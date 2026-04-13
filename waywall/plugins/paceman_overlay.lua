local cfg = {
	username = "Its_Saanvi",
	look = {
		X = 300,
		Y = 700,
		color = "#ffffff",
		bold = true,
		size = 4,
	},

	info = {
		{ tag = "", enabled = false, key = "nether" },
		{ tag = "Bastions", enabled = false, key = "bastion" },
		{ tag = "Fortresses", enabled = false, key = "fortress" },
		{ tag = "First Structures", enabled = false, key = "first_structure" },
		{ tag = "Second Structures", enabled = false, key = "second_structure" },
		{ tag = "First Portals", enabled = false, key = "first_portal" },
		{ tag = "Strongholds", enabled = false, key = "stronghold" },
		{ tag = "End Enters", enabled = false, key = "end" },
		{ tag = "Completions", enabled = false, key = "finish" },
	},
}

return {
	url = "https://github.com/arjuncgore/ww_paceman_overlay",
	enabled = false,
	config = function(config)
		require("paceman_overlay.init").setup(config, cfg)
	end,
	dependencies = {
		{
			url = "https://github.com/arjuncgore/ww_requests",
			name = "ww_requests",
		},
	},
	name = "paceman_overlay",
	update_on_load = false,
}
