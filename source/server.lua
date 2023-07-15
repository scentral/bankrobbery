RegisterNetEvent("bank-robbery:attemptRobbery")
AddEventHandler("bank-robbery:attemptRobbery", function(bank, street) 
    Citizen.Wait(5000)
    if Config.Alert.enable then
        if math.random(0, 100) < 1 then
            TriggerClientEvent('chatMessage', source, '[Partner]', {255, 0, 0}, 'The manager has been knocked out and the silent alarm will not go off.')
        else
            TriggerClientEvent('chatMessage', -1, Config.Alert.prefix, {255, 0, 0}, 'A silent alarm has been triggered at ' .. street .. ' ' .. Config.banks[bank].bank .. '')
        end
    end

    -- Hude the help text from all players
    TriggerClientEvent("bank-robbery:hideHelpText", -1)
end)

print('Bank Robbery by scentral')
