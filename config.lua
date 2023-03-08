Config = {}

Config.ActivateBill         =   true                            -- DEAKTIVIERT: Wenn 'false' wird das Geld direkt vom Bank Account abgebucht
Config.DisableBlips         =   true                           -- Wenn 'true' werden gar keine Blips angezeigt
Config.WhitelistedJobs      =   {'police','fib','ambulance'}    -- Jobs die nicht geblitzt werden
Config.ActivateFlash        =   false                           -- Beta Feature: Funktioniert noch nicht
Config.DisableProps         =   false                           -- Wenn 'false' werden keine Props auf der Map platziert
Config.Prop                 =   'prop_elecbox_03a'              -- Prop das an der Prop Stelle geplaced wird

Config.Blitzer = {
    -- von hier
    Blitzer_Hauptplatz = {

        Prop = {
            activated = true, -- Soll ein Objekt gespawned werden?
            Coords = vector3(242.0643, -826.1656, 28.9841) -- Wo soll das Objekt gespawned werden? (& Blip)
        },

        Lane = {
            Coords = vector3(251.0114, -838.3312, 28.7378), -- Spur die geblitzt werden soll
            Radius = 10 -- Radius der Spur
        },

        ActivateSecondLane = true, -- Gegenfahrbahn Blitzer aktiveren

        SecondLane = {
            Coords = vector3(232.1089, -848.5179, 29.0755), -- Gegenfahrbahn Spur
            Radius = 10 -- Radius der Gegenfahrbahn Spur
        },

        Blip = true, -- Soll ein Blip auf der Karte angezeigt werden?

        Speedlimit = 80 -- Tempolimit

    },
    -- bis hier
}