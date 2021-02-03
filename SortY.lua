local sortedEntities= {}


-- 1=enemy, 2=boss
function Sort(enemies, boss)
    sortedEntities= {}
    for i=1, #enemies do
        if enemies[i] then
            sortedEntities[i]= enemies[i]
        end
    end


    for i=1, #boss do
        if boss[i] then
            sortedEntities[#sortedEntities+1]= boss[i]
        end
    end

    table.sort(sortedEntities, SortFunc)
end

function SortedDraw(playerY)
    local playerDrawn= false
    for i=1, #sortedEntities do
        if playerDrawn== false and playerY<sortedEntities[i].position.y then
            DrawPlayer()
            playerDrawn= true
        end
        if sortedEntities[i].eType== 1 then
            DrawEnemy(sortedEntities[i])
        else
            DrawBoss(sortedEntities[i])
        end
    end
    if playerDrawn== false then
        DrawPlayer()
    end
end

function SortFunc(a, b)
    return a.position.y< b.position.y
end