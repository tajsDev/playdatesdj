import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics
local playerSpeed = 4

local playTimer = nil
local score = 0 
local highestScore = 0 
local coinSprite = nil
local playTime = 30 * 1000
local function moveCoin()
	local randX = math.random(40,360)
	local randY = math.random(40,200)
	coinSprite:moveTo(randX,randY)
	
end
local function resetTimer() 
	playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
	score = 0
end 

local function initPlayer()
	playerSprite:moveTo(200,120)
	playerSprite:add()
end

local function initCoin()
	moveCoin()
	coinSprite:add()
end


local function initialize()
	local playerImage = gfx.image.new("images/player")
	playerSprite = gfx.sprite.new(playerImage)
	playerSprite:moveTo(200,120)
	playerSprite:setCollideRect(0,0,playerSprite:getSize())
	playerSprite:add()
	local coinImage = gfx.image.new("images/coin")
    coinSprite = gfx.sprite.new(coinImage)
	moveCoin()
	coinSprite:setCollideRect(0,0,coinSprite:getSize())
	coinSprite:add()
	local backgroundImage = gfx.image.new("images/background")
	gfx.sprite.setBackgroundDrawingCallback(
		function (x,y,width,height)
			gfx.setClipRect(x,y,width,height)
			backgroundImage:draw(0,0)
			gfx.clearClipRect()
		end
	)
	resetTimer()
end

initialize()
function playerMovement()
	if playdate.buttonIsPressed(playdate.kButtonUp) then
		playerSprite:moveBy(0, -playerSpeed)
	end
	if playdate.buttonIsPressed(playdate.kButtonRight) then
		playerSprite:moveBy(playerSpeed, 0)
	end
	if playdate.buttonIsPressed(playdate.kButtonDown) then
		playerSprite:moveBy(0, playerSpeed)
	end
	if playdate.buttonIsPressed(playdate.kButtonLeft) then
		playerSprite:moveBy(-playerSpeed, 0)
	end

end

function drawUI()
	gfx.drawText("Time: "..math.ceil(playTimer.value/1000),5,5)	
	gfx.drawText("Score: " .. score, 320, 5)
	if playTimer.value == 0 then
		playerSprite:remove()
		coinSprite:remove()
		if highestScore < score then
			highestScore = score;
		end
		gfx.drawText("Highest Score:"..highestScore,100,120)
		gfx.drawText("Press A to try again",100,145)
	end
end

function playdate.update()

	if playTimer.value == 0 then
		if playdate.buttonJustPressed(playdate.kButtonA) then
			resetTimer()
			initCoin()
			initPlayer()
		end
	else
		playerMovement()
		local collisions = coinSprite:overlappingSprites()
		if #collisions >= 1 then
			moveCoin()
			score += 1
		end
	end
	playdate.timer.updateTimers()
	gfx.sprite.update()
	drawUI()
end