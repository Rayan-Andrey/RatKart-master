local opponents = {}

local opponentSprite
local player = require("player") -- Needed for AI vs Player collisions

-------------------------------------------------------------
-- Collision helpers
-------------------------------------------------------------
local function resolveCollision(a, b)
    local dx = b.x - a.x
    local dy = b.y - a.y
    local dist = math.sqrt(dx*dx + dy*dy)

    local minDist = (a.w/2 + b.w/2)

    -- Only resolve if overlapping
    if dist < minDist and dist > 0 then
        local overlap = minDist - dist

        local nx = dx / dist
        local ny = dy / dist

        -- Push both karts away from each other
        a.x = a.x - nx * overlap * 0.5
        a.y = a.y - ny * overlap * 0.5

        b.x = b.x + nx * overlap * 0.5
        b.y = b.y + ny * overlap * 0.5
    end
end

-------------------------------------------------------------
-- Clamp AI to screen boundaries
-------------------------------------------------------------
local function clampToScreen(ai)
    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()

    local hw = ai.w / 2
    local hh = ai.h / 2

    if ai.x < hw then ai.x = hw end
    if ai.x > sw - hw then ai.x = sw - hw end

    if ai.y < hh then ai.y = hh end
    if ai.y > sh - hh then ai.y = sh - hh end
end

-------------------------------------------------------------
-- Load opponents
-------------------------------------------------------------
function opponents.load(count)
    opponentSprite = love.graphics.newImage("Sprites/Oponent.png")

    opponents.list = {}

    for i = 1, count do
        opponents.list[i] = {
            name = "CPU " .. i,

            x = 0,
            y = 250 + i * 20,
            w = 32,
            h = 32,

            rotation = 0,
            speed = 0,
            maxSpeed = 250,
            accel = 80,
            turnSpeed = 2,

            nextCP = 1,
            lap = 0,
            finished = false
        }
    end
end


-------------------------------------------------------------
-- Utility: compute angle from AI to target
-------------------------------------------------------------
local function angleTo(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end


-------------------------------------------------------------
-- UPDATE: AI movement + lap tracking + collisions
-------------------------------------------------------------
function opponents.update(dt, checkpoints, obstacles)

    ---------------------------
    -- MAIN AI LOOP
    ---------------------------
    for _, ai in ipairs(opponents.list) do

        if ai.finished then
            goto continue
        end

        -----------------------------------------------------
        -- Move toward next checkpoint
        -----------------------------------------------------
        local cp = checkpoints.list[ai.nextCP]

        local targetAngle = angleTo(ai.x, ai.y, cp.x + cp.w/2, cp.y + cp.h/2)
        local diff = targetAngle - ai.rotation

        -- Normalize angle
        if diff > math.pi then diff = diff - 2*math.pi end
        if diff < -math.pi then diff = diff + 2*math.pi end

        -- Steer
        if diff > 0 then
            ai.rotation = ai.rotation + ai.turnSpeed * dt
        else
            ai.rotation = ai.rotation - ai.turnSpeed * dt
        end

        -- Accelerate
        ai.speed = math.min(ai.speed + ai.accel * dt, ai.maxSpeed)

        -- Move
        ai.x = ai.x + math.cos(ai.rotation) * ai.speed * dt
        ai.y = ai.y + math.sin(ai.rotation) * ai.speed * dt

        -- Stay inside screen
        clampToScreen(ai)


        -----------------------------------------------------
        -- Obstacles (same function player uses)
        -----------------------------------------------------
        if obstacles and obstacles.resolveCollisionSingle then
            obstacles.resolveCollisionSingle(ai)
        end


        -----------------------------------------------------
        -- Checkpoint collision
        -----------------------------------------------------
        if ai.x < cp.x + cp.w and
           ai.x + ai.w > cp.x and
           ai.y < cp.y + cp.h and
           ai.y + ai.h > cp.y then

            ai.nextCP = ai.nextCP + 1

            -- Completed one lap
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


    ---------------------------------------------------------
    -- AI vs AI COLLISION
    ---------------------------------------------------------
    for i = 1, #opponents.list do
        for j = i + 1, #opponents.list do
            resolveCollision(opponents.list[i], opponents.list[j])
        end
    end

    ---------------------------------------------------------
    -- AI vs PLAYER COLLISION
    ---------------------------------------------------------
    for _, ai in ipairs(opponents.list) do
        resolveCollision(ai, player)
    end
end

-------------------------------------------------------------
-- DRAW
-------------------------------------------------------------
function opponents.draw()
    for _, ai in ipairs(opponents.list) do
        love.graphics.setColor(1, 1, 1)

        love.graphics.draw(
            opponentSprite,
            ai.x,
            ai.y,
            ai.rotation,
            1, 1,
            ai.w / 2,
            ai.h / 2
        )
    end
end

return opponents
