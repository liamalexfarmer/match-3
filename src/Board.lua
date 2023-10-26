--[[
	Code that governs the presence and functionality of the board for Match 3 remake.
]]

Board = Class{}

function Board:init( x, y )
	self.x = x
	self.y = y
	self.matches = {}

	self:initializeTiles()
end

function Board:initializeTiles(  )
	self.tiles = {}

	for tileY = 1, 8 do

		table.insert(self.tiles, {})

		for tileX = 1, 8 do

			table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(18), math.random(6)))

		end

	end

	while self:calculateMatches() do

		self.initializeTiles()

	end
end

function Board:calculateMatches(  )
	local matches = {}

	--keeps track of how many matches found in a row
	local matchNum = 1

	--horizontal match checks begin
	for y = 1, 8 do

		--set match color variable to current tiles color
		local colorToMatch = self.tiles[y][1].color

		matchNum = 1

		--for every subsequent horizontal tile
		 for x = 2, 8 do

		 	--if the color matches the previous, add 1 to matchNum
		 	if self.tiles[y][x].color == colorToMatch then
		 		matchNum = matchNum + 1
		 	--if not set the color to match to the current color 
		 	else
		 		colorToMatch = self.tiles[x][y].color

		 		--if there was a 3+ row, add it to a new match table
		 		if matchNum >= 3 then
		 			local match = {}

		 			for x2 = x - 1, x - matchNum, -1 do
		 				table.insert(match, self.tiles[y][x2])
		 			end
		 			--add the match table to the governing matches table
		 			table.insert(matches, match)

		 		end

		 		--reset matchNum counter regardless
		 		matchNum = 1

		 		--if no matches by 7 then finish early
		 		if x >= 7 then
		 			break
		 		end
		 	end
		 end

		 --accounts for if the last tile in a row contributes to a match
		 if matchNum >= 3 then
		 	local match = {}

		 	for x = 8, 8 - matchNum + 1, -1 do
		 		table.insert(match, self.tiles[y][x])
		 	end

		 	table.insert(matches, match)
		 end
	 end


	 --reverse logic for checking vertical matches
	 for x = 1, 8 do
	 	local colorToMatch = self.tiles[1][x].color

	 	matchNum = 1

	 	for y = 2, 8 do
	 		if self.tiles[y][x].color = colorToMatch then
	 			matchNum = matchNum + 1
	 		else
	 			colorToMatch = self.tiles[y][x].color

	 			if matchNum >= 3 then 
	 				local match = {}

	 				for y2 = y - 1, y - matchNum, -1 do
	 					table.insert(match, self.tiles[y2][x])
	 				end

	 				table.insert(matches, match)
	 			end

	 			matchNum = 1

	 			if y >= 8 then
	 				break
	 			end
	 		end
	 	end

	 	if matchNum >= 3 then
	 		local match = {}

	 		for y = 8, 8 - matchNum + 1, -1 do
	 			table.insert(match, self.tiles[y][x])
	 		end

	 		table.insert(matches, match)

	 	end
	 end

	 self.matches = matches

	 --if there are matches return the table, if not return false
	 return #self.matches > 0 and self.matches or false

end

--[[
	Set tiles that are tabled for removal to nil.
]]

function Board:removeMatches(  )
	for k, match in pairs(self.matches) do
		for k, tile in pairs(match) do
			self.tiles[tile.gridY][tile.gridX] = nil
		end
	end

	self.matches = nil
end

--[[
	Collapses the tiles down to their lowest point based on gaps left behind by matches.
	Returns a table with data to facilitate tweening.
]]

function Board:getFallingTiles(  )
	--tweens table, where tiles will act as keys to deliver tweens so bricks fall from off screen
	local tweens = {}

	for x = 1, 8 do
		--variables used to track conditions
		local space = false
		local spaceY = 0

		--leveraging gridY
		local y = 8

		while y >= 1 do

			local tile = self.tile[y][x]

			--if the space flag is active, meaning the previous grid slot is empty
			if space then

				--if the current grid slot has a tile in it
				if tile then

					--move (duplicate) it to the previous slot that's empty
					self.tiles[spaceY][x] = tile

					--set spaceY to the new tile spot for later use
					tile.gridY = spaceY

					--set it's initial space to empty
					self.tiles[y][x] = nil

					--store the tween data that slides it into place
					tweens[tile] = {
						y = (tile.gridY - 1) * 32
					}

					--reset the space flag
					space = false
					--set y to the new tile's position to restart the check
					y = spaceY

					--reset spaceY to indicate no "active" space
					spaceY = 0

				end

			--if there's no tile then flag space as true
			elseif tile = nil then
				space = true

				--if a space in the column hasn't been detected yet, set spaceY to current y
				if spaceY == 0 then
					spaceY = y
				end
			end

			--lower y and check the next space
			y = y - 1

		end

	end

	--from the first to the eight column
	for x = 1, 8 do
		--check each row from lowest on screen to highest
		for y = 8, 1, -1 do
			--set tile to the current grid slot's tile
			local tile = self.tiles[y][x]

			--if there is no tile present
			if not tile then
				--create a random one assigned to the current grid position (x, y translate to tile.gridX/gridY)
				local tile = Tile(x, y, math.random(18), math.random(6))

				--set it's coordinate y value to above the top edge of the screen
				tile.y = -32

				--assign the tile to the empty grid slot in the grid tile table
				self.tiles[y][x] = tile

				--deliver the tween data for it's final resting place
				tweens[tile] = {
					y = (tile.gridY - 1) * 32
				}
			end
		end
	end

	--return the tween data for rendering and what not
	return tweens
end

function Board:render(  )
	for y = 1, #self.tiles do
		for x = 1, #self.tiles[1] do
			self.tiles[y][x]:render(self.x, self.y)
		end
	end
end