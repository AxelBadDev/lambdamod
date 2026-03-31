--[[
   * Copyleft 2026 hedv948-source
--]]
-- YourLocalCappy filesystem as extension
fs = fs or {}

local function safe_open(path, mode)
    local ok, file = pcall(io.open, path, mode)
    if not ok then
        return nil
    end
    return file
end

---@param fn function
---@return boolean
local function safe_call(fn)
    return pcall(fn)
end

---@param path string
---@return boolean
function fs.Exists(path)
    local file = safe_open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

---@param path string
---@return string|nil
function fs.Read(path)
    if filesystem and filesystem.Open then
        local file = filesystem.Open(path, "r", "MOD")
        if not file then
            return nil
        end

        local size = filesystem.Size(file)
        if not size or size <= 0 then
            filesystem.Close(file)
            return ""
        end

        local _, data = filesystem.Read(size, file)
        filesystem.Close(file)
        return data
    end

    local file = safe_open(path, "r")
    if not file then
        return nil
    end
    local content = file:read("*a")
    file:close()
    return content
end

---@param path string
---@param content string?
---@return boolean
function fs.Write(path, content)
    local file = safe_open(path, "w")
    if not file then
        return false
    end
    file:write(content or "")
    file:close()
    return true
end

---@param path string
---@param content string?
---@return boolean
function fs.Append(path, content)
    local file = safe_open(path, "a")
    if not file then
        return false
    end
    file:write(content or "")
    file:close()
    return true
end

---@param path string
---@return string[]|nil
function fs.ReadLines(path)
    local file = safe_open(path, "r")
    if not file then
        return nil
    end
    local lines = {}
    for line in file:lines() do
        lines[#lines + 1] = line
    end
    file:close()
    return lines
end

---@param path string
---@param lines string[]
---@return boolean
function fs.WriteLines(path, lines)
    local file = safe_open(path, "w")
    if not file then
        return false
    end
    for i = 1, #lines do
        file:write(lines[i], "\n")
    end
    file:close()
    return true
end

---@param path string
---@return integer|nil
function fs.Size(path)
    local file = safe_open(path, "r")
    if not file then
        return nil
    end
    local size = file:seek("end")
    file:close()
    return size
end

---@param path string
---@return boolean
function fs.IsEmpty(path)
    local size = fs.Size(path)
    return size == 0
end

---@param path string
---@return boolean
function fs.Delete(path)
    return safe_call(
        function()
            os.remove(path)
        end
    )
end

---@param from string
---@param to string
---@return boolean
function fs.Move(from, to)
    return safe_call(
        function()
            os.rename(from, to)
        end
    )
end

---@param from string
---@param to string
---@return boolean
function fs.Copy(from, to)
    local content = fs.Read(from)
    if not content then
        return false
    end
    return fs.Write(to, content)
end

---@param path string
---@return boolean
function fs.Touch(path)
    if fs.Exists(path) then
        return true
    end
    return fs.Write(path, "")
end

---@param path string
---@return boolean
function fs.MakeDir(path)
    return safe_call(
        function()
            os.execute('mkdir "' .. path .. '"') -- @hedv948-source: ThePixelMoon please patch this
        end
    )
end

---@param path string
---@return boolean
function fs.RemoveDir(path)
    return safe_call(
        function()
            os.execute('rmdir "' .. path .. '"')
        end
    )
end

function fs.IsWindows()
    return package.config:sub(1, 1) == "\\"
end

function fs.Join(base, relative)
    if base:sub(-1) == "/" or base:sub(-1) == "\\" then
        return base .. relative
    end
    if fs.IsWindows() then
        return base .. "\\" .. relative
    end
    return base .. "/" .. relative
end

function fs.Normalize(path)
    path = path:gsub("\\", "/")
    path = path:gsub("/+", "/")
    return path
end

---@param dir string
---@param pattern string?
---@return string[]
function fs.Find(dir, pattern)
    local tmp = os.tmpname()
    local cmd
    if fs.IsWindows() then
        cmd = 'dir "' .. dir .. '" /b /s'
    else
        cmd = 'find "' .. dir .. '" -type f'
    end
    os.execute(cmd .. ' > "' .. tmp .. '"')
    local results = {}
    local lines = fs.ReadLines(tmp)
    fs.Delete(tmp)
    if not lines then
        return results
    end
    for i = 1, #lines do
        if not pattern or lines[i]:match(pattern) then
            results[#results + 1] = lines[i]
        end
    end
    return results
end

---@param dir string
---@param filename string
---@return string|nil
function fs.FindOne(dir, filename)
    local files = fs.Find(dir, filename)
    return files[1]
end

---@param path string
---@param mustContain string
---@return boolean
function fs.Restrict_Detect(path, mustContain)
    local content = fs.Read(path)
    if not content then
        return false
    end
    return content:find(mustContain, 1, true) ~= nil
end

---@param path string
---@param find string
---@param replace string
---@return boolean
function fs.Replace(path, find, replace)
    local content = fs.Read(path)
    if not content then
        return false
    end
    content = content:gsub(find, replace)
    return fs.Write(path, content)
end

---@param path string
---@param line string
---@return boolean
function fs.HasLine(path, line)
    local lines = fs.ReadLines(path)
    if not lines then
        return false
    end
    for i = 1, #lines do
        if lines[i] == line then
            return true
        end
    end
    return false
end

---@param path string
---@param prefix string
---@return string[]
function fs.FilterByPrefix(path, prefix)
    local lines = fs.ReadLines(path)
    local out = {}
    if not lines then
        return out
    end
    for i = 1, #lines do
        if lines[i]:sub(1, #prefix) == prefix then
            out[#out + 1] = lines[i]
        end
    end
    return out
end

return fs