LIGHT_BG = {0.97, 0.86, 0.96, 1}
DARK_BG = {0.03, 0.08, 0.16, 1}

PURP = {0.61, 0.25, 0.8, 1}
YELLO = {1, 1, 0.31, 1}

grid = {{{200, 200},{400, 200},{600, 200}},
        {{200, 400},{400, 400},{600, 400}},
        {{200, 600},{400, 600},{600, 600}}}

obj = {{{'t','p'},{'c','y'},{'t','y'}},
       {{'c','p'},{'t','p'},{'c','p'}},
       {{'t','y'},{'t','y'},{'t','y'}}}

d_pos = {{0, 0, 0,},
         {0, 0, 0,},
         {0, 0, 0,}}

MOVE_P = 0.4
D_POS_PIXELS = 20
MOVE_P_DIR_STEP = 0.25  -- 0.5, 0.75, 1.0, so max 2 steps in any direction

state = {
    swap_time = 2.0,
    jump_time = 0.5,
    dark = false,
}

function love.load()
    success = love.window.setMode(800, 800)
end

function love.update()
    -- TODO timer table
    state.swap_time = state.swap_time - love.timer.getDelta()
    if state.swap_time < 0 then
        state.swap_time = state.swap_time + 2.0
        state.dark = not state.dark
    end

    state.jump_time = state.jump_time - love.timer.getDelta()
    if state.jump_time < 0 then
        state.jump_time = state.jump_time + 0.5
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

function love.draw()
    if state.dark then
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
end
