require"globals"
local love = require"love"
local Player = require"objects/Player"
local Game = require"states/Game"
local Menu =require"states.Menu"
local Button = require"components.Button"
local SFX = require"components.SFX"

math.randomseed(os.time())
-------------------------------------------------------------------------
function love.load()

    love.mouse.setVisible(false)--the mouse cursor won't be visible in the game.
    mouse_x,mouse_y = 0,0
    sfx = SFX()
    sfx:playBGM()--to play background music
    player = Player(3,sfx)
    game = Game(sfx)
    menu = Menu(game,player,sfx)
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
        if key == "space" then
            player:shootLaser()
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
--mousepressed Event
function love.mousepressed(x,y,button,istouch,presses)
    mouse_x,mouse_y = love.mouse.getPosition()
    if button == 1 then
        if game.state.running then
            player:shootLaser()
        elseif game.state.ended then
            if ((mouse_x + cursor_radius) >= (_button.button_X)) and ((mouse_x - cursor_radius) <= (_button.button_X + _button.width)) then
                if ((mouse_y + cursor_radius) >= (_button.button_Y)) and ((mouse_y - cursor_radius) <= (_button.button_Y + _button.height)) then
                    _button:click()
                    player = Player()
                    game = Game()
                    menu = Menu(game,player)
                    score = score - 10
                end
            end
        else
            clickedMouse = true
        end
    end
end
--Update
function love.update(dt)
    game.seconds = game.seconds + dt
    mouse_x,mouse_y = love.mouse.getPosition()
    if game.state.running then
        player:movePlayer()
        for ast_index, asteroid in pairs(asteroids) do
            if not player.exploding then
                if math.sqrt((player.x - asteroid.x)^2 + (player.y - asteroid.y)^2) < asteroid.radius then
                    player:explode()
                    destroy_ast = true
                end
            else
                player.explode_time = player.explode_time - 1

                if player.explode_time == 0 then--after the explosion,
                    if player.lives - 1 <= 0 then--if player has no lives left,
                        game:changeGameState("ended")--end the game.
                        total_score = score
                        total_time = math.floor(game.seconds)
                        score = 0--and set the score back to 0.
                        return
                    end
                    player = Player(player.lives-1,sfx)--otherwise spawn a new player.
                end
            end
            for _, laser in pairs(player.lasers) do
                if math.sqrt((laser.x - asteroid.x)^2 + (laser.y - asteroid.y)^2) < asteroid.radius then
                    laser:explode()
                    asteroid:destroy(asteroids,ast_index,game)
                end
            end
            if destroy_ast then
                if player.lives - 1 <= 0 then
                    if player.explode_time == 0 then
                        destroy_ast = false
                        asteroid:destroy(asteroids,ast_index,game)
                    end
                else
                    destroy_ast = false
                    asteroid:destroy(asteroids,ast_index,game)
                end
            end
            asteroid:move(dt)
        end
        if #asteroids == 0 then
            game.level = game.level + 1
            game:startNewGame(player)
        end
    elseif game.state.menu then
        menu:run(clickedMouse,sfx)
        clickedMouse = false
    end
    
end
-------------------------------------------------------------------------
function love.draw()
    if game.state.running or game.state.paused then
        love.graphics.printf("Timer: "..math.floor(game.seconds),love.graphics.getFont(24),0,10,love.graphics.getWidth(),"center")
        player:drawLives(game.state.paused)
        player:draw(game.state.paused)
        game:draw(game.state.paused)
        for _, asteroid in pairs(asteroids) do
            asteroid:draw(game.state.paused)
        end
        love.graphics.setColor(1,1,1,1)
    love.graphics.printf(
        "FPS: "..love.timer.getFPS(),
        love.graphics.newFont(16),--font-size
        10,--the x position on screen
        love.graphics.getHeight()-30,--the y position on screen
        love.graphics.getWidth()--Wrap the line after this many horizontal pixels.
        )--this will get you the FPS counter
    love.graphics.printf(
        "Health Bar: ",
        love.graphics.newFont(16),
        45,
        20,
        love.graphics.getWidth()
        )
    love.graphics.printf(
        "Score: "..score,
        love.graphics.newFont(16),
        love.graphics.getWidth()-100,
        20,
        love.graphics.getWidth()
        )
    elseif game.state.menu then
        menu:draw()
    elseif game.state.ended then
        love.graphics.printf(
        "Game Over",
        love.graphics.newFont(50),
        love.graphics.getWidth()/2 - 165,
        love.graphics.getHeight()/2 - 125,
        love.graphics.getWidth()
        )
        love.graphics.printf(
        "Total Score: "..total_score,
        love.graphics.newFont(16),
        love.graphics.getWidth()/2 - 75,
        love.graphics.getHeight()/2 - 50,
        love.graphics.getWidth()
        )
        love.graphics.printf(
        "Accuracy: "..total_score/total_time,
        love.graphics.newFont(16),
        love.graphics.getWidth()/2 - 75,
        love.graphics.getHeight()/2 - 25,
        love.graphics.getWidth()
        )
        menuState = function ()
            game:changeGameState("menu")
        end
        _button = Button(menuState,nil,{r=110/255,g=152/255,b=111/255},love.graphics.getWidth()/3, 50 , "Main Menu","center","h3",love.graphics.getWidth()/3,love.graphics.getHeight() * 0.5 )
        
        _button:draw()
    end
    if not game.state.running then
        love.graphics.circle("fill",mouse_x,mouse_y,cursor_radius)
    end
end