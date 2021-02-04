require "boss"


local playerposition = vector2.new(50, 500)
local velocity = vector2.new(0, 0)
local mass = 1
local playersize = vector2.new(30, 60)
local weapon = nil
local attacking = false
local maxvelocity = 9999
local movementForce = 1500
local EndStage = false
local BackUpCam = false
local maxHealth=750
local health=maxHealth
local teleported = false
local god = false
local wave = 0
 
function UpdatePlayer(dt, frictioncoefficient, enemy)
--Movement Start
    local friction = vector2.mult(velocity, -1)
    friction = vector2.normalize(friction)
    friction = vector2.mult(friction, frictioncoefficient)
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
-- Player Movement Restrictions start
    wave = GetWave()
    if playerposition.y < love.graphics.getHeight()  -200 - playersize.y then
        playerposition.y = love.graphics.getHeight() -200 - playersize.y
    end

    if playerposition.y > love.graphics.getHeight() + 80 - playersize.y then
        playerposition.y = love.graphics.getHeight() + 80 - playersize.y
    end

    if playerposition.x < (playersize.x/2)*0.3 then
       playerposition.x = (playersize.x /2)*0.3
    end

    if playerposition.x > 800 - playersize.x and #enemy > 0 and wave == 1 then
        playerposition.x = 800 -playersize.x
    end

    if playerposition.x > 1600 - playersize.x and #enemy > 0 and wave == 2 then
        playerposition.x = 1600 - playersize.x
    end

    if playerposition.x > 3200 - playersize.x and #enemy > 0 and wave == 3 then
        playerposition.x = 3200 - playersize.x
    end

    if playerposition.x > 4700 - playersize.x and #enemy > 0 and wave == 4 then
        playerposition.x = 4700 - playersize.x
    end

    if playerposition.x > 5075  then
        EndStage = true
    end

    if playerposition.x > 6000 - playersize.x  then
        playerposition.x = 6000 - playersize.x
    end

    if EndStage == true and playerposition.x < 5075  then 
        playerposition.x = 5075
    end

    if wallsUp == true then
        if teleported == false then
            playerposition = vector2.new(5450,500)
            velocity = vector2.new(0,0)
            teleported = true
        end

        if playerposition.x >= 5700 - playersize.x then
            playerposition.x = 5700 - playersize.x
        end

        if playerposition.x < 5400  then
            playerposition.x = 5400
        end

        if playerposition.y < love.graphics.getHeight()  -200 - playersize.y then
            playerposition.y = love.graphics.getHeight() -200 - playersize.y
        end

        if playerposition.y > love.graphics.getHeight() + 80 - playersize.y then
            playerposition.y = love.graphics.getHeight() + 80 - playersize.y
        end
    end
--Movement End


--Weapon Start
    if weapon ~= nil then
        if weapon.durability <0 then
            attacking= false
            weapon.groundTimer= 100
            BreakWeapon()
        end
    end

    if weapon~= nil then
        weapon.position.x=playerposition.x+playersize.x/2
        weapon.position.y=playerposition.y+playersize.y/2
        weapon.cooldownTimer=(weapon.cooldownTimer + dt)

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
    end
    if weapon ~= nil and weapon.cooldownTimer>weapon.attSp/8 then
        attacking= false
    end
--Weapon End
end

function DrawPlayer()
    if attacking== true and weapon ~= nil then
        love.graphics.setColor(0.2, 0, 0.5)
        love.graphics.rectangle("fill", playerposition.x+ playersize.x/2, playerposition.y+ playersize.y/3, weapon.direction* weapon.size.x, weapon.size.y)
    end
    DrawPunch()

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

--General Info
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
--Info End

function DamagePlayer(damage)
    if god == false then
        health=health-damage
    end
end

--Weapon Related
function AssignWeapon(array, id)
    weapon= array[id]
end

function BreakWeapon()
    weapon= nil
end

function DamageWeapon(weapon)
    weapon.durability= weapon.durability- 0.75
    return weapon.durability
end

function GetPlayerWeapon()
    return weapon
end

function GetAttack()
    return attacking
end
-- Weapon End