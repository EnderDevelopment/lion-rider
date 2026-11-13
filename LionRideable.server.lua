local Players = game:GetService("Players")

local LION_NAME = "RideableLion"
local SPAWN_POSITION = Vector3.new(0, 0, 0)

local COLORS = {
	Body = BrickColor.new("Bright orange"),
	Mane = BrickColor.new("Reddish brown"),
	Face = BrickColor.new("Nougat"),
	Nose = BrickColor.new("Really black"),
	Eyes = BrickColor.new("New Yeller"),
	Paws = BrickColor.new("Dark orange"),
}

local existingLion = workspace:FindFirstChild(LION_NAME)
if existingLion then
	existingLion:Destroy()
end

local lion = Instance.new("Model")
lion.Name = LION_NAME
lion.Parent = workspace

local function createBlock(name, size, position, color, parent)
	local block = Instance.new("Part")
	block.Name = name
	block.Size = size
	block.Position = SPAWN_POSITION + position
	block.BrickColor = color
	block.Material = Enum.Material.SmoothPlastic
	block.TopSurface = Enum.SurfaceType.Smooth
	block.BottomSurface = Enum.SurfaceType.Smooth
	block.Anchored = false
	block.CanCollide = true
	block.Parent = parent
	return block
end

local function weldToRoot(block, root)
	local weld = Instance.new("WeldConstraint")
	weld.Name = "LionBlockWeld"
	weld.Part0 = root
	weld.Part1 = block
	weld.Parent = root
end

local root = createBlock("LionBody", Vector3.new(6, 3.5, 9), Vector3.new(0, 6.25, 0), COLORS.Body, lion)
lion.PrimaryPart = root

local bodyBlocks = {
	{"Chest", Vector3.new(6.2, 3.7, 2.2), Vector3.new(0, 6.35, 3.4), COLORS.Body},
	{"Hindquarters", Vector3.new(6.2, 3.7, 2.2), Vector3.new(0, 6.35, -3.4), COLORS.Body},
	{"Neck", Vector3.new(4.2, 4.4, 3.2), Vector3.new(0, 7.1, 3.9), COLORS.Mane},
	{"Head", Vector3.new(4.6, 4.2, 4.3), Vector3.new(0, 8.65, 5.45), COLORS.Mane},
	{"Face", Vector3.new(3.4, 2.7, 2.2), Vector3.new(0, 8.15, 7.65), COLORS.Face},
	{"Muzzle", Vector3.new(2.4, 1.5, 1.3), Vector3.new(0, 7.75, 8.8), COLORS.Face},
	{"Nose", Vector3.new(1.1, 0.7, 0.45), Vector3.new(0, 8.05, 9.5), COLORS.Nose},
	{"LeftEar", Vector3.new(1.3, 1.4, 1.3), Vector3.new(-1.65, 10.75, 4.8), COLORS.Mane},
	{"RightEar", Vector3.new(1.3, 1.4, 1.3), Vector3.new(1.65, 10.75, 4.8), COLORS.Mane},
	{"LeftEye", Vector3.new(0.55, 0.55, 0.3), Vector3.new(-1.05, 8.85, 7.6), COLORS.Eyes},
	{"RightEye", Vector3.new(0.55, 0.55, 0.3), Vector3.new(1.05, 8.85, 7.6), COLORS.Eyes},
}

for _, blockInfo in ipairs(bodyBlocks) do
	local block = createBlock(blockInfo[1], blockInfo[2], blockInfo[3], blockInfo[4], lion)
	weldToRoot(block, root)
end

local legData = {
	{"FrontLeftLeg", Vector3.new(-2.05, 3.2, 3.0)},
	{"FrontRightLeg", Vector3.new(2.05, 3.2, 3.0)},
	{"BackLeftLeg", Vector3.new(-2.05, 3.2, -3.0)},
	{"BackRightLeg", Vector3.new(2.05, 3.2, -3.0)},
}

for _, legInfo in ipairs(legData) do
	local leg = createBlock(legInfo[1], Vector3.new(1.6, 4.8, 1.6), legInfo[2], COLORS.Body, lion)
	weldToRoot(leg, root)
	local paw = createBlock(legInfo[1] .. "Paw", Vector3.new(2.1, 0.9, 2.1), legInfo[2] + Vector3.new(0, -2.35, 0), COLORS.Paws, lion)
	weldToRoot(paw, root)
end

local tailSegments = {
	{"TailBase", Vector3.new(0, 6.4, -5.2), Vector3.new(2.1, 2.1, 2.8)},
	{"TailMiddle", Vector3.new(0, 8.0, -7.3), Vector3.new(1.7, 1.7, 2.4)},
	{"TailTip", Vector3.new(0, 9.6, -8.9), Vector3.new(2.3, 2.3, 1.8)},
}

for _, segmentInfo in ipairs(tailSegments) do
	local segment = createBlock(segmentInfo[1], segmentInfo[3], segmentInfo[2], COLORS.Mane, lion)
	weldToRoot(segment, root)
end

local seat = Instance.new("Seat")
seat.Name = "LionSeat"
seat.Size = Vector3.new(2.8, 1, 2.8)
seat.Position = SPAWN_POSITION + Vector3.new(0, 8.65, -0.8)
seat.BrickColor = COLORS.Body
seat.Material = Enum.Material.SmoothPlastic
seat.Anchored = false
seat.CanCollide = true
seat.MaxSpeed = 35
seat.Parent = lion
weldToRoot(seat, root)

local prompt = Instance.new("ProximityPrompt")
prompt.Name = "RidePrompt"
prompt.ActionText = "Ride Lion"
prompt.ObjectText = "Lion"
prompt.KeyboardKeyCode = Enum.KeyCode.E
prompt.HoldDuration = 0
prompt.MaxActivationDistance = 12
prompt.RequiresLineOfSight = false
prompt.Parent = seat

prompt.Triggered:Connect(function(player)
	local character = player.Character
	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end

	if seat.Occupant and seat.Occupant ~= humanoid then
		return
	end

	seat:Sit(humanoid)
end)

local function setNetworkOwner(player)
	if root and root.Parent then
		root:SetNetworkOwner(player)
	end
end

seat:GetPropertyChangedSignal("Occupant"):Connect(function()
	local occupant = seat.Occupant
	if occupant then
		local player = Players:GetPlayerFromCharacter(occupant.Parent)
		if player then
			setNetworkOwner(player)
		end
	else
		root:SetNetworkOwner(nil)
	end
end)

root:SetNetworkOwner(nil)
