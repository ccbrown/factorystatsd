local sc = table.deepcopy(data.raw["arithmetic-combinator"]["arithmetic-combinator"])
sc.name = "statsd-combinator"
sc.icon = "__factorystatsd__/graphics/icons/statsd-combinator.png"
sc.icon_mipmaps = 1
sc.icon_size = 64
sc.minable.result = "statsd-combinator"
sc.active_energy_usage = "100KW"
sc.corpse = "statsd-combinator-remnants"
sc.output_connection_bounding_box = {
    {-0.5, -0.5},
    {0.5, -0.5},
}
sc.sprites = {
    east = {
        layers = {
            {
                filename = "__factorystatsd__/graphics/entity/statsd-combinator/statsd-combinator.png",
                frame_count = 1,
                height = 64,
                hr_version = {
                    filename = "__factorystatsd__/graphics/entity/statsd-combinator/hr-statsd-combinator.png",
                    frame_count = 1,
                    height = 124,
                    priority = "high",
                    scale = 0.5,
                    shift = {0.015625, 0.234375},
                    width = 144,
                    x = 144,
                    y = 0
                },
                priority = "high",
                scale = 1,
                shift = {0.03125, 0.25},
                width = 74,
                x = 74,
                y = 0
            },
            {
                draw_as_shadow = true,
                filename = "__factorystatsd__/graphics/entity/statsd-combinator/statsd-combinator-shadow.png",
                frame_count = 1,
                height = 78,
                hr_version = {
                    draw_as_shadow = true,
                    filename = "__factorystatsd__/graphics/entity/statsd-combinator/hr-statsd-combinator-shadow.png",
                    frame_count = 1,
                    height = 156,
                    priority = "high",
                    scale = 0.5,
                    shift = {0.421875, 0.765625},
                    width = 148,
                    x = 148,
                    y = 0
                },
                priority = "high",
                scale = 1,
                shift = {0.4375, 0.75},
                width = 76,
                x = 76,
                y = 0
            }
        }
    },
    north = {
        layers = {
            {
                filename = "__factorystatsd__/graphics/entity/statsd-combinator/statsd-combinator.png",
                frame_count = 1,
                height = 64,
                hr_version = {
                    filename = "__factorystatsd__/graphics/entity/statsd-combinator/hr-statsd-combinator.png",
                    frame_count = 1,
                    height = 124,
                    priority = "high",
                    scale = 0.5,
                    shift = {0.015625, 0.234375},
                    width = 144,
                    x = 0,
                    y = 0
                },
                priority = "high",
                scale = 1,
                shift = {0.03125, 0.25},
                width = 74,
                x = 0,
                y = 0
            },
            {
                draw_as_shadow = true,
                filename = "__factorystatsd__/graphics/entity/statsd-combinator/statsd-combinator-shadow.png",
                frame_count = 1,
                height = 78,
                hr_version = {
                    draw_as_shadow = true,
                    filename = "__factorystatsd__/graphics/entity/statsd-combinator/hr-statsd-combinator-shadow.png",
                    frame_count = 1,
                    height = 156,
                    priority = "high",
                    scale = 0.5,
                    shift = {0.421875, 0.765625},
                    width = 148,
                    x = 0,
                    y = 0
                },
                priority = "high",
                scale = 1,
                shift = {0.4375, 0.75},
                width = 76,
                x = 0,
                y = 0
            }
        }
    },
    south = {
        layers = {
            {
                filename = "__factorystatsd__/graphics/entity/statsd-combinator/statsd-combinator.png",
                frame_count = 1,
                height = 64,
                hr_version = {
                    filename = "__factorystatsd__/graphics/entity/statsd-combinator/hr-statsd-combinator.png",
                    frame_count = 1,
                    height = 124,
                    priority = "high",
                    scale = 0.5,
                    shift = {0.015625, 0.234375},
                    width = 144,
                    x = 288,
                    y = 0
                },
                priority = "high",
                scale = 1,
                shift = {0.03125, 0.25},
                width = 74,
                x = 148,
                y = 0
            },
            {
                draw_as_shadow = true,
                filename = "__factorystatsd__/graphics/entity/statsd-combinator/statsd-combinator-shadow.png",
                frame_count = 1,
                height = 78,
                hr_version = {
                    draw_as_shadow = true,
                    filename = "__factorystatsd__/graphics/entity/statsd-combinator/hr-statsd-combinator-shadow.png",
                    frame_count = 1,
                    height = 156,
                    priority = "high",
                    scale = 0.5,
                    shift = {0.421875, 0.765625},
                    width = 148,
                    x = 296,
                    y = 0
                },
                priority = "high",
                scale = 1,
                shift = {0.4375, 0.75},
                width = 76,
                x = 152,
                y = 0
            }
        }
    },
    west = {
        layers = {
            {
                filename = "__factorystatsd__/graphics/entity/statsd-combinator/statsd-combinator.png",
                frame_count = 1,
                height = 64,
                hr_version = {
                    filename = "__factorystatsd__/graphics/entity/statsd-combinator/hr-statsd-combinator.png",
                    frame_count = 1,
                    height = 124,
                    priority = "high",
                    scale = 0.5,
                    shift = {0.015625, 0.234375},
                    width = 144,
                    x = 432,
                    y = 0
                },
                priority = "high",
                scale = 1,
                shift = {0.03125, 0.25},
                width = 74,
                x = 222,
                y = 0
            },
            {
                draw_as_shadow = true,
                filename = "__factorystatsd__/graphics/entity/statsd-combinator/statsd-combinator-shadow.png",
                frame_count = 1,
                height = 78,
                hr_version = {
                    draw_as_shadow = true,
                    filename = "__factorystatsd__/graphics/entity/statsd-combinator/hr-statsd-combinator-shadow.png",
                    frame_count = 1,
                    height = 156,
                    priority = "high",
                    scale = 0.5,
                    shift = {0.421875, 0.765625},
                    width = 148,
                    x = 444,
                    y = 0
                },
                priority = "high",
                scale = 1,
                shift = {0.4375, 0.75},
                width = 76,
                x = 228,
                y = 0
            }
        }
    }
}
sc.multiply_symbol_sprites = {
    east = {
        draw_as_glow = true,
        filename = "__factorystatsd__/graphics/entity/statsd-combinator/display.png",
        height = 11,
        hr_version = {
            draw_as_glow = true,
            filename = "__factorystatsd__/graphics/entity/statsd-combinator/hr-display.png",
            height = 22,
            scale = 0.5,
            shift = {
                0,
                -0.328125
            },
            width = 30,
        },
        shift = {
            0,
            -0.328125
        },
        width = 15,
    },
    north = {
        draw_as_glow = true,
        filename = "__factorystatsd__/graphics/entity/statsd-combinator/display.png",
        height = 11,
        hr_version = {
            draw_as_glow = true,
            filename = "__factorystatsd__/graphics/entity/statsd-combinator/hr-display.png",
            height = 22,
            scale = 0.5,
            shift = {
                0,
                -0.140625
            },
            width = 30,
        },
        shift = {
            0,
            -0.140625
        },
        width = 15,
    },
    south = {
        draw_as_glow = true,
        filename = "__factorystatsd__/graphics/entity/statsd-combinator/display.png",
        height = 11,
        hr_version = {
            draw_as_glow = true,
            filename = "__factorystatsd__/graphics/entity/statsd-combinator/hr-display.png",
            height = 22,
            scale = 0.5,
            shift = {
                0,
                -0.140625
            },
            width = 30,
        },
        shift = {
            0,
            -0.140625
        },
        width = 15,
    },
    west = {
        draw_as_glow = true,
        filename = "__factorystatsd__/graphics/entity/statsd-combinator/display.png",
        height = 11,
        hr_version = {
            draw_as_glow = true,
            filename = "__factorystatsd__/graphics/entity/statsd-combinator/hr-display.png",
            height = 22,
            scale = 0.5,
            shift = {
                0,
                -0.328125
            },
            width = 30,
        },
        shift = {
            0,
            -0.328125
        },
        width = 15,
    }
}
sc.and_symbol_sprites = sc.multiply_symbol_sprites
sc.divide_symbol_sprites = sc.multiply_symbol_sprites
sc.left_shift_symbol_sprites = sc.multiply_symbol_sprites
sc.minus_symbol_sprites = sc.multiply_symbol_sprites
sc.modulo_symbol_sprites = sc.multiply_symbol_sprites
sc.or_symbol_sprites = sc.multiply_symbol_sprites
sc.plus_symbol_sprites = sc.multiply_symbol_sprites
sc.power_symbol_sprites = sc.multiply_symbol_sprites
sc.right_shift_symbol_sprites = sc.multiply_symbol_sprites
sc.xor_symbol_sprites = sc.multiply_symbol_sprites

local corpse = table.deepcopy(data.raw["corpse"]["arithmetic-combinator-remnants"])
corpse.name = "statsd-combinator-remnants"
corpse.icon = "__factorystatsd__/graphics/icons/statsd-combinator.png"
corpse.icon_mipmaps = 1
corpse.icon_size = 64
corpse.animation = {
    axially_symmetrical = false,
    direction_count = 4,
    filename = "__factorystatsd__/graphics/entity/statsd-combinator/statsd-combinator-remnants.png",
    frame_count = 1,
    height = 78,
    hr_version = {
        axially_symmetrical = false,
        direction_count = 4,
        filename = "__factorystatsd__/graphics/entity/statsd-combinator/hr-statsd-combinator-remnants.png",
        frame_count = 1,
        height = 156,
        line_length = 1,
        scale = 0.5,
        variation_count = 1,
        width = 156
    },
    line_length = 1,
    variation_count = 1,
    width = 78
}
corpse.localised_name = {
    "remnant-name",
    {
        "entity-name.statsd-combinator"
    }
}

data:extend({sc, corpse})
