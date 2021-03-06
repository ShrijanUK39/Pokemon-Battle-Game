EntityWalkState = Class{__includes = EntityBaseState}

function EntityWalkState:init(entity, level)
    self.entity = entity
    self.level = level
    
    self.canWalk = false
end

function EntityWalkState:enter(params)
    self:attemptMove()
end

function EntityWalkState:attemptMove()
    self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))

    local toX, toY = self.entity.mapX, self.entity.mapY

    if self.entity.direction == 'left' then
        toX = toX - 1
    elseif self.entity.direction == 'right' then
        toX = toX + 1
    elseif self.entity.direction == 'up' then
        toY = toY - 1
    else
        toY = toY + 1
    end

    if toX < 1 or toX > 24 or toY < 1 or toY > 13 then
        self.entity:changeState('idle')
        self.entity:changeAnimation('idle-' .. tostring(self.entity.direction))
        return
    end

    self.entity.mapY = toY
    self.entity.mapX = toX

    Timer.tween(0.2, {
        [self.entity] = {x = (toX - 1) * TILE_SIZE, y = (toY - 1) * TILE_SIZE - self.entity.height / 2}
    }):finish(function()
        if love.keyboard.isDown(CTRL_LEFT) then
            self.entity.direction = 'left'
            self.entity:changeState('walk')
        elseif love.keyboard.isDown(CTRL_RIGHT) then
            self.entity.direction = 'right'
            self.entity:changeState('walk')
        elseif love.keyboard.isDown(CTRL_UP) then
            self.entity.direction = 'up'
            self.entity:changeState('walk')
        elseif love.keyboard.isDown(CTRL_DOWN) then
            self.entity.direction = 'down'
            self.entity:changeState('walk')
        else
            self.entity:changeState('idle')
        end
    end)
end