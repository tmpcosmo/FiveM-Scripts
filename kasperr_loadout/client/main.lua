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

local open = false
local cooldown = 0
local temp_access = nil

if true then
  Citizen.CreateThread(
    function()
      while true do
        Citizen.Wait(0)
        if (IsNear()) then
          if IsControlJustPressed(1, Config.OpenMenu) then
            if open then
              closeGui()
            else
              TriggerEvent("kasperr_loadout:openGui")
            end
          end
        else
          if (open) then
            closeGui()
          end
        end
      end
    end
  )
end

Citizen.CreateThread(
  function()
    while true do
      Citizen.Wait(0)
      for _, item in pairs(Config.Locations) do
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)
        local distance =
          GetDistanceBetweenCoords(item.x, item.y, item.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
        if (distance <= 3) then
          ply_drawTxt(Config.Language.openMenuText, 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
        end
      end
    end
  end
)

Citizen.CreateThread(
  function()
    while true do
      if open then
        local ply = GetPlayerPed(-1)
        local active = true
        DisableControlAction(0, 1, active) -- LookLeftRight
        DisableControlAction(0, 2, active) -- LookUpDown
        DisableControlAction(0, 24, active) -- Attack
        DisablePlayerFiring(ply, true) -- Disable weapon firing
        DisableControlAction(0, 142, active) -- MeleeAttackAlternate
        DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
      end
      Citizen.Wait(0)
    end
  end
)

RegisterNUICallback(
  "close",
  function(data)
    closeGui()
  end
)

RegisterNUICallback(
  "giveLoadout",
  function(data)
    giveLoadout(data.loadout)
  end
)

RegisterNetEvent("kasperr_loadout:openGui")
AddEventHandler(
  "kasperr_loadout:openGui",
  function()
    if cooldown > 0 and temp_access ~= nil then
      TriggerEvent("kasperr_loadout:open", temp_access)
    else
      cooldown = Config.AntiSpamCooldown
      TriggerServerEvent("kasperr_loadout:open")
    end
  end
)

RegisterNetEvent("kasperr_loadout:open")
AddEventHandler(
  "kasperr_loadout:open",
  function(response)
    if response == true then
      temp_access = true
      openGui()
    else
      temp_access = false
      TriggerEvent(
        "pNotify:SendNotification",
        {
          text = Config.Language.AccessDenied,
          type = "alert",
          timeout = (15000),
          layout = "bottomCenter",
          queue = "global"
        }
      )
    end
  end
)

function openGui()
  open = true
  SetNuiFocus(true, true)
  SendNUIMessage({open = true})
end

function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({open = false})
  open = false
end

function setArmour(armour,vest)
  local player = GetPlayerPed(-1)
  if vest then
    if(GetEntityModel(player) == GetHashKey("mp_m_freemode_01")) then
      SetPedComponentVariation(player, 9, 4, 1, 2)  --Bulletproof Vest
    else 
      if(GetEntityModel(player) == GetHashKey("mp_f_freemode_01")) then
        SetPedComponentVariation(player, 9, 6, 1, 2)
      end
    end
  end
  local n = math.floor(armour)
  SetPedArmour(player,n)
end

function giveLoadout(loadout)
  SetPedArmour(GetPlayerPed(-1), 100)
  setArmour(100,true)
  for i, item in ipairs(loadout) do
    local hash = GetHashKey(item)
    GiveWeaponToPed(GetPlayerPed(-1), hash, 1000, 0, false)
  end
end

function IsNear()
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  for _, item in pairs(Config.Locations) do
    local distance =
      GetDistanceBetweenCoords(item.x, item.y, item.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
    if (distance <= 3) then
      return true
    end
  end
end

function ply_drawTxt(text, font, centre, x, y, scale, r, g, b, a)
  SetTextFont(font)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(centre)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x, y)
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    if cooldown > 0 then 
      cooldown = cooldown - 1
    end
  end
end)

AddEventHandler(
  "onResourceStop",
  function(resource)
    if resource == GetCurrentResourceName() then
      if open then
        closeGui()
      end
    end
  end
)
