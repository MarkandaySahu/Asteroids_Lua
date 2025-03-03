require"../globals"
local love = require "love"
local Player = require"objects.Player"
function Asteroids(x,y,ast_size,level,sfx)
    debugging = debugging or false
    local ASTEROID_VERTICES = 6--the higher this value is the more spikey the asteorid is.
    local ASTEROID_JAGGED = 0.4--the lower this value is the more round the polygon will be.
    local ASTEROID_SPEED = (math.random(50) + (level * 3)) * ast_sp
    local vert = math.floor(math.random(ASTEROID_VERTICES+1)*ASTEROID_VERTICES/2)--to produce random no. of vertices
    local offset = {}
    for i = 1,vert+1 do
        table.insert(offset,math.random() * ASTEROID_JAGGED * 2 + 1 - ASTEROID_JAGGED)
    end
    local vel = -1
    if math.random() < 0.5 then
        vel = 1
    end
    return{
        x=x,
        y=y,
        x_vel = math.random() + ASTEROID_SPEED * vel,
        y_vel = math.random() + ASTEROID_SPEED * vel,
        radius = math.ceil( ast_size / 2 ),
        angle = math.rad(math.random(math.pi)),
        vert = vert,
        offset = offset,
        
        draw = function (self,faded)
            local opacity = 1

            if faded then
                opacity = 0.4
            end

            love.graphics.setColor(186/255,189/255,182/255,opacity)
            --draw the polygon with the below inserted points.
            local points = {}
            for i = 1, self.vert do
                table.insert(points,self.x + self.radius * self.offset[i] * math.cos(self.angle + i * math.pi * 2 / self.vert))
                table.insert(points,self.y + self.radius * self.offset[i] * math.sin(self.angle + i * math.pi * 2 / self.vert))
            end
            love.graphics.setColor(0.6,0.6,0.6)
            love.graphics.polygon("fill",points)
            if show_debugging then
                love.graphics.setColor(1,0,0)
                love.graphics.circle("line",self.x,self.y,self.radius)
            end
        end,
        
        move = function (self, dt)
            self.x = self.x + self.x_vel * dt
            self.y = self.y + self.y_vel * dt

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
        end,

        destroy = function (self, asteroids_tbl, index, game)
            score = score + 10
            local MIN_ASTEROID_SIZE = math.ceil(ASTEROID_SIZE / 8)
            if self.radius > MIN_ASTEROID_SIZE then
                table.insert(asteroids_tbl,Asteroids(self.x,self.y,self.radius,game.level,sfx))
                table.insert(asteroids_tbl,Asteroids(self.x,self.y,self.radius,game.level,sfx))
            end
            sfx:playFX("asteroid_explosion")
            table.remove(asteroids_tbl,index)
        end
    }
end
return Asteroids