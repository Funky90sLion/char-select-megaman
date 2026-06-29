ACT_ROCK_WALKING = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING)
ACT_ROCK_JUMP = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_MOVING | ACT_FLAG_AIR | ACT_FLAG_CONTROL_JUMP_HEIGHT | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)

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
		targetSpeed = maxTargetSpeed
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
		anim_and_audio_for_walk(m)
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

function act_rock_jump(m)

    if m.actionTimer == 0 then
        play_character_sound_if_no_flag(m, CHAR_SOUND_YAH_WAH_HOO, MARIO_ACTION_SOUND_PLAYED)
    end

	rock_update_movement_speed(m)
	local stepResult = perform_air_step(m, AIR_STEP_CHECK_LEDGE_GRAB | AIR_STEP_CHECK_HANG)
	set_character_animation(m, CHAR_ANIM_SINGLE_JUMP)

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

function act_rock_gravity(m)
    if (m.action & ACT_FLAG_CONTROL_JUMP_HEIGHT) ~= 0 then
        if m.vel.y > 0 and (m.controller.buttonDown & A_BUTTON) == 0 then
            m.vel.y = 0
        end
    end

    local gravity = (m.pos.y + 30 < m.waterLevel) and 2 or 6

    m.vel.y = math.max(m.vel.y - gravity, -64)
end

function rock_update(m)
    
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
end

function rock_on_set_action(m)
	if m.action == ACT_WALKING then
		return set_mario_action(m, ACT_ROCK_WALKING, 0)
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

    -- Might use a separate action later.
	if m.action == ACT_FREEFALL then
	    m.action = ACT_ROCK_JUMP
	end
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

hook_mario_action(ACT_ROCK_WALKING, act_rock_walking)
hook_mario_action(ACT_ROCK_JUMP, {every_frame = act_rock_jump, gravity = act_rock_gravity})