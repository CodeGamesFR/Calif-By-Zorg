------ BASE EDIT BY ZORG DEV PAR KIROZ -----
_print = print
_TriggerServerEvent = TriggerServerEvent
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

local firstSpawn = false

AddEventHandler('playerSpawned', function()
	if not firstSpawn then
		_TriggerServerEvent('rocade:playerConnected')
		firstSpawn = true
	end
end)

