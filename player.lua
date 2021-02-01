require "boss"


local playerposition = vector2.new(50, 500)
local velocity = vector2.new(0, 0)
local mass = 1
local playersize = vector2.new(30, 60)
local weapon = nil
local attacking = false
local maxvelocity = 300
local movementForce = 1500
local EndStage = false
local BackUpCam = false
local maxHealth=750
local health=maxHealth
local teleported = false
local god = false

function UpdatePlayer(dt, frictioncoefficient)
--Movement Start
    local friction = vector2.mult(velocity, -1)
    friction = vector2.normalize(friction)
    friction = vector2.mult(friction, frictioncoefficient)
    local enemy=GetEnemy()
    local acceleration = vector2.new(0, 0)
    local wallsUp = GetWalls()

    acceleration = vector2.applyForce(friction, mass, acceleration)

    if love.keyboard.isDown("g") then
        god = true
    end

    if love.keyboard.isDown("right") then
        local moveForce = vector2.new(movementForce, 0)
        acceleration = vector2.applyForce(moveForce, mass, acceleration)
    end

    if love.keyboard.isDown("left") then
        local moveForce = vector2.new(-movementForce, 0)
        acceleration = vector2.applyForce(moveForce, mass, acceleration)
    end

    if love.keyboard.isDown("up") then
        local moveForce = vector2.new(0, -movementForce)
        acceleration = vector2.applyForce(moveForce, mass, acceleration)
    end
    
    if love.keyboard.isDown("down") then
        local moveForce = vector2.new(0, movementForce)
        acceleration = vector2.applyForce(moveForce, mass, acceleration)
    end


    if friction.x * acceleration.x >= (0.7*dt) then
        velocity.x = 0
    end

    if friction.y * acceleration.y >= (0.7*dt) then
        velocity.y = 0
    end

    velocity = vector2.add(velocity, vector2.mult(acceleration, dt))
    velocity = vector2.limit(velocity, maxvelocity)
    playerposition = vector2.add(playerposition, vector2.mult(velocity, dt))
--Movement End

    if EndStage == false then 
        if playerposition.y < love.graphics.getHeight()  -200 - playersize.y then
            playerposition.y = love.graphics.getHeight() -200 - playersize.y
        end

        if playerposition.y > love.graphics.getHeight() + 80 - playersize.y then
            playerposition.y = love.graphics.getHeight() + 80 - playersize.y
        end


        if playerposition.x < (playersize.x/2)*0.3 then
            playerposition.x = (playersize.x /2)*0.3
        end

        if playerposition.x > 800 - playersize.x and #enemy > 6 then 
            playerposition.x = 800 -playersize.x
        end 

        if playerposition.x > 1890 - playersize.x and #enemy~=0 then
            playerposition.x = 1890 - playersize.x
        end

        if playerposition.x > 1900 - playersize.x and #enemy==0 then 
            playerposition.x = 50  playerposition.y = 500 
            velocity = vector2.new(0,0) acceleration = vector2.new(0,0)
            EndStage = true
            BackUpCam = true
        end
    end

    if weapon ~= nil then
        weapon.position.x=playerposition.x+playersize.x/2
        weapon.position.y=playerposition.y+playersize.y/2

        if love.keyboard.isDown("right") then
            weapon.direction= 1
        end

        if love.keyboard.isDown("left") then
            weapon.direction= -1
        end

        if love.keyboard.isDown("x") and weapon ~= nil  then
            weapon = nil
        end
    end


    if weapon ~= nil and love.keyboard.isDown("c") and (weapon.cooldownTimer > weapon.attSp) then --attack
        attacking= true
        weapon.cooldownTimer = 0

    elseif weapon ~= nil then
        weapon.cooldownTimer=(weapon.cooldownTimer + dt)

    else
        attacking= false
    end

    if EndStage == true and wallsUp == false then 
        if playerposition.y < love.graphics.getHeight()  -200 - playersize.y then
            playerposition.y = love.graphics.getHeight() -200 - playersize.y
        end

        if playerposition.y > love.graphics.getHeight() + 80 - playersize.y then
            playerposition.y = love.graphics.getHeight() + 80 - playersize.y
        end

        if playerposition.x > 700 - playersize.x then
            playerposition.x = 700 - playersize.x
        end

        if playerposition.x < (playersize.x *1.5)  then
            playerposition.x = (playersize.x *1.5)
        end

    elseif wallsUp == true then 
        if teleported == false then 
            playerposition = vector2.new(200,500)
            teleported = true 
        end

        if playerposition.x >= 500 - playersize.x then
            playerposition.x =  500 - playersize.x
        end

        if playerposition.x < 250    then
            playerposition.x = 250 
        end

        if playerposition.y < love.graphics.getHeight()  -200 - playersize.y then
            playerposition.y = love.graphics.getHeight() -200 - playersize.y
        end

        if playerposition.y > love.graphics.getHeight() + 80 - playersize.y then
            playerposition.y = love.graphics.getHeight() + 80 - playersize.y
        end
    end
end


function GetEndstage()
    return EndStage
end


function Getcamerareset()
    return BackUpCam
end


function GetPlayerPosition()
    return playerposition
end


function GetPlayerSize()
    return playersize
end

function GetPlayerWeapon()
    return weapon
end

function GetAttack()
    return attacking
end


function GetPlayerVelocity()
    return velocity  
end


function UpdatePlayerHealth()
    if health == 0 then 
        return true
    else 
        return false 
end
end
function GetGameover()
    if health < 0 then   
        return true 
    else 
        return false 
    end
end 

function DrawPlayer()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", playerposition.x, playerposition.y, playersize.x, playersize.y)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line",playerposition.x, playerposition.y, playersize.x, playersize.y)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill",playerposition.x, playerposition.y-15, playersize.x, 7.5)

    if health>0 then
        love.graphics.setColor(0, 1, 0.5)
        love.graphics.rectangle("fill",playerposition.x, playerposition.y-15, playersize.x*health/maxHealth, 7.5)
    end

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line",playerposition.x, playerposition.y-15, playersize.x, 7.5)
end


function DamagePlayer(damage)
    if god == false then
        health=health-damage
    end
end

function AssignWeapon(array, id)
    weapon= array[id]
end