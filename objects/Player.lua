require"../globals"
local love = require"love"
local Laser = require"objects/Laser"

function Player(num_lives,sfx)
    local SHIP_SIZE = 30
    local VIEW_ANGLE = math.rad(90)
    local EXPLODE_DURATION = 2
    return{
        --player will be positioned at the center when game starts.
        x = love.graphics.getWidth()/2,
        y = love.graphics.getHeight()/2,
        radius = SHIP_SIZE/2,--hitbox for player(ship)
        angle = VIEW_ANGLE,
        rotation = 0,
        explode_time = 0,
        exploding = false,
        lives = num_lives or 3,
        lasers={},--table containing points for laser.
        thrusting = false,--to move the player.
        thrust={
            x=0,
            y=0,
            speed=1,
            big_flame = false,
            flame = 0.5--it should be less than 1.5(it is the ratio between flame height and radius--> H : R)
        },
        drawFlameThrust = function (self, filltype, color)--(pg-18,MKGVI)
            love.graphics.setColor(color)
            love.graphics.polygon(--(pg-17,MKGVI)
                filltype,
                self.x - (self.radius)*(math.cos(self.angle)/2 + self.thrust.flame*math.sin(self.angle)/math.sqrt(3)),
                self.y + (self.radius)*(math.sin(self.angle)/2 - self.thrust.flame*math.cos(self.angle)/math.sqrt(3)),
                self.x - (self.radius/2) * ((1+2*self.thrust.flame)*math.cos(self.angle)),
                self.y + (self.radius/2) * ((1+2*self.thrust.flame)*math.sin(self.angle)),
                self.x - (self.radius)*(math.cos(self.angle)/2 - self.thrust.flame*math.sin(self.angle)/math.sqrt(3)),
                self.y + (self.radius)*(math.sin(self.angle)/2 + self.thrust.flame*math.cos(self.angle)/math.sqrt(3))
            )
        end,
        drawLives = function (self, faded)
            local opacity = 1--to determine the visibility of the player.
            
            if faded then
                opacity = 0.4
            end

            if self.lives == 2 then
                love.graphics.setColor(1,1,0.5,opacity)
            elseif self.lives == 1 then
                love.graphics.setColor(1,0.2,0.2,opacity)
            else
                love.graphics.setColor(1,1,1,opacity)
            end
            local x_pos, y_pos = 45,60 --setting the position of health bar counter.
            for i = 1, self.lives do
                if self.exploding then
                    if i == self.lives then
                        love.graphics.setColor(1,0,0,opacity)--the health bar will be set to red during explosion time.
                    end
                end
                love.graphics.polygon(--(pg-17,MKGVI)
                "line",
                (i * x_pos) + (self.radius)*math.cos(VIEW_ANGLE),--cos() takes angle parameters in radians(pg-17,MKGVI).
                ( y_pos) - (self.radius)*math.sin(VIEW_ANGLE),
                (i * x_pos) - (self.radius/2) * (math.cos(VIEW_ANGLE) + (math.sqrt(3))*math.sin(VIEW_ANGLE)),
                ( y_pos) + (self.radius/2) * (math.sin(VIEW_ANGLE) - (math.sqrt(3))*math.cos(VIEW_ANGLE)),
                (i * x_pos) - (self.radius/2) * (math.cos(VIEW_ANGLE) - (math.sqrt(3))*math.sin(VIEW_ANGLE)),
                ( y_pos) + (self.radius/2) * (math.sin(VIEW_ANGLE) + (math.sqrt(3))*math.cos(VIEW_ANGLE))
            )
            end
        end,
        shootLaser = function (self)
            if #self.lasers > 3 then
                table.remove(self.lasers,1)
            end
            table.insert(self.lasers,Laser(self.x,self.y,self.angle))
            sfx:playFX("laser")
        end,
        draw = function (self,faded)
            local opacity = 1--to determine the visibility of the player.
            
            if faded then
                opacity = 0.4
            end

            if not self.exploding then
                if self.thrusting then
                    if not self.thrust.big_flame then
                        self.thrust.flame = self.thrust.flame + 0.3 / love.timer.getFPS()
                        if self.thrust.flame > 0.9 then
                            self.thrust.big_flame = true
                        end
                    else
                        self.thrust.flame = self.thrust.flame - 0.3 / love.timer.getFPS()
                        if self.thrust.flame < 0.4 then
                            self.thrust.big_flame = false
                        end
                    end
                    self:drawFlameThrust("fill",{ 255/255 , 182/255 , 25/255 })
                    self:drawFlameThrust("line",{ 1 , 0.16 , 0 })
                end
            else
                love.graphics.setColor(1,0,0,opacity)
                love.graphics.circle("fill",self.x,self.y,self.radius*1.5)
                love.graphics.setColor(1,158/255,0,opacity)
                love.graphics.circle("fill",self.x,self.y,self.radius*1)
                love.graphics.setColor(1,234/255,0,opacity)
                love.graphics.circle("fill",self.x,self.y,self.radius*0.5)
            end
            
            if show_debugging then
                love.graphics.setColor(1,0,0)
                love.graphics.rectangle("fill",self.x-2,self.y-2,4,4)
                love.graphics.circle("line",self.x,self.y,self.radius)
            end
            love.graphics.setColor(1,1,1,opacity)
            love.graphics.polygon(--(pg-17,MKGVI)
                "line",
                self.x + (self.radius)*math.cos(self.angle),--cos() takes angle parameters in radians(pg-17,MKGVI).
                self.y - (self.radius)*math.sin(self.angle),
                self.x - (self.radius/2) * (math.cos(self.angle) + (math.sqrt(3))*math.sin(self.angle)),
                self.y + (self.radius/2) * (math.sin(self.angle) - (math.sqrt(3))*math.cos(self.angle)),
                self.x - (self.radius/2) * (math.cos(self.angle) - (math.sqrt(3))*math.sin(self.angle)),
                self.y + (self.radius/2) * (math.sin(self.angle) + (math.sqrt(3))*math.cos(self.angle))
            )
            for _, laser in pairs(self.lasers) do
                laser:draw(faded)
            end
        end,
        movePlayer = function (self)
            self.exploding = (self.explode_time > 0)

            if not self.exploding then
                local FPS = love.timer.getFPS()
                local friction = 0.7
                self.rotation = 2 * math.pi / FPS
                --to rotate the player
                if love.keyboard.isDown("a") then
                    self.angle = self.angle + self.rotation
                end
                if love.keyboard.isDown("d") then
                    self.angle = self.angle - self.rotation
                end
                --to move the player (gain thrust)
                if self.thrusting then
                    self.thrust.x = self.thrust.x + self.thrust.speed * math.cos(self.angle) / FPS
                    self.thrust.y = self.thrust.y - self.thrust.speed * math.sin(self.angle) / FPS
                    sfx:playFX("thruster","slow")
                else
                    sfx:stopFX("thruster")
                    --to implement friction
                    if self.thrust.x ~= 0 or self.thrust.y ~= 0 then
                        self.thrust.x = self.thrust.x - friction * self.thrust.x / FPS
                        self.thrust.y = self.thrust.y - friction * self.thrust.y / FPS
                    end
                end
                --to move the player (using gained thrust)
                self.x = self.x + self.thrust.x
                self.y = self.y + self.thrust.y
                --implementing window border logic (pg-20,MKGVI)
                if self.x + self.radius < 0 then
                    self.x = love.graphics.getWidth() + self.radius
                elseif self.x - self.radius > love.graphics.getWidth() then
                    self.x = - self.radius
                end
                if self.y + self.radius < 0 then
                    self.y = love.graphics.getHeight() + self.radius
                elseif self.y - self.radius > love.graphics.getHeight() then
                    self.y = - self.radius
                end
                
            end
            --to move all the inserted lasers 
            for _, laser in pairs(self.lasers) do
                    
                if laser.exploding == explodingEnum["not_exploding"] then
                    laser:move()
                elseif laser.exploding == explodingEnum["done_exploding"] then
                    table.remove(self.lasers,1)
                end
            end
        end,
        explode = function (self)
            self.explode_time = math.ceil(EXPLODE_DURATION * (love.timer.getFPS()))
        end
    }
end 
return Player