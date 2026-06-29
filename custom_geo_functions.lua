function geo_custom_mouth_switch(n)
    local switch = cast_graph_node(n)
    local m = geo_get_mario_state()

    if m.action == ACT_ROCK_JUMP then
        switch.selectedCase = 2
    elseif m.action == ACT_ROCK_WALKING then
        switch.selectedCase = 1
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
end

function geo_custom_scale_megabuster(n)
    local switch = cast_graph_node(n)
    local m = geo_get_mario_state()
end

function geo_custom_megabuster_lights(n)
    local switch = cast_graph_node(n)
    local m = geo_get_mario_state()
end