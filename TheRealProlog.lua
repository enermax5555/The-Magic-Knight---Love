function Boss()
  love.filesystem.load('FirstBossLevel.lua')() love.load()
end
Quad = love.graphics.newQuad
local dialogStart = false
local skipMbutton = false
local nextMbutton = false
local counter = 1
local counterMax = 19
function love.load()
  font = love.graphics.setNewFont(30)
  pointer = love.mouse.getSystemCursor('hand')
  normalMouse = love.mouse.getSystemCursor('arrow')
  Background = love.graphics.newImage('Assets/Images/BossBackGround.jpg')
  BackgroundQuad = Quad(0, 50, 1024, 820, Background:getDimensions())
  knight = {}
  knight.img = love.graphics.newImage('Assets/Images/KnightProlog2.png')
  knight.imgQuad = Quad(0, 0, 300, 350, 300, 600)
  knight.x = -280
  knight.y = 130
  knight.speak = false
  dragon = {}
  dragon.img = love.graphics.newImage('Assets/Images/DragonProlog.png')
  dragon.imgQuad = Quad(10, 295, 500, 450, dragon.img:getDimensions())
  dragon.x = 1000
  dragon.y = 100
  dragon.need = false
  dragon.speak = false
  stranger = {}
  stranger.img = love.graphics.newImage('Assets/Images/MageProlog.png')
  stranger.need = true
  stranger.x = 2000
  stranger.y = 50
  stranger.speak = false
  skipButton = {}
  skipButton.x = 875
  skipButton.y = 520
  nextButton = {}
  nextButton.x = 875
  nextButton.y = 665
  love.mouse.setCursor(normalMouse)
  mode = {"Hello, who are u?", "I am mage, who travel in the time.", "What do u want?", "I am here to warn u!", "Warn me about what?", "About the dangerous drake, that comes for u!","Bring it on, it will be easy!", "Be aware, u took his gold, now he is angry.", "Thats how he supposed to be.", "O, no he is here.", "Cover ur self mage!","Ha-Ha-Ha are u the little knight?","I am the knight, yes!","You took something from me!","I don't think so.","So u want to die in agony?","Bring it on u little drake!", "Dieee in my flames scrub!","We see.."}
   currentIndex, currentMode = next(mode)
end
function love.update(dt)
  if counter >= 19 then
    Boss()
  end
  PosX, PosY = love.mouse.getPosition()
  Hover()
  if dragon.x > 550 then
    dragon.x = dragon.x - 1 * dt * 350
  end
  if stranger.x > 1250 then
    stranger.x = stranger.x - 1 * dt * 400
  end
  if knight.x < 280 then
    knight.x = knight.x + 1 * dt * 400
  end
  if knight.x >= 280 then
    if stranger.x <= 1250 or dragon.x <= 550 then
      dialogStart = true
    else
      dialogStart = false
    end
  end
  if counter == 11 then
    stranger.need = false
    dragon.need = true
    dragon.x = 1000
  end
end
function Hover()
  love.mouse.setCursor(normalMouse)
  if PosX > skipButton.x and PosX < skipButton.x + 100 and
     PosY > skipButton.y and PosY < skipButton.y + 35 then
       skipMbutton = true
       love.mouse.setCursor(pointer)
  else
       skipMbutton = false
  end
  if PosX > nextButton.x and PosX < nextButton.x + 100 and
     PosY > nextButton.y and PosY < nextButton.y + 35 then
       nextMbutton = true
       love.mouse.setCursor(pointer)
  else
       nextMbutton = false
  end
end
function love.mousepressed(x, y)
  if x > skipButton.x and x < skipButton.x + 100 and
     y > skipButton.y and y < skipButton.y + 35 then
       counter = counter + counterMax
  end
  if x > nextButton.x and x < nextButton.x + 100 and
     y > nextButton.y and y < nextButton.y + 35 then
       counter = counter + 1
       currentIndex, currentMode = next(mode, currentIndex)
  end
end
function love.draw()
  love.graphics.setFont(font)
  love.graphics.setColor(255, 255, 255, 1)
  love.graphics.draw(Background, BackgroundQuad, 0, 0)
  if dragon.need then
    if counter % 2 == 0 then
  love.graphics.setColor(255, 255, 255, 1)
  love.graphics.draw(dragon.img, dragon.imgQuad, dragon.x, dragon.y)
  else
  love.graphics.setColor(255, 255, 255, 0.5)
  love.graphics.draw(dragon.img, dragon.imgQuad, dragon.x, dragon.y)
end
end
if stranger.need then
  if counter % 2 == 0 then
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(stranger.img, stranger.x, stranger.y, 0, -1, 1)
  else
  love.graphics.setColor(255, 255, 255, 0.5)
  love.graphics.draw(stranger.img, stranger.x, stranger.y, 0, -1, 1)
end
end
  love.graphics.setColor(255, 255, 255, 255)
  if counter % 2 == 1 then
  love.graphics.draw(knight.img, knight.imgQuad, knight.x, knight.y, 0, -1, 1)
  else
  love.graphics.setColor(255, 255, 255, 0.5)
  love.graphics.draw(knight.img, knight.imgQuad, knight.x, knight.y, 0, -1, 1)
  end

  if dialogStart then
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(currentMode, 50, 520)
    if skipMbutton == false then
    love.graphics.print('Skip', 894, 520)
    love.graphics.rectangle('line', 875, 520, 100, 35)
    else
    love.graphics.rectangle('fill', 875, 520, 100, 35)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print('Skip', 894, 520)
    end
    love.graphics.setColor(255, 255, 255, 255)
    if nextMbutton == false then
    love.graphics.print('Next', 890, 665)
    love.graphics.rectangle('line', 875, 665, 100, 35)
    else
      love.graphics.rectangle('fill', 875, 665, 100, 35)
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.print('Next', 890, 665)
    end
    love.graphics.setColor(0,0,0, 0.5)

  round_rectangle(20, 500, 982, 220, 15)
  end
end

function round_rectangle(x, y, width, height, radius)
love.graphics.rectangle("line", x + radius, y + radius, width - (radius * 2), height - radius * 2)
love.graphics.rectangle("fill", x + radius, y + 8.9, width - (radius * 2), radius - 10)
	love.graphics.rectangle("fill", x + radius, y + height - radius, width - (radius * 2), radius - 10)
	love.graphics.rectangle("fill", x + 10, y + radius, radius - 10, height - (radius * 2))
	love.graphics.rectangle("fill", x + (width - radius), y + radius, radius - 10, height - (radius * 2))
  --
  --
	love.graphics.arc("fill", x + radius, y + radius, radius - 5, math.rad(-180), math.rad(-90))
	love.graphics.arc("fill", x + width - radius , y + radius, radius - 5, math.rad(-90), math.rad(0))
	love.graphics.arc("fill", x + radius, y + height - radius, radius - 5, math.rad(-180), math.rad(-270))
	love.graphics.arc("fill", x + width - radius , y + height - radius, radius - 5, math.rad(0), math.rad(90))
end
