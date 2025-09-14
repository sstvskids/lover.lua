--[[

    lover.lua
    Type: Loader
    by @stav

]]

local ids = {
    [6872274481] = '6872274481.lua',
    [8444591321] = '6872274481.lua',
    [8560631822] = '6872274481.lua'
}

local function downloadFile(file)
    url = file:gsub('pineapple/', '')
    if not isfile(file) then
        writefile(file, game:HttpGet('https://raw.githubusercontent.com/pinpple/pineapple/'..readfile('pineapple/commit.txt')..'/'..url))
    end

    repeat task.wait() until isfile(file)
    return readfile(file)
end

for i,v in ids do
    if i == game.PlaceId then
        return loadstring(downloadFile('pineapple/games/'..v))()
    end
end

return loadstring(downloadFile('pineapple/games/universal.lua'))()