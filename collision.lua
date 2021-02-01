


function GetBoxCollisionDirection(x1, y1, w1, h1, x2, y2, w2, h2)
    local xdist = math.abs((x1 + (w1 /2)) - (x2 + (w2 /2)))
    local ydist = math.abs((y1 + (h1 /2)) - (y2 + (h2 /2)))
    local combinedwidth = (w1 / 2) + (w2 / 2)
    local combinedheight = (h1 / 2) + (h2 / 2)
    if (xdist > combinedwidth) then
        return vector2.new(0, 0)
    end
    if (ydist > combinedheight) then
        return vector2.new(0, 0)
    end
    local overlapx = math.abs(xdist - combinedwidth)
    local overlapy = math.abs(ydist - combinedheight)
    local direction = vector2.normalize(vector2.sub(vector2.new(x1 + (w1/2), y1 + (h1/2)), 
                                        vector2.new(x2 + (w2/2), y2 + (h2/2))))
    local colisiondirection
    if overlapx > overlapy then
        colisiondirection = vector2.normalize(vector2.new(0, direction.y * overlapy))
    elseif overlapx < overlapy then
        colisiondirection = vector2.normalize(vector2.new(direction.x * overlapx, 0))
    else
        colisiondirection = vector2.normalize(vector2.new(direction.x * overlapx, direction.y * overlapy))
    end
    return colisiondirection
end



function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    local xdist = math.abs((x1 + (w1 /2)) - (x2 + (w2 /2)))
    local ydist = math.abs((y1 + (h1 /2)) - (y2 + (h2 /2)))
    local combinedwidth = (w1 / 2) + (w2 / 2)
    local combinedheight = (h1 / 2) + (h2 / 2)
    if xdist>combinedwidth then
        return false
    elseif ydist>combinedheight then
        return false
    else
        return true
    end
end

function CheckBoxCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end