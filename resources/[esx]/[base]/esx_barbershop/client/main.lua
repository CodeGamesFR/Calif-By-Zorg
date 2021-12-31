------ BASE EDIT BY ZORG DEV PAR KIROZ -----
_print = print
_TriggerServerEvent = TriggerServerEvent
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

local HasAlreadyEnteredMarker = false
local LastZone = nil

local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

local HasPayed = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
end)

function OpenShopMenu()
	HasPayed = false

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = _U('valid_purchase'),
			elements = {
				{label = _U('no'), value = 'no'},
				{label = _U('yes'), value = 'yes'}
			}
		}, function(data, menu)
			menu.close()

			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('esx_barbershop:checkMoney', function(hasEnoughMoney)
					if hasEnoughMoney then
						TriggerEvent('skinchanger:getSkin', function(skin)
							_TriggerServerEvent('esx_skin:save', skin)
						end)

						_TriggerServerEvent('esx_barbershop:pay')

						HasPayed = true
					else
						TriggerEvent('esx_skin:getLastSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
						end)

						ESX.ShowNotification(_U('not_enough_money'))
					end
				end)
			end

			if data.current.value == 'no' then
				TriggerEvent('esx_skin:getLastSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			CurrentAction = 'shop_menu'
			CurrentActionMsg = _U('press_access')
			CurrentActionData = {}
		end, function(data, menu)
			CurrentAction = 'shop_menu'
			CurrentActionMsg = _U('press_access')
			CurrentActionData = {}
		end)
	end, function(data, menu)
		CurrentAction = 'shop_menu'
		CurrentActionMsg = _U('press_access')
		CurrentActionData = {}
	end, {
		'beard_1',
		'beard_2',
		'beard_3',
		'beard_4',
		'hair_1',
		'hair_2',
		'hair_color_1',
		'hair_color_2',
	})
end

AddEventHandler('esx_barbershop:hasEnteredMarker', function(zone)
	CurrentAction = 'shop_menu'
	CurrentActionMsg = _U('press_access')
	CurrentActionData = {}
end)

AddEventHandler('esx_barbershop:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil

	if not HasPayed then
		TriggerEvent('esx_skin:getLastSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
	end
end)

Citizen.CreateThread(function()
	for i = 1, #Config.Shops, 1 do
		local blip = AddBlipForCoord(Config.Shops[i])

		SetBlipSprite(blip, 71)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 51)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('barber_blip'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local plyCoords = GetEntityCoords(PlayerPedId(), false)

		for i = 1, #Config.Shops, 1 do
			if #(plyCoords - Config.Shops[i]) < Config.DrawDistance then
				DrawMarker(29, Config.Shops[i], vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(0.5, 0.5, 0.5), 0, 255, 0, 100, false, false, 2, true, nil, nil, false)
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local plyCoords = GetEntityCoords(PlayerPedId(), false)
		local isInMarker = false
		local currentZone

		for i = 1, #Config.Shops, 1 do
			if #(plyCoords - Config.Shops[i]) < Config.MarkerSize.x then
				isInMarker = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_barbershop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_barbershop:hasExitedMarker', LastZone)
		end
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentSubstringPlayerName(CurrentActionMsg)
			EndTextCommandDisplayHelp(0, 0, 1, -1)

			if IsControlPressed(0, 38) then
				if CurrentAction == 'shop_menu' then
					OpenShopMenu()
				end

				CurrentAction = nil
			end
		end
	end
end)

