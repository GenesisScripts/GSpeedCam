ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('GSpeedCam:payFine')
AddEventHandler('GSpeedCam:payFine', function(fineAmount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.removeAccountMoney('bank', fineAmount)

        if xPlayer.getAccount('bank').money < -50000 then
            TriggerClientEvent('GSpeedCam:confiscateVehicle', source)
        end
    end
end)

