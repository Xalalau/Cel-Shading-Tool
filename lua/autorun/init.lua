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

if CLIENT then
    CST.SOBELMAT = Material("pp/sobel")
    CST.SOBELMAT:SetTexture("$fbtexture", render.GetScreenEffectTexture())
end

local function includeModules(dir, isClientModule)
    local files, dirs = file.Find( dir.."*", "LUA" )

    if not dirs then return end

    for _, fdir in ipairs(dirs) do
        includeModules(dir .. fdir .. "/", isClientModule)
    end

    for k,v in ipairs(files) do
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
