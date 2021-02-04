require "player"

local mass= 1
local enemy= {}
local playerWeapon= {}
local spawned = 0



function CreateEnemy(x, y, w, h, t)
    local health
    local attackSpeed
    local maxvelocity
    local damage

    if t== 1 then
        health=100
        attackSpeed= 1
        maxvelocity= 400
        damage= 0.75
    else
        health= 150
        attackSpeed= 0.75
        maxvelocity= 300
        damage=1
    end

    return{position=vector2.new(x,y), size=vector2.new(w,h), type= t, health=health, attSp= attackSpeed, maxvelocity= maxvelocity, 
    damage=damage, attacking=false, attackLength= 0, growing=false, maxHealth=health, delay=1, 
    KnockBack = false, KnockBackTimer = 0,KnockBackCooldown = 0.05,KnockBackDirection = vector2.new(0,0), engaged= false, randomDist= love.math.random(-30, 30),
    eType= 1}
end

function DrawEnemy(sortedEnemy)
            love.graphics.setColor(0, 1, 0)
            love.graphics.rectangle("fill", sortedEnemy.position.x+ sortedEnemy.size.x/2, sortedEnemy.position.y+sortedEnemy.size.y/1.95, sortedEnemy.attackLength, 10)

            if sortedEnemy.type== 1 then
                love.graphics.setColor(1, 0.5, 1)
            else
                love.graphics.setColor(1, 0, 1)
            end

            love.graphics.rectangle("fill", sortedEnemy.position.x, sortedEnemy.position.y, sortedEnemy.size.x, sortedEnemy.size.y)
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("fill", sortedEnemy.position.x, sortedEnemy.position.y-15, sortedEnemy.size.x, 7.5)
            love.graphics.setColor(0, 1, 0.5)
            love.graphics.rectangle("fill", sortedEnemy.position.x, sortedEnemy.position.y-15, (sortedEnemy.health*sortedEnemy.size.x)/sortedEnemy.maxHealth, 7.5)
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("line", sortedEnemy.position.x, sortedEnemy.position.y-15, sortedEnemy.size.x, 7.5)
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("line", sortedEnemy.position.x, sortedEnemy.position.y, sortedEnemy.size.x, sortedEnemy.size.y)
end

function UpdateEnemy(origEnemy,dt, frictionCoef)
    enemy= origEnemy
    local playerPos=GetPlayerPosition()
    local playerSize=GetPlayerSize()
    if dt<0.05 then
        if playerPos.x >= 250 and spawned == 0 then 
            table.insert(enemy,CreateEnemy(700,420, 30, 60, 1))
            table.insert(enemy, CreateEnemy(700, 560, 30, 60, 1))
            table.insert(enemy,CreateEnemy(-10, 470, 30, 60, 1))
            spawned = 1
            
        elseif playerPos.x >= 1000 and spawned == 1 then 
            table.insert(enemy,CreateEnemy(600,420, 30, 60, 1))
            table.insert(enemy, CreateEnemy(600, 560, 30, 60, 1))
            table.insert(enemy,CreateEnemy(650, 470, 30, 60, 1))
            table.insert(enemy,CreateEnemy(1500,420, 30, 60, 1))
            table.insert(enemy, CreateEnemy(1500, 560, 30, 60, 1))
            table.insert(enemy,CreateEnemy(1450, 470, 30, 60, 1))
            spawned = 2 
        elseif playerPos.x >= 2500 and spawned == 2 then 
            table.insert(enemy,CreateEnemy(2100,420, 30, 60, 1))
            table.insert(enemy, CreateEnemy(2100, 560, 30, 60, 1))
            table.insert(enemy,CreateEnemy(2150, 470, 40, 60, 2))
            table.insert(enemy,CreateEnemy(2900,420, 30, 60, 1))
            table.insert(enemy, CreateEnemy(2900, 560, 30, 60, 1))
            table.insert(enemy,CreateEnemy(2950, 470, 40, 60, 2))
            spawned = 3
        elseif playerPos.x >= 4000 and spawned == 3 then 
            table.insert(enemy,CreateEnemy(3600,420, 40, 60, 2))
            table.insert(enemy, CreateEnemy(3600, 560, 40, 60, 2))
            table.insert(enemy,CreateEnemy(3650, 470, 40, 60, 2))
            table.insert(enemy,CreateEnemy(4500,420, 40, 60, 2))
            table.insert(enemy, CreateEnemy(4500, 560, 40, 60, 2))
            table.insert(enemy,CreateEnemy(4550, 470, 40, 60, 2))
            spawned = 4
        end 
        for i=1, #enemy do
        if enemy[i] then
            if enemy[i].KnockBack == true then
                enemy[i].KnockBackTimer = enemy[i].KnockBackTimer+dt
                if  enemy[i].KnockBackTimer < enemy[i].KnockBackCooldown then
                    local movement = vector2.mult(enemy[i].KnockBackDirection,7500)
                    local velocity = vector2.new(0,0)
                    velocity= vector2.add(velocity, movement)
                    velocity=vector2.limit(velocity, enemy[i].maxvelocity)
                    velocity= vector2.mult(velocity, dt)
                    enemy[i].position= vector2.add(enemy[i].position, velocity)

                elseif  enemy[i].KnockBackTimer > enemy[i].KnockBackCooldown  then
                    enemy[i].KnockBack = false
                    enemy[i].KnockBackTimer = 0
                end

            elseif math.abs(enemy[i].position.x-playerPos.x)<2000  then
                local velocity= vector2.new(0, 0)
                velocity= vector2.sub(vector2.new(playerPos.x, playerPos.y+ enemy[i].randomDist), enemy[i].position)
                velocity= vector2.normalize(velocity)
                velocity= vector2.mult(velocity, 100)
                --[[
                for j= 1, #enemy do
                    if enemy[j]~= enemy[i] then
                    if playerPos.x< enemy[j].position.x then
                        velocity= vector2.sub(vector2.new(playerPos.x+ 250, playerPos.y+ love.math.random(-30, 30)), enemy[j].position)
                        velocity= vector2.normalize(velocity)
                        velocity= vector2.mult(velocity, 100)
                    else
                        velocity= vector2.sub(vector2.new(playerPos.x- 250, playerPos.y+ love.math.random(-30, 30)), enemy[j].position)
                        velocity= vector2.normalize(velocity)
                        velocity= vector2.mult(velocity, 100)
                    end
                    end
                end
                --]]

                local friction = vector2.mult(velocity, -1)
                friction = vector2.normalize(friction)
                friction = vector2.mult(friction, frictionCoef)

                local acceleration= vector2.new(0, 0)
                acceleration= vector2.applyForce(friction, mass, acceleration)
                acceleration= vector2.applyForce(velocity, mass, acceleration)
                acceleration= vector2.mult(acceleration, dt)

                local futurevelocity=vector2.add(velocity, acceleration)
                futurevelocity=vector2.limit(futurevelocity, enemy[i].maxvelocity)
                futurevelocity= vector2.mult(futurevelocity, dt)

                local futureposition=vector2.add(enemy[i].position, futurevelocity)
                local collisionDirectionPlayer= GetBoxCollisionDirection(futureposition.x, futureposition.y, enemy[i].size.x, enemy[i].size.y, playerPos.x, playerPos.y, playerSize.x, playerSize.y)

                if collisionDirectionPlayer.x ~= 0 then
                    velocity.x= 0
                    acceleration.x= 0
                end

                if collisionDirectionPlayer.y ~= 0 then
                    velocity.y= 0
                    acceleration.y= 0
                end

                --[[
                for j= 1, #enemy do
                    if enemy[i]~= enemy[j] and math.abs(enemy[j].position.x - playerPos.x)< 50 then
                        enemy[j].engaged= true
                    else
                        enemy[j].engaged= false
                    end
                    enemy[i].engaged= false
                end
                --]]

                if math.abs(enemy[i].position.x- playerPos.x)<50 and math.abs(enemy[i].position.y- playerPos.y)<50 and enemy[i].KnockBack == false then
                    velocity.x= 0
                    acceleration.x= 0
                    enemy[i].attacking= true
                    EnemyAttack(enemy[i], playerPos, dt, playerSize)
                else
                    enemy[i].attacking= false
                    enemy[i].attackLength=0
                end

                velocity= vector2.add(velocity, acceleration)
                velocity=vector2.limit(velocity, enemy[i].maxvelocity)
                velocity= vector2.mult(velocity, dt)
                enemy[i].position= vector2.add(enemy[i].position, velocity)
            end

            if love.keyboard.isDown("p")== true and enemy[i].delay>0.5 and math.abs(enemy[i].position.x-playerPos.x)<1000 then
                DamageEnemy(enemy, 5000, i)
                enemy[i].delay= 0
            end

            --Attack Enemy Start
            playerWeapon= GetPlayerWeapon()
            if playerWeapon~= nil then
                local playerAttack= GetAttack()
                if playerAttack== true and playerWeapon.direction>0 and CheckCollision(playerWeapon.position.x, playerWeapon.position.y, playerWeapon.size.x, playerWeapon.size.y,
                    enemy[i].position.x, enemy[i].position.y, enemy[i].size.x, enemy[i].size.y)== true then
                    DamageEnemy(enemy, playerWeapon.damage, i)
                    DamageWeapon(playerWeapon)
                    enemy[i].KnockBackDirection = vector2.new(1,0)
                    enemy[i].KnockBack = true
                end

                if playerAttack== true and playerWeapon.direction<0 and CheckCollision(playerWeapon.position.x-playerWeapon.size.x, playerWeapon.position.y, playerWeapon.size.x, playerWeapon.size.y,
                    enemy[i].position.x, enemy[i].position.y, enemy[i].size.x, enemy[i].size.y)== true then
                    DamageEnemy(enemy, playerWeapon.damage, i)
                    DamageWeapon(playerWeapon)
                    enemy[i].KnockBackDirection = vector2.new(-1,0)
                    enemy[i].KnockBack = true
                end
            end

            local punch= GetPunch()
                if punch.direction>0 and punch.attacking==true and CheckCollision(punch.position.x, punch.position.y, punch.size.x, punch.size.y, 
                enemy[i].position.x, enemy[i].position.y, enemy[i].size.x, enemy[i].size.y)== true then

                    if enemy[i].delay>-1 then --ataque para direita
                    DamageEnemy(enemy, punch.damage, i)
                    enemy[i].KnockBackDirection = vector2.new(1,0)
                    enemy[i].delay=0
                    enemy[i].KnockBack = true
                   end

                elseif punch.direction<0 then --ataque para esquerda
                    if punch.attacking==true and CheckCollision(punch.position.x-punch.size.x, punch.position.y, punch.size.x, punch.size.y, 
                    enemy[i].position.x, enemy[i].position.y, enemy[i].size.x, enemy[i].size.y)== true then

                    if enemy[i].delay>-1 then
                        DamageEnemy(enemy, punch.damage, i)
                        enemy[i].KnockBackDirection = vector2.new(-1,0)
                        enemy[i].KnockBack = true
                        enemy[i].delay=0
                    end
                    end
                end
            --Attack Enemy End

            if enemy[i].health<0 then
                KillEnemy(enemy, i)
            end
        end
    end
    end
end


function DamageEnemy(enemy, damage, i)
    enemy[i].health= enemy[i].health- damage
    return enemy[i].health
end

function KillEnemy(enemy, i)
    if RandomCheck(100)== true then
        if enemy[i].type== 1 then
            DropWeapon(1, enemy[i].position)
        elseif enemy[i].type== 2 then
            DropWeapon(2, enemy[i].position)
        end
    end
    table.remove(enemy, i)
    return enemy[i]
end

function GetWave()
    return spawned
    
end


function GetEnemy()
    return enemy
end


function EnemyAttack(enemy, playerPos, dt, playerSize)
    if enemy.position.x> playerPos.x then
        if enemy.attackLength> -75 and enemy.growing==true then
            enemy.attackLength= enemy.attackLength- enemy.attSp*250*dt
        elseif enemy.attackLength<= -75 then
            enemy.growing=false
        end
        if enemy.attackLength<0 and enemy.growing==false then
            enemy.attackLength= enemy.attackLength+ enemy.attSp*350*dt
        elseif enemy.attackLength>= 0 then
            enemy.growing= true
        end
    elseif enemy.position.x< playerPos.x then
        if enemy.attackLength< 75 and enemy.growing==true then
            enemy.attackLength= enemy.attackLength+ enemy.attSp*250*dt
        elseif enemy.attackLength>= 75 then
            enemy.growing=false
        end
        if enemy.attackLength>0 and enemy.growing==false then
            enemy.attackLength= enemy.attackLength- enemy.attSp*350*dt
        elseif enemy.attackLength<= 0 then
            enemy.growing= true
        end
    end

    local enemyweapon={
        position= vector2.new(0, 0),
        size= vector2.new(0, 0)
    }

    enemyweapon.position.x=  enemy.position.x+(enemy.size.x/2)
    enemyweapon.position.y=  enemy.position.y+( enemy.size.y/1.95)
    enemyweapon.size.x=  enemy.attackLength
    enemyweapon.size.y= 10
    local player= {
        position= playerPos,
        size= playerSize
    }
    CheckEnemyWeaponCollision(enemyweapon, player, enemy)
end

function CheckEnemyWeaponCollision(enemyweapon, player, enemy)

    if CheckCollision(enemyweapon.position.x, enemyweapon.position.y, enemyweapon.size.x, enemyweapon.size.y, player.position.x, player.position.y, player.size.x, player.size.y)== true and enemyweapon.size.x>0 then
        DamagePlayer(enemy.damage)

    elseif enemyweapon.size.x<0 then
        if CheckCollision(enemyweapon.position.x+enemyweapon.size.x, enemyweapon.position.y, -enemyweapon.size.x, enemyweapon.size.y, player.position.x, player.position.y, player.size.x, player.size.y)== true then
            DamagePlayer(enemy.damage)
        end
    end
end
