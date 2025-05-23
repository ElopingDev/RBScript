-- Roblox Conditional GUI Loader Script with Toggle Menu
-- Place this LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService") -- Needed for toggle keybind
local ReplicatedStorage = game:GetService("ReplicatedStorage") -- Optional: If loading pre-made GUI elements

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui") -- Wait for PlayerGui to be ready

-- The target Universe ID to check against
local targetUniverseId = 6504986360

-- Get the current game's Universe ID
local currentUniverseId = game.GameId

-- Create a new ScreenGui instance in memory (don't parent yet)
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false -- Keep the GUI when the player respawns
screenGui.DisplayOrder = 1 -- Control layering if multiple GUIs exist

print("Checking Universe ID:", currentUniverseId)

-- Variable to hold the main UI frame if created
local mainFrame = nil

-- Check if the current game's Universe ID matches the target
if currentUniverseId == targetUniverseId then
	print("Universe ID matches. Configuring 'BubbleGum Infinity Script' GUI with toggle menu.")

	-- Configure the GUI for the target game
	screenGui.Name = "BubbleGum Infinity Script" -- Set the GUI name

	-- == Create the Main UI Frame (Black with Pink Highlights) ==
	mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 300, 0, 200) -- Example size (300x200 pixels)
	mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100) -- Centered (adjust offset based on size)
	mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black background
	mainFrame.BorderColor3 = Color3.fromRGB(255, 192, 203) -- Light Pink border (highlight)
	mainFrame.BorderSizePixel = 2 -- Adjust border size as needed
	mainFrame.Active = true -- Allows dragging if Draggable is true
	mainFrame.Draggable = true -- Make the frame draggable
	mainFrame.Visible = false -- Start hidden, toggled by Insert key
	mainFrame.Parent = screenGui -- Parent the frame to the ScreenGui

	-- Add a Title Bar to the frame
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 30) -- Full width, 30 pixels height
	titleBar.Position = UDim2.new(0, 0, 0, 0) -- Top of the mainFrame
	titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark Gray/Black
	titleBar.BorderSizePixel = 0 -- No border for the title bar itself
	titleBar.Parent = mainFrame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(1, -10, 1, 0) -- Almost full width/height of titleBar
	titleLabel.Position = UDim2.new(0, 5, 0, 0) -- Centered vertically, slight left padding
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.fromRGB(255, 192, 203) -- Light Pink text
	titleLabel.Font = Enum.Font.SourceSansBold
	titleLabel.Text = screenGui.Name -- Use the ScreenGui's name for the title
	titleLabel.TextScaled = true
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = titleBar

	-- Add a container for buttons (ScrollingFrame)
	local buttonContainer = Instance.new("ScrollingFrame")
	buttonContainer.Name = "ButtonContainer"
	buttonContainer.Size = UDim2.new(1, -10, 1, -35) -- Fill below title bar with padding
	buttonContainer.Position = UDim2.new(0, 5, 0, 35) -- Position below title bar
	buttonContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Dark grey background for container
	buttonContainer.BorderColor3 = Color3.fromRGB(255, 192, 203) -- Light Pink border (highlight)
	buttonContainer.BorderSizePixel = 1 -- Slightly thinner border for container
	buttonContainer.CanvasSize = UDim2.new(0, 0, 0, 0) -- Start with no scrolling needed
	buttonContainer.ScrollBarThickness = 6
	buttonContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 192, 203) -- Pink scrollbar
	buttonContainer.Parent = mainFrame

	-- == Toggle Functionality ==
	local function toggleMenu()
		if mainFrame then -- Check if mainFrame exists
			mainFrame.Visible = not mainFrame.Visible
			print("Menu visibility toggled:", mainFrame.Visible)
		end
	end

	-- Connect the toggle function to the Insert key
	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		-- Don't toggle if user is typing in a textbox, etc.
		if gameProcessedEvent then return end

		if input.KeyCode == Enum.KeyCode.Insert then
			toggleMenu()
		end
	end)

else
	print("Universe ID does not match. Configuring 'Empty Script' GUI.")

	-- Configure the GUI for other games (no special UI elements)
	screenGui.Name = "Empty Script"

	-- No mainFrame or toggle functionality needed for the "Empty" version.
	-- The ScreenGui itself will be created, but it will be visually empty.

end

-- Finally, parent the configured ScreenGui to the PlayerGui
screenGui.Parent = playerGui

print("GUI '" .. screenGui.Name .. "' loaded and parented to PlayerGui.")

