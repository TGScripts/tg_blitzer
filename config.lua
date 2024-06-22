Config = {}

Config.Debug                =   false                           -- Debug Modus aktivieren / deaktivieren

Config.DisableBlips         =   false                           -- Wenn 'true' werden gar keine Blips angezeigt
Config.WhitelistedJobs      =   {'police','fib','ambulance'}    -- Jobs die nicht geblitzt werden
Config.DisableProps         =   false                           -- Wenn 'false' werden keine Props auf der Map platziert
Config.Prop                 =   'prop_elecbox_03a'              -- Prop das an der Prop Stelle geplaced wird
Config.Account              =   'bank'                          -- Account des Spielers von dem das Geld abgebucht werden soll (zB. Bank)
Config.Reciever             =   'society_police'                -- Auf welches (Fraktions-) Konto soll die Rechnung gehen? - Leer lassen damit es ins nichts geht
Config.BillMultiplyer       =   9                               -- Wie viel wird pro KM/H dazugerechnet? (km/h * Multiplyer)
Config.Blipname             =   'Blitzer'                       -- Falls der Blip angezeigt werden soll, wie soll er heißen?

Config.Blitzer = {
    Blitzer_Hauptplatz = {

        Prop = {
            activated = true, -- Soll ein Objekt gespawned werden?
            Coords = vector3(242.0643, -826.1656, 28.9841) -- Wo soll das Objekt gespawned werden? (& Blip)
        },

        Lane = {
            Coords = vector3(251.0114, -838.3312, 28.7378), -- Spur die geblitzt werden soll
            Radius = 10, -- Radius der Spur
            Speedlimit = 50 -- Tempolimit
        },

        ActivateSecondLane = true, -- Gegenfahrbahn Blitzer aktiveren

        SecondLane = {
            Coords = vector3(232.1089, -848.5179, 29.0755), -- Gegenfahrbahn Spur
            Radius = 10, -- Radius der Gegenfahrbahn Spur
            Speedlimit = 50 -- Tempolimit
        },
        
        Blip = true, -- Soll ein Blip auf der Karte angezeigt werden?
    },
}