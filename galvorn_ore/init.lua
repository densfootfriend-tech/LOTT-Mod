-- Galvorn Ore Generator
-- Spawns below -10000
-- Surrounded by lava

local c_galvorn = minetest.get_content_id("lottores:galvorn_block")
local c_stone   = minetest.get_content_id("default:stone")
local c_lava    = minetest.get_content_id("default:lava_source")

-- Tier 1: Extremely rare Galvorn (-10000 to -15000)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "lottores:galvorn_block",
	wherein        = "default:stone",
	clust_scarcity = 50 * 50 * 50, -- Extra rare transition layer
	clust_num_ores = 1,
	clust_size     = 1,
	y_max          = -10000,
	y_min          = -15000,
})

-- Tier 2: Standard Galvorn rarity (-15000 to -31000)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "lottores:galvorn_block",
	wherein        = "default:stone",
	clust_scarcity = 40 * 40 * 40, -- Baseline rarity
	clust_num_ores = 1,
	clust_size     = 1,
	y_max          = -15001,
	y_min          = -31000,
})

-- Surround spawned Galvorn blocks with lava
minetest.register_on_generated(function(minp, maxp, seed)
	if maxp.y > -10000 then
		return
	end

	local vm = minetest.get_mapgen_object("voxelmanip")
	local emin, emax = vm:get_emerged_area()
	local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
	local data = vm:get_data()

	local changed = false

	for z = minp.z, maxp.z do
		for y = minp.y, maxp.y do
			for x = minp.x, maxp.x do
				local vi = area:index(x, y, z)

				if data[vi] == c_galvorn then
					changed = true

					for dx = -1, 1 do
						for dy = -1, 1 do
							for dz = -1, 1 do
								if not (dx == 0 and dy == 0 and dz == 0) then
									local ni = area:index(x + dx, y + dy, z + dz)

									if data[ni] ~= c_galvorn then
										data[ni] = c_lava
									end
								end
							end
						end
					end
				end

			end
		end
	end

	if changed then
		vm:set_data(data)
		vm:write_to_map()
	end
end)