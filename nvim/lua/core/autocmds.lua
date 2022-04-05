local M = {}
local Log = require "core.log"

M.autocommands = {
  general_settings = {
    { "VimResized", "*", "tabdo wincmd =" },
    { "CursorHold", "* checktime" },
    {
      "TextYankPost",
      "*",
      "lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 200})",
    },
    {
      "BufWinEnter,BufRead,BufNewFile",
      "*",
      "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
    },
  },
  file_setting = {
    { "FileType", "markdown,gitcommit", "setlocal spell wrap" },
  },
  buffer_quit = {
    { "FileType", "alpha,floaterm", "nnoremap <silent> <buffer> q :q<CR>" },
    { "FileType", "qf,help,man", "nnoremap <silent> <buffer> q :close<CR>" },
    { "FileType", "lspinfo,lsp-installer,null-ls-info", "nnoremap <silent> <buffer> q :close<CR>" },
  },
  buffer_setting = {
    { "TermOpen", "*", "setlocal nonumber norelativenumber" },
    { "FileType", "qf", "set nobuflisted" },
    { "FileType", "Outline", "setlocal signcolumn=no nowrap" },
    { "user", "TelescopePreviewerLoaded", "setlocal number relativenumber wrap list" },
    {
      "BufWinEnter",
      "dashboard",
      "setlocal cursorline signcolumn=yes cursorcolumn number",
    },
  },
}

M.format_on_save = {
  pattern = "*",
  timeout = 1000,
}

M.setup = function()
  M.define_augroups(M.autocommands)
  M.configure_format_on_save()
end

function M.disable_augroup(name)
  vim.schedule(function()
    if vim.fn.exists("#" .. name) == 1 then
      vim.cmd("augroup " .. name)
      vim.cmd "autocmd!"
      vim.cmd "augroup END"
    end
  end)
end

function M.define_augroups(definitions, buffer)
  for group_name, definition in pairs(definitions) do
    vim.cmd("augroup " .. group_name)
    if buffer then
      vim.cmd [[autocmd! * <buffer>]]
    else
      vim.cmd [[autocmd!]]
    end

    for _, def in pairs(definition) do
      local command = table.concat(vim.tbl_flatten { "autocmd", def }, " ")
      vim.cmd(command)
    end

    vim.cmd "augroup END"
  end
end

local get_format_on_save_opts = function()
  local defaults = {
    pattern = "*",
    timeout = 1000,
  }
  if type(M.format_on_save) ~= "table" then
    return defaults
  end
  return {
    pattern = M.format_on_save.pattern or defaults.pattern,
    timeout = M.format_on_save.timeout or defaults.timeout,
  }
end

function M.enable_format_on_save(opts)
  local fmd_cmd = string.format(":silent lua vim.lsp.buf.formatting_sync({}, %s)", opts.timeout)
  M.define_augroups {
    format_on_save = { { "BufWritePre", opts.pattern, fmd_cmd } },
  }
  Log:debug "enabled format-on-save"
end

function M.disable_format_on_save()
  M.disable_augroup "format_on_save"
  Log:debug "disabled format-on-save"
end

function M.configure_format_on_save()
  if M.format_on_save then
    local opts = get_format_on_save_opts()
    M.enable_format_on_save(opts)
  else
    M.disable_format_on_save()
  end
end

function M.toggle_format_on_save()
  if vim.fn.exists "#format_on_save#BufWritePre" == 0 then
    local opts = get_format_on_save_opts()
    M.enable_format_on_save(opts)
  else
    M.disable_format_on_save()
  end
end

function M.enable_lsp_document_highlight(client_id)
  M.define_augroups({
    lsp_document_highlight = {
      {
        "CursorHold",
        "<buffer>",
        string.format("lua require('plugins.lsp.utils').conditional_document_highlight(%d)", client_id),
      },
      {
        "CursorMoved",
        "<buffer>",
        "lua vim.lsp.buf.clear_references()",
      },
    },
  }, true)
end

function M.disable_lsp_document_highlight()
  M.disable_augroup "lsp_document_highlight"
end

function M.enable_code_lens_refresh()
  M.define_augroups({
    lsp_code_lens_refresh = {
      {
        "InsertLeave ",
        "<buffer>",
        "lua vim.lsp.codelens.refresh()",
      },
      {
        "InsertLeave ",
        "<buffer>",
        "lua vim.lsp.codelens.display()",
      },
    },
  }, true)
end

function M.disable_code_lens_refresh()
  M.disable_augroup "lsp_code_lens_refresh"
end


return M
