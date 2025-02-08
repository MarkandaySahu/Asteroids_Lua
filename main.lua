local love = require"love"
local Player = require"objects/Player"
local Game = require"states/Game"

math.randomseed(os.time())
-------------------------------------------------------------------------
function love.load()

    love.mouse.setVisible(false)--the mouse cursor won't be visible in the game.
    mouse_x,mouse_y = 0,0

    local show_debugging = true
    player = Player(show_debugging)
    game = Game()
    game:startNewGame(player)
end
-------------------------------------------------------------------------
--keypressed Event
function love.keypressed(key)
    if game.state.running then
        if key=="w" then
            player.thrusting=true
        end
        if key == "escape" then
            game:changeGameState("paused")
        end
    elseif game.state.paused then
        if key == "escape" then
            game:changeGameState("running")
        end
    end
end
function love.keyreleased(key)
    if key=="w" then
        player.thrusting=false
    end
end
--Update
function love.update(dt)
    
    mouse_x,mouse_y = love.mouse.getPosition()
    if game.state.running then
        player:movePlayer()
        for ast_index, asteroid in pairs(asteroids) do--asteroids table is defined in Game.lua
            asteroid:move(dt)
        end
    end
    
end
-------------------------------------------------------------------------
function love.draw()
    if game.state.running or game.state.paused then
        player:draw(game.state.paused)
        for _, asteroid in pairs(asteroids) do--asteroids table is defined in Game.lua
            asteroid:draw(game.state.paused)
        end
        game:draw(game.state.paused)
    end
    
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf(
        "FPS: "..love.timer.getFPS(),
        love.graphics.newFont(16),--font-size
        10,--the x position on screen
        love.graphics.getHeight()-30,--the y position on screen
        love.graphics.getWidth()--Wrap the line after this many horizontal pixels.
        )--this will get you the FPS counter
end