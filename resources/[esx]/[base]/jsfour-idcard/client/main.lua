------ BASE EDIT BY ZORG DEV PAR KIROZ -----
_print = print
_TriggerServerEvent = TriggerServerEvent
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

local open = false

RegisterNetEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function(data, type)
	open = true

	SendNUIMessage({
		action = 'open',
		array = data,
		type = type
	})
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if (IsControlJustReleased(0, 322) and open) or (IsControlJustReleased(0, 177) and open) then
			SendNUIMessage({
				action = 'close'
			})

			open = false
		end
	end
end)

