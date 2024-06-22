local isinzone = false
local removedmoney = false
local ESX = nil
local bypass = false

CreateThread(function()
	while not ESX do
		ESX = exports["es_extended"]:getSharedObject()
		Wait(500)
	end

	while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

function checkZone(v, coords, radius)
	local ped = PlayerPedId()
	local entitycoords = GetEntityCoords(ped, true)
	local distance = Vdist2(coords, entitycoords)

	if distance <= radius then
		local vehicle = GetVehiclePedIsIn(ped, false)

		if vehicle ~= 0 then
			isinzone = true

			while isinzone and not removedmoney do
				Wait(0)
				local speed = GetEntitySpeed(vehicle) * 3.602151

				if speed > (v.Speedlimit + 5) then
					if GetPedInVehicleSeat(vehicle, -1) == ped then
						for _, job in pairs(Config.WhitelistedJobs) do 
							if PlayerData.job.name == job then
								bypass = true
							end
						end

						if not bypass then
							if not removedmoney then
								local above = ESX.Math.Round(speed - (v.Speedlimit + 5))
								local amount = Config.BillMultiplyer * above

								ESX.ShowNotification('~r~BLITZER~s~: Du wurdest mit ~b~'..math.floor(speed)..' km/h ~s~in der ~b~'..v.Speedlimit..'er~s~ Zone geblitzt. Dir wurden ~g~$'..amount..'~s~ abgezogen.','error',5000)
								TriggerServerEvent('tg_blitzer:removemoney', amount)

								removedmoney = true
							end
						end
						bypass = false
					end
				end
			end
		end
	end

	if distance > radius and isinzone then
		isinzone = false
	end

	if distance < radius + 1 and distance > radius then
		removedmoney = false
	end
end

CreateThread(function()
	while true do
		Wait(0)
		for _, v in pairs(Config.Blitzer) do
			if v.Lane.Speedlimit then
				checkZone(v.Lane, v.Lane.Coords, v.Lane.Radius)
			else
				print("^0[^1ERROR^0] ^3tg_blitzer^0: ^4Speedlimit^0 is not set for Main Lane!")
			end

			if v.ActivateSecondLane then
				if v.SecondLane.Speedlimit then
					checkZone(v.SecondLane, v.SecondLane.Coords, v.SecondLane.Radius)
				else
					print("^0[^1ERROR^0] ^3tg_blitzer^0: ^4Speedlimit^0 is not set for Second Lane!")
				end
			end
		end

		if Config.Debug then
			for _, v in pairs(Config.Blitzer) do
				DrawMarker(23, v.Lane.Coords, 0, 0, 0, 0, 0, 0, v.Lane.Radius * 2.0, v.Lane.Radius * 2.0, 2.0, 255, 0, 0, 100, false, true, 2, nil, nil, false)
				if v.ActivateSecondLane then
					DrawMarker(23, v.SecondLane.Coords, 0, 0, 0, 0, 0, 0, v.SecondLane.Radius * 2.0, v.SecondLane.Radius * 2.0, 1.0, 255, 0, 0, 100, false, true, 2, nil, nil, false)
				end
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