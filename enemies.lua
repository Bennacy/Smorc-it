require "player"

local mass= 1
local ea= {}


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
    KnockBack = false, KnockBackTimer = 0,KnockBackCooldown = 0.05,KnockBackDirection = vector2.new(0,0)}
end

function DrawEnemy(enemy)
    for i=1, #enemy do
        if enemy[i] then
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", enemy[i].position.x+ enemy[i].size.x/2, enemy[i].position.y+enemy[i].size.y/1.95, enemy[i].attackLength, 10)
        if enemy[i].type== 1 then
            love.graphics.setColor(1, 0.5, 1)
        else
            love.graphics.setColor(1, 0, 1)
        end
        love.graphics.rectangle("fill", enemy[i].position.x, enemy[i].position.y, enemy[i].size.x, enemy[i].size.y)
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", enemy[i].position.x, enemy[i].position.y-15, enemy[i].size.x, 7.5)
        love.graphics.setColor(0, 1, 0.5)
        love.graphics.rectangle("fill", enemy[i].position.x, enemy[i].position.y-15, (enemy[i].health*enemy[i].size.x)/enemy[i].maxHealth, 7.5)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", enemy[i].position.x, enemy[i].position.y-15, enemy[i].size.x, 7.5)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", enemy[i].position.x, enemy[i].position.y, enemy[i].size.x, enemy[i].size.y)
        end
    end
end
local spawned = 0 

function UpdateEnemy(enemy,dt, frictionCoef)
    local playerPos=GetPlayerPosition()
    local playerSize=GetPlayerSize()
    if dt<0.05 then
        for i=1, #enemy do
            if playerPos.x >= 250 and spawned == 0 then 
                enemy[1].position.x = 700 
                enemy[2].position.x = 700
                enemy[3].position.x = -10 
                spawned = 1
            elseif playerPos.x >= 1000 and spawned == 1 then 
                enemy[1].position.x = 600
                enemy[2].position.x = 600
                enemy[3].position.x = 650
                enemy[4].position.x = 1500
                enemy[5].position.x = 1500 
                enemy[6].position.x = 1450 
                spawned = 2 
            end 
            
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


                local velocity= vector2.sub(playerPos, enemy[i].position)
                velocity= vector2.normalize(velocity)
                velocity= vector2.mult(velocity, 100)

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

                for j=1, #enemy do
                    if enemy[j] then
                    if j~= i then
                        local collisionDirectionEnemy= GetBoxCollisionDirection(futureposition.x, futureposition.y, enemy[i].size.x, enemy[i].size.y -(enemy[i].size.y/1.3), enemy[j].position.x, enemy[j].position.y, enemy[j].size.x, enemy[j].size.y  -(enemy[j].size.y/1.3))
                        if collisionDirectionEnemy.x ~= 0 then
                            velocity.x= 0
                            acceleration.x= 0
                        end
                        if collisionDirectionEnemy.y ~= 0 then
                            velocity.y= 0
                            acceleration.y= 0
                        end
                    end
                    end
                end

                if math.abs(enemy[i].position.x- playerPos.x)<50 and math.abs(enemy[i].position.y- playerPos.y)<50 and enemy[i].KnockBack == false then
                    velocity.x= 0
                    acceleration.x= 0
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

            enemy[i].delay=enemy[i].delay+dt
            
            local weapon= GetWeapons()
             
                if weapon[i].direction>0 and weapon[i].attacking==true and CheckCollision(weapon[i].position.x, weapon[i].position.y, weapon[i].size.x, weapon[i].size.y, 
                enemy[i].position.x, enemy[i].position.y, enemy[i].size.x, enemy[i].size.y)== true then
                    
                    if enemy[i].delay>-1 then --ataque para direita
                    DamageEnemy(enemy, weapon[i].damage, i)
                    DamageWeapon(weapon,i)
                    enemy[i].KnockBackDirection = vector2.new(1,0)
                    enemy[i].delay=0
                    enemy[i].KnockBack = true 
                   end

                elseif weapon[i].direction<0 then --ataque para esquerda
                    if weapon[i].attacking==true and CheckCollision(weapon[i].position.x-weapon[i].size.x, weapon[i].position.y, weapon[i].size.x, weapon[i].size.y, 
                    enemy[i].position.x, enemy[i].position.y, enemy[i].size.x, enemy[i].size.y)== true then
                        
                        if enemy[i].delay>-1 then
                            DamageEnemy(enemy, weapon[i].damage, i)
                            DamageWeapon(weapon,i)
                            enemy[i].KnockBackDirection = vector2.new(-1,0)
                            enemy[i].KnockBack = true 
                            enemy[i].delay=0
                        end
                    end
                end
      


            if enemy[i].health<0 then
                KillEnemy(enemy, i)
            end
            end
        end

    end
    ea=enemy
    attacking=false
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


function GetEnemy()
    return ea
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