util.AddNetworkString("net_enable_celshading_on_players")
util.AddNetworkString("net_enable_gm13halos_on_players")

net.Receive("net_enable_celshading_on_players", function(_, ply)
    if not ply:IsAdmin() then return end

    RunConsoleCommand("enable_celshading_on_players", net.ReadString())
end)

net.Receive("net_enable_gm13halos_on_players", function(_, ply)
    if not ply:IsAdmin() then return end

    RunConsoleCommand("enable_gm13_for_players", net.ReadString())
end)

hook.Add("PlayerSay","cst.callpanel.2020",function(ply, text, team)
    if string.sub(text,1,4) == "!cst" then
        ply:ConCommand("cel_menu")
    end
end)