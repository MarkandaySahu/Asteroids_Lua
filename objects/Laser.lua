local love = require"love"

function Laser(x,y,angle)
    local LASER_SPEED = 500
    local EXPLODE_DURATION = 0.3
    explodingEnum = {
        not_exploding = 0,
        started_exploding = 1,
        done_exploding = 2
    }
    return{
        x = x,
        y = y,
        x_vel = LASER_SPEED * math.cos(angle) / love.timer.getFPS(),
        y_vel = -LASER_SPEED * math.sin(angle) / love.timer.getFPS(),
        exploding = explodingEnum["not_exploding"],
        explod_time = 0,
        
        explode = function (self)
            self.explod_time = math.ceil(EXPLODE_DURATION * (love.timer.getFPS()/10))
            if self.explod_time > EXPLODE_DURATION then
                self.exploding = explodingEnum["done_exploding"]
            end
        end,
        draw = function (self,faded)
            local opacity = 1
            if faded then
                opacity = 0.4
            end
            if self.exploding < 1 then
                love.graphics.setColor(1,1,1,opacity)
                love.graphics.setPointSize(3)
                love.graphics.points(self.x,self.y)--to generate a point
            else
                love.graphics.setColor(1,104/255,0,opacity)
                love.graphics.circle("fill",self.x,self.y,7*1.5)
                love.graphics.setColor(1,234/255,0,opacity)
                love.graphics.circle("fill",self.x,self.y,7)
            end
        end,
        move = function (self)
            self.x = self.x + self.x_vel
            self.y = self.y + self.y_vel
            if self.explod_time > 0 then
                self.exploding = explodingEnum["started_exploding"]
            end
        end

    }
end
return Laser