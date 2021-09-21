require('util')

local statuses = {
    [defines.entity_status.working] = {sprite = "utility/status_working", caption = {"entity-status.working"}},
    [defines.entity_status.normal] = {sprite = "utility/status_working", caption = {"entity-status.normal"}},
    [defines.entity_status.no_power] = {sprite = "utility/status_not_working", caption = {"entity-status.no-power"}},
    [defines.entity_status.low_power] = {sprite = "utility/status_yellow", caption = {"entity-status.low-power"}},
    [defines.entity_status.marked_for_deconstruction] = {sprite = "utility/status_not_working", caption = {"entity-status.marked-for-deconstruction"}},
}

local function status_info(status)
    local ret = statuses[status]
    if not ret then
        return {sprite = "utility/status_yellow", caption = {"controls.unknown"}}
    end
    return ret
end

local GUI_CONTENT_WIDTH = 550

local ABSENT_SIGNALS = {
    ignore = "ignore",
    treat_as_0 = "treat-as-0",
}

local DEFAULT_STATSD_COMBINATOR_SETTINGS = {
    name = "",
    tags = "",
    absent_signals = ABSENT_SIGNALS.ignore,
}

local function entity_settings(entity)
    local settings = global.entity_settings[entity.unit_number]
    if settings then
        return settings
    end
    return DEFAULT_STATSD_COMBINATOR_SETTINGS
end

local function update_entity_settings(entity, update)
    local prev_settings = entity_settings(entity)
    local new_settings = table.deepcopy(prev_settings)
    update(new_settings)
    global.entity_settings[entity.unit_number] = new_settings
end

local function build_text_option_edit_mode_gui(editor_flow, value)
    editor_flow.clear()

    local textfield = editor_flow.add{
        type = "textfield",
        name = "factorystatsd_text_option_textfield",
        text = value,
    }
    textfield.select_all()
    textfield.focus()

    local button = editor_flow.add{
        type = "sprite-button",
        name="factorystatsd_text_option_save_button",
        sprite="utility/check_mark_white",
    }
    button.style.size = 28
    button.style.padding = 1
end

local function build_text_option_view_mode_gui(editor_flow, value)
    editor_flow.clear()

    editor_flow.add{
        type = "label",
        name = "label",
        caption = value,
        single_line = false,
    }

    local button = editor_flow.add{
        type = "sprite-button",
        name="factorystatsd_text_option_edit_button",
        sprite="utility/rename_icon_small_white",
    }
    button.style.size = 20
    button.style.padding = 1
end

local function build_text_option_gui(content_frame, config)
    local flow = content_frame.add{
        type = "flow",
        direction = "vertical",
        name = config.name,
    }

    local label = flow.add{
        type = "label",
        caption = config.title,
        style = "bold_label",
    }
    label.style.top_margin = 8

    local description_label = flow.add{
        type = "label",
        style = "description_label",
        caption = config.description,
        single_line = false,
    }
    description_label.style.maximal_width = GUI_CONTENT_WIDTH
    description_label.style.bottom_margin = 4
    description_label.style.single_line = false

    local editor_flow = flow.add{
        type = "flow",
        name = "editor_flow",
    }

    build_text_option_view_mode_gui(editor_flow, config.value)
end

local function refresh_statsd_combinator_gui(frame, entity)
    local status = status_info(entity.status)
    frame.content_frame.status_flow.status_image.sprite = status.sprite
    frame.content_frame.status_flow.status_label.caption = status.caption

    local settings = entity_settings(entity)

    local name_gui = frame.content_frame.name_setting.editor_flow
    if name_gui.label then
        name_gui.label.caption = settings.name
    end

    local tags_gui = frame.content_frame.tags_setting.editor_flow
    if tags_gui.label then
        tags_gui.label.caption = settings.tags
    end

    local absent_signals_checkbox = frame.content_frame.absent_signals_setting.absent_signals_checkbox
    absent_signals_checkbox.state = (settings.absent_signals == ABSENT_SIGNALS.treat_as_0)
end

local function build_statsd_combinator_gui(player, entity)
    local frame = player.gui.screen.add({
        type = "frame",
        name = "statsd_combinator",
        direction = "vertical",
    })

    local title_flow = frame.add{type = "flow", name = "title_flow"}
    local title = title_flow.add{type = "label", caption = {"entity-name.statsd-combinator"}, style = "frame_title"}
    title.drag_target = frame

    local pusher = title_flow.add{type = "empty-widget", style = "draggable_space_header"}
    pusher.style.vertically_stretchable = true
    pusher.style.horizontally_stretchable = true
    pusher.drag_target = frame

    title_flow.add{type = "sprite-button", style = "frame_action_button", sprite = "utility/close_white", name = "statsd_combinator_close_button"}

    local content_frame = frame.add{
        type = "frame",
        name = "content_frame",
        direction = "vertical",
        style = "inside_shallow_frame_with_padding",
    }

    local status_flow = content_frame.add{
        type = "flow",
        name = "status_flow",
        style = "status_flow",
    }
    status_flow.style.bottom_margin = 8

    local status = status_info(entity.status)

    local status_image = status_flow.add{
        type = "sprite",
        name = "status_image",
        sprite = status.sprite,
        style = "status_image",
    }
    status_image.style.top_margin = 2
    status_image.style.stretch_image_to_widget_size = true

    status_flow.add{
        type = "label",
        name = "status_label",
        caption = status.caption,
    }

    local preview_frame = content_frame.add{
        type = "frame",
        name = "preview_frame",
        direction = "vertical",
        style = "deep_frame_in_shallow_frame",
    }

    local preview = preview_frame.add{
        type = "entity-preview",
        name = "preview",
    }
    -- for some reason these have to be set after creating the preview
    preview.style.width = GUI_CONTENT_WIDTH
    preview.style.height = 150
    preview.entity = entity

    build_text_option_gui(content_frame, {
        title = {"statsd-combinator-ui.name"},
        description = {"statsd-combinator-ui.name-description"},
        name = "name_setting",
        value = "",
    })

    build_text_option_gui(content_frame, {
        title = {"statsd-combinator-ui.tags"},
        description = {"statsd-combinator-ui.tags-description"},
        name = "tags_setting",
        value = "",
    })

    local absent_signals = content_frame.add{
        type = "label",
        caption = {"statsd-combinator-ui.absent-signals"},
        style = "bold_label",
    }
    absent_signals.style.top_margin = 8

    local absent_signals_description_label = content_frame.add{
        type = "label",
        style = "description_label",
        caption = {"statsd-combinator-ui.absent-signals-description"},
        single_line = false,
    }
    absent_signals_description_label.style.maximal_width = GUI_CONTENT_WIDTH
    absent_signals_description_label.style.bottom_margin = 4
    absent_signals_description_label.style.single_line = false

    local absent_signals_flow = content_frame.add{
        type = "flow",
        name = "absent_signals_setting",
    }

    local absent_signals_checkbox = absent_signals_flow.add{
        type = "checkbox",
        name = "absent_signals_checkbox",
        state = false,
    }
    absent_signals_checkbox.style.top_margin = 3

    absent_signals_flow.add{
        type = "label",
        caption = {"statsd-combinator-ui.treat-absent-signals-as-zero"},
    }

    player.opened = frame

    frame.force_auto_center()
    refresh_statsd_combinator_gui(frame, entity)
end

local function on_gui_opened(event)
	if event.entity and event.entity.name == "statsd-combinator" then
        local player = game.get_player(event.player_index)
        if player.gui.screen.statsd_combinator then
            player.gui.screen.statsd_combinator.destroy()
        end

        build_statsd_combinator_gui(player, event.entity)
	end
end
script.on_event(defines.events.on_gui_opened, on_gui_opened)

local function on_gui_closed(event)
	if event.element then
        local player = game.get_player(event.player_index)
        if event.element == player.gui.screen.statsd_combinator then
            player.gui.screen.statsd_combinator.destroy()
        end
	end
end
script.on_event(defines.events.on_gui_closed, on_gui_closed)

local function on_gui_confirmed(event)
    local editor_flow = event.element.parent
    local player = game.players[event.player_index]
    local sc_frame = player.gui.screen.statsd_combinator;
    if sc_frame then
        local entity = sc_frame.content_frame.preview_frame.preview.entity
        local value = editor_flow.factorystatsd_text_option_textfield.text
        update_entity_settings(entity, function(settings)
            if editor_flow.parent.name == "name_setting" then
                settings.name = value
            else
                settings.tags = value
            end
        end)
        build_text_option_view_mode_gui(editor_flow, value)
    end
end
script.on_event(defines.events.on_gui_confirmed, on_gui_confirmed)

local function on_gui_click(event)
    if event.element.name == "statsd_combinator_close_button" then
        local player = game.get_player(event.player_index)
        player.gui.screen.statsd_combinator.destroy()
    elseif event.element.name == "factorystatsd_text_option_edit_button" then
        local editor_flow = event.element.parent
        build_text_option_edit_mode_gui(editor_flow, editor_flow.label.caption)
    elseif event.element.name == "factorystatsd_text_option_save_button" then
        on_gui_confirmed({
            element = event.element.parent.factorystatsd_text_option_textfield,
            player_index = event.player_index,
        })
    end
end
script.on_event(defines.events.on_gui_click, on_gui_click)

local function write_server_file(path, data)
    if game.is_multiplayer() then
        game.write_file(path, data, false, 0)
    else
        game.write_file(path, data)
    end
end

local function export_game_data()
    local data = {
        virtual_signal_names = {},
        item_names = {},
        fluid_names = {},
    }

    for _, p in pairs(game.virtual_signal_prototypes) do
        table.insert(data.virtual_signal_names, p.name)
    end
    for _, p in pairs(game.fluid_prototypes) do
        table.insert(data.fluid_names, p.name)
    end
    for _, p in pairs(game.item_prototypes) do
        table.insert(data.item_names, p.name)
    end

    write_server_file("factoriostatsd-game-data.json", game.table_to_json(data))
end

local function export_samples()
    local samples = {
        entities = {},
    }
    for _, surface in pairs(game.surfaces) do
        local entities = surface.find_entities_filtered{name = "statsd-combinator"}
        for _, entity in pairs(entities) do
            if entity.status == defines.entity_status.working then
                local settings = entity_settings(entity)
                if settings.name then
                    local entity_data = {
                        settings = settings,
                    }
                    local red = entity.get_circuit_network(defines.wire_type.red, defines.circuit_connector_id.combinator_input)
                    if red then
                        entity_data.red_signals = red.signals
                    end
                    local green = entity.get_circuit_network(defines.wire_type.green, defines.circuit_connector_id.combinator_input)
                    if green then
                        entity_data.green_signals = green.signals
                    end
                    table.insert(samples.entities, entity_data)
                end
            end
        end
    end
    write_server_file("factoriostatsd-samples.json", game.table_to_json(samples))
end

local SAMPLE_TICK_INTERVAL = 60

local should_export_game_data = true

local function on_tick(event)
    for _, player in pairs(game.players) do
        local sc_frame = player.gui.screen.statsd_combinator;
        if sc_frame then
            local entity = sc_frame.content_frame.preview_frame.preview.entity
            refresh_statsd_combinator_gui(sc_frame, entity)
        end
    end

    if should_export_game_data then
        export_game_data()
        should_export_game_data = false
    end

    local tick_interval = math.ceil(SAMPLE_TICK_INTERVAL * game.speed)
    if event.tick % tick_interval == 0 then
        export_samples()
    end
end
script.on_event(defines.events.on_tick, on_tick)

local function on_gui_checked_state_changed(event)
    if event.element.name == "absent_signals_checkbox" then
        local player = game.players[event.player_index]
        local sc_frame = player.gui.screen.statsd_combinator;
        if sc_frame then
            local entity = sc_frame.content_frame.preview_frame.preview.entity
            update_entity_settings(entity, function(settings)
                if event.element.state then
                    settings.absent_signals = ABSENT_SIGNALS.treat_as_0
                else
                    settings.absent_signals = ABSENT_SIGNALS.ignore
                end
            end)
        end
    end
end
script.on_event(defines.events.on_gui_checked_state_changed, on_gui_checked_state_changed)

local function on_entity_cloned(event)
    if event.source.name == "statsd-combinator" and event.destination.name == "statsd-combinator" then
        local source_settings = entity_settings(event.source)
        update_entity_settings(event.destination, function(settings)
            for k, v in pairs(source_settings) do
                settings[k] = v
            end
        end)
    end
end
script.on_event({defines.events.on_entity_cloned, defines.events.on_entity_settings_pasted}, on_entity_cloned)

local function on_entity_destroyed(event)
    table.remove(global.entity_settings, event.unit_number)
end
script.on_event(defines.events.on_entity_destroyed, on_entity_destroyed)

local function on_entity_created(event)
    local entity = event.entity
    if not entity then
        entity = event.created_entity
    end
    if entity.name == "statsd-combinator" and event.tags then
        update_entity_settings(entity, function(settings)
            for k, v in pairs(event.tags) do
                settings[k] = v
            end
        end)
    end
end
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_revive}, on_entity_created)

function on_player_setup_blueprint(event)
    local player_index = event.player_index
    if player_index and game.players[player_index] and game.players[player_index].connected then
        local player = game.players[player_index]
        local blueprint = nil
        if player and player.blueprint_to_setup and player.blueprint_to_setup.valid_for_read then
            blueprint = player.blueprint_to_setup
        elseif player and player.cursor_stack.valid_for_read and player.cursor_stack.is_blueprint then
            blueprint = player.cursor_stack
        end
        if blueprint and blueprint.is_blueprint_setup() then
            local mapping = event.mapping.get()
            local blueprint_entities = blueprint.get_blueprint_entities()
            if blueprint_entities then
                for _, blueprint_entity in pairs(blueprint_entities) do
                    if blueprint_entity.name == "statsd-combinator" then
                        local entity = mapping[blueprint_entity.entity_number]
                        if entity then
                            local settings = entity_settings(entity)
                            blueprint.set_blueprint_entity_tags(blueprint_entity.entity_number, settings)
                        end
                    end
                end
            end
        end
    end
end
script.on_event(defines.events.on_player_setup_blueprint, on_player_setup_blueprint)

script.on_init(function ()
    global.entity_settings = {}
end)
