local haloEntList = {}

net.Receive("cl_SetHalo", function()
    CST:SetHalo(net.ReadEntity(), net.ReadTable())
end)

net.Receive("cl_RemoveHalo", function()
    CST:RemoveHalo(net.ReadEntity(), net.ReadString())
end)

-- Sobel PP effect (light / works / players)
function CST:SetPPeffect(ent, h_data)
    render.ClearStencil()
    render.SetStencilEnable(true)
        render.SetStencilWriteMask(255)
        render.SetStencilTestMask(255)
        render.SetStencilReferenceValue(1)
        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
        render.SetBlend(0)
        if h_data.Color then
            ent:SetColor(h_data.Color)
        end
        ent:DrawModel()
        render.SetBlend(1)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
        render.UpdateScreenEffectTexture()
        self.SOBELMAT:SetFloat("$threshold", 0.15 - h_data.SobelThershold * 0.15)
        ent:DrawModel()
        render.SetMaterial(self.SOBELMAT)
        render.DrawScreenQuad()
    render.SetStencilEnable(false)
end

-- GMod 12 halos (light / scaling problems / players)
function CST:SetGMod12HaloAux(ent, scale, color)
    local pos = LocalPlayer():EyePos() + LocalPlayer():EyeAngles():Forward() * 10
    local ang = Angle(LocalPlayer():EyeAngles().p + 90, LocalPlayer():EyeAngles().y, 0)

    render.ClearStencil()
    render.SetStencilEnable(true)
        render.SetStencilWriteMask(255)
        render.SetStencilTestMask(255)
        render.SetStencilReferenceValue(15)
        render.SetStencilFailOperation(STENCILOPERATION_KEEP)
        render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
        render.SetBlend(0)
        ent:SetModelScale(scale, 0)
        ent:DrawModel()
        ent:SetModelScale(1, 0)
        render.SetBlend(1)
        render.SetStencilPassOperation(STENCIL_KEEP)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
        cam.Start3D2D(pos, ang, 1)
            surface.SetDrawColor(color)
            surface.DrawRect(-ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2)
        cam.End3D2D()
        ent:DrawModel()
    render.SetStencilEnable(false)
end

function CST:SetGMod12Halo(ent, h_data)
    local shake2 = math.Rand(0, h_data.SingleShake == "1" and h_data.Layer1.Shake or h_data.Layer2.Shake)
    local shake1 = h_data.Layers == "1" and (h_data.SingleShake == "1" and shake2 or math.Rand(0, h_data.Layer1.Shake))
    local sizeLayer1 = h_data.Layers and (1 + h_data.Layer1.Size) or 0
    local sizeLayer2 = sizeLayer1 + h_data.Layer2.Size

    self:SetGMod12HaloAux(ent, sizeLayer2 + shake2 / 15, h_data.Layer2.Color)

    if h_data.Layers == "1" then
        self:SetGMod12HaloAux(ent, sizeLayer1 + shake1 / 15, h_data.Layer1.Color)
    end
end

-- GMod 13 halos (heavy / works / admins)
function CST:SetGMod13Halo(ent, h_data)
    local size = h_data.Size * 5 + math.Rand(0, h_data.Shake)

    halo.Add(
        { ent },
        h_data.Color,
        size,
        size,
        h_data.Passes,
        h_data.Additive == "1" and true or false,
        h_data.ThroughWalls == "1" and true or false
    )
end

-- Start rendering sobel and GMod 12/13 halos
local function DrawAux(entTbl)
    if entTbl and table.Count(entTbl) > 0 then
        for k,v in pairs(entTbl) do
            local ent, h_data = v[1], v[2]

            if not IsValid(ent) or not ent:IsValid() then
                CST:RemoveHalo(ent, h_data.Mode)
            else
                if h_data.Mode == "sobel" then
                    CST:SetPPeffect(ent, h_data)
                elseif h_data.Mode == "gm12" then
                    CST:SetGMod12Halo(ent, h_data)
                elseif h_data.Mode == "gm13" then
                    CST:SetGMod13Halo(ent, h_data)
                end
            end
        end
    end
end

hook.Add("PostDrawOpaqueRenderables", "CST Halos 1", function()
    DrawAux(haloEntList["sobel"])
    DrawAux(haloEntList["gm12"])
end)

hook.Add("PreDrawHalos", "CST Halos 2", function()
    DrawAux(haloEntList["gm13"])
end)

function CST:RemoveHalo(ent, mode)
    haloEntList[mode][ent:EntIndex()] = nil
end

function CST:SetHalo(ent, h_data)
    if not haloEntList[h_data.Mode] then
        haloEntList[h_data.Mode] = {}
    end

    haloEntList[h_data.Mode][ent:EntIndex()] = { ent, h_data }
end
