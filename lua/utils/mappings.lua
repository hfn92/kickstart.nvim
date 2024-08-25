---@alias Mode
---| "n"
---| "v"
---| "i"

---@diagnostic disable-next-line: duplicate-doc-alias
---@alias KeyMapData table<Mode, table>

---@param data KeyMapData
local function load(data)
  for mode, v in pairs(data) do
    for key, data in pairs(v) do
      local opts = data.opts and data.opts or {}
      opts.desc = data[2]
      vim.keymap.set(mode, key, data[1], opts)
    end
  end
end

return load
