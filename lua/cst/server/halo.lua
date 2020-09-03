util.AddNetworkString("net_set_halo")
util.AddNetworkString("net_remove_halo")

function CST:SetHalo(ply, ent, h_data)
    ent.cel = h_data

    timer.Simple(0.1, function()
        net.Start("net_set_halo")
            net.WriteEntity(ent)
            net.WriteTable(h_data)
        net.Broadcast()

        table.insert(self.ENTITIES, { ent })

        duplicator.StoreEntityModifier(ent, "Cel_Halo", h_data)
    end)
end
duplicator.RegisterEntityModifier("Cel_Halo", CST.SetHalo)

function CST:RemoveHalo(ent)
    if not (ent and IsValid(ent) and ent:IsValid()) then return end

    ent.cel = nil

    for k,v in ipairs(self.ENTITIES) do
        if table.HasValue(v, ent) then
            self.ENTITIES[k] = nil
        end
    end

    net.Start("net_remove_halo")
        net.WriteEntity(ent)
    net.Broadcast()

    duplicator.ClearEntityModifier(ent, "Cel_Halo")
end
