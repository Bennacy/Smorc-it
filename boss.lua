local mass= 1
local drawing=1000000

function CreateBoss(x, y, w, h, t)
    local health
    local attackSpeed
    local maxvelocity
    local damage
    local maxHealth
    if t == 1 then
        health= 750
        attackSpeed= 1
        maxvelocity= 300
        damage= 1
        maxHealth = 750
    elseif t == 2 then
        health= 500
        attackSpeed= 1.25
        maxvelocity= 350
        damage = 2
        maxHealth = 750
    elseif t == 3 then  
        health= 250
        attackSpeed= 1.5
        maxvelocity= 400
        damage= 3 
        maxHealth = 750
    elseif t == 4 then 
        health=150
        attackSpeed = 3
        maxvelocity= 900
        damage= 0.5
        maxHealth = 150
    elseif t == 5 then 
        health =200
        attackSpeed = 1
        maxvelocity = 400
        damage = 1
        maxHealth = 200     
    end
    return{position=vector2.new(x,y), size=vector2.new(w,h), type= t, health=health, attSp= attackSpeed, maxvelocity= maxvelocity, damage=damage, attacking=false, 
    attackLength= 0, growing=false, maxHealth=maxHealth,delay = 1,
    KnockBack = false, KnockBackTimer = 0,KnockBackCooldown = 0.5,KnockBackDirection = vector2.new(0,0)}
end

function DrawBoss(boss)
    for i=1, #boss do
        if boss[i] then
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", boss[i].position.x+ boss[i].size.x/2, boss[i].position.y+boss[i].size.y/4, boss[i].attackLength, 10)
        if boss[i].type== 1 then
            love.graphics.setColor(0.992, 0.188, 0.262)
        elseif boss[i].type == 2 then
            love.graphics.setColor(0.921, 0, 0.086)
        elseif boss[i].type == 3 then  
            love.graphics.setColor(0.803, 0.015, 0.090)
        elseif boss[i].type == 4  then   
            love.graphics.setColor(0.996, 0.486, 0.796) 
        else 
            love.graphics.setColor(0.674, 0.007, 0.411) 
        end
        love.graphics.rectangle("fill", boss[i].position.x, boss[i].position.y, boss[i].size.x, boss[i].size.y)
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", boss[i].position.x, boss[i].position.y-15, boss[i].size.x, 7.5)
        love.graphics.setColor(0, 1, 0.5)
        love.graphics.rectangle("fill", boss[i].position.x, boss[i].position.y-15, (boss[i].health*boss[i].size.x)/boss[i].maxHealth, 7.5)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", boss[i].position.x, boss[i].position.y-15, boss[i].size.x, 7.5)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", boss[i].position.x, boss[i].position.y, boss[i].size.x, boss[i].size.y)

        end
    end
    love.graphics.rectangle("fill", drawing, 100, 100, 100)
end
local getboss1 = vector2.new(0,0)
local hell = vector2.new(100000,0)
local getboss2 = vector2.new(0,0)
local teleported = 0 
local walls = false 
function GetWalls()
    return walls 
end
function UpdateBoss(boss,dt,frictionCoef)
    local Reset = GetEndstage()
    local playerPos=GetPlayerPosition()
    local playerSize=GetPlayerSize()
  
    if dt<0.05 then
        for i=1, #boss do
            if boss[i] then
            if Reset == true and boss[1].health >= 500 and teleported == 0  then 
                boss[1].position.x = 600
                teleported = 1                            
            elseif boss[2].health >250 and boss[1].health < 500 and teleported == 1 then 
                    getboss1 = boss[1].position
                    boss[1].position =  hell 
                    boss[2].position = getboss1
                if getboss1.x < 400 then 
                    boss[4].position.x = -10
                    boss[5].position.x = 825
                    boss[6].position.x = 875
                else 
                    boss[4].position.x = 810
                    boss[5].position.x = -75
                    boss[6].position.x = -25
                end 
                
                teleported = 2
                                  
            elseif boss[2].health <= 250 and teleported == 2 then 
                
                    boss[2].position = hell
                    boss[3].position = vector2.new(350,500)
                    walls = true 
                    teleported = 3
                  
               
            end
            if boss[i].KnockBack == true and boss[i].type > 3 then 
                boss[i].KnockBackTimer = boss[i].KnockBackTimer+dt

            if  boss[i].KnockBackTimer < boss[i].KnockBackCooldown then 
                local movement = vector2.mult(boss[i].KnockBackDirection,75)
                local velocity = vector2.new(0,0)

            velocity= vector2.add(velocity, movement)
            velocity=vector2.limit(velocity, boss[i].maxvelocity)
            velocity= vector2.mult(velocity, dt)
            boss[i].position= vector2.add(boss[i].position, velocity)
            elseif  boss[i].KnockBackTimer > boss[i].KnockBackCooldown  then
                boss[i].KnockBack = false
                boss[i].KnockBackTimer = 0   
            end 
        elseif math.abs(boss[i].position.x-playerPos.x)<2000 then
    
                    local velocity= vector2.sub(playerPos, boss[i].position)
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
                    futurevelocity=vector2.limit(futurevelocity, boss[i].maxvelocity)
                    futurevelocity= vector2.mult(futurevelocity, dt)
                    local futureposition=vector2.add(boss[i].position, futurevelocity)
    
                    local collisionDirectionPlayer= GetBoxCollisionDirection(futureposition.x, futureposition.y, boss[i].size.x, boss[i].size.y, playerPos.x, playerPos.y, playerSize.x, playerSize.y)
                    if collisionDirectionPlayer.x ~= 0 then
                        velocity.x= 0
                        acceleration.x= 0
                    end
                    if collisionDirectionPlayer.y ~= 0 then
                        velocity.y= 0
                        acceleration.y= 0
                    end
                
                    for j=1, #boss do
                        if boss[j] then
                        if j~= i then
                            local collisionDirectionBoss= GetBoxCollisionDirection(futureposition.x, futureposition.y, boss[i].size.x, boss[i].size.y - (boss[i].size.y/1.3), boss[j].position.x, boss[j].position.y, boss[j].size.x, boss[j].size.y- (boss[j].size.y/1.3))
                            if collisionDirectionBoss.x ~= 0 then
                                velocity.x= 0
                                acceleration.x= 0
                            end
                            if collisionDirectionBoss.y ~= 0 then
                                velocity.y= 0
                                acceleration.y= 0
                            end
                        end
                        end
                    end
                    
    
                    if math.abs((boss[i].position.x + boss[i].size.x/2)- (playerPos.x + playerSize.x /2))<boss[i].size.x + 10 and math.abs(boss[i].position.y- playerPos.y)<50 then
                        velocity.x= 0
                        acceleration.x= 0
                        BossAttack(boss[i], playerPos, dt, playerSize)
                    else
                        boss[i].attackLength=0
                    end
    
                    velocity= vector2.add(velocity, acceleration)
                    velocity=vector2.limit(velocity, boss[i].maxvelocity)
                    velocity= vector2.mult(velocity, dt)
                    boss[i].position= vector2.add(boss[i].position, velocity)
                end
    
                if love.keyboard.isDown("o")== true  and math.abs(boss[i].position.x-playerPos.x)<1000 then
                    DamageBoss(boss, 5, i)
                    boss[i].delay= 0
                end
    
                boss[i].delay=boss[i].delay+dt
    
                playerWeapon= GetPlayerWeapon()
            if playerWeapon~= nil then
                local playerAttack= GetAttack()

                if playerAttack== true and playerWeapon.direction>0 and CheckCollision(playerWeapon.position.x, playerWeapon.position.y, playerWeapon.size.x, playerWeapon.size.y,
                boss[i].position.x, boss[i].position.y, boss[i].size.x, boss[i].size.y)== true then
                    DamageEnemy(boss, playerWeapon.damage, i)
                    DamageWeapon(playerWeapon)
                    boss[i].KnockBackDirection = vector2.new(1,0)
                    boss[i].delay=0
                    boss[i].KnockBack = true
                end

                if playerAttack== true and playerWeapon.direction<0 and CheckCollision(playerWeapon.position.x-playerWeapon.size.x, playerWeapon.position.y, playerWeapon.size.x, playerWeapon.size.y,
                boss[i].position.x, boss[i].position.y, boss[i].size.x, boss[i].size.y)== true then
                    DamageEnemy(boss, playerWeapon.damage, i)
                    DamageWeapon(playerWeapon)
                    boss[i].KnockBackDirection = vector2.new(-1,0)
                    boss[i].delay=0
                    boss[i].KnockBack = true
                end
            end
    
                if boss[i].health<0 then
                    KillBoss(boss, i)
                end
                else
                    drawing= 100
                end
            end
        end
    end
    
    
    function DamageBoss(boss, damage, i)
        boss[i].health= boss[i].health- damage
        return boss[i].health
        end 
    
    function KillBoss(boss, i)
        table.remove(boss, i)
        return boss[i]
    end
    function GetWin(boss)
        if #boss == 2 then
            return true
        end
    end
    
    function BossAttack(boss, playerPos, dt, playerSize)
        if boss.position.x> playerPos.x then
            if boss.attackLength> -75 and boss.growing==true then
               boss.attackLength= boss.attackLength- boss.attSp*250*dt
            elseif boss.attackLength<= -75 then
                boss.growing=false
            end
            if boss.attackLength<0 and boss.growing==false then
                boss.attackLength= boss.attackLength+ boss.attSp*350*dt
            elseif boss.attackLength>= 0 then
                boss.growing= true
            end
        elseif boss.position.x< playerPos.x then
            if boss.attackLength< 75 and boss.growing==true then
                boss.attackLength= boss.attackLength+ boss.attSp*250*dt
            elseif boss.attackLength>= 75 then
                boss.growing=false
            end
            if boss.attackLength>0 and boss.growing==false then
                boss.attackLength= boss.attackLength- boss.attSp*350*dt
            elseif boss.attackLength<= 0 then
                boss.growing= true
            end
        end
    
        local bossweapon={
            position= vector2.new(0, 0),
            size= vector2.new(0, 0)
        }
    
        bossweapon.position.x=  boss.position.x+(boss.size.x/2)
        bossweapon.position.y=  boss.position.y+( boss.size.y/4)
        bossweapon.size.x=  boss.attackLength
        bossweapon.size.y= 10
        local player= {
            position= playerPos,
            size= playerSize
        }
        CheckBossWeaponCollision(bossweapon, player, boss)
    end
    
    function CheckBossWeaponCollision(bossweapon, player, boss)
    
        if CheckCollision(bossweapon.position.x, bossweapon.position.y, bossweapon.size.x, bossweapon.size.y, player.position.x, player.position.y, player.size.x, player.size.y)== true and bossweapon.size.x>0 then
            DamagePlayer(boss.damage)
    
        elseif bossweapon.size.x<0 then
            if CheckCollision(bossweapon.position.x+bossweapon.size.x, bossweapon.position.y, -bossweapon.size.x, bossweapon.size.y, player.position.x, player.position.y, player.size.x, player.size.y)== true then
                DamagePlayer(boss.damage)
                
            end
        end
    end