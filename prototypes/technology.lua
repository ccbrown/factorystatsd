data:extend({
    {
        type = "technology",
        name = "monitoring",
        icon = "__factorystatsd__/graphics/technology/monitoring.png",
        icon_size = 256,
        effects = {
            {
                type = "unlock-recipe",
                recipe = "statsd-combinator",
            },
        },
        prerequisites = {
            "advanced-electronics",
            "circuit-network",
        },
        unit = {
            count = 300,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1}
            },
            time = 15,
        },
        order = "a-d-d-a",
    }
})
