-- mods/default/mapgen.lua

local mapgen_name = minetest.get_mapgen_setting("mg_name")
local lott_v6 = minetest.settings:get_bool("lott_v6") or false

if mapgen_name == "singlenode" or (mapgen_name == "v6" and lott_v6 ~= true) then
	minetest.set_mapgen_setting("mg_name", "v7", true)
end

local flags = minetest.get_mapgen_setting("mgv7_spflags")

if flags ~= nil then
	local c1, c2 = flags:find("floatlands")

	if c1 and c2 and not flags:find("nofloatlands") then
		minetest.set_mapgen_setting("mgv7_spflags",
			flags:sub(1, c1-1) .. flags:sub(c2+1), true)
	end
end

--
-- Aliases for map generator outputs
--

minetest.register_node("default:mapgen_stone", {
	description = "Mapgen Stone",
	tiles = {"default_stone.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1, not_in_creative_inventory=1},
	drop = 'default:cobble',
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_alias("mapgen_stone", "default:stone")
minetest.register_alias("mapgen_tree", "air")
minetest.register_alias("mapgen_leaves", "air")
minetest.register_alias("mapgen_jungletree", "air")
minetest.register_alias("mapgen_jungleleaves", "air")
minetest.register_alias("mapgen_apple", "air")
minetest.register_alias("mapgen_water_source", "default:water_source")
minetest.register_alias("mapgen_river_water_source", "default:river_water_source")
minetest.register_alias("mapgen_dirt", "default:mapgen_stone")
minetest.register_alias("mapgen_gravel", "default:gravel")
minetest.register_alias("mapgen_clay", "default:mapgen_stone")
minetest.register_alias("mapgen_lava_source", "default:lava_source")
minetest.register_alias("mapgen_cobble", "default:cobble")
minetest.register_alias("mapgen_mossycobble", "default:mossycobble")
minetest.register_alias("mapgen_dirt_with_grass", "default:mapgen_stone")
minetest.register_alias("mapgen_junglegrass", "air")
minetest.register_alias("mapgen_stone_with_coal", "default:stone_with_coal")
minetest.register_alias("mapgen_stone_with_iron", "default:stone_with_iron")
minetest.register_alias("mapgen_mese", "default:mese")
minetest.register_alias("mapgen_sand", "default:stone")
minetest.register_alias("mapgen_sandstone", "default:sandstone")
minetest.register_alias("mapgen_desert_sand", "default:mapgen_stone")

if mapgen_name == "v6" then
	minetest.register_alias("mapgen_desert_stone", "default:stone")
else
	minetest.register_alias("mapgen_desert_stone", "default:desert_stone")
end
minetest.register_alias("mapgen_stair_cobble", "stairs:stair_cobble")
minetest.register_alias("mapgen_sandstonebrick", "default:cobble")
minetest.register_alias("mapgen_stair_sandstonebrick", "stairs:stair_cobble")

--
-- Ore Generation Progression
--

local wl = tonumber(minetest.get_mapgen_setting("water_level")) or 1

-------------------------------------------------------------------------------
-- TIER 1: SHALLOW DEPTHS (Surface down to -500)
-------------------------------------------------------------------------------

-- Clay (Surface sand beaches)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:clay",
	wherein        = "default:sand",
	clust_scarcity = 12 * 12 * 12,
	clust_num_ores = 64,
	clust_size     = 5,
	y_max          = wl,
	y_min          = wl - 10,
})

-- Coal (Surface down to -500)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_coal",
	wherein        = "default:stone",
	clust_scarcity = 10 * 10 * 10,
	clust_num_ores = 5,
	clust_size     = 3,
	y_max          = wl + 64,
	y_min          = -500,
})

-- Limestone (Shallow stone down to -500)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "lottores:limestone",
	wherein        = "default:stone",
	clust_scarcity = 12 * 12 * 12,
	clust_num_ores = 4,
	clust_size     = 2,
	y_max          = wl - 10,
	y_min          = -500,
})

-- Tin (-30 to -500)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "lottores:tin_ore",
	wherein        = "default:stone",
	clust_scarcity = 14 * 14 * 14,
	clust_num_ores = 3,
	clust_size     = 2,
	y_max          = -30,
	y_min          = -500,
})

-- Copper (-60 to -500)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_copper",
	wherein        = "default:stone",
	clust_scarcity = 14 * 14 * 14,
	clust_num_ores = 3,
	clust_size     = 2,
	y_max          = -60,
	y_min          = -500,
})

-- Iron (-120 to -500)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_iron",
	wherein        = "default:stone",
	clust_scarcity = 13 * 13 * 13,
	clust_num_ores = 3,
	clust_size     = 2,
	y_max          = -120,
	y_min          = -500,
})

-- Lead (-150 to -500)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "lottores:lead_ore",
	wherein        = "default:stone",
	clust_scarcity = 13 * 13 * 13,
	clust_num_ores = 3,
	clust_size     = 2,
	y_max          = -150,
	y_min          = -500,
})

-------------------------------------------------------------------------------
-- TIER 2: MID-DEPTHS (-500 to -2000)
-------------------------------------------------------------------------------

local mid_ores = {
	{"default:stone_with_coal",  10*10*10, 6, 3},
	{"lottores:limestone",       11*11*11, 6, 3},
	{"lottores:tin_ore",         12*12*12, 4, 3},
	{"default:stone_with_copper",12*12*12, 4, 3},
	{"default:stone_with_iron",  10*10*10, 5, 3},
	{"lottores:lead_ore",        11*11*11, 4, 3},
}

for _, def in ipairs(mid_ores) do
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = def[1],
		wherein        = "default:stone",
		clust_scarcity = def[2],
		clust_num_ores = def[3],
		clust_size     = def[4],
		y_max          = -501,
		y_min          = -2000,
	})
end

-- Silver (-500 to -2000)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "lottores:silver_ore",
	wherein        = "default:stone",
	clust_scarcity = 20*20*20,
	clust_num_ores = 2,
	clust_size     = 2,
	y_max          = -500,
	y_min          = -2000,
})

-- Gold (-750 to -2000)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_gold",
	wherein        = "default:stone",
	clust_scarcity = 22*22*22,
	clust_num_ores = 2,
	clust_size     = 2,
	y_max          = -750,
	y_min          = -2000,
})

-------------------------------------------------------------------------------
-- TIER 3: DEEP MINING (-2000 to -5000) - Toned Down Density
-------------------------------------------------------------------------------

local deep_ores = {
	{"default:stone_with_coal",  9*9*9,   6, 3},
	{"lottores:limestone",       10*10*10, 6, 3},
	{"lottores:tin_ore",         10*10*10, 4, 3},
	{"default:stone_with_copper",10*10*10, 4, 3},
	{"default:stone_with_iron",  9*9*9,   6, 3},
	{"lottores:lead_ore",        10*10*10, 4, 3},
	{"lottores:silver_ore",      13*13*13, 4, 3},
	{"default:stone_with_gold",  14*14*14, 4, 3},
	{"lottores:rough_rock",      16*16*16, 3, 2},
	{"default:stone_with_mese",  18*18*18, 2, 2},
}

for _, def in ipairs(deep_ores) do
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = def[1],
		wherein        = "default:stone",
		clust_scarcity = def[2],
		clust_num_ores = def[3],
		clust_size     = def[4],
		y_max          = -2001,
		y_min          = -5000,
	})
end

-------------------------------------------------------------------------------
-- TIER 4: ABYSS (-5000 to -10000) - Only Gold, Silver, Rough Rock, Mese
-------------------------------------------------------------------------------

local abyss_ores = {
	{"lottores:rough_rock",     8*8*8,   6, 3},
	{"lottores:silver_ore",     8*8*8,   6, 3},
	{"default:stone_with_gold", 9*9*9,   6, 3},
	{"default:stone_with_mese", 11*11*11,5, 3},
}

for _, def in ipairs(abyss_ores) do
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = def[1],
		wherein        = "default:stone",
		clust_scarcity = def[2],
		clust_num_ores = def[3],
		clust_size     = def[4],
		y_max          = -5001,
		y_min          = -10000,
	})
end

-------------------------------------------------------------------------------
-- TIER 5: DEEP ABYSS (-10000 to -15000)
-------------------------------------------------------------------------------

local deep_abyss_ores = {
	{"lottores:rough_rock",     7*7*7, 8, 4},
	{"lottores:silver_ore",     5*5*5, 8, 4},
	{"default:stone_with_gold", 6*6*6, 8, 4},
	{"default:stone_with_mese", 7*7*7, 7, 3},
}

for _, def in ipairs(deep_abyss_ores) do
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = def[1],
		wherein        = "default:stone",
		clust_scarcity = def[2],
		clust_num_ores = def[3],
		clust_size     = def[4],
		y_max          = -10001,
		y_min          = -15000,
	})
end

-------------------------------------------------------------------------------
-- SPECIAL ORES: MITHRIL (-5000 and deeper)
-------------------------------------------------------------------------------

-- Rare Mithril Ore (-5000 to -15000)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "lottores:mithril_ore",
	wherein        = "default:stone",
	clust_scarcity = 32 * 32 * 32,
	clust_num_ores = 3,
	clust_size     = 2,
	y_min          = -15000,
	y_max          = -5000,
})

-- Mithril Ore (-15000 and below) - Made 2x Rarer
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "lottores:mithril_ore",
	wherein        = "default:stone",
	clust_scarcity = 20 * 20 * 20,
	clust_num_ores = 5,
	clust_size     = 3,
	y_min          = -31000,
	y_max          = -15000,
})

-- Mithril Blocks (-15000 and below) - Made 2x Rarer
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "lottores:mithril_block",
	wherein        = "default:stone",
	clust_scarcity = 40 * 40 * 40,
	clust_num_ores = 1,
	clust_size     = 1,
	y_min          = -31000,
	y_max          = -15000,
})

-------------------------------------------------------------------------------
-- DEPRECATED HELPER
-------------------------------------------------------------------------------

function default.generate_ore(name, wherein, minp, maxp, seed, chunks_per_volume, chunk_size, ore_per_chunk, y_min, y_max)
	minetest.log('action', "WARNING: default.generate_ore is deprecated")
	if maxp.y < y_min or minp.y > y_max then return end
	local y_min = math.max(minp.y, y_min)
	local y_max = math.min(maxp.y, y_max)
	if chunk_size >= y_max - y_min + 1 then return end
	local volume = (maxp.x-minp.x+1)*(y_max-y_min+1)*(maxp.z-minp.z+1)
	local pr = PseudoRandom(seed)
	local num_chunks = math.floor(chunks_per_volume * volume)
	local inverse_chance = math.floor(chunk_size*chunk_size*chunk_size / ore_per_chunk)

	for i=1,num_chunks do
		local y0 = pr:next(y_min, y_max-chunk_size+1)
		if y0 >= y_min and y0 <= y_max then
			local x0 = pr:next(minp.x, maxp.x-chunk_size+1)
			local z0 = pr:next(minp.z, maxp.z-chunk_size+1)
			for x1=0,chunk_size-1 do
				for y1=0,chunk_size-1 do
					for z1=0,chunk_size-1 do
						if pr:next(1,inverse_chance) == 1 then
							local p2 = {x=x0+x1, y=y0+y1, z=z0+z1}
							if minetest.get_node(p2).name == wherein then
								minetest.set_node(p2, {name=name})
							end
						end
					end
				end
			end
		end
	end
end