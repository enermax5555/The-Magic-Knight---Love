function win()
  love.filesystem.load('VictoryScreen.lua')() love.load()

  if epicBossMelody:isPlaying() then
    epicBossMelody:stop()
  end
end
function lose()
  love.filesystem.load('LosingScreen.lua')() love.load()
  if epicBossMelody:isPlaying() then
    epicBossMelody:stop()
  end
end

local currentAttackFrame = 1
local characterFrames = {}
local characterWidth = 80
local characterHeigth = 100
local currentFrame = 1
local frameWidth = 80
local frameHeigth = 100
Quad = love.graphics.newQuad
local RunningFrames = {}
local characterTimePass = 0
local characterMaxTimePass = 1
local delayBool = false
local PlayerCanJump
local isInTheAir = false
local Attacks = {}
local SpellCD = 1
local Spell = false
local SpellRdy = 0
local sideCheck = true
local currentDragonStaticFrame = 1
local dragonStaticFrames = {}
local dragonTimer = 0
local dragonMaxTimer = 1
local dragonSmallAttackFrames = {}
local currentDragonSmallAttackFrame = 1
local dragonAttackCD = false
local dragonSmallAttackTimer = 0
local dragonSmallAttackMaxTimer = 15
local timer = 0
local maxTimer = 2
local fireBall = false
local dragonAttacks = {}
local dragonAttackSpeed = 400
local dragonDyingFrames = {}
local currentDragonDyingFrame = 1
local victoryDelay = 0
local victoryDelayMax = 5

function love.load()
  epicBossMelody = love.audio.newSource('BossBattle.mp3', 'stream')
  epicBossMelody:setVolume(0.3)
  epicBossMelody:play()
  characterHitted = love.audio.newSource('CharacterHitted.mp3', 'static')
  characterHitted:setVolume(0.2)
  dragonHitted = love.audio.newSource('MeteoriteHitSound.mp3', 'static')
  dragonHitted:setVolume(0.2)
  Background = love.graphics.newImage('BossBackGround.jpg')
  BackgroundQuad = Quad(0, 50, 1024, 820, Background:getDimensions())
  -- lolthefakisthis = love.graphics.newImage('Dragon.png')
  SomeUsefulSprites = love.graphics.newImage('SomeusefulspritesReworked.png')
  attackImg = Quad(330, 90, 60, 85, 1000, 1080)
  Hearth = love.graphics.newImage('Hearth.png')
  hearthQuad = Quad(0, 0, 40, 40, 40, 40)
  dragonFireBall = Quad(0, 0, 80, 80, 80, 80)
  love.mouse.setCursor(normalMouse)
  ---------- Boss --------------
  dragon = {}
  dragon.boss = love.graphics.newImage('Dragon.png')
  dragon.smallAttack = love.graphics.newImage('DragonSmallAttack.png')
  dragon.fireBall = love.graphics.newImage('smallDragonAttack.png')
  dragon.dying = love.graphics.newImage('DragonDying.png')
  dragon.x = 1000
  dragon.y = 415
  dragon.health = 250
  ----------- Player ------------------
    character = {}
    character.player = love.graphics.newImage('pngegg.png')
    character.GroundLevel = 530
    character.speed = 200
    character.dmg = 25
  ----------- Player Position ------------
    character.x = 100
    character.y = 530
    -- Player Hearths --
      lives = {}
      lives.c = 5
      lives.x = 0
    --------- Dragon Dying -----------
    for frame = 1, 5 do
      dragonDyingFrames[frame] = Quad((frame - 1) * 275, 0, 275, 250, 1400, 300)
    end
    --------- Dragon Small Attack -----------
    for frame = 1, 1 do
      dragonSmallAttackFrames[frame] = Quad(1100, 0, 275, 250, 1400, 300)
    end
    for frame = 2, 2 do
      dragonSmallAttackFrames[frame] = Quad(1100, 0, 275, 250, 1400, 300)
    end
    --------- Dragon Static state -----------
    for frame = 1, 2 do
      dragonStaticFrames[frame] = Quad((frame - 1) * 545, 0, 275, 250, 2000, 300)
    end
    for frame = 3, 3 do
      dragonStaticFrames[frame] = Quad(1110, 0, 275, 250, 2000, 300)
    end
    for frame = 4, 4 do
      dragonStaticFrames[frame] = Quad(1723, 0, 275, 250, 2000, 300)
    end
    --------Character running----------
      for frame = 1, 2 do
        RunningFrames[frame] = Quad((frame - 1) * frameWidth, 0,
        frameWidth, frameHeigth, character.player:getDimensions())
      end
    --------Character running----------
      for frame = 2, 4 do
        RunningFrames[frame] = Quad(((frame - 1) * frameWidth) + 10, 0,
        frameWidth, frameHeigth, character.player:getDimensions())
      end
    --------Moving Frames[4,6]----------
    --------Character running----------
      for frame = 4, 6 do
        RunningFrames[frame] = Quad(((frame - 1) * frameWidth) + 20, 0,
        frameWidth, frameHeigth, character.player:getDimensions())
      end
    --------Moving Frames[7,8]----------
    --------Up/Down Movement-----------
      for frame = 7, 8 do
        RunningFrames[frame] = Quad(((frame - 1) * frameWidth) - 485, 160,
        frameWidth, frameHeigth, character.player:getDimensions())
      end
      ------------Attack Movement--------
      for frame = 1, 4 do
        characterFrames[frame] = Quad((frame - 1) * characterWidth, 330,
        characterWidth, characterHeigth, 600, 636)
      end
      for frame = 5, 5 do
        characterFrames[frame] = Quad((frame - 1) * characterWidth + 10, 330,
        characterWidth, characterHeigth, 600, 636)
      end
      for frame = 6, 6 do
        characterFrames[frame] = Quad((frame - 1) * characterWidth + 20, 330,
        characterWidth, characterHeigth, 600, 636)
      end
end

local menuFont = love.graphics.setNewFont(70)

function love.update(dt)
love.mouse.setCursor(normalMouse)

  --------- Attack CD ----------
  if dragon.health <= 0 then
    victoryDelay = victoryDelay + 1 * dt * 12
    if victoryDelay > victoryDelayMax then
    win()
  end
  end
  if lives.c == 0 then
    lose()
  end

updateAttackSpell(dt)
updateDragonSmallAttack(dt)

  SpellRdy = SpellRdy + 1 * dt * 4
  if math.floor(SpellRdy) < SpellCD then
    Spell = false
  elseif math.floor(SpellRdy) == SpellCD then
    Spell = true
    SpellRdy = 0
end

  if character.y > character.GroundLevel then
    character.y = 530
  end

  SpawnDragonSmallAttack(dragon.x, dragon.y, dragonAttackSpeed)
  -- Attack spell only ground usable --
  if love.keyboard.isDown('k') and sideCheck then
  if character.y > 490 then
SpawnAttackSpell(character.x, character.y, attackSpeed)
 end
end
end

function updateDragonSmallAttack(dt)
  for i=table.getn(dragonAttacks), 1, -1 do
      dragonAttack = dragonAttacks[i]
      dragonAttack.x = dragonAttack.x - dt * dragonAttackSpeed

      if dragonAttack.x < 0 then
        table.remove(dragonAttacks, i)
      end

      if character.x - dragonAttack.x > -100 and PlayerCanJump and character.x - dragonAttack.x < 50 then
        lives.c = lives.c - 1


        characterHitted:play()
        if characterHitted:isPlaying() then
          characterHitted:stop()
          characterHitted:play()
        end
        table.remove(dragonAttacks, i)
      end
end

function SpawnDragonSmallAttack(x, y, speed)
  if fireBall and Spell then
    dragonAttack = {x = x - 200, y = y + 135, speed = speed}
    table.insert(dragonAttacks, dragonAttack)
  end
end
end

 function updateAttackSpell(dt)
 for i=table.getn(Attacks), 1, -1 do
     attack = Attacks[i]
     attack.x = attack.x + dt * 450
  if attack.x > (character.x + 300) then
    table.remove(Attacks, i)
  end

  if dragon.x - attack.x < 240 then
    dragonHitted:play()
    if dragonHitted:isPlaying() then
      dragonHitted:stop()
      dragonHitted:play()
    end

    dragon.health = dragon.health - character.dmg
    table.remove(Attacks, i)
  end
end

 function SpawnAttackSpell(x, y, speed)
   if Spell == true then
     attack = {x = x + 65, y = y + 15, speed = speed}
     table.insert(Attacks, attack)
 end
 end

  if character.y == 530 then
    PlayerCanJump = true
    isInTheAir = false
  else
    PlayerCanJump = false
  end

  if PlayerCanJump == true then
    if love.keyboard.isDown('space') then
      character.y = character.y - (5000 * dt)
      currentFrame = 7
    end
  end
  ---------- Air Boost --------
  if character.y < 530 then
    if love.keyboard.isDown('d') then
      character.x = character.x + 1 * dt * character.speed /2
    elseif love.keyboard.isDown('a') then
      character.x = character.x -1 * dt * character.speed /2
    end
  end
  ---------Something like gravity xD--------
if  character.y < character.GroundLevel then
    character.y = character.y + (250 * dt)
    isInTheAir = true
    currentFrame = 8
end

  function love.keypressed(key)
    if key == 'a' then
    if sideCheck then
    character.x = character.x + 100
  end
    sideCheck = false
  end
  if key == 'd' then
    if sideCheck == false then
    character.x = character.x - 100
  end
    sideCheck = true
  end
end

  function love.keyreleased(key)
    if key == 'a' then
      -- character.x = character.x - 100
    end
  end

  if love.keyboard.isDown('d') then
      character.x = character.x + 1 * dt * character.speed
    end

  if love.keyboard.isDown('a') then
    character.x = character.x - 1 * dt * character.speed
  end

  dragonSmallAttackTimer = dragonSmallAttackTimer + dt * 5
  if dragonSmallAttackTimer > dragonSmallAttackMaxTimer then
    dragonAttackCD = true
    dragonSmallAttackTimer = dragonSmallAttackTimer - dragonSmallAttackMaxTimer
    fireBall = true
  end

  if dragonAttackCD == true then
    timer = timer + dt * 10
    if timer > maxTimer then
      timer = timer - maxTimer
      dragonAttackCD = false
      fireBall = false
    end
  end

  dragonTimer = dragonTimer + dt * 6
  if dragonTimer > dragonMaxTimer then
  currentDragonStaticFrame = currentDragonStaticFrame + 1
  currentDragonSmallAttackFrame = currentDragonSmallAttackFrame + 1
  currentDragonDyingFrame = currentDragonDyingFrame + 1
  dragonTimer = dragonTimer - dragonMaxTimer
end
  if currentDragonDyingFrame > 5 then
    currentDragonDyingFrame = 1
  end

if currentDragonSmallAttackFrame > 2 then
  currentDragonSmallAttackFrame = 1
end
  if currentDragonStaticFrame > 4 then
    currentDragonStaticFrame = 1
  end


  characterTimePass = characterTimePass + dt * 8
  if characterTimePass > characterMaxTimePass then
    delayBool = true
    characterTimePass = characterTimePass - characterMaxTimePass
  else
    delayBool = false
  end
  if delayBool and isInTheAir == false then

    if love.keyboard.isDown('k') and not love.keyboard.isDown('d') and not love.keyboard.isDown('a') then
      currentAttackFrame = currentAttackFrame + 3
      if currentAttackFrame > 6 then
        currentAttackFrame = 1
      end
    end

    if love.keyboard.isDown('k') and love.keyboard.isDown('a') and not love.keyboard.isDown('d') then
      currentAttackFrame = currentAttackFrame + 1
      if currentAttackFrame > 6 then
        currentAttackFrame = 1
      end
    end

    if love.keyboard.isDown('k') and love.keyboard.isDown('d') then
      currentAttackFrame = currentAttackFrame + 1
      if currentAttackFrame > 6 then
        currentAttackFrame = 1
      end
    else
  if love.keyboard.isDown('d') or love.keyboard.isDown('a') then
    currentFrame = currentFrame + 1
    if currentFrame > 6 then
      currentFrame = 1
    end
  else
    currentFrame = currentFrame + 3
    if currentFrame > 4 then
      currentFrame = 1
    end

end
end
end
end

function love.draw()
  love.graphics.setColor(255, 255, 255, 255)
  -- love.graphics.draw(character.player, characterFrames[currentAttackFrame], 200, 200)
  love.graphics.draw(Background, BackgroundQuad, 0, 0)
  love.graphics.setColor(0, 255, 0, 255)
  for i = 1, dragon.health do
  love.graphics.rectangle("fill", dragon.x - 250, dragon.y, dragon.health - i ,15)
  end
  love.graphics.setColor(255, 255, 255, 255)
  if dragonAttackCD == false and dragon.health > 0 then
  love.graphics.draw(dragon.boss, dragonStaticFrames[currentDragonStaticFrame], dragon.x, dragon.y, 0, -1, 1)
elseif dragonAttackCD and fireBall then
  love.graphics.draw(dragon.smallAttack, dragonSmallAttackFrames[currentDragonSmallAttackFrame], dragon.x, dragon.y, 0, -1, 1)
else
  love.graphics.draw(dragon.dying, dragonDyingFrames[currentDragonDyingFrame], dragon.x, dragon.y, 0, -1, 1)
  end
  for i = 1, lives.c do
  love.graphics.draw(Hearth, hearthQuad, (lives.x + 40) * i, 30)
  end
  if love.keyboard.isDown('k') and PlayerCanJump == true and not love.keyboard.isDown('a') and love.keyboard.isDown('d') then
  love.graphics.draw(character.player, characterFrames[currentAttackFrame], character.x, character.y)
elseif love.keyboard.isDown('k') and love.keyboard.isDown('a') and PlayerCanJump == true and not love.keyboard.isDown('d') then
  love.graphics.draw(character.player, characterFrames[currentAttackFrame], character.x, character.y, 0, -1, 1)
elseif sideCheck then
  if love.keyboard.isDown('k') and not love.keyboard.isDown('a') and not love.keyboard.isDown('d') then
    love.graphics.draw(character.player, characterFrames[currentAttackFrame], character.x, character.y)
  else
    love.graphics.draw(character.player, RunningFrames[currentFrame], character.x, character.y)
  end
elseif sideCheck == false then
  if love.keyboard.isDown('k') and not love.keyboard.isDown('a') and not love.keyboard.isDown('d') then
    love.graphics.draw(character.player, characterFrames[currentAttackFrame], character.x, character.y, 0, -1, 1)
  else
    love.graphics.draw(character.player, RunningFrames[currentFrame], character.x, character.y, 0, -1, 1)
  end
elseif love.keyboard.isDown('k') and not love.keyboard.isDown('a') and not love.keyboard.isDown('d') and sideCheck then
  love.graphics.draw(character.player, characterFrames[currentAttackFrame], character.x, character.y)
end
  for index, dragonAttack in ipairs(dragonAttacks) do
    love.graphics.draw(dragon.fireBall, dragonFireBall, dragonAttack.x, dragonAttack.y, 0, -1, 1)
  end
  for index, attack in ipairs(Attacks) do
    love.graphics.draw(SomeUsefulSprites, attackImg, attack.x - 10, attack.y - 50)
  end

end
