local pun = {}
function CreatePunch(x, y, w, h)
    return{position=vector2.new(x,y), size=vector2.new(w,h), attackSpeed= 0.75, damage=5, direction=0, attacking=false,
     grabbed=true,dropY= 0,cooldownTimer=0,cooldownDraw=0}
end 

function DrawPunch(punch)
      
    if punch.attacking== true then
    love.graphics.setColor(0, 1, 0.054)
    love.graphics.rectangle("fill", punch.position.x, punch.position.y-20, punch.direction*punch.size.x, punch.size.y)

    end
end


function UpdatePunch(punch,dt)

        if punch then  
        local Player_s = GetPlayerSize()
        local Player_p= GetPlayerPosition()

        if love.keyboard.isDown("right") then
            punch.direction= 1
        end 
        if love.keyboard.isDown("left") then
            punch.direction= -1
        end

        if punch.grabbed==true then
            punch.position.x=Player_p.x+Player_s.x/2
            punch.position.y=Player_p.y+Player_s.y/2
        end 
      
        punch.cooldownTimer=(punch.cooldownTimer + dt)
        
        if love.keyboard.isDown("v") and (punch.cooldownTimer>punch.attackSpeed)   then
            punch.attacking= true
            punch.cooldownDraw = punch.cooldownDraw +dt
            if punch.cooldownDraw > punch.attackSpeed/8 then
                punch.cooldownTimer = 0            
                punch.cooldownDraw = 0 
            end 
        else
        punch.attacking= false
        end
    end
    pun = punch  
end

function GetPunch()
    return pun 
end