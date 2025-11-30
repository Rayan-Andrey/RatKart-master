local StartMenu = {}

StartMenu.active = true

StartMenu.buttons = {
    start = { w = 250, h = 70, text = "START RACE" },
    exit  = { w = 250, h = 70, text = "EXIT GAME" }
}

function StartMenu.load()
    local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
    local startY = sh / 2 - 60
    local i = 0

    for _, btn in pairs(StartMenu.buttons) do
        btn.x = (sw - btn.w) / 2
        btn.y = startY + i * 100
        i = i + 1
    end
end

local function mouseInButton(btn, mx, my)
    if not btn then return false end
    return mx > btn.x and mx < btn.x + btn.w and
           my > btn.y and my < btn.y + btn.h
end

function StartMenu.checkClick(x, y)
    if not StartMenu.active then return nil end

    if mouseInButton(StartMenu.buttons.start, x, y) then
        return "start"
    end

    if mouseInButton(StartMenu.buttons.exit, x, y) then
        return "exit"
    end

    return nil
end

return StartMenu
