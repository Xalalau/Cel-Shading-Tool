net.Receive("net_init_player", function()
    CST:InitPlayer(LocalPlayer())
end)

function CST:InitPlayer(ply)
    ply.cel = {}
end
