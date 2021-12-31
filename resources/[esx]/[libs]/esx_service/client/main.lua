------ BASE EDIT BY ZORG DEV PAR KIROZ -----
_print = print
_TriggerServerEvent = TriggerServerEvent
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_service:notifyAllInService')
AddEventHandler('esx_service:notifyAllInService', function(notification, targetId)
	local target = GetPlayerFromServerId(targetId)

	if target == PlayerId() or target < 1 then
		return
	end

	local targetPed = GetPlayerPed(target)
	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(targetPed)

	ESX.ShowAdvancedNotification(notification.title, notification.subject, notification.msg, mugshotStr, notification.iconType)
	UnregisterPedheadshot(mugshot)
end)

