local isinzone = false
local sentbill = false
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

CreateThread(function()
	while true do
		Wait(0)

		for _,v in pairs(Config.Blitzer) do
			coords = v.Lane.Coords
			radius = v.Lane.Radius

			local ped = PlayerPedId()
			local entitycoords = GetEntityCoords(ped,true)
			local distance = Vdist2(coords,entitycoords)

			if distance <= radius then
				
				local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1),false)

				if vehicel ~= 0 then
					isinzone = true
					while isinzone and (sentbill == false) do
						Wait(0)
						local speed = GetEntitySpeed(vehicle) * 3.602151
						if speed > (v.Speedlimit + 5) then
							if GetPedInVehicleSeat(GetVehiclePedIsIn(ped),-1) == ped then
								for _,v in pairs(Config.WhitelistedJobs) do 
									if PlayerData.job.name == v then
										bypass = true
									end
								end
								if not bypass then
									if sentbill == false then
										above = ESX.Math.Round((speed-(v.Speedlimit + 5)))
										amount = 25*above
										TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(PlayerId()), Config.Reciever, 'Blitzerrechnung - ~r~'..above..' km/h~s~ drüber', amount)
										sentbill = true
									end
								end
								bypass = false
							end
						end
					end
				end
			end

			if (distance > radius) and isinzone then
				isinzone = false
			end

			if (distance < radius + 1) and (distance > radius) then
				sentbill = false
			end

		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)

		for _,v in pairs(Config.Blitzer) do
			if v.ActivateSecondLane then
				coords = v.SecondLane.Coords
				radius = v.SecondLane.Radius

				local ped = PlayerPedId()
				local entitycoords = GetEntityCoords(ped,true)
				local distance = Vdist2(coords,entitycoords)

				if distance <= radius then
				
					local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1),false)
	
					if vehicel ~= 0 then
						isinzone = true
						while isinzone and (sentbill == false) do
							Wait(0)
							local speed = GetEntitySpeed(vehicle) * 3.602151
							if speed > (v.Speedlimit + 5) then
								if GetPedInVehicleSeat(GetVehiclePedIsIn(ped),-1) == ped then
									for _,v in pairs(Config.WhitelistedJobs) do 
										if PlayerData.job.name == v then
											bypass = true
										end
									end
									if not bypass then
										if sentbill == false then
											above = ESX.Math.Round((speed-(v.Speedlimit + 5)))
											amount = 25*above
											TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(PlayerId()), Config.Reciever, 'Blitzerrechnung - ~r~'..above..' km/h~s~ drüber', amount)
											sentbill = true
										end
									end
									bypass = false
								end
							end
						end
					end
				end
	
				if (distance > radius) and isinzone then
					isinzone = false
				end
	
				if (distance < radius + 1) and (distance > radius) then
					sentbill = false
				end

			end
		end
	end
end)


CreateThread(function()
	if Config.DisableBlips == false then
		for _,v in pairs(Config.Blitzer) do
			if v.Blip then
				local blip = AddBlipForCoord(v.Prop.Coords)

				SetBlipSprite (blip, 774)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 0.9)
				SetBlipColour (blip, 1)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(Config.Blipname)
				EndTextCommandSetBlipName(blip)
			end
		end
	end

	if not Config.DisableProps then
		for _,v in pairs(Config.Blitzer) do
			if v.Prop.activated then
				local prop = CreateObject(Config.Prop,v.Prop.Coords,true)
				FreezeEntityPosition(prop, true)
			end
		end
	end
end)