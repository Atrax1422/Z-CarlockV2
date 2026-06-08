ESX = exports['es_extended']:getSharedObject()

exports.ox_inventory:registerHook('usingItem', function(source, item, slot)
    if item.name == Config.CarkeyItem then
        TriggerClientEvent('carlock:haskeys')
    else
        ESX.ShowNotification("Du hast kein Schlüssel für dieses Fahrzeug")
    end
    
end)

local SharedKeys = {}


ESX.RegisterServerCallback('carlock:hasKeys', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    
    if SharedKeys[plate] and SharedKeys[plate][identifier] then
        cb(true)
        return
    end

    
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
        ['@owner'] = identifier,
        ['@plate'] = plate
    }, function(result)
        if result[1] then
            cb(true) 
        else
            cb(false) 
        end
    end)
end)


RegisterNetEvent('carlock:giveKey')
AddEventHandler('carlock:giveKey', function(targetId, plate)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if xTarget then
        if not SharedKeys[plate] then
            SharedKeys[plate] = {}
        end

        
        SharedKeys[plate][xTarget.identifier] = true
        
        xPlayer.showNotification("~g~Du hast den Schlüssel für ~y~" .. plate .. " ~g~weitergegeben.")
        xTarget.showNotification("~g~Du hast einen Schlüssel für ~y~" .. plate .. " ~g~erhalten.")
    end
end)


CreateThread(function()
    while Config.LockpickItem == nil do Wait(100) end 
    
    ESX.RegisterUsableItem(Config.LockpickItem, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        TriggerClientEvent('carlock:startLockpick', source)
    end)
end)