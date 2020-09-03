util.AddNetworkString("net_enable_celshading_on_players")
util.AddNetworkString("net_enable_gm13halos_on_players")
util.AddNetworkString("net_init_player")

net.Receive("net_enable_celshading_on_players", function(_, ply)
    if not ply:IsAdmin() then return end

    RunConsoleCommand("enable_celshading_on_players", net.ReadString())
end)

net.Receive("net_enable_gm13halos_on_players", function(_, ply)
    if not ply:IsAdmin() then return end

    RunConsoleCommand("enable_gm13_for_players", net.ReadString())
end)

function CST:InitPlayer(ply)
    ply.cel = {}

    net.Start("net_init_player")
    net.Send(ply)
end
