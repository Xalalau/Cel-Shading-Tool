function CST:SetMaterial(ply, ent, t_data)
    ent:SetMaterial(t_data.MaterialOverride)

    duplicator.StoreEntityModifier(ent, "Cel_Material", t_data)
    duplicator.RegisterEntityModifier("Cel_Material", SetMaterial)
end

function CST:RemoveMaterial(ent)
    if not (ent and IsValid(ent) and ent:IsValid() and ent.cel) then return end

    self:SetMaterial(nil, ent, { MaterialOverride = "" })

    duplicator.ClearEntityModifier(ent, "Cel_Material")
end
