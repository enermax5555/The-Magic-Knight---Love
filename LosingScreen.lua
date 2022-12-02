function gameStart()
  love.filesystem.load('game.lua')() love.load()
end

function quit()
  love.event.quit()
end

function menu()
  love.event.quit('restart')
  love.filesystem.load('main.lua')() love.load()
end

function love.load()
  pointer = love.mouse.getSystemCursor('hand')
  normalMouse = love.mouse.getSystemCursor('arrow')
  local menuFont = love.graphics.setNewFont(70)
  text = {}
  text.x = 85
  text.y = -80
  retryMbutton = {}
  retryMbutton.x = 475
  retryMbutton.y = 330
  exitMbutton = {}
  exitMbutton.x = 620
  exitMbutton.y = 535
  menuMbutton = {}
  menuMbutton.x = 320
  menuMbutton.y = 535
  losingScreen = love.graphics.newImage('LosingScreen.jpg')
  lScreen = love.graphics.newQuad(0, 0, 650, 600, 650, 600)
  youLose = love.graphics.newImage('YouLose.jpg')
  retryButton = love.graphics.newImage('RetryButton6.png')
  retryButtonQuad = love.graphics.newQuad(0, 0, 40, 40, 40, 40)
  exitButton = love.graphics.newImage('ExitButton.jpg')
  exitButtonQuad = love.graphics.newQuad(0, 35, 100, 30, 100, 100)
  menuButton = love.graphics.newImage('MenuButton.jpg')
  menuButtonQuad = love.graphics.newQuad(5, 35, 95, 30, 100, 100)
  losingSound = love.audio.newSource('GameOver.mp3', 'static')
  losingSound:setVolume(0.5)
  losingSound:play(losingSound)
end

function love.update(dt)
  PosX, PosY = love.mouse.getPosition()
  Hovering()
  text.y = text.y + 1 * dt * 100
    if text.y > 230 then
      text.y = 230
    end
end

function love.draw()
  local width = love.graphics.getWidth()
local height = love.graphics.getHeight()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(losingScreen, lScreen, 175, -40)
  love.graphics.setColor(255, 0, 0, 255)
  -- love.graphics.print('You Lose', text.x ,text.y)
  love.graphics.draw(youLose, text.x, text.y)
  love.graphics.setColor(255, 255, 255, 255)
  if text.y == 230 then
  love.graphics.draw(retryButton, retryButtonQuad, retryMbutton.x, retryMbutton.y)
  love.graphics.draw(exitButton, exitButtonQuad, exitMbutton.x, exitMbutton.y)
  love.graphics.draw(menuButton, menuButtonQuad, menuMbutton.x, menuMbutton.y)
  end
end

function love.mousepressed(x, y)
  if x > retryMbutton.x and x < retryMbutton.x + 40 and
     y > retryMbutton.y and y < retryMbutton.y + 40 then
       gameStart()
    end
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
  if PosX > retryMbutton.x and PosX < retryMbutton.x + 40 and
     PosY > retryMbutton.y and PosY < retryMbutton.y + 40 and
     text.y == 230 then
       love.mouse.setCursor(pointer)
  end
  if PosX > exitMbutton.x and PosX < exitMbutton.x + 100 and
     PosY > exitMbutton.y and PosY < exitMbutton.y + 30 and
     text.y == 230 then
       love.mouse.setCursor(pointer)
  end
  if PosX > menuMbutton.x and PosX < menuMbutton.x + 95 and
     PosY > menuMbutton.y and PosY < menuMbutton.y + 30 and
     text.y == 230 then
       love.mouse.setCursor(pointer)
     end
end
