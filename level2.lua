-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local function onPlayMenu()
	-- go to level1.lua scene
	composer.gotoScene( "menu", "fade", 500 )

	return true	-- indicates successful touch
end



-- include Corona's "physics" library
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0 )
-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
--------------------------------------------

	local function updateText()
		livesText.text = "Lives: " .. lives
		scoreText.text = "Score: " .. score
	end

	local w = display.contentWidth -- largura da tela
	local h = display.contentHeight -- altura da tela

-- Initialize variables

	local score = 0
	local died = false
	local raposaTable = {}

	local ship
	local gameLoopTimer
	local livesText
	local scoreText

	-- Set up display groups
	backGroup = display.newGroup()  -- Display group for the background image
	mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	bonecoGroup = display.newGroup()
	raposaGroup = display.newGroup()

	mainGroup:insert(bonecoGroup)
	mainGroup:insert(raposaGroup)
	-- Load the background
	local background = display.newImageRect( backGroup, "imagens/background2.png", display.actualContentWidth, display.actualContentHeight )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local lives = 1
	local score = 0
	local died = false
	local ship
	local gameLoopTimer
	local livesText
	local scoreText
	local passadaSound


-- Display lives and score
livesText = display.newText( uiGroup, "Lives: " .. lives, 60, 20, native.systemFont, 20 )
scoreText = display.newText( uiGroup, "Score: " .. score, 200, 20, native.systemFont, 20 )
local sheetData =  { width=45, height=63, numFrames=12 }

------------------------------CRIAÇÃO DA RAPOZA-------------------------------------------------------



local function createRaposa()

	--local newAsteroid = display.newImageRect( mainGroup, objectSheet, 1, 102, 85 )
	local rapD1 = display.newImageRect( raposaGroup,"Imagens/Thebat1.png", 40, 22)

	table.insert( raposaTable, rapD1 )
	physics.addBody( rapD1, "dynamic", {bounce=0.8 } )
	rapD1.myName = "raposa"

	local whereFrom = math.random( 3 )

	if ( whereFrom == 1 ) then
		-- From the left
		rapD1.x = -60
		rapD1.y = math.random( 180,450 )
		rapD1:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
		
	elseif ( whereFrom == 2 ) then
		-- From the top
		rapD1.x = 2
		rapD1.y = math.random( 180,450 )
		rapD1:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
		
	elseif ( whereFrom == 3 ) then
		-- From the right
		rapD1.x = 2
		rapD1.y = math.random( 180,450 )
		rapD1:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
	end

	rapD1:applyTorque( math.random( -6,6 ) )
	
end


local function gameLoop()
	print ("iniciando jogo")

	-- Create new raposa
	createRaposa()

	-- Remover raposa que se afastaram da tela
	for i = #raposaTable, 1, -1 do
		local thisRaposa = raposaTable[i]

		if ( thisRaposa.x < -100 or
			 thisRaposa.x > display.contentWidth + 100 or
			 thisRaposa.y < -100 or
			 thisRaposa.y > display.contentHeight + 100 )
		then
			display.remove( thisRaposa )
			table.remove( raposaTable, i )
		end
	end
end
--gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )





---------------------------------- CRIA O BONECO ------------------------------------------------------------
local sheetData =  { width=45, height=63, numFrames=12 }
local sheet = graphics.newImageSheet("imagens/gaara.png", sheetData)
-- cria uma nova imagem usando a sprite "gaara.png" e as propriedades vistas acima

local sequenceData =
{
	{ name = "idleDown", start = 1, count = 1, time = 0, loopCount = 1 }, --idleDown = parado para baixo (� s� um nome, vc quem nomeia como quiser)
	{ name = "idleLeft", start = 4, count = 1, time = 0, loopCount = 1 }, --parado pra esquerda
    { name = "idleRight", start = 7, count = 1, time = 0, loopCount = 1 }, --parado pra direita
    { name = "idleUp", start = 10, count = 1, time = 0, loopCount = 1 }, --parado pra cima
	{ name = "moveDown", start = 2, count = 2, time = 300, loopCount = 0 },
	{ name = "moveLeft", start = 5, count = 2, time = 300, loopCount = 0 },
	{ name = "moveRight", start = 8, count = 2, time = 300, loopCount = 0 },
    { name = "moveUp", start = 11, count = 2, time = 300, loopCount = 0 },
}


	local player = display.newSprite(bonecoGroup, sheet, sequenceData)

	-- cria finalmente a sprite utilizando as propriedades vistas acima
	player.x = w * .5
	player.y = h * .5

	local hitBox = display.newRect(bonecoGroup, player.x, player.y, player.width - 20, player.height - 20)

	function RecriarBoneco()
		if lives > 0 then
			lives = lives - 1
			livesText.text = "Lives: " .. lives
			player = display.newSprite(bonecoGroup, sheet, sequenceData)
			player.x = w * .5
			player.y = h * .5
			hitBox = display.newRect(bonecoGroup, player.x, player.y, player.width - 20, player.height - 20)
			hitBox.alpha = 0
			physics.addBody( player, {isSensor=true } )
			physics.addBody( hitBox, {isSensor=true } )
			hitBox.myName="hitBox"
			player.myName = "player"
		else
			timer.performWithDelay( 1000, onPlayMenu)
		end
		
	end

hitBox.alpha = 0

physics.addBody( player, {isSensor=true } )
physics.addBody( hitBox, {isSensor=true } )
hitBox.myName="hitBox"
player.myName = "player"
----------------------------------------------boneco coleta legumes --------------------------------------------
local function handleCollisionBoneco(event)
	if (event.object1.myName == "raposa" and event.object2.myName == "hitBox") then
		display.remove(event.object2)
		display.remove(player)
		timer.performWithDelay( 1500, RecriarBoneco)

	elseif(event.object2.myName == "raposa" and event.object1.myName == "hitBox") then		
		display.remove(event.object1)
		display.remove(player)
		timer.performWithDelay( 1500, RecriarBoneco)

	elseif (event.object1.myName == "leg1" and event.object2.myName == "hitBox") or (event.object2.myName == "leg1" and event.object1.myName == "hitBox") then
		display.remove(event.object2)
		legumes[1] = false
	elseif(event.object2.myName == "leg2" and event.object1.myName == "hitBox") or (event.object2.myName == "leg1" and event.object1.myName == "hitBox") then
		display.remove(event.object2)
		legumes[2] = false
	elseif (event.object2.myName == "leg3" and event.object1.myName == "hitBox") or (event.object2.myName == "leg3" and event.object1.myName == "hitBox") then
		display.remove(event.object2)
		legumes[3] = false
	elseif (event.object2.myName == "leg4" and event.object1.myName == "hitBox") or (event.object2.myName == "leg4" and event.object1.myName == "hitBox") then
		display.remove(event.object2)
		legumes[4] = false	
	elseif (event.object2.myName == "leg5" and event.object1.myName == "hitBox") or (event.object2.myName == "leg5" and event.object1.myName == "hitBox") then
		display.remove(event.object2)
		legumes[5] = false	
	elseif (event.object2.myName == "leg6" and event.object1.myName == "hitBox") or (event.object2.myName == "leg6" and event.object1.myName == "hitBox") then
		display.remove(event.object2)	
		legumes[6] = false
	elseif (event.object2.myName == "leg7" and event.object1.myName == "hitBox") or (event.object2.myName == "leg7" and event.object1.myName == "hitBox") then
		display.remove(event.object)
		legumes[7] = false

	end

	return true    
end

Runtime:addEventListener("collision", handleCollisionBoneco)
--player:addEventListener("collision", colidindoFogo)

-- configura um valor inicial para sprite, nesse caso � o "idleDown", por isso o gaara come�a olhando para baixo
player:setSequence("idleDown")

buttons = {}

buttons[1] = display.newImage(uiGroup, "Imagens/button1.png") --up
buttons[1].x = 250
buttons[1].y = 380
buttons[1].myName = "up"
buttons[1].rotation = -90

buttons[2] = display.newImage(uiGroup,"Imagens/button1.png") -- down
buttons[2].x = 250
buttons[2].y = 440
buttons[2].myName = "down"
buttons[2].rotation = 90

buttons[3] = display.newImage(uiGroup,"Imagens/button1.png") -- left
buttons[3].x = 210
buttons[3].y = 410
buttons[3].myName = "left"
buttons[3].rotation = 180

buttons[4] = display.newImage(uiGroup,"Imagens/button1.png") -- right
buttons[4].x = 290
buttons[4].y = 410
buttons[4].myName = "right"

local yAxis = 0
local xAxis = 0

touchFunction = function(e)
	local eventName = e.phase
	local direction = e.target.myName
	

	
	if eventName == "began" or eventName == "moved" then
		audio.play(passadaSound)
		
		if direction == "up" and player.x ~= nil and player.y ~= nil then
			player:setSequence("moveUp")
			yAxis = -5
			xAxis = 0

			
			
		elseif direction == "down" and player.x ~= nil and player.y ~= nil then 
			player:setSequence("moveDown")
			-- mesmo principio do moveUp, mas agora � mostrada a anima��o do gaara olhando para baixo
			yAxis = 5
			xAxis = 0
			
			
		elseif direction == "right" and player.x ~= nil and player.y ~= nil then
			player:setSequence("moveRight")
			xAxis = 5
			yAxis = 0
			
		elseif direction == "left" and player.x ~= nil and player.y ~= nil then
			player:setSequence("moveLeft")
			xAxis = -5
			yAxis = 0
			
		end
	else 
		
		if e.target.myName == "up" and player.x ~= nil and player.y ~= nil then 
			player:setSequence("idleUp")
			
		elseif e.target.myName == "down" and player.x ~= nil and player.y ~= nil then 
			player:setSequence("idleDown")
			-- mesmo principio do "idleUp", mas agora o gaara olha para baixo
		elseif e.target.myName == "right" and player.x ~= nil and player.y ~= nil then
			player:setSequence("idleRight")
		elseif e.target.myName == "left" and player.x ~= nil and player.y ~= nil then
			player:setSequence("idleLeft")
		end
		
		yAxis = 0
		xAxis = 0
	end
end

local j=1

for j=1, #buttons do 
	buttons[j]:addEventListener("touch", touchFunction)
end


fimJogo = false

 update = function()

			if (fimJogo) then
				return 
			end
		if (hitBox.x ~= nil and hitBox.y ~= nil) then	
			hitBox.x = hitBox.x + xAxis
			hitBox.y = hitBox.y + yAxis
			player.x = player.x + xAxis
			player.y = player.y + yAxis

			if player.x <= player.width * .5 then 
				player.x = player.width * .5
			elseif player.x >= w - player.width * .5 then 
				player.x = w - player.width * .5
			end

			if player.y <= player.height * .5 then
				player.y = player.height * .5
			elseif player.y >= h - player.height * .5 then 
				player.y = h - player.height * .5
			end 
			
			player:play() --executa a anima��o, � necess�rio usar essa fun��o para ativar a anima��o
		end
end

Runtime:addEventListener("enterFrame", update)




-----------------------------INSERIND0 OS LEGUMES------------------------------------------
local plantacaoGroup = display.newGroup()
backGroup:insert(plantacaoGroup)


legumes = {false, false, false, false, false, false, false}
ultimoLegume = 0

criarLegumes = function ()
	ultimoLegume = (ultimoLegume) + 1
	if (ultimoLegume == 8) then
		ultimoLegume = 1
	end

	
	if (legumes[ultimoLegume]) then
		
		--criarLegumes()
	else
		legumes[ultimoLegume] = true
		if(ultimoLegume == 1) then
			local leg1 = display.newImageRect( plantacaoGroup,"Imagens/leg1.png", 27, 33)
			leg1.x = 20
			leg1.y = 460
			physics.addBody( leg1, { isSensor=true } )
			leg1.myName = "leg1"
		
		elseif(ultimoLegume == 2) then
			local leg2 = display.newImageRect( plantacaoGroup,"Imagens/leg2.png", 27, 33)
			leg2.x = 130
			leg2.y = 160
			physics.addBody( leg2, { isSensor=true } )
			leg2.myName = "leg2"
		
		elseif(ultimoLegume == 3) then
			local leg3 = display.newImageRect( plantacaoGroup,"Imagens/leg3.png", 27, 33)
			leg3.x = 40
			leg3.y = 210
			physics.addBody( leg3, { isSensor=true } )
			leg3.myName = "leg3"

		
		elseif(ultimoLegume == 4) then
			local leg4 = display.newImageRect( plantacaoGroup,"Imagens/leg4.png", 14,22)
			leg4.x = 75
			leg4.y = 460
			
			physics.addBody( leg4, { isSensor=true } )
			leg4.myName = "leg4"
		
		elseif(ultimoLegume == 5) then
			local leg5 = display.newImageRect( plantacaoGroup,"Imagens/leg5.png", 27, 33)
			leg5.x = 300
			leg5.y = 200
			leg5.rotation = 90
			physics.addBody( leg5, { isSensor=true } )
			leg5.myName = "leg5"
		
		elseif(ultimoLegume == 6) then
			local leg6 = display.newImageRect( plantacaoGroup,"Imagens/leg6.png", 14,22)
			leg6.x = 215
			leg6.y = 160
			physics.addBody( leg6, { isSensor=true } )
			leg6.myName = "leg6"

		elseif(ultimoLegume == 7) then
			local leg7 = display.newImageRect( plantacaoGroup,"Imagens/leg7.png", 14,22)
			leg7.x = 140
			leg7.y = 360
			physics.addBody( leg7, { isSensor=true } )
			leg7.myName = "leg7"
		
		end
	end

end






local plant4 = display.newImageRect( plantacaoGroup,"Imagens/plant4.png", 27, 33)
plant4.x = 250
plant4.y = 300

local plant3 = display.newImageRect( plantacaoGroup,"Imagens/plant3.png", 50, 40)
plant3.x = 30
plant3.y = 220

local buraco = display.newImageRect( plantacaoGroup,"Imagens/buraco1.png", 40, 30)
buraco.x = 300
buraco.y = 220

local plant3 = display.newImageRect( plantacaoGroup,"Imagens/plant3.png", 33, 32)
plant3.x = 160
plant3.y = 350

local plant2 = display.newImageRect( plantacaoGroup,"Imagens/plant2.png", 33, 65)
plant2.x = 300
plant2.y = 280

local plant10 = display.newImageRect( plantacaoGroup,"Imagens/plant10.png", 33, 40)
plant10.x = 100
plant10.y = 450


physics.addBody( plant4, { isSensor=true } )
plant4.myName = "plant4"

local function LimparTela ()
	display.remove(plantacaoGroup)
	plantacaoGroup = nil
	display.remove(raposaGroup)
	raposaGroup = nil
	display.remove(bonecoGroup)
	bonecoGroup = nil
end

passadaSound = audio.loadSound( "sound/land.wav" )

-- local function Som()
-- 	local musica = audio.loadSound( "sound/land.wav")
-- 	audio.play(musica, { channel=1, loops=-1})
-- end


-------------------------------------------



function scene:create( event )
	local sceneGroup = self.view
		
	sceneGroup:insert( backGroup )
	sceneGroup:insert( mainGroup)
	sceneGroup:insert( uiGroup )
	physics.pause()

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
		legumeLoopTimer = timer.performWithDelay( 2000, criarLegumes, -1 )
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
		timer.cancel(gameLoopTimer)
		timer.cancel(legumeLoopTimer)
		audio.stop(1)

	elseif phase == "did" then
		-- Called when the scene is now off screen
		LimparTela()
		composer.removeScene("level2")
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene