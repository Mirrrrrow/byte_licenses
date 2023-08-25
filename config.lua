Config = {}

Config.CommandName = 'givelic'
Config.AllowSelfGive = true

Config.PayAccount = 'money'

Config.AllowedJobs = {'police'}

Config.DistanceCheck = {
    BeetweenPlayers = 5.0,
    Other = {
        {
            label = 'DMV-HQ', 
            position = vector3(-820.5547, -1332.5043, 5.1502), 
            distance = 50.0 -- Distance
        },
    }
}

Config.Inventory = {
    CanCarryItem = function(playerId, itemName, itemCount, metaData)
        return exports.ox_inventory:CanCarryItem(playerId, itemName, itemCount, metaData)
    end,
    AddItem = function(playerId, itemName, itemCount, metaData)
        exports.ox_inventory:AddItem(playerId, itemName, itemCount, metaData)
    end
}

Config.Notify = {
    Client = function(data)
        lib.notify(data)
    end,
    Server = function(playerId, data)
        -- data.title, data.description, data.title
        TriggerClientEvent('ox_lib:notify', playerId, data)
    end
}

Config.Locales = {
    ['unkown_error'] = 'An unkown error occured',
    ['command_help_description'] = 'Give a license to somebody',
    ['command_param_description'] = 'Name of the person',
    ['player_not_found'] = '%s could not be found.',
    ['cannot_give_to_yourself'] = 'You cannot give yourself a license',
    ['no_permissions'] = 'You dont have the permission to do this.',
    ['respect_command_usage'] = 'Please use /%s <Firstname_Lastname>',
    ['player_not_nearby'] = 'The person has to be near you.',
    ['need_to_be_nearby'] = 'To give out a license you have to be near %s.',
    ['need_to_be_nearby_keyword'] = 'or',
    ['give_license'] = 'Give license for %s$',
    ['menu_title'] = 'Issue licenses to %s',
    ['not_enough_space'] = 'You dont have enough space',
    ['not_enough_money'] = 'You dont have enough money',
    ['item_description'] = "Holder %s  \nType: %s",
    ['gave_license'] ='You gave %s %s',
    ['got_license'] = '%s gave you %s.',
    ['faction_notify'] = "Grade %s | %s gave %s the license %s.",
}

--[[Config.Locales = {
    ['unkown_error'] = 'Es ist ein unbekannter Fehler aufgetreten.',
    ['command_help_description'] = 'Gebe einer Person eine Lizenz',
    ['command_param_description'] = 'Name der Person',
    ['player_not_found'] = '%s konnte nicht gefunden werden.',
    ['cannot_give_to_yourself'] = 'Du kannst dir keine Lizenz ausstellen.',
    ['no_permissions'] = 'Du hast keine Rechte dazu.',
    ['respect_command_usage'] = 'Bitte nutze /%s <Vorname_Nachname>',
    ['player_not_nearby'] = 'Die Person befindet sich nicht in deiner Nähe.',
    ['need_to_be_nearby'] = 'Um eine Lizenz auszustellen musst du in der Nähe von %s sein.',
    ['need_to_be_nearby_keyword'] = 'oder',
    ['give_license'] = 'Lizenz für %s$ vergeben',
    ['menu_title'] = 'Lizenzen an %s vergeben',
    ['not_enough_space'] = 'Du hast nicht genügend Platz.',
    ['not_enough_money'] = 'Du hast nicht genügend Geld',
    ['item_description'] = "Besitzer %s  \nTyp: %s",
    ['gave_license'] ='Sie haben %s %s ausgestellt.',
    ['got_license'] = '%s hat Ihnen %s ausgestellt.',
    ['faction_notify'] = "Rang %s | %s hat %s %s ausgestellt.",
}--]]

Config.License = {
    --[[Types = {
        DrivingA = {
            ItemName = 'mastercard',
            AllowedJobs = {"dmv", "police"},
            name = "license_driving_a",
            label = "Führerschein Klasse A",
            icon = "car",
            price = 15000
        },
        Weapon = {
            ItemName = 'mastercard',
            AllowedJobs = {"police", "sheriff"},
            name = "weapon_license",
            icon = "gun",
            price = 30000,
            label = "Waffenschein Typ A"
        }
    }--]]
    Types = {
        DrivingA = {
            ItemName = 'mastercard',
            AllowedJobs = {"dmv"},
            name = "license-driving-a",
            label = "Driverslicense A",
            icon = "car",
            price = 15000
        },
        Weapon = {
            ItemName = 'mastercard',
            AllowedJobs = {"police", "sheriff"},
            name = "weapon_license",
            icon = "gun",
            price = 30000,
            label = "Gunlicense A"
        }
    }
}