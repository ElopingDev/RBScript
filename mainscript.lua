-- This is a LocalScript, so it should be placed in StarterGui

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local currentGameId = game.GameId
local menuTitle = "Base Script"

-- Check if the current GameId matches the specified ID
if currentGameId == 6504986360 then
    menuTitle = "BubbleGum Infinite Script"
end

-- Create the main menu frame
local menuFrame = Instance.new("Frame")
menuFrame.Parent = PlayerGui
menuFrame.Name = "ScriptMenu" -- Give it a name for easier identification
menuFrame.Size = UDim2.new(0.3, 0, 0.5, 0)  -- Size: 30% width, 50% height
menuFrame.Position = UDim2.new(0.35, 0, 0.25, 0) -- Position: roughly centered
menuFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48) -- Dark grey background
menuFrame.BorderSizePixel = 1
menuFrame.BorderColor3 = Color3.fromRGB(80, 80, 80) -- Slightly lighter border
menuFrame.Visible = false -- Start hidden
menuFrame.Active = true -- Allow user input processing
menuFrame.Draggable = true -- Allow the user to drag the menu

-- Create the title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = menuFrame
titleLabel.Size = UDim2.new(1, 0, 0.15, 0) -- Size: full width, 15% height
titleLabel.Position = UDim2.new(0, 0, 0, 0) -- Position: top
titleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Slightly lighter title bar background
titleLabel.BorderSizePixel = 0
titleLabel.Text = menuTitle
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20 -- Adjust text size as needed
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.TextYAlignment = Enum.TextYAlignment.Center

-- Create a container for menu options (useful for scrolling if needed later)
local optionsContainer = Instance.new("Frame")
optionsContainer.Parent = menuFrame
optionsContainer.Size = UDim2.new(1, 0, 0.85, 0) -- Fill remaining space below title
optionsContainer.Position = UDim2.new(0, 0, 0.15, 0) -- Position below title bar
optionsContainer.BackgroundTransparency = 1 -- Make container invisible
optionsContainer.BorderSizePixel = 0

-- Example menu option button (Add more like this)
local option1Button = Instance.new("TextButton")
option1Button.Parent = optionsContainer
option1Button.Name = "Option1"
option1Button.Size = UDim2.new(0.9, 0, 0.1, 0) -- 90% width, 10% height
option1Button.Position = UDim2.new(0.05, 0, 0.05, 0) -- Centered horizontally, near top
option1Button.Text = "Example Option 1"
option1Button.TextColor3 = Color3.fromRGB(220, 220, 220) -- Light grey text
option1Button.BackgroundColor3 = Color3.fromRGB(55, 55, 55) -- Dark button background
option1Button.BorderSizePixel = 1
option1Button.BorderColor3 = Color3.fromRGB(70, 70, 70)
option1Button.Font = Enum.Font.SourceSans
option1Button.TextSize = 16

-- Add function for the button click
option1Button.MouseButton1Click:Connect(function()
    print("Option 1 clicked!")
    -- Add the action for this button here
end)

-- Function to toggle menu visibility
local menuOpen = false
local function ToggleMenu()
    menuOpen = not menuOpen
    menuFrame.Visible = menuOpen
end

-- Listen for the Insert key press
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    -- Ignore input if it was already processed by the game (e.g., typing in chat)
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode.Insert then
        ToggleMenu()
    end
end)

-- Optional: Ensure core GUIs like backpack/chat are not blocked
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
