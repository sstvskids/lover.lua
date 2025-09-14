--[[

    lover.lua
    Type: Installer
    by @stav

]]

local cloneref = cloneref or function(obj)
    return obj
end
local httpService = cloneref(game:GetService('HttpService'))

local function wipeFolders()
    for _, v in {'lover.lua', 'lover.lua/games', 'lover.lua/interface', 'lover.lua/libraries'} do
        if isfolder(v) then
            for x, d in listfiles(v) do
                if string.find(d, 'commit.txt') then continue end
                
                if not isfolder(d) then
                    delfile(d)
                end
            end
        end
    end
end

local function downloadFile(file, read)
    url = file:gsub('lover.lua/', '')
    if not isfile(file) then
        writefile(file, game:HttpGet('https://raw.githubusercontent.com/sstvskids/lover.lua/'..readfile('lover.lua/commit.txt')..'/'..url))
    end

    if read ~= nil and read == false then
        return
    end

    repeat task.wait() until isfile(file)
    return readfile(file)
end

for _, v in {'lover.lua', 'lover.lua/games', 'lover.lua/interface', 'lover.lua/libraries', 'lover.lua/configs'} do
    if not isfolder(v) then
        makefolder(v)
    end
end

local commit = httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/sstvskids/lover.lua/commits'))[1].sha
if not isfile('lover.lua/commit.txt') then
    writefile('lover.lua/commit.txt', commit)
elseif readfile('lover.lua/commit.txt') ~= commit then
    wipeFolders()
    writefile('lover.lua/commit.txt', commit)
end

repeat task.wait() until isfile('lover.lua/commit.txt')

downloadFile('lover.lua/interface/interface.lua', false)
loadstring(downloadFile('lover.lua/main.lua'))()