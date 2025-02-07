local love = require"love"
local Player = require"Player"

-------------------------------------------------------------------------
function love.load()
    love.mouse.setVisible(false)--the mouse cursor won't be visible in the game.
    mouse_x,mouse_y = 0,0

    local show_debugging = true
    player = Player(show_debugging)
end
-------------------------------------------------------------------------
function love.keypressed(key)
    if key=="w" then
        player.thrusting=true
    end
end
function love.keyreleased(key)
    if key=="w" then
        player.thrusting=false
    end
end

function love.update(dt)
    mouse_x,mouse_y = love.mouse.getPosition()
    player:movePlayer()
end
-------------------------------------------------------------------------
function love.draw()
    player:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf(
        "FPS: "..love.timer.getFPS(),
        love.graphics.newFont(16),--font-size
        10,--the x position on screen
        love.graphics.getHeight()-30,--the y position on screen
        love.graphics.getWidth()--Wrap the line after this many horizontal pixels.
        )--this will get you the FPS counter
end