local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add("permakill", "Permanently kill a character", {
    { name = "citizenid", help = "Character Citizen ID" }
}, true, function(source, args)
    local citizenid = args[1]
    if not citizenid then return end

    MySQL.update('UPDATE players SET permakilled = 1 WHERE citizenid = ?', {citizenid}, function(affected)
        if affected > 0 then
            for _, id in pairs(QBCore.Functions.GetPlayers()) do
                local Player = QBCore.Functions.GetPlayer(id)
                if Player and Player.PlayerData.citizenid == citizenid then
                    DropPlayer(id, "Your character has been permanently killed.")
                end
            end
            print("Character " .. citizenid .. " has been permakilled.")
        end
    end)
end, "admin")

QBCore.Commands.Add("unpermakill", "Restore a permakilled character", {
    { name = "citizenid", help = "Character Citizen ID" }
}, true, function(source, args)
    local citizenid = args[1]
    if not citizenid then return end

    MySQL.update('UPDATE players SET permakilled = 0 WHERE citizenid = ?', {citizenid}, function(affected)
        if affected > 0 then
            print("Character " .. citizenid .. " has been unpermakilled.")
        end
    end)
end, "admin")

QBCore.Functions.CreateCallback('qb-permakill:checkPermakill', function(source, cb, citizenid)
    MySQL.scalar('SELECT permakilled FROM players WHERE citizenid = ?', {citizenid}, function(result)
        print(result)
        cb(result == 1)
    end)
end)