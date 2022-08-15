local status_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
if not status_ok then
	vim.notify("mason_tool_installer not found!", "error")
	return
end

mason_tool_installer.setup({
	ensure_installed = {
		-- Formatter
		"stylua",
		"black",
		"prettier",
		"clang-format",
		"golines",
		"flake8",

		-- LSP
		"json-lsp",
		"lua-language-server",
		"clangd",
		"gopls",
		"pyright",
	},
	auto_update = true,
	run_on_start = true,
	start_delay = 3000,  -- 3 second delay
})
