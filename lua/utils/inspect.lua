local M = {}

function M.show_pos(bufnr, row, col, filter)
  local items = vim.inspect_pos(bufnr, row, col, filter)

  local lines = { {} }

  local function append(str, hl)
    table.insert(lines[#lines], { str, hl })
  end

  local function nl()
    table.insert(lines, {})
  end

  local function item(data, comment)
    append "  - "
    append(data.hl_group, data.hl_group)
    append " "
    if data.hl_group ~= data.hl_group_link then
      append("links to ", "MoreMsg")
      append(data.hl_group_link, data.hl_group_link)
      append "   "
    end
    if comment then
      append(comment, "Comment")
    end
    nl()
  end

  -- treesitter
  if #items.treesitter > 0 then
    append("Treesitter", "Title")
    nl()
    for _, capture in ipairs(items.treesitter) do
      item(
        capture,
        string.format(
          "priority: %d   language: %s",
          capture.metadata.priority or vim.highlight.priorities.treesitter,
          capture.lang
        )
      )
    end
    nl()
  end

  -- semantic tokens
  if #items.semantic_tokens > 0 then
    append("Semantic Tokens", "Title")
    nl()
    local sorted_marks = vim.fn.sort(items.semantic_tokens, function(left, right)
      local left_first = left.opts.priority < right.opts.priority
        or left.opts.priority == right.opts.priority and left.opts.hl_group < right.opts.hl_group
      return left_first and -1 or 1
    end)
    for _, extmark in ipairs(sorted_marks) do
      item(extmark.opts, "priority: " .. extmark.opts.priority)
    end
    nl()
  end

  -- syntax
  if #items.syntax > 0 then
    append("Syntax", "Title")
    nl()
    for _, syn in ipairs(items.syntax) do
      item(syn)
    end
    nl()
  end

  -- extmarks
  if #items.extmarks > 0 then
    append("Extmarks", "Title")
    nl()
    for _, extmark in ipairs(items.extmarks) do
      if extmark.opts.hl_group then
        item(extmark.opts, extmark.ns)
      else
        append "  - "
        append(extmark.ns, "Comment")
        nl()
      end
    end
    nl()
  end

  if #lines[#lines] == 0 then
    table.remove(lines)
  end

  local chunks = {}
  for _, line in ipairs(lines) do
    vim.list_extend(chunks, line)
    table.insert(chunks, { "\n" })
  end
  if #chunks == 0 then
    chunks = {
      {
        "No items found at position " .. items.row .. "," .. items.col .. " in buffer " .. items.buffer,
      },
    }
  end
  vim.api.nvim_echo(chunks, true, {})
  -- vim.notify(vim.inspect(chunks), true), true
  -- vim.notify
end

return M
