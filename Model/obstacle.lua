local Obstacles = {}
Obstacles.list = {}

function Obstacles.new(x, y, w, h)
    table.insert(Obstacles.list, {
        x = x,
        y = y,
        w = w,
        h = h
    })
end

local function checkCollision(a, b)
    return a.x < b.x + b.w and
           b.x < a.x + a.w and
           a.y < b.y + b.h and
           b.y < a.y + a.h
end

function Obstacles.load()
    Obstacles.new(250, 150, 750, 350)
end

local function resolveObjectCollision(obj)
    local ox = obj.x
    local oy = obj.y
    local ow = obj.w
    local oh = obj.h

    for _, o in ipairs(Obstacles.list) do

        local a = {
            x = ox - ow/2,
            y = oy - oh/2,
            w = ow,
            h = oh
        }

        if checkCollision(a, o) then

            local left   = (a.x + a.w) - o.x
            local right  = (o.x + o.w) - a.x
            local top    = (a.y + a.h) - o.y
            local bottom = (o.y + o.h) - a.y

            local minOverlap = math.min(left, right, top, bottom)

            if minOverlap == left then
                obj.x = o.x - ow/2
            elseif minOverlap == right then
                obj.x = o.x + o.w + ow/2
            elseif minOverlap == top then
                obj.y = o.y - oh/2
            else
                obj.y = o.y + o.h + oh/2
            end
        end
    end
end

function Obstacles.resolveCollision(player)
    resolveObjectCollision(player)
end

function Obstacles.resolveCollisionSingle(ai)
    resolveObjectCollision(ai)
end

return Obstacles
