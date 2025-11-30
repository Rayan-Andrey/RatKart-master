local PauseMenuView = {}
local PauseMenu = require("Model.PauseMenu")

function PauseMenuView.draw()
    if not PauseMenu.active then return end

    -- Dim background
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    -- Draw buttons
    for _, btn in pairs(PauseMenu.buttons) do
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h, 10)

        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", btn.x, btn.y, btn.w, btn.h, 10)

        love.graphics.printf(btn.text, btn.x, btn.y + 15, btn.w, "center")
    end
    
    love.graphics.printf("PAUSA", 0, love.graphics.getHeight()/2 - 150, love.graphics.getWidth(), "center")
end

return PauseMenuView
