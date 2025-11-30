local StartMenuView = {}
local StartMenu = require("Model.StartMenu")

function StartMenuView.draw()
    if not StartMenu.active then return end

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("RatKart", love.graphics.getWidth()/2 - 50, love.graphics.getHeight()/2 - 300 , love.graphics.getWidth(), "left",nil, 3, 3)

    for _, btn in pairs(StartMenu.buttons) do
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h, 10)

        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", btn.x, btn.y, btn.w, btn.h, 10)

        love.graphics.printf(btn.text, btn.x, btn.y + 23, btn.w, "center")
    end
end

return StartMenuView
