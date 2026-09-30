return {
	"folke/snacks.nvim",
	opts = {
		indent = {
			indent = {
				char = "▏",
			},
			scope = {
				char = "▏",
			},
		},
	},
	keys = {
		{
			"<leader>/",
			LazyVim.pick("live_grep", { root = false }),
			desc = "Grep (cwd)",
		},
	},
}
