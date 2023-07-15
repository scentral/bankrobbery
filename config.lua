Config = {}

Config.banks = {
    {
        bank = "Fleeca Bank",
        coords = vector3(1175.96, 2712.92, 38.09),
        isRobbable = true
    }, 
    {
        bank = "Fleeca Bank",
        coords = vector3(147.0, -1045.0, 29.37),
        isRobbable = true
    }
}

Config.Alert = {
    enable = true,
    prefix = "^1[^2Bank Robbery^1]",
    message = "A silent alarm has been triggered at ^2%s^0." -- %s is the bank name if you remove it the bank name will not appear in the alert
}