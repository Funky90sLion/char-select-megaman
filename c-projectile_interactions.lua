
-------------------
--GENERAL ENEMIES--
-------------------

function rock_shot_enemygeneral(o, shot_dir, shot_level)
    if (o.oInteractStatus & INT_STATUS_INTERACTED) == 0 
    and o.oAction ~= OBJ_ACT_VERTICAL_KNOCKBACK and o.oAction ~= OBJ_ACT_HORIZONTAL_KNOCKBACK and o.oAction ~= OBJ_ACT_SQUISHED then
        o.oInteractStatus = ATTACK_PUNCH | INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED
        return true
    else
        return false
    end
end

function rock_shot_goomba(o, shot_dir, shot_level)
    if (o.oInteractStatus & INT_STATUS_INTERACTED) == 0 
    and o.oAction ~= OBJ_ACT_VERTICAL_KNOCKBACK and o.oAction ~= OBJ_ACT_HORIZONTAL_KNOCKBACK and o.oAction ~= OBJ_ACT_SQUISHED then
        if o.oGoombaSize == GOOMBA_SIZE_HUGE then
            o.oInteractStatus = ATTACK_GROUND_POUND_OR_TWIRL | INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED
        else
            o.oInteractStatus = ATTACK_PUNCH | INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED
        end
        return true
    else
        return false
    end
end

function rock_shot_enemygeneral(o, shot_dir, shot_level)
    if (o.oInteractStatus & INT_STATUS_INTERACTED) == 0 
    and o.oAction ~= OBJ_ACT_VERTICAL_KNOCKBACK and o.oAction ~= OBJ_ACT_HORIZONTAL_KNOCKBACK and o.oAction ~= OBJ_ACT_SQUISHED then
        o.oInteractStatus = ATTACK_PUNCH | INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED
        return true
    else
        return false
    end
end

function rock_shot_bigenemygeneral(o, shot_dir, shot_level)
    if (o.oInteractStatus & INT_STATUS_INTERACTED) == 0 then
        o.oInteractStatus = ATTACK_FAST_ATTACK | INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED
        return true
    else
        return false
    end
end

-----------------------
--BOB-OMB BATTLEFIELD--
-----------------------

function rock_shot_bobomb(o, shot_dir, shot_level)
    if (o.oAction ~= BOBOMB_ACT_EXPLODE) then
        if (o.oVelY <= 0) then
            o.oMoveAngleYaw = shot_dir
            o.oForwardVel = 30.0
            o.oVelY = 40.0
            o.oAction = BOBOMB_ACT_LAUNCHED
        end
        return true
    else
        return false
    end
end

function rock_shot_chainchomp(o, shot_dir, shot_level)
    if shot_level == 3  then
        o.oSubAction = CHAIN_CHOMP_SUB_ACT_LUNGE
        o.oChainChompMaxDistFromPivotPerChainPart = 900.0 / 5
        o.oForwardVel = 0.0
        o.oVelY = 300.0
        o.oGravity = -4.0
        o.oChainChompTargetPitch = -0x3000
    end
    return true
end

function rock_shot_waterbomb(o, shot_dir, shot_level)
    o.oAction = WATER_BOMB_ACT_EXPLODE
    return true
end

function rock_shot_kingbobomb(o, shot_dir, shot_level)
    if shot_level == 3 and (o.oFlags & OBJ_FLAG_HOLDABLE) ~= 0 and o.oAction ~= 8 then
        o.oVelY = 30
        o.oForwardVel = 30
        o.oMoveAngleYaw = shot_dir
        o.oMoveFlags = 0
        o.oAction = 4
    end
    return true
end

function rock_shot_breakablebox(o, shot_dir, shot_level)
    o.oInteractStatus =  ATTACK_PUNCH | INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED
    return true
end

function rock_shot_breakableboxsmall(o, shot_dir, shot_level)
    o.oInteractStatus = ATTACK_KICK_OR_TRIP | INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED | INT_STATUS_STOP_RIDING
    return true
end

function rock_shot_exclamationbox(o, shot_dir, shot_level)
    if o.oAction ~= 5 and o.oAction ~= 6 then
        o.oInteractStatus = ATTACK_KICK_OR_TRIP | INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED
        return true
    else
        return false
    end
end

--------------------
--WHOMP'S FORTRESS--
--------------------

function rock_shot_bridge(o, shot_dir, shot_level)
    if shot_level == 3 and (o.oFaceAnglePitch > -0x4000) then
        o.oAction = 2
    end
    return true
end

function rock_shot_whomp(o, shot_dir, shot_level)
    if o.oAction ~= 8 and shot_level == 3 then
        o.oNumLootCoins = 5
        obj_spawn_loot_yellow_coins(o, 5, 20.0)
        o.oAction = 8
    end
    return true
end

function rock_shot_whompking(o, shot_dir, shot_level)
    if o.oAction ~= 8 and o.oAction ~= 0 and shot_level == 3 then
        o.oHealth = o.oHealth - 1
        play_sound(SOUND_OBJ2_WHOMP_SOUND_SHORT, o.header.gfx.cameraToObject)
        play_sound(SOUND_OBJ_KING_WHOMP_DEATH, o.header.gfx.cameraToObject)
        if (o.oHealth == 0) then
            o.oAction = 8
        end
    end
    return true
end

function rock_shot_piranhaplant(o, shot_dir, shot_level)
    stop_secondary_music(50)
    if o.oAction ~= PIRANHA_PLANT_ACT_SHRINK_AND_DIE 
    and o.oAction ~= PIRANHA_PLANT_ACT_ATTACKED and o.oAction ~= PIRANHA_PLANT_ACT_WAIT_TO_RESPAWN then
        o.oAction = PIRANHA_PLANT_ACT_ATTACKED
        return true
    end
    return false
end

function rock_shot_bulletbill(o, shot_dir, shot_level)
    if shot_level == 2 then
        o.oAction = 4
    elseif shot_level == 3 then
        o.oAction = 3
        spawn_non_sync_object(id_bhvExplosion, E_MODEL_EXPLOSION, o.oPosX, o.oPosY, o.oPosZ, nil)
    end
    return true
end

----------------------
--COOL COOL MOUNTAIN--
----------------------

function rock_shot_mrblizzard(o, shot_dir, shot_level)
    if o.oAction ~= MR_BLIZZARD_ACT_DEATH then
        o.oAction = MR_BLIZZARD_ACT_DEATH
        return true
    end
    return false
end

----------------------
--SHIFTING SAND LAND--
----------------------
function rock_shot_klepto(o, shot_dir, shot_level)
    o.oInteractStatus = ATTACK_FROM_ABOVE | INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED | INT_STATUS_STOP_RIDING
    return true
end

--------------------
--LETHAL LAVA LAND--
--------------------
function rock_shot_mri(o, shot_dir, shot_level)
    if (o.oAction ~= 3) then
        o.oAction = 3
        o.oTimer = 104
        return true
    end
    return false
end

function rock_shot_bully(o, shot_dir, shot_level)
    o.oMoveAngleYaw = shot_dir
    o.oInteractStatus = INT_STATUS_INTERACTED
    o.oForwardVel = 15
    return true
end

---------------------
---TINY HUGE ISLAND--
---------------------

function rock_shot_spiny(o, shot_dir, shot_level)
    o.oInteractStatus =  ATTACK_PUNCH | INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED
    return true
end

function rock_shot_firepiranhaplant(o, shot_dir, shot_level)
    if o.oAction ~= FIRE_PIRANHA_PLANT_ACT_HIDE then
        o.oInteractStatus = ATTACK_FAST_ATTACK | INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED
        return true
    end
    return false
end

crystalbullettargets = {
    -- BOB
    [id_bhvGoomba] = rock_shot_goomba, 
    [id_bhvKoopa] = rock_shot_enemygeneral,
    [id_bhvBobomb] = rock_shot_bobomb,
    --[id_bhvChainChomp] = rock_shot_chainchomp,
    [id_bhvWaterBomb] = rock_shot_waterbomb,
    [id_bhvKingBobomb] = rock_shot_kingbobomb,
    [id_bhvBreakableBox] = rock_shot_breakablebox,
    [id_bhvBreakableBoxSmall] = rock_shot_breakableboxsmall,
    [id_bhvExclamationBox] = rock_shot_exclamationbox,
    -- WF
    [id_bhvKickableBoard] = rock_shot_bridge,
    [id_bhvWfBreakableWallLeft] = rock_shot_breakablebox,
    [id_bhvWfBreakableWallRight] = rock_shot_breakablebox,
    [id_bhvSmallWhomp] = rock_shot_whomp,
    [id_bhvWhompKingBoss] = rock_shot_whompking,
    [id_bhvPiranhaPlant] = rock_shot_piranhaplant,
    [id_bhvBulletBill] = rock_shot_bulletbill,
    -- CM
    [id_bhvSpindrift] = rock_shot_enemygeneral,
    --[id_bhvMrBlizzard] = rock_shot_mrblizzard,
    -- BBH
    [id_bhvBoo] = rock_shot_enemygeneral,
    [id_bhvGhostHuntBoo] = rock_shot_enemygeneral,
    [id_bhvFlyingBookend] = rock_shot_enemygeneral,
    [id_bhvHauntedChair] = rock_shot_enemygeneral,
    [id_bhvBooInCastle] = rock_shot_enemygeneral,
    [id_bhvBooWithCage] = rock_shot_enemygeneral,
    [id_bhvMerryGoRoundBoo] = rock_shot_bigenemygeneral,
    [id_bhvBalconyBigBoo] = rock_shot_bigenemygeneral,
    [id_bhvGhostHuntBigBoo] = rock_shot_bigenemygeneral,
    [id_bhvMerryGoRoundBigBoo] = rock_shot_bigenemygeneral,
    -- LLL
    [id_bhvMrI] = rock_shot_mri,
    [id_bhvSmallBully] = rock_shot_bully,
    [id_bhvBigBully] = rock_shot_bully,
    [id_bhvBigBullyWithMinions] = rock_shot_bully,
    -- SSL
    [id_bhvPokey] = rock_shot_enemygeneral,
    [id_bhvPokeyBodyPart] = rock_shot_enemygeneral,
    [id_bhvKlepto] = rock_shot_klepto,
    [id_bhvFlyGuy] = rock_shot_enemygeneral,
    [id_bhvEyerokHand] = rock_shot_bigenemygeneral,
    -- HMZ
    [id_bhvScuttlebug] = rock_shot_enemygeneral,
    [id_bhvSnufit] = rock_shot_enemygeneral,
    [id_bhvSwoop] = rock_shot_enemygeneral,
    -- THI
    [id_bhvFirePiranhaPlant] = rock_shot_firepiranhaplant,
    --[id_bhvChuckya] = rock_shot_chuckya,
    [id_bhvEnemyLakitu] = rock_shot_enemygeneral,
    [id_bhvSpiny] = rock_shot_spiny,
    [id_bhvWigglerBody] = rock_shot_klepto,
    [id_bhvWigglerHead] = rock_shot_klepto,
    -- TTM
    [id_bhvMontyMole] = rock_shot_enemygeneral,
    -- WDW
    [id_bhvSkeeter] = rock_shot_enemygeneral,
    -- SL
    [id_bhvSmallChillBully] = rock_shot_bully,
    [id_bhvBigChillBully] = rock_shot_bully,
    [id_bhvMoneybag] = rock_shot_enemygeneral,
}

function projectileattack(obj, shot_dir)
    local hurtenemy = false
    local enemyobj
    
    for key,value in pairs(crystalbullettargets) do --projectilehurtableenemy is a table of enemies that can be hurt by projectiles with each enemy stored by behaviorid
        enemyobj = obj_get_nearest_object_with_behavior_id(obj,key) --get nearest hitable obj
        if enemyobj ~= nil and obj_check_hitbox_overlap(obj, enemyobj) then --check if obj is touching enemy obj
            if crystalbullettargets[key] then
                hurtenemy = crystalbullettargets[key](enemyobj, shot_dir, shot_level)
            end
        end
    end
    return hurtenemy
end