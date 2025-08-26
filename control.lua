local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local BOUNTY_REMOTE = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SetBounty")

local totalSpent = 0
local lastValue = 0

local viewing = false
local lastCameraSubject = nil

local dragging
local dragInput
local dragStart
local startPos

local existingGui = CoreGui:FindFirstChild("Control")
if existingGui then
    existingGui:Destroy()
end

local ControlGui = Instance.new("ScreenGui")
ControlGui.Name = "Control"
ControlGui.Parent = CoreGui
ControlGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Parent = ControlGui
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0.4, 0, 0.4, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
MainFrame.ZIndex = 2
MainFrame.BorderSizePixel = 0

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

local BountyF = Instance.new("Frame")
BountyF.Name = "Bounty"
BountyF.Parent = MainFrame
BountyF.Position = UDim2.new(0.5, 0, 0.5, 0)
BountyF.Size = UDim2.new(1, 0, 1, 0)
BountyF.AnchorPoint = Vector2.new(0.5, 0.5)
BountyF.BackgroundTransparency = 1
BountyF.BorderSizePixel = 0

-- Target Frame
local TargetFrame = Instance.new("Frame")
TargetFrame.Name = "Target"
TargetFrame.Parent = BountyF
TargetFrame.Position = UDim2.new(0.03, 0, 0.06, 0)
TargetFrame.Size = UDim2.new(0.94, 0, 0.31, 0)
TargetFrame.BackgroundTransparency = 1
TargetFrame.BorderSizePixel = 0

-- Target User Image
local TargetUserImage = Instance.new("ImageLabel")
TargetUserImage.Name = "UserImage"
TargetUserImage.Parent = TargetFrame
TargetUserImage.Position = UDim2.new(0.03, 0, 0.08, 0)
TargetUserImage.Size = UDim2.new(0.15, 0, 0.84, 0)
TargetUserImage.BackgroundTransparency = 1
TargetUserImage.BorderSizePixel = 0
TargetUserImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

local Image1Corner = Instance.new("UICorner")
Image1Corner.CornerRadius = UDim.new(0, 8)
Image1Corner.Parent = TargetUserImage

-- Target Username
local TargetUsername = Instance.new("TextLabel")
TargetUsername.Name = "Username"
TargetUsername.Parent = TargetFrame
TargetUsername.Position = UDim2.new(0.2, 0, 0.22, 0)
TargetUsername.Size = UDim2.new(0.29, 0, 0.2, 0)
TargetUsername.BackgroundTransparency = 1
TargetUsername.Font = Enum.Font.SourceSansBold
TargetUsername.Text = "Username"
TargetUsername.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetUsername.TextScaled = true
TargetUsername.TextWrapped = true
local UsernameSize = Instance.new("UITextSizeConstraint")
UsernameSize.Parent = TargetUsername
UsernameSize.MaxTextSize = 25

-- Target UserID
local TargetUserID = Instance.new("TextLabel")
TargetUserID.Name = "UserID"
TargetUserID.Parent = TargetFrame
TargetUserID.Position = UDim2.new(0.2, 0, 0.54, 0)
TargetUserID.Size = UDim2.new(0.29, 0, 0.2, 0)
TargetUserID.BackgroundTransparency = 1
TargetUserID.Font = Enum.Font.SourceSansBold
TargetUserID.Text = "UserID"
TargetUserID.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetUserID.TextScaled = true
TargetUserID.TextWrapped = true
local UserIDSize = Instance.new("UITextSizeConstraint")
UserIDSize.Parent = TargetUserID
UserIDSize.MaxTextSize = 25

local TargetAmount = Instance.new("TextLabel")
TargetAmount.Name = "TargetDHC"
TargetAmount.Parent = TargetFrame
TargetAmount.Position = UDim2.new(0.706, 0, 0.632, 0)
TargetAmount.Size = UDim2.new(0.29, 0, 0.16, 0)
TargetAmount.BackgroundTransparency = 1
TargetAmount.Font = Enum.Font.SourceSansBold
TargetAmount.Text = "Target"
TargetAmount.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetAmount.TextScaled = true
TargetAmount.TextWrapped = true
local TargetAmountSize = Instance.new("UITextSizeConstraint")
TargetAmountSize.Parent = TargetAmount
TargetAmountSize.MaxTextSize = 20

-- Amount
local Amount = Instance.new("TextLabel")
Amount.Name = "Amount"
Amount.Parent = TargetFrame
Amount.Position = UDim2.new(0.71, 0, 0.06, 0)
Amount.Size = UDim2.new(0.29, 0, 0.16, 0)
Amount.BackgroundTransparency = 1
Amount.Font = Enum.Font.SourceSansBold
Amount.Text = "Amount"
Amount.TextColor3 = Color3.fromRGB(255, 255, 255)
Amount.TextScaled = true
Amount.TextWrapped = true
local AmountSize = Instance.new("UITextSizeConstraint")
AmountSize.Parent = Amount
AmountSize.MaxTextSize = 20

-- Target Remaining
local TargetRemaining = Instance.new("TextLabel")
TargetRemaining.Name = "Remaining"
TargetRemaining.Parent = TargetFrame
TargetRemaining.Position = UDim2.new(0.7, 0, 0.22, 0)
TargetRemaining.Size = UDim2.new(0.18, 0, 0.16, 0)
TargetRemaining.BackgroundTransparency = 1
TargetRemaining.Font = Enum.Font.SourceSansBold
TargetRemaining.Text = "Remaining"
TargetRemaining.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetRemaining.TextTransparency = 0.5
TargetRemaining.TextScaled = true
TargetRemaining.TextWrapped = true
local RemainingSize = Instance.new("UITextSizeConstraint")
RemainingSize.Parent = TargetRemaining
RemainingSize.MaxTextSize = 20

-- Giving TextBox
local GivingBox = Instance.new("TextBox")
GivingBox.Name = "Giving"
GivingBox.Parent = TargetFrame
GivingBox.Position = UDim2.new(0.49, 0, 0.06, 0)
GivingBox.Size = UDim2.new(0.19, 0, 0.21, 0)
GivingBox.BackgroundTransparency = 1
GivingBox.BorderSizePixel = 0
GivingBox.Font = Enum.Font.SourceSansBold
GivingBox.PlaceholderText = "Type an amount to give"
GivingBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
GivingBox.Text = ""
GivingBox.TextColor3 = Color3.fromRGB(255, 255, 255)
GivingBox.TextScaled = true
GivingBox.TextWrapped = true
local GivingBoxSize = Instance.new("UITextSizeConstraint")
GivingBoxSize.Parent = GivingBox
GivingBoxSize.MaxTextSize = 14

-- Aspect Ratio Constraint
local TargetAspect = Instance.new("UIAspectRatioConstraint")
TargetAspect.Parent = TargetFrame
TargetAspect.AspectRatio = 5.44

-- Bounty Frame
local BountyFrame = Instance.new("Frame")
BountyFrame.Name = "Bounty"
BountyFrame.Parent = BountyF
BountyFrame.Position = UDim2.new(0.03, 0, 0.55, 0)
BountyFrame.Size = UDim2.new(0.94, 0, 0.31, 0)
BountyFrame.BackgroundTransparency = 1
BountyFrame.BorderSizePixel = 0

-- Bounty User Image
local BountyUserImage = Instance.new("ImageLabel")
BountyUserImage.Name = "UserImage"
BountyUserImage.Parent = BountyFrame
BountyUserImage.Position = UDim2.new(0.03, 0, 0.08, 0)
BountyUserImage.Size = UDim2.new(0.15, 0, 0.84, 0)
BountyUserImage.BackgroundTransparency = 1
BountyUserImage.BorderSizePixel = 0
BountyUserImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

local Image2Corner = Instance.new("UICorner")
Image2Corner.CornerRadius = UDim.new(0, 8)
Image2Corner.Parent = BountyUserImage

-- Bounty Player Name
local BountyPlayerName = Instance.new("TextBox")
BountyPlayerName.Name = "PlayerName"
BountyPlayerName.Parent = BountyFrame
BountyPlayerName.Position = UDim2.new(0.2, 0, 0.21, 0)
BountyPlayerName.Size = UDim2.new(0.29, 0, 0.21, 0)
BountyPlayerName.BackgroundTransparency = 1
BountyPlayerName.BorderSizePixel = 0
BountyPlayerName.Font = Enum.Font.SourceSansBold
BountyPlayerName.PlaceholderText = "Type a player to set a bounty on"
BountyPlayerName.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
BountyPlayerName.Text = ""
BountyPlayerName.TextColor3 = Color3.fromRGB(255, 255, 255)
BountyPlayerName.TextScaled = true
BountyPlayerName.TextWrapped = true
local PlayerNameSize = Instance.new("UITextSizeConstraint")
PlayerNameSize.Parent = BountyPlayerName
PlayerNameSize.MaxTextSize = 17

-- Bounty Amount
local BountyAmount = Instance.new("TextBox")
BountyAmount.Name = "BountyAmount"
BountyAmount.Parent = BountyFrame
BountyAmount.Position = UDim2.new(0.76, 0, 0.21, 0)
BountyAmount.Size = UDim2.new(0.19, 0, 0.21, 0)
BountyAmount.BackgroundTransparency = 1
BountyAmount.BorderSizePixel = 0
BountyAmount.Font = Enum.Font.SourceSansBold
BountyAmount.PlaceholderText = "Type a Bounty Amount"
BountyAmount.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
BountyAmount.Text = ""
BountyAmount.TextColor3 = Color3.fromRGB(255, 255, 255)
BountyAmount.TextScaled = true
BountyAmount.TextWrapped = true
local BountyAmountSize = Instance.new("UITextSizeConstraint")
BountyAmountSize.Parent = BountyAmount
BountyAmountSize.MaxTextSize = 14

local BountyAspect = Instance.new("UIAspectRatioConstraint")
BountyAspect.Parent = BountyFrame
BountyAspect.AspectRatio = 5.44

-- Bounty UserID
local BountyUserID = Instance.new("TextLabel")
BountyUserID.Name = "UserID"
BountyUserID.Parent = BountyFrame
BountyUserID.Position = UDim2.new(0.2, 0, 0.54, 0)
BountyUserID.Size = UDim2.new(0.29, 0, 0.2, 0)
BountyUserID.BackgroundTransparency = 1
BountyUserID.Font = Enum.Font.SourceSansBold
BountyUserID.Text = "UserID"
BountyUserID.TextColor3 = Color3.fromRGB(255, 255, 255)
BountyUserID.TextScaled = true
BountyUserID.TextWrapped = true
local BountyUserIDSize = Instance.new("UITextSizeConstraint")
BountyUserIDSize.Parent = BountyUserID
BountyUserIDSize.MaxTextSize = 25

-- Bounty DHC
local BountyDHC = Instance.new("TextLabel")
BountyDHC.Name = "DHC"
BountyDHC.Parent = BountyFrame
BountyDHC.Position = UDim2.new(0.706, 0, 0.54, 0)
BountyDHC.Size = UDim2.new(0.29, 0, 0.2, 0)
BountyDHC.BackgroundTransparency = 1
BountyDHC.Font = Enum.Font.SourceSansBold
BountyDHC.Text = "Amount"
BountyDHC.TextColor3 = Color3.fromRGB(255, 255, 255)
BountyDHC.TextScaled = true
BountyDHC.TextWrapped = true
local BountyDHCSize = Instance.new("UITextSizeConstraint")
BountyDHCSize.Parent = BountyDHC
BountyDHCSize.MaxTextSize = 25

local PlayerF = Instance.new("Frame")
PlayerF.Name = "Player"
PlayerF.Parent = MainFrame
PlayerF.Visible = false
PlayerF.Position = UDim2.new(0.5, 0, 0.5, 0)
PlayerF.Size = UDim2.new(1, 0, 1, 0)
PlayerF.AnchorPoint = Vector2.new(0.5, 0.5)
PlayerF.BackgroundTransparency = 1
PlayerF.BorderSizePixel = 0

local TargetFrame2 = Instance.new("Frame")
TargetFrame2.Name = "Target"
TargetFrame2.Parent = PlayerF
TargetFrame2.Position = UDim2.new(0.03, 0, 0.06, 0)
TargetFrame2.Size = UDim2.new(0.94, 0, 0.31, 0)
TargetFrame2.BackgroundTransparency = 1
TargetFrame2.BorderSizePixel = 0

local PlayerUserImage = Instance.new("ImageLabel")
PlayerUserImage.Name = "UserImage"
PlayerUserImage.Parent = TargetFrame2
PlayerUserImage.Position = UDim2.new(0.03, 0, 0.08, 0)
PlayerUserImage.Size = UDim2.new(0.15, 0, 0.84, 0)
PlayerUserImage.BackgroundTransparency = 1
PlayerUserImage.BorderSizePixel = 0
PlayerUserImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

local Image2Corner = Instance.new("UICorner")
Image2Corner.CornerRadius = UDim.new(0, 8)
Image2Corner.Parent = PlayerUserImage

local PlayerNameThing = Instance.new("TextBox")
PlayerNameThing.Name = "PlayerName"
PlayerNameThing.Parent = TargetFrame2
PlayerNameThing.Position = UDim2.new(0.199, 0, 0.208, 0)
PlayerNameThing.Size = UDim2.new(0.294, 0, 0.208, 0)
PlayerNameThing.BackgroundTransparency = 1
PlayerNameThing.BorderSizePixel = 0
PlayerNameThing.Font = Enum.Font.SourceSansBold
PlayerNameThing.PlaceholderText = "Enter a Username"
PlayerNameThing.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
PlayerNameThing.Text = ""
PlayerNameThing.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerNameThing.TextScaled = true
PlayerNameThing.TextWrapped = true
local TargetNameSize = Instance.new("UITextSizeConstraint")
TargetNameSize.Parent = PlayerNameThing
TargetNameSize.MaxTextSize = 14

local PlayerUserID = Instance.new("TextLabel")
PlayerUserID.Name = "UserID"
PlayerUserID.Parent = TargetFrame2
PlayerUserID.Position = UDim2.new(0.2, 0, 0.54, 0)
PlayerUserID.Size = UDim2.new(0.29, 0, 0.2, 0)
PlayerUserID.BackgroundTransparency = 1
PlayerUserID.Font = Enum.Font.SourceSansBold
PlayerUserID.Text = "UserID"
PlayerUserID.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerUserID.TextScaled = true
PlayerUserID.TextWrapped = true
local UserIDSize = Instance.new("UITextSizeConstraint")
UserIDSize.Parent = PlayerUserID
UserIDSize.MaxTextSize = 25

local PlayerDHC = Instance.new("TextLabel")
PlayerDHC.Name = "DHC"
PlayerDHC.Parent = TargetFrame2
PlayerDHC.Position = UDim2.new(0.473, 0, 0.216, 0)
PlayerDHC.Size = UDim2.new(0.294, 0, 0.2, 0)
PlayerDHC.BackgroundTransparency = 1
PlayerDHC.Font = Enum.Font.SourceSansBold
PlayerDHC.Text = "DHC"
PlayerDHC.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerDHC.TextScaled = true
PlayerDHC.TextWrapped = true
local PlayerDHCSize = Instance.new("UITextSizeConstraint")
PlayerDHCSize.Parent = PlayerDHC
PlayerDHCSize.MaxTextSize = 20

local AmountSpent = Instance.new("TextLabel")
AmountSpent.Name = "Spent"
AmountSpent.Parent = TargetFrame2
AmountSpent.Position = UDim2.new(0.473, 0, 0.54, 0)
AmountSpent.Size = UDim2.new(0.294, 0, 0.2, 0)
AmountSpent.BackgroundTransparency = 1
AmountSpent.Font = Enum.Font.SourceSansBold
AmountSpent.Text = "Spent"
AmountSpent.TextColor3 = Color3.fromRGB(255, 255, 255)
AmountSpent.TextScaled = true
AmountSpent.TextWrapped = true
local AmountSpentSize = Instance.new("UITextSizeConstraint")
AmountSpentSize.Parent = AmountSpent
AmountSpentSize.MaxTextSize = 20

local ButtonsF = Instance.new("Frame")
ButtonsF.Parent = PlayerF
ButtonsF.AnchorPoint = Vector2.new(0.5,0.5)
ButtonsF.BackgroundTransparency = 1
ButtonsF.Position = UDim2.new(0.5,0,0.68,0)
ButtonsF.Size = UDim2.new(1,0,0.5,0)
ButtonsF.Name = "Buttons"
local ButtonsAspect = Instance.new("UIAspectRatioConstraint")
ButtonsAspect.Parent = ButtonsF
ButtonsAspect.AspectRatio = 3.585

local BringF = Instance.new("Frame")
BringF.Parent = ButtonsF
BringF.Name = "Bring"
BringF.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
BringF.Position = UDim2.new(0.05, 0, 0.062, 0)
BringF.Size = UDim2.new(0.173, 0, 0.155, 0)
BringF.ZIndex = 3
local BringCorner = Instance.new("UICorner")
BringCorner.CornerRadius = UDim.new(0,3)
BringCorner.Parent = BringF

local BringB = Instance.new("TextButton")
BringB.Parent = BringF
BringB.Name = "Button"
BringB.Text = "Bring"
BringB.BackgroundTransparency = 1
BringB.Position = UDim2.new(0, 0, 0.12, 0)
BringB.Size = UDim2.new(1, 0, 0.72, 0)
BringB.TextColor3 = Color3.fromRGB(255,255,255)
BringB.ZIndex = 1
local BringSize = Instance.new("UITextSizeConstraint")
BringSize.Parent = BringB
BringSize.MaxTextSize = 18

local GoToF = Instance.new("Frame")
GoToF.Parent = ButtonsF
GoToF.Name = "GoTo"
GoToF.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
GoToF.Position = UDim2.new(0.291, 0, 0.062, 0)
GoToF.Size = UDim2.new(0.173, 0, 0.155, 0)
GoToF.ZIndex = 3
local GoCorner = Instance.new("UICorner")
GoCorner.CornerRadius = UDim.new(0,3)
GoCorner.Parent = GoToF

local GoToB = Instance.new("TextButton")
GoToB.Parent = GoToF
GoToB.Name = "Button"
GoToB.Text = "GoTo"
GoToB.BackgroundTransparency = 1
GoToB.Position = UDim2.new(0, 0, 0.12, 0)
GoToB.Size = UDim2.new(1, 0, 0.72, 0)
GoToB.TextColor3 = Color3.fromRGB(255,255,255)
GoToB.ZIndex = 1
local GoToSize = Instance.new("UITextSizeConstraint")
GoToSize.Parent = GoToB
GoToSize.MaxTextSize = 18

local ViewF = Instance.new("Frame")
ViewF.Parent = ButtonsF
ViewF.Name = "View"
ViewF.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
ViewF.Position = UDim2.new(0.536, 0, 0.062, 0)
ViewF.Size = UDim2.new(0.173, 0, 0.155, 0)
ViewF.ZIndex = 3
local ViewCorner = Instance.new("UICorner")
ViewCorner.CornerRadius = UDim.new(0,3)
ViewCorner.Parent = ViewF

local ViewB = Instance.new("TextButton")
ViewB.Parent = ViewF
ViewB.Name = "Button"
ViewB.Text = "View"
ViewB.BackgroundTransparency = 1
ViewB.Position = UDim2.new(0, 0, 0.12, 0)
ViewB.Size = UDim2.new(1, 0, 0.72, 0)
ViewB.TextColor3 = Color3.fromRGB(255,255,255)
ViewB.ZIndex = 1
local ViewSize = Instance.new("UITextSizeConstraint")
ViewSize.Parent = ViewB
ViewSize.MaxTextSize = 18

local KnockF = Instance.new("Frame")
KnockF.Parent = ButtonsF
KnockF.Name = "Knock"
KnockF.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
KnockF.Position = UDim2.new(0.772, 0, 0.062, 0)
KnockF.Size = UDim2.new(0.173, 0, 0.155, 0)
KnockF.ZIndex = 3
local GoCorner = Instance.new("UICorner")
GoCorner.CornerRadius = UDim.new(0,3)
GoCorner.Parent = KnockF

local KnockB = Instance.new("TextButton")
KnockB.Parent = KnockF
KnockB.Name = "Button"
KnockB.Text = "Knock"
KnockB.BackgroundTransparency = 1
KnockB.Position = UDim2.new(0, 0, 0.12, 0)
KnockB.Size = UDim2.new(1, 0, 0.72, 0)
KnockB.TextColor3 = Color3.fromRGB(255,255,255)
KnockB.ZIndex = 1
local KnockSize = Instance.new("UITextSizeConstraint")
KnockSize.Parent = KnockB
KnockSize.MaxTextSize = 18

-- Title Frame
local TitleFrame = Instance.new("Frame")
TitleFrame.Name = "Title"
TitleFrame.Parent = MainFrame
TitleFrame.Position = UDim2.new(0.5, 0, -0.07, 0)
TitleFrame.Size = UDim2.new(0.87, 0, 0.11, 0)
TitleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
TitleFrame.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
TitleFrame.BorderSizePixel = 0

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Parent = TitleFrame
TitleLabel.Position = UDim2.new(0.36, 0, -0.007, 0)
TitleLabel.Size = UDim2.new(0.28, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Era Bounty Control"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.TextWrapped = true

local stuff = Instance.new("Frame")
stuff.Name = "Stuff"
stuff.Position = UDim2.new(-0.232052192, 0, 0, 0)
stuff.Size = UDim2.new(0.217548952, 0, 1, 0)
stuff.Visible = false
stuff.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
stuff.BackgroundTransparency = 0
stuff.BorderSizePixel = 0
stuff.BorderColor3 = Color3.new(0, 0, 0)
stuff.ZIndex = 0
stuff.Parent = MainFrame

local corner = Instance.new("UICorner")
corner.Parent = stuff

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(59, 59, 59)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
}
gradient.Rotation = 42
gradient.Offset = Vector2.new(-0.3, -0.4)  -- X, Y offset
gradient.Parent = stuff

local inner = Instance.new("Frame")
inner.Name = "Inner"
inner.Position = UDim2.new(0, 0, 0.03, 0)
inner.Size = UDim2.new(0.99999994, 0, 0.949999988, 0)
inner.Visible = true
inner.BackgroundColor3 = Color3.new(1, 1, 1)
inner.BackgroundTransparency = 1
inner.BorderSizePixel = 0
inner.BorderColor3 = Color3.new(0, 0, 0)
inner.ZIndex = 1
inner.Parent = stuff

local layout = Instance.new("UIListLayout")
layout.Parent = inner
layout.Padding = UDim.new(0, 8)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

local mainTab = Instance.new("Frame")
mainTab.Name = "MainTab"
mainTab.Position = UDim2.new(0, 0, -1.04378273e-07, 0)
mainTab.Size = UDim2.new(0.916666687, 0, 0.0799999982, 0)
mainTab.AnchorPoint = Vector2.new(0, 0)
mainTab.Visible = true
mainTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainTab.BackgroundTransparency = 0.4
mainTab.BorderSizePixel = 0
mainTab.BorderColor3 = Color3.new(0, 0, 0)
mainTab.LayoutOrder = 1
mainTab.ZIndex = 0
mainTab.Parent = inner

local corner = Instance.new("UICorner")
corner.Parent = mainTab

local MainButton = Instance.new("TextButton")
MainButton.Name = "Button"
MainButton.Position = UDim2.new(0.5, 0, 0.470954746, 0)
MainButton.Size = UDim2.new(1, 0, 0.685389459, 0)
MainButton.AnchorPoint = Vector2.new(0.5, 0.5)
MainButton.Visible = true
MainButton.BackgroundColor3 = Color3.new(1, 1, 1)
MainButton.BackgroundTransparency = 1
MainButton.BorderSizePixel = 0
MainButton.BorderColor3 = Color3.new(0, 0, 0)
MainButton.ZIndex = 1
MainButton.Text = "Main"
MainButton.TextColor3 = Color3.new(1, 1, 1)
MainButton.TextSize = 14
MainButton.TextScaled = true
MainButton.Font = Enum.Font.FredokaOne
MainButton.AutoButtonColor = true
MainButton.Parent = mainTab

local playerTab = Instance.new("Frame")
playerTab.Name = "PlayerTab"
playerTab.Position = UDim2.new(0, 0, -1.04378273e-07, 0)
playerTab.Size = UDim2.new(0.916666687, 0, 0.0799999982, 0)
playerTab.AnchorPoint = Vector2.new(0, 0)
playerTab.Visible = true
playerTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerTab.BackgroundTransparency = 0.4
playerTab.BorderSizePixel = 0
playerTab.BorderColor3 = Color3.new(0, 0, 0)
playerTab.LayoutOrder = 2
playerTab.ZIndex = 0
playerTab.Parent = inner

local corner = Instance.new("UICorner")
corner.Parent = playerTab

local PlayerButton = Instance.new("TextButton")
PlayerButton.Name = "Button"
PlayerButton.Position = UDim2.new(0.5, 0, 0.470954746, 0)
PlayerButton.Size = UDim2.new(1, 0, 0.685389459, 0)
PlayerButton.AnchorPoint = Vector2.new(0.5, 0.5)
PlayerButton.Visible = true
PlayerButton.BackgroundColor3 = Color3.new(1, 1, 1)
PlayerButton.BackgroundTransparency = 1
PlayerButton.BorderSizePixel = 0
PlayerButton.BorderColor3 = Color3.new(0, 0, 0)
PlayerButton.ZIndex = 1
PlayerButton.Text = "Player"
PlayerButton.TextColor3 = Color3.new(1, 1, 1)
PlayerButton.TextSize = 14
PlayerButton.TextScaled = true
PlayerButton.Font = Enum.Font.FredokaOne
PlayerButton.AutoButtonColor = true
PlayerButton.Parent = playerTab

local button = Instance.new("TextButton")
button.Name = "Button"
button.Position = UDim2.new(-0.0562001951, 0, 0.458144844, 0)
button.Size = UDim2.new(0, 25, 0, 25)
button.AnchorPoint = Vector2.new(0, 0)
button.Visible = true
button.BackgroundColor3 = Color3.new(1, 1, 1)
button.BackgroundTransparency = 1
button.BorderSizePixel = 0
button.BorderColor3 = Color3.new(0, 0, 0)
button.ZIndex = 1
button.AutoButtonColor = true
button.Text = "<"
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 14
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.Parent = MainFrame

local gradient = gradient
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local fadeInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local targetPositionIn = UDim2.new(-0.232, 0, 0, 0)
local targetPositionOut = UDim2.new(0.038, 0, 0, 0)

local buttonPositionIn = UDim2.new(-0.277, 0, 0.458, 0)
local buttonPositionOut = UDim2.new(-0.058, 0, 0.458, 0)

local fadeValue = Instance.new("NumberValue")
fadeValue.Value = 1

fadeValue.Changed:Connect(function(val)
	gradient.Transparency = NumberSequence.new(val)
end)

local function setInnerFramesVisible(visible)
    for _, obj in pairs(inner:GetChildren()) do
        if obj:IsA("Frame") and obj.Name ~= "MainTab" and obj.Name ~= "PlayerTab" then
            obj.Visible = visible
        end
    end
end

local function moveIn()
    stuff.Visible = true
    fadeValue.Value = 1
    TweenService:Create(stuff, tweenInfo, {Position = targetPositionIn}):Play()
    TweenService:Create(button, tweenInfo, {Rotation = 180, Position = buttonPositionIn}):Play()
    TweenService:Create(fadeValue, fadeInfo, {Value = 0}):Play()

    task.delay(0.05, function()
        setInnerFramesVisible(true)
    end)
end

local function moveOut()
    setInnerFramesVisible(false)

    local tween = TweenService:Create(stuff, tweenInfo, {Position = targetPositionOut})
    tween:Play()
    TweenService:Create(button, tweenInfo, {Rotation = 0, Position = buttonPositionOut}):Play()
    TweenService:Create(fadeValue, fadeInfo, {Value = 1}):Play()

    tween.Completed:Once(function()
        stuff.Visible = false
    end)
end

button.Activated:Connect(function()
	if stuff.Visible == false then
		moveIn()
	else
		moveOut()
	end
end)

local function switchTab(tabName)
    if tabName == "Main" then
        PlayerF.Visible = false
        BountyF.Visible = true
    elseif tabName == "Player" then
        PlayerF.Visible = true
        BountyF.Visible = false
    end
end

MainButton.Activated:Connect(function()
    switchTab("Main")
end)

PlayerButton.Activated:Connect(function()
    switchTab("Player")
end)

local TitleSize = Instance.new("UITextSizeConstraint")
TitleSize.Parent = TitleLabel
TitleSize.MaxTextSize = 28

local TitleAspect = Instance.new("UIAspectRatioConstraint")
TitleAspect.Parent = TitleFrame
TitleAspect.AspectRatio = 14.39

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleFrame

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Parent = TitleFrame
TitleGradient.Rotation = 42
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(59, 59, 59)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
}

local MainAspect = Instance.new("UIAspectRatioConstraint")
MainAspect.Parent = MainFrame
MainAspect.AspectRatio = 1.79

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainGradient = Instance.new("UIGradient")
MainGradient.Parent = MainFrame
MainGradient.Offset = Vector2.new(0, 1.2)  -- X, Y offset
MainGradient.Rotation = 42
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(59, 59, 59)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
}

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

MainFrame.InputChanged:Connect(function(input)
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

GoToB.Activated:Connect(function()
    local targetName = PlayerNameThing.Text
    if not targetName or targetName == "" then return end

    local targetPlayer
for _, p in ipairs(Players:GetPlayers()) do
    if p.Name:lower():find(targetName:lower()) then
        targetPlayer = p
        break
    end
end
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        return 
    end

    local targetHRP = targetPlayer.Character.HumanoidRootPart
    local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if localHRP then
        localHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
    end
end)

ViewB.Activated:Connect(function()
    local targetName = PlayerNameThing.Text
    if not targetName or targetName == "" then return end

    if viewing then
        viewing = false
        Camera.CameraSubject = lastCameraSubject or LocalPlayer.Character:FindFirstChild("Humanoid")
        ViewB.Text = "View"
        return
    end

    targetPlayer = Players:FindFirstChild(targetName)
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Humanoid") then return end

    viewing = true
    lastCameraSubject = Camera.CameraSubject
    Camera.CameraSubject = targetPlayer.Character.Humanoid
    ViewB.Text = "Unview"
end)

BringB.Activated:Connect(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local VirtualInputManager = game:GetService("VirtualInputManager")

    local targetName = PlayerNameThing.Text
    if not targetName or targetName == "" then return end

    local targetPlayer = Players:FindFirstChild(targetName)
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local tool = LocalPlayer.Backpack:WaitForChild("Combat")
    char.Humanoid:EquipTool(tool)

    local originalCFrame = char.HumanoidRootPart.CFrame
    local targetHRP = targetPlayer.Character.HumanoidRootPart

    local teleporting = true
    spawn(function()
        while teleporting do
            char.HumanoidRootPart.CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)
            wait(0.05)
        end
    end)

    wait(0.2)
    tool:Activate()
    wait(5)

    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.G, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.G, false, game)

    wait(0.2)
    teleporting = false

    char.HumanoidRootPart.CFrame = originalCFrame
    wait(0.1)

    -- Drop target
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.G, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.G, false, game)
end)

KnockB.Activated:Connect(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local targetName = PlayerNameThing.Text
    if not targetName or targetName == "" then return end

    local targetPlayer = Players:FindFirstChild(targetName)
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

    local targetHRP = targetPlayer.Character.HumanoidRootPart
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end

    myChar.HumanoidRootPart.CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)

    local tool = LocalPlayer.Backpack:FindFirstChild("Combat") or myChar:FindFirstChild("Combat")
    if tool then
        myChar.Humanoid:EquipTool(tool)
        wait(0.1)
        tool:Activate()
    end
end)

local function parseBountyAmount(text)
    local lower = text:lower():gsub("%s", "") -- remove spaces and lowercase
    local multiplier = 1

    if lower:find("k") then
        multiplier = 1000
        lower = lower:gsub("k", "")
    elseif lower:find("m") then
        multiplier = 1000000
        lower = lower:gsub("m", "")
    elseif lower:find("b") then
        multiplier = 1000000000
        lower = lower:gsub("b", "")
    end

    local numberValue = tonumber(lower)
    if numberValue then
        return numberValue * multiplier
    else
        return 0
    end
end

local function updateDHC(text)
    local amount = parseBountyAmount(text)
    local dhc = math.floor(amount * 0.65)
    BountyDHC.Text = tostring(dhc)
end

local function setBountyImageFromInGame(namePart)
    local matchedPlayer
    local lowerNamePart = namePart:lower()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():sub(1, #lowerNamePart) == lowerNamePart then
            matchedPlayer = plr
            break
        end
    end

    if matchedPlayer then
        BountyPlayerName.Text = matchedPlayer.Name
        local userId = matchedPlayer.UserId
        BountyUserID.Text = tostring(userId)

        local success, thumb = pcall(function()
            return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)

        if success then
            BountyUserImage.Image = thumb
        else
            BountyUserImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        end
    else
        BountyUserImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        BountyUserID.Text = ""
    end
end

local function sendBounty()
    if BountyPlayerName.Text ~= "" and BountyAmount.Text ~= "" then
        local amount = parseBountyAmount(BountyAmount.Text)
        if amount > 0 then
            local args = {BountyPlayerName.Text, amount}
            pcall(function()
                BOUNTY_REMOTE:InvokeServer(unpack(args))
            end)
        end
    end
    BountyAmount.Text = ""
    BountyDHC.Text = ""
end

BountyPlayerName.FocusLost:Connect(function(enterPressed)
    if enterPressed and BountyPlayerName.Text ~= "" then
        setBountyImageFromInGame(BountyPlayerName.Text)
    end
end)

BountyAmount:GetPropertyChangedSignal("Text"):Connect(function()
    updateDHC(BountyAmount.Text)
end)

BountyAmount.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        sendBounty()
    end
end)

local function setPlayerImageFromIngame(namePart)
    local matchedPlayer
    local lowerNamePart = namePart:lower()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():sub(1, #lowerNamePart) == lowerNamePart then
            matchedPlayer = plr
            break
        end
    end

    if matchedPlayer then
        PlayerNameThing.Text = matchedPlayer.Name
        local userId = matchedPlayer.UserId
        PlayerUserID.Text = userId
        local success, thumb = pcall(function()
            return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)

        if success then
            PlayerUserImage.Image = thumb
        else
            PlayerUserImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        end
    else
        PlayerUserImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    end
end

local function formatNumberWithCommas(number)
    local formatted = tostring(number)
    while true do
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then break end
    end
    return formatted
end

local CurrencyConnection

local function updatePlayerCurrency()
    local playerName = PlayerNameThing.Text
    local player = Players:FindFirstChild(playerName)

    if player and player:FindFirstChild("DataFolder") and player.DataFolder:FindFirstChild("Currency") then
        local currencyValue = player.DataFolder.Currency.Value
        PlayerDHC.Text = "$" .. formatNumberWithCommas(currencyValue)

        if CurrencyConnection then
            CurrencyConnection:Disconnect()
        end

        CurrencyConnection = player.DataFolder.Currency.Changed:Connect(function(newValue)
            PlayerDHC.Text = "$" .. formatNumberWithCommas(newValue)
        end)
    else
        PlayerDHC.Text = "0"
        if CurrencyConnection then
            CurrencyConnection:Disconnect()
            CurrencyConnection = nil
        end
    end
end

local function formatWithCommas(amount)
    local formatted = tostring(amount):reverse():gsub("(%d%d%d)", "%1,")
    if formatted:sub(-1) == "," then
        formatted = formatted:sub(1, -2)
    end
    return formatted:reverse()
end

local function trackAmountSpent()
    local player = Players:FindFirstChild(PlayerNameThing.Text)
    if not player or not player:FindFirstChild("DataFolder") or not player.DataFolder:FindFirstChild("Currency") then
        AmountSpent.Text = "0"
        return
    end

    local currency = player.DataFolder.Currency
    local lastValue = currency.Value
    local totalSpent = 0
    AmountSpent.Text = formatWithCommas(totalSpent)
    AmountSpent.TextColor3 = Color3.new(1, 0, 0)

    currency.Changed:Connect(function(newValue)
        local delta = lastValue - newValue
        if delta > 0 then
            totalSpent = totalSpent + delta
            AmountSpent.Text = formatWithCommas(totalSpent)
        end
        lastValue = newValue
    end)
end

PlayerNameThing.FocusLost:Connect(function(enterPressed)
    if enterPressed and PlayerNameThing.Text ~= "" then
        setPlayerImageFromIngame(PlayerNameThing.Text)
        updatePlayerCurrency()
        trackAmountSpent()
    end
end)

local function UpdateBuyerUI()
    local buyerId = getgenv().Buyer
    if not buyerId then return end

    local buyer = Players:GetPlayerByUserId(buyerId)
    if buyer then
        local userId = buyer.UserId
        local username = buyer.Name
        local thumbnail = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

        TargetUserImage.Image = thumbnail
        TargetUsername.Text = username
        TargetUserID.Text = tostring(userId)
        Amount.Text = buyer.DataFolder.Currency.Value
    else
        TargetUserImage.Image = ""
        TargetUsername.Text = "Not in-game"
        TargetUserID.Text = tostring(getgenv().Buyer)
        Amount.Text = ""
    end
end

UpdateBuyerUI()

local initialTarget = 0
local lastCurrency = 0

local function updateTargetValues()
    local text = GivingBox.Text
    local amountToGive = parseBountyAmount(text)
    if amountToGive <= 0 then return end

    local buyerId = getgenv().Buyer
    if not buyerId then return end
    local buyer = Players:GetPlayerByUserId(buyerId)
    if not buyer then return end

    local currentCurrency = buyer:FindFirstChild("DataFolder") 
                            and buyer.DataFolder:FindFirstChild("Currency") 
                            and buyer.DataFolder.Currency.Value or 0

    if initialTarget == 0 then
        initialTarget = currentCurrency + amountToGive
        lastCurrency = currentCurrency
    end

    local gained = math.max(0, currentCurrency - lastCurrency)
    lastCurrency = currentCurrency

    local remaining = math.max(0, initialTarget - currentCurrency)
    
    TargetAmount.Text = formatNumberWithCommas(initialTarget)
    TargetRemaining.Text = formatNumberWithCommas(remaining)
end

GivingBox:GetPropertyChangedSignal("Text"):Connect(function()
    initialTarget = 0
    updateTargetValues()
end)

GivingBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        initialTarget = 0
        updateTargetValues()
    end
end)
spawn(function()
    while true do
        wait(0.1)
        updateTargetValues()
    end
end)

for i, v in pairs(getconnections(LocalPlayer.Idled)) do
    v:Disable()
end
