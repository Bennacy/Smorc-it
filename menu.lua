function Colorir(x,y,z,v)
    return x,y,z,v
    
end
function NewButton(text, fn)
    return{text = text, fn = fn,now = false,last = false}
end

function DrawMenu(Buttons,font)   

local ww = love.graphics.getWidth()
local wh = love.graphics.getHeight()
local ButtonWidth = ww* (1/3)
local ButtonHeight = 64
local margin = 16 
local TotalHeight = (ButtonHeight + margin) * #Buttons
local CurrentButtonY = 0
for i, Buttons in ipairs(Buttons) do 
 Buttons.last = Buttons.now

local bx = (ww * 0.5) - (ButtonWidth * 0.5)
local by = (wh*0.5) - (TotalHeight * 0.5) + CurrentButtonY

local color = {0.4,0.4,0.45,0.5}
local mx, my = love.mouse.getPosition()
local over = mx > bx and mx < bx  + ButtonWidth and my > by and my < by +ButtonHeight
if over then 
    color = {0.8,0.8,0.9,1.0}
end 
Buttons.now = love.mouse.isDown(1) 
if Buttons.now and not Buttons.last and over then 
    Buttons.fn()
end 
love.graphics.setColor(Colorir(color))
love.graphics.rectangle("fill", bx, by,ButtonWidth,ButtonHeight)
love.graphics.setColor(0,0,0,1)
local textW = font:getWidth(Buttons.text)
local textH = font:getHeight(Buttons.text)
love.graphics.print(Buttons.text,font,(ww * 0.5) - (textW*0.5),by + (textH *0.5))                
CurrentButtonY  = CurrentButtonY + (ButtonHeight + margin )
end
end
function DrawMenuBAck()
    love.graphics.setColor(0.062, 0.537, 0.215)
    love.graphics.rectangle("fill",0,0,800,600)
    love.graphics.setColor(0.058, 0.062, 0.058)
    love.graphics.setLineWidth(25)
    love.graphics.rectangle("line",0,0,800,600)
    love.graphics.setLineWidth(2)
end
function DrawEnd(Respawn,font)   

    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight() 
    local ButtonWidth = ww* (1/3)
    local ButtonHeight = 64
    local margin = 16 
    local TotalHeight = (ButtonHeight + margin) * #Respawn
    local CurrentButtonY = 0
    for i, Respawn in ipairs(Respawn) do 
     Respawn.last = Respawn.now
    
    local bx = (ww * 0.5) - (ButtonWidth * 0.5)
    local by = (wh*0.5 + 120) - (TotalHeight * 0.5) + CurrentButtonY
    
    local color = {0.4,0.4,0.45,0.5}
    local mx, my = love.mouse.getPosition()
    local over = mx > bx and mx < bx  + ButtonWidth and my > by and my < by +ButtonHeight
    if over then 
        color = {0.8,0.8,0.9,1.0}
    end 
    Respawn.now = love.mouse.isDown(1) 
    if Respawn.now and not Respawn.last and over then 
        Respawn.fn()
    end 
    love.graphics.setColor(Colorir(color))
    love.graphics.rectangle("fill", bx, by,ButtonWidth,ButtonHeight)
    love.graphics.setColor(0,0,0,1)
    local textW = font:getWidth(Respawn.text)
    local textH = font:getHeight(Respawn.text)
    love.graphics.print(Respawn.text,font,(ww * 0.5) - (textW*0.5),by + (textH *0.5))                
    CurrentButtonY  = CurrentButtonY + (ButtonHeight + margin )
    end
    end

    function DrawEndBAck(Dead)
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("fill",0,0,1000,1000)
        love.graphics.draw(Dead,230,love.graphics.getHeight()/2,0,0.5,0.5,0,Dead:getHeight()/2)
    end

    function DrawWinBAck(Win)
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill",0,0,1000,1000)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(Win,230,love.graphics.getHeight()/2,0,0.5,0.5,0,Win:getHeight()/2)
    end

    function DrawWin(WinB,font)   

        local ww = love.graphics.getWidth()
        local wh = love.graphics.getHeight() 
        local ButtonWidth = ww* (1/3)
        local ButtonHeight = 64
        local margin = 16 
        local TotalHeight = (ButtonHeight + margin) * #WinB
        local CurrentButtonY = 0
        for i, WinB in ipairs(WinB) do 
         WinB.last = WinB.now
        
        local bx = (ww * 0.5) - (ButtonWidth * 0.5)
        local by = (wh*0.5 + 120) - (TotalHeight * 0.5) + CurrentButtonY
        
        local color = {0.4,0.4,0.45,0.5}
        local mx, my = love.mouse.getPosition()
        local over = mx > bx and mx < bx  + ButtonWidth and my > by and my < by +ButtonHeight
        if over then 
            color = {0.8,0.8,0.9,1.0}
        end 
        WinB.now = love.mouse.isDown(1) 
        if WinB.now and not WinB.last and over then 
            WinB.fn()
        end 
        love.graphics.setColor(Colorir(color))
        love.graphics.rectangle("fill", bx, by,ButtonWidth,ButtonHeight)
        love.graphics.setColor(0,0,0,1)
        local textW = font:getWidth(WinB.text)
        local textH = font:getHeight(WinB.text)
        love.graphics.print(WinB.text,font,(ww * 0.5) - (textW*0.5),by + (textH *0.5))                
        CurrentButtonY  = CurrentButtonY + (ButtonHeight + margin )
        end
        end