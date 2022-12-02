function gameStart()
  love.filesystem.load('game.lua')() love.load()
end

function bossLevel()
  love.filesystem.load('FirstBossLevel.lua')() love.load()
end
function prolog()
  love.filesystem.load('BossProlog.lua')() love.load()
end
function RealProlog()
  love.filesystem.load('TheRealProlog.lua')() love.load()
end

local menuFont = love.graphics.setNewFont(70)
local menuFonts = love.graphics.setNewFont(30)
local Quad = love.graphics.newQuad
local isHovered = false
local menuDifficult = false
local projectMbutton = false
local easyMbutton = false
local menuSoundBool = true
local menuVisability = true

function love.load()
  pointer = love.mouse.getSystemCursor('hand')
  normalMouse = love.mouse.getSystemCursor('arrow')
  startButton = {}
  startButton.x = 390
  startButton.y = 175
  easyButton = {}
  easyButton.x = 390
  easyButton.y = 300
  projectButton = {}
  projectButton.x = 390
  projectButton.y = 225
  backArrowButton = {}
  backArrowButton.x = 450
  backArrowButton.y = 520
  button = 'l'
  startMenuWallpaper = love.graphics.newImage('Assets/Images/StartMenuWallpaper.png')
  backArrow = love.graphics.newImage('Assets/Images/BackArrow.png')
  WallPaperQuad = Quad(0, 0, 1050, 820, 1050, 820)
  backArrowQuad = Quad(0, 0, 50, 50, 50, 50)
  menuMelody = love.audio.newSource('Assets/Sounds/IntroMelody.mp3', 'stream')
  menuMelody:setVolume(0.2)
  menuHoverSound = love.audio.newSource('Assets/Sounds/MenuSoundEffect.mp3', 'static')
  menuHoverSound:setVolume(0.1)
  selectMenu = love.audio.newSource('Assets/Sounds/SelectMenu.mp3', 'static')
  selectMenu:setVolume(0.2)

end

function love.update(dt)
  if menuVisability then
  menuMelody:play(menuMelody)
  if not menuMelody:isPlaying() then
    menuMelody:play(menuMelody)
  end
end
  PosX, PosY = love.mouse.getPosition()
  mouseHover()
  if menuSoundBool == false then
    menuSound()
  end

end

function love.draw()
  if menuVisability then
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(startMenuWallpaper, WallPaperQuad, 0, 0)
    love.graphics.print('The Magic Knight',menuFont, 200 ,50)

  if menuDifficult == false then
  if isHovered == false then
    love.graphics.rectangle('line', 390, 175, 180, 45)
    love.graphics.print('New Game', menuFonts, 400, 180)
  else
    love.graphics.rectangle('fill', 390, 175, 180, 45)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print('New Game', menuFonts, 400, 180)
  end

  else
    love.graphics.rectangle('line', 380, 210, 200, 300)
    love.graphics.draw(backArrow, backArrowQuad, 450, 520)
    love.graphics.print('Difficult:', menuFonts, 415, 170)
    for i = 1, 4 do
    love.graphics.rectangle('line', 390, (175 - 100) * i + 150, 180, 45)
    end
    if projectMbutton == false then
      love.graphics.setColor(255,255,255)
      love.graphics.print('Project', menuFonts, 400, 230)
    else
      love.graphics.rectangle('fill', 390, 225, 180, 45)
      love.graphics.setColor(0,0,0)
      love.graphics.print('Project', menuFonts, 400, 230)
    end
    if easyMbutton == true then
      love.graphics.rectangle('fill', 390, 300, 180, 45)
      love.graphics.setColor(0,0,0)
      love.graphics.print('Easy', menuFonts, 400, 305)
    else
      love.graphics.setColor(255,255,255)
      love.graphics.print('Easy', menuFonts, 400, 305)
    end

    love.graphics.setColor(255, 255, 255, 0.3)
    love.graphics.print('Normal', menuFonts, 400, 380)
    love.graphics.print('Hard', menuFonts, 400, 455)
end
  end
end

function mouseHover()

  love.mouse.setCursor(normalMouse)
if menuVisability then
  if PosX > startButton.x and PosX < startButton.x + 180 and
     PosY > startButton.y and PosY < startButton.y + 45 and menuDifficult == false then
       love.mouse.setCursor(pointer)
       isHovered = true
       menuSoundBool = true
  else
       menuSoundBool = false
       isHovered = false
  end

  if PosX > projectButton.x and PosX < projectButton.x + 180 and
     PosY > projectButton.y and PosY < projectButton.y + 45 and menuDifficult then
       projectMbutton = true
       love.mouse.setCursor(pointer)
       menuSoundBool = true
  else
       projectMbutton = false
  end

  if PosX > easyButton.x and PosX < easyButton.x + 180 and
     PosY > easyButton.y and PosY < easyButton.y + 45 and menuDifficult then
       love.mouse.setCursor(pointer)
       easyMbutton = true
       menuSoundBool = true
  else

       easyMbutton = false
  end
  if PosX > backArrowButton.x and PosX < backArrowButton.x + 50 and
     PosY > backArrowButton.y and PosY < backArrowButton.y + 50 and menuDifficult then
       love.mouse.setCursor(pointer)
     end
  end
end

function love.mousepressed(x, y, button)
  if menuVisability then
  if x > startButton.x  and x < startButton.x + 180 and
     y > startButton.y  and y < startButton.y + 45 then
       menuDifficult = true
       selectMenu:play()
  end
  if x > projectButton.x  and x < projectButton.x + 180 and
     y > projectButton.y  and y < projectButton.y + 45 and menuDifficult then
       gameStart()
       -- bossLevel()
       -- prolog()
       -- RealProlog()
       selectMenu:play()
       menuVisability = false
       menuMelody:stop()
     end
  if x > easyButton.x  and x < easyButton.x + 180 and
     y > easyButton.y  and y < easyButton.y + 45 and menuDifficult then
       gameStart()
       selectMenu:play()
       menuVisability = false
       menuMelody:stop()
     end
  if x > backArrowButton.x and x < backArrowButton.x + 50 and
     y > backArrowButton.y and y < backArrowButton.y + 50 and menuDifficult then
       menuDifficult = false
       selectMenu:play()
     end
   end
 end

function menuSound()
  menuHoverSound:play()
  if menuHoverSound:isPlaying() then
    menuHoverSound:stop()
    menuHoverSound:play()
  end
end
