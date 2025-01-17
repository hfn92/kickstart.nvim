local M = {}

function M:init()
  self.open = false
  self.buf = 0
  self.win = 0
end

---@param lines table<string, string>[]
function M:show(lines)
  if self.open then
    if vim.api.nvim_win_is_valid(self.win) then
      vim.api.nvim_win_close(self.win, true)
    end
    self.open = false
  end

  local buf = vim.api.nvim_create_buf(false, true)

  local l = { "" }
  local hl = { "TabNormal" }
  for _, value in ipairs(lines) do
    l[#l + 1] = value[1]
    hl[#hl + 1] = value[2]
  end

  l[#l + 1] = ""
  hl[#hl + 1] = "TabNormal"

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, l)

  for i, hl_group in ipairs(hl) do
    if hl_group then
      vim.api.nvim_buf_add_highlight(buf, -1, hl_group, i - 1, 0, -1)
    end
  end

  local width = 0
  for _, line in ipairs(l) do
    width = math.max(width, #line)
  end

  local height = #l

  local col = math.floor((vim.o.columns - width) / 2) -- Center horizontally

  local win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    width = width + 2,
    height = height,
    row = 5,
    col = col,
    style = "minimal",
    border = "none",
    focusable = false,
    zindex = 1000,
  })

  self.win = win
  self.open = true

  vim.api.nvim_set_option_value("winhl", "Normal:TelescopeBorder", { win = win })
  vim.api.nvim_set_option_value("winblend", 25, { win = win })

  vim.defer_fn(function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    self.open = false
  end, 2500)
end

local function list_buffers()
  local cwd = vim.fn.getcwd()
  local buffers = vim.api.nvim_list_bufs()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffer_list = {}

  for _, buf in ipairs(buffers) do
    if vim.bo[buf].buflisted then
      local buf_name = vim.api.nvim_buf_get_name(buf)
      local filename = vim.fn.fnamemodify(buf_name, ":t")
      if buf_name:sub(1, #cwd) == cwd then
        buf_name = buf_name:sub(#cwd + 2)
      end

      if buf_name == "" then
        filename = "[No Name]"
      end

      if buf == current_buf then
        table.insert(buffer_list, { filename, buf_name, "TabSelected" })
      else
        table.insert(buffer_list, { filename, buf_name, "TabNormal" })
      end
    end
  end

  return buffer_list
end

function M:show_buffers()
  local buffers = list_buffers()
  local max_name = 0
  for _, value in ipairs(buffers) do
    max_name = math.max(max_name, #value[1])
  end

  local t = {}

  for _, v in ipairs(buffers) do
    local entry = "   " .. v[1] .. string.rep(" ", max_name - #v[1]) .. "   " .. v[2]
    t[#t + 1] = { entry, v[3] }
  end

  self:show(t)
end

-- vim.keymap.set("n", "<TAB>", function()
--   vim.cmd "bnext"
--   M.show_buffers()
-- end, { desc = "Move focus to the upper window" })

return M
