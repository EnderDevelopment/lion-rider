# Roblox Rideable Lion Script

LionRider is a Roblox script that creates a rideable lion model from unanchored blocks. This Roblox script uses welded physical parts to form the lion's body, mane, face, legs, paws, tail, and seat, then lets players ride it by pressing E near the lion.

## Install

1. Open your Roblox place in Roblox Studio.
2. In the Explorer panel, open ServerScriptService.
3. Insert a new Script.
4. Copy the contents of `LionRideable.server.lua` into the Script.
5. Press Play to test the place.
6. The script spawns the lion in Workspace at position `(0, 0, 0)`.

The script creates a model named `RideableLion`. If a model with that name already exists, the old model is removed before a new one is created.

## Use

1. Walk near the seat on the lion's back.
2. Wait for the `Ride Lion` ProximityPrompt to appear.
3. Press E to sit on the lion.
4. Use Roblox's normal seat controls to move the rideable lion.
5. Leave the seat to stop riding.

To customize the lion, edit the constants near the top of the script. You can change its name, spawn position, and block colors. The model's body parts, legs, paws, tail segments, and seat are unanchored and connected with WeldConstraints so they move together as one physical assembly.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/1a8fe6d0-038d-4977-8c79-ab38bc580176?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=1a8fe6d0-038d-4977-8c79-ab38bc580176
