local M = require("utils.fn")

-- vim.tbl_deep_extend("force", M, require("utils.fn"))

M.buffer = require("utils.buffer")
M.colors = require("utils.colors")
M.headers = require("utils.headers")
M.icons = require("utils.icons")
M.lsp = require("utils.lsp")
M.telescope = require("utils.telescope")

return M
