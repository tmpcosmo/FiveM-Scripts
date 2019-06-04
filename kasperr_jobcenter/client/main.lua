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

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "kasperr_jobcenter")

local open = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if (IsNear()) then
      if IsControlJustPressed(1, Config.OpenMenu) then
        if open then
          closeGui()
        else
          openGui()
        end
      end
    else
      if (open) then
        closeGui()
      end
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    for _, item in pairs(Config.Locations) do
      if(Vdist(pos.x, pos.y, pos.z, item.x, item.y, item.z+1) < 15.0)then
        DrawMarker(30, item.x, item.y, item.z+1, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 2.0001, 0, 155, 255, 200, 1, 0, 0, 1)
        if GetDistanceBetweenCoords(item.x, item.y, item.z, GetEntityCoords(LocalPed())) < 3 and IsPedInAnyVehicle(LocalPed(), true) == false then
          DrawText3Ds(item.x, item.y, item.z+2, Config.Language.openMenuText)
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
    for _, item in pairs(Config.Locations) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipAsShortRange(item.blip, true)
      SetBlipColour(item.blip, item.colour)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
    end
end)

Citizen.CreateThread(function()
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
end)

RegisterNUICallback("close", function(data)
  closeGui()
end)

RegisterNUICallback("selectJob", function(data)
  if data.group ~= nil then
    TriggerServerEvent("kasperr_jobcenter:selectJob", data.group)
  end
end)

RegisterNetEvent("kasperr_jobcenter:notification")
AddEventHandler("kasperr_jobcenter:notification", function(message)
    nuiNotification(message)
end)

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

function nuiNotification(message) 
  SendNUIMessage({
    notification = true,
    notification_msg = message
  })
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

function LocalPed()
  return GetPlayerPed(-1)
end

function DrawText3Ds(x,y,z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function ply_drawTxt(text,font,centre,x,y,scale,r,g,b,a)
  SetTextFont(font)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(centre)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x , y)
end

AddEventHandler("onResourceStop", function(resource)
  if resource == GetCurrentResourceName() then
    if open then
      closeGui()
    end
  end
end)
