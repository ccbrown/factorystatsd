local sc = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])

sc.name = "statsd-combinator"
sc.icon = "__factorystatsd__/graphics/icons/statsd-combinator.png"
sc.icon_size = 64
sc.minable.result = "statsd-combinator"
sc.sprites = {
    east = {
        layers = {
            {
                filename = "__factorystatsd__/graphics/entity/statsd-combinator.png",
                frame_count = 1,
                height = 64,
                hr_version = {
                    filename = "__factorystatsd__/graphics/entity/hr-statsd-combinator.png",
                    frame_count = 1,
                    height = 124,
                    priority = "high",
                    scale = 0.5,
                    shift = {
                        0.015625,
                        0.234375
                    },
                    width = 144,
                    x = 144,
                    y = 0
                },
                priority = "high",
                scale = 1,
                shift = {
                    0.03125,
                    0.25
                },
                width = 74,
                x = 74,
                y = 0
            },
            {
                draw_as_shadow = true,
                filename = "__base__/graphics/entity/combinator/arithmetic-combinator-shadow.png",
                frame_count = 1,
                height = 78,
                hr_version = {
                    draw_as_shadow = true,
                    filename = "__base__/graphics/entity/combinator/hr-arithmetic-combinator-shadow.png",
                    frame_count = 1,
                    height = 156,
                    priority = "high",
                    scale = 0.5,
                    shift = {
                        0.421875,
                        0.765625
                    },
                    width = 148,
                    x = 148,
                    y = 0
                },
                priority = "high",
                scale = 1,
                shift = {
                    0.4375,
                    0.75
                },
                width = 76,
                x = 76,
                y = 0
            }
        }
    },
    north = {
        layers = {
            {
                filename = "__factorystatsd__/graphics/entity/statsd-combinator.png",
                frame_count = 1,
                height = 64,
                hr_version = {
                    filename = "__factorystatsd__/graphics/entity/hr-statsd-combinator.png",
                    frame_count = 1,
                    height = 124,
                    priority = "high",
                    scale = 0.5,
                    width = 144,
                    x = 0,
                    y = 0
                },
                priority = "high",
                scale = 1,
                width = 74,
                x = 0,
                y = 0
            },
            {
                draw_as_shadow = true,
                filename = "__base__/graphics/entity/combinator/arithmetic-combinator-shadow.png",
                frame_count = 1,
                height = 78,
                hr_version = {
                    draw_as_shadow = true,
                    filename = "__base__/graphics/entity/combinator/hr-arithmetic-combinator-shadow.png",
                    frame_count = 1,
                    height = 156,
                    priority = "high",
                    scale = 0.5,
                    width = 148,
                    x = 0,
                    y = 0
                },
                priority = "high",
                scale = 1,
                width = 76,
                x = 0,
                y = 0
            }
        }
    },
    south = {
        layers = {
            {
                filename = "__factorystatsd__/graphics/entity/statsd-combinator.png",
                frame_count = 1,
                height = 64,
                hr_version = {
                    filename = "__factorystatsd__/graphics/entity/hr-statsd-combinator.png",
                    frame_count = 1,
                    height = 124,
                    priority = "high",
                    scale = 0.5,
                    width = 144,
                    x = 288,
                    y = 0
                },
                priority = "high",
                scale = 1,
                width = 74,
                x = 148,
                y = 0
            },
            {
                draw_as_shadow = true,
                filename = "__base__/graphics/entity/combinator/arithmetic-combinator-shadow.png",
                frame_count = 1,
                height = 78,
                hr_version = {
                    draw_as_shadow = true,
                    filename = "__base__/graphics/entity/combinator/hr-arithmetic-combinator-shadow.png",
                    frame_count = 1,
                    height = 156,
                    priority = "high",
                    scale = 0.5,
                    width = 148,
                    x = 296,
                    y = 0
                },
                priority = "high",
                scale = 1,
                width = 76,
                x = 152,
                y = 0
            }
        }
    },
    west = {
        layers = {
            {
                filename = "__factorystatsd__/graphics/entity/statsd-combinator.png",
                frame_count = 1,
                height = 64,
                hr_version = {
                    filename = "__factorystatsd__/graphics/entity/hr-statsd-combinator.png",
                    frame_count = 1,
                    height = 124,
                    priority = "high",
                    scale = 0.5,
                    width = 144,
                    x = 432,
                    y = 0
                },
                priority = "high",
                scale = 1,
                width = 74,
                x = 222,
                y = 0
            },
            {
                draw_as_shadow = true,
                filename = "__base__/graphics/entity/combinator/arithmetic-combinator-shadow.png",
                frame_count = 1,
                height = 78,
                hr_version = {
                    draw_as_shadow = true,
                    filename = "__base__/graphics/entity/combinator/hr-arithmetic-combinator-shadow.png",
                    frame_count = 1,
                    height = 156,
                    priority = "high",
                    scale = 0.5,
                    width = 148,
                    x = 444,
                    y = 0
                },
                priority = "high",
                scale = 1,
                width = 76,
                x = 228,
                y = 0
            }
        }
    }
}

data:extend({sc})
