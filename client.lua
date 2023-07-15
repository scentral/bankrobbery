AddEventHandler("bank-robbery:attemptRobbery")
RegisterNetEvent('bank-robbery:attemptRobbery', function() 
    DisplayUI(true)
    startAnim()
end)

RegisterNetEvent("bank-robbery:enterVault")
AddEventHandler("bank-robbery:enterVault", function() 
    local player = PlayerPedId()
    SetEntityCoords(player, 1174.69, 2711.69, 38.07)
end)

RegisterNetEvent("bank-robbery:hideHelpText")
AddEventHandler("bank-robbery:hideHelpText", function() 
    HideHelpText()
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(0)
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        for k, v in pairs(Config.banks) do
            if v.isRobbable then
                local distance = GetDistanceBetweenCoords(playerCoords, v.coords, true)
                if distance < 1.3 then
                    ShowHelpText("Press ~INPUT_CONTEXT~ to rob ~b~" .. v.bank)
                    if IsControlJustPressed(0, 51) then
                        local street = GetStreetNameAtCoord(v.coords.x, v.coords.y, v.coords.z)
                        TriggerServerEvent("bank-robbery:attemptRobbery", k, GetStreetNameFromHashKey(street))
                        TriggerEvent("bank-robbery:attemptRobbery")
                        v.isRobbable = false
                    end
                end
            end 
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k, v in pairs(Config.banks) do
            if not v.isRobbable then
                Citizen.Wait(3600000)
                v.isRobbable = true
            end
        end
    end
end)

RegisterNUICallback("complete", function()
    DisplayUI(false)
    stopAnim()
    DoScreenFadeOut(1000)
    Citizen.Wait(5000)
    DoScreenFadeIn(1000)
    SendNotification()
end)

RegisterNUICallback("close", function(data)
    DisplayUI(false)
    stopAnim()
end)

function ShowHelpText(text) 
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end

function HideHelpText() 
    BeginTextCommandDisplayHelp("STRING")
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end

function SendNotification()
    SetNotificationTextEntry("STRING")
    -- random money amount between $50,000 and $200,000
    AddTextComponentSubstringPlayerName("You have stolen ~g~$" .. math.random(50000, 200000) .. "~w~ from the bank!")
    AddTextComponentSubstringPlayerName()
    DrawNotification(false, false)
end

function DisplayUI(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool
    })
end

function startAnim()
	Citizen.CreateThread(function()
	  RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
	  while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
	    Citizen.Wait(0)
	  end
		attachObject()
		TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
	end)
end

function attachObject()
	tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
	AttachEntityToEntity(tab, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)
end

function stopAnim()
	StopAnimTask(GetPlayerPed(-1), "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
	DeleteEntity(tab)
end
