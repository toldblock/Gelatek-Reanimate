local Global = (getgenv and getgenv()) or getfenv(0)
Global.Gelatek_Reanimate_Settings = {
    ['Events'] = {}, -- dont edit those
    ['Bullet'] = nil,-- dont edit those
    ['ScriptStopped'] = false,-- dont edit those
    ['FreeMode'] = false,
    ['CSCollisionsOff'] = false
}
setfpscap(65)
local AntiSleepBoost = 10
local Global = (getgenv and getgenv()) or getfenv(0)
local Cos, Sin, Rad, Time = math.cos, math.sin, math.rad, 0
local CFrame_new, CFrame_Angles = CFrame.new, CFrame.Angles
local AnglesZero = CFrame_Angles(0,0,0)
local Check, CFrameCheck = false, false
local Insert = table.insert 
local Loops, Hats  = {}, {}
local AntiSleep = CFrame_new()
local FreeMode = Global.Gelatek_Reanimate_Settings['FreeMode']
local Collisions = Global.Gelatek_Reanimate_Settings['CSCollisionsOff']

local function Get(OfClass, Parent, LookingFor)
    if OfClass then
        return Parent:FindFirstChildOfClass(LookingFor) 
    end
    return Parent:FindFirstChild(LookingFor) 
end


local Workspace = Get(true, game, "Workspace")
local RunService = Get(true, game, "RunService")
local Players = Get(true, game, "Players")

if Workspace:FindFirstChild("Raw_Reanimation") then
    Workspace:FindFirstChild("Raw_Reanimation"):Destroy()
end

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local Humanoid = Get(true, Character, "Humanoid")
local RootPart = Get(false, Character, "HumanoidRootPart")
Character.Archivable = true

do --[[ Rename Hats (By Mizt) ]] --
	local HatsNames = {}
	for Index, Accessory in pairs(Character:GetDescendants()) do
		if Accessory:IsA("Accessory") then
			if HatsNames[Accessory.Name] then
				if HatsNames[Accessory.Name] == "Unknown" then
					HatsNames[Accessory.Name] = {}
				end
				Insert(HatsNames[Accessory.Name], Accessory)
			else
				HatsNames[Accessory.Name] = "Unknown"
			end	
		end
	end
	for Index, Tables in pairs(HatsNames) do
		if type(Tables) == "table" then
			local Number = 1
			for Index2, Names in ipairs(Tables) do
				Names.Name = Names.Name .. Number
				Number = Number + 1
			end
		end
	end
	HatsNames = nil  
end

local FakeCharacter = game:GetObjects("rbxassetid://8440552086")[1]
FakeCharacter.Parent = Workspace
FakeCharacter.Name = "Raw_Reanimation"
--Workspace.CurrentCamera.CameraSubject = Workspace:FindFirstChildOfClass("Part")
FakeCharacter.HumanoidRootPart.CFrame = RootPart.CFrame * CFrame.new(0,5,0) 
for _, Part in pairs(FakeCharacter:GetDescendants()) do
    if pcall(function() Part.Transparency = 1 end) then
       Part.Transparency = 1
    end
    if pcall(function() Part.Anchored = false end) then
        Part.Anchored = false
    end
end

local HowManyPlayers = 0
local SimRadiusOffset = 0; do -- [[ Get Offset Value ]] --
    for i,v in next, Players:GetPlayers() do
        if v ~= LocalPlayer then
            HowManyPlayers = HowManyPlayers + i
            SimRadiusOffset = SimRadiusOffset + gethiddenproperty(v, "SimulationRadius")
        end
    end
end

local Physics = settings().Physics
Physics.AllowSleep = false
Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
Physics.ThrottleAdjustTime = 1/0

Workspace.InterpolationThrottling = "Disabled"
Workspace.Retargeting = "Disabled"
sethiddenproperty(Workspace, "SignalBehavior", "Immediate")

Insert(Loops, RunService.Stepped:Connect(function()
    sethiddenproperty(LocalPlayer, "MaximumSimulationRadius", 1000*HowManyPlayers)
    sethiddenproperty(LocalPlayer, "SimulationRadius", 1000*HowManyPlayers)
    
    Time = Time + 1
    AntiSleep = CFrame_new(1.7 / 110 * Cos(Time / 8), 1.4 / 110 * Sin(Time / 6),0)
    
    if Time == 9e9 then
        Time = 0
    end
end))

local BackupCFrame = RootPart.CFrame

for i,v in pairs(Character:GetChildren()) do
    if v:IsA("Accessory") then
        Insert(Hats, v.Handle)
    end
end

Insert(Loops, RunService.Heartbeat:Connect(function()
    for i, Part0 in pairs(Hats) do
        if Part0 and Part0.Parent and isnetworkowner(Part0) and Check then
            Part0.Velocity = Vector3.new(FakeCharacter.HumanoidRootPart.Velocity.X * (Part0.Mass*15), 40, FakeCharacter.HumanoidRootPart.Velocity.Z * (Part0.Mass*15))
            if CFrameCheck then Part0.CFrame = FakeCharacter.HumanoidRootPart.CFrame * AntiSleep end
        end
    end
end))


LocalPlayer.Character = nil
LocalPlayer.Character = FakeCharacter
RootPart.CFrame = CFrame.new(0,Workspace.FallenPartsDestroyHeight + 300,SimRadiusOffset*2)
FakeCharacter.HumanoidRootPart.CFrame = CFrame.new(0,10,SimRadiusOffset)
FakeCharacter.HumanoidRootPart.Anchored = true
Character.Head.Anchored = true
wait(Players.RespawnTime + 0.35)
Character:FindFirstChild("Animate"):Destroy()
Character.Head.Anchored = false
RootPart.Velocity = Vector3.new(3000,0,0)
Humanoid:ChangeState(15)
for i,v in pairs(Humanoid:GetPlayingAnimationTracks()) do
    v:Stop()
end

Check = true
CFrameCheck = true

for i,v in pairs(Character:GetChildren()) do
    if v:IsA("Accessory") then
        v.Handle.Velocity = Vector3.new(0,500,0)
    end
end 

wait(2)
FakeCharacter.HumanoidRootPart.Anchored = false
FakeCharacter.HumanoidRootPart.CFrame = BackupCFrame * CFrame_new(0,60,0)
FakeCharacter.HumanoidRootPart.Velocity = Vector3.new()
FakeCharacter:FindFirstChildOfClass("Humanoid").Died:Once(function()
    for i, v in pairs(Loops) do
        v:Disconnect()
    end
    for i,v in pairs(Global.Gelatek_Reanimate_Settings['Events']) do
       v:Disconnect() 
    end
    Global.Gelatek_Reanimate_Settings['ScriptStopped'] = true; delay(0.3, function()
        Global.Gelatek_Reanimate_Settings['ScriptStopped'] = false
    end)
    Global.Gelatek_Reanimate_Settings['Bullet'] = nil
    
    LocalPlayer.Character = Character
    Character.Parent = Workspace
    Character:BreakJoints()
    FakeCharacter:Destroy()
end)

local CharDescendants = Character:GetDescendants()
for i,v in pairs(CharDescendants) do
    if v:IsA("Accessory") then
        local Accessory = v:Clone()
        Accessory.Parent = FakeCharacter
        local Handle = Accessory:FindFirstChild("Handle")
        Handle.Transparency = 1
    	pcall(function() Handle:FindFirstChildOfClass("Weld"):Destroy() end)
    	local NewWeld = Instance.new("Weld")
    	NewWeld.Name = "AccessoryWeld"
    	NewWeld.Part0 = Handle
    	local Attachment = Handle:FindFirstChildOfClass("Attachment")
    	if Attachment then
    		NewWeld.C0 = Attachment.CFrame
    		NewWeld.C1 = FakeCharacter:FindFirstChild(tostring(Attachment), true).CFrame
    		NewWeld.Part1 = FakeCharacter:FindFirstChild(tostring(Attachment), true).Parent
    	else
    		NewWeld.Part1 = FakeCharacter:FindFirstChild("Head")
    		NewWeld.C1 = CFrame.new(0,FakeCharacter:FindFirstChild("Head").Size.Y / 2,0) * Accessory.AttachmentPoint:Inverse()
    	end
    	Handle.CFrame = NewWeld.Part1.CFrame * NewWeld.C1 * NewWeld.C0:Inverse()
    	NewWeld.Parent = Accessory.Handle
    end
end

local FakeCharDesc = FakeCharacter:GetDescendants()
local function GetHandleFromMeshId(RealMesh)
    for i,v in pairs(CharDescendants) do
        if v:IsA("Accessory") then
            local Handle = v:FindFirstChild("Handle")
            local Mesh = Handle:FindFirstChild("SpecialMesh") or Handle:FindFirstChild("Mesh") or Handle
            
            if Mesh.MeshId == RealMesh then
                FakeCharacter:FindFirstChild(v.Name):Destroy()
                warn(v, v.Parent, v.Parent.Parent, Mesh)
                return Handle
            end
        end
    end
end

local Torso, RightArm, LeftArm, RightLeg, LeftLeg;

if not FreeMode then
    Torso = GetHandleFromMeshId("rbxassetid://6963024829");
    LeftArm = GetHandleFromMeshId("rbxassetid://11449386931")
    RightArm = GetHandleFromMeshId("rbxassetid://11449388499")
    LeftLeg = GetHandleFromMeshId("rbxassetid://11263221350")
    RightLeg = GetHandleFromMeshId("rbxassetid://11159370334")
else
    Torso = GetHandleFromMeshId("rbxassetid://4819720316");
    LeftArm = GetHandleFromMeshId("rbxassetid://4094864753")
    RightArm = GetHandleFromMeshId("rbxassetid://4154474745")
    LeftLeg = GetHandleFromMeshId("rbxassetid://4324138105") --GetHandleFromMeshId("rbxassetid://3030546036")
    RightLeg = GetHandleFromMeshId("rbxassetid://4489232754")
end

local function ConnectTo(Part0, Part1, Offset)
    if Part0 and isnetworkowner(Part0) then
        Part0.CFrame = Part1.CFrame * Offset * AntiSleep
    end
end

task.wait(0.5)

local FakeTorso = FakeCharacter:FindFirstChild("Torso")
local FakeRA, FakeLA = FakeCharacter:WaitForChild("Right Arm"), FakeCharacter:WaitForChild("Left Arm")
local FakeRL, FakeLL = FakeCharacter:WaitForChild("Right Leg"), FakeCharacter:WaitForChild("Left Leg")

if not FreeMode then
    Insert(Loops, RunService.Heartbeat:Connect(function()
        ConnectTo(Torso, FakeTorso, AnglesZero)
        ConnectTo(LeftArm, FakeLA, CFrame_Angles(Rad(-125), 0, 0))
        ConnectTo(RightArm, FakeRA, CFrame_Angles(Rad(-125), 0, 0))
        ConnectTo(LeftLeg, FakeLL, CFrame_Angles(0, Rad(-90), Rad(90)))
        ConnectTo(RightLeg, FakeRL, CFrame_Angles(0, Rad(-90), Rad(90)))
        
        for i, Hat in pairs(Hats) do
            if Hat and Hat.Parent and FakeCharacter:FindFirstChild(Hat.Parent.Name) then
                ConnectTo(Hat, FakeCharacter:FindFirstChild(Hat.Parent.Name).Handle, AnglesZero)
            end
        end
    end))
else
    Insert(Loops, RunService.Heartbeat:Connect(function()
        ConnectTo(Torso, FakeTorso, CFrame_Angles(0, 0, Rad(-15)))
        ConnectTo(LeftArm, FakeLA, CFrame_Angles(Rad(90), 0, Rad(90)))
        ConnectTo(RightArm, FakeRA, CFrame_Angles(Rad(90), 0, Rad(-90)))
        ConnectTo(LeftLeg, FakeLL, CFrame_Angles(Rad(-90), 0, Rad(-90)))
        ConnectTo(RightLeg, FakeRL, CFrame_Angles(Rad(-90), 0, Rad(90)))
        
        for i, Hat in pairs(Hats) do
            if Hat and Hat.Parent and FakeCharacter:FindFirstChild(Hat.Parent.Name) then
                ConnectTo(Hat, FakeCharacter:FindFirstChild(Hat.Parent.Name).Handle, AnglesZero)
            end
        end
    end))
end

if Collisions then
    Insert(Loops, RunService.Stepped:Connect(function()
        for i, v in pairs(FakeCharDesc) do
            if v and v.Parent and v:IsA("BasePart") then
               v.CanCollide = false
            end
        end
    end))
end
Character.Parent = FakeCharacter
CFrameCheck = false
Workspace.CurrentCamera.CameraSubject = FakeCharacter:FindFirstChildOfClass("Humanoid")
AntiSleepBoost = 1.35
