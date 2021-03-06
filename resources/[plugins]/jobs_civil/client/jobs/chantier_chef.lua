RMenu.Add('chantier', 'main', RageUI.CreateMenu("Chantier", " "))
RMenu.Get('chantier', 'main'):SetSubtitle("~b~Manager du Chantier")
RMenu.Get('chantier', 'main').EnableMouse = false
RMenu.Get('chantier', 'main').Closed = function()
	RenderScriptCams(false, true, 1500, true, true)
	DestroyCam(cam, true)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local distance = #(GetEntityCoords(PlayerPedId()) - zone.Chantier)

		if distance <= 3.0 then
			ESX.ShowHelpNotification("Appuyer sur ~b~E~w~ pour parler avec la personne.")

			if IsControlJustPressed(0, 51) and distance <= 3.0 then
				RageUI.Visible(RMenu.Get('chantier', 'main'), true)
				CreateCamera()
			end
		end
	end
end)

RageUI.CreateWhile(1.0, nil, nil, function()
	RageUI.IsVisible(RMenu.Get('chantier', 'main'), true, true, true, function()
		if not AuTravailleChantier then
			RageUI.Button("Demander à travailler sur le Chantier", nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					RageUI.Popup({message = "Alors comme ça tu veux bosser sur le ~g~chantier~w~ ? Très bien, met un casque et prends tes outils ! Je te préviens c'est pas pour les petite fiottes !"})

					RageUI.Visible(RMenu.Get('chantier', 'main'), false)
					RenderScriptCams(false, true, 1500, true, true)
					DestroyCam(cam, true)
					AuTravailleChantier = true

					TriggerEvent('skinchanger:getSkin', function(skin)
						local clothesSkin = {
							['bags_1'] = 0, ['bags_2'] = 0,
								['tshirt_1'] = 59, ['tshirt_2'] = 0,
								['torso_1'] = 56, ['torso_2'] = 0,
								['arms'] = 30,
								['pants_1'] = 31, ['pants_2'] = 0,
								['shoes_1'] = 25, ['shoes_2'] = 0,
								['mask_1'] = 0, ['mask_2'] = 0,
								['bproof_1'] = 0, ['bproof_2'] = 0,
								['helmet_1'] = 0, ['helmet_2'] = 0
						}

						TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
					end)

					StartTravailleChantier()
				end
			end)
		else
			RageUI.Button("Arreter de travailler", nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					RageUI.Popup({message = "Haha ! Tu stop déja ! Allez prends ta paye feignant ! Merci de ton aide, revient quand tu veux."})

					RageUI.Visible(RMenu.Get('chantier', 'main'), false)
					RenderScriptCams(false, true, 1500, true, true)
					DestroyCam(cam, true)
					AuTravailleChantier = false

					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
						local isMale = skin.sex == 0

						TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
							ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin)
								TriggerEvent('esx:restoreLoadout')
							end)
						end)
					end)
				end
			end)
		end
	end, function()
	end)
end)