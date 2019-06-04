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

-------------------------------------
------------ vRP tunnels ------------
-------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "kasperr_carjack_alert")

-------------------------------------
----------- Server events -----------
-------------------------------------
RegisterServerEvent("kasperr_carjack_alert:call")
AddEventHandler(
  "kasperr_carjack_alert:call",
  function(data, x, y)
    local plate = data:gsub('%P% ', '') -- Remove "P" and space from the string
    vRP.getUserByRegistration({plate, function(user_id) -- Registration check
      if user_id == nil then -- If the vehicle dosn't have a owner
        local random = math.random(1, 10) -- Get a random number 1-10 (10%)
        if random == 5 then -- If the number = 5, make a police call
          call(x, y)
        end
      end
    end})
  end
)

-------------------------------------
------------- Functions -------------
-------------------------------------
function call(x, y)
  local answered = false -- Make sure the request isn't answered - predefined variable
  local players = {} -- Table - Players with "police.service" permissions
  local user_id = vRP.getUserId({source}) -- Get user_id - Not using it
  local users = vRP.getUsers() -- Get all players
  for k, v in pairs(users) do -- Loop - for each player
    local player = vRP.getUserSource({tonumber(k)}) -- Get source of current player
    if vRP.hasPermission({k, Config.RequiredPermission}) and player then -- If current player has permissions to "police.service"
      table.insert(players, player) -- Insert current player into my table called "players"
    end
  end

  for k, v in pairs(players) do -- Loop - for each player in my table called "players"
    vRP.request({v, Config.Language.RequiredPermission, 30, function(v, ok) -- Make a request 
      if ok then -- If the player accept the request
        if not answered then -- If it's not accepted
          vRPclient.setGPS(v, {x, y}) -- Set GPS coordinates
          answered = true -- accept the call
        else
          vRPclient.notify(v, {Config.Language.CallAlreadyTaken}) -- If the request already accepted
        end
      end
    end})
  end
end
