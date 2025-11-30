local Car = {}
Car.__index = Car

function Car.new(x, y, isPlayer)
    local self = setmetatable({}, Car)
    
    self.x = x
    self.y = y
    self.w = 50
    self.h = 50
    
    self.rotation = 0
    self.speed = 0
    
    -- Stats
    self.acceleration = 200
    self.topSpeed = 300
    self.friction = 150
    self.brakeForce = 400
    self.turnSpeed = 3
    
    self.originalTopSpeed = self.topSpeed
    self.boostTime = 0
    
    self.isPlayer = isPlayer or false
    
    return self
end

function Car:accelerate(dt, direction)
    -- direction: 1 for forward, -1 for backward
    if direction > 0 then
        self.speed = math.min(self.speed + self.acceleration * dt, self.topSpeed)
    else
        self.speed = math.max(self.speed - self.acceleration * dt, -self.topSpeed / 2)
    end
end

function Car:brake(dt)
    if self.speed > 0 then
        self.speed = math.max(0, self.speed - self.brakeForce * dt)
    elseif self.speed < 0 then
        self.speed = math.min(0, self.speed + self.brakeForce * dt)
    end
end

function Car:applyFriction(dt)
    if self.speed > 0 then
        self.speed = math.max(0, self.speed - self.friction * dt)
    elseif self.speed < 0 then
        self.speed = math.min(0, self.speed + self.friction * dt)
    end
end

function Car:turn(dt, direction)
    -- direction: -1 left, 1 right
    self.rotation = self.rotation + (self.turnSpeed * direction * dt)
end

function Car:updatePhysics(dt)
    self.x = self.x + math.cos(self.rotation) * self.speed * dt
    self.y = self.y + math.sin(self.rotation) * self.speed * dt
    
    self:clampToScreen()
    
    -- Handle boost timer
    if self.boostTime > 0 then
        self.boostTime = self.boostTime - dt
        if self.boostTime <= 0 then
            self.topSpeed = self.originalTopSpeed
        end
    end
end

function Car:clampToScreen()
    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()
    local halfW = self.w / 2
    local halfH = self.h / 2

    if self.x < halfW then self.x = halfW end
    if self.x > sw - halfW then self.x = sw - halfW end

    if self.y < halfH then self.y = halfH end
    if self.y > sh - halfH then self.y = sh - halfH end
end

return Car
