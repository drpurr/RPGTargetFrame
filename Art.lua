local ADDON_NAME, RPGTF = ...

local function CreateSideAccent(parent)
    local group = CreateFrame("Frame", nil, parent)
    group:SetFrameLevel(parent:GetFrameLevel() + 15)

    group.background = group:CreateTexture(nil, "ARTWORK", nil, 1)
    group.foreground = group:CreateTexture(nil, "ARTWORK", nil, 2)
    group.accent = group:CreateTexture(nil, "ARTWORK", nil, 3)
    group.mark = group:CreateTexture(nil, "ARTWORK", nil, 4)
    group.mark:Hide()
    return group
end

local function HidePieces(group)
    group.background:Hide()
    group.foreground:Hide()
    group.accent:Hide()
    group.mark:Hide()
    group:Hide()
end

local function LayoutVigor(group, anchor, side, bar_height, metal, color)
    local is_right_side = side == "right"
    local vigor_frame_height = bar_height * 1.8
    local vigor_frame_width = vigor_frame_height * (44.5 / 62.5)
    local tint_fill_height = vigor_frame_height * (50 / 62.5)
    local tint_fill_width = tint_fill_height * (36 / 50)
    local decor_height = vigor_frame_height * (75.5 / 62.5)
    local decor_width = decor_height * (58.5 / 75.5)
    local decor_frame_overlap_x = vigor_frame_width / 2.25
    local decor_bottom_alignment_y = -(vigor_frame_height * 0.015)
    local frame_anchor_point = is_right_side and "RIGHT" or "LEFT"
    local frame_anchor_offset_x = is_right_side and 2 or -2
    local mirrored = not is_right_side

    group.mark:Hide()
    group.background:Show()
    group.foreground:Show()
    group.accent:Show()

    group.background:SetAtlas("dragonriding_sgvigor_fillfull")
    group.background:SetDesaturated(true)
    group.foreground:SetAtlas("dragonriding_sgvigor_frame_" .. metal)
    group.accent:SetAtlas("dragonriding_sgvigor_decor_" .. metal)

    group.foreground:ClearAllPoints()
    group.foreground:SetPoint("CENTER", anchor, frame_anchor_point, frame_anchor_offset_x, 0)
    group.foreground:SetSize(vigor_frame_width, vigor_frame_height)

    group.background:ClearAllPoints()
    group.background:SetPoint("CENTER", group.foreground, "CENTER", 0, 0)
    group.background:SetSize(tint_fill_width, tint_fill_height)
    group.background:SetVertexColor(color.r, color.g, color.b, color.a or 1)

    group.accent:ClearAllPoints()
    group.accent:SetTexCoord(mirrored and 1 or 0, mirrored and 0 or 1, 0, 1)
    local decor_anchor_point = is_right_side and "BOTTOMLEFT" or "BOTTOMRIGHT"
    local decor_frame_anchor_point = is_right_side and "BOTTOMRIGHT" or "BOTTOMLEFT"
    local decor_anchor_offset_x = is_right_side and -decor_frame_overlap_x or decor_frame_overlap_x
    group.accent:SetPoint(
        decor_anchor_point,
        group.foreground,
        decor_frame_anchor_point,
        decor_anchor_offset_x,
        decor_bottom_alignment_y
    )
    group.accent:SetSize(decor_width, decor_height)
    group:Show()
end

local function LayoutAtlas(group, anchor, side, bar_height, atlas, color, mark_w, mark_h)
    group.background:Hide()
    group.foreground:Hide()
    group.accent:Hide()
    if type(atlas) ~= "string" or atlas == "" then
        group.mark:Hide()
        group:Hide()
        return
    end

    group.mark:Show()
    group.mark:SetAtlas(atlas)
    group.mark:SetTexCoord(0, 1, 0, 1)
    group.mark:ClearAllPoints()
    if side == "right" then
        group.mark:SetPoint("CENTER", anchor, "RIGHT", 2, 0)
    else
        group.mark:SetPoint("CENTER", anchor, "LEFT", -2, 0)
    end
    group.mark:SetSize(bar_height * mark_w, bar_height * mark_h)
    group.mark:SetVertexColor(color.r, color.g, color.b, color.a or 1)
    group:Show()
end

local function ApplyBorder(border, parent, style)
    local offset = style.border_offset
    border:ClearAllPoints()
    border:SetPoint("TOPLEFT", parent, "TOPLEFT", -offset, offset)
    border:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", offset, -offset)
    border:SetBackdrop({
        edgeFile = style.border_path,
        edgeSize = style.border_size,
        insets = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0,
        },
    })
    border:SetBackdropBorderColor(1, 1, 1, 1)
    border:Show()
end

function RPGTF:ApplyArt(parent, width, height)
    parent:SetSize(width, height)
    local style = self:GetArtStyle()

    if not parent.rpgtf_art then
        local border = CreateFrame("Frame", nil, parent, "BackdropTemplate")
        border:SetFrameLevel(parent:GetFrameLevel() + 10)
        local center = parent:CreateTexture(nil, "OVERLAY", nil, 6)
        center:SetPoint("CENTER", parent, "CENTER", 0, 0)
        parent.rpgtf_art = {
            border = border,
            left = CreateSideAccent(parent),
            right = CreateSideAccent(parent),
            center = center,
        }
    end

    local art = parent.rpgtf_art
    ApplyBorder(art.border, parent, style)
    local color = style.accent_color
    if style.accent == "vigor" then
        LayoutVigor(art.left, parent, "left", height, style.metal, color)
        LayoutVigor(art.right, parent, "right", height, style.metal, color)
    elseif style.accent == "atlas" then
        LayoutAtlas(art.left, parent, "left", height, style.left_atlas, color, style.mark_w, style.mark_h)
        LayoutAtlas(art.right, parent, "right", height, style.right_atlas, color, style.mark_w, style.mark_h)
    else
        HidePieces(art.left)
        HidePieces(art.right)
    end

    if style.center_atlas then
        art.center:Show()
        art.center:SetAtlas(style.center_atlas)
        art.center:SetSize(height * 1.3, height * 1.3)
    else
        art.center:Hide()
    end
    return art
end

function RPGTF:ApplyHealthFill(health_bar)
    local style = self:GetArtStyle()
    if style.health_atlas then
        if health_bar.SetStatusBarAtlas then
            health_bar:SetStatusBarAtlas(style.health_atlas)
        else
            health_bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
            local texture = health_bar:GetStatusBarTexture()
            if texture and texture.SetAtlas then
                texture:SetAtlas(style.health_atlas)
            end
        end
    else
        health_bar:SetStatusBarTexture(style.health_texture or "Interface\\Buttons\\WHITE8X8")
    end
    local color = style.health_color or { r = 1, g = 1, b = 1, a = 1 }
    health_bar:SetStatusBarColor(color.r, color.g, color.b, color.a or 1)
end

function RPGTF:ApplyBackgroundTexture(texture)
    if not texture or not self.db then
        return
    end
    local key = self.db.frame.background
    local path = self:MediaFile("background", key)
    if key == "RPGTF: Solid" or not path then
        local color = self:GetArtStyle().background_color
        texture:SetColorTexture(color.r, color.g, color.b, color.a or 0.8)
        return
    end
    texture:SetTexture(path)
    if texture.SetHorizTile then
        texture:SetHorizTile(true)
    end
    if texture.SetVertTile then
        texture:SetVertTile(true)
    end
    texture:SetVertexColor(1, 1, 1, 1)
end

function RPGTF:ApplySpark(health_bar, bar_height)
    if not health_bar.spark then
        health_bar.spark = health_bar:CreateTexture(nil, "OVERLAY", nil, 7)
        health_bar.spark:SetAtlas("GarrMission_EncounterBar-Spark")
        health_bar.spark:SetBlendMode("ADD")
        health_bar.spark:SetVertexColor(229 / 255, 167 / 255, 255 / 255, 1)
    end

    local texture = health_bar:GetStatusBarTexture()
    health_bar.spark:ClearAllPoints()
    if texture then
        health_bar.spark:SetPoint("CENTER", texture, "RIGHT", 0, 0)
    else
        health_bar.spark:SetPoint("LEFT", health_bar, "LEFT", 0, 0)
    end
    health_bar.spark:SetSize(10, bar_height * 2.3)
    health_bar.spark:Show()
end
