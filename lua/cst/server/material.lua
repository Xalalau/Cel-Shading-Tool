function CSTool:SetMaterial(ent, t_data)
    ent:SetMaterial(t_data)
    ent:SetNWBool("Cel_Material", true)

    duplicator.StoreEntityModifier(ent, "Cel_MaterialDup", { t_data })
end
duplicator.RegisterEntityModifier("Cel_MaterialDup", SetMaterial)

function CSTool:RemoveMaterial(ent)
    if not (ent and IsValid(ent) and ent:IsValid()) then return end
    if not ent:GetNWBool("Cel_Material") then return end

    ent:SetNWBool("Cel_Material", false)
    ent:SetMaterial("")

    duplicator.ClearEntityModifier(ent, "Cel_MaterialDup")
end
