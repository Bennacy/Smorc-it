require "player"


local wa = {}
local god = false
local playerWeapon


function CreateWeapon(x, y, w, h, t)
    local attackSpeed
    local damage
    local durability
    if t == 1 then
        attackSpeed= 0.75
        damage= 1.5
        durability = 100
    elseif t== 2 then
        attackSpeed=1
        damage = 3
        durability = 100
    end
    return{position=vector2.new(x,y), size=vector2.new(w,h), type= t, attSp= attackSpeed, damage=damage, direction=0, attacking=false,
     grabbed=false, dropped=false, dropY= 0, groundTimer= 0, durability=durability, cooldownTimer=0}
end

function DrawWeapon(weapons)
    for i=1, #weapons do

        if weapons[i].type== 0 then

            love.graphics.setColor(0, 1, 0.054)

        elseif weapons[i].type== 1 then  --light

            love.graphics.setColor(0.2, 0, 0.5)

        elseif weapons[i].type== 2 then  --heavy

            love.graphics.setColor(0.5, 0.5, 0)
        end
        
        if weapons[i]~= playerWeapon then
        love.graphics.rectangle("fill", weapons[i].position.x, weapons[i].position.y, weapons[i].size.x, weapons[i].size.y)
        end
    end
end


function UpdateWeapon(weapons,dt)
    playerWeapon= GetPlayerWeapon()
    for i=1, #weapons do
        if weapons[i] then
            if god == true then
                weapons[i].damage = 400
            end

            if weapons[i].durability <0 then
                BreakWeapon(weapons,i)
            end

            if love.keyboard.isDown("h") then
                god = true
            end
            local Player_s = GetPlayerSize()
            local Player_p= GetPlayerPosition()
            local colliding= CheckCollision(weapons[i].position.x, weapons[i].position.y, weapons[i].size.x, weapons[i].size.y,
            Player_p.x, Player_p.y, Player_s.x, Player_s.y)


            if colliding==true and love.keyboard.isDown("z") and playerWeapon == nil then
                weapons[i].groundTimer=0
                AssignWeapon(weapons, i)
            end

            
            if weapons[i]~= playerWeapon then
                weapons[i].groundTimer= weapons[i].groundTimer+dt
                if weapons[i].groundTimer> 7 then
                    table.remove(weapons, i)
                end
            end
        end
    end
    wa = weapons
end



function GetWeapons()
    return wa
end

function DropWeapon(type, position)
    local drop_weapon = GetWeapons()
    table.insert( drop_weapon, CreateWeapon(position.x, position.y, 65, 10, type))
end

function DamageWeapon(weapons,i)
    weapons[i].durability= weapons[i].durability- 0
    return weapons[i].durability
end

function BreakWeapon(weapons,i)
    table.remove(weapons,i)
end

function PickupWeapon(array)
    
end