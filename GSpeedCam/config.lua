Config = {}

-- Blacklisted (EMS) vehicles
Config.EMSVehicles = {
    'AMBULANCE',
    'FIRETRUK',
    'POLICE',
    'POLICE2',
}

-- Speed camera zones (and blip locations)
Config.SpeedCameras = {
    {x=289.65, y=-855.25, z=28.92},
    {x=107.75, y=-998.35, z=29.09},
    {x=478.02, y=-311.94, z=46.32},
    {x=694.89, y=13.07, z=84.81},
    {x=-189.18, y=-892.51, z=28.95},
    {x=-244.03, y=-400.03, z=29.92},
    {x=-631.04, y=-369.04, z=34.43},
    {x=-545.09, y=-659.83, z=32.07},
    {x=-1438.95, y=-753.53, z=23.22},
    {x=1696.97, y=3508.42, z=36.17},
    {x=-304.77, y=6228.08, z=31.15},
}

-- Use blips setting
Config.UseBlips = true

-- Fines for different speed ranges
Config.Fines = {
    {minSpeed = 80, maxSpeed = 85, amount = 0},
    {minSpeed = 85, maxSpeed = 90, amount = 1500},
    {minSpeed = 90, maxSpeed = 100, amount = 2500},
    {minSpeed = 100, maxSpeed = 110, amount = 3900},
    {minSpeed = 110, maxSpeed = 120, amount = 4900},
    {minSpeed = 120, maxSpeed = 130, amount = 6900},
    {minSpeed = 130, maxSpeed = 230, amount = 16900},
    {minSpeed = 230, maxSpeed = math.huge, amount = 26900},
}

return Config
