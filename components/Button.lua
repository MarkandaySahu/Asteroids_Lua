local love = require"love"
local Text = require"components.Text"

function Button(func, text_color, button_color, width, height, text, text_align, font_size, button_X, button_Y, text_X, text_Y)
    local btn_text = {
        x = button_X,
        y = button_Y
    }
    func = func or function () print("this function has no function attached.") end
    if text_X then
        btn_text.x = text_X + button_X
    end
    if text_Y then
        btn_text.y = text_Y + button_Y
    end
    return{
        text_color = text_color or { r = 1, g = 1, b = 1 },
        button_color = button_color or { r = 0, g = 0, b = 0 },
        width = width or 100,
        height = height or 100,
        text = text or "No text added",
        text_x = text_X or button_X or 0,
        text_y = text_Y or button_Y or 0,
        button_X = button_X or 0,
        button_Y = button_Y or 0,
        text_component = Text(
            text,
            btn_text.x,
            btn_text.y,
            font_size,
            false,
            false,
            width,
            text_align,
            1
        ),
        checkHover = function (self, mouse_x,mouse_y,cur_rad)--(pg-15,MKGVI)
            if ((mouse_x + cur_rad) >= (self.button_X)) and ((mouse_x - cur_rad) <= (self.button_X + self.width)) then
                if ((mouse_y + cur_rad) >= (self.button_Y)) and ((mouse_y - cur_rad) <= (self.button_Y + self.height)) then
                    return true
                end
            end
        end,
        click = function (self)
            func()
        end,
        setTextColor = function (self,r,g,b)
            self.text_color = {r = r,g = g, b = b}
        end,
        draw = function (self)
            love.graphics.setColor(self.button_color["r"],self.button_color["g"],self.button_color["b"])
            love.graphics.rectangle("fill",self.button_X, self.button_Y, self.width, self.height)
            
            self.text_component:setColor(self.text_color["r"],self.text_color["g"],self.text_color["b"])
            self.text_component:draw()

            love.graphics.setColor(1, 1, 1)
        end,
    }
end

return Button