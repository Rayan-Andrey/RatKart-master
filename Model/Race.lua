local Race = {}

function Race.load()
    Race.order = 1
    Race.lap = 0
    Race.lapLimit = 3
    Race.finished = false
    Race.raceTime = 0
    Race.finishedRacers = {}

    Race.list = {
        { x = love.graphics.getWidth()/2 , y = 0, w = 20, h = 150, id = 1, triggered = false },
        { x = 1000, y = love.graphics.getHeight()/2 , w = 250, h = 20, id = 2, triggered = false },
        { x = love.graphics.getWidth()/2 , y = 500, w = 20, h = 200, id = 3, triggered = false },
        { x = 0, y = love.graphics.getHeight()/2, w = 250, h = 20, id = 4, triggered = false }
    }
end

local function inside(player, cp)
    return player.x < cp.x + cp.w and
           player.x + player.w > cp.x and
           player.y < cp.y + cp.h and
           player.y + player.h > cp.y
end

function Race.finishRacer(name)
    for _, r in ipairs(Race.finishedRacers) do
        if r.name == name then return end
    end

    table.insert(Race.finishedRacers, {
        name = name,
        time = Race.raceTime
    })

    table.sort(Race.finishedRacers, function(a, b)
        return a.time < b.time
    end)

    for i, r in ipairs(Race.finishedRacers) do
        r.position = i
    end
end

function Race.update(dt, player)
    if not Race.finished then
        Race.raceTime = Race.raceTime + dt
    end

    if Race.finished then
        return
    end

    for _, cp in ipairs(Race.list) do
        if inside(player, cp) then

            if not cp.triggered and cp.id == Race.order then
                cp.triggered = true
                Race.order = Race.order + 1

                if Race.order > #Race.list then
                    Race.lap = Race.lap + 1
                    Race.order = 1

                    if Race.lap >= Race.lapLimit then
                        Race.finished = true
                        Race.finishRacer("Player")
                    end
                end
            end
        else
            cp.triggered = false
        end
    end
end

return Race
