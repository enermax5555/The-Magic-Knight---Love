function quit()
  love.event.quit()
end

function menu()
  love.event.quit('restart')
  love.filesystem.load('main.lua')() love.load()
end
love.audio.setVolume(0.7)
function love.load()
  pointer = love.mouse.getSystemCursor('hand')
  normalMouse = love.mouse.getSystemCursor('arrow')
  exitMbutton = {}
  exitMbutton.x = 925
  exitMbutton.y = 680
  menuMbutton = {}
  menuMbutton.x = 10
  menuMbutton.y = 680
  victory = {}
  victory.music = love.audio.newSource('Victory.mp3', 'stream')
  victory.music:play()
  victory.img = love.graphics.newImage('victory2.jpg')
  victory.x = 0
  victory.y = -1000
  g = love.graphics.getHeight()
  gg = love.graphics.getWidth()
  victory.quad = love.graphics.newQuad(190, 100, 1100, 1000, 1400, 1200)
  exitButton = love.graphics.newImage('ExitButton.jpg')
  exitButtonQuad = love.graphics.newQuad(6, 35, 89, 30, 100, 100)
  menuButton = love.graphics.newImage('MenuButton.jpg')
  menuButtonQuad = love.graphics.newQuad(6, 36, 89, 29, 100, 100)
end
function love.update(dt)
  PosX, PosY = love.mouse.getPosition()
  Hovering()

  victory.y = victory.y + 1 * dt * 300
  if victory.y > -100 then
    victory.y = -100
  end
end
function love.draw()
  love.graphics.draw(victory.img, victory.quad, victory.x, victory.y)
  if victory.y > -110 then
  love.graphics.draw(exitButton, exitButtonQuad, exitMbutton.x, exitMbutton.y)
  love.graphics.draw(menuButton, menuButtonQuad, menuMbutton.x, menuMbutton.y)
  end
end

function love.mousepressed(x, y)
  if x > exitMbutton.x and x < exitMbutton.x + 100 and
     y > exitMbutton.y and y < exitMbutton.y + 30 then
       quit()
     end
  if x > menuMbutton.x and x < menuMbutton.x + 100 and
     y > menuMbutton.y and y < menuMbutton.y + 30 then
       menu()
     end
end

function Hovering()
  love.mouse.setCursor(normalMouse)
  if PosX > exitMbutton.x and PosX < exitMbutton.x + 100 and
     PosY > exitMbutton.y and PosY < exitMbutton.y + 30 and
     victory.y > -110 then
       love.mouse.setCursor(pointer)
  end
  if PosX > menuMbutton.x and PosX < menuMbutton.x + 95 and
     PosY > menuMbutton.y and PosY < menuMbutton.y + 30 and
     victory.y > -110 then
       love.mouse.setCursor(pointer)
     end
end
