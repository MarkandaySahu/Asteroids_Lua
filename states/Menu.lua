local love =  require"love"
local Button = require"components.Button"
local Text = require"components.Text"
function Menu(game,player,sfx)
    local funcs = {
        newGame = function ()
            game:startNewGame(player)
        end,
        setting = function ()
            game:changeGameState("settings")
        end,
        quitGame = function ()
            love.event.quit()
        end
    }
    local buttons = {
        Button(funcs.newGame,nil,{r=110/255,g=152/255,b=111/255},love.graphics.getWidth()/3, 50 , "New Game","center","h3",love.graphics.getWidth()/3,love.graphics.getHeight() * 0.25 ),
        Button(funcs.setting,nil,{r=110/255,g=152/255,b=111/255},love.graphics.getWidth()/3, 50 , "Settings","center","h3",love.graphics.getWidth()/3,love.graphics.getHeight() * 0.32 ),
        Button(funcs.quitGame,nil,{r=110/255,g=152/255,b=111/255},love.graphics.getWidth()/3, 50 , "Quit Game","center","h3",love.graphics.getWidth()/3,love.graphics.getHeight() * 0.39 )
    }
    return{
        focused="",
        run = function (self,clicked,sfx)
            local _x,_y = love.mouse.getPosition()
            for name, button in pairs(buttons) do
                if button:checkHover(_x,_y,cursor_radius) then
                    sfx:playFX("select","single")
                    if clicked then
                        button:click()
                    end
                    self.focused = name
                    button:setTextColor(165/255,1,131/255)
                else
                    if self.focused == name then
                        sfx:setFXPlayed(false)
                    end
                    button:setTextColor(1,1,1)
                end
            end
        end,
       draw = function (self)
        local text = Text("ASTEROIDS",love.graphics.getWidth()/4,love.graphics.getHeight() * 0.12,"h1",false,false,love.graphics.getWidth()/2,"center",1)
        text:setColor(246/255,1,65/255)
        text:draw()
        for _, button in pairs(buttons) do
            button:draw()
        end
       end
    }
end
return Menu