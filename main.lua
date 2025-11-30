local GameController = require("Controller.GameController")

function love.load()
    GameController.load()
end

function love.update(dt)
    GameController.update(dt)
end

function love.draw()
    GameController.draw()
end

function love.mousepressed(x, y, button)
    GameController.mousepressed(x, y, button)
end

function love.keypressed(key)
    if GameController.keypressed then
        GameController.keypressed(key)
    end
end