local Frame

function CST:BuildPanel()
    -- --------
    -- WINDOW:
    -- --------

    local panelw = 510
    local panelh = 340

    if Frame then
        Frame:SetVisible(true)
        return
    end
    
    Frame = vgui.Create("DFrame")
        Frame:SetSize(panelw, panelh)
        Frame:SetPos((ScrW() - panelw) / 2, (ScrH() - panelh) / 2)
        Frame:SetTitle("#Tool.cel.name")
        Frame:SetVisible(false)
        Frame:SetDraggable(true)
        Frame:ShowCloseButton(true)
        Frame:SetDeleteOnClose(false)

    local sheet = vgui.Create("DPropertySheet", Frame)
        sheet:Dock(FILL)

    local panel1 = vgui.Create("DPanel", sheet)
        panel1.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(112, 112, 112)) end
        sheet:AddSheet("General", panel1, "icon16/application_view_list.png")

    local panel2 = vgui.Create("DPanel", sheet)
        panel2.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(112, 112, 112)) end
        sheet:AddSheet("Modes", panel2, "icon16/star.png")

    local panel3 = vgui.Create("DPanel", sheet)
        panel3.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(112, 112, 112)) end
        sheet:AddSheet("Textures", panel3, "icon16/picture.png")

    -- --------
    -- TAB 3:
    -- --------

    local TextureEnable = vgui.Create("DCheckBoxLabel", panel3)
        TextureEnable:SetPos(10, 10)
        TextureEnable:SetText("Enable Textures")
        TextureEnable:SetConVar("cel_apply_texture")
        TextureEnable:SetValue(GetConVar("cel_apply_texture"):GetInt())
        TextureEnable:SizeToContents()

    local HaloSizeLabel = vgui.Create("DLabel", panel3)
        HaloSizeLabel:SetPos(10, 32)
        HaloSizeLabel:SetText("Select:")

    local TextureType = vgui.Create("DComboBox", panel3)
        TextureType:SetPos(10, 57)
        TextureType:SetSize(190, 25)
        TextureType:SetValue(CST.TEXTURES[GetConVar("cel_texture"):GetInt()])
        for k,v in ipairs(CST.TEXTURES) do
            TextureType:AddChoice(CST.TEXTURES[k], k)
        end
        TextureType.OnSelect = function(panel, index, value)
            RunConsoleCommand("cel_texture", tostring(index))
        end

    local TextureColorLabel = vgui.Create("DLabel", panel3)
        TextureColorLabel:SetPos(210, 5)
        TextureColorLabel:SetText("Color:")

    local TextureColor = vgui.Create("DColorMixer", panel3)
        local r, g, b
        TextureColor:SetSize(266, 230)
        TextureColor:SetPos(210, 30)
        TextureColor:SetPalette(true)
        TextureColor:SetAlphaBar(false)
        TextureColor:SetWangs(true)
        r = GetConVar("cel_colour_r"):GetInt()
        g = GetConVar("cel_colour_g"):GetInt()
        b = GetConVar("cel_colour_b"):GetInt()
        TextureColor:SetColor(Color(r, g, b))
        TextureColor.ValueChanged = function()
            local ChosenColor = TextureColor:GetColor()

            RunConsoleCommand("cel_colour_r", tostring(ChosenColor.r))
            RunConsoleCommand("cel_colour_g", tostring(ChosenColor.g))
            RunConsoleCommand("cel_colour_b", tostring(ChosenColor.b))
        end

    local TextureMimic = vgui.Create("DCheckBoxLabel", panel3)
        TextureMimic:SetPos(10, 95)
        TextureMimic:SetText("Use The Halo Color")
        TextureMimic:SetConVar("cel_texture_mimic_halo")
        TextureMimic:SetValue(GetConVar("cel_texture_mimic_halo"):GetInt())
        TextureMimic:SizeToContents()
        TextureMimic:SetVisible(false)
        function TextureMimic:OnChange(val)
            local r, g, b

            if val then
                TextureColor:SetVisible(false)
                TextureColorLabel:SetVisible(false)
            else
                TextureColor:SetVisible(true)
                TextureColorLabel:SetVisible(true)
            end
        end

    Frame:SetVisible(true)
    Frame:MakePopup()

    -- --------
    -- TAB 2:
    -- --------

    local HaloModelLabel = vgui.Create("DLabel", panel2)
        HaloModelLabel:SetPos(10, 5)
        HaloModelLabel:SetText("Mode:")

    local SobelLabel = vgui.Create("DLabel", panel2)
        SobelLabel:SetPos(10, 60)
        SobelLabel:SetText("Thershold:")

    local Sobel = vgui.Create("DNumSlider", panel2)
        Sobel:SetPos(-130, 75)
        Sobel:SetSize(340, 35)
        Sobel:SetMin(0.09)
        Sobel:SetMax(0.99)
        Sobel:SetDecimals(2)
        Sobel:SetConVar("cel_sobel_thershold")

    local HaloSizeLabel = vgui.Create("DLabel", panel2)
        HaloSizeLabel:SetPos(10, 60)
        HaloSizeLabel:SetText("Size:")

    local HaloSize = vgui.Create("DNumSlider", panel2)
        HaloSize:SetPos(-130, 75)
        HaloSize:SetSize(340, 35)
        HaloSize:SetMin(0.1)
        HaloSize:SetMax(1)
        HaloSize:SetDecimals(2)
        HaloSize:SetConVar("cel_h_size")

    local HaloShakeLabel = vgui.Create("DLabel", panel2)
        HaloShakeLabel:SetPos(10, 105)
        HaloShakeLabel:SetText("Shake:")

    local HaloShake = vgui.Create("DNumSlider", panel2)
        HaloShake:SetPos(-130, 120)
        HaloShake:SetSize(340, 35)
        HaloShake:SetMin(0)
        HaloShake:SetMax(10)
        HaloShake:SetDecimals(2)
        HaloShake:SetConVar("cel_h_shake")

    local Halo13PassesLabel = vgui.Create("DLabel", panel2)
        Halo13PassesLabel:SetPos(10, 150)
        Halo13PassesLabel:SetText("Passes:")

    local Halo13Passes = vgui.Create("DNumSlider", panel2)
        Halo13Passes:SetPos(-130, 165)
        Halo13Passes:SetSize(340, 35)
        Halo13Passes:SetMin(0)
        Halo13Passes:SetMax(10)
        Halo13Passes:SetDecimals(0)
        Halo13Passes:SetConVar("cel_h_13_passes")

    local Halo13Aditive = vgui.Create("DCheckBoxLabel", panel2)
        Halo13Aditive:SetPos(10, 215)
        Halo13Aditive:SetText("Aditive")
        Halo13Aditive:SetValue(GetConVar("cel_h_13_additive"):GetInt())
        function Halo13Aditive:OnChange(val)
            RunConsoleCommand("cel_h_13_additive", val and "1" or "0")
        end

    local Halo13ThroughWalls = vgui.Create("DCheckBoxLabel", panel2)
        Halo13ThroughWalls:SetPos(10, 240)
        Halo13ThroughWalls:SetText("Render Through The Map")
        Halo13ThroughWalls:SetValue(GetConVar("cel_h_13_throughwalls"):GetInt())
        function Halo13ThroughWalls:OnChange(val)
            RunConsoleCommand("cel_h_13_throughwalls", val and "1" or "0")
        end

    local HaloColorLabel = vgui.Create("DLabel", panel2)
        HaloColorLabel:SetPos(210, 5)
        HaloColorLabel:SetText("Color:")

    local HaloColor = vgui.Create("DColorMixer", panel2)
        local r = GetConVar("cel_h_colour_r"):GetInt()
        local g = GetConVar("cel_h_colour_g"):GetInt()
        local b = GetConVar("cel_h_colour_b"):GetInt()
        HaloColor:SetSize(266, 230)
        HaloColor:SetPos(210, 30)
        HaloColor:SetPalette(true)
        HaloColor:SetAlphaBar(false)
        HaloColor:SetWangs(true)
        HaloColor:SetColor(Color(r, g, b))
        HaloColor.ValueChanged = function()
            local ChosenColor = HaloColor:GetColor()

            if GetConVar("cel_h_12_selected_halo"):GetInt() == 1 or not GetConVar("cel_h_12_two_layers"):GetInt() then
                RunConsoleCommand("cel_h_colour_r", tostring(ChosenColor.r))
                RunConsoleCommand("cel_h_colour_g", tostring(ChosenColor.g))
                RunConsoleCommand("cel_h_colour_b", tostring(ChosenColor.b))
            else
                RunConsoleCommand("cel_h_12_colour_r_2", tostring(ChosenColor.r))
                RunConsoleCommand("cel_h_12_colour_g_2", tostring(ChosenColor.g))
                RunConsoleCommand("cel_h_12_colour_b_2", tostring(ChosenColor.b))
            end
        end

    local Halo12Choose2Label = vgui.Create("DLabel", panel2)
        Halo12Choose2Label:SetPos(35, 192)
        Halo12Choose2Label:SetText("Select:")

    local function Halo12Choose2Options(choice)
        if choice == 1 then
            return "Layer 1"
        elseif choice == 2 then
            return "Layer 2"
        end
    end

    local Halo12Choose2 = vgui.Create("DComboBox", panel2)
        Halo12Choose2:SetPos(75, 190)
        Halo12Choose2:SetSize(123, 25)
        Halo12Choose2:SetValue(Halo12Choose2Options(GetConVar("cel_h_12_selected_halo"):GetInt()))
        Halo12Choose2:AddChoice("Layer 1", 1)
        Halo12Choose2:AddChoice("Layer 2", 2)
        Halo12Choose2.OnSelect = function(panel, value)
            RunConsoleCommand("cel_h_12_selected_halo", tostring(value))
            if value == 1 or not GetConVar("cel_h_12_two_layers"):GetInt() then
                local r = GetConVar("cel_h_colour_r"):GetInt()
                local g = GetConVar("cel_h_colour_g"):GetInt()
                local b = GetConVar("cel_h_colour_b"):GetInt()
                HaloSize:SetConVar("cel_h_size")
                HaloShake:SetConVar("cel_h_shake")
                HaloColor:SetColor(Color(r, g, b))
            else
                local r = GetConVar("cel_h_12_colour_r_2"):GetInt()
                local g = GetConVar("cel_h_12_colour_g_2"):GetInt()
                local b = GetConVar("cel_h_12_colour_b_2"):GetInt()
                HaloSize:SetConVar("cel_h_12_size_2")
                if (GetConVar("cel_h_12_singleshake"):GetInt() == 1) then
                    HaloShake:SetConVar("cel_h_shake")
                else
                    HaloShake:SetConVar("cel_h_12_shake_2")
                end
                HaloColor:SetColor(Color(r, g, b))
            end
        end

    local Halo12SingleShake = vgui.Create("DCheckBoxLabel", panel2)
        Halo12SingleShake:SetPos(35, 225)
        Halo12SingleShake:SetText("Single Shake")
        Halo12SingleShake:SetValue(GetConVar("cel_h_12_singleshake"):GetInt())
        function Halo12SingleShake:OnChange(val)
            local aux = 0

            if val then
                aux = 1
                HaloShake:SetConVar("cel_h_shake")
            else
                HaloShake:SetConVar("cel_h_12_shake_2")
            end

            RunConsoleCommand("cel_h_12_singleshake", tostring(aux))
        end

    local Halo12ExtraLayer = vgui.Create("DCheckBoxLabel", panel2)
        Halo12ExtraLayer:SetPos(10, 165)
        Halo12ExtraLayer:SetText("Use Two Layers")
        Halo12ExtraLayer:SetValue(GetConVar("cel_h_12_two_layers"):GetInt())
        function Halo12ExtraLayer:OnChange(val)
            if val then
                if GetConVar("cel_h_mode"):GetString() == "gm12" then -- Used for hiding these options when reseting everything
                    Halo12Choose2Label:SetVisible(true)
                    Halo12Choose2:SetVisible(true)
                    Halo12SingleShake:SetVisible(true)
                end
            else
                Halo12Choose2Label:SetVisible(false)
                Halo12Choose2:SetVisible(false)
                Halo12SingleShake:SetVisible(false)
            end

            RunConsoleCommand("cel_h_12_two_layers", val and "1" or "0")
        end

    -- This is an old, shitty piece of code that I don't want to fix.
    local function ShowOptions(mode)
        if mode == "sobel" then
            SobelLabel:SetVisible(true)
            Sobel:SetVisible(true)
            HaloSizeLabel:SetVisible(false)
            HaloSize:SetVisible(false)
            HaloShakeLabel:SetVisible(false)
            HaloShake:SetVisible(false)
            Halo13PassesLabel:SetVisible(false)
            Halo13Passes:SetVisible(false)
            Halo13Aditive:SetVisible(false)
            Halo13ThroughWalls:SetVisible(false)
            HaloColorLabel:SetVisible(false)
            HaloColor:SetVisible(false)
            Halo12ExtraLayer:SetVisible(false)
            Halo12Choose2Label:SetVisible(false)
            Halo12Choose2:SetVisible(false)
            Halo12SingleShake:SetVisible(false)
            TextureMimic:SetVisible(false)
        elseif mode == "gm12" then
            SobelLabel:SetVisible(false)
            Sobel:SetVisible(false)
            HaloSizeLabel:SetVisible(true)
            HaloSize:SetVisible(true)
            HaloShakeLabel:SetVisible(true)
            HaloShake:SetVisible(true)
            Halo13PassesLabel:SetVisible(false)
            Halo13Passes:SetVisible(false)
            Halo13Aditive:SetVisible(false)
            Halo13ThroughWalls:SetVisible(false)
            HaloColorLabel:SetVisible(true)
            HaloColor:SetVisible(true)
            Halo12ExtraLayer:SetVisible(true)
            if GetConVar("cel_h_12_two_layers"):GetInt() == 1 then
                Halo12Choose2Label:SetVisible(true)
                Halo12Choose2:SetVisible(true)
                Halo12SingleShake:SetVisible(true)
            end
            TextureMimic:SetVisible(true)
        elseif mode == "gm13" then
            SobelLabel:SetVisible(false)
            Sobel:SetVisible(false)
            HaloSizeLabel:SetVisible(true)
            HaloSize:SetVisible(true)
            HaloShakeLabel:SetVisible(true)
            HaloShake:SetVisible(true)
            Halo13PassesLabel:SetVisible(true)
            Halo13Passes:SetVisible(true)
            Halo13Aditive:SetVisible(true)
            Halo13ThroughWalls:SetVisible(true)
            HaloColorLabel:SetVisible(true)
            HaloColor:SetVisible(true)
            Halo12ExtraLayer:SetVisible(false)
            Halo12Choose2Label:SetVisible(false)
            Halo12Choose2:SetVisible(false)
            Halo12SingleShake:SetVisible(false)
            TextureMimic:SetVisible(true)
        end
    end

    local function HaloGetOptionID(choice)
        if choice == 1 then
            return "sobel"
        elseif choice == 2 then
            return "gm12"
        elseif choice == 3 then
            return "gm13"
        end
    end

    local function HaloGetOptionValue(choice)
        if choice == "sobel" then
            return "Sobel"
        elseif choice == "gm12" then
            return "GMod 12 Halo"
        elseif choice == "gm13" then
            return "GMod 13 Halo"
        end
    end

    local HaloChoose = vgui.Create("DComboBox", panel2)
        HaloChoose:SetPos(10, 30)
        HaloChoose:SetSize(190, 25)
        local choice = GetConVar("cel_h_mode"):GetString()
        HaloChoose:SetValue(HaloGetOptionValue(choice))
        ShowOptions(choice)
        HaloChoose:AddChoice("Sobel", "sobel")
        HaloChoose:AddChoice("GMod 12 Halo", "gm12")
        HaloChoose:AddChoice("GMod 13 Halo", "gm13")
        HaloChoose.OnSelect = function(panel, value)
            value = HaloGetOptionID(value)
            RunConsoleCommand("cel_h_mode", value)
            ShowOptions(value)
        end

    -- --------
    -- TAB 1:
    -- --------

    local Description = vgui.Create("DLabel", panel1)
        Description:SetPos(50, 18)
        Description:SetSize(492, 45)
        Description:SetText("Rendering modes work well or poorly depending on the entity, so do your tests.\n\n            The \"GMod 13 Halo\" mode is very good, but it causes a lot of lag!")

    local ApplyOnYourself = vgui.Create("DCheckBoxLabel", panel1)
        ApplyOnYourself:SetPos(164, 130)
        ApplyOnYourself:SetText("Apply the effect to yourself")
        ApplyOnYourself:SetValue(GetConVar("cel_apply_yourself"):GetInt())
        function ApplyOnYourself:OnChange(val)
            RunConsoleCommand("cel_apply_yourself", val and "1" or "0")
        end

    local ApplyOnPlayers = vgui.Create("DCheckBoxLabel", panel1)
        ApplyOnPlayers:SetVisible(false)
        ApplyOnPlayers:SetPos(152, 143)
        ApplyOnPlayers:SetText("Enable rendering in playermodels")
        ApplyOnPlayers:SetValue(GetConVar("enable_celshading_on_players"):GetInt())
        function ApplyOnPlayers:OnChange(val)
            net.Start("net_enable_celshading_on_players")
                net.WriteString(val and "1" or "0")
            net.SendToServer()
        end

    local EnableHalo13ForPlayers = vgui.Create("DCheckBoxLabel", panel1)
        EnableHalo13ForPlayers:SetVisible(false)
        EnableHalo13ForPlayers:SetPos(120, 163)
        EnableHalo13ForPlayers:SetText("Enable \"GMod 13 Halo\" option in clients menus")
        EnableHalo13ForPlayers:SetValue(GetConVar("enable_gm13_for_players"):GetInt())
        function EnableHalo13ForPlayers:OnChange(val)
            net.Start("net_enable_gm13halos_on_players")
                net.WriteString(val and "1" or "0")
            net.SendToServer()
        end

    if LocalPlayer():IsAdmin() and not game.SinglePlayer() then
        ApplyOnYourself:SetPos(164, 93)
        ApplyOnPlayers:SetVisible(true)
        EnableHalo13ForPlayers:SetVisible(true)
    end

    local ResetButton = vgui.Create("DButton", panel1)
        ResetButton:SetPos(182, 218)
        ResetButton:SetText("Reset Options!")
        ResetButton:SetSize(120, 30)
        ResetButton.DoClick = function()
            HaloChoose:ChooseOption(HaloGetOptionValue("sobel"), 1)
            Halo12Choose2:ChooseOption(Halo12Choose2Options(1), 1)
            timer.Simple(0.3, function() -- Wait for the changes
                RunConsoleCommand("cel_h_colour_r", "255")
                RunConsoleCommand("cel_h_colour_g", "0")
                RunConsoleCommand("cel_h_colour_b", "0")
                RunConsoleCommand("cel_h_size", "0.3")
                RunConsoleCommand("cel_h_shake", "0.00")
                RunConsoleCommand("cel_h_13_passes", "1")
                RunConsoleCommand("cel_h_13_additive", "1")
                RunConsoleCommand("cel_h_13_throughwalls", "0")
                RunConsoleCommand("cel_apply_texture", "0")
                RunConsoleCommand("cel_texture", "1")
                RunConsoleCommand("cel_colour_r", "255")
                RunConsoleCommand("cel_colour_g", "255")
                RunConsoleCommand("cel_colour_b", "255")
                RunConsoleCommand("cel_sobel_thershold", "0.2")
                RunConsoleCommand("cel_h_12_size_2", "0.3")
                RunConsoleCommand("cel_h_12_shake_2", "0.00")
                RunConsoleCommand("cel_h_12_colour_r_2", "0")
                RunConsoleCommand("cel_h_12_colour_g_2", "0")
                RunConsoleCommand("cel_h_12_colour_b_2", "0")
                RunConsoleCommand("cel_apply_yourself", "0")
                RunConsoleCommand("cel_texture_mimic_halo", "0")
                -- ApplyOnYourself:
                ApplyOnYourself:SetValue(0)
                -- ApplyOnPlayers:
                ApplyOnPlayers:SetValue(1)
                -- EnableHalo13ForPlayers:
                EnableHalo13ForPlayers:SetValue(0)
                timer.Simple(0.3, function() -- Wait for the changes
                    local r, g, b
                    -- HaloColor:
                    r = GetConVar("cel_h_colour_r"):GetInt()
                    g = GetConVar("cel_h_colour_g"):GetInt()
                    b = GetConVar("cel_h_colour_b"):GetInt()
                    HaloColor:SetColor(Color(r, g, b)) 
                    HaloColor:SetColor(Color(r, g, b)) -- It seems that GMod doesn't see this change at first, so here is another call
                    -- Halo12ExtraLayer:
                    Halo12ExtraLayer:SetValue(1)
                    -- Halo12SingleShake:
                    Halo12SingleShake:SetValue(0)
                    -- Halo13Aditive:
                    Halo13Aditive:SetValue(GetConVar("cel_h_13_additive"):GetInt())
                    -- Halo13ThroughWalls:
                    Halo13ThroughWalls:SetValue(GetConVar("cel_h_13_throughwalls"):GetInt())
                    -- TextureType:
                    TextureType:ChooseOption(CST.TEXTURES[1], 1)
                    -- TextureColor:
                    r = GetConVar("cel_colour_r"):GetInt()
                    g = GetConVar("cel_colour_g"):GetInt()
                    b = GetConVar("cel_colour_b"):GetInt()
                    TextureColor:SetColor(Color(r, g, b))
                    TextureColor:SetColor(Color(r, g, b)) -- It seems that GMod doesn't see this change at first, so here is another call
                    -- TextureMimic:
                    TextureMimic:SetValue(GetConVar("cel_texture_mimic_halo"):GetInt())
                end)
            end)
        end

    local ToolVersion = vgui.Create("DLabel", panel1)
        ToolVersion:SetPos(445, 245)
        ToolVersion:SetSize(45, 25)
        ToolVersion:SetText("v" .. CST.VERSION)

end

concommand.Add("cel_menu", CST.BuildPanel)
