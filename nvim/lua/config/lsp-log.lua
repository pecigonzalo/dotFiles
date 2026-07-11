local MAX_LOG_BYTES = 10 * 1024 * 1024

local function trim_log(path)
  local stat = vim.uv.fs_stat(path)
  if not stat or stat.size <= MAX_LOG_BYTES then return end

  local input = io.open(path, "rb")
  if not input then return end

  input:seek("end", -MAX_LOG_BYTES)
  local contents = input:read(MAX_LOG_BYTES)
  input:close()
  if not contents then return end

  local first_newline = contents:find("\n")
  if first_newline and first_newline <= 4096 then contents = contents:sub(first_newline + 1) end

  local temporary_path = path .. ".tmp"
  local output = io.open(temporary_path, "wb")
  if not output then return end

  output:write(contents)
  output:close()

  if not vim.uv.fs_rename(temporary_path, path) then vim.uv.fs_unlink(temporary_path) end
end

vim.lsp.log.set_level(vim.log.levels.WARN)
trim_log(vim.lsp.log.get_filename())
