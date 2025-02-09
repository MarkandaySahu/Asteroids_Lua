--it'll contain our game state.
local love =  require"love"
local Text = require"../components/Text"
local Asteroids = require"../objects/Asteroids"
function Game()
    return{
        level = 1,
        state={
            menu = false,
            paused = false,
            running = true,
            ended = false
        },
        changeGameState = function (self,state)
            self.state.menu = state == "menu"
            self.state.paused = state == "paused"
            self.state.running = state == "running"
            self.state.ended = state == "ended"
        end,
        startNewGame = function (self, player)
            self:changeGameState("running")

            _G.asteroids = {}--inserting no. of asteroids to the Game.
            
            table.insert(asteroids,Asteroids(math.floor(math.random(love.graphics.getWidth())),math.floor(math.random(love.graphics.getHeight())),100,self.level))
            table.insert(asteroids,Asteroids(math.floor(math.random(love.graphics.getWidth())),math.floor(math.random(love.graphics.getHeight())),100,self.level))
            table.insert(asteroids,Asteroids(math.floor(math.random(love.graphics.getWidth())),math.floor(math.random(love.graphics.getHeight())),100,self.level))
            table.insert(asteroids,Asteroids(math.floor(math.random(love.graphics.getWidth())),math.floor(math.random(love.graphics.getHeight())),100,self.level))

        end,
        draw = function (self, faded)
            if faded then
                Text(
                    "PAUSED :O",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "h1",
                    false,
                    false,
                    love.graphics.getWidth(),
                    "center"
                ):draw()
            end
        end
    }
end

return Game