function geo_custom_mouth_switch(n)
    local switch = cast_graph_node(n)
    local m = geo_get_mario_state()

    if m.action == ACT_ROCK_JUMP or m.action == ACT_ROCK_SLIDE then
        switch.selectedCase = 1
    elseif m.action == ACT_ROCK_WALKING or m.action == ACT_ROCK_SHOOTING_IDLE then
        switch.selectedCase = 2
    else
        switch.selectedCase = 0
    end
end

function geo_custom_happy_eyes(n)
    local switch = cast_graph_node(n)
    local m = geo_get_mario_state()
end

function geo_custom_megabuster(n)
    local switch = cast_graph_node(n)
    local m = geo_get_mario_state()
    local r = gRockStates[m.playerIndex]

    if switch.parameter == 1 then
        if r.shootAnimState > 0 or m.action == ACT_ROCK_SHOOTING_IDLE then
            switch.selectedCase = 1
        else
            switch.selectedCase = 0
        end
    end
    
end

function geo_custom_scale_megabuster(n)
    local switch = cast_graph_node(n)
    local m = geo_get_mario_state()
end

function geo_custom_megabuster_lights(n)
    local switch = cast_graph_node(n)
    local m = geo_get_mario_state()
    local r = gRockStates[m.playerIndex]
    djui_chat_message_create(tostring(switch.selectedCase))

    switch.selectedCase = 2
end