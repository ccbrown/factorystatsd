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

local function on_gui_opened(event)
	if event.entity and event.entity.name == "statsd-combinator" then
        local player = game.get_player(event.player_index)
        if player.gui.screen.statsd_combinator then
            player.gui.screen.statsd_combinator.destroy()
        end

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

        local status = status_info(event.entity.status)

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
        preview.style.width = 375
        preview.style.height = 150
        preview.entity = event.entity

		player.opened = frame

        frame.force_auto_center()
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

local function on_gui_click(event)
    if event.element.name == "statsd_combinator_close_button" then
        local player = game.get_player(event.player_index)
        player.gui.screen.statsd_combinator.destroy()
    end
end
script.on_event(defines.events.on_gui_click, on_gui_click)

local function on_tick(event)
    for _, player in pairs(game.players) do
        local sc_frame = player.gui.screen.statsd_combinator;
        if sc_frame then
            local entity = sc_frame.content_frame.preview_frame.preview.entity
            local status = status_info(entity.status)
            sc_frame.content_frame.status_flow.status_image.sprite = status.sprite
            sc_frame.content_frame.status_flow.status_label.caption = status.caption
        end
    end
end
script.on_event(defines.events.on_tick, on_tick)
