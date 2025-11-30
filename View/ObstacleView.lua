local ObstacleView = {}
local Obstacles = require("Model.Obstacle")

function ObstacleView.load()
    ObstacleView.sprite = love.graphics.newImage("Sprites/wall.png")
end

function ObstacleView.draw()
    if not ObstacleView.sprite then return end

    local spriteW = ObstacleView.sprite:getWidth()
    local spriteH = ObstacleView.sprite:getHeight()

    for _, o in ipairs(Obstacles.list) do
        for x = 0, o.w - 1, spriteW do
            for y = 0, o.h - 1, spriteH do
                love.graphics.draw(ObstacleView.sprite, o.x + x, o.y + y)
            end
        end
    end
end

return ObstacleView
