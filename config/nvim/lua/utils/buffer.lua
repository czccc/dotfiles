local M = {}

M.latest_buf_id = nil

function M.delete_buf(bufnr)
  if bufnr ~= nil then
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
end

function M.split(vertical, bufnr)
  local cmd = vertical and "vsplit" or "split"

  vim.cmd(cmd)
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, bufnr)
end

function M.resize(vertical, amount)
  local cmd = vertical and "vertical resize " or "resize"
  cmd = cmd .. amount

  vim.cmd(cmd)
end

M.output_in_buffer = function(command)
  if M.latest_buf_id ~= nil then
    vim.api.nvim_buf_delete(M.latest_buf_id, { force = true })
  end
  M.latest_buf_id = vim.api.nvim_create_buf(false, true)
  local header = {
    "------------------------------",
    "Command: " .. command,
    "------------------------------",
  }
  vim.api.nvim_buf_set_lines(M.latest_buf_id, 0, -1, false, header)
  vim.api.nvim_buf_set_option(M.latest_buf_id, "buftype", "nofile")
  vim.api.nvim_buf_set_option(M.latest_buf_id, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(M.latest_buf_id, "swapfile", false)
  vim.api.nvim_buf_set_option(M.latest_buf_id, "buflisted", false)
  vim.api.nvim_buf_set_keymap(M.latest_buf_id, "n", "<Esc>", ":q<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(M.latest_buf_id, "n", "q", ":q<CR>", { noremap = true, silent = true })

  M.split(false, M.latest_buf_id)

  local save_previous = vim.fn.getreg("a")
  vim.api.nvim_command("redir @a")
  vim.api.nvim_command("silent! " .. command)
  vim.api.nvim_command("redir END")
  local output = vim.split(vim.fn.getreg("a"), "\n")
  vim.fn.setreg("a", save_previous)
  vim.api.nvim_buf_set_lines(M.latest_buf_id, 3, -1, false, output)
end

return M
