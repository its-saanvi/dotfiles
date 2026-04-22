return {
	"its-saanvi/sessionizer.nvim",
	-- dir = "~/Desktop/Projects/sessionizer.nvim",
	name = "sessionizer",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		project_sources = { "~/Desktop/Projects" },
		hooks = {
			post_connect_hook = function()
				vim.cmd("Cord enable")
			end,
			pre_detach_hook = function()
				vim.cmd("Cord disable")
			end,
		},
	},
}
