--[[
	Functions that govern the Tiles of a Match3 remake.
]]

Tile = Class{}

function Tile:init( x, y, color, variety )
	
	--board positions
	self.gridX = x
	self.gridY = y

	--co-ordinate position
	self.x = (self.gridX - 1) * 32
	self.y = (self.gridY - 1) * 32

	--tile color and pattern
	self.color = color
	self.variety = variety
end

function Tile:render( x, y )

	--draw a drop shadow
	love.graphics.setColor(34, 32, 52, 255)
	love.graphics.draw(gTextures.main, gFrames.tiles[self.color][self.variety],
		self.x + x + 2, self.y + y + 2)

	--draw the tile over the shadow
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(gTextures.main, gFrames.tiles[self.color][self.variety],
		self.x + x, self.y + y)
end