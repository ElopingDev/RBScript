--[[
    Disclaimer: This script provides UI elements ONLY, inspired by a user-provided image.
    It contains NO cheat/exploit functionality. Using executors or cheat scripts violates Roblox ToS.
    This script does NOT intentionally contain the 'HookScrollingFrame' bug previously discussed.
]]

-- Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService") -- Used for basic drag functionality

-- Basic Setup
local Player = Players.LocalPlayer
local PlayerGui = Player and Player:FindFirstChild("PlayerGui") -- Get PlayerGui, may need adjustment depending on executor context

-- If PlayerGui is not found immediately, create a ScreenGui in CoreGui (common executor practice)
local ScreenGui
if PlayerGui then
    ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
else
    -- Fallback for environments where PlayerGui might be tricky (like some executors)
    ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    print("Warning: PlayerGui not found, using CoreGui. May have parenting issues.")
end


-- Determine Menu Title based on GameId
local currentGameId = game.GameId
local menuTitle = "Base Script"
if currentGameId == 6504986360 then
    menuTitle = "BubbleGum Infinite Script"
end

-- Main Frame (Window)
local menuFrame = Instance.new("Frame")
menuFrame.Name = "ExecutorMenu"
menuFrame.Parent = ScreenGui
menuFrame.Size = UDim2.new(0, 500, 0, 350) -- Fixed size in pixels (adjust as needed)
menuFrame.Position = UDim2.new(0.5, -250, 0.5, -175) -- Centered
menuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40) -- Dark background
menuFrame.BorderColor3 = Color3.fromRGB(80, 80, 90)
menuFrame.BorderSizePixel = 1
menuFrame.Visible = false -- Start hidden
menuFrame.Active = true -- Enable input processing for dragging
menuFrame.Draggable = true -- Allow dragging (basic Roblox dragging)
menuFrame.ClipsDescendants = true

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Parent = menuFrame
titleBar.Size = UDim2.new(1, 0, 0, 30) -- Full width, 30 pixels height
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55) -- Slightly lighter background for title
titleBar.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = titleBar
titleLabel.Size = UDim2.new(1, -10, 1, 0) -- Leave space on the right if needed for close button later
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.Text = menuTitle
titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
titleLabel.Font = Enum.Font.SourceSansSemibold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.BackgroundTransparency = 1

-- Tab Container
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Parent = menuFrame
tabContainer.Size = UDim2.new(1, 0, 0, 30) -- Full width, 30 pixels height
tabContainer.Position = UDim2.new(0, 0, 0, 30) -- Position below title bar
tabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
tabContainer.BorderSizePixel = 0

-- Content Area
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Parent = menuFrame
contentArea.Size = UDim2.new(1, -10, 1, -70) -- Adjust size to fit within main frame, below title and tabs, with padding
contentArea.Position = UDim2.new(0, 5, 0, 65) -- Position below tabs with padding
contentArea.BackgroundColor3 = Color3.fromRGB(35, 35, 40) -- Same as main background or slightly different
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true

-- Create Tab Frames (one for each tab, only one visible at a time)
local tabFrames = {}

local function createTabFrame(name)
    local frame = Instance.new("Frame")
    frame.Name = name .. "TabFrame"
    frame.Parent = contentArea
    frame.Size = UDim2.new(1, 0, 1, 0) -- Fill content area
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Visible = false -- Start hidden
    frame.ClipsDescendants = true
    table.insert(tabFrames, frame)
    return frame
end

-- Create Tabs and Content Frames
local tabs = {"Legit", "Visuals", "Settings", "Config"} -- Match image approximately
local activeTabFrame = nil
local tabButtons = {}

local currentX = 0.02 -- Starting X position for tabs (as scale)
for i, tabName in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName .. "Tab"
    tabButton.Parent = tabContainer
    tabButton.Size = UDim2.new(0, 80, 1, -4) -- Fixed width for tabs, slightly smaller height for padding
    tabButton.Position = UDim2.new(currentX, 0, 0, 2)
    tabButton.Text = tabName
    tabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    tabButton.Font = Enum.Font.SourceSans
    tabButton.TextSize = 14
    tabButton.BorderSizePixel = 1
    tabButton.BorderColor3 = Color3.fromRGB(65,65,75)

    currentX = currentX + 0.01 + (80 / tabContainer.AbsoluteSize.X) -- Update X position for next tab (requires initial size guess or calculation)

    local contentFrame = createTabFrame(tabName)
    tabButtons[tabName] = {button = tabButton, frame = contentFrame}

    -- Tab click logic
    tabButton.MouseButton1Click:Connect(function()
        if activeTabFrame then
            activeTabFrame.Visible = false
            tabButtons[activeTabFrame.Name:gsub("TabFrame","")].button.BackgroundColor3 = Color3.fromRGB(50, 50, 60) -- Deselect color
            tabButtons[activeTabFrame.Name:gsub("TabFrame","")].button.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        contentFrame.Visible = true
        activeTabFrame = contentFrame
        tabButton.BackgroundColor3 = Color3.fromRGB(65, 65, 75) -- Select color
        tabButton.TextColor3 = Color3.fromRGB(230, 230, 230)
    end)
end

-- Function to add placeholder elements to a tab frame (example)
local function addPlaceholderContent(tabFrame, contentType)
    local yPos = 0.05
    local xPosCol1 = 0.05
    local xPosCol2 = 0.55
    local colWidth = 0.4

    local label = Instance.new("TextLabel", tabFrame)
    label.Size = UDim2.new(colWidth, 0, 0.05, 0)
    label.Position = UDim2.new(xPosCol1, 0, yPos, 0)
    label.Text = contentType .. " Option 1:"
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local checkbox = Instance.new("TextButton", tabFrame) -- Using button as placeholder checkbox
    checkbox.Size = UDim2.new(0, 15, 0, 15)
    checkbox.Position = UDim2.new(xPosCol1 + colWidth - (15/tabFrame.AbsoluteSize.X) - 0.01, 0, yPos, 2) -- Position near label end
    checkbox.Text = "" -- Checkbox visual
    checkbox.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    checkbox.BorderSizePixel = 1
    checkbox.BorderColor3 = Color3.fromRGB(80, 80, 90)
    local isChecked = false
    checkbox.MouseButton1Click:Connect(function()
        isChecked = not isChecked
        checkbox.Text = isChecked and "X" or ""
        checkbox.TextColor3 = Color3.fromRGB(200, 200, 200)
        checkbox.TextSize = 14
        checkbox.Font = Enum.Font.SourceSansBold
    end)

    yPos = yPos + 0.08

    local label2 = Instance.new("TextLabel", tabFrame)
    label2.Size = UDim2.new(colWidth, 0, 0.05, 0)
    label2.Position = UDim2.new(xPosCol1, 0, yPos, 0)
    label2.Text = contentType .. " Slider:"
    label2.TextColor3 = Color3.fromRGB(200, 200, 200)
    label2.BackgroundTransparency = 1
    label2.Font = Enum.Font.SourceSans
    label2.TextSize = 14
    label2.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBg = Instance.new("Frame", tabFrame) -- Placeholder slider background
    sliderBg.Size = UDim2.new(colWidth, -20, 0, 8)
    sliderBg.Position = UDim2.new(xPosCol1, 0, yPos + 0.05, 0)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sliderBg.BorderSizePixel = 1
    sliderBg.BorderColor3 = Color3.fromRGB(80, 80, 90)

    local sliderValueLabel = Instance.new("TextLabel", tabFrame)
    sliderValueLabel.Size = UDim2.new(0, 30, 0.05, 0)
    sliderValueLabel.Position = UDim2.new(xPosCol1 + colWidth - (30/tabFrame.AbsoluteSize.X) - 0.01, 0, yPos, 0)
    sliderValueLabel.Text = "50" -- Example value
    sliderValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    sliderValueLabel.BackgroundTransparency = 1
    sliderValueLabel.Font = Enum.Font.SourceSans
    sliderValueLabel.TextSize = 14
    sliderValueLabel.TextXAlignment = Enum.TextXAlignment.Right

    -- Add similar placeholders for the second column if needed
end

-- Populate placeholder content (do this AFTER tabs are created)
if tabButtons["Legit"] then addPlaceholderContent(tabButtons["Legit"].frame, "Aimbot") end
if tabButtons["Visuals"] then addPlaceholderContent(tabButtons["Visuals"].frame, "ESP") end
-- Add more population for other tabs as needed

-- Activate the first tab by default
if tabButtons[tabs[1]] then
    tabButtons[tabs[1]].button:Invoke() -- Simulate click to activate
end


-- Toggle Menu Visibility
local menuOpen = false
local function ToggleMenu()
    menuOpen = not menuOpen
    menuFrame.Visible = menuOpen
end

-- Input Handling
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    -- If the input is already being used by something else (like chat), ignore it
    if gameProcessedEvent then return end

    -- Check if the key pressed is Insert
    if input.KeyCode == Enum.KeyCode.Insert then
        ToggleMenu()
    end
end)

print(menuTitle .. " UI Loaded (Visuals Only)")

-- Basic Drag Logic (Example, replace with better logic if needed)
local dragging = false
local dragInput = nil
local frameStartPos = nil
local dragStartPos = nil

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStartPos = input.Position
		frameStartPos = menuFrame.Position
		input.Changed:Connect(function() -- Handle mouse leaving while dragging
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

RunService.RenderStepped:Connect(function() -- Use RenderStepped for smooth dragging
	if dragging and dragInput then
		local delta = dragInput.Position - dragStartPos
		menuFrame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X,
										 frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
	end
end)
