local M = {}

function M.load_queries()
  vim.schedule_wrap(function()
    local scan = require "plenary.scandir"
    local path = require "plenary.path"
    local dbh_path = path:new "./tools/queries/"
    local paths = {}
    if dbh_path:exists() then
      local files = scan.scan_dir(dbh_path.filename, { depth = 1, only_dirs = true })
      for _, v in ipairs(files) do
        paths[#paths + 1] = v
      end
    end

    local result = {}

    for _, v in ipairs(paths) do
      local lang = vim.fn.fnamemodify(v, ":t")
      local files = scan.scan_dir(v, { depth = 1 })
      for _, file in ipairs(files) do
        local filename = vim.fn.fnamemodify(file, ":t")
        local name, extension = filename:match "(.+)%.([^%.]+)$"

        if extension == "scm" then
          result[#result + 1] = {
            lang = lang,
            type = name,
            data = path:new(file):read(),
          }
          vim.notify(("[%s] loading treesitter extensions: '%s'"):format(lang, name))
        end
      end
    end

    local query = require "vim.treesitter.query"
    for _, v in ipairs(result) do
      query.set(v.lang, v.type, v.data)
    end
  end)()
end

return M
