function CST:SetColor(ply, ent, c_data)
    if (c_data.Color) then
        if (c_data.Mode == 2) then
            ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
        else
            ent:SetRenderMode(RENDERMODE_NORMAL)
        end
        ent:SetColor(c_data.Color)
        if (c_data.Mode == 1) then
            ent:PhysWake()
        end
    end

    duplicator.StoreEntityModifier(ent, "Cel_Colour", c_data)
    duplicator.RegisterEntityModifier("Cel_Colour", SetColor)
end

function CST:RemoveColor(ent)
    self:SetColor(nil, ent, { Color = Color(255, 255, 255, 255), Mode = ent.cel.Mode })
    duplicator.ClearEntityModifier(ent, "Cel_Colour")
end
