net.Receive("net_set_halo", function()
    CST:SetHalo(net.ReadEntity(), net.ReadTable())
end)

net.Receive("net_remove_halo", function()
    CST:RemoveHalo(net.ReadEntity())
end)

-- Sobel PP effect (light / works / players)
function CST:SetPPeffect(ent)
    render.ClearStencil()
    render.SetStencilEnable(true)
        render.SetStencilWriteMask(255)
        render.SetStencilTestMask(255)
        render.SetStencilReferenceValue(1)
        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
        render.SetBlend(0)
        if ent.cel.Color then
            ent:SetColor(ent.cel.Color)
        end
        ent:DrawModel()
        render.SetBlend(1)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
        render.UpdateScreenEffectTexture();
        self.SOBELMAT:SetFloat("$threshold", 0.15 - ent.cel.SobelThershold * 0.15)
        ent:DrawModel()
        render.SetMaterial(self.SOBELMAT);
        render.DrawScreenQuad();
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
        ent:SetModelScale(1,0)
        render.SetBlend(1)
        render.SetStencilPassOperation(STENCIL_KEEP)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
        cam.Start3D2D(pos,ang,1)
            surface.SetDrawColor(color)
            surface.DrawRect(-ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2)
        cam.End3D2D()
        ent:DrawModel()
    render.SetStencilEnable(false)
end

function CST:SetGMod12Halo(ent)
    local shake = math.Rand(0, ent.cel.Layer1.Shake)

    local addsizefromlayer2onlayer1 = 0
    if ent.cel.Layers == 1 then
        addsizefromlayer2onlayer1 = ent.cel.Layer2.Size / 2 + 1
    end

    self:SetGMod12HaloAux(ent, ent.cel.Layer1.Size / 2 + addsizefromlayer2onlayer1 + shake / 15, ent.cel.Layer1.Color)

    if ent.cel.Layers == 1 then
        if ent.cel.SingleShake == 0 then
            shake = math.Rand(0, ent.cel.Layer2.Shake)
        end

        self:SetGMod12HaloAux(ent, ent.cel.Layer2.Size / 2 + 1 + shake / 15, ent.cel.Layer2.Color)
    end
end

-- GMod 13 halos (heavy / works / admins)
function CST:SetGMod13Halo(entTable)
    local size = entTable[1].cel.Size * 5 + math.Rand(0, entTable[1].cel.Shake)

    halo.Add(entTable, entTable[1].cel.Color, size, size, entTable[1].cel.Passes, entTable[1].cel.Additive, entTable[1].cel.ThroughWalls)
end

function CST:DrawEffects()
    if table.Count(self.ENTITIES) > 0 then
        for k,v in pairs(self.ENTITIES) do
            if not IsValid(v[1]) or not v[1]:IsValid() then
                self.ENTITIES[k] = nil
            else
                if v[1].cel.Mode == "1" then
                    CST:SetPPeffect(v[1])
                elseif v[1].cel.Mode == "2" then
                    CST:SetGMod12Halo(v[1])
                elseif v[1].cel.Mode == "3" then
                    CST:SetGMod13Halo(v)
                end
            end
        end
    end
end

-- OLD https://facepunch.com/showthread.php?t=1337232
-- https://wiki.facepunch.com/gmod/GM:PreDrawHalos
hook.Add("PostDrawOpaqueRenderables", "PlayerBorders", function()
    CST:DrawEffects()
end)

function CST:RemoveHalo(ent)
    for k,v in pairs(self.ENTITIES) do
        if table.HasValue(v, ent) then
            self.ENTITIES[k] = nil
        end
    end

    ent.cel = nil
end

function CST:SetHalo(ent, h_data)
    for k,v in pairs(self.ENTITIES) do
        if table.HasValue(v, ent) then
            self.ENTITIES[k] = nil
        end
    end

    ent.cel = h_data
    table.insert(self.ENTITIES, { ent })
end
