LIGHT_BG = {0.97, 0.86, 0.96, 1}
DARK_BG = {0.03, 0.08, 0.16, 1}

PURP = {0.61, 0.25, 0.8, 1}
YELLO = {1, 1, 0.31, 1}

GREN = {0.52, 0.92, 0.49, 1}

grid = {{{200, 200},{400, 200},{600, 200}},
        {{200, 400},{400, 400},{600, 400}},
        {{200, 600},{400, 600},{600, 600}}}

obj = {{{'t','p'},{'c','y'},{'t','y'}},
       {{'c','p'},{'t','p'},{'c','p'}},
       {{'t','y'},{'t','y'},{'t','y'}}}

d_pos = {{0, 0, 0,},
         {0, 0, 0,},
         {0, 0, 0,}}

selector_pos = {1,1}

MOVE_P = 0.4
D_POS_PIXELS = 20
MOVE_P_DIR_STEP = 0.25  -- 0.5, 0.75, 1.0, so max 2 steps in any direction

swap_time = 2.0
jump_time = 0.5
dark = false
selected = false

function love.load()
    success = love.window.setMode(800, 800)
    music = love.audio.newSource("sound/boopy-song.wav", "stream")
    music:setLooping(true)
    music:play()
    selector = love.graphics.newImage("selector.png")
end

function love.update()
    -- TODO timer table
    swap_time = swap_time - love.timer.getDelta()
    if swap_time < 0 then
        swap_time = swap_time + 2.0
        dark = not dark
    end

    jump_time = jump_time - love.timer.getDelta()
    if jump_time < 0 then
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
    if key == "right" then
        selector_pos[1] = ((selector_pos[1]) % 3) + 1
    elseif key == "left" then
        selector_pos[1] = ((selector_pos[1] - 2) % 3) + 1
    elseif key == "up" then
        selector_pos[2] = ((selector_pos[2] - 2) % 3) + 1
    elseif key == "down" then
        selector_pos[2] = ((selector_pos[2]) % 3) + 1
    elseif key == "return" then
        selected = not selected
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
            if obj[iy][ix][2] == 'p' then
                love.graphics.setColor(PURP)
            else
                love.graphics.setColor(YELLO)
            end
            pos = grid[iy][ix]
            x = pos[1]
            y = pos[2] + d_pos[iy][ix] * D_POS_PIXELS
            if obj[iy][ix][1] == 't' then
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
