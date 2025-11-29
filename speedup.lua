local speedup = {}

speedup.list = {}
speedup.sprites = {}
speedup.duration = 2        -- player boost time
speedup.boostAmount = 200   -- extra speed
speedup.respawnTime = 4     -- time before object reappears


function speedup.new(x, y, spriteType)
    table.insert(speedup.list, {
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

function speedup.load()

    speedup.sprites[1] = love.graphics.newImage("Sprites/speedup_vertical.png")
    speedup.sprites[2] = love.graphics.newImage("Sprites/speedup_vertical.png")

    speedup.w = speedup.sprites[1]:getWidth()
    speedup.h = speedup.sprites[1]:getHeight()


    speedup.new(100, 100, 1)
    speedup.new(900, 650, 1)
end

function speedup.update(dt, player)

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

    for _, obj in ipairs(speedup.list) do


        if not obj.active then
            obj.timer = obj.timer - dt
            if obj.timer <= 0 then
                obj.active = true
            end
        end

        if obj.active then
            if collides(
                { x = px, y = py, w = pw, h = ph },
                { x = obj.x, y = obj.y, w = speedup.w, h = speedup.h }
            ) then

                obj.active = false
                obj.timer = speedup.respawnTime


                player.originalTopSpeed = player.originalTopSpeed or player.topSpeed
                player.topSpeed = player.originalTopSpeed + speedup.boostAmount
                player.boostTime = speedup.duration
            end
        end
    end
end

function speedup.draw()
    for _, obj in ipairs(speedup.list) do

        if obj.active then
            love.graphics.setColor(1, 1, 1)
            local sprite = speedup.sprites[obj.spriteType]
            love.graphics.draw(sprite, obj.x, obj.y)
        end
    end
end

return speedup
