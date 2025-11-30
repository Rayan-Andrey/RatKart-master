local Player = {}
local Car = require("Model.Car")

function Player.load()
    Player.car = Car.new(0, 200, true)
end

function Player.update(dt)
    local car = Player.car
    
    -- Turning
    if love.keyboard.isDown("left") then
        car:turn(dt, -1)
    elseif love.keyboard.isDown("right") then
        car:turn(dt, 1)
    end

    -- Acceleration / Reverse / Brake
    if love.keyboard.isDown("z") then
        car:accelerate(dt, 1)
    elseif love.keyboard.isDown("x") then
        car:accelerate(dt, -1)
    elseif love.keyboard.isDown("space") then
        car:brake(dt)
    else
        car:applyFriction(dt)
    end

    car:updatePhysics(dt)
end

return Player
