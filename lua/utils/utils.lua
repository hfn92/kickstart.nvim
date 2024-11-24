local M = {}

function M.DisplayCenterText(lines, win, ns_id, hl_group, border_hl_group)
  local buf = vim.api.nvim_win_get_buf(win)
  local line_count = vim.api.nvim_buf_line_count(buf)

  -- Get window dimensions
  local width = vim.api.nvim_win_get_width(win)
  local height = vim.api.nvim_win_get_height(win)

  -- Determine the dimensions of the message
  local max_line_length = 0
  for _, line in ipairs(lines) do
    max_line_length = math.max(max_line_length, #line)
  end

  -- Calculate the border dimensions
  local box_width = max_line_length + 4 -- Add padding for border
  local box_height = #lines + 2 -- Add padding for border

  -- Get the first visible line in the window
  local first_visible_line = vim.fn.line("w0", win) - 1 -- Convert to 0-based index

  -- Calculate the center of the visible window
  local top_line = first_visible_line + math.floor((height - box_height) / 2)
  local left_col = math.floor((width - box_width) / 2)

  -- Create border lines
  local top_border = "┌" .. string.rep("─", box_width - 2) .. "┐"
  local bottom_border = "└" .. string.rep("─", box_width - 2) .. "┘"

  while (top_line + #lines + 1) > line_count do
    top_line = top_line - 1
    if top_line < first_visible_line then
      return
    end
  end

  -- Top border
  vim.api.nvim_buf_set_extmark(buf, ns_id, top_line, 0, {
    virt_text = { { top_border, border_hl_group or "Normal" } },
    virt_text_pos = "overlay",
    virt_text_win_col = left_col,
  })

  -- Content lines with side borders
  for i, line in ipairs(lines) do
    local padded_line = "│ " .. line .. string.rep(" ", box_width - #line - 3) .. "│"
    vim.api.nvim_buf_set_extmark(buf, ns_id, top_line + i, 0, {
      virt_text = { { padded_line, hl_group or "Normal" } },
      virt_text_pos = "overlay",
      virt_text_win_col = left_col,
    })
  end

  -- Bottom border
  vim.api.nvim_buf_set_extmark(buf, ns_id, top_line + #lines + 1, 0, {
    virt_text = { { bottom_border, border_hl_group or "Normal" } },
    virt_text_pos = "overlay",
    virt_text_win_col = left_col,
  })
end

return M
