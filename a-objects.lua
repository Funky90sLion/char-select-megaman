E_MODEL_ROCK_SHOT = smlua_model_util_get_id("og_megaman_shot_geo")
E_MODEL_ROCK_POWERSHOT = smlua_model_util_get_id("og_megaman_powershot_geo")
E_MODEL_ROCK_CHARGESHOT = smlua_model_util_get_id("og_megaman_chargeshot_geo")

define_custom_obj_fields({
    oShotOwner = "u32",
    oChargeLevel = "u32"
})

local shotModelTable = {
    [0] = E_MODEL_ROCK_SHOT,
    [1] = E_MODEL_ROCK_POWERSHOT,
    [2] = E_MODEL_ROCK_CHARGESHOT
}

----------------
-- Shard Toss --
----------------
-- Main object behavior.
function rock_shot_init(o)
    local np = network_player_from_global_index(o.oShotOwner)
    local m = gMarioStates[np.localIndex]

    o.oFlags =
        (OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO | OBJ_FLAG_COMPUTE_DIST_TO_MARIO | OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW |
        OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)

    o.activeFlags = o.activeFlags | ACTIVE_FLAG_UNK9

    if (m.playerIndex ~= 0) then
        o.oIntangibleTimer = 0
        if gServerSettings.playerInteractions == PLAYER_INTERACTIONS_PVP then
            o.oInteractType = INTERACT_DAMAGE
            o.oDamageOrCoinValue = 1
        end
    end
    
    cur_obj_scale(1)
    o.oFriction = 1
    o.oVelY = 0

    -- hitbox
    o.hitboxRadius = 80
    o.oWallHitboxRadius = 0
    o.hitboxHeight = 80
    o.hitboxDownOffset = 80
    obj_set_model_extended(o, shotModelTable[o.oChargeLevel])

    --network_init_object(o, true, { "oShotOwner" })

end

function rock_shot_loop(o)
    local collisionFlags = object_step()
    o.oForwardVel = 60
    obj_set_model_extended(o, shotModelTable[o.oChargeLevel])
    
    if (collisionFlags & OBJ_COL_FLAG_GROUNDED) ~= 0 
        or (collisionFlags & OBJ_COL_FLAG_HIT_WALL) ~= 0
        or o.oTimer > 9000 then
            rock_shot_death(o)
    end
    
    --[[if projectileattack(o, o.oMoveAngleYaw) then
        rock_shot_death(o)
    end]]
    o.oInteractStatus = o.oInteractStatus + ~(INT_STATUS_INTERACTED)
end

-- Interactions

function rock_shot_hit_other_players(o)
    local np = network_player_from_global_index(o.oShotOwner)
    local m = gMarioStates[np.localIndex]
    local player = nearest_mario_state_to_object(o)
    if player ~= nil and obj_check_hitbox_overlap(o, player.marioObj) and player.playerIndex ~= m.playerIndex then
        return true
    end
    return false
end

function rock_shot_death(o)
    local position = {x = o.oPosX, y = o.oPosY, z =o.oPosZ,}
    obj_mark_for_deletion(o)
end

id_bhvRockShot = hook_behavior(nil, OBJ_LIST_GENACTOR, true, rock_shot_init, rock_shot_loop)

--[[function field_test()
    local goomba = obj_get_first_with_behavior_id(id_bhvGoomba)
    goomba.oShotOwner = math.random(0, 16)
    djui_chat_message_create("Shot owner is " .. goomba.oShotOwner)
end

hook_event(HOOK_UPDATE, field_test)]]