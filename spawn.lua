if dmobs.regulars then

	-- FRIENDLIES

	mobs:register_spawn(
		"dmobs:hedgehog",
		{"default:dirt_with_grass","default:pine_needles","lottmapgen:shire_grass"},
		20, 10, 15000, 2, 31000
	)

	mobs:register_spawn(
		"dmobs:whale",
		{"default:water_source"},
		20, 10, 80000, 2, -20
	)

	mobs:register_spawn(
		"dmobs:owl",
		{"default:leaves","default:tree"},
		20, 10, 80000, 2, 31000
	)

	mobs:register_spawn(
		"dmobs:tortoise",
		{"default:clay","default:sand"},
		20, 10, 60000, 2, 31000
	)

	mobs:register_spawn(
		"dmobs:elephant",
		{"default:dirt_with_dry_grass","default:desert_sand"},
		20, 10, 40000, 2, 31000
	)



	-- UNDERGROUND ENEMIES


	-- DMobs Orc
	-- Depth: -1 to -5000
	mobs:spawn_specific(
		"dmobs:orc",
		{"default:stone"},
		{"air"},
		-1,
		20,
		30,
		5000,
		3,
		-5000,
		-1
	)


	-- DMobs Orc redesign (Morgul Orc)
	-- Depth: -1 to -5000
	mobs:spawn_specific(
		"dmobs:orc2",
		{"default:stone"},
		{"air"},
		-1,
		20,
		30,
		8000,
		3,
		-5000,
		-1
	)


	-- Deep Ogres
	-- Depth: -5000 to -15000
	mobs:spawn_specific(
		"dmobs:ogre",
		{"default:stone"},
		{"air"},
		-1,
		20,
		30,
		12000,
		2,
		-15000,
		-5000
	)

end



-- DRAGONS


-- Rare Wyvern
-- Surface/Mordor areas
mobs:spawn_specific(
	"dmobs:wyvern",
	{"lottmapgen:mordor_stone","lottmapgen:angsnowblock"},
	{"air"},
	-1,
	20,
	30,
	40000,
	2,
	-31000,
	31000
)


-- Great Dragon intentionally disabled
-- because you already have it spawning

--mobs:spawn_specific(
--	"dmobs:dragon_great",
--	{"default:lava_source","default:lava_flowing"},
--	{"air"},
--	0,
--	20,
--	300,
--	64000,
--	1,
--	-21000,
--	1000
--)