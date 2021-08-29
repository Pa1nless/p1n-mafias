function getMaximumGrade(jobname)
    local result = MySQL.Sync.fetchAll("SELECT * FROM job_grades WHERE job_name=@jobname  ORDER BY `grade` DESC ;", {
        ['@jobname'] = jobname
    })
    if result[1] ~= nil then
        return result[1].grade
    end
    return nil
end


RegisterServerEvent('mafias:promote')
AddEventHandler('mafias:promote', function(target)

  local _source = source

  local sourceXPlayer = ESX.GetPlayerFromId(_source)
  local targetXPlayer = ESX.GetPlayerFromId(target)
  local maximumgrade = tonumber(getMaximumGrade(sourceXPlayer.job.name)) -1 

  if(targetXPlayer.job.grade == maximumgrade)then
    TriggerClientEvent('esx:showNotification', _source, "Debe solicitar autorización del ~r~Gobierno~w~.")
  else
    if(sourceXPlayer.job.name == targetXPlayer.job.name)then

      local grade = tonumber(targetXPlayer.job.grade) + 1 
      local job = targetXPlayer.job.name

      targetXPlayer.setJob(job, grade)

      TriggerClientEvent('esx:showNotification', _source, "Has ~g~promovido ha "..targetXPlayer.name.."~w~.")
      TriggerClientEvent('esx:showNotification', target,  "Has sido ~g~promovido por ".. sourceXPlayer.name.."~w~.")		

    else
      TriggerClientEvent('esx:showNotification', _source, "No tienes ~r~permiso~w~.")

    end

  end 
    
end)

RegisterServerEvent('mafias:descend')
AddEventHandler('mafias:descend', function(target)

  local _source = source

  local sourceXPlayer = ESX.GetPlayerFromId(_source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if(targetXPlayer.job.grade == 0)then
    TriggerClientEvent('esx:showNotification', _source, "No puedes ~r~degradar~w~ más.")
  else
    if(sourceXPlayer.job.name == targetXPlayer.job.name)then

      local grade = tonumber(targetXPlayer.job.grade) - 1 
      local job = targetXPlayer.job.name

      targetXPlayer.setJob(job, grade)

      TriggerClientEvent('esx:showNotification', _source, "Has ~r~degradado "..targetXPlayer.name.."~w~.")
      TriggerClientEvent('esx:showNotification', target,  "Has sido ~r~degradado por ".. sourceXPlayer.name.."~w~.")		

    else
      TriggerClientEvent('esx:showNotification', _source, "Usted no tiene ~r~autorización~w~~w~.")

    end

  end 
    
end)

RegisterServerEvent('mafias:recruit')
AddEventHandler('mafias:recruit', function(target, job, grade)

  local _source = source

  local sourceXPlayer = ESX.GetPlayerFromId(_source)
  local targetXPlayer = ESX.GetPlayerFromId(target)
  
    targetXPlayer.setJob(job, grade)

    TriggerClientEvent('esx:showNotification', _source, "Has ~g~reclutado "..targetXPlayer.name.."~w~.")
    TriggerClientEvent('esx:showNotification', target,  "Has sido ~g~reclutado por ".. sourceXPlayer.name.."~w~.")		

end)

RegisterServerEvent('mafias:fire')
AddEventHandler('mafias:fire', function(target)

  local _source = source

  local sourceXPlayer = ESX.GetPlayerFromId(_source)
  local targetXPlayer = ESX.GetPlayerFromId(target)
  local job = "unemployed"
  local grade = "0"

  if(sourceXPlayer.job.name == targetXPlayer.job.name)then
    targetXPlayer.setJob(job, grade)

    TriggerClientEvent('esx:showNotification', _source, "Estas ~r~despedido "..targetXPlayer.name.."~w~.")
    TriggerClientEvent('esx:showNotification', target,  "Fuiste ~g~despedido por ".. sourceXPlayer.name.."~w~.")	
  else

    TriggerClientEvent('esx:showNotification', _source, "Usted no tiene ~r~autorización~w~.")

  end

end)