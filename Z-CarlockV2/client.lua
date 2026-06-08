ESX = exports['es_extended']:getSharedObject()

CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerped, false)
            local driver = GetPedInVehicleSeat
    end
        if IsControlJustPressed(0, Config.LockKey) then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local vehicle = ESX.Game.GetClosestVehicle(coords)



            if vehicle and #(coords - GetEntityCoords(vehicle)) <= Config.LockDistance then
                local plate = GetVehicleNumberPlateText(vehicle):match("^%s*(.-)%s*$") 

               
                ESX.TriggerServerCallback('carlock:hasKeys', function(hasKeys)
                    if hasKeys then
                        local lockStatus = GetVehicleDoorLockStatus(vehicle)

                        
                        RequestAnimDict("anim@mp_player_intmenu@key_fob@")
                        while not HasAnimDictLoaded("anim@mp_player_intmenu@key_fob@") do Wait(1) end
                        TaskPlayAnim(playerPed, "anim@mp_player_intmenu@key_fob@", "fob_click", 8.0, 8.0, -1, 48, 1, false, false, false)

                        if lockStatus == 1 or lockStatus == 0 then 
                            SetVehicleDoorsLocked(vehicle, 2)
                            PlayVehicleDoorCloseSound(vehicle, 1)
                            ESX.ShowNotification("~r~Fahrzeug zugeschlossen (~y~" .. plate .. "~r~)")
                            TriggerEvent('carlock:blinkLights', vehicle)
                        elseif lockStatus == 2 then 
                            SetVehicleDoorsLocked(vehicle, 1)
                            PlayVehicleDoorOpenSound(vehicle, 0)
                            ESX.ShowNotification("~g~Fahrzeug aufgeschlossen (~y~" .. plate .. "~g~)")
                            TriggerEvent('carlock:blinkLights', vehicle)
                            StartVehicleHorn(vehicle, 100, "HELD", false)
                        end
                    else
                        ESX.ShowNotification("~r~Du hast keinen Schlüssel für dieses Fahrzeug.")
                    end
                end, plate)
            end
        end
    end
end)


RegisterNetEvent('carlock:blinkLights')
AddEventHandler('carlock:blinkLights', function(vehicle)
    SetVehicleLights(vehicle, 2)
    Wait(200)
    SetVehicleLights(vehicle, 0)
    Wait(200)
    SetVehicleLights(vehicle, 2)
    Wait(200)
    SetVehicleLights(vehicle, 0)
end)


RegisterCommand('givekey', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = ESX.Game.GetClosestVehicle(coords)
    
    if vehicle and #(coords - GetEntityCoords(vehicle)) < 4.0 then
        local plate = GetVehicleNumberPlateText(vehicle):match("^%s*(.-)%s*$")
        
        
        ESX.TriggerServerCallback('carlock:hasKeys', function(hasKeys)
            if hasKeys then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('carlock:giveKey', GetPlayerServerId(closestPlayer), plate)
                else
                    ESX.ShowNotification('~r~Kein Spieler in der Nähe!')
                end
            else
                ESX.ShowNotification('~r~Du kannst keinen Schlüssel für ein fremdes Auto vergeben.')
            end
        end, plate)
    else
        ESX.ShowNotification('~r~Kein Fahrzeug in der Nähe!')
    end
end)


RegisterNetEvent('carlock:startLockpick')
AddEventHandler('carlock:startLockpick', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = ESX.Game.GetClosestVehicle(coords)

    if vehicle and #(coords - GetEntityCoords(vehicle)) < 3.0 then
        local lockStatus = GetVehicleDoorLockStatus(vehicle)
        
        if lockStatus == 2 then 
            
            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
            ESX.ShowNotification('~y~Du versuchst das Schloss zu knacken...')

            Wait(Config.LockpickDuration)
            
            ClearPedTasksImmediately(playerPed)
            local chance = math.random(1, 100)

            if chance <= Config.LockpickChance then
                
                SetVehicleDoorsLocked(vehicle, 1) 
                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                ESX.ShowNotification('~g~Schloss erfolgreich geknackt!')
            else
                
                SetVehicleAlarm(vehicle, true)
                StartVehicleAlarm(vehicle)
                SetVehicleAlarmTimeLeft(vehicle, 30000) 
                ESX.ShowNotification('~r~Lockpick abgebrochen! Alarm ausgelöst!')
            end
        else
            ESX.ShowNotification('~y~Das Auto ist bereits aufgeschlossen.')
        end
    else
        ESX.ShowNotification('~r~Kein Fahrzeug in der Nähe!')
    end
end)