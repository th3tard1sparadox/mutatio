LIGHT_BG = {0.97, 0.86, 0.96, 1}
DARK_BG = {0.03, 0.08, 0.16, 1}

PURP = {0.61, 0.25, 0.8, 1}
YELLO = {1, 1, 0.31, 1}

GREN = {0.52, 0.92, 0.49, 1}

grid = {{{200, 200},{400, 200},{600, 200}},
        {{200, 400},{400, 400},{600, 400}},
        {{200, 600},{400, 600},{600, 600}}}

-- true = triange
obj = {{{true,true},{false,false},{true,false}},
       {{false,true},{true,true},{false,true}},
       {{true,false},{true,false},{true,false}}}

d_pos = {{0, 0, 0,},
         {0, 0, 0,},
         {0, 0, 0,}}

selector_pos = {1,1}
selector_start_pos = nil

MOVE_P = 0.4
D_POS_PIXELS = 20
MOVE_P_DIR_STEP = 0.25  -- 0.5, 0.75, 1.0, so max 2 steps in any direction

swap_time = 1.25
jump_time = 0.625
dark = false
selected = false

function generate_obj()
    for _, y in pairs(obj) do
        for _, x in pairs(y) do
            for i, _ in pairs(x) do
                if love.math.random() > 0.5 then
                    x[i] = true
                else
                    x[i] = false
                end
            end
        end
    end

end

function copy_values(table)
    new_table = {}
    for k,v in pairs(table) do
        new_table[k] = v
    end
    return new_table
end

-- all k, v in a is in b as well
-- a <= b when seen as sets
function is_subtable(a, b)
    for k,v in pairs(a) do
        if v ~= b[k] then
            return false
        end
    end
    return true
end

-- a and b contains only the same k, v
-- a == b when seen as sets
function equal_tables(a, b)
    return is_subtable(a, b) and is_subtable(b, a)
end

function love.load()
    success = love.window.setMode(800, 800)
    music = love.audio.newSource("sound/boopy-song.wav", "stream")
    music:setLooping(true)
    music:play()
    jump_time = 0
    swap_time = 0
    selector = love.graphics.newImage("selector.png")
    generate_obj()
end

function love.update()
    -- TODO timer table
    swap_time = swap_time - love.timer.getDelta()
    if swap_time <= 0 then
        swap_time = swap_time + 2.0
        dark = not dark
    end

    jump_time = jump_time - love.timer.getDelta()
    if jump_time <= 0 then
        jump_time = jump_time + 0.5
        for ix=1, 3 do
            for iy=1, 3 do
                if love.math.random() < MOVE_P then
                    move_up = love.math.random() < 0.5 + MOVE_P_DIR_STEP * d_pos[iy][ix]
                    if move_up then
                        d_pos[iy][ix] = d_pos[iy][ix] - 1
                    else
                        d_pos[iy][ix] = d_pos[iy][ix] + 1
                    end
                end
            end
        end
    end
end

function love.keypressed(key)
    -- if selected, only allow moves if the other dimension hasn't changed
    -- TODO flash red on invalid movement
    -- TODO ghost on selector_start_pos
    prev_pos = copy_values(selector_pos)
    if key == "right" then
        if not selected or (selected and selector_start_pos[2] == selector_pos[2]) then
            if selector_pos[1] < 3 then
                selector_pos[1] = selector_pos[1] + 1
            end
        end
    elseif key == "left" then
        if not selected or (selected and selector_start_pos[2] == selector_pos[2]) then
            if selector_pos[1] > 1 then
                selector_pos[1] = selector_pos[1] - 1
            end
        end
    elseif key == "up" then
        if not selected or (selected and selector_start_pos[1] == selector_pos[1]) then
            if selector_pos[2] > 1 then
                selector_pos[2] = selector_pos[2] - 1
            end
        end
    elseif key == "down" then
        if not selected or (selected and selector_start_pos[1] == selector_pos[1]) then
            if selector_pos[2] < 3 then
                selector_pos[2] = selector_pos[2] + 1
            end
        end
    elseif key == "return" then
        if not selected then
            selected = true
            selector_start_pos = copy_values(selector_pos)
        else
            selected = false
            if not equal_tables(selector_start_pos, selector_pos) then
                if obj[selector_pos[2]][selector_pos[1]][1] then
                    if selector_start_pos[1] == selector_pos[1] then -- y move
                        for i = math.min(selector_start_pos[2], selector_pos[2]), math.max(selector_start_pos[2], selector_pos[2]) do
                            if i ~= selector_pos[2] then
                                obj[i][selector_pos[1]][2] = not obj[i][selector_pos[1]][2]
                            end
                        end
                    else
                        for i = math.min(selector_start_pos[1], selector_pos[1]), math.max(selector_start_pos[1], selector_pos[1]) do
                            if i ~= selector_pos[1] then
                                obj[selector_pos[2]][i][2] = not obj[selector_pos[2]][i][2]
                            end
                        end
                    end
                else
                    if selector_start_pos[1] == selector_pos[1] then -- y move
                        for i = math.min(selector_start_pos[2], selector_pos[2]), math.max(selector_start_pos[2], selector_pos[2]) do
                            if i ~= selector_pos[2] then
                                obj[i][selector_pos[1]][1] = not obj[i][selector_pos[1]][1]
                            end
                        end
                    else
                        for i = math.min(selector_start_pos[1], selector_pos[1]), math.max(selector_start_pos[1], selector_pos[1]) do
                            if i ~= selector_pos[1] then
                                obj[selector_pos[2]][i][1] = not obj[selector_pos[2]][i][1]
                            end
                        end
                    end
                end
            end
            selector_start_pos = nil
        end
    end

    if selected and not equal_tables(prev_pos, selector_pos) then
        to_swap = obj[prev_pos[2]][prev_pos[1]]
        obj[prev_pos[2]][prev_pos[1]] = obj[selector_pos[2]][selector_pos[1]]
        obj[selector_pos[2]][selector_pos[1]] = to_swap
    end
end

function love.draw()
    if dark then
        love.graphics.clear(DARK_BG)
    else
        love.graphics.clear(LIGHT_BG)
    end

    for ix=1, 3 do
        for iy=1, 3 do
            if obj[iy][ix][2] == true and dark or obj[iy][ix][2] == false and not dark then
                love.graphics.setColor(PURP)
            else
                love.graphics.setColor(YELLO)
            end
            pos = grid[iy][ix]
            x = pos[1]
            y = pos[2] + d_pos[iy][ix] * D_POS_PIXELS
            if obj[iy][ix][1] == true then
                love.graphics.polygon("fill", x-50, y+50, x+20, y-50, x+50, y+50)
            else
                love.graphics.circle("fill", x, y, 50, 500)
            end
        end
    end

    x = grid[selector_pos[2]][selector_pos[1]][1]
    y = grid[selector_pos[2]][selector_pos[1]][2]

    if dark then
        love.graphics.setColor(LIGHT_BG)
    else
        love.graphics.setColor(DARK_BG)
    end

    if selected then
        love.graphics.setColor(GREN)
    end
    love.graphics.draw(selector, x-65, y-65)
end
