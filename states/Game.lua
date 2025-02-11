--it'll contain our game state.
require"../globals"
local love =  require"love"
local Text = require"../components/Text"
local Asteroids = require"../objects/Asteroids"
function Game(sfx)
    return{
        level = 1,
        seconds = 0,
        state={
            menu = true,
            paused = false,
            running = false,
            ended = false
        },
        changeGameState = function (self,state)
            self.state.menu = state == "menu"
            self.state.paused = state == "paused"
            self.state.running = state == "running"
            self.state.ended = state == "ended"
        end,
        startNewGame = function (self, player)
            if player.lives <= 0 then
                self:changeGameState("ended")
            else
                self:changeGameState("running")
            end
            
            for i = 1, self.level do
                table.insert(asteroids,Asteroids(math.floor(math.random(love.graphics.getWidth())),math.floor(math.random(love.graphics.getHeight())),ASTEROID_SIZE,self.level,sfx))
            end
        end,
        draw = function (self, faded)
            if faded then
                Text(
                    "-PAUSED-",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "h1",
                    false,
                    false,
                    love.graphics.getWidth(),
                    "center"
                ):draw()
            end
            Text(
            "Level "..self.level,
            0,
            love.graphics.getHeight() * 0.08,
            "h1",
            true,
            true,
            love.graphics.getWidth(),
            "center"
            ):draw()
        end
    }
end

return Game