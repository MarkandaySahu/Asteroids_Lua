local love = require"love"
function SFX()
    local bgm = love.audio.newSource("components/sounds/bgm.mp3","stream")
    bgm:setVolume(0.1)
    bgm:setLooping(true)
    local effects = {
        ship_explosion = love.audio.newSource("components/sounds/explosion_player.ogg","static"),
        asteroid_explosion = love.audio.newSource("components/sounds/explosion_asteroid.ogg","static"),
        laser = love.audio.newSource("components/sounds/laser.ogg","static"),
        select = love.audio.newSource("components/sounds/option_select.ogg","static"),
        thruster = love.audio.newSource("components/sounds/thruster_loud.ogg","static")
    }
    return{
        fx_played = false,
        setFXPlayed = function (self,has_played)
            self.fx_played = has_played
        end,
        playBGM = function (self)
            if not bgm:isPlaying() then
                bgm:play()
            end
        end,
        setBGvol = function (self,v)
            bgm:setVolume(v)
        end,
        stopFX = function (self,effect)
            if effects[effect]:isPlaying() then
                effects[effect]:stop()
            end
        end,
        playFX = function (self,effect, mode)
            --[[
            Types of mode:
            single: effect will be played only once.
            slow: effect will be played normally.
            ]]
            if mode == "single" then
                if not self.fx_played then
                    self:setFXPlayed(true)
                    if not effects[effect]:isPlaying() then
                        effects[effect]:play()
                    end
                end
            elseif mode == "slow" then
                if not effects[effect]:isPlaying() then
                    effects[effect]:play()
                end
            else
                self:stopFX(effect)
                effects[effect]:play()
            end
        end
    }
end
return SFX