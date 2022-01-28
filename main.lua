LIGHT_BG = {0.93, 0.75, 0.92, 1}
DARK_BG = {0.03, 0.08, 0.16, 1}

state = {
    swap_time = 2.0,
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
end
