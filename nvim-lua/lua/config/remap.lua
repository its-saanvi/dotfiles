vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("x", "<leader>p", '"_dP')

--System-wide copy and paste registers by default.
vim.keymap.set("n", "y", '"+y')
vim.keymap.set("v", "y", '"+y')
vim.keymap.set("n", "Y", '"+Y')
vim.keymap.set("n", "p", '"+p')
vim.keymap.set("v", "p", '"+p')
vim.keymap.set("n", "P", '"+P')
vim.keymap.set("n", "d", '"+d')
vim.keymap.set("v", "d", '"+d')
vim.keymap.set("n", "D", '"+D')
vim.keymap.set("n", "c", '"+c')
vim.keymap.set("v", "c", '"+c')
vim.keymap.set("n", "C", '"+C')
vim.keymap.set("n", "x", '"+x')
vim.keymap.set("v", "x", '"+x')
vim.keymap.set("n", "X", '"+X')

if not vim.g.vscode then
	--Split remaps
	vim.keymap.set("n", "<C-H>", "<C-W><C-H>")
	vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
	vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
	vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
end

vim.keymap.set("t", "<leader><leader>", "<C-\\><C-n>", { desc = "Terminal - Go to normal mode" })
local term_win_id = nil

vim.keymap.set("n", "<leader>`", function()
	if term_win_id and vim.api.nvim_win_is_valid(term_win_id) then
		vim.api.nvim_set_current_win(term_win_id)
		vim.cmd("startinsert")
		return
	end

	vim.cmd("botright 15split")
	vim.cmd("terminal")
	vim.cmd("startinsert")

	term_win_id = vim.api.nvim_get_current_win()
end, { desc = "Terminal - Focus or open dedicated terminal window" })

if not vim.g.vscode then
	vim.keymap.set("n", "<leader>2", function()
		vim.cmd([[cn]])
	end, { desc = "Quickfix - Next Quickfix" })
	vim.keymap.set("n", "<leader>1", function()
		vim.cmd([[cp]])
	end, { desc = "Quickfix - Previous Quickfix" })
	vim.keymap.set("n", "<leader><Tab>", function()
		vim.cmd([[copen]])
	end, { desc = "Quickfix - Open Quickfix Window" })

	vim.keymap.set("n", "<leader><S-F>", function()
		local out = vim.fn.system({
			"find",
			vim.fn.expand("~/Desktop/Projects/"),
			"-mindepth",
			"1",
			"-maxdepth",
			"1",
			"-type",
			"d",
		})
		local full_project_names = vim.split(out, "\n")
		local projects = {}
		local project_names = {}
		for _, full_project_name in ipairs(full_project_names) do
			local project_name = vim.fn.fnamemodify(full_project_name, ":t")
			projects[project_name] = full_project_name
			table.insert(project_names, project_name)
		end

		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		pickers
			.new({}, {
				prompt_title = "Projects",
				finder = finders.new_table({
					results = project_names,
				}),
				sorter = conf.generic_sorter({}),
				attach_mappings = function()
					actions.select_default:replace(function(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						actions.close(prompt_bufnr)

						vim.schedule(function()
							if not selection then
								return
							end

							local project_name = selection.value
							local must_detach_old = string.find(vim.api.nvim_get_vvar("servername"), "-nvim.sock")
								== nil
							local full_project_name = projects[project_name]
							local socket = "/tmp/" .. project_name .. "-nvim.sock"

							if not (vim.uv or vim.loop).fs_stat(socket) then
								-- Spawn NEW nvim instance with server
								vim.fn.jobstart({
									"nvim",
									"--listen",
									socket,
									"--headless",
									"-c",
									"cd " .. full_project_name,
								}, { detach = true })
							end

							-- Small delay to allow server to start
							vim.defer_fn(function()
								if must_detach_old then
									vim.cmd("connect! " .. socket)
								else
									vim.cmd("connect " .. socket)
								end
							end, 100)
						end)
					end)
					return true
				end,
			})
			:find()
	end, { desc = "Projects - Switch to project" })
	vim.keymap.set("n", "<leader>d", vim.cmd.detach, { desc = "Projects - Detach from project" })
end
