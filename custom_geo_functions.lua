

function geo_custom_mouth_switch(n)
    local switch = cast_graph_node(n)
    local m = geo_get_mario_state()

    if m.action == ACT_JUMP then
        switch.selectedCase = 2
        m.actionTimer = 0
    else
        switch.selectedCase = 0
    end
end