# RPG Target Frame

RPG Target Frame replaces the World of Warcraft: Forever target frame with one decorative unit bar in the RPG Boss Bar style. It is a separate addon. RPG Boss Bar can stay enabled for boss encounters. This addon does not track bosses or the soft enemy target.

## Compatibility

Version **1.60.1-2** supports World of Warcraft: Forever 1.60.1 (`## Interface: 16001`) only.

Clone this repository so the folder name is `RPGTargetFrame`, then install it at:

`World of Warcraft/_forever_/Interface/AddOns/RPGTargetFrame`

The folder name has to stay `RPGTargetFrame`. A new TOC needs a full client restart. Later Lua edits need `/reload`.

## What it shows

When you have a hard target, the bar shows:

- Name, colored by reaction when that value is readable
- Current health and health percent when those values are readable
- A power bar when the unit has power
- Level, including `??` for a skull level, and a classification label for elite, rare, rare elite, and boss units
- Up to 8 buff icons and 8 debuff icons, with stack counts
- A cast or channel bar, including a shield when the cast is not interruptible
- A smaller target-of-target bar with name, health, and level, when that option is enabled

The bar stays up for friendly, neutral, hostile, and dead targets. A dead target keeps the bar and shows `Dead`. Clearing your target hides the addon frame.

During combat, Midnight's secret-value rules still apply. Health and power are handed to the status bars directly. If a percent, level, aura, or cast time cannot be read, that text is left blank and the bar stays up. If auras are secret, the icon rows hide instead of erroring.

## Settings

`/rpgtt settings` opens the panel. The same panel is registered under Esc, Options, AddOns, RPG Target Frame when the Forever settings API is available.

| Setting | What it does |
| --- | --- |
| Target of target | Shows or hides the smaller bar. `/rpgtt tot` toggles it. |
| Scale | 0.5 to 2. `/rpgtt scale N` sets the same value. |
| Skin | Vigor Dark, Bronze, Gold, and Silver, Alliance, Horde, Simple Alliance, Simple Horde, Kyrian, Necrolord, Night Fae, and Venthyr. These presets are copied from RPG Boss Bar. Choosing a skin sets its accents, health color, border, and the solid background, and returns the font to Metamorphous. |
| Font | Metamorphous and Comfortaa from this addon, plus every font registered with LibSharedMedia-3.0. |
| Border | The bundled Vigor, Action Bar, and Vertex borders, the Blizzard borders this addon registers, and every border registered with LibSharedMedia-3.0. |
| Background | `RPGTF: Solid` uses the skin's dark background color. Any other LibSharedMedia background, including the Blizzard textures LibSharedMedia ships, is tiled behind the health bar. |

Alliance, Horde, and the covenant skins use a Blizzard tooltip edge in place of RPG Boss Bar's NineSlice borders. Their accents and health colors still follow the boss-bar presets.

## What it leaves alone

Portrait, raid icon, PvP flag, combo points, threat, focus, pet, and boss frames are unchanged. The player frame stays visible. This addon does not use profiles or Edit Mode.

The default target frame is hidden out of combat. A change made in combat waits until combat ends. `/rpgtt blizzard` shows Blizzard's target frame again.

## Commands

| Command | Description |
| --- | --- |
| `/rpgtt` | Show command help |
| `/rpgtt settings` | Open the settings panel |
| `/rpgtt tot` | Toggle the target-of-target bar |
| `/rpgtt skin Name` | Apply a skin by name, for example `/rpgtt skin Night Fae` |
| `/rpgtt lock` | Toggle dragging. While unlocked, drag the bar. The position is saved when you release the mouse. |
| `/rpgtt scale N` | Set the scale from 0.5 to 2 |
| `/rpgtt blizzard` | Hide or restore the default target frame |
| `/rpgtt test` | Toggle a preview with an elite target, buffs, a debuff, a cast, and a target-of-target bar |
| `/rpgtt reset` | Restore the default position, scale, skin, and visibility |

`/rpgtargetframe` is the same command.

## Media

These files are not stored in git. Copy them from RPG Boss Bar before using the addon in game, keeping the names below:

- `icon.tga`
- `media/art/dragonriding_sgvigor_border_dark.tga`
- `media/art/dragonriding_sgvigor_border_bronze.tga`
- `media/art/dragonriding_sgvigor_border_gold.tga`
- `media/art/dragonriding_sgvigor_border_silver.tga`
- `media/art/ActionBar-Border.tga`
- `media/art/VertexBorder.tga`
- `media/fonts/Metamorphous-Regular.ttf`
- `media/fonts/Comfortaa-Light.ttf`
- `media/fonts/Comfortaa-Regular.ttf`
- `media/fonts/Comfortaa-Bold.ttf`

LibSharedMedia fonts, borders, and backgrounds from other addons show up in the dropdowns without those files. The Vigor art and Comfortaa fonts need the copies above.

## In-game check

Enable script errors with `/console scriptErrors 1`. Run this once with only RPG Target Frame enabled, then again with RPG Boss Bar enabled:

- Open world: hostile, friendly, neutral, dead, and no target
- A casting mob and a channeling mob, including an interrupt
- Buffs and debuffs out of combat, including a stack count
- A dungeon pull and one boss, confirming there is no secret-value error
- The default target frame stays hidden and the player frame stays visible
- Drag the bar, `/reload`, and confirm the position stuck
- `/rpgtt test` with nothing targeted, then run it again to hide the preview
- `/rpgtt settings`: turn target of target off and on, change the skin, scale, font, border, and background, then `/reload` and confirm the choices stuck

If both `TargetFrame` and `TargetFrameContainer` are missing, `/fstack` the default target frame and add that global name to `FindTargetFrame` in `HideBlizzard.lua`.
