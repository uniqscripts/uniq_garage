return {
    
    ['Garage Innocence Boulevard' --[[ 2 car garage ]] ] = {
        interiorId = 148737,
        enter = vec3(-341.679, -1474.928, 30.750),
        parkVehicle = vec3(-339.623, -1464.116, 30.597),
        insideSpawn = vec4(207.188, -999.216, -99.000, 89.841),
        vehicleSpawnPoint = vec4(-339.220, -1468.510, 30.175, 267.895),
        price = 30000,
        blip = { id = 357, colour = 3, scale = 0.9 },
        blackListClass = { 14, 15, 16, 19, 21 }, -- https://docs.fivem.net/natives/?_0x29439776AAA00A62
        hasMultipleFloors = false,
        Vehicles = {
            [1] = {
                vec4(194.384, -1000.027, -99.424, 179.924),
                vec4(202.148, -1000.393, -99.424, 177.726)
            }
        },
        GarageInfo = 'Can store 2 vehicles.'
    },

    ['Eclipse Boulevard Garage' --[[ 50 car garage ]]] = {
        interiorId = 290561,
        ipl = 'xm3_garage_fix',
        enter = vec3(-286.271, 280.641, 89.888),
        parkVehicle = vec3(-269.203, 279.701, 90.306),
        insideSpawn = vec4(528.401, -2638.002, -49.000, 97.635), -- also exit
        vehicleSpawnPoint = vec4(-272.861, 277.642, 89.620, 175.041),
        editMenu = vec3(524.677, -2638.506, -49.000),
        price = 2740000,
        blip = { id = 357, colour = 3, scale = 0.9 },
        blackListClass = { 14, 15, 16, 19, 21 }, -- https://docs.fivem.net/natives/?_0x29439776AAA00A62
        EntitySets = {
            Purchasable = {
                ['Tint'] = {
                    { label = 'White', price = 75000, style = 1, iscolor = true, },
                    { label = 'Gray', price = 75000, style = 2, iscolor = true },
                    { label = 'Black', price = 75000, style = 3, iscolor = true },
                    { label = 'Purple', price = 75000, style = 4, iscolor = true },
                    { label = 'Orange', price = 75000, style = 5, iscolor = true },
                    { label = 'Yellow', price = 75000, style = 6, iscolor = true },
                    { label = 'Blue', price = 75000, style = 7, iscolor = true },
                    { label = 'Red', price = 75000, style = 8, iscolor = true },
                    { label = 'Green', price = 75000, style = 9, iscolor = true},
                    { label = 'Vintage Blue', price = 75000, style = 10, iscolor = true },
                    { label = 'Vintage Red', price = 75000, style = 11, iscolor = true },
                    { label = 'Vintage Green', price = 75000, style = 12, iscolor = true },
                },
                ['Walls'] = {
                    { label = 'Immaculate', style = 'entity_set_shell_01', price = 137000 },
                    { label = 'Industrial', style = 'entity_set_shell_02', price = 180000 },
                    { label = 'Indulgent', style = 'entity_set_shell_03', price = 265000 },
                }
            },
            Default = {
                [1] = { 'entity_set_shell_01', 'entity_set_numbers_01', 1 },
                [2] = { 'entity_set_shell_01', 'entity_set_numbers_02', 1 },
                [3] = { 'entity_set_shell_01', 'entity_set_numbers_03', 1 },
                [4] = { 'entity_set_shell_01', 'entity_set_numbers_04', 1 },
                [5] = { 'entity_set_shell_01', 'entity_set_numbers_05', 1 },
            }
        },
        DeactivateInterior = function()
            local list = {
                'entity_set_shell_01',
                'entity_set_shell_02',
                'entity_set_shell_03',
                'entity_set_numbers_01',
                'entity_set_numbers_02',
                'entity_set_numbers_03',
                'entity_set_numbers_04',
                'entity_set_numbers_05',
            }

            for i = 1, #list do
                if IsInteriorEntitySetActive(290561, list[i]) then
                    DeactivateInteriorEntitySet(290561, list[i])
                end
            end
        end,
        hasMultipleFloors = true,
        Vehicles = {
            [1] = { -- floor
                vec4(523.858, -2633.473, -49.420, 68.767),
                vec4(524.019, -2628.844, -49.421, 68.777),
                vec4(524.191, -2623.912, -49.420, 66.021),
                vec4(524.111, -2619.902, -49.420, 67.442),
                vec4(524.217, -2615.142, -49.420, 63.122),
                vec4(515.537, -2633.750, -49.420, 297.266),
                vec4(515.128, -2629.531, -49.420, 291.997),
                vec4(515.419, -2625.219, -49.420, 291.996),
                vec4(515.221, -2621.091, -49.420, 294.086),
                vec4(515.287, -2616.303, -49.421, 310.113)
            },
            [2] = {
                vec4(523.858, -2633.473, -49.420, 68.767),
                vec4(524.019, -2628.844, -49.421, 68.777),
                vec4(524.191, -2623.912, -49.420, 66.021),
                vec4(524.111, -2619.902, -49.420, 67.442),
                vec4(524.217, -2615.142, -49.420, 63.122),
                vec4(515.537, -2633.750, -49.420, 297.266),
                vec4(515.128, -2629.531, -49.420, 291.997),
                vec4(515.419, -2625.219, -49.420, 291.996),
                vec4(515.221, -2621.091, -49.420, 294.086),
                vec4(515.287, -2616.303, -49.421, 310.113)
            },
            [3] = {
                vec4(523.858, -2633.473, -49.420, 68.767),
                vec4(524.019, -2628.844, -49.421, 68.777),
                vec4(524.191, -2623.912, -49.420, 66.021),
                vec4(524.111, -2619.902, -49.420, 67.442),
                vec4(524.217, -2615.142, -49.420, 63.122),
                vec4(515.537, -2633.750, -49.420, 297.266),
                vec4(515.128, -2629.531, -49.420, 291.997),
                vec4(515.419, -2625.219, -49.420, 291.996),
                vec4(515.221, -2621.091, -49.420, 294.086),
                vec4(515.287, -2616.303, -49.421, 310.113)
            },
            [4] = {
                vec4(523.858, -2633.473, -49.420, 68.767),
                vec4(524.019, -2628.844, -49.421, 68.777),
                vec4(524.191, -2623.912, -49.420, 66.021),
                vec4(524.111, -2619.902, -49.420, 67.442),
                vec4(524.217, -2615.142, -49.420, 63.122),
                vec4(515.537, -2633.750, -49.420, 297.266),
                vec4(515.128, -2629.531, -49.420, 291.997),
                vec4(515.419, -2625.219, -49.420, 291.996),
                vec4(515.221, -2621.091, -49.420, 294.086),
                vec4(515.287, -2616.303, -49.421, 310.113)
            },
            [5] = {
                vec4(523.858, -2633.473, -49.420, 68.767),
                vec4(524.019, -2628.844, -49.421, 68.777),
                vec4(524.191, -2623.912, -49.420, 66.021),
                vec4(524.111, -2619.902, -49.420, 67.442),
                vec4(524.217, -2615.142, -49.420, 63.122),
                vec4(515.537, -2633.750, -49.420, 297.266),
                vec4(515.128, -2629.531, -49.420, 291.997),
                vec4(515.419, -2625.219, -49.420, 291.996),
                vec4(515.221, -2621.091, -49.420, 294.086),
                vec4(515.287, -2616.303, -49.421, 310.113)
            },
        },
        GarageInfo = 'Can store 50 vehicles. There are 3 interior styles with 12 lighting options for each floor, 5 floors in total.'
    }
}