-- name: [CS] MegaMan
-- description: The blue bomber is here! Play as the ultimate Super Fighting Robot using his Mega Buster and trusty robot dog pal, Rush!\n\nMade by: You!\n\n\\#ff7777\\This Pack requires Character Select\nto use as a Library!

--[[
    API Documentation for Character Select can be found below:
    https://github.com/Squishy6094/character-select-coop/wiki/API-Documentation

    Use this if you're curious on how anything here works >v<
]]

-- Replace Mod Name with your Character/Pack name.
local TEXT_MOD_NAME = "MegaMan"

-- Stops mod from loading if Character Select isn't on, Does not need to be touched
if not _G.charSelectExists then
    djui_popup_create("\\#ffffdc\\\n"..TEXT_MOD_NAME.."\nRequires the Character Select Mod\nto use as a Library!\n\nPlease turn on the Character Select Mod\nand Restart the Room!", 6)
    return 0
end

--[[
    Everything from here down is character data, and is loaded at the end of the file

    Note that most things here are noted out via use of '--', if there is any
    functionality you'd want to use then remove the '--' in front of the functions.

    If needbe, Replace CHAR in the tables with your character's name
    Ex: E_MODEL_CHAR -> E_MODEL_SQUISHY

    Ensure all file naming is unique from other mods.
    Prefixing your files with your character's name should work fine
    Ex: life-icon.png -> squis
]]

local E_MODEL_MEGAMAN =      smlua_model_util_get_id("og_megaman_geo")      -- Located in "actors"
-- local E_MODEL_CHAR_STAR = smlua_model_util_get_id("custom_model_star_geo") -- Located in "actors"

local TEX_MEGAMAN_LIFE_ICON = get_texture_info("exclamation-icon") -- Located in "textures"
-- local TEX_CHAR_STAR_ICON = get_texture_info("exclamation-icon") -- Located in "textures"

-- All sound files are located in "sound" folder
-- Remember to include the file extention in the name
local VOICETABLE_MEGAMAN = {
    [CHAR_SOUND_OKEY_DOKEY] =        'MegaManStartGame.ogg', -- I'm heading out, Dr Light!
	[CHAR_SOUND_LETS_A_GO] =         'MegaManStartLevel.ogg', -- Ready?
	[CHAR_SOUND_GAME_OVER] =         'MegaManGameOver.ogg', -- No.. what happened?
	[CHAR_SOUND_PUNCH_YAH] =         'MegaManPunch1.ogg', -- YA
	[CHAR_SOUND_PUNCH_WAH] =         'MegaManPunch2.ogg', -- WAH
	[CHAR_SOUND_PUNCH_HOO] =         'MegaManPunch3.ogg', -- HAH!
	[CHAR_SOUND_YAH_WAH_HOO] =       {'MegaManJump1.ogg', 'MegaManJump2.ogg', 'MegaManJump3.ogg'}, -- Ya/Wa.Hoo will be reused
	[CHAR_SOUND_HOOHOO] =            'MegaManDoubleJump.ogg', -- Haha
	[CHAR_SOUND_YAHOO_WAHA_YIPPEE] = {'MegaManTripleJump1.ogg', 'MegaManTripleJump2.ogg', 'MegaManTripleJump3.ogg'}, -- Wahoo! Yeah! Weehee!
	[CHAR_SOUND_UH] =                'MegaManUh.ogg', -- Soft wall bonk - Uh!
	[CHAR_SOUND_UH2] =               'MegaManLedgeGetUp.ogg', -- Quick ledge get up - UH!
	[CHAR_SOUND_UH2_2] =             'MegaManLongJumpLand.ogg', -- Landing after long jump
	[CHAR_SOUND_DOH] =               'MegaManBonk.ogg', -- DUUGH!
	[CHAR_SOUND_OOOF] =              'MegaManOoof.ogg', -- DAAA!
	[CHAR_SOUND_OOOF2] =             'MegaManOoof2.ogg', -- OOF!
	[CHAR_SOUND_HAHA] =              'MegaManTripleJumpLand.ogg', -- Okay!
	[CHAR_SOUND_HAHA_2] =            'MegaManWaterLanding.ogg', -- Phew..
	[CHAR_SOUND_YAHOO] =             'MegaManLongJump.ogg', -- Yahoo!
	[CHAR_SOUND_DOH] =               'MegaManBonk.ogg', -- Uh!
	[CHAR_SOUND_WHOA] =              'MegaManGrabLedge.ogg', -- Woah!
	[CHAR_SOUND_EEUH] =              'MegaManClimbLedge.ogg', -- Ughhhhugh!
	[CHAR_SOUND_WAAAOOOW] =          'MegaManFalling.ogg', -- Falling a long distance
	[CHAR_SOUND_TWIRL_BOUNCE] =      'MegaManFlowerBounce.ogg', -- BOING!
	[CHAR_SOUND_GROUND_POUND_WAH] =  'MegaManGroundPound.ogg', -- Reused
	[CHAR_SOUND_WAH2] =              'MegaManThrow.ogg', -- Reused
	[CHAR_SOUND_HRMM] =              'MegaManLift.ogg', -- Lifting something - Hrrm!
	[CHAR_SOUND_HERE_WE_GO] =        'MegaManGetStar.ogg', -- All in a day's work!
	[CHAR_SOUND_SO_LONGA_BOWSER] =   'MegaManThrowBowser.ogg', -- FLY AWAY!
--DAMAGE
	[CHAR_SOUND_ATTACKED] =          'MegaManDamaged.ogg', -- Damaged
	[CHAR_SOUND_PANTING] =           'MegaManPanting.ogg', -- Low health
	[CHAR_SOUND_PANTING_COLD] =      'MegaManColdPanting.ogg', -- Getting cold
	[CHAR_SOUND_ON_FIRE] =           'MegaManBurned.ogg', -- Burned
--SLEEP SOUNDS
	[CHAR_SOUND_IMA_TIRED] =         'MegaManTired.ogg', -- "So tired.."
	[CHAR_SOUND_YAWNING] =           'MegaManYawn.ogg', -- Mario yawning before he sits down to sleep
	[CHAR_SOUND_SNORING1] =          'MegaManSnore.ogg', -- Snore Inhale
	[CHAR_SOUND_SNORING2] =          'MegaManExhale.ogg', -- Exhale
	[CHAR_SOUND_SNORING3] =          'MegaManSleepTalk.ogg', -- It's the same song and dance... I am not...  ...falling for it...  ... Dr. Wily...
--COUGHING (USED IN THE GAS MAZE)
	[CHAR_SOUND_COUGHING1] =         'MegaManCough1.ogg', -- Cough take 1
	[CHAR_SOUND_COUGHING2] =         'MegaManCough2.ogg', -- Cough take 2
	[CHAR_SOUND_COUGHING3] =         'MegaManCough3.ogg', -- Cough take 3
--DEATH
	[CHAR_SOUND_DYING] =             'MegaManDying.ogg', -- Two clips
	[CHAR_SOUND_DROWNING] =          'MegaManDrowning.ogg', -- uh!
	[CHAR_SOUND_MAMA_MIA] =          'MegaManLeaveLevel.ogg' -- I won't give up!

    -- POWER SHOT!!    -- RUSH COIL!!!    -- RUSH JET!!! 
}

-- All Located in "actors" folder
-- (Models do not exist in template)
--[[
local CAPTABLE_CHAR = {
    normal = smlua_model_util_get_id("FILENAME_geo"),
    wing = smlua_model_util_get_id("FILENAME_geo"),
    metal = smlua_model_util_get_id("FILENAME_geo"),
}
]]

local PALETTE_MEGAMAN = {
    [PANTS]  = "5a9fd2",
    [SHIRT]  = "0a5ac7",
    [GLOVES] = "0a5ac7",
    [SHOES]  = "ff5746",
    [HAIR]   = "1c1e3e",
    [SKIN]   = "fec179",
    [CAP]    = "0a5ac7",
	[EMBLEM] = "5a9fd2"
}

-- All Located in "textures" folder
-- (Textures do not exist in template)
--[[
local HEALTH_METER_CHAR = {
    label = {
        left = get_texture_info("healthleft"),
        right = get_texture_info("healthright"),
    },
    pie = {
        [1] = get_texture_info("Pie1"),
        [2] = get_texture_info("Pie2"),
        [3] = get_texture_info("Pie3"),
        [4] = get_texture_info("Pie4"),
        [5] = get_texture_info("Pie5"),
        [6] = get_texture_info("Pie6"),
        [7] = get_texture_info("Pie7"),
        [8] = get_texture_info("Pie8"),
    }
}
]]

--[[
    Everything from here down where the data is applied

    Note that nothing here other than the 'character_add' function
    is required for a custom character, if you don't have the assets
    then feel free to remove the function from the functions below
]]

local CSloaded = false
local function on_character_select_load()
    -- Adds the custom character to the Character Select Menu
    CT_MEGAMAN = _G.charSelect.character_add(
        "MegaMan", -- Character Name
        "Also known as Rock, is a lab assistant robot created by Dr. Light who has stepped up as the world's protector to stop any of Dr. Wily's evil schemes! I wonder how he got here... ", -- Description
        "FunkyLion", -- Credits
        "0A5AC7",           -- Menu Color
        E_MODEL_MEGAMAN,       -- Character Model
        CT_MARIO,           -- Override Character
        TEX_MEGAMAN_LIFE_ICON, -- Life Icon
        1                   -- Camera Scale
    )

    -- Adds cap models to your character
    -- (Models do not exist in template)
    -- _G.charSelect.character_add_caps(E_MODEL_CHAR, CAPTABLE_CHAR)

    -- Adds a voice to your character
    -- (Sounds do not exist in template)
    _G.charSelect.character_add_voice(E_MODEL_MEGAMAN, VOICETABLE_MEGAMAN)

    -- Adds a celebration star to your character
    -- (Models do not exist in template)
    --_G.charSelect.character_add_celebration_star(E_MODEL_CHAR, E_MODEL_CHAR_STAR, TEX_CHAR_STAR_ICON)

    -- Adds a palette to your character
    _G.charSelect.character_add_palette_preset(E_MODEL_MEGAMAN, PALETTE_MEGAMAN)

    -- Adds a health meter to your character
    -- (Textures do not exist in template)
    -- _G.charSelect.character_add_health_meter(CT_CHAR, HEALTH_METER_CHAR)

    -- Adds credits to the credits menu
    _G.charSelect.credit_add(TEXT_MOD_NAME, "FunkyLion", "Megaman")

    CSloaded = true
end

-- Character Voice hooks
-- You will likely not need to care about these
-- Will soon be overhauled

_G.charSelect.config_character_sounds()

hook_event(HOOK_ON_MODS_LOADED, on_character_select_load)