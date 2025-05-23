-- Roblox Basic Black Conditional Menu Script
-- Place this LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService") -- Needed for menu toggle keybind
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService") -- Needed for loop timing

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui") -- Wait for PlayerGui to be ready

-- Target Universe IDs
local bubbleGumUniverseId = 6504986360
local fischUniverseId = 5750914919

-- Get the current game's Universe ID
local currentUniverseId = game.GameId

-- == GUI Variables ==
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BasicScriptLoader" -- Default name, will be changed
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 1
local mainFrame = nil -- Holds the main UI frame if created

-- == Game Specific Variables ==
-- BubbleGum
local isAutoBubbling = false
local autoBubbleCoroutine = nil
local bubbleEvent = nil -- Still needed for AutoBubble
local autoBubbleButton = nil
local teleportDropdownFrame = nil -- Frame for teleport options
local teleportButton = nil -- Main teleport button
local copyPosButton = nil -- Button to get position
local posTextBox = nil -- TextBox to display position
-- Fisch
local isReeling = false
local reelCoroutine = nil
local reelEvent = nil
local instantReelButton = nil
local teleportDropdownFrame = nil -- Existing location teleport frame -- V--- Added these ---V
local teleportButton = nil -- Existing location teleport button
local copyPosButton = nil -- Existing copy position button
local posTextBox = nil -- Existing position textbox
local playerTeleportButton = nil -- ADDED: Button for player teleport
local playerTeleportDropdownFrame = nil -- ADDED: Dropdown for player list -- ^--- Added these ---^

-- == GUI Creation Functions (Basic Black Theme) ==

-- Function to create a very basic black menu frame
local function createBasicMenuFrame(guiName)
	local frame = Instance.new("Frame")
	frame.Name = "MainFrame"
	-- Increased height further for new elements
	frame.Size = UDim2.new(0, 250, 0, 400)
	frame.Position = UDim2.new(0.1, 0, 0.1, 0) -- Position top-left-ish
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Pure Black background
	frame.BorderColor3 = Color3.fromRGB(50, 50, 50) -- Dark grey border
	frame.BorderSizePixel = 1
	frame.Active = true -- Allows dragging
	frame.Draggable = true
	frame.Visible = false -- Start hidden
	frame.Parent = screenGui

	-- Basic Title Label
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"; titleLabel.Size = UDim2.new(1, 0, 0, 20)
	titleLabel.Position = UDim2.new(0, 0, 0, 0); titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	titleLabel.BorderSizePixel = 0
	titleLabel.TextColor3 = Color3.fromRGB(200, 200, 200); titleLabel.Font = Enum.Font.SourceSansSemibold
	titleLabel.Text = guiName; titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center; titleLabel.Parent = frame

	-- Basic Button Container (ScrollingFrame)
	local buttonContainer = Instance.new("ScrollingFrame")
	buttonContainer.Name = "ButtonContainer"; buttonContainer.Size = UDim2.new(1, -10, 1, -25) -- Fill below title
	buttonContainer.Position = UDim2.new(0, 5, 0, 25); buttonContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Match frame background
	buttonContainer.BorderSizePixel = 0
	buttonContainer.CanvasSize = UDim2.new(0,0,0,0) -- Start small, will expand
	buttonContainer.ScrollBarThickness = 4
	buttonContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80) -- Grey scrollbar
	buttonContainer.Parent = frame

	-- Basic UIListLayout for main buttons
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 5); listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; listLayout.Parent = buttonContainer

	return frame, buttonContainer
end

-- Function to set up the menu toggle keybind (Insert key)
local function setupMenuToggle(frame)
	local function toggleMenu()
		if frame then frame.Visible = not frame.Visible; print("Menu visibility toggled:", frame.Visible) end
	end
	UserInputService.InputBegan:Connect(function(input, gp) if gp then return end; if input.KeyCode == Enum.KeyCode.Insert then toggleMenu() end end)
end

-- Function to create a very basic toggle button (for AutoBubble/InstantReel/Teleport Dropdown)
local function createBasicToggleButton(name, textOff, textOn, order, parent, clickFunc)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(0.9, 0, 0, 25) -- Basic button size
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Dark Grey OFF color
	button.BorderColor3 = Color3.fromRGB(100, 100, 100) -- Lighter Grey border
	button.BorderSizePixel = 1
	button.TextColor3 = Color3.fromRGB(200, 200, 200) -- Light Grey text
	button.Font = Enum.Font.SourceSans
	button.TextSize = 14
	button.Text = textOff
	button.LayoutOrder = order
	button.Parent = parent
	button.MouseButton1Click:Connect(clickFunc)
	return button
end

-- Function to create a basic action button (for Teleport locations and Copy Pos)
local function createBasicActionButton(name, text, order, parent, clickFunc)
	local button = Instance.new("TextButton")
	button.Name = name
	-- Adjusted size slightly for consistency
	button.Size = UDim2.new(0.9, 0, 0, 25)
	button.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Slightly lighter grey for action buttons
	button.BorderColor3 = Color3.fromRGB(100, 100, 100)
	button.BorderSizePixel = 1
	button.TextColor3 = Color3.fromRGB(200, 200, 200)
	button.Font = Enum.Font.SourceSans
	button.TextSize = 14
	button.Text = text
	button.LayoutOrder = order
	button.Parent = parent
	button.MouseButton1Click:Connect(clickFunc)
	return button
end

-- Function to create a basic text box
local function createBasicTextBox(name, placeholder, order, parent)
	local textBox = Instance.new("TextBox")
	textBox.Name = name
	textBox.Size = UDim2.new(0.9, 0, 0, 25)
	textBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Dark background
	textBox.BorderColor3 = Color3.fromRGB(100, 100, 100)
	textBox.BorderSizePixel = 1
	textBox.TextColor3 = Color3.fromRGB(220, 220, 220) -- Lighter text for readability
	textBox.PlaceholderText = placeholder
	textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
	textBox.Text = ""
	textBox.Font = Enum.Font.SourceSans
	textBox.TextSize = 12
	textBox.ClearTextOnFocus = false -- Keep text when clicked
	textBox.TextXAlignment = Enum.TextXAlignment.Left
	textBox.LayoutOrder = order
	textBox.Visible = true -- Make it always visible below the button
	textBox.Parent = parent
	return textBox
end


-- == Main Logic: Check Universe ID and Configure GUI ==

print("Checking Universe ID:", currentUniverseId)

if currentUniverseId == bubbleGumUniverseId then
	-- == BubbleGum Infinity Script Configuration ==
	print("Universe ID matches BubbleGum. Configuring 'BubbleGum Infinity Script' GUI.")
	screenGui.Name = "BubbleGum Infinity Script"
	local buttonContainer
	mainFrame, buttonContainer = createBasicMenuFrame(screenGui.Name) -- Create the base UI

	-- Dynamically adjust CanvasSize of main ButtonContainer
	local mainListLayout = buttonContainer:FindFirstChildOfClass("UIListLayout")
	local function updateMainCanvasSize()
		local contentHeight = mainListLayout.AbsoluteContentSize.Y
		buttonContainer.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
	end
	buttonContainer.ChildAdded:Connect(updateMainCanvasSize)
	buttonContainer.ChildRemoved:Connect(updateMainCanvasSize)

	-- Find BubbleGum RemoteEvent (Still needed for AutoBubble)
	local remoteEventPath = ReplicatedStorage:FindFirstChild("Shared", true)
	if remoteEventPath then remoteEventPath = remoteEventPath:FindFirstChild("Framework", true) end
	if remoteEventPath then remoteEventPath = remoteEventPath:FindFirstChild("Network", true) end
	if remoteEventPath then remoteEventPath = remoteEventPath:FindFirstChild("Remote", true) end
	if remoteEventPath then remoteEventPath = remoteEventPath:FindFirstChild("Event") end
	bubbleEvent = remoteEventPath
	if not bubbleEvent or not bubbleEvent:IsA("RemoteEvent") then warn(screenGui.Name .. ": Could not find BubbleGum RemoteEvent for AutoBubble") end

	-- AutoBubble Loop
	local function autoBubbleLoop()
		print("AutoBubble loop started.")
		while isAutoBubbling and bubbleEvent do
			local success, err = pcall(function() bubbleEvent:FireServer("BlowBubble") end)
			if not success then warn("Error firing Bubble Event:", err); isAutoBubbling = false; break end
			task.wait(0.1)
		end
		print("AutoBubble loop stopped."); autoBubbleCoroutine = nil;
		if autoBubbleButton then -- Update button appearance after loop stops
			autoBubbleButton.Text = "AutoBubble [OFF]"
			autoBubbleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Dark Grey OFF
		end
	end

	-- Create AutoBubble Button (Basic Style)
	autoBubbleButton = createBasicToggleButton("AutoBubbleButton", "AutoBubble [OFF]", "AutoBubble [ON]", 1, buttonContainer, function() -- LayoutOrder 1
		if not bubbleEvent then warn("Cannot toggle AutoBubble: RemoteEvent not found."); return end
		isAutoBubbling = not isAutoBubbling
		if isAutoBubbling then
			autoBubbleButton.Text = "AutoBubble [ON]"; autoBubbleButton.BackgroundColor3 = Color3.fromRGB(80, 120, 80) -- Basic Green ON
			if not autoBubbleCoroutine then autoBubbleCoroutine = task.spawn(autoBubbleLoop) end
		else
			autoBubbleButton.Text = "AutoBubble [OFF]"; autoBubbleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Dark Grey OFF
		end
	end)

	-- Create Teleport Dropdown Elements
	teleportButton = createBasicToggleButton("TeleportButton", "Teleport ▼", "Teleport ▲", 2, buttonContainer, function() end) -- LayoutOrder 2, click handled later

	teleportDropdownFrame = Instance.new("Frame") -- Keep this as a standard Frame for BubbleGum
	teleportDropdownFrame.Name = "TeleportDropdown"
	teleportDropdownFrame.Size = UDim2.new(0.9, 0, 0, 120) -- Size to fit ~5 buttons + padding
	teleportDropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark background for dropdown
	teleportDropdownFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
	teleportDropdownFrame.BorderSizePixel = 1
	teleportDropdownFrame.ClipsDescendants = true
	teleportDropdownFrame.Visible = false -- Start hidden
	teleportDropdownFrame.LayoutOrder = 3 -- Place it after the Teleport button
	teleportDropdownFrame.Parent = buttonContainer

	local dropdownListLayout = Instance.new("UIListLayout")
	dropdownListLayout.Padding = UDim.new(0, 3); dropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	dropdownListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; dropdownListLayout.Parent = teleportDropdownFrame

	-- Teleport Locations and Coordinates
	local teleportLocations = {
		{"Floating Island", Vector3.new(-15.85, 422.76, 143.42)},
		{"Outer Space", Vector3.new(41.50, 2662.87, -6.40)},
		{"Twilight", Vector3.new(-77.94, 6862.18, 88.33)},
		{"The Void", Vector3.new(15.98, 10145.70, 151.72)},
		{"Zen", Vector3.new(36.30, 15971.42, 41.87)}
	}

	-- Teleport Function (Direct CFrame Manipulation)
	local function doTeleport(locationName, targetPosition)
		local char = player.Character
		local rootPart = char and char:FindFirstChild("HumanoidRootPart")

		if rootPart then
			print("Teleporting to:", locationName, "at", targetPosition)
			-- Use CFrame for direct position setting
			rootPart.CFrame = CFrame.new(targetPosition)
			-- Optionally hide dropdown after clicking
			-- teleportDropdownFrame.Visible = false
			-- teleportButton.Text = "Teleport ▼"
		else
			warn("Cannot Teleport: Player character or HumanoidRootPart not found.")
		end
	end

	-- Create buttons for each location
	for i, data in ipairs(teleportLocations) do
		local locName = data[1]
		local locPos = data[2] -- Now a Vector3
		-- Use the action button creator for teleport locations
		local tpLocButton = createBasicActionButton(locName:gsub("%s+", ""), locName, i, teleportDropdownFrame, function() -- Use index for LayoutOrder
			doTeleport(locName, locPos) -- Pass Vector3 position
		end)
		tpLocButton.Size = UDim2.new(1, -10, 0, 20) -- Override size for smaller dropdown buttons
		tpLocButton.TextSize = 12
	end

	-- Add click logic to the main Teleport button to toggle dropdown
	teleportButton.MouseButton1Click:Connect(function()
		teleportDropdownFrame.Visible = not teleportDropdownFrame.Visible
		teleportButton.Text = teleportDropdownFrame.Visible and "Teleport ▲" or "Teleport ▼"
	end)

	-- Create Copy Position Button and TextBox
	copyPosButton = createBasicActionButton("CopyPosButton", "Copy Position", 4, buttonContainer, function() -- LayoutOrder 4
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root and posTextBox then
			local pos = root.Position
			local posString = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z) -- Format to 2 decimal places
			posTextBox.Text = posString
			posTextBox:CaptureFocus() -- Attempt to select the text for easy copying
			print("Position displayed:", posString)
		elseif not root then
			warn("Cannot get position: HumanoidRootPart not found.")
			if posTextBox then posTextBox.Text = "Error: RootPart not found" end
		end
	end)

	posTextBox = createBasicTextBox("PosTextBox", "Click 'Copy Position'", 5, buttonContainer) -- LayoutOrder 5


	-- Setup menu toggle (Insert Key)
	setupMenuToggle(mainFrame)


elseif currentUniverseId == fischUniverseId then
	-- == Fisch Script Configuration ==
	print("Universe ID matches Fisch. Configuring 'Fisch Script' GUI.")
	screenGui.Name = "Fisch Script"
	local buttonContainer
	mainFrame, buttonContainer = createBasicMenuFrame(screenGui.Name) -- Create the base UI

	-- Dynamically adjust CanvasSize of main ButtonContainer
	local mainListLayout = buttonContainer:FindFirstChildOfClass("UIListLayout")
	local function updateMainCanvasSize()
		local contentHeight = mainListLayout.AbsoluteContentSize.Y
		buttonContainer.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
	end
	buttonContainer.ChildAdded:Connect(updateMainCanvasSize)
	buttonContainer.ChildRemoved:Connect(updateMainCanvasSize)


	-- Find Fisch RemoteEvent
	reelEvent = ReplicatedStorage:FindFirstChild("events", true)
	if reelEvent then reelEvent = reelEvent:FindFirstChild("reelfinished ") end
	if not reelEvent or not reelEvent:IsA("RemoteEvent") then warn(screenGui.Name .. ": Could not find Fisch RemoteEvent") end

	-- Instant Reel Loop
	local function instantReelLoop()
		print("Instant Reel loop started.")
		while isReeling and reelEvent do
			local success, err = pcall(function() reelEvent:FireServer(100, true) end)
			if not success then warn("Error firing Reel Event:", err); isReeling = false; break end
			task.wait(2)
		end
		print("Instant Reel loop stopped."); reelCoroutine = nil
		if instantReelButton then -- Update button appearance after loop stops
			instantReelButton.Text = "Instant Reel [OFF]"
			instantReelButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Dark Grey OFF
		end
	end

	-- Create Instant Reel Button (Basic Style)
	instantReelButton = createBasicToggleButton("InstantReelButton", "Instant Reel [OFF]", "Instant Reel [ON]", 1, buttonContainer, function() -- LayoutOrder 1
		if not reelEvent then warn("Cannot toggle Instant Reel: RemoteEvent not found."); return end
		isReeling = not isReeling
		if isReeling then
			instantReelButton.Text = "Instant Reel [ON]"; instantReelButton.BackgroundColor3 = Color3.fromRGB(80, 120, 80) -- Basic Green ON
			if not reelCoroutine then reelCoroutine = task.spawn(instantReelLoop) end
		else
			instantReelButton.Text = "Instant Reel [OFF]"; instantReelButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Dark Grey OFF
		end
	end)

	-- Create Location Teleport Dropdown Elements
	teleportButton = createBasicToggleButton("TeleportButton", "Locations ▼", "Locations ▲", 2, buttonContainer, function() end) -- LayoutOrder 2, click handled later

	teleportDropdownFrame = Instance.new("ScrollingFrame") -- Changed from Frame
	teleportDropdownFrame.Name = "TeleportDropdown"
	teleportDropdownFrame.Size = UDim2.new(0.9, 0, 0, 120) -- Keep original visible size
	teleportDropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 595) -- Added CanvasSize for scrolling content
	teleportDropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark background for dropdown
	teleportDropdownFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
	teleportDropdownFrame.BorderSizePixel = 1
	teleportDropdownFrame.ClipsDescendants = true
	teleportDropdownFrame.Visible = false -- Start hidden
	teleportDropdownFrame.LayoutOrder = 3 -- Place it after the Teleport button
	teleportDropdownFrame.ScrollBarThickness = 4 -- Added Scrollbar property
	teleportDropdownFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80) -- Added Scrollbar property
	teleportDropdownFrame.Parent = buttonContainer

	local dropdownListLayout = Instance.new("UIListLayout")
	dropdownListLayout.Padding = UDim.new(0, 3); dropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	dropdownListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; dropdownListLayout.Parent = teleportDropdownFrame

	-- Teleport Locations and Coordinates (Existing)
	local teleportLocations = { --
		{"Abyssal Zenith", Vector3.new(-13518.85, -11050.19, 116.59)},
		{"Ancient Archives", Vector3.new(-3155.02, -754.82, 2193.12)},
		{"Ancient Isles", Vector3.new(6065.16, 195.18, 301.24)},
		{"Atlantis", Vector3.new(-4265.13, -603.40, 1830.77)},
		{"Brine Pool", Vector3.new(-1795.83, -142.69, -3346.37)},
		{"Calm Zone", Vector3.new(-4341.86, -11173.99, 3713.90)},
		{"Calm Zone Top", Vector3.new(-4304.27, -11161.20, 1612.15)},
		{"Challengers Deep", Vector3.new(751.84, -3352.89, -1578.95)},
		{"Cryogenic Canal", Vector3.new(19834.54, 439.23, 5608.69)},
		{"Desolate Pocket", Vector3.new(-1655.84, -213.68, -2848.12)},
		{"Enchant Altar", Vector3.new(1309.00, -805.29, -99.02)},
		{"Forsaken Shores", Vector3.new(-2494.85, 133.25, 1553.42)},
		{"Grand Reef", Vector3.new(-3565.90, 148.57, 557.34)},
		{"Heavens Rod Gate", Vector3.new(1309.00, -805.29, -99.02)},
		{"Kraken Door", Vector3.new(-4291.88, -848.79, 1748.93)},
		{"Kraken Pool", Vector3.new(-4311.00, -1002.34, 2010.98)},
		{"Merlin", Vector3.new(-947.37, 222.28, -987.83)},
		{"Moosewood", Vector3.new(472.33, 150.94, 255.27)},
		{"North Mountains", Vector3.new(19535.91, 132.67, 5294.26)},
		{"Roslit Bay", Vector3.new(-1472.89, 132.53, 699.50)},
		{"The Depths", Vector3.new(11.46, -706.12, 1230.81)},
		{"Trident Room", Vector3.new(-1484.95, -225.71, -2377.54)},
		{"Veil of The Forsaken", Vector3.new(-2362.25, -11184.60, 7070.17)},
		{"Vertigo", Vector3.new(-102.41, -513.30, 1061.27)},
		{"Volcanic Vents", Vector3.new(-3350.04, -2027.96, 4078.46)},
		{"Volcanic Vents Start", Vector3.new(-3402.08, -2263.01, 3826.46)}
	}

	-- Existing Teleport Function
	local function doTeleport(locationName, targetPosition)
		local char = player.Character
		local rootPart = char and char:FindFirstChild("HumanoidRootPart")

		if rootPart then
			print("Teleporting to:", locationName, "at", targetPosition)
			rootPart.CFrame = CFrame.new(targetPosition)
		else
			warn("Cannot Teleport: Player character or HumanoidRootPart not found.")
		end
	end

	-- Create buttons for each location (Existing)
	for i, data in ipairs(teleportLocations) do
		local locName = data[1]
		local locPos = data[2] -- Now a Vector3
		local tpLocButton = createBasicActionButton(locName:gsub("%s+", ""), locName, i, teleportDropdownFrame, function() -- Use index for LayoutOrder
			doTeleport(locName, locPos) -- Pass Vector3 position
		end)
		tpLocButton.Size = UDim2.new(1, -10, 0, 20) -- Override size for smaller dropdown buttons
		tpLocButton.TextSize = 12
	end

	-- Add click logic to the main Location Teleport button (Existing)
	teleportButton.MouseButton1Click:Connect(function()
		-- ADDED: Hide player teleport dropdown if open
		if playerTeleportDropdownFrame and playerTeleportDropdownFrame.Visible then
			playerTeleportDropdownFrame.Visible = false
			playerTeleportButton.Text = "Player TP ▼"
		end
		teleportDropdownFrame.Visible = not teleportDropdownFrame.Visible
		teleportButton.Text = teleportDropdownFrame.Visible and "Locations ▲" or "Locations ▼"
	end)

	-- Create Copy Position Button and TextBox (Existing)
	copyPosButton = createBasicActionButton("CopyPosButton", "Copy Position", 4, buttonContainer, function() -- LayoutOrder 4
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root and posTextBox then
			local pos = root.Position
			local posString = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z) -- Format to 2 decimal places
			posTextBox.Text = posString
			posTextBox:CaptureFocus() -- Attempt to select the text for easy copying
			print("Position displayed:", posString)
		elseif not root then
			warn("Cannot get position: HumanoidRootPart not found.")
			if posTextBox then posTextBox.Text = "Error: RootPart not found" end
		end
	end)

	posTextBox = createBasicTextBox("PosTextBox", "Click 'Copy Position'", 5, buttonContainer) -- LayoutOrder 5

	-- ****** ADDED: Player Teleport Section ******
	-- Function to teleport to a specific player
	local function teleportToPlayer(targetPlayer)
		local localChar = player.Character
		local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
		local targetChar = targetPlayer and targetPlayer.Character
		local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

		if localRoot and targetRoot then
			print("Teleporting to player:", targetPlayer.Name)
			localRoot.CFrame = targetRoot.CFrame -- Set local player's CFrame to target's CFrame
		elseif not localRoot then
			warn("Cannot teleport: Local HumanoidRootPart not found.")
		elseif not targetPlayer then
			warn("Cannot teleport: Target player object is nil.")
		elseif not targetChar then
			warn("Cannot teleport: Target player character for", targetPlayer.Name, "not found.")
		elseif not targetRoot then
			warn("Cannot teleport: Target HumanoidRootPart for", targetPlayer.Name, "not found.")
		end
	end

	-- Function to update the player list in the dropdown
	local function updatePlayerList(dropdown)
		-- Clear existing buttons
		for _, child in ipairs(dropdown:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end

		local players = Players:GetPlayers()
		local playerCount = 0
		for i, p in ipairs(players) do
			if p ~= player then -- Don't list the local player
				playerCount += 1
				local playerButton = createBasicActionButton("Player_" .. p.UserId, p.DisplayName, i, dropdown, function()
					teleportToPlayer(p)
					-- Optionally hide dropdown after clicking
					-- dropdown.Visible = false
					-- playerTeleportButton.Text = "Player TP ▼"
				end)
				playerButton.Size = UDim2.new(1, -10, 0, 20) -- Match location button size
				playerButton.TextSize = 12
			end
		end
		-- Adjust CanvasSize based on player count
		dropdown.CanvasSize = UDim2.new(0, 0, 0, math.max(120, playerCount * 23 + 5)) -- Height per button + padding, min height 120
	end

	-- Create Player Teleport Button
	playerTeleportButton = createBasicToggleButton("PlayerTeleportButton", "Player TP ▼", "Player TP ▲", 6, buttonContainer, function() end) -- LayoutOrder 6

	-- Create Player Teleport Dropdown Frame (ScrollingFrame)
	playerTeleportDropdownFrame = Instance.new("ScrollingFrame")
	playerTeleportDropdownFrame.Name = "PlayerTeleportDropdown"
	playerTeleportDropdownFrame.Size = UDim2.new(0.9, 0, 0, 120) -- Initial visible size
	playerTeleportDropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 120) -- Start with base size, updated later
	playerTeleportDropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	playerTeleportDropdownFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
	playerTeleportDropdownFrame.BorderSizePixel = 1
	playerTeleportDropdownFrame.ClipsDescendants = true
	playerTeleportDropdownFrame.Visible = false -- Start hidden
	playerTeleportDropdownFrame.LayoutOrder = 7 -- Place it after the Player TP button
	playerTeleportDropdownFrame.ScrollBarThickness = 4
	playerTeleportDropdownFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
	playerTeleportDropdownFrame.Parent = buttonContainer

	local playerDropdownListLayout = Instance.new("UIListLayout")
	playerDropdownListLayout.Padding = UDim.new(0, 3)
	playerDropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	playerDropdownListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	playerDropdownListLayout.Parent = playerTeleportDropdownFrame

	-- Add click logic to the main Player Teleport button
	playerTeleportButton.MouseButton1Click:Connect(function()
		-- Hide location dropdown if open
		if teleportDropdownFrame.Visible then
			teleportDropdownFrame.Visible = false
			teleportButton.Text = "Locations ▼"
		end

		local shouldBeVisible = not playerTeleportDropdownFrame.Visible
		if shouldBeVisible then
			updatePlayerList(playerTeleportDropdownFrame) -- Update list *before* showing
		end
		playerTeleportDropdownFrame.Visible = shouldBeVisible
		playerTeleportButton.Text = shouldBeVisible and "Player TP ▲" or "Player TP ▼"
	end)
	-- ****** END ADDED SECTION ******

	-- Setup menu toggle (Insert Key)
	setupMenuToggle(mainFrame)

else
	-- == Empty Script Configuration ==
	print("Universe ID does not match known IDs. Configuring 'Empty Script' GUI.")
	screenGui.Name = "Empty Script"
	-- No mainFrame or toggle functionality needed for the "Empty" version.
	-- Create a basic frame just to show something if needed, but keep it minimal
	local frame = Instance.new("Frame")
	frame.Name = "MainFrame"
	frame.Size = UDim2.new(0, 200, 0, 50)
	frame.Position = UDim2.new(0.1, 0, 0.1, 0)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BorderColor3 = Color3.fromRGB(50, 50, 50)
	frame.BorderSizePixel = 1
	frame.Visible = true -- Make it visible so user knows the script ran
	frame.Parent = screenGui

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"; titleLabel.Size = UDim2.new(1, 0, 1, 0) -- Fill frame
	titleLabel.Position = UDim2.new(0, 0, 0, 0); titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	titleLabel.BorderSizePixel = 0
	titleLabel.TextColor3 = Color3.fromRGB(180, 180, 180); titleLabel.Font = Enum.Font.SourceSansSemibold
	titleLabel.Text = screenGui.Name .. " (No features for this game)"; titleLabel.TextSize = 12
	titleLabel.TextWrapped = true
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center; titleLabel.Parent = frame
end

-- == Global Event Connections & Initialization ==

-- Function to safely stop loops and reset buttons
local function stopLoopsAndResetButtons()
	isAutoBubbling = false
	isReeling = false
	-- Check if UI elements exist before trying to update them
	if autoBubbleButton then
		autoBubbleButton.Text = "AutoBubble [OFF]"; autoBubbleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	end
	if instantReelButton then
		instantReelButton.Text = "Instant Reel [OFF]"; instantReelButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	end
	if posTextBox then
		posTextBox.Text = "" -- Clear position
	end
	-- Close dropdowns if open
	if teleportDropdownFrame and teleportDropdownFrame.Visible then
		teleportDropdownFrame.Visible = false
		if teleportButton then teleportButton.Text = "Locations ▼" end -- Reset button text
	end
	if playerTeleportDropdownFrame and playerTeleportDropdownFrame.Visible then
		playerTeleportDropdownFrame.Visible = false
		if playerTeleportButton then playerTeleportButton.Text = "Player TP ▼" end -- Reset button text
	end
end


-- Stop loops if character dies
local function onCharacterDied()
	print("Humanoid Died. Stopping game-specific loops and resetting buttons.")
	stopLoopsAndResetButtons()
end

-- Connect to current character if it exists
local char = player.Character
if char then
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.Died:Connect(onCharacterDied)
	end
end

-- Connect CharacterAdded for future spawns
player.CharacterAdded:Connect(function(newCharacter)
	print("Character Added. Resetting game-specific states.")
	stopLoopsAndResetButtons() -- Ensure loops are stopped from previous life

	-- Connect Died event to the new humanoid
	local newHumanoid = newCharacter:WaitForChild("Humanoid")
	newHumanoid.Died:Connect(onCharacterDied)
end)


-- Finally, parent the configured ScreenGui to the PlayerGui
screenGui.Parent = playerGui
print("GUI '" .. screenGui.Name .. "' loaded and parented to PlayerGui.")
if mainFrame then print("Toggle menu visibility with Insert key.") end
-- Ensure the main button container canvas size is updated initially if it exists
if mainFrame and buttonContainer then
	task.wait(0.1) -- Wait a moment for layout to potentially calculate
	updateMainCanvasSize()
end
