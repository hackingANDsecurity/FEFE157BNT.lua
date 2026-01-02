-- FEFE157BNT HUB • Clean Dark Mod Menu

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ═════════ THEME ═════════
local Theme = {
    Bg = Color3.fromRGB(14,14,14),
    Panel = Color3.fromRGB(22,22,22),
    Btn = Color3.fromRGB(30,30,30),
    Accent = Color3.fromRGB(160,90,255),
    Text = Color3.fromRGB(235,235,235),
    Muted = Color3.fromRGB(160,160,160)
}

-- ═════════ STATE ═════════
local State = {
    WalkSpeed = false,
    InfJump = false,
    ESP = false
}

-- ═════════ GUI ═════════
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "FEFE157BNT"

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromOffset(460,330)
Main.Position = UDim2.fromScale(0.5,0.5)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.BackgroundColor3 = Theme.Bg
Main.BorderSizePixel = 0
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,12)

-- Top
local Top = Instance.new("Frame",Main)
Top.Size = UDim2.new(1,0,0,42)
Top.BackgroundColor3 = Theme.Panel
Top.BorderSizePixel = 0
Instance.new("UICorner",Top).CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel",Top)
Title.Size = UDim2.new(1,0,1,0)
Title.Text = "FEFE157BNT"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextColor3 = Theme.Accent
Title.BackgroundTransparency = 1

-- Sidebar
local Tabs = Instance.new("Frame",Main)
Tabs.Position = UDim2.fromOffset(0,42)
Tabs.Size = UDim2.fromOffset(120,288)
Tabs.BackgroundColor3 = Theme.Panel
Tabs.BorderSizePixel = 0

-- Pages
local Pages = Instance.new("Folder",Main)

-- ═════════ UI HELPERS ═════════
local function round(o,r)
    Instance.new("UICorner",o).CornerRadius = UDim.new(0,r or 6)
end

local function animate(obj,prop,val)
    TweenService:Create(obj,TweenInfo.new(.15),{[prop]=val}):Play()
end

local function toggle(text,parent,y,callback)
    local b = Instance.new("TextButton",parent)
    b.Size = UDim2.fromOffset(210,32)
    b.Position = UDim2.fromOffset(10,y)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 13
    b.TextColor3 = Theme.Text
    b.BackgroundColor3 = Theme.Btn
    b.BorderSizePixel = 0
    round(b)

    local stroke = Instance.new("UIStroke",b)
    stroke.Color = Theme.Accent
    stroke.Thickness = 0

    local on = false
    b.MouseButton1Click:Connect(function()
        on = not on
        stroke.Thickness = on and 1 or 0
        b.TextColor3 = on and Theme.Accent or Theme.Text
        callback(on)
    end)
end

local function newPage(name)
    local p = Instance.new("ScrollingFrame",Pages)
    p.Name = name
    p.Position = UDim2.fromOffset(120,42)
    p.Size = UDim2.fromOffset(340,288)
    p.CanvasSize = UDim2.fromOffset(0,500)
    p.ScrollBarThickness = 3
    p.BackgroundTransparency = 1
    p.Visible = false
    return p
end

local Local = newPage("Local")
local Universal = newPage("Universal")
local Visual = newPage("Visual")
Local.Visible = true

local function tab(name,y)
    local t = Instance.new("TextButton",Tabs)
    t.Size = UDim2.fromOffset(100,30)
    t.Position = UDim2.fromOffset(10,y)
    t.Text = name
    t.Font = Enum.Font.Gotham
    t.TextSize = 13
    t.TextColor3 = Theme.Text
    t.BackgroundColor3 = Theme.Btn
    t.BorderSizePixel = 0
    round(t)

    t.MouseButton1Click:Connect(function()
        for _,p in pairs(Pages:GetChildren()) do
            p.Visible = (p.Name == name)
        end
    end)
end

tab("Local",12)
tab("Universal",48)
tab("Visual",84)

-- ═════════ LOCAL ═════════
toggle("WalkSpeed",Local,10,function(v)
    State.WalkSpeed = v
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = v and 32 or 16 end
end)

toggle("Infinite Jump",Local,50,function(v)
    State.InfJump = v
end)

UIS.JumpRequest:Connect(function()
    if State.InfJump then
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

toggle("Fullbright",Local,90,function(v)
    Lighting.Brightness = v and 2 or 1
    Lighting.GlobalShadows = not v
end)

-- ═════════ VISUAL ═════════
toggle("ESP Names",Visual,10,function(v)
    State.ESP = v
end)

RunService.RenderStepped:Connect(function()
    if not State.ESP then return end
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
            local pos,vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis then
                local d = Drawing.new("Text")
                d.Text = p.Name
                d.Position = Vector2.new(pos.X,pos.Y)
                d.Size = 16
                d.Color = Theme.Accent
                d.Center = true
                task.delay(0,function() d:Remove() end)
            end
        end
    end
end)

-- ═════════ KEYBIND ═════════
UIS.InputBegan:Connect(function(i,g)
    if not g and i.KeyCode == Enum.KeyCode.Insert then
        Main.Visible = not Main.Visible
    end
end)
