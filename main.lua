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

state = {
    swap_time = 2.0,
    jmp_time = 0.5,
    dark = false,
}

function love.load()
    success = love.window.setMode(800, 800)
end

function love.update()
    state.swap_time = state.swap_time - love.timer.getDelta()
    if state.swap_time < 0 then
        state.swap_time = 2.0
        dark = not dark
    end
end

function love.draw()
    if dark then
        love.graphics.clear(DARK_BG)
    else
        love.graphics.clear(LIGHT_BG)
    end

    for x=1, 3 do
        for y=1, 3 do
            pos = grid[y][x]
            if obj[y][x][2] == 'p' then
                love.graphics.setColor(PURP)
            else
                love.graphics.setColor(YELLO)
            end
            if obj[y][x][1] == 't' then
                love.graphics.polygon("fill", pos[1]-50,pos[2]+50, pos[1]+20,pos[2]-50, pos[1]+50,pos[2]+50)
            else
                love.graphics.circle("fill", pos[1], pos[2], 50, 500)
            end
        end
    end
end
