return {
  name = "Conan install Debug",
  builder = function()
    local path = require "plenary.path"
    local b_path = path:new "./build/"
    if not b_path:exists() then
      b_path:mkdir()
    end

    b_path = path:new "./build/Debug"
    if not b_path:exists() then
      b_path:mkdir()
    end
    -- Full path to current file (see :help expand())
    return {
      cmd = { "conan" },
      -- "-s zlib:build_type=Release"
      args = {
        "install",
        "-of",
        ".",
        "../..",
        "-s",
        "build_type=Debug",
        "--build=missing",
        "-s",
        "lz4:build_type=Release",
        "-s",
        "compressonator:build_type=Release",
        "-s",
        "assimp:build_type=RelWithDebInfo",
        "-s",
        "gli:build_type=RelWithDebInfo",
      },
      cwd = "./build/Debug",
      components = { { "on_output_quickfix", open_on_exit = "failure" }, "default" },
    }
  end,
}
