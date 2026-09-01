@tool
extends RefCounted


func build(
		source_texture: Texture2D,
		frame_size: Vector2i,
		sheet_margin: Vector2i,
		sheet_spacing: Vector2i,
		states: Array[Dictionary],
		directions: Array[Dictionary]
) -> SpriteFrames:
	var frames := SpriteFrames.new()
	clear_animations(frames)
	for state in states:
		for direction in directions:
			var animation_name := StringName("%s_%s" % [state.name, direction.name])
			frames.add_animation(animation_name)
			frames.set_animation_speed(animation_name, float(state.fps))
			frames.set_animation_loop_mode(
				animation_name,
				SpriteFrames.LOOP_LINEAR if state.loop else SpriteFrames.LOOP_NONE
			)
			for frame_index in int(state.frame_count):
				var region := _cell_region(
					int(state.start_column) + frame_index,
					int(direction.row),
					frame_size,
					sheet_margin,
					sheet_spacing
				)
				var atlas_frame := AtlasTexture.new()
				atlas_frame.atlas = source_texture
				atlas_frame.region = region
				frames.add_frame(animation_name, atlas_frame)
	return frames


func copy_animations(source: SpriteFrames, target: SpriteFrames) -> void:
	clear_animations(target)
	for animation_name in source.get_animation_names():
		target.add_animation(animation_name)
		target.set_animation_speed(animation_name, source.get_animation_speed(animation_name))
		target.set_animation_loop_mode(animation_name, source.get_animation_loop_mode(animation_name))
		for frame_index in source.get_frame_count(animation_name):
			target.add_frame(
				animation_name,
				source.get_frame_texture(animation_name, frame_index),
				source.get_frame_duration(animation_name, frame_index)
			)


func clear_animations(frames: SpriteFrames) -> void:
	for animation_name in frames.get_animation_names():
		frames.remove_animation(animation_name)


func frame_total(states: Array[Dictionary], directions: Array[Dictionary]) -> int:
	var frames_per_direction := 0
	for state in states:
		frames_per_direction += int(state.frame_count)
	return frames_per_direction * directions.size()


func _cell_region(
		column: int,
		row: int,
		frame_size: Vector2i,
		sheet_margin: Vector2i,
		sheet_spacing: Vector2i
) -> Rect2:
	return Rect2(
		sheet_margin.x + column * (frame_size.x + sheet_spacing.x),
		sheet_margin.y + row * (frame_size.y + sheet_spacing.y),
		frame_size.x,
		frame_size.y
	)
