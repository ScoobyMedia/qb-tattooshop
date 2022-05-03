local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('SmallTattoos:GetPlayerTattoos', function(source, cb)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	if Player then
		MySQL.Async.fetchAll('SELECT tattoos FROM players WHERE citizenid = ?', { Player.PlayerData.citizenid }, function(result)
			if result[1].tattoos then
				print(result[1].tattoos)
				cb(json.decode(result[1].tattoos))
			else
				cb()
			end
		end)
	else
		cb()
		print("player não encontrado")
	end
end)

QBCore.Functions.CreateCallback('SmallTattoos:PurchaseTattoo', function(source, cb, tattooList, price, tattoo, tattooName)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)

	if Player.PlayerData.money.cash >= price then
		Player.Functions.RemoveMoney('cash', price)
		table.insert(tattooList, tattoo)

			MySQL.Async.execute('UPDATE players SET tattoos = ? WHERE citizenid = ?', { json.encode(tattooList), Player.PlayerData.citizenid })

		TriggerClientEvent('QBCore:Notify', src, "você fez ~y~" .. tattooName .. "~s~ e pagou ~g~R$" .. price, "success", 4000)
		cb(true)
	else
		TriggerClientEvent('QBCore:Notify', src, "Você não tem dinheiro o suficiente para fazer esta tatuagem", "error", 4000)
		cb(false)
	end
end)

RegisterServerEvent('SmallTattoos:RemoveTattoo')
AddEventHandler('SmallTattoos:RemoveTattoo', function (tattooList)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	MySQL.Async.execute('UPDATE players SET tattoos = ? WHERE citizenid = ?', { json.encode(tattooList), Player.PlayerData.citizenid })
end)
