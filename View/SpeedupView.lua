local SpeedupView = {}
local Speedup = require("Model.Speedup")

function SpeedupView.load()
    SpeedupView.sprites = {}
    SpeedupView.sprites[1] = love.graphics.newImage("Sprites/speedup_vertical.png")
    SpeedupView.sprites[2] = love.graphics.newImage("Sprites/speedup_vertical.png")

    Speedup.w = SpeedupView.sprites[1]:getWidth()
    Speedup.h = SpeedupView.sprites[1]:getHeight()
end

function SpeedupView.draw()
    for _, obj in ipairs(Speedup.list) do
        if obj.active then
            love.graphics.setColor(1, 1, 1)
            local sprite = SpeedupView.sprites[obj.spriteType]
            love.graphics.draw(sprite, obj.x, obj.y)
        end
    end
end

return SpeedupView
