RegisterServerEvent('dans_smolstuff_bath:server:pay')
AddEventHandler('dans_smolstuff_bath:server:pay', function(price, type)
    TriggerEvent('redemrp:getPlayerFromId', source, function(user)
        local _source = source
        if user.getMoney() >= price then
            user.removeMoney(price)
            TriggerClientEvent('dans_smolstuff_bath:client:clean', _source, type)
            TriggerClientEvent('redemrp_notification:start', _source, "You have cleaned yourself!", 3, success)
        else
            TriggerClientEvent('redemrp_notification:start', _source, "You do not have enough money!", 3, error)
        end
    end)
end)