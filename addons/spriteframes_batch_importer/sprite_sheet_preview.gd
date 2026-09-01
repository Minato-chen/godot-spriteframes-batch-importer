@tool
extends Control

var sheet_texture: Texture2D
var frame_size := Vector2i(16, 16)
var sheet_margin := Vector2i.ZERO
var sheet_spacing := Vector2i.ZERO
var state_definitions: Array[Dictionary] = []
var direction_definitions: Array[Dictionary] = []
var zoom := 2.0
var empty_message := "No sprite sheet selected"

const STATE_COLORS := [
	Color(0.22, 0.65, 1.0, 0.34),
	Color(0.35, 0.9, 0.45, 0.34),
	Color(1.0, 0.65, 0.2, 0.34),
	Color(1.0, 0.86, 0.12, 0.38),
	Color(0.85, 0.18, 1.0, 0.38),
	Color(0.25, 0.9, 0.85, 0.34),
]


func configure(texture: Texture2D, new_frame_size: Vector2i, new_margin: Vector2i, new_spacing: Vector2i, new_states: Array[Dictionary], new_directions: Array[Dictionary]) -> void:
	sheet_texture = texture
	frame_size = new_frame_size
	sheet_margin = new_margin
	sheet_spacing = new_spacing
	state_definitions = new_states
	direction_definitions = new_directions
	_update_minimum_size()
	queue_redraw()


func set_zoom(new_zoom: float) -> void:
	zoom = clampf(new_zoom, 0.25, 16.0)
	_update_minimum_size()
	queue_redraw()


func set_empty_message(message: String) -> void:
	empty_message = message
	queue_redraw()


func _update_minimum_size() -> void:
	if sheet_texture == null:
		custom_minimum_size = Vector2(640, 480)
	else:
		custom_minimum_size = Vector2(sheet_texture.get_size()) * zoom


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.07, 0.08, 0.1, 1.0), true)
	if sheet_texture == null:
		_draw_centered_text(empty_message)
		return
	var texture_size := Vector2(sheet_texture.get_size())
	if texture_size.x <= 0.0 or texture_size.y <= 0.0:
		return
	var scale_factor := zoom
	var display_size: Vector2 = texture_size * scale_factor
	var origin := Vector2.ZERO
	draw_texture_rect(sheet_texture, Rect2(origin, display_size), false)
	var selection_counts: Dictionary = {}
	var selected_regions: Dictionary = {}
	for state_index in state_definitions.size():
		var state := state_definitions[state_index]
		var state_color := _state_color(state, state_index)
		for direction in direction_definitions:
			var color := state_color
			for frame_index in int(state.frame_count):
				var column := int(state.start_column) + frame_index
				var row := int(direction.row)
				var source_region := _source_cell(column, row)
				var screen_region := Rect2(origin + source_region.position * scale_factor, source_region.size * scale_factor)
				draw_rect(screen_region, color, true)
				draw_rect(screen_region, Color(color.r, color.g, color.b, 0.95), false, max(1.0, scale_factor))
				_draw_direction_index(screen_region, row)
				var cell := Vector2i(column, row)
				selection_counts[cell] = int(selection_counts.get(cell, 0)) + 1
				selected_regions[cell] = screen_region
	for cell in selection_counts:
		if int(selection_counts[cell]) > 1:
			_draw_overlap_marker(selected_regions[cell])


func _state_color(state: Dictionary, state_index: int) -> Color:
	var state_name := String(state.get("name", "")).to_lower()
	if state_name == "hit" or state_name.contains("hurt"):
		return Color(1.0, 0.86, 0.12, 0.38)
	if state_name == "death" or state_name.contains("dead") or state_name.contains("die"):
		return Color(0.85, 0.18, 1.0, 0.38)
	return STATE_COLORS[state_index % STATE_COLORS.size()]


func _draw_direction_index(region: Rect2, direction_number: int) -> void:
	var cell_size := minf(region.size.x, region.size.y)
	if cell_size < 12.0:
		return
	var font := get_theme_default_font()
	var font_size := clampi(int(round(cell_size * 0.38)), 8, 16)
	var label := str(direction_number)
	var text_size := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var padding := maxf(1.0, cell_size * 0.06)
	var badge_size := text_size + Vector2(padding * 2.0, padding)
	draw_rect(Rect2(region.position, badge_size), Color(0.02, 0.03, 0.05, 0.82), true)
	var text_position := region.position + Vector2(padding, font.get_ascent(font_size))
	draw_string(
		font,
		text_position,
		label,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1.0,
		font_size,
		Color.WHITE
	)


func _draw_overlap_marker(region: Rect2) -> void:
	var line_width := max(1.5, zoom)
	var marker_color := Color(1.0, 1.0, 1.0, 0.95)
	draw_rect(region.grow(-line_width * 0.5), marker_color, false, line_width)
	draw_line(region.position, region.end, marker_color, line_width, true)
	draw_line(Vector2(region.end.x, region.position.y), Vector2(region.position.x, region.end.y), marker_color, line_width, true)


func _source_cell(column: int, row: int) -> Rect2:
	return Rect2(sheet_margin.x + column * (frame_size.x + sheet_spacing.x), sheet_margin.y + row * (frame_size.y + sheet_spacing.y), frame_size.x, frame_size.y)


func _draw_centered_text(message: String) -> void:
	var font := get_theme_default_font()
	var font_size := get_theme_default_font_size()
	var text_size := font.get_string_size(message, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var position := Vector2((size.x - text_size.x) * 0.5, (size.y + text_size.y) * 0.5)
	draw_string(font, position, message, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color(0.7, 0.72, 0.76))
