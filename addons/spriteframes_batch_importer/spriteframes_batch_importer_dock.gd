@tool
extends VBoxContainer

const PreviewControl = preload("res://addons/spriteframes_batch_importer/sprite_sheet_preview.gd")

var source_path := ""
var source_texture: Texture2D
var source_value: Label
var output_path: LineEdit
var frame_width: SpinBox
var frame_height: SpinBox
var margin_x: SpinBox
var margin_y: SpinBox
var spacing_x: SpinBox
var spacing_y: SpinBox
var base_column: SpinBox
var fps: SpinBox
var preview_summary: Label
var preview_window: PanelContainer
var preview: Control
var zoom_label: Label
var preview_scroll: ScrollContainer
var state_list: VBoxContainer
var direction_list: VBoxContainer
var state_entries: Array[Dictionary] = []
var direction_entries: Array[Dictionary] = []
var status: Label
var editor_interface: EditorInterface


func _ready() -> void:
	custom_minimum_size = Vector2(300, 0)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_build_ui()
	_add_defaults()
	_refresh_preview()


func _build_ui() -> void:
	var title := Label.new()
	title.text = "SpriteFrames 批量导入"
	title.add_theme_font_size_override("font_size", 18)
	add_child(title)

	var choose := Button.new()
	choose.text = "使用文件系统中选中的 Sprite Sheet"
	choose.pressed.connect(_choose_source)
	add_child(choose)
	source_value = Label.new()
	source_value.text = "尚未选择纹理"
	source_value.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(source_value)

	_add_section("实时预览")
	var open_preview := Button.new()
	open_preview.text = "展开可缩放预览"
	open_preview.pressed.connect(_show_preview)
	add_child(open_preview)
	preview_summary = Label.new()
	preview_summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(preview_summary)

	_add_section("切片设置")
	frame_width = _add_spin("帧宽", 1, 4096, 16)
	frame_height = _add_spin("帧高", 1, 4096, 16)
	margin_x = _add_spin("左边距", 0, 4096, 0)
	margin_y = _add_spin("上边距", 0, 4096, 0)
	spacing_x = _add_spin("横向间隔", 0, 4096, 0)
	spacing_y = _add_spin("纵向间隔", 0, 4096, 0)
	base_column = _add_spin("起始列", 0, 4096, 0)
	fps = _add_spin("动画 FPS", 0.1, 120.0, 8.0, 0.1)

	_add_section("动画状态")
	var state_hint := Label.new()
	state_hint.text = "状态按列排列；起始列为 -1 时自动接在上一状态之后。"
	state_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(state_hint)
	state_list = VBoxContainer.new()
	add_child(state_list)
	var add_state := Button.new()
	add_state.text = "+ 添加状态"
	add_state.pressed.connect(_add_state.bind("state", 1, false, -1))
	add_child(add_state)

	_add_section("方向与所在行")
	var direction_hint := Label.new()
	direction_hint.text = "行号从 0 开始，可以跳过标题行。"
	direction_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(direction_hint)
	direction_list = VBoxContainer.new()
	add_child(direction_list)
	var add_direction := Button.new()
	add_direction.text = "+ 添加方向"
	add_direction.pressed.connect(_add_direction.bind("direction", 0))
	add_child(add_direction)

	_add_section("输出")
	var output_row := HBoxContainer.new()
	add_child(output_row)
	output_path = LineEdit.new()
	output_path.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	output_path.text = "res://generated/sprite_frames.tres"
	output_row.add_child(output_path)

	var generate := Button.new()
	generate.text = "生成 SpriteFrames"
	generate.add_theme_font_size_override("font_size", 16)
	generate.pressed.connect(_generate)
	add_child(generate)
	status = Label.new()
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(status)



func setup_editor(new_editor_interface: EditorInterface) -> void:
	editor_interface = new_editor_interface


func cleanup_dialogs() -> void:
	if is_instance_valid(preview_window):
		preview_window.hide()
		preview_window.queue_free()
	preview_window = null
	preview = null
	preview_scroll = null
	zoom_label = null


func _add_defaults() -> void:
	_add_state("idle", 4, true, -1)
	_add_state("walk", 4, true, -1)
	_add_state("attack", 4, true, -1)
	_add_state("hit", 4, true, -1)
	_add_state("death", 4, true, -1)
	_add_direction("down", 1)
	_add_direction("left", 2)
	_add_direction("right", 3)
	_add_direction("up", 4)


func _add_section(text: String) -> void:
	add_child(HSeparator.new())
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 15)
	add_child(label)


func _add_spin(label_text: String, min_value: float, max_value: float, value: float, step := 1.0) -> SpinBox:
	var row := HBoxContainer.new()
	add_child(row)
	var label := Label.new()
	label.text = label_text
	label.custom_minimum_size.x = 100
	row.add_child(label)
	var spin := SpinBox.new()
	spin.min_value = min_value
	spin.max_value = max_value
	spin.step = step
	spin.value = value
	spin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spin.value_changed.connect(_setting_changed)
	row.add_child(spin)
	return spin


func _add_state(state_name: String, count: int, loop: bool, start_column: int) -> void:
	var panel := PanelContainer.new()
	state_list.add_child(panel)
	var column := VBoxContainer.new()
	panel.add_child(column)
	var top := HBoxContainer.new()
	column.add_child(top)
	var name_edit := LineEdit.new()
	name_edit.placeholder_text = "状态名"
	name_edit.text = state_name
	name_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_edit.text_changed.connect(_text_changed)
	top.add_child(name_edit)
	var remove := Button.new()
	remove.text = "删除"
	top.add_child(remove)

	var options := HBoxContainer.new()
	column.add_child(options)
	var count_label := Label.new()
	count_label.text = "帧数"
	options.add_child(count_label)
	var count_spin := SpinBox.new()
	count_spin.min_value = 1
	count_spin.max_value = 999
	count_spin.value = count
	count_spin.value_changed.connect(_setting_changed)
	options.add_child(count_spin)
	var loop_check := CheckBox.new()
	loop_check.text = "循环"
	loop_check.button_pressed = loop
	loop_check.toggled.connect(_toggle_changed)
	options.add_child(loop_check)

	var start_row := HBoxContainer.new()
	column.add_child(start_row)
	var start_label := Label.new()
	start_label.text = "起始列（-1 自动）"
	start_row.add_child(start_label)
	var start_spin := SpinBox.new()
	start_spin.min_value = -1
	start_spin.max_value = 4096
	start_spin.value = start_column
	start_spin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	start_spin.value_changed.connect(_setting_changed)
	start_row.add_child(start_spin)

	state_entries.append({"panel": panel, "name": name_edit, "count": count_spin, "loop": loop_check, "start": start_spin})
	remove.pressed.connect(_remove_state.bind(panel))
	_refresh_preview()


func _remove_state(panel: Control) -> void:
	if state_entries.size() <= 1:
		_set_status("至少保留一个动画状态。", true)
		return
	for index in state_entries.size():
		if state_entries[index].panel == panel:
			state_entries.remove_at(index)
			panel.queue_free()
			break
	_refresh_preview()


func _add_direction(direction_name: String, row_index: int) -> void:
	var row := HBoxContainer.new()
	direction_list.add_child(row)
	var name_edit := LineEdit.new()
	name_edit.placeholder_text = "方向名"
	name_edit.text = direction_name
	name_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_edit.text_changed.connect(_text_changed)
	row.add_child(name_edit)
	var row_label := Label.new()
	row_label.text = "行"
	row.add_child(row_label)
	var row_spin := SpinBox.new()
	row_spin.min_value = 0
	row_spin.max_value = 4096
	row_spin.value = row_index
	row_spin.value_changed.connect(_setting_changed)
	row.add_child(row_spin)
	var remove := Button.new()
	remove.text = "删除"
	row.add_child(remove)
	direction_entries.append({"row_control": row, "name": name_edit, "row": row_spin})
	remove.pressed.connect(_remove_direction.bind(row))
	_refresh_preview()


func _remove_direction(row_control: Control) -> void:
	if direction_entries.size() <= 1:
		_set_status("至少保留一个方向。", true)
		return
	for index in direction_entries.size():
		if direction_entries[index].row_control == row_control:
			direction_entries.remove_at(index)
			row_control.queue_free()
			break
	_refresh_preview()


func _choose_source() -> void:
	if editor_interface == null:
		_set_status("编辑器接口尚未初始化，请重新启用插件。", true)
		return
	var selected_paths := editor_interface.get_selected_paths()
	for path in selected_paths:
		var selected_path := String(path)
		if selected_path.get_extension().to_lower() in ["png", "webp", "svg"]:
			_source_selected(selected_path)
			return
	_set_status("请先在 Godot 文件系统面板中选中 PNG、WebP 或 SVG。", true)


func _show_preview() -> void:
	if not is_instance_valid(preview_window):
		_build_preview_window()
	_refresh_preview()
	preview_window.show()


func _build_preview_window() -> void:
	preview_window = PanelContainer.new()
	preview_window.name = "SpriteSheetPreviewPanel"
	preview_window.custom_minimum_size = Vector2(0, 420)
	preview_window.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(preview_window)
	move_child(preview_window, preview_summary.get_index() + 1)

	var root := VBoxContainer.new()
	preview_window.add_child(root)
	var toolbar := HBoxContainer.new()
	root.add_child(toolbar)
	var preview_title := Label.new()
	preview_title.text = "实时预览"
	preview_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	preview_title.add_theme_font_size_override("font_size", 16)
	toolbar.add_child(preview_title)
	var zoom_out := Button.new()
	zoom_out.text = "−"
	zoom_out.tooltip_text = "缩小"
	zoom_out.pressed.connect(_change_zoom.bind(0.5))
	toolbar.add_child(zoom_out)
	zoom_label = Label.new()
	zoom_label.custom_minimum_size.x = 72
	zoom_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toolbar.add_child(zoom_label)
	var zoom_in := Button.new()
	zoom_in.text = "+"
	zoom_in.tooltip_text = "放大"
	zoom_in.pressed.connect(_change_zoom.bind(2.0))
	toolbar.add_child(zoom_in)
	var reset_zoom := Button.new()
	reset_zoom.text = "100%"
	reset_zoom.pressed.connect(_set_preview_zoom.bind(1.0))
	toolbar.add_child(reset_zoom)
	var pixel_zoom := Button.new()
	pixel_zoom.text = "像素画 4×"
	pixel_zoom.pressed.connect(_set_preview_zoom.bind(4.0))
	toolbar.add_child(pixel_zoom)
	var close_preview := Button.new()
	close_preview.text = "关闭"
	close_preview.pressed.connect(preview_window.hide)
	toolbar.add_child(close_preview)

	preview_scroll = ScrollContainer.new()
	preview_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	preview_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(preview_scroll)
	preview = PreviewControl.new()
	preview.mouse_filter = Control.MOUSE_FILTER_PASS
	preview_scroll.add_child(preview)
	_set_preview_zoom(2.0)


func _change_zoom(multiplier: float) -> void:
	if is_instance_valid(preview):
		_set_preview_zoom(preview.zoom * multiplier)


func _set_preview_zoom(value: float) -> void:
	if not is_instance_valid(preview):
		return
	preview.set_zoom(value)
	if is_instance_valid(zoom_label):
		zoom_label.text = "%d%%" % int(round(preview.zoom * 100.0))


func _source_selected(path: String) -> void:
	source_path = path
	source_texture = load(path) as Texture2D
	source_value.text = path
	output_path.text = "res://generated/%s_frames.tres" % path.get_file().get_basename().to_snake_case()
	_set_status("纹理已载入，请检查预览中的彩色选区。", false)
	_refresh_preview()


func _setting_changed(_value: float) -> void:
	_refresh_preview()


func _text_changed(_value: String) -> void:
	_refresh_preview()


func _toggle_changed(_value: bool) -> void:
	_refresh_preview()


func _resolved_states() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var next_column := int(base_column.value) if is_instance_valid(base_column) else 0
	for entry in state_entries:
		var explicit_start := int(entry.start.value)
		var resolved_start := explicit_start if explicit_start >= 0 else next_column
		var count := int(entry.count.value)
		result.append({"name": entry.name.text.strip_edges().to_snake_case(), "frame_count": count, "loop": entry.loop.button_pressed, "start_column": resolved_start})
		next_column = resolved_start + count
	return result


func _resolved_directions() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for entry in direction_entries:
		result.append({"name": entry.name.text.strip_edges().to_snake_case(), "row": int(entry.row.value)})
	return result


func _refresh_preview() -> void:
	if not is_instance_valid(frame_width):
		return
	var states := _resolved_states()
	var directions := _resolved_directions()
	if is_instance_valid(preview):
		preview.configure(source_texture, Vector2i(int(frame_width.value), int(frame_height.value)), Vector2i(int(margin_x.value), int(margin_y.value)), Vector2i(int(spacing_x.value), int(spacing_y.value)), states, directions)
	var frames_per_direction := 0
	for state in states:
		frames_per_direction += int(state.frame_count)
	preview_summary.text = "%d 个状态 × %d 个方向 = %d 个动画，共 %d 帧" % [states.size(), directions.size(), states.size() * directions.size(), frames_per_direction * directions.size()]


func _generate() -> void:
	if source_path.is_empty() or source_texture == null:
		_set_status("请先选择 Sprite Sheet。", true)
		return
	var states := _resolved_states()
	var directions := _resolved_directions()
	if not _validate(states, directions):
		return
	var save_path := output_path.text.strip_edges()
	if not save_path.begins_with("res://"):
		_set_status("输出路径必须位于 res:// 内。", true)
		return
	if not save_path.ends_with(".tres"):
		save_path += ".tres"
	if not _validate_regions(states, directions):
		return

	# Reuse the cached resource when overwriting an existing file. Scenes and the
	# SpriteFrames editor may still hold this exact object; replacing it with a
	# new object leaves them displaying stale frame selections until a restart.
	var frames: SpriteFrames = null
	if ResourceLoader.exists(save_path):
		frames = load(save_path) as SpriteFrames
	if frames == null:
		frames = SpriteFrames.new()
	else:
		for old_animation in frames.get_animation_names():
			frames.remove_animation(old_animation)
	if frames.has_animation(&"default"):
		frames.remove_animation(&"default")
	var total_frames := 0
	for state in states:
		for direction in directions:
			var animation_name := StringName("%s_%s" % [state.name, direction.name])
			frames.add_animation(animation_name)
			frames.set_animation_speed(animation_name, fps.value)
			frames.set_animation_loop_mode(animation_name, SpriteFrames.LOOP_LINEAR if state.loop else SpriteFrames.LOOP_NONE)
			for frame_index in int(state.frame_count):
				var region := _cell_region(int(state.start_column) + frame_index, int(direction.row))
				var atlas_frame := AtlasTexture.new()
				atlas_frame.atlas = source_texture
				atlas_frame.region = region
				frames.add_frame(animation_name, atlas_frame)
				total_frames += 1
	var absolute_directory := ProjectSettings.globalize_path(save_path.get_base_dir())
	if not DirAccess.dir_exists_absolute(absolute_directory):
		var mkdir_error := DirAccess.make_dir_recursive_absolute(absolute_directory)
		if mkdir_error != OK:
			_set_status("无法创建输出目录。", true)
			return
	var error := ResourceSaver.save(frames, save_path)
	if error != OK:
		_set_status("保存失败，错误代码：%d" % error, true)
		return
	frames.emit_changed()
	_set_status("生成完成：%d 个动画、%d 帧。\n%s" % [states.size() * directions.size(), total_frames, save_path], false)


func _validate_regions(states: Array[Dictionary], directions: Array[Dictionary]) -> bool:
	for state in states:
		for direction in directions:
			var animation_name := "%s_%s" % [state.name, direction.name]
			for frame_index in int(state.frame_count):
				var region := _cell_region(int(state.start_column) + frame_index, int(direction.row))
				if region.position.x < 0.0 or region.position.y < 0.0 or region.end.x > source_texture.get_width() or region.end.y > source_texture.get_height():
					_set_status("选区越界：%s 第 %d 帧。" % [animation_name, frame_index], true)
					return false
	return true


func _validate(states: Array[Dictionary], directions: Array[Dictionary]) -> bool:
	var names: Dictionary = {}
	for state in states:
		if String(state.name).is_empty():
			_set_status("状态名称不能为空。", true)
			return false
	for direction in directions:
		if String(direction.name).is_empty():
			_set_status("方向名称不能为空。", true)
			return false
	for state in states:
		for direction in directions:
			var combined := "%s_%s" % [state.name, direction.name]
			if names.has(combined):
				_set_status("动画名称重复：%s" % combined, true)
				return false
			names[combined] = true
	return true


func _cell_region(column: int, row: int) -> Rect2:
	return Rect2(margin_x.value + column * (frame_width.value + spacing_x.value), margin_y.value + row * (frame_height.value + spacing_y.value), frame_width.value, frame_height.value)


func _set_status(message: String, is_error: bool) -> void:
	if not is_instance_valid(status):
		return
	status.text = message
	status.modulate = Color("ff7777") if is_error else Color("8ee6a1")
