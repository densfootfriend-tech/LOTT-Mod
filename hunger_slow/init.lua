-- hunger_slow/init.lua
-- Slows down LOTT's stamina (hunger) drain.
-- Works by adjusting the stamina mod's own settings table after it loads
-- (depends=stamina in mod.conf guarantees load order), so no config files
-- need to be touched and this is fully portable/shareable.

if not stamina or not stamina.settings then
	minetest.log("warning", "[hunger_slow] stamina mod not found, nothing to adjust")
	return
end

local s = stamina.settings

-- How long (seconds) between each -1 hunger point. Higher = slower drain.
-- Default is 8000.
s.tick = s.tick * 3

-- How much "exhaustion" (from moving/digging/etc) has to build up before
-- a hunger point is spent. Higher = slower drain from activity.
-- Default is 160.
s.exhaust_lvl = s.exhaust_lvl * 2

-- Optional: also soften how much exhaustion each action adds.
-- Comment any of these out if you want normal per-action cost but slower
-- overall drain (the two settings above already do most of the work).
s.exhaust_move = s.exhaust_move * 0.5   -- default 1.5
s.exhaust_dig = s.exhaust_dig * 0.5     -- default 3
s.exhaust_jump = s.exhaust_jump * 0.5   -- default 5

minetest.log("action", "[hunger_slow] Hunger drain slowed down " ..
	"(tick=" .. s.tick .. ", exhaust_lvl=" .. s.exhaust_lvl .. ")")
