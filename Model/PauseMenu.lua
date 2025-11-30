local PauseMenu = {}

PauseMenu.active = false

PauseMenu.buttons = {
    continue = { w = 200, h = 50, text = "CONTINUAR" },
    restart  = { w = 200, h = 50, text = "REINICIAR" },
    exit     = { w = 200, h = 50, text = "SALIR" }
}

function PauseMenu.load()
    local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
    local startY = sh / 2 - 75
    
    -- Position buttons
    PauseMenu.buttons.continue.x = (sw - PauseMenu.buttons.continue.w) / 2
    PauseMenu.buttons.continue.y = startY
    
    PauseMenu.buttons.restart.x = (sw - PauseMenu.buttons.restart.w) / 2
    PauseMenu.buttons.restart.y = startY + 70
    
    PauseMenu.buttons.exit.x = (sw - PauseMenu.buttons.exit.w) / 2
    PauseMenu.buttons.exit.y = startY + 140
end

function PauseMenu.toggle()
    PauseMenu.active = not PauseMenu.active
end

local function mouseInButton(btn, mx, my)
    if not btn then return false end
    return mx > btn.x and mx < btn.x + btn.w and
           my > btn.y and my < btn.y + btn.h
end

function PauseMenu.checkClick(x, y)
    if not PauseMenu.active then return nil end

    if mouseInButton(PauseMenu.buttons.continue, x, y) then
        return "continue"
    elseif mouseInButton(PauseMenu.buttons.restart, x, y) then
        return "restart"
    elseif mouseInButton(PauseMenu.buttons.exit, x, y) then
        return "exit"
    end

    return nil
end

return PauseMenu
