local OpponentView = {}
local Opponent = require("Model.Opponent")

function OpponentView.load()
    OpponentView.sprite = love.graphics.newImage("Sprites/Oponent.png")
end

function OpponentView.draw()
    for _, ai in ipairs(Opponent.list) do
        local car = ai.car
        love.graphics.setColor(1, 1, 1)

        love.graphics.draw(
            OpponentView.sprite,
            car.x,
            car.y,
            car.rotation,
            1, 1,
            car.w / 2,
            car.h / 2
        )
    end
end

return OpponentView
