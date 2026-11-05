# Roblox Script: VoidOrb Flight

VoidOrb Flight is a Roblox script that lets players fly from their current character position to the nearest `VoidOrb` model stored inside a `Workspace.VoidOrbs` folder, with server-side targeting, movement, cooldown protection, and keyboard or mobile controls.

## Install

1. In Roblox Studio, create a folder named `VoidOrbs` directly inside `Workspace`.
2. Place each orb model inside the folder, including nested folders if needed. Every target model must be named `VoidOrb`.
3. Add `VoidOrbFlight.server.lua` as a normal `Script` inside `ServerScriptService`.
4. Add `VoidOrbFlight.client.lua` as a `LocalScript` inside `StarterPlayer > StarterPlayerScripts`.
5. Start a play test.

The server script automatically creates the required `RequestVoidOrbFlight` `RemoteEvent` in `ReplicatedStorage`.

## Use

1. Move the player to the desired starting position.
2. Press `F` on keyboard, or use the generated `Fly to Orb` mobile button.
3. The server finds the nearest descendant model named `VoidOrb` inside `Workspace.VoidOrbs`.
4. The character is moved to a position five studs above the selected orb over 2.25 seconds.
5. The character is restored after arrival.
6. Wait three seconds before requesting another flight.

The script searches for orb models up to 10,000 studs away. If the folder uses a different location or name, update `ORB_FOLDER_NAME` and the `getOrbFolder` function in the server script.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/551bd9d8-82c4-4766-a447-416a1a73fed7?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=551bd9d8-82c4-4766-a447-416a1a73fed7
