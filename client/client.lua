
RegisterNetEvent('esx:playerLoaded') 
AddEventHandler('esx:playerLoaded', function(xPlayer, isNew)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:playerLogout') 
AddEventHandler('esx:playerLogout', function(xPlayer, isNew)
    ESX.PlayerLoaded = false
    ESX.PlayerData = {}
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

CreateThread(function()
    while true do 
        local wait = 1000
        for k,v in pairs(Config.mafias) do 
                if ESX.PlayerData.job and ESX.PlayerData.job.name == v.job then 
                local _pos = GetEntityCoords(PlayerPedId())
                local _dist = #(_pos - v.point) < 3
                if _dist then 
                    wait = 0
                    ESX.ShowFloatingHelpNotification("Press ~r~E~w~ to open your mafia point", v.point)
                    if IsControlJustPressed(0, 38) then 
                        TriggerEvent('nh-context:sendMenu', {
                            {
                                id = 1,
                                header = "Mafia Menu",
                                txt = '',
                            },
                            {
                                id = 2,
                                header = "Open Armory",
                                txt = 'Open your mafia armory',
                                params = {
                                    event = 'mafias:openArmory',
                                    args = {
                                        id = v.job
                                    }
                                }
                            },
                            {
                                id = 3,
                                header = "Menu de Jefe",
                                txt = 'Solo los Jefes, no lo intentes',
                                params = {
                                    event = 'mafias:bossMenu',
                                }
                            },
                        })
                    end
                end 
                local dist = #(_pos - v.cars) <3
                if dist then 
                    wait = 0
                    ESX.ShowFloatingHelpNotification("Press ~r~E~w~ to open your mafia garage", v.cars)
                    if IsControlJustPressed(0, 38) then 
                        local options = {}
                        for i = 1, #v.models do
                        table.insert(options,{
                            id = n, 
                            header = v.models[i].nombre, 
                            txt = '',
                            params = {
                                event = "mafias:spawnvehicle",
                                args = {
                                    model = v.models[i].modelo,
                                    spawn = v.spawnvehicle,
                                    heading = v.headingvehicle,
                                }
                            }
                        }
                    )
                end
                    TriggerEvent('nh-context:sendMenu', options)
                    end
                end
                local dist2 = #(_pos - v.deletevehicle) < 3
                    if dist2 then 
                        wait = 0
                        if IsPedInAnyVehicle(PlayerPedId()) then 
                        ESX.ShowFloatingHelpNotification("Press ~r~E~w~ to delete your vehicle", v.deletevehicle)
                        if IsControlJustPressed(0, 38) then 
                            ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                        end
                    end
                end
            end
        end
        Wait(wait)
    end
end)

AddEventHandler("mafias:bossMenu", function()
    if ESX.PlayerData.job and ESX.PlayerData.job.grade_name == "boss" then 
        TriggerEvent("nh-context:sendMenu", {
            {
                id = 1,
                header = 'Boss Menu',
                txt = '',
            },
            {
                id = 2,
                header = 'Recruit',
                txt = 'Recruit the closest player',
                params = {
                    event = 'mafias:bossActions',
                    args = {
                        action = 'recruit'
                    }
                }

            },
            {
                id = 3,
                header = 'Despedir',
                txt = 'Fire the closest player',
                params = {
                    event = 'mafias:bossActions',
                    args = {
                        action = 'fire'
                    }
                }
            },
            {
                id = 4,
                header = 'Promote',
                txt = 'Promote the closest player',
                params = {
                    event = 'mafias:bossActions',
                    args = {
                        action = 'promote'
                    }
                }
            },
            {
                id = 5,
                header = 'Descend',
                txt = 'Descend the closest player',
                params = {
                    event = 'mafias:bossActions',
                    args = {
                        action = 'descend'
                    }
                }
            }
        })
    else
        ESX.ShowNotification("No eres jefe")
    end
end)

AddEventHandler('mafias:bossActions', function(jobdata)
    if ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' then 
    local action = jobdata.action
        if action == 'recruit' then
            local job =  ESX.PlayerData.job.name
            local grade = 0
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification("No players Nearby")
            else
                TriggerServerEvent('mafias:recruit', GetPlayerServerId(closestPlayer), job,grade)
            end
        elseif action == 'fire' then 
            local job =  PlayerData.job.name
            local grade = 0
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification("No players Nearby")
            else
                TriggerServerEvent('mafias:fire', GetPlayerServerId(closestPlayer))
            end
        elseif action == 'promote' then 
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification("No players Nearby")
            else
                TriggerServerEvent('mafias:promote', GetPlayerServerId(closestPlayer))
            end
        elseif action == 'descend' then 
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification("No players Nearby")
            else
                TriggerServerEvent('NB:destituerplayer', GetPlayerServerId(closestPlayer))
            end
        else
            ESX.ShowNotification("You are not boss")
    end
end
end)

AddEventHandler('mafias:spawnvehicle', function(data)
    ESX.Game.SpawnVehicle(data.model, data.spawn, data.heading, function(veh) 
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    end)
end)

AddEventHandler('mafias:openArmory', function(invdata)
    exports['linden_inventory']:OpenStash({owner = false, id = invdata.id, label = "Armario de Mafia", slots = 80})
end)
