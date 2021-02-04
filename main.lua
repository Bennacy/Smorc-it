require "vector2"
require "player"
require "enemies"
require "weapons"
require "camera"
require "menu"
require "collision"
require "boss"
require "map"
require "SortY"
require "punch"

local frictioncoefficient = 500
local Buttons = {}
local font = nil
local Reset= false
local enemy= {}
local started = false
local camera= {}
local boss = {}
local weapons = {}
local GameState = 0
local Respawn = {}
local Dead
local wallsUp
local Win
local WinB = {}
local playerposition = GetPlayerPosition()
local punch={}

function RandomCheck(percentage)
  if love.math.random (1, 100)<= percentage then
    return true
  else
    return false
  end
end

function love.load()

  Dead = love.graphics.newImage("gameOver.png")
  Win = love.graphics.newImage("victory.png")

  weapons[1]=CreateWeapon(100,500,65,10,1)

  punch=CreatePunch(0,0,40,10)

  font = love.graphics.newFont(32)

  table.insert(Buttons, NewButton("Start Game", function () started= true end))
  table.insert(Buttons, NewButton("Exit", function () love.event.quit(0) end))
  --table.insert(Respawn,NewButton("Try Again", function() started = true GameState = 0  Reset = false  end))
  table.insert(Respawn, NewButton("Exit", function () love.event.quit(0) end))
  table.insert(WinB,NewButton("Exit", function () love.event.quit(0) end))
end

function love.update(dt)
  if love.keyboard.isDown("escape") then
    love.event.quit()
  end

  if GetGameover() == true then
    GameState = 1
  elseif GetWin(boss)  == true then
    GameState = 2
  end

  camera=GetCamera()
  if GameState == 0 then
    if started == true then
      Sort(enemy, boss)
      UpdatePlayer(dt, frictioncoefficient, enemy)
      UpdatePunch(punch, dt)
      UpdateWeapon(weapons,dt)
      UpdateEnemy(enemy, dt, frictioncoefficient)
      UpdateBoss(boss,dt, frictioncoefficient)
      UpdateCamera()
      Reset = GetEndstage()
    end
  end
  wallsUp = GetWalls()
end
function love.draw()

  if GameState == 0 then
    camera:set()
  
    love.graphics.setColor(1, 1, 1)
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill",0,340,5000,340)  
    love.graphics.setColor(0.450, 0.745, 0.929)
    love.graphics.rectangle("fill", 0,0,5000,340) 
    love.graphics.setColor(0,1,1)
    love.graphics.rectangle("fill", 5000,340,1200,340) 
    Linesinmap()
    if Reset == true then
      love.graphics.setColor(0.407, 0.031, 0.031)
      love.graphics.rectangle("fill",5000,340,75,340)
    end
    
    DrawClouds()
    DrawTree()
    if wallsUp == true then 
      love.graphics.setColor(0.407, 0.031, 0.031)
      love.graphics.rectangle("fill",5000,340,400,340)
      love.graphics.rectangle("fill",5700,340,700,340)
    end

    DrawWeapon()
    if started== true then
      SortedDraw(playerposition.y)
    end

    camera:unset()
    if started == false then
      DrawMenuBAck()
      DrawMenu(Buttons,font)
    end

  elseif GameState == 2 then
    DrawWinBAck(Win)
    DrawWin(WinB,font)

  elseif GameState == 1 then
    DrawEndBAck(Dead)
    DrawEnd(Respawn,font)

  elseif GameState== 3 then
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)
  end
end

function love.keypressed(key)
  if key == "backspace" then
    if GameState>2 then
      GameState=0
    else
      GameState= 3
    end
  end
end