dofile(minetest.get_modpath("dmobs").."/dragons/piloting.lua")

mobs:register_mob("dmobs:dragon", {
	type = "monster",
	passive = false,
	attacks_monsters = false, -- Aggressive towards players like the Great Dragon

	-- Base Combat Stats (Unchanged)
	damage = 4,
	reach = 3,
	attack_type = "dogshoot",
	shoot_interval = 2.5,
	dogshoot_switch = 2,
	dogshoot_count = 0,
	dogshoot_count_max = 5,
	arrow = "dmobs:fire",
	shoot_offset = 1,

	-- Base Health & Defense (Unchanged)
	hp_min = 70,
	hp_max = 100,
	armor = 100,
-- Collision Box
collisionbox = {-0.6, -1.2, -0.6, 0.6, 0.6, 0.6},
visual = "mesh",
mesh = "dragon.b3d",
textures = {
	{"dmobs_dragon.png"},
	{"dmobs_dragon2.png"},
	{"dmobs_dragon3.png"},
	{"dmobs_dragon4.png"},
},
blood_texture = "mobs_blood.png",

-- Halved Visual Size
visual_size = {x = 2, y = 2},
makes_footstep_sound = true,
runaway = false,
jump_chance = 30,
walk_chance = 80,
fall_speed = 0,
pathfinding = true,
fall_damage = 0,
	sounds = {
		shoot_attack = "mobs_fireball",
	},

	walk_velocity = 3,
	run_velocity = 5,
	jump = true,
	fly = true,

	-- Drops: Gold and Silver ingots
	drops = {
		{name = "lottweapons:mithril_spear", chance = 10, min = 1, max = 1},
		{name = "default:gold_ingot", chance = 2, min = 1, max = 5},
		{name = "default:silver_ingot", chance = 2, min = 1, max = 5},
	},

	stepheight = 10,
	water_damage = 2,
	lava_damage = 0,
	light_damage = 0,
	view_range = 20,

	animation = {
		speed_normal = 10,
		speed_run = 20,
		walk_start = 1,
		walk_end = 22,
		stand_start = 1,
		stand_end = 22,
		run_start = 1,
		run_end = 22,
		punch_start = 22,
		punch_end = 47,
	},

	knock_back = 2,
	do_custom = dmobs.dragon.step_custom,
	on_rightclick = dmobs.dragon.on_rc,
})

-- High-Frequency Underground Spawn Setup (Triggers roughly every 30s - 1 min in big caves)
mobs:spawn_specific(
	"dmobs:dragon", 
	{"air"}, 
	{"default:stone"}, 
	0,              -- Min light level (allows spawning in total cave darkness)
	15,             -- Max light level
	20,             -- Interval: Checks every 20 seconds
	1500,           -- Chance: 1 in 1,500 per node (frequent hits in large cavern systems)
	2,              -- Max group size (kept to 2 so the 2x large models don't crowd/overlap)
	-30000, 
	-15000
)

mobs:register_egg("dmobs:dragon", "Dragon", "default_apple.png", 1)