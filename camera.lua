local camera = {}
camera.x = 0
camera.y = 0
camera.scaleX = 0.8
camera.scaleY = 0.8

function UpdateCamera()
local PlayerPOSI = GetPlayerPosition()
local camera = GetCameraPos()
local cameraRES = Getcamerareset()
if cameraRES == false then
  if PlayerPOSI.x > love.graphics.getWidth() / 2  then 
   camera.x = PlayerPOSI.x - love.graphics.getWidth() /2  
  end
  if PlayerPOSI.y > love.graphics.getHeight() / 2  then
   camera.y = PlayerPOSI.y - love.graphics.getHeight() / 2 
  end
  if camera.y > 200 then 
    camera.y = 200 
  end 
end
 if cameraRES == true then 
  camera.x = 50 
  camera.y = 500 - love.graphics.getHeight() / 2
  cameraRES = false 
  end
  
end

function GetCamera()
  return camera
end

function camera:set()
  love.graphics.push()
  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
  love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
  love.graphics.pop()
end

function camera:move(dx, dy)
  self.x = self.x + dx
  self.y = self.y + dy 
end

function camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function camera:setPosition(x,y)
  self.x = x or self.x
  self.y = y or self.y
end

function camera:setPositionX(x)
  self.x = x or self.x
end

function camera:setPositionY(y)
  self.y = y or self.y
end

function camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

function GetCameraPos()
  return camera
end