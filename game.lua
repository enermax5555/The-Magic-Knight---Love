-------- Loading screen ---------
function BossProlog()
  love.filesystem.load('BossProlog.lua')() love.load()
end
-------- Load Boss Level ---------
function Boss()
  love.filesystem.load('FirstBossLevel.lua')() love.load()
  if music:isPlaying() then
  music:stop(music)
end
end
-------- Load Losing Screen ---------
function Lose()
  love.filesystem.load('LosingScreen.lua')() love.load()
  if music:isPlaying() then
    music:stop(music)
  end
end
----------Some Local Veriables----------
----------Should be FIXED!!!---------
local grass
local girl
local subImage
local allImages
local Quad = love.graphics.newQuad
local frameWidth = 80
local frameHeigth = 100
local characterWidth = 80
local characterHeigth = 100
local angelWidth = 50
local angelHeigth = 70
local angelFrames = {}
local currentAngelFrame = 1
local angelTime = 0
local angelDesiredTime = 0.15
local needAngel = false
local totalNumberOfFrames = 6
local currentFrame = 1
local currentAttackFrame = 1
local characterFrames = {}
local AttackDelay = 0.15
local timePassedSinceLastAttackFrame = 0
local desiredDelayBetweenFrameChanges = 0.15
local timePassedSinceLastFrameChange = 0
local desiredDelayBetweenFrameChangesCoin = 0.15
local timePassedSinceLastFrameChangeCoin = 0
local desiredDelayBetweenFrameChangesMeteorite = 0.15
local timePassedSinceLastFrameChangeMeteorite = 0
local desiredDelayBetweenFrameChangesBomb = 0.15
local timePassedSinceLastFrameChangeBomb = 0
local desiredDelayBetweenFrameChangesExplosion = 0.20
local timePassedSinceLastFrameChangeExplosion = 0
local MeteoriteExplosionDelay = 0.15
local MeteoriteExplosionDelayPassed = 0
local bombExplosionDelay = 0.50
local bombExplosionDelayPassed = 0
local msgTimer = 0
local msgMaxTimer = 1
local losingTimer = 0
local losingTimerReach = 5
local workerFrames = {}
local PlayerCanJump = false
local coinWidth = 40
local coinHeigth = 100
local coinFrames = {}
local currentcoinFrame = 1
local currentMeteoriteFrame = 1
local meteoriteWidth = 180
local meteoriteHeight = 180
local meteoriteFrames = {}
local bombFrames = {}
local bombWidth = 60
local bombHeight = 50
local bombExplosionFrames = {}
local currentBombExplosionFrame = 1
local currentBombFrame = 1
local characterPosition
local coinCounter = 0
local cloud1move = {}
local cloud2move = {}
local cloud3move = {}
local cloud4move = {}
local font = love.graphics.newFont(40)
local timerFont = love.graphics.newFont(70)
local Attacks = {}
local SpellCD = 1
local Spell = false
local SpellRdy = 0
local hearthX = 20
local hearthWidth = 50
local attackMaxSpeed = 300
local attackSpeed = 50
local Hearths = {}
local ImprovedAttack = false
local stopTheGame = false
local resumeGame = false
local isHovered = false
local resumeMbutton = false
local restartMbutton = false
local quitMbutton = false
local stopTheGameTimer = 0
local stopTheGameMaxTimer = 31
local stopTheGameSwitch = false
local timerHide = false

function love.load()

----------- Mouse Settings ----------
pointer = love.mouse.getSystemCursor('hand')
normalMouse = love.mouse.getSystemCursor('arrow')

----------- Get Screen Dimensions ------------
  ScreenWidth = love.graphics.getWidth()
  ScreenHeight = love.graphics.getHeight()
----------- Sound Area ------------
  music = love.audio.newSource('GameMusic.mp3', 'stream')
  music:setVolume(0.05)
  meteoriteSound = love.audio.newSource('MeteoriteOld.wav', 'static')
  meteoriteSound:setVolume(0.2)
  bombSound = love.audio.newSource('Bomb.wav', 'static')
  bombSound:setVolume(0.1)
  coinSound = love.audio.newSource('CoinOld.wav', 'static')
  coinSound:setVolume(0.2)
  buffsSound = love.audio.newSource('BuffSound.mp3', 'static')
  buffsSound:setVolume(0.2)
  meteoriteHitted = love.audio.newSource('MeteoriteHitSound.mp3', 'static')
  meteoriteHitted:setVolume(0.1)
  characterHitted = love.audio.newSource('CharacterHitted.mp3', 'static')
  characterHitted:setVolume(0.3)
  dyingMelody = love.audio.newSource('Dying.mp3', 'static')
  dyingMelody:setVolume(0.3)
----------- Fonts -----------
  love.graphics.setFont(font)
----------- Terrain Loader ----------
  sky = love.graphics.newImage('SkyBackGroundCloudSync.png')
  grassGroundLevel = love.graphics.newImage('SampleGrassBlock.png')
  cloud1move.obj = love.graphics.newImage('CloudSource.png')
  Hearth = love.graphics.newImage('Hearth.png')
  SomeUsefulSprites = love.graphics.newImage('SomeusefulspritesReworked.png')
  Buffs = love.graphics.newImage('BuffImage.jpg')
  sBuffs = love.graphics.newImage('SpeedBuff.jpg')
  pauseIcon = love.graphics.newImage('PauseGameIcon.png')

----------- Objectives ------------
-- Pause Button --
pauseButton = {}
pauseButton.x = 963
pauseButton.y = 90
-- Resume Button --
resumeButton = {}
resumeButton.x = ScreenWidth/2 - 82
resumeButton.y = ScreenHeight/2 - 202
-- Restart Button --
restartButton = {}
restartButton.x = ScreenWidth/2 - 82
restartButton.y = ScreenHeight/2 - 142
-- Quit Button --
quitButton = {}
quitButton.x = ScreenWidth/2 - 82
quitButton.y = ScreenHeight/2 - 82
----------- Buffs --------------
-- Attack Buff --
aBuff = {}
aBuff.x = 7500
aBuff.y = 370
-- Attack Buff Text --
aBuffText = {}
aBuffText.x = 10000
aBuffText.y = 250
-- Speed Buff --
sBuff = {}
sBuff.x = 4400
sBuff.y = 370
-- Speed Buff Text --
sBuffText = {}
sBuffText.x = 10000
sBuffText.y = 250
-- Player Hearths --
  lives = {}
  lives.c = 5
  lives.x = 0
-- Angle --
angel = {}
angel.obj = love.graphics.newImage('Creatures.png')
angel.x = 0
angel.y = 400
-- Coins --
  coin = {}
  coin.obj = love.graphics.newImage('coin.png')
  coin.x = love.math.random(1000, 1400)
  coin.y = 365
-- Meteorite --
  meteorite = {}
  meteorite.health = 100
  meteorite.obj = love.graphics.newImage('Meteorite.png')
  meteorite.x = love.math.random(1000, 1400)
  meteorite.y = 330
  MeteoriteExplosions = {}
  MeteoriteExplosions.x = 2000
  MeteoriteExplosions.y = 200
-- Bomb --
  bomb = {}
  bomb.obj = love.graphics.newImage('NormalBombNewReworked.png')
  bomb.x = love.math.random(1000, 3000)
  bomb.y = 470
  bombExplosion = {}
  bombExplosion.x = 2000
  bombExplosion.y = 350
----------- Player ------------------
  character = {}
  character.player = love.graphics.newImage('pngegg.png')
  character.GroundLevel = 415
  character.speed = 200
----------- Player Position ------------
  character.x = 100
  character.y = 415
----------- Different Required Img Quads -----------
hearth = Quad(0, 0, 40, 40, 40, 40)
skybackground = Quad(0, 0, 10000, 1000, 32, 32)
staticCoin = Quad(0, 0, 50, 100, 300, 70)
subImage = Quad(0, 0, 10000, 1000, 32, 32)
allImages = Quad(0, 60,1000, 170, 400, 500)
attackImg = Quad(330, 90, 60, 85, 1000, 1080)
ImprovedAttackImg = Quad(565, 105, 80, 85, 1000, 1000)
MeteoriteExplosion = Quad(0, 60,1000, 170, 400, 500)
AttackBuff = Quad(50, 17, 27, 30, 180, 120)
SpeedBuff = Quad(0, 0, 29, 30, 29, 30)
PauseGame = Quad(0,0, 29, 30, 29, 30)
Angle = Quad(1616, 5, 195, 70, 4000, 3000)
--------Clouds Pos/Spawn/Loc etc----------
cloud1 = Quad(0, 40, 120, 50, 700, 600)
cloud1move.x = love.math.random(850, 1050)
cloud1move.y = love.math.random(5, 300)
cloud2 = Quad(250, 40, 120, 50, 700, 600)
cloud2move.x = love.math.random(1200, 1250)
cloud2move.y = love.math.random(5, 300)
cloud3move.x = love.math.random(1400, 1450)
cloud3move.y = love.math.random(5, 300)
cloud4move.x = love.math.random(1650, 1700)
cloud4move.y = love.math.random(5, 300)
---------NEED FIX WITH FAKING CLOUDS----------
-- cloud3 = Quad(370, 140, 100, 60, 700, 600)
  for frame = 1, 2 do
    bombExplosionFrames[frame] = Quad((frame - 1) * 71, 335, 71, 85, 350, 550)
  end
----------AngelFlying----------
----------Angel Frames[1,2]----------
  for frame = 1, 2 do
    angelFrames[frame] = Quad((frame - 1) * angelWidth + 1616, 5, angelWidth, angelHeigth, 4000, 3000)
  end
----------Angel Frames[2,4]-----------
  for frame = 2, 4 do
    angelFrames[frame] = Quad((frame - 1) * 49.05 + 1616, 5, angelWidth, angelHeigth, 4000, 3000)
  end
---------Moving Frames[1,2]---------
--------Character running----------
  for frame = 1, 2 do
    workerFrames[frame] = Quad((frame - 1) * frameWidth, 0,
    frameWidth, frameHeigth, character.player:getDimensions())
  end
---------Moving Frames[2,4]----------
--------Character running----------
  for frame = 2, 4 do
    workerFrames[frame] = Quad(((frame - 1) * frameWidth) + 10, 0,
    frameWidth, frameHeigth, character.player:getDimensions())
  end
--------Moving Frames[4,6]----------
--------Character running----------
  for frame = 4, 6 do
    workerFrames[frame] = Quad(((frame - 1) * frameWidth) + 20, 0,
    frameWidth, frameHeigth, character.player:getDimensions())
  end
--------Moving Frames[7,8]----------
--------Up/Down Movement-----------
  for frame = 7, 8 do
    workerFrames[frame] = Quad(((frame - 1) * frameWidth) - 485, 160,
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
------------Coin Rotation----------
  for frame = 1, 6 do
    coinFrames[frame] = Quad((frame - 1) * coinWidth, 0,
    coinWidth, coinHeigth, coin.obj:getDimensions())
  end
---------- Meteor Rotation ---------
  for frame = 1, 9 do
    meteoriteFrames[frame] = Quad((frame - 1) * meteoriteWidth, 0,
    meteoriteWidth, meteoriteHeight, meteorite.obj:getDimensions())
  end
--------- Bomb Rotation ----------
  for frame = 1, 2 do
    bombFrames[frame] = Quad((frame - 1) * bombWidth, 0,
    bombWidth, bombHeight, 350, 400)
  end
  love.audio.play(music)

end
function love.update(dt)
------- Stop Intro Melody --------
  menuMelody:stop(menuMelody)
---------- Some Seconds Delay before Unpausing the Game ----------
  if stopTheGameSwitch == true then
    stopTheGameTimer = stopTheGameTimer + 1 * dt * 10
    if stopTheGameTimer > stopTheGameMaxTimer then
      stopTheGame = false
      stopTheGameSwitch = false
      stopTheGameTimer = stopTheGameTimer - stopTheGameMaxTimer
    end
  end
  --------- Mouse Controll ----------
  MousePosX, MousePosY = love.mouse.getPosition()
  if MousePosX > pauseButton.x and MousePosX < pauseButton.x + 30 and
     MousePosY > pauseButton.y and MousePosY < pauseButton.y + 30 then
       love.mouse.setCursor(pointer)
  else
       love.mouse.setCursor(normalMouse)
  end
  if MousePosX > resumeButton.x and MousePosX < resumeButton.x + 168 and
     MousePosY > resumeButton.y and MousePosY < resumeButton.y + 50 then
       isHovered = true
       resumeMbutton = true
       mouseStyleOnHover()
  else
    resumeMbutton = false
  end
  if MousePosX > restartButton.x and MousePosX < restartButton.x + 168 and
     MousePosY > restartButton.y and MousePosY < restartButton.y + 50 then
       isHovered = true
       restartMbutton = true
       mouseStyleOnHover()
  else
    restartMbutton = false
  end
  if MousePosX > quitButton.x and MousePosX < quitButton.x + 168 and
     MousePosY > quitButton.y and MousePosY < quitButton.y + 50 then
       isHovered = true
       quitMbutton = true
       mouseStyleOnHover()
  else
    quitMbutton = false
  end
--------- Losing the game -----------
if lives.c <= 0 then
  music:stop(music)
stopTheGame = true
losingTimer = losingTimer + 1 * dt * 5
timerHide = true
angel.y = angel.y - 1 * dt * 150
angel.x = 0
angel.x = angel.x + character.x + 15
character.y = 415
if character.x < 10 then
  character.x = 10
end
needAngel = true

love.mouse.setCursor(normalMouse)
dyingMelody:play(dyingMelody)
-- if losingTimer > losingTimerReach then
--    Lose()
--  end
if angel.y < 100 then
  Lose()
end
end
--------- Boss Level the game -----------
  if coinCounter > 9 then
    music:stop(music)
    BossProlog()
  end

  if love.keyboard.isDown('o') then
    love.event.quit('restart')
    love.filesystem.load('main.lua')() love.load()
  end
  -- if not music:isPlaying() then
  --   love.audio.play(music)
  -- end
  --------- Attack CD ----------
updateAttackSpell(dt)
  SpellRdy = SpellRdy + 1 * dt * 4
  if math.floor(SpellRdy) < SpellCD then
    Spell = false
  elseif math.floor(SpellRdy) == SpellCD then
    Spell = true
    SpellRdy = 0
end
------------ Angel Animation ------------
angelTime = angelTime + dt
if angelTime > angelDesiredTime then
  currentAngelFrame = currentAngelFrame + 1
  angelTime = angelTime - angelDesiredTime
  if currentAngelFrame > 4 then
    currentAngelFrame = 1
  end
end
------- Pause the game --------
if stopTheGame == false then
  ----------Screen Edge-------
  if character.x > 1024 then
    character.x = 1024
  end
  if character.x < 0 then
    character.x = 0
  end
  ----------Ground Level--------
  if character.y > character.GroundLevel then
    character.y = 415
  end
  ------------Jump-----------
  if character.y == 415 then
    PlayerCanJump = true
  else
    PlayerCanJump = false
  end
  if PlayerCanJump == true then
    if love.keyboard.isDown('space') then
      character.y = character.y - (5000 * dt)
      currentFrame = 7
    end

  end
  ----------Move Forward in the Air--------
  if character.y < 415 then
    if love.keyboard.isDown('d') then
      character.x = character.x + 1 * dt * character.speed
    end
  end
  ---------Something like gravity xD--------
if (character.y < character.GroundLevel) then
    character.y = character.y + (250 * dt)
    currentFrame = 8
end
  ----------Moving Right--------
  if character.y == 415 then
  if love.keyboard.isDown('d') then
    character.x = character.x + 1 * dt * character.speed
end
end
-- Shooting animation --
if love.keyboard.isDown('k') then
  timePassedSinceLastAttackFrame = timePassedSinceLastAttackFrame + dt
  if timePassedSinceLastAttackFrame > AttackDelay then
    timePassedSinceLastAttackFrame = timePassedSinceLastAttackFrame -
    AttackDelay
    currentAttackFrame = currentAttackFrame + 1
    if currentAttackFrame > 6 then
      currentAttackFrame = 1
    end
  end
  -- Attack spell only ground usable --
  if character.y > 410 then
SpawnAttackSpell(character.x, character.y, attackSpeed)
 end
elseif PlayerCanJump == true then
timePassedSinceLastFrameChange = timePassedSinceLastFrameChange + dt
  if timePassedSinceLastFrameChange > desiredDelayBetweenFrameChanges then
  timePassedSinceLastFrameChange = timePassedSinceLastFrameChange -
  desiredDelayBetweenFrameChanges
  currentFrame = currentFrame + 1
  if currentFrame > 6 then
    currentFrame = 1
  end
  end
  end

  ------------ Moving Left ------------
  if love.keyboard.isDown('a') then
    character.x = character.x - 1 * dt * character.speed
  end
  ------------Coin Animation--------
  timePassedSinceLastFrameChangeCoin = timePassedSinceLastFrameChangeCoin + dt
    if timePassedSinceLastFrameChangeCoin > desiredDelayBetweenFrameChangesCoin then
      timePassedSinceLastFrameChangeCoin = timePassedSinceLastFrameChangeCoin -
      desiredDelayBetweenFrameChangesCoin
      currentcoinFrame = currentcoinFrame + 1
      if currentcoinFrame > 6 then
        currentcoinFrame = 1
      end
    end
      coin.x = coin.x - 1 * dt * 200
      -- Coin Jump Tick --
      coin.y = coin.y + 1 * dt * 20
      if coin.y > 380 then
        coin.y = 365
      end

      -- Coin get by player --
      if (coin.x - character.x) > -30 and (coin.x - character.x) < 30 and PlayerCanJump == false then
        coinCounter = coinCounter + 1
        coinSound.play(coinSound)
        if coinSound:isPlaying() then
          coinSound.stop(coinSound)
          coinSound.play(coinSound)
        end
        coin.x = love.math.random(1000, 1400)
      elseif coin.x < 0 then
        coin.x = love.math.random(1000, 1400)


    end
    ----------Meteorite animation---------
    timePassedSinceLastFrameChangeMeteorite = timePassedSinceLastFrameChangeMeteorite + dt
      if timePassedSinceLastFrameChangeMeteorite > desiredDelayBetweenFrameChangesMeteorite then
        timePassedSinceLastFrameChangeMeteorite = timePassedSinceLastFrameChangeMeteorite -
        desiredDelayBetweenFrameChangesMeteorite
        currentMeteoriteFrame = currentMeteoriteFrame + 1
        if currentMeteoriteFrame > 9 then
          currentMeteoriteFrame = 1
        end
      end
        meteorite.x = meteorite.x - 1 * dt * 350
        -- Meteorite hit player --
          if meteorite.x - character.x < 60 then
            lives.c = lives.c - 2
            -- Sound Controll --
            characterHitted.play(characterHitted)
            if characterHitted:isPlaying() then
              characterHitted.stop(characterHitted)
              characterHitted.play(characterHitted)
            end
            character.x = character.x - (10000 * dt)
            meteorite.x = love.math.random(1000, 1400)
            meteorite.health = 100
          end
          if meteorite.x < 0 then
          meteorite.x = love.math.random(1000, 3000)

      end

    ---------Bomb Animation----------
    timePassedSinceLastFrameChangeBomb = timePassedSinceLastFrameChangeBomb + dt
      if timePassedSinceLastFrameChangeBomb > desiredDelayBetweenFrameChangesBomb then
        timePassedSinceLastFrameChangeBomb = timePassedSinceLastFrameChangeBomb -
        desiredDelayBetweenFrameChangesBomb
        currentBombFrame = currentBombFrame + 1
        if currentBombFrame > 2 then
          currentBombFrame = 1
        end
      end
        bomb.x = bomb.x - 1 * dt * 500
        -- Need Fix --
        bombExplosionDelayPassed = bombExplosionDelayPassed + dt
        if bombExplosionDelayPassed > bombExplosionDelay then
          bombExplosion.x = 2000
        end
        -- Bomb hit player --
        if (bomb.x - character.x) > -30 and (bomb.x - character.x) < 30 and PlayerCanJump == true then
          lives.c = lives.c - 1
          -- Sound Controll --

          characterHitted.play(characterHitted)
          if characterHitted:isPlaying() then
            characterHitted.stop(characterHitted)
            characterHitted.play(characterHitted)
          end
          bombSound.play(bombSound)
          if bombSound:isPlaying() then
            bombSound.stop(bombSound)
            bombSound.play(bombSound)
          end
          bombExplosionDelayPassed = 0
          bomb.x = love.math.random(1000, 1400)
          bombExplosion.x = character.x + 50
          bombExplosion.y = 425
        elseif bomb.x < 0 then
          bomb.x = love.math.random(1000, 1400)
      end



      ----------Bomb Explosion Animation--------------
      timePassedSinceLastFrameChangeExplosion = timePassedSinceLastFrameChangeExplosion + dt
        if timePassedSinceLastFrameChangeExplosion > desiredDelayBetweenFrameChangesExplosion then
          timePassedSinceLastFrameChangeExplosion = timePassedSinceLastFrameChangeExplosion -
          desiredDelayBetweenFrameChangesExplosion
          currentBombExplosionFrame = currentBombExplosionFrame + 1
          if currentBombExplosionFrame > 2 then
            currentBombExplosionFrame = 1
          end
        end
        ----------Cloud Movement--------
        -- Need Fix --
        cloud1move.x = cloud1move.x - 1 * dt * 100
        if cloud1move.x < -110 then
          cloud1move.x = love.math.random(850, 900)
          cloud1move.y = love.math.random(5, 100)
        end
        cloud2move.x = cloud2move.x - 1 * dt * 100
        if cloud2move.x < -110 then
          cloud2move.x = love.math.random(950, 1000)
          cloud2move.y = love.math.random(105, 155)
        end
        cloud3move.x = cloud3move.x - 1 * dt * 100
        if cloud3move.x < -110 then
          cloud3move.x = love.math.random(1050, 1100)
          cloud3move.y = love.math.random(160, 205)
        end
        cloud4move.x = cloud4move.x - 1 * dt * 100
        if cloud4move.x < -110 then
          cloud4move.x = love.math.random(1150,1200)
          cloud4move.y = love.math.random(210, 300)
        end

        -- Attack Buff --
        aBuff.x = aBuff.x - 1 * dt * 200
        if aBuff.x < -50 then
          aBuff.x = 20000
        end
        if aBuff.x - character.x < 30 and PlayerCanJump == false
            and aBuff.x - character.x > -30 then
          aBuff.x = 20000
          ImprovedAttack = true
          aBuffText.x = 350
          msgTimer = 0
          buffsSound.play(buffsSound)
        end
        -- Speed Buff --
        sBuff.x = sBuff.x - 1 * dt * 200
        if sBuff.x < -50 then
          sBuff.x = 20000
        end
        if sBuff.x - character.x < 30 and PlayerCanJump == false
          and sBuff.x - character.x > -30 then
            sBuff.x = 20000
            character.speed = character.speed * 2
            sBuffText.x = 350
            msgTimer = 0
            buffsSound.play(buffsSound)
        end
        -- Buff Text --
        msgTimer = msgTimer + 1 * dt
        if msgTimer > msgMaxTimer then
          sBuffText.x = 10000
          aBuffText.x = 10000
        end

        -- Meteorite explosion animation --
        -- Need Fix --
        MeteoriteExplosionDelayPassed = MeteoriteExplosionDelayPassed + 1 * dt
        if MeteoriteExplosionDelayPassed > MeteoriteExplosionDelay then
          MeteoriteExplosions.x = 2000
        end
end
end
-- Atacking spell --
function updateAttackSpell(dt)
for i=table.getn(Attacks), 1, -1 do
  attack = Attacks[i]
  attack.x = attack.x + dt * 450
  if ImprovedAttack == false then
  attack.dmg = 25
else
  attack.dmg = 100
  end
-- Destroy meteorite --
  if (meteorite.x - attack.x) > -30 and (meteorite.x - attack.x) < 30 then
    meteorite.health = meteorite.health - attack.dmg
    meteoriteHitted.play(meteoriteHitted)
    -- Sound Controll --
      if meteoriteHitted:isPlaying() then
        meteoriteHitted.stop(meteoriteHitted)
        meteoriteHitted.play(meteoriteHitted)
        love.audio.play(meteoriteHitted)
      end
    -- At destruction --
    if meteorite.health == 0 then
    MeteoriteExplosionDelayPassed = 0
    meteoriteSound.play(meteoriteSound)
    meteorite.health = 100

  -- Sound Controll --
    if meteoriteSound:isPlaying() then
      meteoriteSound.stop(meteoriteSound)
      meteoriteSound.play(meteoriteSound)
      love.audio.play(meteoriteSound)
    end

  -- Meteorite destroy animation --
    if MeteoriteExplosionDelayPassed < MeteoriteExplosionDelay then
        MeteoriteExplosions.x = meteorite.x - 60
        MeteoriteExplosions.y = meteorite.y
    end

    meteorite.x = love.math.random(1000, 1400)
  end
    table.remove(Attacks, i)
  end
  -- Attackspeed Controll --
  if attack.speed < attackMaxSpeed then
    attack.speed = attack.speed + 1 * dt
  end
  -- Range Controll --
  if attack.x > (character.x + 300) then
    table.remove(Attacks, i)

end
end

end
-- Create Attack --
function SpawnAttackSpell(x, y, speed)
  if Spell == true then
    attack = {x = x + 65, y = y + 15, speed = speed}
    table.insert(Attacks, attack)
end
end
---------- Pause The Game Button -----------
function love.mousepressed(x, y, button)
if timerHide == false then
  if x > pauseButton.x  and x < pauseButton.x + 30 and
     y > pauseButton.y  and y < pauseButton.y + 30 then
       stopTheGame = true
       resumeGame = true
  end
  if x > resumeButton.x and x < resumeButton.x + 168 and
     y > resumeButton.y and y < resumeButton.y + 50 then
       -- stopTheGame = false
       stopTheGameSwitch = true
  end
  if x > restartButton.x and x < restartButton.x + 168 and
     y > restartButton.y and y < restartButton.y + 50 then
       love.event.quit('restart')
       love.filesystem.load('main.lua')() love.load()
  end
  if x > quitButton.x and x < quitButton.x + 168 and
     y > quitButton.y and y < quitButton.y + 50 then
       love.event.quit()
  end
end
end

function mouseStyleOnHover()
  if isHovered and stopTheGame and stopTheGameSwitch == false then
    love.mouse.setCursor(pointer)
  else
    love.mouse.setCursor(normalMouse)
  end
end

function love.draw()
  love.graphics.setColor(255, 255, 255, 255)
  ---------GrassGroundLevel---------
  love.graphics.draw(grassGroundLevel, subImage, 0, 500)
  --------Up Background--------
  love.graphics.draw(sky, skybackground, 0, -485)
  love.graphics.draw(cloud1move.obj, cloud1, cloud1move.x, cloud1move.y)
  love.graphics.draw(cloud1move.obj, cloud2, cloud2move.x, cloud2move.y)
  love.graphics.draw(cloud1move.obj, cloud1, cloud3move.x, cloud3move.y)
  love.graphics.draw(cloud1move.obj, cloud2, cloud4move.x, cloud4move.y)
  ---------COME ONE LAZY FIX THE CLOUDS--------
  -- love.graphics.draw(clouds, cloud3, 400, 150)
  ---------Player---------
  if needAngel then
  love.graphics.draw(angel.obj, angelFrames[currentAngelFrame], angel.x, angel.y)
  end
    -- if love.keyboard.isDown('d') and love.keyboard.isDown('k') and PlayerCanJump == true or love.keyboard.isDown('a') and love.keyboard.isDown('k') and PlayerCanJump == true and then
    if love.keyboard.isDown('k') and PlayerCanJump == true then
    love.graphics.draw(character.player, characterFrames[currentAttackFrame], character.x, character.y)
    else
    love.graphics.draw(character.player, workerFrames[currentFrame], character.x, character.y)
    end

  -------- Gold coin ----------
  love.graphics.draw(coin.obj, coinFrames[currentcoinFrame], coin.x, coin.y)
  -------- Meteorite ---------
  love.graphics.draw(meteorite.obj, meteoriteFrames[currentMeteoriteFrame], meteorite.x, meteorite.y)
  -------- Bomb --------
  love.graphics.draw(bomb.obj, bombFrames[currentBombFrame], bomb.x, bomb.y)
  love.graphics.draw(bomb.obj, bombExplosionFrames[currentBombExplosionFrame], bombExplosion.x, bombExplosion.y)
  -------- Static Coin --------
  love.graphics.setFont(font)
  love.graphics.draw(coin.obj, staticCoin, 950, 18)
  love.graphics.print(math.floor(coinCounter), 880, 30)
  -------- Pause The Game --------
  love.graphics.draw(pauseIcon, PauseGame, 962, 90)
  -------- Resume Menu ----------
  if stopTheGame == true and stopTheGameSwitch == false and timerHide == false then
    if resumeMbutton == false then
  love.graphics.rectangle('line', resumeButton.x, resumeButton.y, 168, 50)
  love.graphics.print('Resume', ScreenWidth/2 - 80, ScreenHeight/2 - 200)
  else
    love.graphics.rectangle('fill', resumeButton.x, resumeButton.y, 168, 50)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print('Resume', ScreenWidth/2 - 80, ScreenHeight/2 - 200)
  end
  if restartMbutton == false then
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle('line', restartButton.x, restartButton.y, 168, 50)
    love.graphics.print('Restart', ScreenWidth/2 - 73, ScreenHeight/2 - 140)
  else
    love.graphics.rectangle('fill', restartButton.x, restartButton.y, 168, 50)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print('Restart', ScreenWidth/2 - 73, ScreenHeight/2 - 140)
  end
  if quitMbutton == false then
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle('line', quitButton.x, quitButton.y, 168, 50)
    love.graphics.print('Quit', ScreenWidth/2 - 45, ScreenHeight/2 - 80)
  else
    love.graphics.rectangle('fill', quitButton.x, quitButton.y, 168, 50)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print('Quit', ScreenWidth/2 - 45, ScreenHeight/2 - 80)
  end
  end
  -- love.graphics.print(tostring(stopTheGameSwitch), 200, 200)
  -------- Buffs --------
  love.graphics.draw(Buffs, AttackBuff, aBuff.x, aBuff.y)
  love.graphics.draw(sBuffs, SpeedBuff, sBuff.x, sBuff.y)
  -------- Buffs Text -------
  love.graphics.print('Speed Increase!', sBuffText.x, sBuffText.y)
  love.graphics.print('Attack Increase!', aBuffText.x, aBuffText.y)
  -------- Static Buffs -------
  if ImprovedAttack == true then
    love.graphics.draw(Buffs, AttackBuff, 765, 18)
  end
  if character.speed > 250 then
    love.graphics.draw(sBuffs, SpeedBuff, 800, 18)
  end
  ------- Hearths ------
  love.graphics.setColor(255, 255, 255, 255)
  for i = 1, lives.c do
  love.graphics.draw(Hearth, hearth, (lives.x + 40) * i, 30)
  end

  if stopTheGameSwitch == true and timerHide == false then
  love.graphics.setFont(timerFont)
  if stopTheGameTimer <= 10 then
    love.graphics.print('3', 495, 100)
  elseif stopTheGameTimer <= 20 then
    love.graphics.print('2', 495, 100)
  elseif stopTheGameTimer <= 30 then
    love.graphics.print('1', 495, 100)
  end
  end

  for index, attack in ipairs(Attacks) do
    if ImprovedAttack == false then
    love.graphics.draw(SomeUsefulSprites, attackImg, attack.x - 10, attack.y - 50)
  else if ImprovedAttack == true then
    love.graphics.draw(SomeUsefulSprites,ImprovedAttackImg, attack.x - 10, attack.y - 25)
  end
end
  end

  love.graphics.draw(bomb.obj, MeteoriteExplosion, MeteoriteExplosions.x, MeteoriteExplosions.y)
  love.graphics.setColor(0,255,0)
  if meteorite.health == 75 then
    love.graphics.rectangle("fill", meteorite.x + 40, meteorite.y - 15, 80 ,10)
  elseif meteorite.health == 50 then
    love.graphics.rectangle("fill", meteorite.x + 40, meteorite.y - 15, 40,10)
  elseif meteorite.health == 25 then
    love.graphics.rectangle("fill", meteorite.x + 40, meteorite.y - 15, 20,10)
  end

end
