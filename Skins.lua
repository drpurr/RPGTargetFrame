local ADDON_NAME, RPGTF = ...

local function Color(r, g, b, a)
    return { r = r, g = g, b = b, a = a or 1 }
end

-- Visual presets taken from RPG Boss Bar's bundled skins. Border files are the
-- same art, addressed under this addon's folder. NineSlice frame borders from
-- the boss bar become the Blizzard Tooltip edge, which LibSharedMedia provides.
RPGTF.skins = {
    {
        id = "vigor_dark",
        name = "Vigor Dark",
        border = "RPGTF: Vigor Dark",
        border_size = 32,
        border_offset = 4,
        accent = "vigor",
        metal = "dark",
        accent_color = Color(70 / 255, 34 / 255, 106 / 255),
        health_atlas = "Unit_Priest_Insanity_Fill",
        health_color = Color(1, 1, 1),
        background_color = Color(0, 0, 0, 0.8),
    },
    {
        id = "vigor_bronze",
        name = "Vigor Bronze",
        border = "RPGTF: Vigor Bronze",
        border_size = 32,
        border_offset = 4,
        accent = "vigor",
        metal = "bronze",
        accent_color = Color(164 / 255, 92 / 255, 43 / 255),
        health_atlas = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Energy",
        health_color = Color(220 / 255, 105 / 255, 40 / 255),
        background_color = Color(0, 0, 0, 0.8),
    },
    {
        id = "vigor_gold",
        name = "Vigor Gold",
        border = "RPGTF: Vigor Gold",
        border_size = 32,
        border_offset = 4,
        accent = "vigor",
        metal = "gold",
        accent_color = Color(214 / 255, 154 / 255, 45 / 255),
        health_atlas = "Unit_Evoker_EbonMight_Fill",
        health_color = Color(1, 1, 1),
        background_color = Color(0, 0, 0, 0.8),
    },
    {
        id = "vigor_silver",
        name = "Vigor Silver",
        border = "RPGTF: Vigor Silver",
        border_size = 32,
        border_offset = 4,
        accent = "vigor",
        metal = "silver",
        accent_color = Color(135 / 255, 206 / 255, 235 / 255),
        health_atlas = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Energy",
        health_color = Color(180 / 255, 225 / 255, 1),
        background_color = Color(0, 0, 0, 0.8),
    },
    {
        id = "alliance",
        name = "Alliance",
        border = "Blizzard Tooltip",
        border_size = 12,
        border_offset = 5,
        accent = "atlas",
        left_atlas = "charcreatetest-logo-alliance",
        right_atlas = "charcreatetest-logo-alliance",
        center_atlas = "Quest-Alliance-WaxSeal",
        mark_w = 1.6,
        mark_h = 1.6,
        accent_color = Color(1, 1, 1),
        health_texture = "Interface\\Buttons\\WHITE8X8",
        health_color = Color(0 / 255, 90 / 255, 179 / 255),
        background_color = Color(0, 0, 0, 0.8),
    },
    {
        id = "horde",
        name = "Horde",
        border = "Blizzard Tooltip",
        border_size = 12,
        border_offset = 5,
        accent = "atlas",
        left_atlas = "charcreatetest-logo-horde",
        right_atlas = "charcreatetest-logo-horde",
        center_atlas = "Quest-Horde-WaxSeal",
        mark_w = 1.6,
        mark_h = 1.6,
        accent_color = Color(1, 1, 1),
        health_texture = "Interface\\Buttons\\WHITE8X8",
        health_color = Color(140 / 255, 22 / 255, 22 / 255),
        background_color = Color(0, 0, 0, 0.8),
    },
    {
        id = "simple_alliance",
        name = "Simple Alliance",
        border = "RPGTF: Action Bar Border",
        border_size = 24,
        border_offset = 5,
        accent = "atlas",
        left_atlas = "UI-HUD-ActionBar-Gryphon-Left",
        right_atlas = "UI-HUD-ActionBar-Gryphon-Right",
        center_atlas = "Quest-Alliance-WaxSeal",
        mark_w = 1.8,
        mark_h = 2.2,
        accent_color = Color(1, 1, 1),
        health_texture = "Interface\\Buttons\\WHITE8X8",
        health_color = Color(0 / 255, 90 / 255, 179 / 255),
        background_color = Color(0, 0, 0, 0.8),
    },
    {
        id = "simple_horde",
        name = "Simple Horde",
        border = "RPGTF: Action Bar Border",
        border_size = 24,
        border_offset = 5,
        accent = "atlas",
        left_atlas = "UI-HUD-ActionBar-Wyvern-Left",
        right_atlas = "UI-HUD-ActionBar-Wyvern-Right",
        center_atlas = "Quest-Horde-WaxSeal",
        mark_w = 1.8,
        mark_h = 2.2,
        accent_color = Color(1, 1, 1),
        health_texture = "Interface\\Buttons\\WHITE8X8",
        health_color = Color(140 / 255, 22 / 255, 22 / 255),
        background_color = Color(0, 0, 0, 0.8),
    },
    {
        id = "kyrian",
        name = "Kyrian",
        border = "Blizzard Tooltip",
        border_size = 12,
        border_offset = 5,
        accent = "atlas",
        left_atlas = "CovenantSanctum-Resevoir-Full-Kyrian",
        right_atlas = "CovenantSanctum-Resevoir-Full-Kyrian",
        center_atlas = "CovenantChoice-Celebration-KyrianSigil",
        mark_w = 2.2,
        mark_h = 2.2,
        accent_color = Color(1, 1, 1),
        health_texture = "Interface\\Buttons\\WHITE8X8",
        health_color = Color(63 / 255, 199 / 255, 235 / 255),
        background_color = Color(0, 0, 0, 0.8),
    },
    {
        id = "necrolord",
        name = "Necrolord",
        border = "Blizzard Tooltip",
        border_size = 12,
        border_offset = 5,
        accent = "atlas",
        left_atlas = "CovenantSanctum-Resevoir-Full-Necrolord",
        right_atlas = "CovenantSanctum-Resevoir-Full-Necrolord",
        center_atlas = "CovenantChoice-Celebration-NecrolordSigil",
        mark_w = 2.2,
        mark_h = 2.2,
        accent_color = Color(1, 1, 1),
        health_texture = "Interface\\Buttons\\WHITE8X8",
        health_color = Color(0, 248 / 255, 152 / 255),
        background_color = Color(0, 0, 0, 0.8),
    },
    {
        id = "nightfae",
        name = "Night Fae",
        border = "Blizzard Tooltip",
        border_size = 12,
        border_offset = 5,
        accent = "atlas",
        left_atlas = "CovenantSanctum-Resevoir-Full-Nightfae",
        right_atlas = "CovenantSanctum-Resevoir-Full-Nightfae",
        center_atlas = "CovenantChoice-Celebration-NightfaeSigil",
        mark_w = 2.2,
        mark_h = 2.2,
        accent_color = Color(1, 1, 1),
        health_texture = "Interface\\Buttons\\WHITE8X8",
        health_color = Color(163 / 255, 48 / 255, 201 / 255),
        background_color = Color(0, 0, 0, 0.8),
    },
    {
        id = "venthyr",
        name = "Venthyr",
        border = "Blizzard Tooltip",
        border_size = 12,
        border_offset = 5,
        accent = "atlas",
        left_atlas = "CovenantSanctum-Resevoir-Full-Venthyr",
        right_atlas = "CovenantSanctum-Resevoir-Full-Venthyr",
        center_atlas = "CovenantChoice-Celebration-VenthyrSigil",
        mark_w = 2.2,
        mark_h = 2.2,
        accent_color = Color(1, 1, 1),
        health_texture = "Interface\\Buttons\\WHITE8X8",
        health_color = Color(196 / 255, 19 / 255, 58 / 255),
        background_color = Color(0, 0, 0, 0.8),
    },
}

function RPGTF:FindSkin(query)
    if type(query) ~= "string" or query == "" then
        return nil
    end
    local needle = query:lower()
    for index = 1, #self.skins do
        local skin = self.skins[index]
        if skin.id == needle or skin.name:lower() == needle then
            return skin
        end
    end
    return nil
end

function RPGTF:SkinNames()
    local names = {}
    for index = 1, #self.skins do
        names[index] = self.skins[index].name
    end
    return names
end

function RPGTF:GetArtStyle()
    local frame = self.db and self.db.frame
    local skin = self:FindSkin(frame and frame.skin or "vigor_dark") or self.skins[1]
    local border_key = frame and frame.border or skin.border
    local border_size = skin.border_size
    local border_offset = skin.border_offset
    if border_key ~= skin.border then
        border_size = 16
        border_offset = 4
    end

    return {
        border_path = self:MediaFile("border", border_key) or self.MEDIA.border,
        border_size = border_size,
        border_offset = border_offset,
        accent = skin.accent,
        metal = skin.metal or "dark",
        left_atlas = skin.left_atlas,
        right_atlas = skin.right_atlas,
        center_atlas = skin.center_atlas,
        mark_w = skin.mark_w or 1.8,
        mark_h = skin.mark_h or 1.8,
        accent_color = skin.accent_color,
        health_atlas = skin.health_atlas,
        health_texture = skin.health_texture,
        health_color = skin.health_color,
        background_color = skin.background_color,
    }
end

function RPGTF:SelectSkin(query)
    local skin = self:FindSkin(query)
    if not skin or not self.db then
        return false
    end
    self.db.frame.skin = skin.id
    self.db.frame.font = "Metamorphous"
    self.db.frame.border = skin.border
    self.db.frame.background = "RPGTF: Solid"
    self:ApplyAppearance()
    return skin
end
