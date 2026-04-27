local waywall = require("waywall")
local helpers = require("waywall.helpers")
local utils = require("utils")

local M = {}

--- @param custom CustomOpts
--- @return nil
M.exec_ninb = function(custom)
	helpers.toggle_floating()
	if waywall.floating_shown() then
		custom.mirrors.fire_res_mirror(true)
	else
		custom.mirrors.fire_res_mirror(false)
	end
	if not utils.is_ninb_running() then
		waywall.exec("java -jar " .. custom.ninb_path)
	end
end

--- @param custom CustomOpts
--- @return nil
M.show_ninb = function(custom)
	if not utils.is_ninb_running() then
		waywall.exec("java -jar " .. custom.ninb_path)
	end
	if not waywall.floating_shown() then
		custom.mirrors.fire_res_mirror(true)
		waywall.show_floating(true)
	end
end

--- @param custom CustomOpts
--- @return nil
M.hide_ninb = function(custom)
	if waywall.floating_shown() then
		waywall.show_floating(false)
	end
end

--- @param custom CustomOpts
--- @return nil
M.remaps_set = function(custom)
	waywall.set_remaps(custom.input.remaps)
	waywall.set_keymap({ layout = custom.input.layout.primary })
end

--- @param custom CustomOpts
--- @return nil
M.remaps_unset = function(custom)
	waywall.set_remaps({})
	waywall.set_keymap({ layout = custom.input.layout.secondary })
end

--- @param custom CustomOpts
--- @return nil
M.exec_tmpfs_clear = function(custom)
	waywall.exec("bash " .. custom.tmpfs_clear_path)
end

--- @param custom CustomOpts
--- @param state State
--- @return nil
M.thin_enable = function(custom, state)
	utils.show_mirrors(custom, false, true, false, true)
end

--- @param custom CustomOpts
--- @param state State
--- @return nil
M.tall_enable = function(custom, state)
	if not state.tall_after_thin then
		waywall.set_sensitivity(custom.input.sensitivity.tall)
		M.show_ninb(custom)
		utils.show_mirrors(custom, true, true, true, false)
	else
		state.tall_after_thin = false
		utils.show_mirrors(custom, false, true, true, false)
	end
end

--- @param custom CustomOpts
--- @param state State
--- @return nil
M.tall_enable_pre = function(custom, state)
	local active_width, active_height = waywall.active_res()
	if active_width == 330 and active_height == 1000 then
		state.tall_after_thin = true
	end
end

--- @param custom CustomOpts
--- @param state State
--- @return nil
M.wide_enable = function(custom, state)
	utils.show_mirrors(custom, false, false, false, false)
end

--- @param custom CustomOpts
--- @param state State
--- @return nil
M.tall_disable = function(custom, state)
	waywall.set_sensitivity(custom.input.sensitivity.normal)
	utils.show_mirrors(custom, false, false, false, false)
end

--- @param custom CustomOpts
--- @param state State
--- @return nil
M.generic_disable = function(custom, state)
	utils.show_mirrors(custom, false, false, false, false)
end

--- @param custom CustomOpts
--- @param state State
--- @return nil
M.startup_mirrors = function(custom, state)
	for _, v in pairs(custom.startup_mirrors) do
		v(true)
	end
end

return M
