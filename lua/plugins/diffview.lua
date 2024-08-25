function GitDiffRange(from, to)
  if from and to then
    vim.cmd("DiffviewOpen " .. to .. ".." .. from)
  end

  local commits = vim.fn.systemlist "git log --oneline"

  if not from then
    return vim.ui.select(
      commits,
      { prompt = "Select commit 1" },
      vim.schedule_wrap(function(_, idx)
        if not idx then
          return
        end
        GitDiffRange(commits[idx]:match "^%w+", to)
      end)
    )
  end

  if not to then
    return vim.ui.select(
      commits,
      { prompt = "Select commit 2" },
      vim.schedule_wrap(function(_, idx)
        if not idx then
          return
        end
        GitDiffRange(from, commits[idx]:match "^%w+")
      end)
    )
  end
end

function GitDiffBranch(from, to)
  if from and to then
    vim.cmd("DiffviewOpen " .. to .. ".." .. from)
  end

  local commits = vim.fn.systemlist [[git branch -a --format '%(refname:short)']]
  table.insert(commits, 1, "HEAD")

  if not from then
    return vim.ui.select(
      commits,
      { prompt = "Select branch 1" },
      vim.schedule_wrap(function(_, idx)
        if not idx then
          return
        end
        GitDiffBranch(commits[idx], to)
      end)
    )
  end

  if not to then
    return vim.ui.select(
      commits,
      { prompt = "Select branch 2" },
      vim.schedule_wrap(function(_, idx)
        if not idx then
          return
        end
        GitDiffBranch(from, commits[idx])
      end)
    )
  end
end

return {
  "sindrets/diffview.nvim",
  config = function()
    require("diffview").setup { view = { merge_tool = { layout = "diff3_mixed" } } }

    SetKeyBinds {
      n = {
        ["<leader>gl"] = { "<cmd>LazyGit<CR>", "LazyGit" },
        ["<leader>gv"] = { "<cmd>DiffviewOpen<CR>", "Open diff view" },
        ["<leader>gc"] = { "<cmd>DiffviewClose<CR>", "Close diff view" },
        ["<leader>gh"] = { "<cmd>DiffviewFileHistory %<CR>", "git history" },
        ["<leader>gdr"] = { "<cmd>lua GitDiffRange()<CR>", "git diff range" },
        ["<leader>gdb"] = { "<cmd>lua GitDiffBranch()<CR>", "git diff branch" },
      },
    }
  end,
  lazy = false,
}
