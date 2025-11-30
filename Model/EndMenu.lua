local EndMenu = {}

EndMenu.active = false

EndMenu.buttons = {
    restart = { w = 200, h = 60, text = "RESTART" },
    exit    = { w = 200, h = 60, text = "EXIT GAME" }
}

function EndMenu.load()
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    local startY = screenH / 2 - 80
    local idx = 0

    for _, btn in pairs(EndMenu.buttons) do
        btn.x = (screenW - btn.w) / 2
        btn.y = startY + idx * 100
        idx = idx + 1
    end
end

function EndMenu.show()
    EndMenu.active = true
    EndMenu.load()
end

local function mouseInButton(btn, mx, my)
    if not btn then return false end
    return mx > btn.x and mx < btn.x + btn.w and
           my > btn.y and my < btn.y + btn.h
end

function EndMenu.checkClick(x, y)
    if not EndMenu.active then return nil end

    if mouseInButton(EndMenu.buttons.restart, x, y) then
        return "restart"
    end

    if mouseInButton(EndMenu.buttons.exit, x, y) then
        return "exit"
    end

    return nil
end

return EndMenu
