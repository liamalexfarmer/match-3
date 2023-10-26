--[[
	Utility functions to facilitate the recreation of Match 3
]]



function GenerateTileQuads( atlas )
	local tiles = {}

	local x = 0
	local y = 0

	local counter = 1

	--9 rows of
	for row = 1, 9 do
		--two columns of
		for i = 1, 2 do

			tiles[counter] = {}

			--six patterns
			for col = 1, 6 do
				table.insert(tiles[counter], love.graphics.newQuad(
					x, y, 32, 32, atlas:getDimensions()
				))
				x = x + 32
			end

			counter = counter + 1
		end
		y = y + 32
		x = 0
	end

	--results in tiles[x] being a table of tile patterns for one tile color for 0 < x < 19
	--tiles [x][y] should pull each pattern so long as 0 < y < 7
	return tiles

end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end