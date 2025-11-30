local GameController = {}

local Player = require("Model.Player")
local Opponent = require("Model.Opponent")
local Obstacles = require("Model.Obstacle")
local Speedup = require("Model.Speedup")
local Race = require("Model.Race")

local PlayerView = require("View.PlayerView")
local OpponentView = require("View.OpponentView")
local ObstacleView = require("View.ObstacleView")
local SpeedupView = require("View.SpeedupView")
local RaceView = require("View.RaceView")

local StartMenu = require("Model.StartMenu")
local StartMenuView = require("View.StartMenuView")
local EndMenu = require("Model.EndMenu")
local EndMenuView = require("View.EndMenuView")
local PauseMenu = require("Model.PauseMenu")
local PauseMenuView = require("View.PauseMenuView")

function GameController.load()
    StartMenu.load()
    PauseMenu.load()
    EndMenu.load()
    
    GameController.resetGame()

    GameController.music = love.audio.newSource("Sound/music.mp3", "stream")
    GameController.music:setLooping(true)
    GameController.music:setVolume(0.3)
    GameController.music:play()
end

function GameController.resetGame()
    Player.load()
    PlayerView.load()
    
    Opponent.load(3)
    OpponentView.load()
    
    Obstacles.load()
    ObstacleView.load()
    
    Speedup.load()
    SpeedupView.load()
    
    Race.load()
    RaceView.load()
    
    PauseMenu.active = false
    EndMenu.active = false
    -- StartMenu.active remains whatever it was, or we can force it if needed. 
    -- Usually resetGame is called when we want to play again, so we don't show StartMenu.
end

function GameController.update(dt)
    if StartMenu.active then
        return
    end

    if PauseMenu.active then
        return
    end

    if Race.finished then
        EndMenu.show()
        return
    end

    Player.update(dt)
    Opponent.update(dt, Race, Obstacles)
    Obstacles.resolveCollision(Player.car)
    Speedup.update(dt, Player.car)
    Race.update(dt, Player.car)
end

function GameController.draw()
    if StartMenu.active then
        StartMenuView.draw()
        return
    end

    ObstacleView.draw()
    OpponentView.draw()
    SpeedupView.draw()
    PlayerView.draw()
    
    EndMenuView.draw()
    RaceView.draw()
    PauseMenuView.draw()
end

function GameController.keypressed(key)
    if key == "escape" then
        if not StartMenu.active and not EndMenu.active then
            PauseMenu.toggle()
        end
    end
end

function GameController.mousepressed(x, y, button)
    if StartMenu.active then
        local action = StartMenu.checkClick(x, y)
        if action == "start" then
            StartMenu.active = false
            GameController.resetGame() -- Ensure fresh start
        elseif action == "exit" then
            love.event.quit()
        end
        return
    end

    if PauseMenu.active then
        local action = PauseMenu.checkClick(x, y)
        if action == "continue" then
            PauseMenu.toggle()
        elseif action == "restart" then
            GameController.resetGame()
        elseif action == "exit" then
            love.event.quit()
        end
        return
    end

    if EndMenu.active then
        local action = EndMenu.checkClick(x, y)
        if action == "restart" then
            GameController.resetGame()
        elseif action == "exit" then
            love.event.quit()
        end
    end
end

return GameController
