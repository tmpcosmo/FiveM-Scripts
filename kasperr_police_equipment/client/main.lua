--[[
  __  __           _            _                 _  __                         _____  
 |  \/  |         | |          | |               | |/ /                        |  __ \ 
 | \  / | __ _  __| | ___      | |__  _   _      | ' / __ _ ___ _ __   ___ _ __| |__) |
 | |\/| |/ _` |/ _` |/ _ \     | '_ \| | | |     |  < / _` / __| '_ \ / _ \ '__|  _  / 
 | |  | | (_| | (_| |  __/     | |_) | |_| |     | . \ (_| \__ \ |_) |  __/ |  | | \ \ 
 |_|  |_|\__,_|\__,_|\___|     |_.__/ \__, |     |_|\_\__,_|___/ .__/ \___|_|  |_|  \_\
                                       __/ |                   | |                     
                                      |___/                    |_|                     

  Author: Kasper Rasmussen
  Steam: https://steamcommunity.com/id/kasperrasmussen
]]

local cooldown = 0

RegisterNetEvent("kasperr_police_equipment:giveEquipment")
AddEventHandler("kasperr_police_equipment:giveEquipment", function()
	local hash = GetHashKey(Config.PoliceWeapon)
	GiveWeaponToPed(GetPlayerPed(-1), hash, 1000, 0, false)
	TriggerEvent("pNotify:SendNotification", {
		text = Config.Language.EquipmentReceived,
		type = "info",
		timeout = (3000),
		layout = "bottomCenter",
		queue = "global"
	})
end)

RegisterNetEvent("kasperr_police_equipment:removeEquipment")
AddEventHandler("kasperr_police_equipment:removeEquipment", function()
	local hash = GetHashKey(Config.PoliceWeapon)
	RemoveWeaponFromPed(GetPlayerPed(-1), hash)
	TriggerEvent("pNotify:SendNotification", {
		text = Config.Language.EquipmentRemoved,
		type = "info",
		timeout = (3000),
		layout = "bottomCenter",
		queue = "global"
	})
end)

RegisterCommand(Config.Command, function(source, args)
	if cooldown == 0 then 
		cooldown = 5
		if IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) ~= false then 
			local hash = GetHashKey(Config.PoliceWeapon)
			if HasPedGotWeapon(GetPlayerPed(-1),hash) then
				TriggerServerEvent("kasperr_police_equipment:hasPermissions", true)
			else
				TriggerServerEvent("kasperr_police_equipment:hasPermissions", false)
			end
		end
	else 
		TriggerEvent("pNotify:SendNotification", {
			text = Config.Language.Cooldown,
			type = "info",
			timeout = (3000),
			layout = "bottomCenter",
			queue = "global"
		})
	end
end)

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1000)
	  if cooldown > 0 then 
		cooldown = cooldown - 1
	  end
	end
end)