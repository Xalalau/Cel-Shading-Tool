CSTool = {}
CSTool.__index = CSTool

CSTool.VERSION = "1.3.2"

CSTool.FOLDER = {}
CSTool.FOLDER.LUA = "cst/"
CSTool.FOLDER.SV_MODULES = CSTool.FOLDER.LUA .. "server/"
CSTool.FOLDER.CL_MODULES = CSTool.FOLDER.LUA .. "client/"
CSTool.TEXTURES = {
    "models/debug/debugwhite",
    "models/shiny",
    "models/player/shared/ice_player",
}

if CLIENT then
    CSTool.SOBELMAT = Material("pp/sobel")
    CSTool.SOBELMAT:SetTexture("$fbtexture", render.GetScreenEffectTexture())
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
    includeModules(CSTool.FOLDER.SV_MODULES)
end
includeModules(CSTool.FOLDER.CL_MODULES, true)
