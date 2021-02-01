function Linesinmap()
    for i = 1, 20, 1 do
        love.graphics.setColor(0,0.2,1)
        love.graphics.rectangle("fill",(100*i),340,50,340)
    end
end

function DrawTree()
    for i = 1, 5, 1 do
    love.graphics.setColor(0.345, 0.219, 0.054)
    love.graphics.rectangle("fill", 500*i, 200, 50, 140)

    love.graphics.setColor(0.007, 0.450, 0.050)
    love.graphics.circle("fill", 30 + i*500, 140, 80)
    end 
end   

function DrawClouds()
    for i = 10, 50, 10 do 
      love.graphics.setColor(1, 1, 1)
      love.graphics.circle("fill",i*70, 100,40)
      love.graphics.setColor(1, 1, 1)
      love.graphics.circle("fill", (i*70)-50, 100,40)
      love.graphics.setColor(1, 1, 1)
      love.graphics.circle("fill", (i*70)-100, 100, 40)
      love.graphics.setColor(1, 1, 1)
      love.graphics.circle("fill", (i*70)-150, 100, 40)
    end 
end
