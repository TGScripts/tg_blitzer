local label = 
[[

    .______    __       __  .___________.________   _______ .______      
    |   _  |  |  |     |  | |           |       /  |   ____||   _  |     
    |  |_)  | |  |     |  | `---|  |----`---/  /   |  |__   |  |_)  |    
    |   _  <  |  |     |  |     |  |       /  /    |   __|  |      /     
    |  |_)  | |  `----.|  |     |  |      /  /----.|  |____ |  ||  |----.
    |______/  |_______||__|     |__|     /________||_______|| _| `._____|

                    Made by Tiger (Lets_Tiger#4159)
]]

local rio = false
local resourceName = "ERROR"
local responseText = "ERROR"
local curVersion = 7.0.7
local updatePath = "ERROR"
local svs = false
local utd = false

function GetCurrentVersion()
	return GetResourceMetadata( GetCurrentResourceName(), "version" )
end

Citizen.CreateThread( function()
    updatePath = "/LetsTiger/tg_blitzer/blob/main/tg_blitzer"
    resourceName = " Blitzer Script ("..GetCurrentResourceName()..")"
    
    function checkVersion(err,responseText, headers)
        curVersion = LoadResourceFile(GetCurrentResourceName(), "version")
    
        if curVersion ~= responseText and tonumber(curVersion) < tonumber(responseText) then
            rio = true
            responseText = responseText
            curVersion = curVersion
            updatePath = updatePath
        elseif tonumber(curVersion) > tonumber(responseText) then
            svs = true
        else
            utd = true
        end
    end
    
    PerformHttpRequest("https://github.com"..updatePath.."/version", checkVersion, "GET")
end)

function Resourcestart()
    print("\n")

    print( label )

    if rio then
        print("\n"..resourceName.." is outdated, should be:\n"..responseText.."is:\n"..curVersion.."\nplease update it from https://github.com"..updatePath.."")
    elseif svs then
        print("You somehow skipped a few versions of "..resourceName.." or the git went offline, if it's still online i advise you to update ( or downgrade? )")
    elseif utd then
        print("\n"..resourceName.." is up to date, have fun!")
    else
        print("ERROR SOMETHING WENT WRONG!")
    end

    print("\n")
end

CreateThread(function()
    Citizen.Wait(2100)
    Resourcestart()
end)