local M = {}

M.configs = {
    colorscheme = "default",
}

M.recoad = function(name, conf)
    M.configs[name] = conf
end

M.export = function()
    return M.configs
end

return M