--[[

    lover.lua
    Type: Loader
    by @stav

]]

local ids = {
    [6872265039] = '6872274481.lua',
    [6872274481] = '6872274481.lua',
    [8444591321] = '6872274481.lua',
    [8560631822] = '6872274481.lua',
    --[17813692689] = '17813692689.lua'
}

local function downloadFile(file)
    url = file:gsub('lover.lua/', '')
    if not isfile(file) then
        writefile(file, game:HttpGet('https://raw.githubusercontent.com/sstvskids/lover.lua/'..readfile('lover.lua/commit.txt')..'/'..url))
    end

    repeat task.wait() until isfile(file)
    return readfile(file)
end

for i,v in ids do
    if i == game.PlaceId then
        return loadstring(downloadFile('lover.lua/games/'..v))()
    end
end

return loadstring(downloadFile('lover.lua/games/universal.lua'))()