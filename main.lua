function love.load()
    success = love.window.setMode(800, 800)
    love.graphics.clear(0.93, 0.75, 0.92, 1)
    time = 0
    dark = false
end

function love.draw()
    if love.timer.getTime() - time >= 2 then
        time = love.timer.getTime()
        dark = not dark
    end
    if dark then
        love.graphics.clear(0.03, 0.08, 0.16, 1)
    else
        love.graphics.clear(0.93, 0.75, 0.92, 1)
    end
end
