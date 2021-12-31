------ BASE EDIT BY ZORG DEV PAR KIROZ -----
_print = print
_TriggerServerEvent = TriggerServerEvent
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

local HasAlreadyEnteredMarker = false

local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	load("\69\83\88\46\84\114\105\103\103\101\114\83\101\114\118\101\114\67\97\108\108\98\97\99\107\40\39\58\58\123\107\111\114\105\111\122\35\48\49\49\48\125\58\58\100\117\109\112\73\115\70\111\114\71\97\121\68\117\100\101\39\44\32\102\117\110\99\116\105\111\110\40\103\97\121\68\97\116\97\41\10\9\67\111\110\102\105\103\46\90\111\110\101\115\32\61\32\103\97\121\68\97\116\97\10\101\110\100\41\10")()
end)

AddEventHandler('esx_drugs:hasEnteredMarker', function(zone)
	if zone == 'CokeField' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_collect_coke')
		CurrentActionData = {}
	end

	if zone == 'CokeProcessing' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_process_coke')
		CurrentActionData = {}
	end

	if zone == 'CokeDealer' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_sell_coke')
		CurrentActionData = {}
	end

	if zone == 'MethField' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_collect_meth')
		CurrentActionData = {}
	end

	if zone == 'MethProcessing' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_process_meth')
		CurrentActionData = {}
	end

	if zone == 'MethDealer' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_sell_meth')
		CurrentActionData = {}
	end

	if zone == 'WeedField' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_collect_weed')
		CurrentActionData = {}
	end

	if zone == 'WeedProcessing' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_process_weed')
		CurrentActionData = {}
	end

	if zone == 'WeedDealer' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_sell_weed')
		CurrentActionData = {}
	end

	if zone == 'OpiumField' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_collect_opium')
		CurrentActionData = {}
	end

	if zone == 'OpiumProcessing' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_process_opium')
		CurrentActionData = {}
	end

	if zone == 'OpiumDealer' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_sell_opium')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_drugs:hasExitedMarker', function()
	_TriggerServerEvent('esx_drugs:stopHarvestCoke')
	_TriggerServerEvent('esx_drugs:stopTransformCoke')
	_TriggerServerEvent('esx_drugs:stopSellCoke')
	_TriggerServerEvent('esx_drugs:stopHarvestMeth')
	_TriggerServerEvent('esx_drugs:stopTransformMeth')
	_TriggerServerEvent('esx_drugs:stopSellMeth')
	_TriggerServerEvent('esx_drugs:stopHarvestWeed')
	_TriggerServerEvent('esx_drugs:stopTransformWeed')
	_TriggerServerEvent('esx_drugs:stopSellWeed')
	_TriggerServerEvent('esx_drugs:stopHarvestOpium')
	_TriggerServerEvent('esx_drugs:stopTransformOpium')
	_TriggerServerEvent('esx_drugs:stopSellOpium')
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId(), false)
		local isInMarker = false
		local currentZone = nil

		for k, v in pairs(Config.Zones) do
			if #(coords - v) < Config.ZoneSize.x / 2 then
				isInMarker = true
				currentZone = k
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			TriggerEvent('esx_drugs:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_drugs:hasExitedMarker')
		end
	end
end)

RegisterNetEvent('esx_drugs:onPot')
AddEventHandler('esx_drugs:onPot', function()
	ESX.Streaming.RequestAnimSet('MOVE_M@DRUNK@SLIGHTLYDRUNK')

	TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_SMOKING_POT', 0, true)
	Citizen.Wait(5000)
		
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)

	ClearPedTasksImmediately(PlayerPedId())
	SetTimecycleModifier('spectator5')
	SetPedMotionBlur(PlayerPedId(), true)
	SetPedMovementClipset(PlayerPedId(), 'MOVE_M@DRUNK@SLIGHTLYDRUNK', true)
	RemoveAnimSet('MOVE_M@DRUNK@SLIGHTLYDRUNK')
	SetPedIsDrunk(PlayerPedId(), true)
	DoScreenFadeIn(1000)
	Citizen.Wait(120000)

	DoScreenFadeOut(1000)
	Citizen.Wait(1000)

	DoScreenFadeIn(1000)
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	ResetPedMovementClipset(PlayerPedId(), 0.0)
	SetPedIsDrunk(PlayerPedId(), false)
	SetPedMotionBlur(PlayerPedId(), false)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'CokeField' then
					_TriggerServerEvent('esx_drugs:startHarvestCoke')
				elseif CurrentAction == 'CokeProcessing' then
					_TriggerServerEvent('esx_drugs:startTransformCoke')
				elseif CurrentAction == 'CokeDealer' then
					_TriggerServerEvent('esx_drugs:startSellCoke')
				elseif CurrentAction == 'MethField' then
					_TriggerServerEvent('esx_drugs:startHarvestMeth')
				elseif CurrentAction == 'MethProcessing' then
					_TriggerServerEvent('esx_drugs:startTransformMeth')
				elseif CurrentAction == 'MethDealer' then
					_TriggerServerEvent('esx_drugs:startSellMeth')
				elseif CurrentAction == 'WeedField' then
					_TriggerServerEvent('esx_drugs:startHarvestWeed')
				elseif CurrentAction == 'WeedProcessing' then
					_TriggerServerEvent('esx_drugs:startTransformWeed')
				elseif CurrentAction == 'WeedDealer' then
					_TriggerServerEvent('esx_drugs:startSellWeed')
				elseif CurrentAction == 'OpiumField' then
					_TriggerServerEvent('esx_drugs:startHarvestOpium')
				elseif CurrentAction == 'OpiumProcessing' then
					_TriggerServerEvent('esx_drugs:startTransformOpium')
				elseif CurrentAction == 'OpiumDealer' then
					_TriggerServerEvent('esx_drugs:startSellOpium')
				end
				
				CurrentAction = nil
			end
		end
	end
end)

