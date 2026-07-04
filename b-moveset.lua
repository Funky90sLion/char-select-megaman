
gRockStates = {}
for i = 0, (MAX_PLAYERS - 1) do
    gRockStates[i] = {}
    local m = gMarioStates[i]
    local r = gRockStates[i]
    r.shootAnimState = 0
    r.chargeLevel = 0
end

ACT_ROCK_WALKING = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING)
ACT_ROCK_SHOOTING_IDLE = allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_STATIONARY)
ACT_ROCK_JUMP = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_MOVING | ACT_FLAG_AIR | ACT_FLAG_CONTROL_JUMP_HEIGHT | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_ROCK_FALL = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_MOVING | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_ROCK_SLIDE = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_ATTACKING)

function rock_update_movement_speed(m)
    local maxTargetSpeed = 32.0
    local targetSpeed = 0

    if (m.floor ~= nil and m.floor.type == SURFACE_SLOW) then
        maxTargetSpeed = 24.0
    else
        maxTargetSpeed = 32.0
    end
	
	if m.intendedMag < maxTargetSpeed then
		targetSpeed = m.intendedMag
	else
		targetSpeed = maxTargetSpeed * m.intendedMag / 32
	end

    if (m.quicksandDepth > 10.0) then
        targetSpeed = targetSpeed * (6.25 / m.quicksandDepth)
    end

    mario_set_forward_vel(m, math.min(targetSpeed, 48))
	
    if analog_stick_held_back(m) ~= 0 then
	    m.faceAngle.y = m.intendedYaw
        m.forwardVel = math.abs(m.forwardVel)
    else
	    m.faceAngle.y = m.intendedYaw - approach_s32(math.s16(m.intendedYaw - m.faceAngle.y), 0, 0x1000, 0x1000)
    end
end

function play_step_sound_custom(m, frame1, frame2)
    local stepSound = SOUND_ACTION_TERRAIN_STEP

    if (m.flags & MARIO_METAL_CAP) ~= 0 then
        if (m.marioObj.header.gfx.animInfo.animID == get_character_anim(m, CHAR_ANIM_TIPTOE)) then
            stepSound = SOUND_ACTION_METAL_STEP_TIPTOE
        else
            stepSound = SOUND_ACTION_METAL_STEP
        end

    elseif (m.quicksandDepth > 50.0) then
        stepSound = SOUND_ACTION_QUICKSAND_STEP

    elseif (m.marioObj.header.gfx.animInfo.animID == get_character_anim(m, CHAR_ANIM_TIPTOE)) then
        stepSound = SOUND_ACTION_TERRAIN_STEP_TIPTOE
    else
        stepSound = SOUND_ACTION_TERRAIN_STEP
    end

    if (is_anim_past_frame(m, frame1) ~= 0 or is_anim_past_frame(m, frame2) ~= 0) then
        
        if m.pos.y + 80 < m.waterLevel or m.quicksandDepth > 50.0 then
            play_sound(stepSound + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject)
        else
            play_sound_and_spawn_particles(m, stepSound, 0)
        end
    end
end

function rock_anim_and_audio_for_walk(m)
    if not m then return end
    local r = gRockStates[m.playerIndex]
    local val14
    local marioObj = m.marioObj
    local val0C = true
    local targetPitch = 0
    local val04

    val04 = (m.intendedMag > m.forwardVel) and m.intendedMag or m.forwardVel

    if val04 < 4.0 then
        val04 = 4.0
    end

    if m.quicksandDepth > 50.0 then
        val14 = math.floor(val04 / 4.0 * 0x10000)
        set_character_anim_with_accel(m, CHAR_ANIM_MOVE_IN_QUICKSAND, val14)
        play_step_sound_custom(m, 19, 93)
        m.actionTimer = 0
    else
        while val0C do
            if m.actionTimer == 0 then
                if val04 > 8.0 then
                    m.actionTimer = 2
                else
                    val14 = math.floor(val04 / 4.0 * 0x10000)
                    if val14 < 0x1000 then
                        val14 = 0x1000
                    end
                    set_character_anim_with_accel(m, CHAR_ANIM_START_TIPTOE, val14)
                    play_step_sound_custom(m, 7, 22)
                    if is_anim_past_frame(m, 23) then
                        m.actionTimer = 2
                    end
                    val0C = false
                end
            elseif m.actionTimer == 1 then
                if val04 > 8.0 then
                    m.actionTimer = 2
                else
                    val14 = math.floor(val04 * 0x10000)
                    if val14 < 0x1000 then
                        val14 = 0x1000
                    end
                    set_character_anim_with_accel(m, CHAR_ANIM_TIPTOE, val14)
                    play_step_sound_custom(m, 14, 72)
                    val0C = false
                end
            elseif m.actionTimer == 2 then
                if val04 < 5.0 then
                    m.actionTimer = 1
                elseif val04 > 22.0 then
                    m.actionTimer = 3
                else
                    val14 = math.floor(val04 / 4.0 * 0x10000)
                    set_character_anim_with_accel(m, CHAR_ANIM_WALKING, val14)
                    play_step_sound_custom(m, 10, 49)
                    val0C = false
                end
            elseif m.actionTimer == 3 then
                if val04 < 18.0 then
                    m.actionTimer = 2
                else
                    val14 = math.floor(val04 / 4.0 * 0xC000)
                    if r.shootAnimState > 0 then
                        set_character_anim_with_accel(m, CHAR_ANIM_RUNNING_UNUSED, val14)
                    else
                        set_character_anim_with_accel(m, CHAR_ANIM_RUNNING, val14)
                    end

                    play_step_sound_custom(m, 9, 45)
                    targetPitch = tilt_body_running(m)
                    val0C = false
                end
            else
                val0C = false
            end
        end
    end

    marioObj.oMarioWalkingPitch = approach_s32(marioObj.oMarioWalkingPitch, targetPitch, 0x800, 0x800)
    marioObj.header.gfx.angle.x = marioObj.oMarioWalkingPitch
end

function act_rock_walking(m)
    local startYaw = m.faceAngle.y
    mario_drop_held_object(m)

    m.actionState = 0
	rock_update_movement_speed(m)
	local stepResult = perform_ground_step(m)

    if stepResult == GROUND_STEP_LEFT_GROUND then
		set_mario_action(m, ACT_FREEFALL, 0)
		set_mario_animation(m, MARIO_ANIM_GENERAL_FALL)
    elseif stepResult == GROUND_STEP_NONE then
		rock_anim_and_audio_for_walk(m)
        --m.marioObj.header.gfx.animInfo.animAccel = m.marioObj.header.gfx.animInfo.animAccel * 0.75
		if (m.intendedMag - m.forwardVel) > 16 then
			set_mario_particle_flags(m, PARTICLE_DUST, false)
		end
    elseif stepResult == GROUND_STEP_HIT_WALL then
		push_or_sidle_wall(m, m.pos)
		m.actionTimer = 0
	end
	
    check_ledge_climb_down(m)

    --m.marioBodyState.allowPartRotation = true
	--tilt_body_walking(m, startYaw)
	
	if should_begin_sliding(m) ~= 0 then
        return set_mario_action(m, ACT_BEGIN_SLIDING, 0)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_CROUCH_SLIDE, 0)
    end

    if (m.controller.buttonPressed & Y_BUTTON) ~= 0 then
        set_mario_action(m, ACT_MOVE_PUNCHING, 0)
    end

    if (m.input & INPUT_FIRST_PERSON) ~= 0 then
        return begin_braking_action(m)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jump_from_landing(m)
    end

    if (m.input & INPUT_ZERO_MOVEMENT) ~= 0 then
		return set_mario_action(m, ACT_IDLE, 0)
    end

    return 0
end

function act_rock_shooting_idle(m)
    local r = gRockStates[m.playerIndex]

    r.shootAnimState = 15

    stationary_ground_step(m)
	set_character_animation(m, CHAR_ANIM_FIRST_PUNCH)
    smlua_anim_util_set_animation(m.marioObj, "megaman_shoot")
    set_anim_to_frame(m, m.actionTimer)

    if m.actionTimer > 2 and (m.controller.buttonPressed & B_BUTTON) ~= 0 then
        m.actionTimer = 0
    end

    if check_common_idle_cancels(m) ~= 0 then
        return 1
    end

    if is_anim_past_end(m) ~= 0 then
        set_mario_action(m, ACT_IDLE, 0)
    end

    m.actionTimer = m.actionTimer + 1
end

function act_rock_jump(m)
    local r = gRockStates[m.playerIndex]

    if m.actionTimer == 0 then
        play_character_sound_if_no_flag(m, CHAR_SOUND_YAH_WAH_HOO, MARIO_ACTION_SOUND_PLAYED)
    end

	rock_update_movement_speed(m)
	local stepResult = perform_air_step(m, AIR_STEP_CHECK_LEDGE_GRAB | AIR_STEP_CHECK_HANG)
	set_character_animation(m, CHAR_ANIM_DOUBLE_JUMP_RISE)

    if r.shootAnimState > 0 then
        smlua_anim_util_set_animation(m.marioObj, "megaman_jump_shoot")
    else
        smlua_anim_util_set_animation(m.marioObj, "megaman_jumping")
    end

    if stepResult == AIR_STEP_LANDED then
		set_mario_action(m, ACT_JUMP_LAND, 0)
    elseif stepResult == AIR_STEP_GRABBED_LEDGE then
        set_mario_animation(m, MARIO_ANIM_IDLE_ON_LEDGE)
        drop_and_set_mario_action(m, ACT_LEDGE_GRAB, 0)
    elseif stepResult == AIR_STEP_GRABBED_CEILING then
        set_mario_action(m, ACT_START_HANGING, 0)
	end

    m.actionTimer = m.actionTimer + 1
end

function act_rock_fall(m)
    local r = gRockStates[m.playerIndex]

	rock_update_movement_speed(m)
	local stepResult = perform_air_step(m, AIR_STEP_CHECK_LEDGE_GRAB)
	set_character_animation(m, CHAR_ANIM_DOUBLE_JUMP_RISE)

    if r.shootAnimState > 0 then
        smlua_anim_util_set_animation(m.marioObj, "megaman_jump_shoot")
    else
        smlua_anim_util_set_animation(m.marioObj, "megaman_jumping")
    end

    if m.marioObj.header.gfx.animInfo.animFrame < 6 then
        set_anim_to_frame(m, 6)
    end

    if stepResult == AIR_STEP_LANDED then
		set_mario_action(m, ACT_FREEFALL_LAND, 0)
    elseif stepResult == AIR_STEP_GRABBED_LEDGE then
        set_mario_animation(m, MARIO_ANIM_IDLE_ON_LEDGE)
        drop_and_set_mario_action(m, ACT_LEDGE_GRAB, 0)
    elseif stepResult == AIR_STEP_GRABBED_CEILING then
        set_mario_action(m, ACT_START_HANGING, 0)
	end

    m.actionTimer = m.actionTimer + 1
end

function act_rock_gravity(m)
    if (m.action & ACT_FLAG_CONTROL_JUMP_HEIGHT) ~= 0 then
        if m.vel.y > 0 and (m.controller.buttonDown & A_BUTTON) == 0 then
            m.vel.y = 0
        end
    end

    local gravity = (m.pos.y + 30 < m.waterLevel) and 2 or 6

    m.vel.y = math.max(m.vel.y - gravity, -64)
end

function act_rock_slide(m)

    if m.actionTimer == 0 then
        play_character_sound_if_no_flag(m, CHAR_SOUND_HOOHOO, MARIO_ACTION_SOUND_PLAYED)
    elseif m.actionTimer > 15 then
		set_mario_action(m, ACT_ROCK_WALKING, 0)
    end

	local stepResult = perform_ground_step(m)
	set_character_animation(m, CHAR_ANIM_SLIDE_KICK)

    if stepResult == GROUND_STEP_NONE then
		mario_set_forward_vel(m, 72)
        set_mario_particle_flags(m, PARTICLE_DUST, false)
        play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject)
    elseif stepResult == GROUND_STEP_HIT_WALL then
        if obj_is_breakable_object(m.wall.object) == 0 then
		    set_mario_action(m, ACT_ROCK_WALKING, 0)
        end
    elseif stepResult == GROUND_STEP_LEFT_GROUND then
        set_mario_action(m, ACT_FREEFALL, 0)
	end

    if math.abs(m.faceAngle.y - m.intendedYaw) > 0x3000 then
        m.faceAngle.y = m.intendedYaw
		set_mario_action(m, ACT_ROCK_WALKING, 0)
    end

    m.actionTimer = m.actionTimer + 1
end

function rock_update(m)
    local r = gRockStates[m.playerIndex]
    
    -- Splash.
    if m.pos.y <= m.waterLevel and m.pos.y >= m.waterLevel - math.abs(m.vel.y) then
        if math.abs(m.vel.y) > 40 then
            m.particleFlags = m.particleFlags + PARTICLE_WATER_SPLASH
            play_sound(SOUND_ACTION_UNKNOWN430, m.marioObj.header.gfx.cameraToObject)
        elseif math.abs(m.vel.y) > 0 then
            m.particleFlags = m.particleFlags + PARTICLE_SHALLOW_WATER_SPLASH
            play_sound(SOUND_ACTION_UNKNOWN431, m.marioObj.header.gfx.cameraToObject)
        end
    end

    if (m.controller.buttonPressed & Y_BUTTON) ~= 0 and m.action == ACT_IDLE then
        set_mario_action(m, ACT_PUNCHING, 0)
    end

    if r.chargeLevel > 30 and m.action == ACT_IDLE and (m.controller.buttonDown & B_BUTTON) == 0 then
        set_mario_action(m, ACT_ROCK_SHOOTING_IDLE, 0)
    end

    r.shootAnimState = r.shootAnimState - 1
end

function rock_on_set_action(m)
    local r = gRockStates[m.playerIndex]
	if m.action == ACT_WALKING then
		return set_mario_action(m, ACT_ROCK_WALKING, 0)
	end

	if ((m.action == ACT_PUNCHING or m.action == ACT_MOVE_PUNCHING) and m.actionArg == 9) or m.action == ACT_SLIDE_KICK then
		return set_mario_action(m, ACT_ROCK_SLIDE, 0)
	end

    if (m.controller.buttonPressed & B_BUTTON) ~= 0 and m.action == ACT_PUNCHING then
        set_mario_action(m, ACT_ROCK_SHOOTING_IDLE, 0)
    end

    local jumpActions = {
        [ACT_JUMP] = true,
        [ACT_DOUBLE_JUMP] = true,
        [ACT_STEEP_JUMP] = true
    }

	if jumpActions[m.action] then
        m.vel.y = 64
	    set_mario_action(m, ACT_ROCK_JUMP, 0)
	end

	if m.action == ACT_FREEFALL then
	    m.action = ACT_ROCK_FALL
	end
    r.shootAnimState = 0
end

function rock_on_interact(m, o, intType)
    if (m.action == ACT_ROCK_WALKING) then
        if obj_has_behavior_id(o, id_bhvDoorWarp) ~= 0 then
            set_mario_action(m, ACT_DECELERATING, 0)
            interact_warp_door(m, 0, o)
        elseif obj_has_behavior_id(o, id_bhvDoor) ~= 0 or obj_has_behavior_id(o, id_bhvStarDoor) ~= 0 then
            set_mario_action(m, ACT_DECELERATING, 0)
            interact_door(m, 0, o)
        end
    end
end

-- This one needs to be a global Mario update.

function rock_shoot_lemon(m, level)
    local r = gRockStates[m.playerIndex]
    r.shootAnimState = 15
    
    if (m.playerIndex == 0) then
        spawn_non_sync_object(
            id_bhvRockShot,
            E_MODEL_NONE,
            m.pos.x, m.pos.y + 80, m.pos.z,
            function (o)
                o.oMoveAngleYaw = m.faceAngle.y
                o.oShotOwner = gNetworkPlayers[m.playerIndex].globalIndex
                o.oChargeLevel = level
            end
        )

        --TODO: Sync this later.
        network_send(true, { type = 'shot',
            m = gNetworkPlayers[m.playerIndex].globalIndex
        })
    end
    r.chargeLevel = 0
end

function rock_pew_pew(m)
    local r = gRockStates[m.playerIndex]

    if _G.charSelect.character_get_current_number(m.playerIndex) == CT_MEGAMAN then
        local rockShootActs = {
            [ACT_ROCK_JUMP] = true,
            [ACT_ROCK_WALKING] = true,
            [ACT_ROCK_SHOOTING_IDLE] = true
        }

        if (m.controller.buttonPressed & B_BUTTON) ~= 0 and rockShootActs[m.action] then
            rock_shoot_lemon(m, 0)
        end

        if (m.controller.buttonDown & B_BUTTON) ~= 0 then
            r.chargeLevel = math.min(r.chargeLevel + 1, 65)
            djui_chat_message_create(tostring(math.floor(r.chargeLevel / 30)))
            
        else
            if r.chargeLevel > 30 and rockShootActs[m.action]  then
                rock_shoot_lemon(m, math.floor(r.chargeLevel / 30))
            end
        end
    else
       r.shootAnimState = 0
       r.chargeLevel = 0
       return
    end
end

hook_event(HOOK_MARIO_UPDATE, rock_pew_pew)

hook_mario_action(ACT_ROCK_WALKING, act_rock_walking)
hook_mario_action(ACT_ROCK_SHOOTING_IDLE, act_rock_shooting_idle)
hook_mario_action(ACT_ROCK_JUMP, {every_frame = act_rock_jump, gravity = act_rock_gravity})
hook_mario_action(ACT_ROCK_FALL, {every_frame = act_rock_fall, gravity = act_rock_gravity})
hook_mario_action(ACT_ROCK_SLIDE, act_rock_slide, INT_KICK)