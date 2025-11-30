local Speedup = {}

Speedup.list = {}
Speedup.duration = 2
Speedup.boostAmount = 200
Speedup.respawnTime = 4
Speedup.w = 32
Speedup.h = 32

function Speedup.new(x, y, spriteType)
    table.insert(Speedup.list, {
        x = x,
        y = y,
        spriteType = spriteType,
        active = true,
        timer = 0
    })
end

local function collides(a, b)
    return a.x < b.x + b.w and
           b.x < a.x + a.w and
           a.y < b.y + b.h and
           b.y < a.y + a.h
end

function Speedup.load()
    Speedup.new(100, 100, 1)
    Speedup.new(900, 650, 1)
end

function Speedup.update(dt, player)

    if player.boostTime and player.boostTime > 0 then
        player.boostTime = player.boostTime - dt
        if player.boostTime <= 0 then
            player.topSpeed = player.originalTopSpeed
        end
    end

    local pw = player.w
    local ph = player.h
    local px = player.x - pw/2
    local py = player.y - ph/2

    for _, obj in ipairs(Speedup.list) do

        if not obj.active then
            obj.timer = obj.timer - dt
            if obj.timer <= 0 then
                obj.active = true
            end
        end

        if obj.active then
            if collides(
                { x = px, y = py, w = pw, h = ph },
                { x = obj.x, y = obj.y, w = Speedup.w, h = Speedup.h }
            ) then

                obj.active = false
                obj.timer = Speedup.respawnTime

                player.originalTopSpeed = player.originalTopSpeed or player.topSpeed
                player.topSpeed = player.originalTopSpeed + Speedup.boostAmount
                player.boostTime = Speedup.duration
            end
        end
    end
end

return Speedup
