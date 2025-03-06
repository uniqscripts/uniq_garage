local Garages = {
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

    ['Arcadius Business Centre Garage'] = {
        interiorId = 253441,
        ipl = 'imp_dt1_02_cargarage_a',
        enter = vec3(-110.985, -605.060, 36.281),
        parkVehicle = vec3(-107.005, -610.433, 36.056),
        insideSpawn = vec4(-197.995, -580.594, 136.001, 295.310),
        vehicleSpawnPoint = vec4(-109.346, -618.759, 36.061, 161.236),
        customizationMenu = vec3(-197.334, -577.085, 136.000),
        price = 2745000,
        blip = { id = 357, colour = 3, scale = 0.9 },
        blackListClass = { 14, 15, 16, 19, 21 },
        hasMultipleFloors = false,
        Customization = {
            Purchasable = {
                ['Interior'] = {
                    { label = 'Interior 1', style = 'garage_decor_01', price = 150000, type = 'interior' },
                    { label = 'Interior 2', style = 'garage_decor_02', price = 285000, type = 'interior' },
                    { label = 'Interior 3', style = 'garage_decor_03', price = 415000, type = 'interior' },
                    { label = 'Interior 4', style = 'garage_decor_04', price = 500000, type = 'interior' },
                },
                ['Lighting'] = {
                    { label = 'Lighting 1', style = 'lighting_option01', price = 75000, type = 'light' },
                    { label = 'Lighting 2', style = 'lighting_option02', price = 81500, type = 'light' },
                    { label = 'Lighting 3', style = 'lighting_option03', price = 85000, type = 'light' },
                    { label = 'Lighting 4', style = 'lighting_option04', price = 87500, type = 'light' },
                    { label = 'Lighting 5', style = 'lighting_option05', price = 92500, type = 'light' },
                    { label = 'Lighting 6', style = 'lighting_option06', price = 99500, type = 'light' },
                    { label = 'Lighting 7', style = 'lighting_option07', price = 105000, type = 'light' },
                    { label = 'Lighting 8', style = 'lighting_option08', price = 127500, type = 'light' },
                    { label = 'Lighting 9', style = 'lighting_option09', price = 150000, type = 'light' },
                },
                ['Signage'] = {
                    { label = 'Lighting 1', style = 'numbering_style01_n1', price = 50000, type = 'signage' },
                    { label = 'Lighting 2', style = 'numbering_style02_n1', price = 62000, type = 'signage' },
                    { label = 'Lighting 3', style = 'numbering_style03_n1', price = 75000, type = 'signage' },
                    { label = 'Lighting 4', style = 'numbering_style04_n1', price = 87500, type = 'signage' },
                    { label = 'Lighting 5', style = 'numbering_style05_n1', price = 100000, type = 'signage' },
                    { label = 'Lighting 6', style = 'numbering_style06_n1', price = 132000, type = 'signage' },
                    { label = 'Lighting 7', style = 'numbering_style07_n1', price = 165000, type = 'signage' },
                    { label = 'Lighting 8', style = 'numbering_style08_n1', price = 197000, type = 'signage' },
                    { label = 'Lighting 9', style = 'numbering_style09_n1', price = 250000, type = 'signage' },
                }
            },

            Default = {
                [1] = { interior = 'garage_decor_01', light = 'lighting_option01', signage = 'numbering_style01_n1' }
            },

            DeactivateInterior = function()
                local interiorId = 253441
                local list = {
                    'garage_decor_01',
                    'garage_decor_02',
                    'garage_decor_03',
                    'garage_decor_04',
                    'lighting_option01',
                    'lighting_option02',
                    'lighting_option03',
                    'lighting_option04',
                    'lighting_option05',
                    'lighting_option06',
                    'lighting_option07',
                    'lighting_option08',
                    'lighting_option09',
                    'numbering_style01_n1',
                    'numbering_style02_n1',
                    'numbering_style03_n1',
                    'numbering_style04_n1',
                    'numbering_style05_n1',
                    'numbering_style06_n1',
                    'numbering_style07_n1',
                    'numbering_style08_n1',
                    'numbering_style09_n1',
                }

                for i = 1, #list do
                    if IsInteriorEntitySetActive(interiorId, list[i]) then
                        DeactivateInteriorEntitySet(interiorId, list[i])
                    end
                end

                RefreshInterior(interiorId)
            end,

            LoadDefault = function() -- loading this when in preview
                local interiorId = 253441
                local list = {
                    'garage_decor_01',
                    'lighting_option01',
                    'numbering_style01_n1'
                }

                for i = 1, #list do
                    if not IsInteriorEntitySetActive(interiorId, list[i]) then
                        ActivateInteriorEntitySet(interiorId, list[i])
                    end
                end

                RefreshInterior(interiorId)
            end
        },
        Vehicles = {
            [1] = {
                vec4(-173.663, -586.285, 135.591, 55.232),
                vec4(-171.772, -581.433, 135.589, 96.429),
                vec4(-174.008, -575.509, 135.591, 133.238),
                vec4(-177.363, -572.505, 135.590, 153.034),
                vec4(-182.227, -571.430, 135.590, 187.091),
                vec4(-187.448, -573.177, 135.590, 219.976),
                vec4(-190.896, -576.068, 135.590, 241.051),
                vec4(-192.936, -580.709, 135.590, 263.572),

                vec4(-173.663, -586.285, 140.934, 55.232),
                vec4(-171.772, -581.433, 140.934, 96.429),
                vec4(-173.565, -575.966, 140.934, 122.879),
                vec4(-177.441, -572.685, 140.934, 150.869),
                vec4(-182.154, -571.731, 140.934, 184.236),
                vec4(-186.981, -573.337, 140.934, 218.274),
                vec4(-190.346, -576.434, 140.934, 241.441),
                vec4(-192.474, -580.448, 140.933, 269.140),

                vec4(-173.663, -586.285, 146.280, 55.232),
                vec4(-171.772, -581.433, 146.283, 96.429),
                vec4(-172.923, -577.460, 146.280, 119.011),
                vec4(-175.864, -573.947, 146.280, 141.728),
                vec4(-180.677, -572.477, 146.279, 176.112),
                vec4(-186.206, -572.990, 146.279, 199.255),
                vec4(-190.747, -575.410, 146.280, 236.287),
                vec4(-192.806, -579.732, 146.279, 260.655)

            }
        },
        GarageInfo = 'Can store 24 vehicles.'

    },

    ['Eclipse Boulevard Garage' --[[ 50 car garage ]]] = {
        interiorId = 290561,
        ipl = 'xm3_garage_fix',
        enter = vec3(-286.271, 280.641, 89.888),
        parkVehicle = vec3(-269.203, 279.701, 90.306),
        insideSpawn = vec4(528.401, -2638.002, -49.000, 97.635), -- also exit
        vehicleSpawnPoint = vec4(-272.861, 277.642, 89.620, 175.041),
        customizationMenu = vec3(524.677, -2638.506, -49.000),
        price = 2740000,
        blip = { id = 357, colour = 3, scale = 0.9 },
        blackListClass = { 14, 15, 16, 19, 21 }, -- https://docs.fivem.net/natives/?_0x29439776AAA00A62
        Customization = {
            Purchasable = {
                ['Tint'] = {
                    { label = 'White', price = 75000, style = 'entity_set_tint_01', color = true, },
                    { label = 'Gray', price = 75000, style = 'entity_set_tint_01', color = true },
                    { label = 'Black', price = 75000, style = 'entity_set_tint_01', color = true },
                    { label = 'Purple', price = 75000, style = 'entity_set_tint_01', color = true },
                    { label = 'Orange', price = 75000, style = 'entity_set_tint_01', color = true },
                    { label = 'Yellow', price = 75000, style = 'entity_set_tint_01', color = true },
                    { label = 'Blue', price = 75000, style = 'entity_set_tint_01', color = true },
                    { label = 'Red', price = 75000, style = 'entity_set_tint_01', color = true },
                    { label = 'Green', price = 75000, style = 'entity_set_tint_01', color = true},
                    { label = 'Vintage Blue', price = 75000, style = 'entity_set_tint_01', color = true },
                    { label = 'Vintage Red', price = 75000, style = 'entity_set_tint_01', color = true },
                    { label = 'Vintage Green', price = 75000, style = 'entity_set_tint_01', color = true },
                },
                ['Interior'] = {
                    { label = 'Immaculate', style = 'entity_set_shell_01', price = 137000, type = 'interior' },
                    { label = 'Industrial', style = 'entity_set_shell_02', price = 180000, type = 'interior' },
                    { label = 'Indulgent', style = 'entity_set_shell_03', price = 265000, type = 'interior' },
                }
            },
            Default = { -- This will be set when in preview or purchasing
                -- [[ [floor] = { style } ]]
                [1] = { interior = 'entity_set_shell_01', number = 'entity_set_numbers_01', color = { entity = 'entity_set_tint_01', color = 1 } },
                [2] = { interior = 'entity_set_shell_01', number = 'entity_set_numbers_02', color = { entity = 'entity_set_tint_01', color = 1 } },
                [3] = { interior = 'entity_set_shell_01', number = 'entity_set_numbers_03', color = { entity = 'entity_set_tint_01', color = 1 } },
                [4] = { interior = 'entity_set_shell_01', number = 'entity_set_numbers_04', color = { entity = 'entity_set_tint_01', color = 1 } },
                [5] = { interior = 'entity_set_shell_01', number = 'entity_set_numbers_05', color = { entity = 'entity_set_tint_01', color = 1 } },
            },

            DeactivateInterior = function()
                local interiorId = 290561
                local list = {
                    'entity_set_shell_01',
                    'entity_set_shell_02',
                    'entity_set_shell_03',
                    'entity_set_numbers_01',
                    'entity_set_numbers_02',
                    'entity_set_numbers_03',
                    'entity_set_numbers_04',
                    'entity_set_numbers_05',
                    'entity_set_tint_01'
                }

                for i = 1, #list do
                    if IsInteriorEntitySetActive(interiorId, list[i]) then
                        DeactivateInteriorEntitySet(interiorId, list[i])
                    end
                end

                RefreshInterior(interiorId)
            end,

            LoadDefault = function() -- loading this when in preview
                local interiorId = 290561
                local list = {
                    'entity_set_shell_01',
                    'entity_set_numbers_01'
                }

                for i = 1, #list do
                    if not IsInteriorEntitySetActive(interiorId, list[i]) then
                        ActivateInteriorEntitySet(interiorId, list[i])
                    end
                end

                if not IsInteriorEntitySetActive(interiorId, 'entity_set_tint_01') then
                    ActivateInteriorEntitySet(interiorId, 'entity_set_tint_01')
                end

                SetInteriorEntitySetColor(interiorId, 'entity_set_tint_01', 1)
                RefreshInterior(interiorId)
            end
        },
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


return Garages