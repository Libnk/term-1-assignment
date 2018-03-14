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
physics.setGravity(0, 0)

--initialise game vars
local lives = 3
local score = 0
local highScore = 5
local alienLives = 0
local ammo = 2
local level = 1
local dead = false
local firing = false
local empty = false
math.randomseed(os.time())
local fireAi = 1
local background2 = display.newImage("scroller.png")
local background = display.newImage("background.png")
local stars = display.newImage("starfield.png")
local fireButton = display.newImage("shut.png")
local gameTimer = display.newText("Time", w - w/8, h/8, "Mina.ttf", 18)
local livesText = display.newText("Lives", w/8, h/8, "Mina.ttf", 18)
local livesCounter = {}
local scoreText
local laser = display.newImage("laser.png")
local enemyLaser = display.newImage("alienLaser.png")
local ship = display.newImage("fighter.png")
local logo = display.newImage("Logo.png")
local alien = {}


--object locations
ship.x = w/2
ship.y = h-h/8
local target = display.newRect(ship.x, h/4, 2, h/6)
target:setFillColor(1,1,1,1)
laser.x, laser.y = w/2, h/2
laser.xScale, laser.yScale = 2, 2
fireButton.xScale, fireButton.yScale = 1/3, 1/3
fireButton.x, fireButton.y = w - w/8, h - h/4
background.x, background.y = w/2, h - background.contentHeight/2
background.xScale, background.yScale = 3/5, 3/5
background2.x, background2.y = w/2, h/2
background2.xScale, background2.yScale = 3/5, 3/5
logo.x, logo.y = w/2, 0 - logo.contentHeight
logo.xScale, logo.yScale = 3/4, 3/4
transition.to(logo, {time = 3000, delay = 500, y = h + logo.contentHeight})
enemyLaser.xScale, enemyLaser.yScale = 2, 2

local gameEntities = {ship, laser}
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
physics.addBody(laser, "dynamic", { friction = 0, bounce =0, density = 2})
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
        target.x = ship.x
        end
    end
    return true
end
ship:addEventListener( "touch", ship )
--laser:applyLinearImpulse(0, 1, laser.x, laser.y)
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
        if firing == false then
        laser.rotation = 0
        laser.x, laser.y = ship.x, ship.y - h/8
        end
        local fireTime = math.random(100)





    end
end
Runtime:addEventListener("enterFrame", Update)
laser.alpha = 0
--schüt action
function fireButton:tap(event)
    --transition.to(background, {time = 2000, y = background.y+200})
    if firing == false then
        firing = true
        laser.alpha = 1
        laser:applyLinearImpulse(0, -4, 0, 0)
    end

end
fireButton:addEventListener("tap", fireButton)
--initial lives
for l = 1, lives do
    livesCounter[l] = display.newImage("lives.png", w/8 - h/16 + l*(h/32), h/6)
    livesCounter[l].xScale, livesCounter[l].yScale = 1, 1   
end

--collision detection for laser
function onCollision( self, event )
    if ( event.phase == "ended" ) then
            if event.other ~= roof then
                
                if event.other.y < 283 and event.other.y > 280 then
                    alien[1] = nil
                    table.remove(alien, 1)
                    fireAi = fireAi + 1
                    print("value", alien[1])
                elseif event.other.y < 181 and event.other.y > 179 then
                    alien[2] = nil
                    table.remove(alien, 2)
                    print("value", alien[1])
                elseif event.other.y < 79 and event.other.y > 77 then
                    alien[3] = nil
                    table.remove(alien, 3)
                    print("value", alien[1])
                end
                event.other:removeSelf()
                
                alienLives = alienLives - 1
                laser:setLinearVelocity(0,0,0,0)
                laser.rotation = 0
                laser.alpha = 0
                empty = false
                firing = false
                print("level", level)
                end
                if alienLives == 0 then
                    print(alienLives)
                    level = level + 1
                    levProg()
                    firing = false 
                end
            else do
              laser:setLinearVelocity(0,0,laser.x,laser.y)
                laser.alpha = 0
                firing = false
            end
         end
end
        
laser.collision = onCollision
laser:addEventListener("collision")

--scroling background
stars.x = w/2
stars.rotation = 90
local bgspeed = 3
function move(event)
    background.y = background.y + bgspeed
    if (background.y - background.contentWidth) > h then
        background.y = 0-background.contentWidth/2
       end
    background2.y = background2.y + bgspeed
    if (background2.y - background2.contentWidth) > h then
        background2.y = 0-background2.contentWidth/2
    end
    stars.y = stars.y + bgspeed*2
    if (stars.y - stars.contentWidth) > h then
        stars.y = 0 - stars.contentWidth/2
    end
end
Runtime:addEventListener( "enterFrame", move )

--level progression and alien spawning
function levProg(event)
            print("lives", alienLives)
        score = score + level
            print("score", score)
            for k = #alien, 1, -1 do
                table.remove(alien, k)
            end
            
        if level < 4 then
            for i = 1, level do


                alien[i] = display.newImage("enemy.png")
                alien[i].y, alien[i].x = 0 + i*alien[i].contentHeight - h/2 - i*h/4, w/2
                transition.to(alien[i], {time = 2000, delay = 2000, y = alien[i].y + h})
                fireAi = level
                function addPhys(event)
                physics.addBody(alien[i], "dynamic", { friction=1, bounce=1 })
                print(i, alien[i].y)
                
                alien[i]:applyLinearImpulse((-1)^i, 0, alien[i].x, alien[i].y)
                
                end
                timer.performWithDelay(4000, addPhys)
                alienLives = i
            end
        elseif level > 3 then
         for i = 1, 3 do 
            
            alien[i] = display.newImage("enemy.png")
                alien[i].y, alien[i].x = 0 + i*alien[i].contentHeight - h/2 - i*h/4, w/2
                print(alien[i].y)
                transition.to(alien[i], {time = 2000, delay = 2000, y = alien[i].y + h})
                fireAi = 3
                function addPhys(event)
                physics.addBody(alien[i], "dynamic", { friction=1, bounce=1 })

                alien[i]:applyLinearImpulse(((-1)^i)*(1 + level/3 * (i/2)), 0, alien[i].x, alien[i].y)

                end
                timer.performWithDelay(4000, addPhys)
                alienLives = i
            end
        end   
end
if alienLives == 0 then
    print(alienLives)
    levProg()
end
time = 60
timeLimit()
function timeLimit( self, event )
timer = display.newText(time, w - w/8, h/10, "Mina.ttf", 18)
if time < 0 then
transition.to(gameTimer, {time = 500, y = gameTimer.y + 60})
transition.to(gameTimer, {time = 500, y = gameTimer.y - 60})
time = time - 1
print("time " + time)
end
Runtime:addEventListener("enterFrame", timeLimit)

end