-- Shared ktlint launch settings for conform (formatting) and nvim-lint (linting).
--
-- ktlint runs on the JVM, and starting it takes most of the time per run. Instead of
-- Mason's launcher script (which starts Java once just to check the version), run the
-- jar directly with:
--   -XX:TieredStopAtLevel=1: only the fast JIT compiler, since every run is short
--   AppCDS archive: caches loaded classes in a file the JVM maps in on later runs.
--                   Recreated automatically when the JDK or ktlint changes.
-- Measured ~0.5s per run instead of ~1.4s.
local M = {}

-- Used for properties that the project's own .editorconfig does not set
M.default_editorconfig = vim.fn.stdpath("config") .. "/lua/haug1/config/ktlint/defaults.editorconfig"

local jar = vim.fn.stdpath("data") .. "/mason/packages/ktlint/ktlint"

-- Same as Mason's launcher: on Java 24+ the Kotlin compiler inside ktlint triggers
-- sun.misc.Unsafe warnings on stderr, which nvim-lint reads ktlint's JSON from.
local java_version
local function java_major_version()
  if not java_version then
    local out = vim.fn.system({ "java", "-version" })
    java_version = tonumber(out:match('version "(%d+)')) or 0
  end
  return java_version
end

--- Command and leading args for running ktlint. `name` keeps a separate class archive per
--- use, so formatting and linting never write the same archive at the same time.
---@param name string
---@return string cmd, string[] args
function M.command(name)
  if vim.fn.executable("java") ~= 1 or vim.fn.filereadable(jar) ~= 1 then
    return "ktlint", {}
  end
  local archive = vim.fn.stdpath("cache") .. "/ktlint-" .. name .. ".jsa"
  local args = {
    "-Xmx512m",
    "-XX:TieredStopAtLevel=1",
    "-XX:+AutoCreateSharedArchive",
    "-XX:SharedArchiveFile=" .. archive,
    -- The JVM logs archive warnings to stdout, which would end up in the formatted code
    "-Xlog:disable",
    "-Xlog:all=error:stderr",
  }
  if java_major_version() >= 24 then
    table.insert(args, "--sun-misc-unsafe-memory-access=allow")
  end
  vim.list_extend(args, { "-jar", jar })
  return "java", args
end

return M
