-- Bootstrap plug.waywall
local plug_repo = "https://github.com/its-saanvi/plug.waywall"
local waywall_share = os.getenv("XDG_DATA_HOME") or (os.getenv("HOME") .. "/.local/share") .. "/waywall"
local plug_path = waywall_share .. "/plug"
local file, err = io.open(plug_path .. "/.check_temp", "w")
if not file and err then
	if string.find(err, "No such file or directory") then
		if not os.execute("mkdir -p " .. waywall_share) then
			print("Failed to create waywall share directory")
		end
		if not os.execute("git clone " .. plug_repo .. " " .. plug_path) then
			print("Failed to clone plug.waywall")
		end
	end
else
	file:close()
	os.remove(plug_path .. "/.check_temp")
end
package.path = package.path .. ";" .. waywall_share .. "/?/init.lua" .. ";" .. plug_path .. "/?.lua"

local plug = require("plug")
local utils = require("utils")
local callbacks = require("callbacks")
local waywall = require("waywall")

--- @type State
local state = {
	tall_after_thin = false,
}

--- @type string?
local user = os.getenv("USER")

--- @type CustomOpts
local custom = {
	input = {
		sensitivity = {
			normal = 6,
			tall = 0.25,
		},
		remaps = {
			["mouse3"] = "rightshift",
			["mouse4"] = "BackSpace",
			["mouse5"] = "Home",
		},
		layout = {
			primary = "usnw",
			secondary = "us",
		},
		confine_pointer = false,
		repeat_delay = 185,
		repeat_rate = 45,
	},
	mirrors = {
		eye_measure = utils.make_mirror({
			src = { x = 162, y = 7902, w = 60, h = 580 },
			dst = { x = 0, y = 315, w = 768, h = 450 },
		}),
		f3_ecount = utils.make_mirror({
			src = { x = 0, y = 36, w = 50, h = 11 },
			dst = { x = 1308, y = 560, w = 240, h = 44 },
			color_key = {
				input = "#dddddd",
				output = "#ffffff",
			},
		}),
		thin_pie_blockentities = utils.make_mirror({
			src = { x = 0, y = 595, w = 330, h = 180 },
			dst = { x = 1150, y = 600, w = 500, h = 200 },
			color_key = {
				input = "#ec6e4e",
				output = "#f25d38",
			},
		}),
		thin_pie_blockentities_percent = utils.make_mirror({
			src = { x = 235, y = 779, w = 37, h = 17 },
			dst = { x = 1308, y = 784, w = 185, h = 100 },
			color_key = {
				input = "#E96D4D",
				output = "#FFFFFF",
			},
		}),
		thin_pie_unspecified = utils.make_mirror({
			src = { x = 0, y = 595, w = 330, h = 180 },
			dst = { x = 1150, y = 600, w = 500, h = 200 },
			color_key = {
				input = "#46CE66",
				output = "#3eb85b",
			},
		}),
		thin_pie_entities = utils.make_mirror({
			src = { x = 0, y = 595, w = 330, h = 180 },
			dst = { x = 1150, y = 600, w = 500, h = 200 },
			color_key = {
				input = "#E446C4",
				output = "#2e3440",
			},
		}),
		thin_pie_destroyProgress = utils.make_mirror({
			src = { x = 0, y = 595, w = 330, h = 180 },
			dst = { x = 1150, y = 600, w = 500, h = 200 },
			color_key = {
				input = "#CC6C46",
				output = "#2e3440",
			},
		}),
		thin_pie_prepare = utils.make_mirror({
			src = { x = 0, y = 595, w = 330, h = 180 },
			dst = { x = 1150, y = 600, w = 500, h = 200 },
			color_key = {
				input = "#464C46",
				output = "#2e3440",
			},
		}),
		tall_pie_blockentities = utils.make_mirror({
			src = { x = 44, y = 15978, w = 350, h = 178 },
			dst = { x = 1150, y = 600, w = 500, h = 200 },
			color_key = {
				input = "#ec6e4e",
				output = "#f25d38",
			},
		}),
		tall_pie_blockentities_percent = utils.make_mirror({
			src = { x = 291, y = 16163, w = 33, h = 25 },
			dst = { x = 1308, y = 784, w = 185, h = 100 },
			color_key = {
				input = "#E96D4D",
				output = "#FFFFFF",
			},
		}),
		tall_pie_unspecified = utils.make_mirror({
			src = { x = 44, y = 15978, w = 350, h = 178 },
			dst = { x = 1150, y = 600, w = 500, h = 200 },
			color_key = {
				input = "#46CE66",
				output = "#3eb85b",
			},
		}),
		tall_pie_entities = utils.make_mirror({
			src = { x = 44, y = 15978, w = 350, h = 178 },
			dst = { x = 1150, y = 600, w = 500, h = 200 },
			color_key = {
				input = "#E446C4",
				output = "#2e3440",
			},
		}),
		tall_pie_destroyProgress = utils.make_mirror({
			src = { x = 44, y = 15978, w = 350, h = 178 },
			dst = { x = 1150, y = 600, w = 500, h = 200 },
			color_key = {
				input = "#CC6C46",
				output = "#2e3440",
			},
		}),
		tall_pie_prepare = utils.make_mirror({
			src = { x = 44, y = 15978, w = 350, h = 178 },
			dst = { x = 1150, y = 600, w = 500, h = 200 },
			color_key = {
				input = "#464C46",
				output = "#2e3440",
			},
		}),
		fire_res_mirror = utils.make_mirror({
			src = { x = 1820, y = 5, w = 95, h = 98 },
			dst = { x = 1340, y = 998, w = 80, h = 80 },
		}),
	},
	startup_mirrors = {},
	shaders = {},
	images = {
		overlay = utils.make_image({
			src = "/home/" .. user .. "/MCSR/overlay.png",
			dst = { x = 0, y = 315, w = 768, h = 450 },
		}),
	},
	resolutions = {
		thin = {
			w = 330,
			h = 1000,
			enable_pre = callbacks.thin_enable,
			enable_post = nil,
			disable_pre = nil,
			disable_post = callbacks.generic_disable,
		},
		tall = {
			w = 384,
			h = 16384,
			enable_pre = callbacks.tall_enable_pre,
			enable_post = callbacks.tall_enable,
			disable_pre = nil,
			disable_post = callbacks.tall_disable,
		},
		wide = {
			w = 1920,
			h = 320,
			enable_pre = nil,
			enable_post = callbacks.wide_enable,
			disable_pre = nil,
			disable_post = callbacks.generic_disable,
		},
	},
	theme = {
		background = "#23273b",
		ninb_anchor = "topright",
		cursor_theme = "Adwaita-MC",
	},
	experimental = {
		jit = true,
		tearing = false,
	},
	ninb_path = "/home/" .. user .. "/Downloads/NinjaBrain/Ninjabrain-Bot-1.5.2.jar",
	tmpfs_clear_path = "/home/" .. user .. "/MCSR/tmpfs_clear.sh",
}

--- @type table<string, fun(): nil>
local resolutions = {}

for k, v in pairs(custom.resolutions) do
	resolutions[k] = utils.make_res(v.w, v.h, {
		enable_pre = utils.wrap_function_with_custom_and_state(v.enable_pre, custom, state),
		enable_post = utils.wrap_function_with_custom_and_state(v.enable_post, custom, state),
		disable_pre = utils.wrap_function_with_custom_and_state(v.disable_pre, custom, state),
		disable_post = utils.wrap_function_with_custom_and_state(v.disable_post, custom, state),
	})
end

local config = {
	input = {
		layout = custom.input.layout.primary,
		sensitivity = custom.input.sensitivity.normal,
		confine_pointer = custom.input.confine_pointer,
		remaps = custom.input.remaps,
		repeat_delay = custom.input.repeat_delay,
		repeat_rate = custom.input.repeat_rate,
	},
	shaders = custom.shaders,
	theme = custom.theme,
	experimental = custom.experimental,
}

waywall.listen("load", function()
	callbacks.startup_mirrors(custom, state)
end)

config.actions = {
	-- eye
	["J"] = resolutions.tall,
	-- thin
	["*-grave"] = resolutions.thin,
	-- wide
	["*-6"] = resolutions.wide,

	-- ninb bot
	["Shift-7"] = utils.wrap_function_with_custom(callbacks.exec_ninb, custom),
	["*-comma"] = utils.wrap_function_with_custom(callbacks.hide_ninb, custom),
	-- ["J"] = toggle_floating,

	-- tmpfs clear
	["Ctrl-Alt-C"] = utils.wrap_function_with_custom(callbacks.exec_tmpfs_clear, custom),

	-- remaps
	["Ctrl-R"] = utils.wrap_function_with_custom(callbacks.remaps_set, custom),
	["Alt-R"] = utils.wrap_function_with_custom(callbacks.remaps_unset, custom),

	-- misc
	-- ["m1"] = atum_reset
}

plug.setup({
	dir = "plugins",
	config = config,
	log_level = "debug",
})

return config
