TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.AddGroupCommand('ac_bypass', 'admin', function(source, args, user) end)

RegisterServerEvent('myAcSuckYourAssholeHacker')
AddEventHandler('myAcSuckYourAssholeHacker', function(report)
	local _source = source

	if not IsPlayerAceAllowed(_source, 'command.ac_bypass') then
		TriggerEvent('esx:customDiscordLog', "Joueur : " .. GetPlayerName(_source) .. " [" .. _source .. "] (" .. ESX.GetIdentifierFromId(_source) .. ") - Méthode : " .. report)
	end
end)

ESX.AddGroupCommand('cleanup', "admin", function(source, args, user)
	TriggerClientEvent('byebyeEntities', -1)
end)