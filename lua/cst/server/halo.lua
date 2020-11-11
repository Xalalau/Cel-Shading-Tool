util.AddNetworkString("cl_SetHalo")
util.AddNetworkString("cl_RemoveHalo")

function CST:SetHalo(ent, h_data)
    ent:SetNWString("Cel_Halo", h_data.Mode)

    net.Start("cl_SetHalo")
        net.WriteEntity(ent)
        net.WriteTable(h_data)
    net.Broadcast()

    ent.h_data = h_data

    duplicator.StoreEntityModifier(ent, "Cel_HaloDup", h_data)
end
duplicator.RegisterEntityModifier("Cel_HaloDup", CST.SetHalo)

function CST:RemoveHalo(ent)
    if not (ent and IsValid(ent) and ent:IsValid()) then return end
    if not ent.h_data then return end

    net.Start("cl_RemoveHalo")
        net.WriteEntity(ent)
        net.WriteString(ent:GetNWString("Cel_Halo"))
    net.Broadcast()

    ent.h_data = nil
    ent:SetNWString("Cel_Halo", "")

    duplicator.ClearEntityModifier(ent, "Cel_HaloDup")
end
