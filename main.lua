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
require "conf"

local frictioncoefficient = 500
local Buttons = {}
local font = nil
local Reset= false
local enemy= {}
local started = false
local camera= {}
local boss = {}
local PlayerDead = false
local weapons = {}
local GameState = 0
local Respawn = {}
local Dead
local wallsUp
local Win
local WinB = {}
local playerposition = GetPlayerPosition()
local punch={}
local Pause = {}

function RandomCheck(percentage)
  if love.math.random (1, 100)<= percentage then
    return true
  else
    return false
  end
end

function love.load()
  boss[1]=CreateBoss(10000, 470, 60, 100, 1)
  boss[2]=CreateBoss(10000,470, 70, 90, 2)
  boss[3]=CreateBoss(10000,470,80,100,3)
  boss[4]=CreateBoss(10000,400,20,30,4)
  boss[5]=CreateBoss(10000,520,40,60,5)
  boss[6]=CreateBoss(10000,570,40,60,5)


  enemy[1]=CreateEnemy(10000, 420, 30, 60, 1)
  enemy[2]=CreateEnemy(10000, 560, 30, 60, 1)
  enemy[3]=CreateEnemy(10000, 470, 30, 60, 1)
  enemy[4]=CreateEnemy(10000, 360, 30, 60, 1)
  enemy[5]=CreateEnemy(10000, 590, 30, 60, 1)
  enemy[6]=CreateEnemy(10000, 470, 30, 60, 1)
  enemy[7]=CreateEnemy(10000, 400, 30, 60, 1)
  enemy[8]=CreateEnemy(10000, 500, 30, 60, 1)
  enemy[9]=CreateEnemy(10000, 550, 30, 60, 1)
  enemy[10]=CreateEnemy(10000, 360, 30, 60, 1)
  enemy[11]=CreateEnemy(10000, 590, 30, 60, 1)
  enemy[12]=CreateEnemy(10000, 470, 40, 60, 2)
  enemy[13]=CreateEnemy(10000, 400, 30, 60, 1)
  enemy[14]=CreateEnemy(10000, 500, 30, 60, 1)
  enemy[15]=CreateEnemy(10000, 550, 40, 60, 2)
  enemy[16]=CreateEnemy(10000, 550, 40, 60, 2)
  enemy[17]=CreateEnemy(10000, 590, 40, 60, 2)
  enemy[18]=CreateEnemy(10000, 470, 40, 60, 2)
  enemy[19]=CreateEnemy(10000, 400, 40, 60, 2)
  enemy[20]=CreateEnemy(10000, 500, 40, 60, 2)
  enemy[21]=CreateEnemy(10000, 550, 40, 60, 2)

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
  table.insert(Pause,NewButton("Resume", function () GameState = 0 end))
  table.insert(Pause,NewButton("Exit", function () love.event.quit(0) end))
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
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill",0,340,5000,340)  --floor
    love.graphics.setColor(0.450, 0.745, 0.929)
    love.graphics.rectangle("fill", 0,0,5000,340) --background
    love.graphics.setColor(0,1,1)
    love.graphics.rectangle("fill", 5000,340,900,340) --unwalkable area
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
    DrawMenuBAck()
    DrawMenu(Pause,font)
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