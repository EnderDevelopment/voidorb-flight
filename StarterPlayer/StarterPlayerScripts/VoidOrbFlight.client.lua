-- StarterPlayer/StarterPlayerScripts/VoidOrbFlight.client.lua
-- Press F to fly to the nearest VoidOrb.

local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local REMOTE_NAME = "RequestVoidOrbFlight"
local ACTION_NAME = "FlyToNearestVoidOrb"
local remote = ReplicatedStorage:WaitForChild(REMOTE_NAME)

local function requestFlight(_actionName: string, inputState: Enum.UserInputState)
	if inputState == Enum.UserInputState.Begin then
		remote:FireServer()
	end
	return Enum.ContextActionResult.Sink
end

ContextActionService:BindAction(ACTION_NAME, requestFlight, true, Enum.KeyCode.F)
ContextActionService:SetTitle(ACTION_NAME, "Fly to Orb")
ContextActionService:SetPosition(ACTION_NAME, UDim2.fromScale(0.82, 0.72))
