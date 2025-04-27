-- Roblox Conditional GUI Loader Script
-- Place this LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
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

print("Checking Universe ID:", currentUniverseId)

-- Check if the current game's Universe ID matches the target
if currentUniverseId == targetUniverseId then
	print("Universe ID matches. Configuring 'BubbleGum Infinity Script' GUI.")

	-- Configure the GUI for the target game
	screenGui.Name = "BubbleGum Infinity Script"
	screenGui.DisplayOrder = 1 -- Example: Set display order if needed

	-- == Add UI Elements specific to BubbleGum Infinity ==
	-- Example: Add a simple TextLabel
	local infoLabel = Instance.new("TextLabel")
	infoLabel.Name = "InfoLabel"
	infoLabel.Size = UDim2.new(0.3, 0, 0.1, 0) -- 30% width, 10% height
	infoLabel.Position = UDim2.new(0.35, 0, 0.05, 0) -- Position near top-center
	infoLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	infoLabel.BackgroundTransparency = 0.3
	infoLabel.BorderSizePixel = 2
	infoLabel.BorderColor3 = Color3.fromRGB(200, 200, 200)
	infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	infoLabel.TextScaled = true
	infoLabel.Font = Enum.Font.SourceSansBold
	infoLabel.Text = "BubbleGum Infinity Features Active"
	infoLabel.Parent = screenGui -- Parent the label to the ScreenGui

	-- Example: Add a Button
	local actionButton = Instance.new("TextButton")
	actionButton.Name = "ActionButton"
	actionButton.Size = UDim2.new(0.2, 0, 0.08, 0)
	actionButton.Position = UDim2.new(0.4, 0, 0.2, 0)
	actionButton.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
	actionButton.BorderSizePixel = 1
	actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	actionButton.TextScaled = true
	actionButton.Font = Enum.Font.SourceSansBold
	actionButton.Text = "Special Action"
	actionButton.Parent = screenGui

	-- Add functionality to the button if needed
	actionButton.MouseButton1Click:Connect(function()
		print("Special Action Button Clicked!")
		-- Add code for the button's action here
	end)

	-- You could also clone pre-made GUI elements from ReplicatedStorage here
	-- local specificFrame = ReplicatedStorage.GameSpecificUI.MyFrame:Clone()
	-- specificFrame.Parent = screenGui

else
	print("Universe ID does not match. Configuring 'Empty Script' GUI.")

	-- Configure the GUI for other games
	screenGui.Name = "Empty Script"
	screenGui.DisplayOrder = 1

	-- == Add minimal or no UI elements ==
	-- Example: Add a small indicator label
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "StatusLabel"
	statusLabel.Size = UDim2.new(0, 150, 0, 30) -- Fixed size
	statusLabel.Position = UDim2.new(1, -160, 0, 10) -- Top-right corner
	statusLabel.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	statusLabel.BackgroundTransparency = 0.5
	statusLabel.BorderSizePixel = 0
	statusLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
	statusLabel.FontSize = Enum.FontSize.Size14
	statusLabel.Font = Enum.Font.SourceSans
	statusLabel.Text = "No special features"
	statusLabel.TextXAlignment = Enum.TextXAlignment.Center
	statusLabel.Parent = screenGui

	-- No special buttons or features needed for the "Empty" version
end

-- Finally, parent the fully configured ScreenGui to the PlayerGui
screenGui.Parent = playerGui

print("GUI '" .. screenGui.Name .. "' loaded and parented to PlayerGui.")

