function CST:SetColor(ent, c_data)
    ent:SetNWBool("Cel_Color", true)

    if c_data.Mode == "2" then
        ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
    elseif c_data.Mode == "1" then
        ent:SetRenderMode(RENDERMODE_NORMAL)
        ent:PhysWake()
    end

    ent:SetColor(c_data.Color)

    duplicator.StoreEntityModifier(ent, "Cel_ColorDup", c_data)
end
duplicator.RegisterEntityModifier("Cel_ColorDup", SetColor)

function CST:RemoveColor(ent)
    if not (ent and IsValid(ent) and ent:IsValid()) then return end
    if not ent:GetNWBool("Cel_Color") then return end

    ent:SetNWBool("Cel_Color", false)
    ent:SetRenderMode(RENDERMODE_NORMAL)
    ent:SetColor(color_white)

    duplicator.ClearEntityModifier(ent, "Cel_ColorDup")
end
