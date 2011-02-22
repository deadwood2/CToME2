--
-- Helper functions for magic powers
--

__magic_powers = {}

function add_magic(m)
	local i, ret

	if type(m.spell_list) ~= "table" then
		error("add_magic called without a table")
	end

	-- Ok iterate over all the powers to add
	local index, p, max

	-- First, count them
	max = 0
	for index, p in m.spell_list do
		max = max + 1
	end

	-- Now register it
	ret = {}
	i = new_magic_power(max)
	ret.spells = i
	ret.max = max
	ret.fail_fct = m.fail
	if m.stat then
		ret.stat = m.stat
	else
		ret.stat = A_INT
	end
	if m.get_level then
		ret.get_current_level = m.get_level
	else
		ret.get_current_level = function()
			return player.lev
		end
	end

	-- And add each spells
	max = 0
	ret.info = {}
	ret.spell = {}
	for index, p in m.spell_list do
		assert(p.name, "No name for the spell!")
		assert(p.desc, "No desc for the spell!")
		assert(p.mana, "No mana for the spell!")
		assert(p.level, "No level for the spell!")
		assert(p.fail, "No fail for the spell!")
		assert(p.info, "No info for the spell!")
		assert(p.spell, "No spell for the spell!")

		get_magic_power(i, max).name = p.name
		get_magic_power(i, max).desc = p.desc
		get_magic_power(i, max).mana_cost = p.mana
		get_magic_power(i, max).min_lev = p.level
		get_magic_power(i, max).fail = p.fail
		ret.info[max] = p.info
		ret.spell[max] = p.spell

		max = max + 1
	end

	return ret
end

function __get_magic_info(power)
	return __current_magic_power_info[power]()
end

-- Get the level of a power
function get_level_power(s, max, min)
	if not max then max = 50 end
	if not min then min = 1 end

	return value_scale(s.get_current_level(), 50, max, min)
end
