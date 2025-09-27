local _ENV = (getgenv or getrenv or getfenv)()

local Scripts = {
    { Name = "PlantsVsBrainrots", Url = "https://raw.githubusercontent.com/gumanba/Scripts/main/PlantsVsBrainrots.lua" },
    { Name = "FixLag",             Url = "https://raw.githubusercontent.com/Luongdaynetroi/Free/964d0730156249f89e7d24c74c27960bffc3f0d3/FixLag/roblox/.lua" },
    { Name = "AntiAFK",            Url = "https://raw.githubusercontent.com/Luongdaynetroi/AntiAfk/refs/heads/main/Free/.lua" }
}

local function httpGetSafe(url)
    local ok, res = pcall(function() return game:HttpGet(url, true) end)
    if not ok then
        return nil, ("HttpGet failed: %s"):format(tostring(res))
    end
    return res
end

local function runStringSafe(code, name)
    if not code then return false, "no code" end
    local fn, err = loadstring(code)
    if not fn then return false, ("loadstring failed (%s): %s"):format(tostring(name or "unknown"), tostring(err)) end
    local ok, runErr = pcall(fn)
    if not ok then return false, ("runtime error (%s): %s"):format(tostring(name or "unknown"), tostring(runErr)) end
    return true
end

for _, info in ipairs(Scripts) do
    local name = info.Name or info.Url
    local url  = info.Url
    print(("[LV Loader] Fetching %s"):format(name))
    local body, err = httpGetSafe(url)
    if not body then
        warn(("[LV Loader] %s - %s"):format(name, err))
    else
        local ok, runErr = runStringSafe(body, name)
        if ok then
            print(("[LV Loader] %s loaded OK"):format(name))
        else
            warn(("[LV Loader] %s failed: %s"):format(name, runErr))
        end
    end
    task.wait(0.15) -- tiny delay between loads (safer)
end

print("[LV Loader] All done.")
