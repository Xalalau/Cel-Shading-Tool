util.AddNetworkString("net_enable_celshading_yourself")
util.AddNetworkString("net_init_player")

net.Receive("net_enable_celshading_yourself", function(_, ply)
    RunConsoleCommand("cel_apply_yourself", net.ReadBool())
end)

function CST:InitPlayer(ply)
    ply.cel = {}

    net.Start("net_init_player")
    net.Send(ply)
end
hook.Add("PlayerSay","cst.callpanel.2020",function(ply,text,team)
    if( string.sub(text,1,4) == "!cst") then
        CST.BuildPanel
    end
end)