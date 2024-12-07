local isinzone = false
local zoneid = nil
local removedmoney = false
local ESX = nil

CreateThread(function()
    while not ESX do
        ESX = exports["es_extended"]:getSharedObject()
        Wait(500)
    end

    while ESX.GetPlayerData().job == nil do
        Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

function checkZone(v, coords, radius, id)
    local ped = PlayerPedId()
    local entitycoords = GetEntityCoords(ped, true)
    local distance = Vdist2(coords, entitycoords)

    if distance <= radius then
        if not isinzone or zoneid ~= id then
            isinzone = true
            removedmoney = false
            zoneid = id
        end

        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
            local speed = GetEntitySpeed(vehicle)

			if Config.Unit == 'kmh' then
				speed = speed * 3.602151
			else
				speed = speed * 2.23694
			end

            if speed > (v.Speedlimit + Config.Tolerance) and not removedmoney then
                local bypass = false
                for _, job in pairs(Config.WhitelistedJobs) do
                    if PlayerData.job.name == job then
                        bypass = true
                        break
                    end
                end

                if not bypass then
					local above = ESX.Math.Round(speed - (v.Speedlimit + Config.Tolerance))
					local amount = Config.BillMultiplyer * above
					
					tg_shownotification(tg_translate('geblitzt', math.floor(speed), v.Speedlimit, amount))
					
					TriggerServerEvent('tg_blitzer:removemoney', amount)
					removedmoney = true
					
					PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", true)
					
					triggerWhiteFlash(250)
				end				
            end
        end
    elseif isinzone and zoneid == id then
        isinzone = false
        removedmoney = false
        zoneid = nil
    end
end

function triggerWhiteFlash(duration)
    local startTime = GetGameTimer()

    while GetGameTimer() - startTime < duration do
        DrawRect(0.5, 0.5, 1.0, 1.0, 255, 0, 0, 180)
        Wait(0)
    end
end


CreateThread(function()
    while true do
        Wait(0)
        for id, v in pairs(Config.Blitzer) do
            if v.Lane.Speedlimit then
                checkZone(v.Lane, v.Lane.Coords, v.Lane.Radius, id)
            else
                print("^0[^1ERROR^0] ^3tg_blitzer^0: ^4Speedlimit^0 is not set for Main Lane!")
            end

            if v.ActivateSecondLane and v.SecondLane.Speedlimit then
                checkZone(v.SecondLane, v.SecondLane.Coords, v.SecondLane.Radius, id .. "_2")
            elseif v.ActivateSecondLane then
                print("^0[^1ERROR^0] ^3tg_blitzer^0: ^4Speedlimit^0 is not set for Second Lane!")
            end
        end
    end
end)

CreateThread(function()
    if not Config.DisableBlips then
        for _, v in pairs(Config.Blitzer) do
            if v.Blip then
                local blip = AddBlipForCoord(v.Prop.Coords)

                SetBlipSprite(blip, 774)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.9)
                SetBlipColour(blip, 1)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName(Config.Blipname)
                EndTextCommandSetBlipName(blip)
            end
        end
    end

    if not Config.DisableProps then
        for _, v in pairs(Config.Blitzer) do
            if v.Prop.activated then
                local prop = CreateObject(Config.Prop, v.Prop.Coords, true)
                FreezeEntityPosition(prop, true)
            end
        end
    end
end)

CreateThread(function()
    while Config.Debug do
        Wait(10)
        for _, v in pairs(Config.Blitzer) do
            DrawMarker(25, v.Lane.Coords, 0, 0, 0, 0, 0, 0, v.Lane.Radius * 2.0, v.Lane.Radius * 2.0, 2, 255, 0, 0, 100, false, true, 2, nil, nil, false)
            if v.ActivateSecondLane then
                DrawMarker(25, v.SecondLane.Coords, 0, 0, 0, 0, 0, 0, v.SecondLane.Radius * 2.0, v.SecondLane.Radius * 2.0, 2, 255, 0, 0, 100, false, true, 2, nil, nil, false)
            end
        end
    end
end)

function tg_shownotification(message)
    local textureDict = "TG_Textures"
    RequestStreamedTextureDict(textureDict, true)

    while not HasStreamedTextureDictLoaded(textureDict) do
        Wait(0)
    end

    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostMessagetext(textureDict, "TG_Logo", false, 0, "TG Blitzer Script", "")

    SetStreamedTextureDictAsNoLongerNeeded(textureDict)
end