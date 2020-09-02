TOOL.Category = "Render" 
TOOL.Name = "#Tool.cel.name"
TOOL.Information = {
    { name = "left" },
    { name = "right" },
    { name = "reload" }
}

if (CLIENT) then
    language.Add("Tool.cel.name", "Cel Shading")
    language.Add("Tool.cel.desc", "Adds Cel Shading like effects to entities")
    language.Add("Tool.cel.left", "Apply")
    language.Add("Tool.cel.right", "Copy")
    language.Add("Tool.cel.reload", "Remove")
end

CreateConVar("enable_gm13_for_players", "0", FCVAR_REPLICATED)
CreateConVar("enable_celshading_on_players", "1", FCVAR_REPLICATED)

if (CLIENT) then
    CreateClientConVar("cel_h_mode", 1, false, true)
    CreateClientConVar("cel_h_colour_r", 255, false, true)
    CreateClientConVar("cel_h_colour_g", 0, false, true)
    CreateClientConVar("cel_h_colour_b", 0, false, true)
    CreateClientConVar("cel_h_size", 0.3, false, true)
    CreateClientConVar("cel_h_shake", 0, false, true)
    CreateClientConVar("cel_h_13_passes", 1, false, true)
    CreateClientConVar("cel_h_13_additive", 1, false, true)
    CreateClientConVar("cel_h_13_throughwalls", 0, false, true)
    CreateClientConVar("cel_apply_texture", 0, false, true)
    CreateClientConVar("cel_texture", 1, false, true)
    CreateClientConVar("cel_texture_mimic_halo", 0, false, true)
    CreateClientConVar("cel_colour_r", 255, false, true)
    CreateClientConVar("cel_colour_g", 255, false, true)
    CreateClientConVar("cel_colour_b", 255, false, true)
    CreateClientConVar("cel_sobel_thershold", 0.2, false, true)
    CreateClientConVar("cel_h_12_selected_halo", 1, false, true)
    CreateClientConVar("cel_h_12_size_2", 0.3, false, true)
    CreateClientConVar("cel_h_12_shake_2", 0, false, true)
    CreateClientConVar("cel_h_12_colour_r_2", 0, false, true)
    CreateClientConVar("cel_h_12_colour_g_2", 0, false, true)
    CreateClientConVar("cel_h_12_colour_b_2", 0, false, true)
    CreateClientConVar("cel_h_12_singleshake", 0, false, true)
    CreateClientConVar("cel_h_12_two_layers", 1, false, true)
    CreateClientConVar("cel_apply_yourself", 0, false, true)
end

-- -------------
-- ACTIONS
-- -------------

local function GetEnt(ply, trace)
    if GetConVar("enable_celshading_on_players"):GetInt() == 1 and
       ply:GetInfo("cel_apply_yourself") == "1" then

        return ply
    end

    local ent = trace.Entity

    if ent and IsValid(ent) and ent:IsValid() and ent.AttachedEntity and ent.AttachedEntity:IsValid() then
        ent = ent.AttachedEntity
    end

    return ent
end

local function IsActionValid(ent, check_ent_cel)
    if check_ent_cel and not ent.cel or
       ent:IsPlayer() and GetConVar("enable_celshading_on_players"):GetInt() == 0 or
       not IsValid(ent) or not ent:IsValid() then

        return false
    end

    return true
end

function TOOL:LeftClick(trace)
    local ply = self:GetOwner()
    local ent = GetEnt(ply, trace)

    if not IsActionValid(ent) then 
        return false
    end
    
    if CLIENT then return true end

    local mode = ply:GetInfo("cel_h_mode")

    if mode == "3" and not ply:IsAdmin() and ply:GetInfo("enable_gm13_for_players") == "0" then
        ply:PrintMessage(HUD_PRINTTALK, "GM 13 Halos are admin only.")

        return
    end

    local h_data

    -- Sobel
    if mode == "1" then
        h_data = { SobelThershold = (ply:GetInfo("cel_sobel_thershold")), Mode = mode }
    -- Halos
    else
        local r = ply:GetInfo("cel_h_colour_r")
        local g = ply:GetInfo("cel_h_colour_g")
        local b = ply:GetInfo("cel_h_colour_b")            
        local size = ply:GetInfo("cel_h_size")
        local shake = ply:GetInfo("cel_h_shake")

        -- GMod 12 halo
        if mode == "2" then
            local layers = ply:GetInfo("cel_h_12_two_layers")
            local singleshake = ply:GetInfo("cel_h_12_singleshake")
            local r2 = ply:GetInfo("cel_h_12_colour_r_2")
            local g2 = ply:GetInfo("cel_h_12_colour_g_2")
            local b2 = ply:GetInfo("cel_h_12_colour_b_2")     
            local size2 = ply:GetInfo("cel_h_12_size_2")
            local shake2 = ply:GetInfo("cel_h_12_shake_2")

            h_data = {
                Mode = mode, Layers = layers, SingleShake = singleshake,
                Layer1 = { Color = Color(r, g, b, 255), Size = size, Shake = shake },
                Layer2 = { Color = Color(r2, g2, b2, 255), Size = size2, Shake = shake2 },
            }

        -- GMod 13 halo
        elseif mode == "3" then
            local passes = ply:GetInfo("cel_h_13_passes")
            local additive = ply:GetInfo("cel_h_13_additive")
            local throughwalls = ply:GetInfo("cel_h_13_throughwalls")

            h_data = { Color = Color(r, g, b, 255), Size = size, Shake = shake, Mode = mode, Passes = passes, Additive = additive, ThroughWalls = throughwalls }
        end
    end

    -- Texture and texture color
    local c_data, t_data
    if (ply:GetInfo("cel_apply_texture") == "1") then
        local r, g, b
        if (ply:GetInfo("cel_texture_mimic_halo") == "1") then
            r = ply:GetInfo("cel_h_colour_r")
            g = ply:GetInfo("cel_h_colour_g")
            b = ply:GetInfo("cel_h_colour_b")
        else
            r = ply:GetInfo("cel_colour_r")
            g = ply:GetInfo("cel_colour_g")
            b = ply:GetInfo("cel_colour_b")
        end
        c_data = { Color = Color(r, g, b, 255), Mode = mode }
        t_data = { MaterialOverride = CST.TEXTURES[tonumber(ply:GetInfo("cel_texture"))] }
    end

    -- Set halo
    CST:SetHalo(nil, ent, h_data)

    -- Set color
    if c_data and (table.Count(c_data) > 0) then
        CST:SetColor(nil, ent, c_data)
    else
        CST:RemoveColor(ent)
    end

    -- Set texture
    if t_data and (table.Count(t_data) > 0) then
        CST:SetMaterial(nil, ent, t_data)
    else
        CST:RemoveMaterial(ent)
    end

    return true
end

function TOOL:RightClick(trace)
    local ply = self:GetOwner()
    local ent = GetEnt(ply, trace)

    if not IsActionValid(ent) then 
        return false
    end

    if CLIENT then return true end

    local mat = ent:GetMaterial()

    local texture_enabled = 0
    for k,v in pairs(CST.TEXTURES) do
        if mat == v then
            texture_enabled = 1

            ply:ConCommand("cel_texture " .. tostring(k))
        end
    end

    ply:ConCommand("cel_apply_yourself " .. (ent == ply and "1" or "0"))

    ply:ConCommand("cel_apply_texture " .. tostring(texture_enabled))
    
    local clr = ent:GetColor()
    ply:ConCommand("cel_colour_r " .. tostring(clr.r))
    ply:ConCommand("cel_colour_g " .. tostring(clr.g))
    ply:ConCommand("cel_colour_b " .. tostring(clr.b))
    
    local mode = ent.cel.Mode
    ply:ConCommand("cel_h_mode " .. tostring(mode))

    if (mode == "1") then
        ply:ConCommand("cel_sobel_thershold " .. tostring(ent.cel.SobelThershold))
        ply:ConCommand("cel_h_colour_r 255")
        ply:ConCommand("cel_h_colour_g 255")
        ply:ConCommand("cel_h_colour_b 255")
    elseif (mode == "2") then
        ply:ConCommand("cel_h_size " .. tostring(ent.cel.Layer1.Size))
        ply:ConCommand("cel_h_shake " .. tostring(ent.cel.Layer1.Shake))
        ply:ConCommand("cel_h_colour_r " .. tostring(ent.cel.Layer1.Color.r))
        ply:ConCommand("cel_h_colour_g " .. tostring(ent.cel.Layer1.Color.g))
        ply:ConCommand("cel_h_colour_b " .. tostring(ent.cel.Layer1.Color.b))
        ply:ConCommand("cel_h_12_size_2 " .. tostring(ent.cel.Layer2.Size))
        ply:ConCommand("cel_h_12_shake_2 " .. tostring(ent.cel.Layer2.Shake))
        ply:ConCommand("cel_h_12_colour_r_2 " .. tostring(ent.cel.Layer2.Color.r))
        ply:ConCommand("cel_h_12_colour_g_2 " .. tostring(ent.cel.Layer2.Color.g))
        ply:ConCommand("cel_h_12_colour_b_2 " .. tostring(ent.cel.Layer2.Color.b))
        ply:ConCommand("cel_h_12_singleshake " .. tostring(ent.cel.SingleShake))
        ply:ConCommand("cel_h_12_two_layers " .. tostring(ent.cel.Layers))
    elseif (mode == "3") then
        ply:ConCommand("cel_h_size " .. tostring(ent.cel.Size))
        ply:ConCommand("cel_h_shake " .. tostring(ent.cel.Shake))
        ply:ConCommand("cel_h_colour_r " .. tostring(ent.cel.Color.r))
        ply:ConCommand("cel_h_colour_g " .. tostring(ent.cel.Color.g))
        ply:ConCommand("cel_h_colour_b " .. tostring(ent.cel.Color.b))
        ply:ConCommand("cel_h_13_passes " .. tostring(ent.cel.Passes))
        ply:ConCommand("cel_h_13_additive " .. (ent.cel.Additive and "1" or "0"))
        ply:ConCommand("cel_h_13_throughwalls " .. (ent.cel.ThroughWalls and "1" or "0"))
    end
    
    return true
end

function TOOL:Reload(trace)
    local ent = GetEnt(self:GetOwner(), trace)

    if not IsActionValid(ent) then 
        return false
    end

    if CLIENT then return true end

    CST:RemoveColor(ent)
    CST:RemoveHalo(ent)
    CST:RemoveMaterial(ent)

    return true
end

function TOOL.BuildCPanel(CPanel)
    CPanel:AddControl("Header", { Text = "#Tool.cel.name", Description = "#Tool.cel.desc" })
    CPanel:Help("")
    CPanel:AddControl("Button" , { Text  = "Open Menu", Command = "cel_menu" })       
    CPanel:Help("")
    CPanel:ControlHelp("Command: \"bind KEY cel_menu\"")
end
