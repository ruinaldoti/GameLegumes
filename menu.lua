-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnNivel1()
-- go to level1.lua scene
	composer.gotoScene( "level2", "fade", 500 )

	return true	-- indicates successful touch
end

local function onPlayCreditos()
	
	-- go to level2.lua scene
	composer.gotoScene( "creditos", "fade", 500 )
	
	return true	-- indicates successful touch
end



function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "imagens/background.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY
	
	-- create/position logo/title image on upper-half of the screen
	--local titleLogo = display.newImageRect( "logo.png", 120, 150 )
	--titleLogo.x = display.contentCenterX
	--titleLogo.y = 250
	
	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="Play",
		labelColor = { default={255}, over={128} },
		defaultFile="imagens/button.png",
		overFile="imagens/button-over.png",
		width=154, height=40,
		onRelease = onPlayBtnNivel1	-- event listener function
	}
	playBtn.x = display.contentCenterX
	playBtn.y = 200 -- display.contentHeight - 125

	playBtn2 = widget.newButton{
		label="Creditos",
		labelColor = { default={255}, over={128} },
		defaultFile="imagens/button.png",
		overFile="imagens/button-over.png",
		width=154, height=40,
		onRelease = onPlayCreditos	-- event listener function
	}
	playBtn2.x = display.contentCenterX
	playBtn2.y = 280 -- display.contentHeight - 125
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	--sceneGroup:insert( titleLogo )
	sceneGroup:insert( playBtn )
	sceneGroup:insert( playBtn2 )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then


	elseif phase == "did" then


	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		
	elseif phase == "did" then
		

	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene