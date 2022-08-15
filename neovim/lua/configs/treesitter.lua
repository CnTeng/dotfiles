local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	vim.notify("treesitter not found!", "error")
	return
end

treesitter.setup({
	ensure_installed = {
		"c",
		"cpp",
		"markdown",
		"go",
		"lua",
		"vim",
	},
	ignore_install = {},
	highlight = {
		enable = true,
		disable = {},
	},
	autopairs = { enable = true },
	incremental_selection = { enable = true },
	indent = {
		enable = true,
		disable = {},
	},
})
