if not lib then
    return print('^1[ERROR] OX-LIB WIRD BENÖTIGT UM ' ..GetCurrentResourceName().. ' ZU NUTZEN!') 
end

local function IsAllowed(xPlayer, Jobs)
    for _, job in ipairs(Jobs) do
        if xPlayer.getJob().name == job then
            return true
        end
    end
    return false
end

local function GetDistanceBetween(from, to)
    return #(from - to)
end

local function GetPlayerCoordinates(xPlayer)
    return GetEntityCoords(GetPlayerPed(xPlayer.source))
end

local function FindPlayerWithName(name)
    local targetName = string.gsub(name, "_", " ")
    local xPlayers = ESX.GetExtendedPlayers('name', targetName)
    return xPlayers[1] or nil
end

local function FormatNearby()
    local string = ''
    for _, value in pairs(Config.DistanceCheck.Other) do
        string = string == '' and value.label or string.. ' ' ..Config.Locales['need_to_be_nearby_keyword'].. ' ' ..value.label
    end
    return string
end

local function NotifyFaction(jobName, msg, type)
    local xPlayers = ESX.GetExtendedPlayers('job', jobName)
    for _, xPlayer in pairs(xPlayers) do
        Config.Notify.Server( xPlayer.source, {
            title = "Lizenzsystem",
            description = msg,
            type = type
        })
    end
end

lib.addCommand(Config.CommandName, {
    help = Config.Locales['command_help_description'],
    params = {
        {
            name = 'targetPlayer',
            type = 'string',
            help = Config.Locales['command_param_description']
        }
    }
}, function (source, args, raw)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not IsAllowed(xPlayer, Config.AllowedJobs) then
        return Config.Notify.Server( src, {
            title = 'LIZENZSYSTEM',
            description = Config.Locales['no_permissions'],
            type = 'error'
        })
    end

    if not xPlayer then 
        return Config.Notify.Server( src, {
            title = 'LIZENZSYSTEM',
            description = Config.Locales['unkown_error'],
            type = 'error'
        })
    end

    if not args.targetPlayer then
        return Config.Notify.Server( src, {
            title = 'LIZENZSYSTEM',
            description = Config.Locales['respect_command_usage']:format(Config.CommandName),
            type = 'error'
        })
    end

    if not Config.AllowSelfGive and xPlayer.getName() == args.targetPlayer then
        return Config.Notify.Server( src, {
            title = 'LIZENZSYSTEM',
            description = Config.Locales['cannot_give_to_yourself'],
            type = 'error'
        })
    end

    local xTarget = FindPlayerWithName(args.targetPlayer)
    if not xTarget then
        return Config.Notify.Server( src, {
            title = 'LIZENZSYSTEM',
            description = Config.Locales['player_not_found']:format(args.targetPlayer),
            type = 'error'
        })
    end

    if Config.DistanceCheck.BeetweenPlayers ~= 0.0 and GetDistanceBetween(GetPlayerCoordinates(xPlayer), GetPlayerCoordinates(xTarget)) > Config.DistanceCheck.BeetweenPlayers then
        return Config.Notify.Server( src, {
            title = 'LIZENZSYSTEM',
            description = Config.Locales['player_not_nearby'],
            type = 'error'
        })
    end

    if #Config.DistanceCheck.Other ~= 0 then
        local isInRange = false
        for _, value in pairs(Config.DistanceCheck.Other) do
            if GetDistanceBetween(GetPlayerCoordinates(xPlayer), value.position) < value.distance then
                isInRange = true
                break
            end
        end

        if not isInRange then
            return Config.Notify.Server( src, {
                title = 'LIZENZSYSTEM',
                description = Config.Locales['need_to_be_nearby']:format(FormatNearby()),
                type = 'error'
            })
        end
    end

    local options = {}
    for key, value in pairs(Config.License.Types) do
        if IsAllowed(xPlayer, value.AllowedJobs) then
            options[#options+1] = {
                title = value.label,
                description = Config.Locales["give_license"]:format(value.price),
                icon = value.icon,
                serverEvent = "licenses:tryGiveLic",
                args = {xTarget.source, value}
            }
        end
    end

    TriggerClientEvent('licenses:openMenu', xPlayer.source, xTarget.getName(), options)
end)

RegisterServerEvent("licenses:tryGiveLic", function (object)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        return Config.Notify.Server( src, {
            title = 'LIZENZSYSTEM',
            description = Config.Locales['unkown_error']:format(FormatNearby()),
            type = 'error'
        })
    end
    
    local xTarget = ESX.GetPlayerFromId(object[1])
    if not xTarget then
        return Config.Notify.Server( src, {
            title = 'LIZENZSYSTEM',
            description = Config.Locales['player_not_found']:format(FormatNearby()),
            type = 'error'
        })
    end

    local targetName = xPlayer.getName()
    local itemMetaData = {
        holder = xTarget.getName(),
        type = object[2].name,
        description = Config.Locales['item_description']:format(targetName, object[2].label)
    }

    if object[2].price ~= 0 and xPlayer.getAccount(Config.PayAccount).money < object[2].price then
        return Config.Notify.Server( src, {
            title = 'LIZENZSYSTEM',
            description = Config.Locales['not_enough_money']:format(FormatNearby()),
            type = 'error'
        })
    end

    if not Config.Inventory.CanCarryItem(xPlayer.source, Config.License.ItemName, 1, itemMetaData) then
        return Config.Notify.Server( src, {
            title = 'LIZENZSYSTEM',
            description = Config.Locales['not_enough_space']:format(FormatNearby()),
            type = 'error'
        })
    end

    Config.Inventory.AddItem(xPlayer.source, Config.License.ItemName, 1, itemMetaData)

    NotifyFaction(xPlayer.getJob().name, Config.Locales['faction_notify']:format(
        xPlayer.getJob().grade,
        xPlayer.getName(),
        xTarget.getName(),
        object[2].label
    ), 'info')

    Config.Notify.Server( src, {
        title = 'LIZENZSYSTEM',
        description =  Config.Locales['gave_license']:format(xTarget.getName(), object[2].label),
        type = 'success'
    })

    Config.Notify.Server( xTarget.source, {
        title = 'LIZENZSYSTEM',
        description =  Config.Locales['got_license']:format(xPlayer.getName(), object[2].label),
        type = 'success'
    })

    if object[2].price ~= 0 then xPlayer.removeAccountMoney(Config.PayAccount, object[2].price) end
end)