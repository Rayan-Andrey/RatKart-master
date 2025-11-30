local RaceView = {}
local Race = require("Model.Race")

function RaceView.load()
    RaceView.checkpointA = love.graphics.newImage("Sprites/checkpoint_A.png")
    RaceView.checkpointB = love.graphics.newImage("Sprites/checkpoint_B.png")
end

function RaceView.draw()
    for _, cp in ipairs(Race.list) do
        love.graphics.setColor(1, 1, 1, 1)

        local sprite = (cp.id == 4) and RaceView.checkpointB or RaceView.checkpointA
        local sw = sprite:getWidth()
        local sh = sprite:getHeight()

        for x = 0, cp.w - 1, sw do
            for y = 0, cp.h - 1, sh do
                love.graphics.draw(sprite, cp.x + x, cp.y + y)
            end
        end
    end

    love.graphics.setColor(1,1,1)
    love.graphics.print("Lap: " .. Race.lap, 20, 20)
    love.graphics.print("Next CP: " .. Race.order, 20, 40)
    love.graphics.print("Time: " .. string.format("%.2f", Race.raceTime), 20, 60)

    if Race.finished then
        love.graphics.setColor(1, 1, 0)
        love.graphics.print("RACE FINISHED!", 300, 120, 0, 2, 2)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print("FINAL RESULTS:", 320, 170)

        for i, r in ipairs(Race.finishedRacers) do
            local line = r.position .. ". " .. r.name .. " - " .. string.format("%.2f s", r.time)
            love.graphics.print(line, 320, 200 + i * 20)
        end
    end
end

return RaceView
