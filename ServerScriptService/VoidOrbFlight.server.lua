-- ServerScriptService/VoidOrbFlight.server.lua
-- Moves a player from the ground to the nearest Workspace.VoidOrbs/VoidOrb model.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local ORB_FOLDER_NAME = "VoidOrbs"
local ORB_MODEL_NAME = "VoidOrb"
local REMOTE_NAME = "RequestVoidOrbFlight"
local FLIGHT_TIME = 2.25
local COOLDOWN = 3
local ARRIVAL_HEIGHT = 5
local MAX_TARGET_DISTANCE = 10000

local remote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = REMOTE_NAME
	remote.Parent = ReplicatedStorage
end

local lastFlightAt: {[Player]: number} = {}
local activeFlight: {[Player]: boolean} = {}

local function getOrbFolder(): Instance?
	return workspace:FindFirstChild(ORB_FOLDER_NAME)
end

local function getOrbPosition(orb: Model): Vector3?
	if not orb:IsA("Model") then
		return nil
	end

	local ok, pivot = pcall(function()
		return orb:GetPivot()
	end)
	if ok then
		return pivot.Position
	end
	return nil
end

local function findNearestOrb(origin: Vector3): Vector3?
	local folder = getOrbFolder()
	if not folder then
		return nil
	end

	local nearestPosition: Vector3? = nil
	local nearestDistance = MAX_TARGET_DISTANCE
	for _, instance in ipairs(folder:GetDescendants()) do
		if instance:IsA("Model") and instance.Name == ORB_MODEL_NAME then
			local position = getOrbPosition(instance)
			if position then
				local distance = (position - origin).Magnitude
				if distance < nearestDistance then
					nearestDistance = distance
					nearestPosition = position
				end
			end
		end
	end
	return nearestPosition
end

local function restoreCharacter(character: Model, humanoid: Humanoid, root: BasePart, oldAutoRotate: boolean)
	if root.Parent then
		root.Anchored = false
	end
	if humanoid.Parent then
		humanoid.AutoRotate = oldAutoRotate
		humanoid.PlatformStand = false
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
	local player = Players:GetPlayerFromCharacter(character)
	if player then
		activeFlight[player] = nil
	end
end

local function flyPlayer(player: Player)
	if activeFlight[player] then
		return
	end

	local now = os.clock()
	if now - (lastFlightAt[player] or 0) < COOLDOWN then
		return
	end

	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not character or not humanoid or not root or humanoid.Health <= 0 then
		return
	end

	local targetPosition = findNearestOrb(root.Position)
	if not targetPosition then
		return
	end

	lastFlightAt[player] = now
	activeFlight[player] = true
	local oldAutoRotate = humanoid.AutoRotate
	humanoid.AutoRotate = false
	humanoid.PlatformStand = true
	root.Anchored = true

	local destination = targetPosition + Vector3.new(0, ARRIVAL_HEIGHT, 0)
	local tween = TweenService:Create(
		root,
		TweenInfo.new(FLIGHT_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
		{CFrame = CFrame.new(destination)}
	)

	local connection
	connection = tween.Completed:Connect(function()
		connection:Disconnect()
		if character.Parent and humanoid.Health > 0 then
			restoreCharacter(character, humanoid, root, oldAutoRotate)
		else
			activeFlight[player] = nil
		end
	end)
	tween:Play()
end

remote.OnServerEvent:Connect(function(player)
	flyPlayer(player)
end)

Players.PlayerRemoving:Connect(function(player)
	lastFlightAt[player] = nil
	activeFlight[player] = nil
end)
