local Opponent = {}
local Car = require("Model.Car")
local Player = require("Model.Player")

local function resolveCollision(a, b)
    local dx = b.x - a.x
    local dy = b.y - a.y
    local dist = math.sqrt(dx*dx + dy*dy)

    local minDist = (a.w/2 + b.w/2)

    if dist < minDist and dist > 0 then
        local overlap = minDist - dist

        local nx = dx / dist
        local ny = dy / dist

        a.x = a.x - nx * overlap * 0.5
        a.y = a.y - ny * overlap * 0.5

        b.x = b.x + nx * overlap * 0.5
        b.y = b.y + ny * overlap * 0.5
    end
end

function Opponent.load(count)
    Opponent.list = {}

    for i = 1, count do
        local car = Car.new(0, 250 + i * 20)
        car.maxSpeed = 250 -- Override default topSpeed if needed
        car.accel = 80     -- Override default acceleration
        car.turnSpeed = 2  -- Override default turnSpeed
        
        Opponent.list[i] = {
            car = car,
            name = "CPU " .. i,
            nextCP = 1,
            lap = 0,
            finished = false
        }
    end
end

local function angleTo(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end

function Opponent.update(dt, checkpoints, obstacles)
    for _, ai in ipairs(Opponent.list) do
        local car = ai.car

        if ai.finished then
            goto continue
        end

        local cp = checkpoints.list[ai.nextCP]

        local targetAngle = angleTo(car.x, car.y, cp.x + cp.w/2, cp.y + cp.h/2)
        local diff = targetAngle - car.rotation

        if diff > math.pi then diff = diff - 2*math.pi end
        if diff < -math.pi then diff = diff + 2*math.pi end

        if diff > 0 then
            car:turn(dt, 1)
        else
            car:turn(dt, -1)
        end

        -- AI Logic: Always accelerate unless finished
        car.speed = math.min(car.speed + car.acceleration * dt, car.topSpeed)
        
        -- Use Car's updatePhysics but we might need custom logic for AI movement if it differs significantly
        -- For now, let's manually move it like before to match AI behavior or use car:updatePhysics?
        -- The previous AI logic was:
        -- ai.x = ai.x + math.cos(ai.rotation) * ai.speed * dt
        -- ai.y = ai.y + math.sin(ai.rotation) * ai.speed * dt
        -- clampToScreen(ai)
        
        -- Car:updatePhysics does exactly this.
        car:updatePhysics(dt)

        if obstacles and obstacles.resolveCollisionSingle then
            obstacles.resolveCollisionSingle(car)
        end

        if car.x < cp.x + cp.w and
           car.x + car.w > cp.x and
           car.y < cp.y + cp.h and
           car.y + car.h > cp.y then

            ai.nextCP = ai.nextCP + 1

            if ai.nextCP > #checkpoints.list then
                ai.nextCP = 1
                ai.lap = ai.lap + 1

                if ai.lap >= checkpoints.lapLimit then
                    ai.finished = true
                    checkpoints.finishRacer(ai.name)
                end
            end
        end

        ::continue::
    end

    for i = 1, #Opponent.list do
        for j = i + 1, #Opponent.list do
            resolveCollision(Opponent.list[i].car, Opponent.list[j].car)
        end
    end

    for _, ai in ipairs(Opponent.list) do
        resolveCollision(ai.car, Player.car)
    end
end

return Opponent
