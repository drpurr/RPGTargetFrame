local ADDON_NAME, RPGTF = ...

local MEDIA_ROOT = "Interface\\AddOns\\RPGTargetFrame\\"
local ALL_LOCALES = 255

local function SharedMedia()
    return LibStub and LibStub("LibSharedMedia-3.0", true)
end

function RPGTF:RegisterMedia()
    local lib = SharedMedia()
    if not lib or self.media_registered then
        return
    end

    local fonts = {
        { "Metamorphous", MEDIA_ROOT .. "media\\fonts\\Metamorphous-Regular.ttf" },
        { "Comfortaa Light", MEDIA_ROOT .. "media\\fonts\\Comfortaa-Light.ttf" },
        { "Comfortaa Regular", MEDIA_ROOT .. "media\\fonts\\Comfortaa-Regular.ttf" },
        { "Comfortaa Bold", MEDIA_ROOT .. "media\\fonts\\Comfortaa-Bold.ttf" },
    }
    for index = 1, #fonts do
        lib:Register("font", fonts[index][1], fonts[index][2], ALL_LOCALES)
    end

    local borders = {
        { "RPGTF: Vigor Dark", MEDIA_ROOT .. "media\\art\\dragonriding_sgvigor_border_dark.tga" },
        { "RPGTF: Vigor Bronze", MEDIA_ROOT .. "media\\art\\dragonriding_sgvigor_border_bronze.tga" },
        { "RPGTF: Vigor Gold", MEDIA_ROOT .. "media\\art\\dragonriding_sgvigor_border_gold.tga" },
        { "RPGTF: Vigor Silver", MEDIA_ROOT .. "media\\art\\dragonriding_sgvigor_border_silver.tga" },
        { "RPGTF: Action Bar Border", MEDIA_ROOT .. "media\\art\\ActionBar-Border.tga" },
        { "RPGTF: Vertex Border", MEDIA_ROOT .. "media\\art\\VertexBorder.tga" },
        { "Blizzard Arena", "Interface\\ArenaEnemyFrame\\UI-Arena-Border" },
        { "Blizzard Azerite", "Interface\\Tooltips\\UI-Tooltip-Border-Azerite" },
        { "Blizzard Corrupted", "Interface\\Tooltips\\UI-Tooltip-Border-Corrupted" },
        { "Blizzard LFG", "Interface\\LFGFrame\\LFGBorder" },
        { "Blizzard Maw", "Interface\\Tooltips\\UI-Tooltip-Border-Maw" },
        { "Blizzard Text Panel", "Interface\\Glues\\Common\\TextPanel-Border" },
        { "Blizzard Toast", "Interface\\FriendsFrame\\UI-Toast-Border" },
    }
    for index = 1, #borders do
        lib:Register("border", borders[index][1], borders[index][2])
    end

    lib:Register("background", "RPGTF: Solid", "Interface\\Buttons\\WHITE8X8")
    self.media_registered = true
end

function RPGTF:MediaFile(kind, key)
    local lib = SharedMedia()
    if not lib or type(key) ~= "string" or key == "" then
        return nil
    end
    local path = lib:Fetch(kind, key, true)
    if type(path) == "string" and path ~= "" then
        return path
    end
    return nil
end

function RPGTF:MediaList(kind)
    local lib = SharedMedia()
    local list = lib and lib:List(kind)
    if type(list) ~= "table" then
        return {}
    end
    local copy = {}
    for index = 1, #list do
        copy[index] = list[index]
    end
    return copy
end

function RPGTF:FontPath()
    local key = self.db and self.db.frame.font or "Metamorphous"
    return self:MediaFile("font", key) or self.MEDIA.font
end

function RPGTF:BorderPath()
    local key = self.db and self.db.frame.border or "RPGTF: Vigor Dark"
    return self:MediaFile("border", key) or self.MEDIA.border
end

function RPGTF:ApplyFont(font_string, size, outline)
    if not font_string then
        return
    end
    font_string.rpgtf_font_size = size
    font_string.rpgtf_font_outline = outline
    self.font_strings = self.font_strings or {}
    self.font_strings[font_string] = true

    local applied = font_string:SetFont(self:FontPath(), size, outline)
    if applied == false then
        font_string:SetFont("Fonts\\FRIZQT__.TTF", size, outline)
    end
end

function RPGTF:RefreshFonts()
    for font_string in pairs(self.font_strings or {}) do
        self:ApplyFont(font_string, font_string.rpgtf_font_size, font_string.rpgtf_font_outline)
    end
end

RPGTF:RegisterMedia()
