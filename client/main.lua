if not lib then
    return print('^1[ERROR] OX-LIB WIRD BENÖTIGT UM ' ..GetCurrentResourceName().. ' ZU NUTZEN!') 
end

RegisterNetEvent('licenses:openMenu')
AddEventHandler('licenses:openMenu', function(target, options)
    lib.registerContext({
        id = 'give_license',
        title = Config.Locales['menu_title']:format(target),
        options = options
    })

    lib.showContext('give_license')
end)