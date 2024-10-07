local Diver = {}

function Diver:init(x, y)
    self.partcles = {}
    self.partcles.bubbles = require 'src.Components.Modules.Game.Particles.Bubbles'

    self.partcles.bubbles:start()

    self.type = "Diver"

    self.x = x or love.graphics.getWidth() / 2
    self.y = y or 75
    self.gravity = 30
    self.moveSpeed = 30
    self.HP = 3
    self.maxHP = 3
    self.harpoon = false
    self.mirrored = false
    self.isDamaged = false
    self.cooldown = 2

    self.carringHarpoon = 0

    self.hitbox = {
        offsetX = 16,
        offsetY = 34,
        x = 0,
        y = 0,
        w = 32,
        h = 72
    }
    
    --  juice later XD --

    --self.diverAsset = love.graphics.newImage("assets/images/diver.png")
    self.diverAssets = {}
    self.diverAssets.image, self.diverAssets.quads = love.graphics.getQuads("assets/images/diver")
end

function Diver:draw()
    --love.graphics.draw(self.diverAsset, self.x, self.y, math.rad(45), 1, 1, self.diverAsset:getWidth() / 2, self.diverAsset:getHeight() / 2)
    local qx, qy, qw, qh = self.diverAssets.quads[1]:getViewport()
    love.graphics.setBlendMode("add")
        love.graphics.draw(self.partcles.bubbles, (self.x + qw / 2) - 16, self.y - 8, 0, 0.3, 0.3)
    love.graphics.setBlendMode("alpha")
    if registers.system.freemove then
        love.graphics.setColor(0, 0.8, 0.45, 1)
    end
    if self.isDamaged then
        love.graphics.setColor(0.5, 0.5, 0.5, 1)
    end
    if self.HP > 0 then
        love.graphics.draw(
            self.diverAssets.image, 
            self.diverAssets.quads[not self.harpoon and 1 or 2], 
            self.x, self.y, not self.mirrored and math.rad(45) or math.rad(-45),
            not self.mirrored and 1.5 or -1.5, 1.5, 
            qw / 2, qh / 2
        )
    end
    love.graphics.setColor(1, 1, 1, 1)
    if registers.system.showDebugHitbox then
        love.graphics.rectangle("line", self.hitbox.x, self.hitbox.y, self.hitbox.w, self.hitbox.h)
    end
end

function Diver:update(elapsed)
    local qx, qy, qw, qh = self.diverAssets.quads[1]:getViewport()
    self.partcles.bubbles:update(elapsed)

    if self.isDamaged then
        self.cooldown = self.cooldown - elapsed
        if self.cooldown <= 0 then
            self.isDamaged = false
            self.cooldown = 2
        end
    end

    self.hitbox.x = self.x - self.hitbox.offsetX
    self.hitbox.y = self.y - self.hitbox.offsetY

    if self.x - self.hitbox.offsetX <= 0 then
        self.x = self.hitbox.offsetX
    end
    if self.x + qw >= love.graphics.getWidth() then
        self.x = love.graphics.getWidth() - qw
    end

    if self.HP > 0 then
        self.y = self.y + self.gravity * elapsed

        self.gravity = 30
        self.partcles.bubbles:stop()
    end
end

function Diver:moveLeft(elapsed)
    self.x = self.x + self.moveSpeed * elapsed
    self.mirrored = false
    self.gravity = 30
    self.partcles.bubbles:stop()
end

function Diver:moveRight(elapsed)
    self.x = self.x - self.moveSpeed * elapsed
    self.mirrored = true
    self.gravity = 30
    self.partcles.bubbles:stop()
end

function Diver:dive(elapsed)
    self.gravity = 70
    self.partcles.bubbles:start()
end

return Diver