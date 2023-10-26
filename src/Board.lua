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