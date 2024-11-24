SetKeyBinds {
  n = {
    ["<leader>ws"] = { "<CMD>WinShift<CR>", "winshift shift" },
    ["<leader>ww"] = { "<CMD>WinShift swap<CR>", "winshift shift swap" },
  },
}

local DisplayCenterText = require("utils.utils").DisplayCenterText
local ns_id = vim.api.nvim_create_namespace "WinShiftCenterText"
local api = vim.api

local function clear_prompt()
  vim.api.nvim_echo({ { "" } }, false, {})
  vim.cmd "redraw"
end

local function input_char(prompt, opt)
  opt = vim.tbl_extend("keep", opt or {}, {
    clear_prompt = true,
    allow_non_ascii = false,
    prompt_hl = nil,
  })

  if prompt then
    vim.api.nvim_echo({ { prompt, opt.prompt_hl } }, false, {})
  end

  local c
  if not opt.allow_non_ascii then
    while type(c) ~= "number" do
      c = vim.fn.getchar()
    end
  else
    c = vim.fn.getchar()
  end

  if opt.clear_prompt then
    clear_prompt()
  end

  local s = type(c) == "number" and vim.fn.nr2char(c) or nil
  local raw = type(c) == "number" and s or c

  ---@diagnostic disable-next-line: return-type-mismatch
  return s, raw
end

---@param opt WindowPickerSpec
local window_picker = function(opt)
  opt = opt or {}
  local tabpage = api.nvim_get_current_tabpage()
  local win_ids = api.nvim_tabpage_list_wins(tabpage)
  local curwin = api.nvim_get_current_win()
  local filter_rules = opt.filter_rules or {}

  local selectable = vim.tbl_filter(function(id)
    if filter_rules.cur_win and curwin == id then
      return false
    elseif filter_rules.floats and api.nvim_win_get_config(id).relative ~= "" then
      return false
    end

    local bufid = api.nvim_win_get_buf(id)
    local bufname = api.nvim_buf_get_name(bufid)

    for _, option in ipairs { "filetype", "buftype" } do
      if vim.tbl_contains(filter_rules[option] or {}, vim.bo[bufid][option]) then
        return false
      end
    end

    for _, pattern in ipairs(filter_rules.bufname or {}) do
      local regex = vim.regex(pattern)
      if regex:match_str(bufname) ~= nil then
        return false
      end
    end

    return true
  end, win_ids)

  if opt.filter_func then
    selectable = opt.filter_func(selectable)
  end

  -- If there are no selectable windows: return. If there's only 1, return it without picking.
  if #selectable == 0 then
    return -1
  end
  if #selectable == 1 then
    return selectable[1]
  end

  local chars = (opt.picker_chars or "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"):upper()
  local i = 1
  local win_map = {}

  -- Setup UI
  for _, id in ipairs(selectable) do
    local char = chars:sub(i, i)

    win_map[char] = id

    DisplayCenterText({
      " " .. char .. " ",
    }, id, ns_id, "WarningMsg", "Title")

    i = i + 1
    if i > #chars then
      break
    end
  end

  vim.cmd "redraw"
  local ok, resp = pcall(input_char, "Pick window: ", { prompt_hl = "ModeMsg" })
  vim.notify(vim.inspect(ok))
  vim.notify(vim.inspect(resp))
  if not ok then
    clear_prompt()
  end
  resp = (resp or ""):upper()

  -- Get a list of all open buffers
  local buffers = vim.api.nvim_list_bufs()

  -- Iterate through each buffer and clear the namespace
  for _, buf in ipairs(buffers) do
    vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
  end

  return win_map[resp]
end

local picker2 = function()
  return require("utils.nvim-window").pick()
end

return {
  "sindrets/winshift.nvim",
  cmd = "WinShift",
  config = function()
    require("winshift").setup {
      window_picker = function()
        return picker2()
        -- return window_picker {
        --   picker_chars = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        --   filter_rules = {
        --     cur_win = true,
        --     floats = true,
        --     filetype = {},
        --     buftype = {},
        --     bufname = {},
        --   },
        --   ---A function used to filter the list of selectable windows.
        --   ---@param winids integer[] # The list of selectable window IDs.
        --   ---@return integer[] filtered # The filtered list of window IDs.
        --   filter_func = nil,
        -- }
      end,
    }
  end,
}
