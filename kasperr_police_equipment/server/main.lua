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

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "kasperr_police_equipment")

RegisterServerEvent("kasperr_police_equipment:hasPermissions")
AddEventHandler("kasperr_police_equipment:hasPermissions", function(hasWeapon)
  local _source = source
  local user_id = vRP.getUserId({source})
  if vRP.hasPermission({user_id, Config.RequiredPermission}) then
    if hasWeapon == true then 
      TriggerClientEvent("kasperr_progress_handler:open", _source, Config.Language.RemovingEquipment, 3000, "client", "kasperr_police_equipment:removeEquipment", {})
    else 
      TriggerClientEvent("kasperr_progress_handler:open", _source, Config.Language.ReceivingEquipment, 3000, "client", "kasperr_police_equipment:giveEquipment", {})
    end
  else
    TriggerClientEvent("pNotify:SendNotification", source, {
      text = Config.Language.Error,
      type = "info",
      timeout = (3000),
      layout = "bottomCenter",
      queue = "global"
    })
  end
end)