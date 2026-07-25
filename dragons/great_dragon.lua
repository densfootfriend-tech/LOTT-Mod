-- 1. Register a dedicated fast fire projectile entity inside the 'dmobs' namespace
mobs:register_arrow("dmobs:fire_fast", {
	visual = "sprite",
	visual_size = {x = 2.0, y = 2.0},
	textures = {"dmobs_fire.png"},      -- Uses dmobs fire texture exclusively
	velocity = 40,                      -- Projectile travel speed
	tail = 1,                           -- Enables particle tail effect
	tail_texture = "dmobs_fire.png",    -- Particle tail texture

	-- Hit logic configured as a fire attack
	hit_player = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 45, fire = 15},
		}, nil)
	end,

	hit_mob = function(self, mob)
		mob:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 45, fire = 15},
		}, nil)
	end,

	-- Places fire on the ground/impact site upon hit
	hit_node = function(self, pos, node)
		local fire_pos = minetest.find_node_near(pos, 1, {"air"})
		if fire_pos then
			minetest.set_node(fire_pos, {name = "fire:basic_flame"})
		end
		self.object:remove()
	end,
})

-- Helper function for 3D Multi-Layered AoE Fire Sphere Attack + Smart Despawn Logic
local function perform_fire_aoe(self, dtime)
	-- 1. SMART DESPAWN TIMER:
	local pos = self.object:get_pos()
	if not pos then return end

	local player_nearby = false
	for _, obj in ipairs(minetest.get_objects_inside_radius(pos, 60)) do
		if obj:is_player() then
			player_nearby = true
			break
		end
	end

	-- Reset internal lifetimer if a player is near so it never despawns mid-fight
	if player_nearby then
		self.lifetimer = 180 
	end

	-- 2. AOE ATTACK TIMER:
	self.aoe_timer = (self.aoe_timer or 0) + dtime
	if self.aoe_timer < 10 then return end -- Fires every 10 seconds
	self.aoe_timer = 0

	-- 3 Y-axis height layers scaled up 4x total (2x larger than your current version)
	local height_layers = {
		{ y_offset = -4.0, radius = 16.0 }, -- Lower layer
		{ y_offset = 2.0,  radius = 24.0 }, -- Middle/main layer
		{ y_offset = 8.0,  radius = 16.0 }, -- Upper layer
	}

	-- Spawn fire particles forming the enlarged 3D sphere
	for _, layer in ipairs(height_layers) do
		for angle = 0, 350, 10 do
			local rad = math.rad(angle)
			local px = pos.x + layer.radius * math.cos(rad)
			local pz = pos.z + layer.radius * math.sin(rad)

			minetest.add_particle({
				pos = {x = px, y = pos.y + layer.y_offset, z = pz},
				velocity = {x = 0, y = 0.8, z = 0},
				acceleration = {x = 0, y = 0.2, z = 0},
				expirationtime = 1.5,
				size = 6,
				collisiondetection = false,
				texture = "fire_basic_flame.png",
			})
		end
	end

	-- Play flame sound effect
	minetest.sound_play("mobs_fireball", {
		pos = pos,
		gain = 1.0,
		max_hear_distance = 35,
	})

	-- Deal 40 damage to players and mobs caught within the max layer radius (24 nodes)
	local objs = minetest.get_objects_inside_radius(pos, 24.0)
	for _, obj in ipairs(objs) do
		if obj ~= self.object then
			obj:punch(self.object, 1.0, {
				full_punch_interval = 1.0,
				damage_groups = {fleshy = 40, fire = 40},
			}, nil)
		end
	end
end
-- 2. Base Dragon Mob Definition
local gdragon_base = {
	type = "monster",
	passive = false,
	attacks_monsters = false,

	-- Custom step hook to trigger the 20-second 3D AoE fire sphere & despawn handling
	do_custom = perform_fire_aoe,

	-- Massive stat overhaul for true boss status
	damage = 35,
	reach = 9,

	-- Attack mechanics: Rapid fire projectile volley
	attack_type = "dogshoot",
	shoot_interval = 0.1,
	dogshoot_switch = 1,
	dogshoot_count = 0,
	dogshoot_count_max = 16,

	-- Uses the newly registered fast fire arrow entity
	arrow = "dmobs:fire_fast",
	shoot_offset = 1.5,

	-- Boss Health & Defense
	hp_min = 2200,
	hp_max = 2200,
	armor = 100,

	collisionbox = {-2.4, -4.4, -2.4, 2.4, 3.0, 2.4},

	visual = "mesh",
	mesh = "dragon.b3d",

	textures = {
		{"dmobs_dragon_great.png"},
	},

	blood_texture = "mobs_blood.png",

	visual_size = {x = 7, y = 7},

	makes_footstep_sound = true,
	runaway = false,

	jump_chance = 50,
	walk_chance = 90,
	fall_speed = 0,
	pathfinding = true,
	fall_damage = 0,

	sounds = {
		shoot_attack = "mobs_fireball",
		random = "roar",
	},

	-- Reduced Mobility
	walk_velocity = 1.5,
	run_velocity = 3.0,

	jump = true,
	fly = true,

	-- Rare & Epic Loot Table
	drops = {
		{name = "dmobs:dragon_egg_poison", chance = 4, min = 1, max = 1},
		{name = "dmobs:dragon_egg_lightning", chance = 4, min = 1, max = 1},
		{name = "dmobs:dragon_egg_fire", chance = 4, min = 1, max = 1},
		{name = "dmobs:dragon_egg_ice", chance = 4, min = 1, max = 1},

	{name = "lottother:tilkal_pure", chance = 1, min = 1, max = 3},



	{name = "lottore:gold_ingot", chance = 1, min = 20, max = 40},

{name = "lottother:red_gem", chance = 2, min = 2, max = 4},
{name = "lottother:blue_gem", chance = 2, min = 2, max = 4},
{name = "lottother:purple_gem", chance = 2, min = 2, max = 4},
{name = "lottother:white_gem", chance = 2, min = 2, max = 4},



	{name = "lottore_silver", chance = 1, min = 20, max = 40},

	{name = "lottother:dragon_sword", chance = 2, min = 1, max = 1},
		{name = "lottother:morgoth_essence", chance = 5, min = 1, max = 1},
		{name = "lottores:mithril_block", chance = 1, min = 1, max = 4},
		{name = "lottores:galvorn_block", chance = 1, min = 1, max = 3},
	},

	stepheight = 12,

	-- Immunities
	water_damage = 0,
	lava_damage = 0,
	light_damage = 0,

	view_range = 120,

	animation = {
		speed_normal = 3,
		speed_run = 6,

		walk_start = 1,
		walk_end = 22,

		stand_start = 1,
		stand_end = 22,

		run_start = 1,
		run_end = 22,

		punch_start = 22,
		punch_end = 47,
	},

	knock_back = 12,
}

-- Register Boss Version
mobs:register_mob("dmobs:dragon_great", dmobs.deepclone(gdragon_base))


-- Tame Version Overrides
local gdragon_tame = dmobs.deepclone(gdragon_base)
gdragon_tame.type = "npc"
gdragon_tame.attacks_monsters = true
gdragon_tame.on_rightclick = dmobs.dragon.ride
gdragon_tame.do_custom = function(self, dtime)
	perform_fire_aoe(self, dtime)
	if dmobs.dragon and dmobs.dragon.do_custom then
		dmobs.dragon.do_custom(self, dtime)
	end
end

mobs:register_mob("dmobs:dragon_great_tame", gdragon_tame)


-- Register Spawn Eggs
mobs:register_egg(
	"dmobs:dragon_great",
	"Great Dragon Boss",
	"dmobs_egg1.png",
	1
)

mobs:register_egg(
	"dmobs:dragon_great_tame",
	"Tamed Great Dragon",
	"default_lava_source_animated.png",
	1
)


-- Deep World Great Dragon Spawn
mobs:spawn_specific(
	"dmobs:dragon_great",
	{"default:stone"},
	{"air"},
	-1,
	15,
	120,
	60000,
	1,
	-30000,
	-15000

)