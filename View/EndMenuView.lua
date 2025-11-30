local EndMenuView = {}
local EndMenu = require("Model.EndMenu")

function EndMenuView.draw()
    if not EndMenu.active then return end

    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    for _, btn in pairs(EndMenu.buttons) do
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h, 10)

        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", btn.x, btn.y, btn.w, btn.h, 10)

        love.graphics.printf(btn.text, btn.x, btn.y + 20, btn.w, "center")
    end
end

return EndMenuView
