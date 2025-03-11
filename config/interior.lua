return {
    ['hangar'] = {
        interiorId = 260353,
        ipl = 'sm_smugdlc_interior_placement_interior_0_smugdlc_int_01_milo_',
        insideSpawn = vec4(-1267.276, -2964.538, -48.490, 180.641),
        Vehicles = {
            [1] = {
                vec4(-1278.662, -3009.974, -47.952, 227.240),
                vec4(-1279.104, -3036.854, -47.953, 227.774),
                vec4(-1278.629, -2979.949, -47.950, 208.765),
                vec4(-1257.139, -2979.658, -47.954, 140.987),
                vec4(-1278.459, -2998.660, -47.951, 218.122),
                vec4(-1254.537, -2996.039, -47.953, 153.004),
                vec4(-1253.602, -3024.242, -47.951, 148.359),
                vec4(-1254.647, -3010.269, -47.946, 147.497),
                vec4(-1267.867, -3023.165, -47.951, 358.918),
                vec4(-1266.686, -2971.295, -47.950, 181.774),
                vec4(-1279.570, -3024.264, -47.952, 224.579),
                vec4(-1266.770, -3005.505, -47.951, 358.676),
                vec4(-1267.028, -2991.258, -47.951, 179.072),
                vec4(-1264.715, -3039.752, -47.951, 2.101),
                vec4(-1252.209, -3036.531, -47.951, 131.371),
            }
        },
        Customization = {
            DeactivateInterior = function()
                local interiorId = 260353
                local list = {
                    'set_floor_decal_1',
                    'set_floor_decal_2',
                    'set_floor_decal_3',
                    'set_floor_decal_4',
                    'set_floor_decal_5',
                    'set_floor_decal_6',
                    'set_floor_decal_7',
                    'set_floor_decal_8',
                    'set_floor_decal_9',
                    'set_floor_1',
                    'set_floor_2',
                    'set_tint_shell',
                    'set_office_modern',
                    'set_bedroom_modern',
                    'set_modarea',
                    'set_office_basic',
                    'set_office_traditional',
                    'set_bedroom_traditional',
                    'set_bedroom_blinds_closed',
                    'set_bedroom_blinds_open',
                    'set_bedroom_tint',
                    'set_crane_tint',
                    'set_lighting_wall_tint02',
                    'set_lighting_wall_tint01',
                    'set_lighting_hangar_c',
                    'set_lighting_hangar_b',
                    'set_lighting_hangar_a',
                    'set_lighting_wall_tint03',
                    'set_lighting_wall_tint04',
                    'set_lighting_wall_tint05',
                    'set_lighting_wall_tint06',
                    'set_lighting_wall_tint07',
                    'set_lighting_wall_tint08',
                    'set_lighting_wall_tint09',
                    'set_lighting_wall_neutral',
                    'set_lighting_tint_props',
                    'set_bedroom_clutter'
                }

                for i = 1, #list do
                    if IsInteriorEntitySetActive(interiorId, list[i]) then
                        DeactivateInteriorEntitySet(interiorId, list[i])
                    end
                end

                RefreshInterior(interiorId)
            end,

            Default = {
                [1] = {
                    tint = { 'set_tint_shell', 1 },
                    crane = { 'set_crane_tint', 1 },
                    floor = 'set_floor_2',
                    floor_decal = { 'set_floor_decal_1', 1 },
                    lighting_hangar = 'set_lighting_hangar_a',
                    set_lighting_wall_neutral = 'set_lighting_wall_neutral',
                    light_tint = { 'set_lighting_tint_props', 1 },
                    modarea = { 'set_modarea', 1 },
                    office = 'set_office_basic',
                    bedroom = 'set_bedroom_modern',
                    bedroom_tint = { 'set_bedroom_tint', 1 },
                    blinds = 'set_bedroom_blinds_open'
                }
            },
            

            LoadDefault = function()
                -- https://github.com/Bob74/bob74_ipl/blob/master/dlc_smuggler/hangar.lua
                local interiorId = 260353
                local list = {
                    { a = 'set_tint_shell', b = 1 },
                    { a = 'set_crane_tint', b = 1 },
                    { a = 'set_floor_2' },
                    { a = 'set_floor_decal_1', b = 1 },
                    { a = 'set_lighting_hangar_a' },
                    { a = 'set_lighting_wall_neutral' },
                    { a = 'set_lighting_tint_props', b = 1 },
                    { a = 'set_modarea', b = 1 },
                    { a = 'set_office_basic' },
                    { a = 'set_bedroom_modern' },
                    { a = 'set_bedroom_tint', b = 1 },
                    { a = 'set_bedroom_blinds_open' },
                }

                for i = 1, #list do
                    if not IsInteriorEntitySetActive(interiorId, list[i].a) then
                        ActivateInteriorEntitySet(interiorId, list[i].a)
                    end

                    if list[i].b then
                        SetInteriorEntitySetColor(interiorId, list[i].a, list[i].b)
                    end
                end

                RefreshInterior(interiorId)
            end
        }
    },

    ['low_end'] = {
        interiorId = 149249,
        insideSpawn = vec4(178.716, -1005.483, -99.000, 92.588),
        Vehicles = {
            [1] = {
                vec4(175.005, -1003.545, -99.412, 180.654),
                vec4(171.057, -1003.645, -99.410, 180.652),
            }
        },
    },

    ['medium'] = {
        interiorId = 148737,
        insideSpawn = vec4(207.188, -999.216, -99.000, 89.841),
        Vehicles = {
            [1] = {
                vec4(194.272, -998.072, -99.412, 180.659),
                vec4(198.538, -998.066, -99.410, 179.261),
                vec4(202.644, -998.127, -99.410, 179.356),
                vec4(194.435, -1003.745, -99.410, 179.297),
                vec4(198.443, -1003.765, -99.410, 179.412),
                vec4(202.531, -1003.639, -99.410, 178.618)
            }
        },
    },

    ['ceo'] = {
        interiorId = 253441,
        ipl = 'imp_dt1_02_cargarage_a',
        insideSpawn = vec4(-197.995, -580.594, 136.001, 295.310),
        customizationMenu = vec3(-197.334, -577.085, 136.000),
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
    },

    ['drugwar'] = {
        interiorId = 290561,
        ipl = 'xm3_garage_fix',
        insideSpawn = vec4(528.401, -2638.002, -49.000, 97.635),
        customizationMenu = vec3(526.233, -2609.031, -49.000),
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
    }
}