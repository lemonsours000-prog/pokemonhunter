print("GUI Script Loaded")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")


local circleAngle = 0
local circleRadius = 3
local circleSpeed = 10
local circleCenter = nil
local circling = false

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "GrassFarmGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 300)
main.Position = UDim2.new(0.5, -130, 0.5, -70)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 170, 255)
stroke.Thickness = 2
stroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Your Pokémon Hunter!"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = main

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0, 42)
status.BackgroundTransparency = 1
status.Text = "Status: OFF"
status.TextColor3 = Color3.fromRGB(255, 80, 80)
status.Font = Enum.Font.Gotham
status.TextSize = 18
status.Parent = main

local chunkLabel = Instance.new("TextLabel")
chunkLabel.Size = UDim2.new(1, 0, 0, 20)
chunkLabel.Position = UDim2.new(0, 0, 0, 70)
chunkLabel.BackgroundTransparency = 1
chunkLabel.Text = "Chunk: none"
chunkLabel.TextColor3 = Color3.fromRGB(180,180,180)
chunkLabel.Font = Enum.Font.Gotham
chunkLabel.TextSize = 14
chunkLabel.Parent = main

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0.8, 0, 0, 40)
toggle.Position = UDim2.new(0.1, 0, 1, -50)
toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggle.Text = "ENABLE"
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 20
toggle.Parent = main

Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 12)

--------------------------------------------------
-- HELP BUTTON
--------------------------------------------------

local helpButton = Instance.new("TextButton")
helpButton.Size = UDim2.new(0, 30, 0, 30)
helpButton.Position = UDim2.new(1, -35, 0, 40)
helpButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
helpButton.Text = "?"
helpButton.TextColor3 = Color3.fromRGB(255,255,255)
helpButton.Font = Enum.Font.GothamBold
helpButton.TextSize = 18
helpButton.Parent = main

Instance.new("UICorner", helpButton).CornerRadius = UDim.new(0,8)

--------------------------------------------------
-- HELP PAGE
--------------------------------------------------

local helpFrame = Instance.new("Frame")
helpFrame.Size = UDim2.new(0, 300, 0, 500)
helpFrame.Position = UDim2.new(1, 10, 0, 0) -- right of main GUI
helpFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
helpFrame.BorderSizePixel = 0
helpFrame.Visible = false
helpFrame.Parent = main

Instance.new("UICorner", helpFrame).CornerRadius = UDim.new(0,16)

local helpStroke = Instance.new("UIStroke")
helpStroke.Color = Color3.fromRGB(0,170,255)
helpStroke.Thickness = 2
helpStroke.Parent = helpFrame

local helpTitle = Instance.new("TextLabel")
helpTitle.Size = UDim2.new(1,0,0,40)
helpTitle.BackgroundTransparency = 1
helpTitle.Text = "Help"
helpTitle.TextColor3 = Color3.new(1,1,1)
helpTitle.Font = Enum.Font.GothamBold
helpTitle.TextSize = 22
helpTitle.Parent = helpFrame

local helpText = Instance.new("TextLabel")
helpText.Size = UDim2.new(1,-20,1,-90)
helpText.Position = UDim2.new(0,10,0,45)
helpText.BackgroundTransparency = 1
helpText.TextColor3 = Color3.fromRGB(220,220,220)
helpText.Font = Enum.Font.Gotham
helpText.TextSize = 16
helpText.TextWrapped = true
helpText.TextYAlignment = Enum.TextYAlignment.Top

helpText.Text = [[
Welcome to Your Pokémon Hunter!

ENABLE
- This teleports you to grass repeatidly until you find a pokemon!

SPHERE HUNT
- Safer way to hunt but a tiny bit slower, best way to stay undetected!

SHINY CHECK
- Turn this on if your looking for shinies!

LEGENDARY CHECK
- Turn this on if your looking for legendaries!

My extra info
 - If you paid for this script you have been SCAMMED as this is a free to use universal hunter for all pokemon brickbronze copies

AUTOCLICKER IS RECOMMENDED

Made by StarsInGreen
]]

helpText.Parent = helpFrame

local closeHelp = Instance.new("TextButton")
closeHelp.Size = UDim2.new(0,80,0,30)
closeHelp.Position = UDim2.new(0.5,-40,1,-40)
closeHelp.BackgroundColor3 = Color3.fromRGB(35,35,35)
closeHelp.Text = "Close"
closeHelp.TextColor3 = Color3.new(1,1,1)
closeHelp.Font = Enum.Font.GothamBold
closeHelp.TextSize = 14
closeHelp.Parent = helpFrame

Instance.new("UICorner", closeHelp).CornerRadius = UDim.new(0,8)

helpButton.MouseButton1Click:Connect(function()
	helpFrame.Visible = true
end)

closeHelp.MouseButton1Click:Connect(function()
	helpFrame.Visible = false
end)

--------------------------------------------------
-- MOBILE + PC DRAGGING
--------------------------------------------------

local UserInputService = game:GetService("UserInputService")

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart

	main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

--------------------------------------------------
-- TOGGLE
--------------------------------------------------

local enabled = false
local miscEnabled = false
local shinyCheckEnabled = true
local legendaryCheckEnabled = true
local shinyToggle
local legendaryToggle

local function updateButton()
	if enabled then
		toggle.Text = "DISABLE"
		status.Text = "Status: ON"
		status.TextColor3 = Color3.fromRGB(0,255,120)

		TweenService:Create(
			toggle,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(0,170,100)}
		):Play()
	else
		toggle.Text = "ENABLE"
		status.Text = "Status: OFF"
		status.TextColor3 = Color3.fromRGB(255,80,80)

		TweenService:Create(
			toggle,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(35,35,35)}
		):Play()
	end
end

toggle.MouseButton1Click:Connect(function()
	enabled = not enabled
	updateButton()
end)

local function updateShinyButton()
	if shinyCheckEnabled then
		shinyToggle.Text = "SHINY CHECK: ON"

		TweenService:Create(
			shinyToggle,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(180,120,0)}
		):Play()
	else
		shinyToggle.Text = "SHINY CHECK: OFF"

		TweenService:Create(
			shinyToggle,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(35,35,35)}
		):Play()
	end
end

local function updateLegendaryButton()
	if legendaryCheckEnabled then
		legendaryToggle.Text = "LEGENDARY CHECK: ON"

		TweenService:Create(
			legendaryToggle,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(180,0,120)}
		):Play()
	else
		legendaryToggle.Text = "LEGENDARY CHECK: OFF"

		TweenService:Create(
			legendaryToggle,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(35,35,35)}
		):Play()
	end
end


--------------------------------------------------
-- AUTO FIND ACTIVE CHUNK
--------------------------------------------------

local grassFolder = nil
local currentChunk = nil

local function findActiveChunk()

	grassFolder = nil

	--------------------------------------------------
	-- PRIORITIZE MISC GRASS
	--------------------------------------------------

	if miscEnabled then
		local chunk15 = workspace:FindFirstChild("chunk15")

		if chunk15 then
			local miscFolder = chunk15:FindFirstChild("MiscGrass")

if miscFolder and #miscFolder:GetChildren() > 0 then
	currentChunk = chunk15
	grassFolder = miscFolder

	chunkLabel.Text = "Chunk: chunk15 (Misc)"

	return
end
		end
	end


--------------------------------------------------
-- MOBILE CHUNK GRASS
--------------------------------------------------

for _, obj in ipairs(workspace:GetChildren()) do
	if obj.Name:match("^chunk%d+$") then

		local mgrass = obj:FindFirstChild("MGrass")

		if mgrass then

			local grass = mgrass:FindFirstChild("Grass")

			if grass and #grass:GetChildren() > 0 then
				currentChunk = obj
				grassFolder = grass

				chunkLabel.Text = "Chunk: " .. obj.Name .. " (Mobile)"
				return
			end

			if #mgrass:GetChildren() > 0 then
				currentChunk = obj
				grassFolder = mgrass

				chunkLabel.Text = "Chunk: " .. obj.Name .. " (Mobile)"
				return
			end
		end
	end
end

--------------------------------------------------
-- NORMAL CHUNK SEARCH
--------------------------------------------------

if not miscEnabled then
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj.Name:match("^chunk%d+$") then

			local grass = obj:FindFirstChild("Grass")

			if grass and #grass:GetChildren() > 0 then
				currentChunk = obj
				grassFolder = grass

				chunkLabel.Text = "Chunk: " .. obj.Name

				return
			end
		end
	end
end
end
--------------------------------------------------
-- REFRESH ACTIVE CHUNK
--------------------------------------------------

task.spawn(function()
	while true do
		findActiveChunk()
		task.wait(1)
	end
end)

findActiveChunk()


--------------------------------------------------
-- RUN BUTTON HIDER
--------------------------------------------------

local areas = {
    "BeachDay",
    "BeachNight",
    "Forest1",
    "FlowersDay",
    "FlowersNight",
    "CragonosMines",
    "RouteDay",
    "RouteNight",
    "Rt14Ruins",
    "SnowDay",
    "SnowNight",
    "SafariNight",
    "SafariDay",
    "LavaCave",
    "Graveyard",
    "artback"
}

local EXPECTED_MUSIC_ID = "16553839613"

task.spawn(function()
	while true do
		local shouldHide = false

		--------------------------------------------------
		-- SHINY CHECK (Aura)
		--------------------------------------------------

		if shinyCheckEnabled then
			for _, areaName in ipairs(areas) do
				local area = workspace:FindFirstChild(areaName)

				if area then
					local aura = area:FindFirstChild("Aura", true)

					if aura and aura:IsA("ParticleEmitter") and aura.Enabled then
						shouldHide = true
						break
					end
				end
			end
		end

		--------------------------------------------------
		-- LEGENDARY CHECK (Music)
		--------------------------------------------------

		if legendaryCheckEnabled then
			local soundContainer = playerGui:FindFirstChild("SoundContainer")
			local battleMusic = soundContainer and soundContainer:FindFirstChild("BattleMusic")

			if battleMusic and battleMusic:IsA("Sound") then
				local currentId = battleMusic.SoundId:match("%d+")

				if currentId ~= EXPECTED_MUSIC_ID then
					shouldHide = true
				end
			else
				shouldHide = true
			end
		end

		--------------------------------------------------
		-- Run button visibility
		--------------------------------------------------

		local mainGui = playerGui:FindFirstChild("MainGui")

		if mainGui then
			local battleGui = mainGui:FindFirstChild("BattleGui", true)

			if battleGui then
				local runButton = battleGui:FindFirstChild("Run", true)

				if runButton then
					runButton.Visible = not shouldHide
				end
			end
		end

		task.wait(0.1)
	end
end)




--------------------------------------------------
-- GRASS TELEPORTER / CIRCLE FALLBACK
--------------------------------------------------


RunService.Heartbeat:Connect(function(dt)
    if not enabled then
        circleCenter = nil
        circling = false
        return
    end

    -- NO GRASS FOUND: CIRCLE A FIXED POSITION
    if not grassFolder or #grassFolder:GetChildren() == 0 then
        circling = true

        -- Save the centre only once
        if not circleCenter then
            circleCenter = hrp.Position
            circleAngle = 0
        end

        circleAngle = circleAngle + circleSpeed * dt

        local offset = Vector3.new(
            math.cos(circleAngle) * circleRadius,
            0,
            math.sin(circleAngle) * circleRadius
        )

        -- Always calculate the position from the fixed centre
        local targetPosition = circleCenter + offset
        hrp.CFrame = CFrame.new(targetPosition)

        return
    end

    -- GRASS FOUND: STOP CIRCLE MODE
    circling = false
    circleCenter = nil

    local grasses = {}

    for _, obj in ipairs(grassFolder:GetChildren()) do
        local pos

        if obj:IsA("BasePart") then
            pos = obj.Position

        elseif obj:IsA("Model") then
            if obj.PrimaryPart then
                pos = obj.PrimaryPart.Position
            else
                local part = obj:FindFirstChildWhichIsA("BasePart")

                if part then
                    pos = part.Position
                end
            end
        end

        if pos then
            table.insert(grasses, {
                object = obj,
                position = pos,
                distance = (hrp.Position - pos).Magnitude
            })
        end
    end

    table.sort(grasses, function(a, b)
        return a.distance < b.distance
    end)

    for i = 1, math.min(4, #grasses) do
        if not enabled then
            break
        end

        local target = grasses[i]
        hrp.CFrame = CFrame.new(
            target.position + Vector3.new(0, 3, 0)
        )

        task.wait(0.02)
    end
end)

--------------------------------------------------
-- MISC GRASS BUTTON
--------------------------------------------------


local miscToggle = Instance.new("TextButton")
miscToggle.Size = UDim2.new(0.8, 0, 0, 32)
miscToggle.Position = UDim2.new(0.1, 0, 1, -88)
miscToggle.BackgroundColor3 = Color3.fromRGB(35,35,35)
miscToggle.Text = "Sphere Hunt: OFF"
miscToggle.TextColor3 = Color3.fromRGB(255,255,255)
miscToggle.Font = Enum.Font.GothamBold
miscToggle.TextSize = 14
miscToggle.Parent = main

Instance.new("UICorner", miscToggle).CornerRadius = UDim.new(0,10)

local function updateMiscButton()
	if miscEnabled then
		miscToggle.Text = "Sphere Hunt: ON"

		TweenService:Create(
			miscToggle,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(0,150,150)}
		):Play()
	else
		miscToggle.Text = "Sphere Hunt: OFF"

		TweenService:Create(
			miscToggle,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(35,35,35)}
		):Play()
	end
end

miscToggle.MouseButton1Click:Connect(function()
	miscEnabled = not miscEnabled

	findActiveChunk()
	updateMiscButton()
end)

--------------------------------------------------
-- SHINY CHECK BUTTON
--------------------------------------------------

shinyToggle = Instance.new("TextButton")
shinyToggle.Size = UDim2.new(0.8, 0, 0, 28)
shinyToggle.Position = UDim2.new(0.1, 0, 1, -122)
shinyToggle.BackgroundColor3 = Color3.fromRGB(35,35,35)
shinyToggle.TextColor3 = Color3.fromRGB(255,255,255)
shinyToggle.Font = Enum.Font.GothamBold
shinyToggle.TextSize = 14
shinyToggle.Parent = main

Instance.new("UICorner", shinyToggle).CornerRadius = UDim.new(0,10)

--------------------------------------------------
-- LEGENDARY CHECK BUTTON
--------------------------------------------------

legendaryToggle = Instance.new("TextButton")
legendaryToggle.Size = UDim2.new(0.8, 0, 0, 28)
legendaryToggle.Position = UDim2.new(0.1, 0, 1, -156)
legendaryToggle.BackgroundColor3 = Color3.fromRGB(35,35,35)
legendaryToggle.TextColor3 = Color3.fromRGB(255,255,255)
legendaryToggle.Font = Enum.Font.GothamBold
legendaryToggle.TextSize = 14
legendaryToggle.Parent = main

Instance.new("UICorner", legendaryToggle).CornerRadius = UDim.new(0,10)

shinyToggle.MouseButton1Click:Connect(function()
	shinyCheckEnabled = not shinyCheckEnabled
	updateShinyButton()
end)

legendaryToggle.MouseButton1Click:Connect(function()
	legendaryCheckEnabled = not legendaryCheckEnabled
	updateLegendaryButton()
end)


--------------------------------------------------
-- MINT BUSH BUTTON
--------------------------------------------------

local mintButton = Instance.new("TextButton")
mintButton.Size = UDim2.new(0.8, 0, 0, 28)
mintButton.Position = UDim2.new(0.1, 0, 1, -190)
mintButton.BackgroundColor3 = Color3.fromRGB(35, 120, 35)
mintButton.Text = "Find Mint Bush"
mintButton.TextColor3 = Color3.fromRGB(255,255,255)
mintButton.Font = Enum.Font.GothamBold
mintButton.TextSize = 14
mintButton.Parent = main

Instance.new("UICorner", mintButton).CornerRadius = UDim.new(0,10)

mintButton.MouseButton1Click:Connect(function()
	for _, chunk in ipairs(workspace:GetChildren()) do
		local mintBush = chunk:FindFirstChild("MintBush")

		if mintBush then
			local mainPart = mintBush:FindFirstChild("Main")

			if mainPart then
				local emitter = mainPart:FindFirstChild("ParticleEmitter")

				if emitter and emitter.Enabled then
					hrp.CFrame = mainPart.CFrame + Vector3.new(0, 3, 0)
					return
				end
			end
		end
	end

	warn("No active MintBush found.")
end)


updateShinyButton()
updateLegendaryButton()


updateMiscButton()

updateButton()

