-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
--V1 13:24 03/03/18
--Display
w = display.contentWidth
h = display.contentHeight
--Physics
local physics = require("physics")
physics.start()
physics.setGravity(0, 0 )

--initialise game vars
local lives = 3
local score = 0
local highScore = 5
local alienLives = 0
local dead = false
local firing = false
math.randomseed(os.time())
local gameTimer
local livesText
local scoreText
local fireButton = display.newImage("shut.png")
local laser = display.newImage("laser.png")
local ship = display.newImage("fighter.png")
local alien = display.newImage("enemy.png")
--object locations
ship.x = w/2
ship.y = h-h/8
alien.x = w/2
alien.y = h/8
laser.x, laser.y = w/2, h/2
laser.xScale, laser.yScale = 2, 2
fireButton.xScale, fireButton.yScale = 1/3, 1/3
fireButton.x, fireButton.y = w - w/8, h - h/4
local gameEntities = {ship, alien, laser}
--walls
local lWall = display.newRect( 0, h/2, 2, h )
lWall:setFillColor(1,0,0,1)

local rWall = display.newRect( w, h/2, 2, h )
rWall:setFillColor(1, 0, 0, 1)

local floor = display.newRect(w/2, h, w, 4)
floor:setFillColor(1, 0, 0, 1)

local roof = display.newRect(w/2, 0, w, 4)
roof:setFillColor(1, 0, 0, 1)

--hitboxes
physics.addBody(ship, "dynamic", { friction=1, bounce=1 })
physics.addBody(alien, "dynamic", { friction=1, bounce=1 })
physics.addBody (lWall, "static")
physics.addBody (rWall, "static")
physics.addBody (floor, "static")
physics.addBody (roof, "static")
--ship movement event
function ship:touch( event )
    if event.phase == "began" then
        self.markX = self.x  
        elseif event.phase == "moved" then
        if (event.x > 40 or event.x < w-40) then
        local x = (event.x - event.xStart) + self.markX
        self.x = x
        end
    end
    return true
end
ship:addEventListener( "touch", ship )
alien:applyLinearImpulse(1, 0, alien.x, alien.y)
--check that the objects don't go off the screen
local minimumX = 0
local maximumX = w
local function Update()

    for i = 1, #gameEntities do

        --stop off left side
        if gameEntities[i].x - (gameEntities[i].width * 0.5) < minimumX then
            gameEntities[i].x = minimumX + w/16

        --stop off right side
        elseif gameEntities[i].x + (gameEntities[i].width * 0.5) > maximumX then
            gameEntities[i].x = maximumX - w/16
        end
        --if firing == false then
        --laser.x, laser.y = ship.x, ship.y
        --end
    end
end
Runtime:addEventListener("enterFrame", Update)

--schüt action
function fireButton:tap(event)
firing = true
laser:applyLinearImpulse(0, 1, 0, 0)
end
fireButton:addEventListener("tap", fireButton)