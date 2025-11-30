local PlayerView = {}
local Player = require("Model.Player")

function PlayerView.load()
    PlayerView.sprites = {
        up = love.graphics.newImage("Sprites/car_up.png"),
        down = love.graphics.newImage("Sprites/car_down.png"),
        left = love.graphics.newImage("Sprites/car_left.png"),
        right = love.graphics.newImage("Sprites/car_right.png"),
        up_left = love.graphics.newImage("Sprites/car_up_left.png"),
        up_right = love.graphics.newImage("Sprites/car_up_right.png"),
        down_left = love.graphics.newImage("Sprites/car_down_left.png"),
        down_right = love.graphics.newImage("Sprites/car_down_right.png")
    }
    
    -- Update car dimensions based on sprite
    if Player.car then
        Player.car.w = PlayerView.sprites.up:getWidth()
        Player.car.h = PlayerView.sprites.up:getHeight()
    end
end

function PlayerView.getSpriteForRotation(rotation)
    local offset = math.pi
    local angle = (rotation + offset) % (2 * math.pi)
    local deg = math.deg(angle)

    if deg >= 337.5 or deg < 22.5 then
        return PlayerView.sprites.left
    elseif deg < 67.5 then
        return PlayerView.sprites.up_left
    elseif deg < 112.5 then
        return PlayerView.sprites.up
    elseif deg < 157.5 then
        return PlayerView.sprites.up_right
    elseif deg < 202.5 then
        return PlayerView.sprites.right
    elseif deg < 247.5 then
        return PlayerView.sprites.down_right
    elseif deg < 292.5 then
        return PlayerView.sprites.down
    elseif deg < 337.5 then
        return PlayerView.sprites.down_left
    end
end

function PlayerView.draw()
    local car = Player.car
    if not car then return end

    love.graphics.setColor(1, 1, 1)
    local currentSprite = PlayerView.getSpriteForRotation(car.rotation)
    love.graphics.draw(
        currentSprite,
        car.x,
        car.y,
        nil,
        2, 2,
        car.w / 2,
        car.h / 2
    )
end

return PlayerView
