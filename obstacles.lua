local obstacles = {}
obstacles.list = {}
obstacles.sprite = nil

-------------------------------------------------------------
-- CREATE OBSTACLE
-------------------------------------------------------------
function obstacles.new(x, y, w, h)
    table.insert(obstacles.list, {
        x = x,
        y = y,
        w = w,
        h = h
    })
end

-------------------------------------------------------------
-- AABB COLLISION
-------------------------------------------------------------
local function checkCollision(a, b)
    return a.x < b.x + b.w and
           b.x < a.x + a.w and
           a.y < b.y + b.h and
           b.y < a.y + a.h
end

-------------------------------------------------------------
-- LOAD SPRITE + SAMPLE OBSTACLES
-------------------------------------------------------------
function obstacles.load()
    obstacles.sprite = love.graphics.newImage("Sprites/wall.png")

    -- Example wall
    obstacles.new(250, 150, 750, 350)
end

-------------------------------------------------------------
-- PUSH-OUT RESOLUTION (PLAYER & AI USE THIS)
-------------------------------------------------------------
local function resolveObjectCollision(obj)
    local ox = obj.x
    local oy = obj.y
    local ow = obj.w
    local oh = obj.h

    for _, o in ipairs(obstacles.list) do

        -- Build AABB for collision check
        local a = {
            x = ox - ow/2,
            y = oy - oh/2,
            w = ow,
            h = oh
        }

        if checkCollision(a, o) then

            -- Compute overlap on each side
            local left   = (a.x + a.w) - o.x
            local right  = (o.x + o.w) - a.x
            local top    = (a.y + a.h) - o.y
            local bottom = (o.y + o.h) - a.y

            -- Push out on the smallest overlap axis
            local minOverlap = math.min(left, right, top, bottom)

            if minOverlap == left then
                obj.x = o.x - ow/2        -- push left
            elseif minOverlap == right then
                obj.x = o.x + o.w + ow/2  -- push right
            elseif minOverlap == top then
                obj.y = o.y - oh/2        -- push up
            else
                obj.y = o.y + o.h + oh/2  -- push down
            end
        end
    end
end

-------------------------------------------------------------
-- PUBLIC COLLISION FUNCTIONS
-------------------------------------------------------------

-- For player
function obstacles.resolveCollision(player)
    resolveObjectCollision(player)
end

-- For AI (used by opponents.lua)
function obstacles.resolveCollisionSingle(ai)
    resolveObjectCollision(ai)
end

-------------------------------------------------------------
-- DRAW
-------------------------------------------------------------
function obstacles.draw()
    if not obstacles.sprite then return end

    local spriteW = obstacles.sprite:getWidth()
    local spriteH = obstacles.sprite:getHeight()

    for _, o in ipairs(obstacles.list) do
        -- Draw the sprite multiple times to cover the entire obstacle area
        for x = 0, o.w - 1, spriteW do
            for y = 0, o.h - 1, spriteH do
                love.graphics.draw(obstacles.sprite, o.x + x, o.y + y)
            end
        end
    end
end


return obstacles
