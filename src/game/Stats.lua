local Class = require "libs.hump.class"
local Timer = require "libs.hump.timer"
local Tween = require "libs.tween"
local Sounds = require "src.game.SoundEffects"


local statFont = love.graphics.newFont(26)

local Stats = Class{}
function Stats:init()
    self.y = 10 
    self.level = 1 -- current level    
    self.totalScore = 0 -- total score so far
    self.targetScore = 10
    self.maxSecs = 99 -- max seconds for the level
    self.elapsedSecs = 0 -- elapsed seconds
    self.timeOut = false -- when time is out
    self.tweenLevel = false 
end

function Stats:draw()
    love.graphics.setColor(1,0,1) -- Magenta
    love.graphics.printf("Level "..tostring(self.level), statFont, gameWidth/2-60,10,100,"center")
    love.graphics.printf("Time "..math.floor(tostring(self.elapsedSecs)).."/"..tostring(self.maxSecs), statFont,10,10,200)
    love.graphics.printf("Score "..tostring(self.totalScore), statFont,gameWidth-210,10,200,"right")
    love.graphics.setColor(1,1,1) -- White

    --only print the level up if one just occured
    if self.tweenLevel then
        love.graphics.setColor(1,0,1)  --Magenta
        love.graphics.printf("Level UP!", statFont, gameWidth/2-60, self.y+100,100, "center")
        love.graphics.setColor(1,1,1) -- White
    end
end


function Stats:update(dt)
    -- Update the timer and game over if too much time is taken 
    self.elapsedSecs = self.elapsedSecs+dt
    if self.elapsedSecs > self.maxSecs then
        --when game ends, reset timer for next play
        gameState = "over"
        self.elapsedSecs=0
    end 

    --end the tweening after 2 seconds, 
    -- also reset the y value for next tween
    if self.elapsedSecs > 2 and self.tweenLevel then
        self.tweenLevel = false
        self.y = 10
    end

    --tween if a level up has just happend
    if self.tweenLevel then
        self.tweenMan:update(dt)
    end
end


function Stats:addScore(n)
    self.totalScore = self.totalScore + n
    if self.totalScore > self.targetScore then
        self:levelUp()
        --reset the timer upon leveling up
        self.elapsedSecs = 0
    end
end

function Stats:levelUp()
    self.level = self.level +1
    self.targetScore = self.targetScore+self.level*500
    
    self.elapsedSecs = 0

    --trigger tweening
    self.tweenLevel = true
    self.tweenMan = Tween.new(2.0,self, {y = self.y + 100})

    --play sound effect
    Sounds.levelUp:play()

end
    
return Stats
    