local M = {}
local path = require "utils.path"
local Log = require "core.log"

function M.init_packer()
  local install_path = path.pack_install_dir
  local package_root = path.pack_dir
  local compile_path = path.pack_compile_path
  local in_headless = #vim.api.nvim_list_uis() == 0

  -- local github_proxy = "https://hub.fastgit.xyz/"
  -- local github_proxy = "git@github.com:"
  local github_proxy = "https://ghproxy.com/https://github.com/"

  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system { "git", "clone", "--depth", "1", github_proxy .. "wbthomason/packer.nvim", install_path }
    vim.cmd "packadd packer.nvim"
  end

  local log_level = in_headless and "debug" or Log.config.level

  local _, packer = pcall(require, "packer")
  packer.init {
    package_root = package_root,
    compile_path = compile_path,
    log = { level = log_level },
    git = {
      clone_timeout = 300,
      subcommands = {
        -- this is more efficient than what Packer is using
        fetch = "fetch --no-tags --no-recurse-submodules --update-shallow --progress",
      },
      default_url_format = github_proxy .. "%s",
    },
    max_jobs = 50,
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end,
    },
  }
end

function M.init()
  M.init_packer()
  -- require("plugins").init()
end

function M.setup()
  M.load(require("plugins").packers)
  require("plugins").setup()
end

function M.reload()
  require("plugins").config()
  M.load(require("plugins").packers)
  require("plugins").setup()
end

function M.load(configurations)
  configurations = configurations or {}
  Log:debug "loading plugins configuration"
  local packer_available, packer = pcall(require, "packer")
  if not packer_available then
    Log:warn "skipping loading plugins until Packer is installed"
    return
  end
  local status_ok, _ = xpcall(function()
    packer.startup(function(use)
      use { "wbthomason/packer.nvim" }
      for _, plugin in pairs(configurations) do
        use(plugin)
      end
    end)
  end, debug.traceback)
  if not status_ok then
    Log:warn "problems detected while loading plugins' configurations"
    Log:trace(debug.traceback())
  end
  require("core.colors").setup()
end

return M
