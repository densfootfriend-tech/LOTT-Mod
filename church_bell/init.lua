
church_bell = {}

church_bell.RING_INTERVAL = 3600 -- 60*60; ring each hour
church_bell.church_bell_SAVE_FILE = minetest.get_worldpath() .. '/church_bell_positions.data'

local church_bell_positions = {}

church_bell.save_church_bell_positions = function( player )
   local str = minetest.serialize( { church_bell_data = church_bell_positions } )

   local file, err = io.open( church_bell.church_bell_SAVE_FILE, 'wb' )
   if (err ~= nil) then
      if( player ) then
         minetest.chat_send_player(player:get_player_name(), 'Error: Could not save bell data')
      end
      return
   end
   file:write( str )
   file:flush()
   file:close()
end

church_bell.restore_church_bell_data = function()
   local file, err = io.open(church_bell.church_bell_SAVE_FILE, 'rb')
   if (err ~= nil) then
      print('Error: Could not open bell data savefile (ignore this message on first start)')
      return
   end
   local str = file:read('*a')
   file:close()

   local church_bell_positions_table = minetest.deserialize( str )
   if( church_bell_positions_table and church_bell_positions_table.church_bell_data ) then
      church_bell_positions = church_bell_positions_table.church_bell_data
      print('[church_bell] Read positions of bells from savefile.')
   end
end

-- Helper function to play bell sound according to node type
local function play_bell_sound(pos, sound_name)
   local node = minetest.get_node(pos)
   local sound_gain = 1.5
   local sound_pitch = 1.0

   if node.name == "church_bell:gold" then
      sound_gain = 2.5   -- Louder volume for gold bell
      sound_pitch = 1.3  -- Higher pitch for gold bell
   elseif node.name == "church_bell:iron" then
      sound_gain = 1.5   -- Standard volume for iron bell
      sound_pitch = 0.9  -- Lower pitch for iron bell
   end

   minetest.sound_play(sound_name, {
      pos = pos,
      gain = sound_gain,
      pitch = sound_pitch,
      max_hear_distance = 300,
   })
end

-- Ring all registered bells once
church_bell.ring_church_bell_once = function()
   for i, v in ipairs( church_bell_positions ) do
      play_bell_sound(v, 'church_bell')
   end
end

church_bell.ring_church_bell = function()
   local sekunde = tonumber( os.date( '%S') )
   local minute  = tonumber( os.date( '%M') )
   local stunde  = tonumber( os.date( '%I') ) -- 12-hour format
   local delay   = church_bell.RING_INTERVAL - sekunde - (minute * 60)

   -- Schedule the next hour's check
   minetest.after( delay, church_bell.ring_church_bell )

   if( church_bell_positions == nil or #church_bell_positions < 1 ) then
      return
   end

   if( sekunde > 10 ) then
      return
   end

   -- Ring the bell once for each hour of the current time
   for i = 1, stunde do
      minetest.after( (i - 1) * 5, church_bell.ring_church_bell_once )
   end
end

-- Initial load and start
minetest.after( 10, church_bell.ring_church_bell )
church_bell.restore_church_bell_data()


--- Nodes ---

minetest.register_node('church_bell:iron', {
	description = 'Iron Bell',
	node_placement_prediction = '',
	drawtype = 'mesh',
	mesh = "church_bell.obj",
	tiles = {'church_bell_iron.png'},
	selection_box = {
		type = 'fixed',
		fixed = { {-0.38, -0.31, -0.38, 0.38, 0.5, 0.38} }
	},
	paramtype = 'light',
	is_ground_content = true,
	inventory_image = 'church_bell_iron_inv.png',
	wield_image = 'church_bell_iron_inv.png',
	stack_max = 1,
	on_punch = function (pos, node, puncher)
		play_bell_sound(pos, 'church_bell_punch')
	end,

	after_place_node = function(pos, placer)
		table.insert( church_bell_positions, pos )
		church_bell.save_church_bell_positions( placer )
	end,

	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local found = 0
		for i, v in ipairs( church_bell_positions ) do
			if( v ~= nil and v.x == pos.x and v.y == pos.y and v.z == pos.z ) then
				found = i
			end
		end
		if( found > 0 ) then
			table.remove( church_bell_positions, found )
			church_bell.save_church_bell_positions( digger )
		end
	end,

	groups = {cracky = 2},
})

minetest.register_node('church_bell:gold', {
	description = 'Gold Bell',
	node_placement_prediction = '',
	drawtype = 'mesh',
	mesh = "church_bell.obj",
	tiles = {'church_bell_gold.png'},
	selection_box = {
		type = 'fixed',
		fixed = { {-0.38, -0.31, -0.38, 0.38, 0.5, 0.38} }
	},
	paramtype = 'light',
	is_ground_content = true,
	inventory_image = 'church_bell_gold_inv.png',
	wield_image = 'church_bell_gold_inv.png',
	stack_max = 1,
	on_punch = function (pos, node, puncher)
		play_bell_sound(pos, 'church_bell_punch')
	end,

	after_place_node = function(pos, placer)
		table.insert( church_bell_positions, pos )
		church_bell.save_church_bell_positions( placer )
	end,

	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local found = 0
		for i, v in ipairs( church_bell_positions ) do
			if( v ~= nil and v.x == pos.x and v.y == pos.y and v.z == pos.z ) then
				found = i
			end
		end
		if( found > 0 ) then
			table.remove( church_bell_positions, found )
			church_bell.save_church_bell_positions( digger )
		end
	end,

	groups = {cracky = 2},
})

--- Recipes ---

minetest.register_craft({
	output = 'church_bell:gold',
	recipe = {
		{'', 'default:gold_ingot', ''},
		{'default:gold_ingot', '', 'default:gold_ingot'},
		{'default:gold_ingot', '', 'default:gold_ingot'},
	},
})

minetest.register_craft({
	output = 'church_bell:iron',
	recipe = {
		{'', 'default:steel_ingot', ''},
		{'default:steel_ingot', '', 'default:steel_ingot'},
		{'default:steel_ingot', '', 'default:steel_ingot'},
	},
})