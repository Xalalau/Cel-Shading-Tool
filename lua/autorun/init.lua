CST = {}
CST.__index = CST

CST.VERSION = "GitHub 1.2+"

CST.FOLDER = {}
CST.FOLDER.LUA = "cst/"
CST.FOLDER.SV_MODULES = CST.FOLDER.LUA .. "server/"
CST.FOLDER.CL_MODULES = CST.FOLDER.LUA .. "client/"

CST.TEXTURES = {
    "models/debug/debugwhite",
    "models/shiny",
    "models/player/shared/ice_player",
}

CST.ENTITIES = {}

if CLIENT then
    CST.SOBELMAT = Material("pp/sobel")
    CST.SOBELMAT:SetTexture("$fbtexture", render.GetScreenEffectTexture())
end

local function includeModules(dir, isClientModule)
    local files, dirs = file.Find( dir.."*", "LUA" )

    if not dirs then return end

    for _, fdir in pairs(dirs) do
        includeModules(dir .. fdir .. "/", isClientModule)
    end

    for k,v in pairs(files) do
        if SERVER and isClientModule then
            AddCSLuaFile(dir .. v)
        else
            include(dir .. v)
        end
    end 
end

if SERVER then
    includeModules(CST.FOLDER.SV_MODULES)
end
includeModules(CST.FOLDER.CL_MODULES, true)

-- First spawn hook
-- Wait until the player fully loads (https://github.com/Facepunch/garrysmod-requests/issues/718)
if SERVER then
    hook.Add("PlayerInitialSpawn", "MRPlyfirstSpawn", function(ply)
        hook.Add("SetupMove", ply, function(self, ply, _, cmd)
            if self == ply and not cmd:IsForced() then
                CST:InitPlayer(ply)

                if table.Count(CST.ENTITIES) > 0 then
                    for _,v in pairs(CST.ENTITIES) do
                        net.Start("net_set_halo")
                            net.WriteEntity(v[1])
                            net.WriteTable(v[1].cel)
                        net.Send(ply)
                    end
                end

                hook.Remove("SetupMove", self)
            end
        end)
    end)
end
