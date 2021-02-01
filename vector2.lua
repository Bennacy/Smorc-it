vector2 = {}

function vector2.new(px, py)
    return {x = px, y = py}
end

function vector2.add(vec1, vec2)
    local result = vector2.new(0, 0)
    result.x = vec1.x + vec2.x
    result.y = vec1.y + vec2.y
    return result 
end

function vector2.mult(vec1, n)
    local result = vector2.new(0, 0)
    result.x = vec1.x * n
    result.y = vec1.y * n
    return result
end

function vector2.sub(vec1, vec2)
    local result = vector2.new(0, 0)
    result.x = vec1.x - vec2.x
    result.y = vec1.y - vec2.y
    return result
end 


function vector2.div(vec1, n)
    local result = vector2.new(0, 0)
    result.x = vec1.x / n
    result.y = vec1.y / n
    return result
end

function vector2.magnitude(vec1)
return math.sqrt(vec1.x * vec1.x + vec1.y * vec1.y)
end

function vector2.normalize(vec1)
    local mag = vector2.magnitude(vec1)
    if mag ~= 0 then 
    return vector2.div(vec1, mag)
    end
    return vec1 
end

function vector2.limit(vec1, max)
     local mag = vector2.magnitude(vec1)
     if (mag > max) then 
        local result = vector2.normalize(vec1)
        return vector2.mult(result, max)
     end
     return vec1 
    end

function vector2.applyForce(force, mass, acceleration)
     local f = vector2.div(force, mass)
     return vector2.add(acceleration, f)
 end

 function vector2.dot(vec1, vec2)
    return (vec1.x * vec2.x) + (vec1.y * vec2.y)
 end