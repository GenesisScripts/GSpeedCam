ESX = nil
local hasBeenCaught = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

-- Load the config file
local Config = require('config')

-- Settings
local Speedcamera60Zone = Config.SpeedCameras
local emsVehicles = Config.EMSVehicles
local useBlips = Config.UseBlips

-- Create blips for speed cameras
Citizen.CreateThread(function()
    if useBlips then
        for _, camera in ipairs(Config.SpeedCameras) do
            camera.blip = AddBlipForCoord(camera.x, camera.y, camera.z)
            SetBlipSprite(camera.blip, 184) -- Blip sprite ID for speed camera
            SetBlipDisplay(camera.blip, 5)  -- Show blips on the minimap only
            SetBlipScale(camera.blip, 0.8)
            SetBlipColour(camera.blip, 0)  -- Color ID for the blip
            SetBlipAsShortRange(camera.blip, true)
            SetBlipHighDetail(camera.blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Speedcamera (60KM/H)")
            EndTextCommandSetBlipName(camera.blip)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        for _, camera in ipairs(Config.SpeedCameras) do
            if useBlips and camera.blip then
                local dist = Vdist(playerCoords, camera.x, camera.y, camera.z)
                if dist <= 100.0 then
                    local alpha = math.max(0, math.min(128, math.floor(128 * (1 - dist / 100))))
                    SetBlipAlpha(camera.blip, alpha)

                    -- Make blip flash every 2 seconds
                    local flashInterval = 2000
                    SetBlipFlashes(camera.blip, GetGameTimer() % (2 * flashInterval) < flashInterval)
                else
                    SetBlipAlpha(camera.blip, 0)
                end
            end
        end
        Citizen.Wait(500)  -- Update blips every 500 ms
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local playerPed = PlayerPedId()
        local playerCar = GetVehiclePedIsIn(playerPed, false)

        if GetPedInVehicleSeat(playerCar, -1) == playerPed and not IsEmsVehicle(playerCar, emsVehicles) then
            local speed = GetEntitySpeed(playerCar) * 3.6 -- Convert m/s to km/h
            local playerCoords = GetEntityCoords(playerPed, false)
            for _, zone in ipairs(Speedcamera60Zone) do
                local dist = Vdist(playerCoords, zone.x, zone.y, zone.z)

                if dist <= 20.0 then
                    if not hasBeenCaught and speed > 80 then
                        hasBeenCaught = true
                        local fine = CalculateFine(speed)

                        if fine > 0 then
                            TriggerFine(fine)
                            Citizen.Wait(8000) -- Cooldown to prevent multiple fines
                        end
                    end
                else
                    hasBeenCaught = false
                end
            end
        end
    end
end)

function CalculateFine(speed)
    for _, fineConfig in ipairs(Config.Fines) do
        if speed >= fineConfig.minSpeed and speed < fineConfig.maxSpeed then
            if fineConfig.amount == 0 then
                lib.notify({
                    title = 'VicRoads',
                    description = "You are going over the speed limit. Slow down or any faster you will be fined.",
                    type = 'warning',
                    position = 'top',
                    icon = 'camera'
                })
                Citizen.Wait(8000)
            end
            return fineConfig.amount
        end
    end
    return 0
end

function TriggerFine(fine)
    TriggerServerEvent('GSpeedCam:payFine', fine)
    lib.notify({
        title = 'VicRoads',
        description = 'You have been hit by a speed camera. Your fine for speeding is: $' .. fine,
        type = 'error',
        position = 'top',
        icon = 'camera'
    })
end

function IsEmsVehicle(vehicle, emsVehicleList)
    local model = GetEntityModel(vehicle)
    local modelName = GetDisplayNameFromVehicleModel(model):upper()
    for _, emsModel in ipairs(emsVehicleList) do
        if modelName == emsModel then
            return true
        end
    end
    return false
end

RegisterNetEvent('GSpeedCam:confiscateVehicle')
AddEventHandler('GSpeedCam:confiscateVehicle', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle and vehicle ~= 0 then
        lib.notify({
            title = 'VicRoads',
            description = 'Vicroads has sent a team to you to take your car \n Best to slow down and pay them bills',
            type = 'error',
            position = 'top',
            icon = 'camera'
        })
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
    end
end)
