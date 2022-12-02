function Boss()
love.filesystem.load('FirstBossLevel.lua')() love.load()
end
function RealProlog()
  love.filesystem.load('TheRealProlog.lua')() love.load()
end
function love.load()
  pointer = love.mouse.getSystemCursor('hand')
  normalMouse = love.mouse.getSystemCursor('arrow')
  dragon = {}
  dragon.img = love.graphics.newImage('DragonProlog.jpg')
  dragon.quad = love.graphics.newQuad(25, 0, 1100, 750, 1100, 750)
  dragon.x = 0
  dragon.y = 0
  dragon.loader = 0
  timer = 0
  timerMax = 1005
end
function love.update(dt)
  love.mouse.setCursor(normalMouse)
  timer = timer + dt * 100
  if timer > timerMax then
    RealProlog()
  end
end
function love.draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(dragon.img,dragon.quad, dragon.x, dragon.y)
  love.graphics.setColor(0, 255, 0, 255)
  for i = 1, timer do
  love.graphics.rectangle('fill', 10, 680, dragon.loader + i, 15)
  end
end
