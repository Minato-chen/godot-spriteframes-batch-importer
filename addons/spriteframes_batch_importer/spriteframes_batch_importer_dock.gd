@tool
extends VBoxContainer

const PreviewControl = preload("res://addons/spriteframes_batch_importer/sprite_sheet_preview.gd")
const TEXTS := {
	"zh": {
		"dock_title": "帧导入", "title": "SpriteFrames 批量导入", "language": "界面语言", "select_sheet": "使用文件系统中选中的图集", "no_texture": "尚未选择图集",
		"preview_section": "图集预览", "open_preview": "展开可缩放预览", "slice_section": "切片设置",
		"frame_width": "帧宽（像素）", "frame_height": "帧高（像素）", "margin_x": "左边距（像素）", "margin_y": "上边距（像素）", "spacing_x": "横向间隔（像素）", "spacing_y": "纵向间隔（像素）", "base_column": "起始列（从 0 开始）", "fps": "默认动画速度（FPS）", "fps_hint": "默认速度为 8 FPS，即每帧 0.125 秒；每个状态也可以单独设置。",
		"states_section": "动画状态", "state_hint": "状态按列排列；起始列为 -1 时自动接在上一状态之后。", "add_state": "+ 添加状态",
		"directions_section": "方向与行号", "direction_hint": "行号从 0 开始：图集没有标题行时，第一个方向填 0；有 1 行标题时，第一个方向填 1。", "add_direction": "+ 添加方向",
		"output_section": "输出设置", "generate": "生成 SpriteFrames", "state_name": "状态名称", "direction_name": "方向名称",
		"remove": "删除", "frame_count": "帧数（帧）", "loop": "循环", "use_default_fps": "使用默认 FPS", "state_fps": "状态速度（FPS）", "start_column_auto": "起始列（从 0 开始；-1 为自动）", "row": "行号（从 0 开始）",
		"preview_title": "图集预览", "zoom_out": "缩小", "zoom_in": "放大", "pixel_4x": "像素画 4×", "close": "关闭",
		"summary": "预览统计：%d 个状态 × %d 个方向，将生成 %d 个动画、共 %d 帧",
		"keep_state": "至少保留一个动画状态。", "keep_direction": "至少保留一个方向。", "editor_unavailable": "编辑器接口尚未初始化，请重新启用插件。",
		"select_hint": "请先在 Godot 文件系统面板中选中 PNG、WebP 或 SVG 图集。", "texture_load_failed": "无法加载图集：%s", "texture_loaded": "图集已载入，请检查预览中的彩色选区。",
		"select_first": "请先选择图集。", "output_empty": "输出路径不能为空。", "path_res": "输出路径必须位于 res:// 内。", "output_directory": "输出路径不能是目录：%s", "output_extension": "输出文件必须使用 .tres 扩展名：%s", "out_of_bounds": "选区越界：%s 的第 %d 帧。",
		"output_not_spriteframes": "输出文件已存在，但不是 SpriteFrames 资源：%s", "output_not_writable": "输出位置不可写：%s", "overwrite_title": "确认覆盖", "overwrite_message": "该 SpriteFrames 文件已存在，继续将替换其中的所有动画：\n%s", "overwrite": "覆盖", "cancel": "取消", "mkdir_failed": "无法创建输出目录。", "save_failed": "保存失败，错误代码：%d", "generated": "生成完成：%d 个动画、%d 帧。\n%s",
		"empty_state": "状态名称不能为空。", "empty_direction": "方向名称不能为空。", "duplicate": "动画名称重复：%s"
	},
	"en": {
		"dock_title": "Frame Import", "title": "SpriteFrames Batch Importer", "language": "Interface Language", "select_sheet": "Use Selected Sprite Sheet", "no_texture": "No sprite sheet selected",
		"preview_section": "Sprite Sheet Preview", "open_preview": "Expand Zoomable Preview", "slice_section": "Slice Settings",
		"frame_width": "Frame Width (px)", "frame_height": "Frame Height (px)", "margin_x": "Left Margin (px)", "margin_y": "Top Margin (px)", "spacing_x": "Horizontal Spacing (px)", "spacing_y": "Vertical Spacing (px)", "base_column": "Base Column (0-based)", "fps": "Default Animation Speed (FPS)", "fps_hint": "The default speed is 8 FPS, or 0.125 seconds per frame. Each state can override it.",
		"states_section": "Animation States", "state_hint": "States run across columns. A start column of -1 continues after the previous state.", "add_state": "+ Add State",
		"directions_section": "Directions and Row Indices", "direction_hint": "Rows are zero-based: use 0 for the first direction when the sheet has no header row, or 1 when it has one header row.", "add_direction": "+ Add Direction",
		"output_section": "Output Settings", "generate": "Generate SpriteFrames", "state_name": "State Name", "direction_name": "Direction Name",
		"remove": "Remove", "frame_count": "Frame Count (frames)", "loop": "Loop", "use_default_fps": "Use Default FPS", "state_fps": "State Speed (FPS)", "start_column_auto": "Start Column (0-based; -1 for Auto)", "row": "Row (0-based)",
		"preview_title": "Sprite Sheet Preview", "zoom_out": "Zoom Out", "zoom_in": "Zoom In", "pixel_4x": "Pixel Art 4×", "close": "Close",
		"summary": "Preview summary: %d states × %d directions will generate %d animations with %d frames total",
		"keep_state": "Keep at least one animation state.", "keep_direction": "Keep at least one direction.", "editor_unavailable": "The editor interface is unavailable. Re-enable the plugin.",
		"select_hint": "Select a PNG, WebP, or SVG in Godot's FileSystem dock first.", "texture_load_failed": "Could not load sprite sheet: %s", "texture_loaded": "Texture loaded. Check the colored selections in the preview.",
		"select_first": "Select a sprite sheet first.", "output_empty": "The output path cannot be empty.", "path_res": "The output path must be inside res://.", "output_directory": "The output path cannot be a directory: %s", "output_extension": "The output file must use the .tres extension: %s", "out_of_bounds": "Selection out of bounds: %s, frame %d.",
		"output_not_spriteframes": "The output file already exists but is not a SpriteFrames resource: %s", "output_not_writable": "The output location is not writable: %s", "overwrite_title": "Confirm Overwrite", "overwrite_message": "This SpriteFrames file already exists. Continuing will replace all of its animations:\n%s", "overwrite": "Overwrite", "cancel": "Cancel", "mkdir_failed": "Could not create the output directory.", "save_failed": "Save failed with error code %d.", "generated": "Generated %d animations and %d frames.\n%s",
		"empty_state": "State names cannot be empty.", "empty_direction": "Direction names cannot be empty.", "duplicate": "Duplicate animation name: %s"
	}
}

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
var overwrite_dialog: ConfirmationDialog
var state_list: VBoxContainer
var direction_list: VBoxContainer
var state_entries: Array[Dictionary] = []
var direction_entries: Array[Dictionary] = []
var status: Label
var editor_interface: EditorInterface
var current_language := "zh"
var language_picker: OptionButton
var ui_text: Dictionary = {}
var pending_overwrite_path := ""
var confirmed_overwrite_path := ""


func _ready() -> void:
	auto_translate_mode = Node.AUTO_TRANSLATE_MODE_DISABLED
	custom_minimum_size = Vector2(300, 0)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_build_ui()
	_add_defaults()
	_refresh_preview()


func _build_ui() -> void:
	var title := Label.new()
	title.text = _t("title")
	add_child(title)
	ui_text.title = title

	var language_row := HBoxContainer.new()
	add_child(language_row)
	var language_label := Label.new()
	language_label.text = _t("language")
	language_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	language_row.add_child(language_label)
	language_picker = OptionButton.new()
	language_picker.add_item("中文")
	language_picker.add_item("English")
	language_picker.select(0 if current_language == "zh" else 1)
	language_picker.item_selected.connect(_language_selected)
	language_row.add_child(language_picker)

	var choose := Button.new()
	choose.text = _t("select_sheet")
	choose.pressed.connect(_choose_source)
	add_child(choose)
	ui_text.select_sheet = choose
	source_value = Label.new()
	source_value.text = _t("no_texture")
	source_value.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(source_value)

	_add_section("preview_section")
	var open_preview := Button.new()
	open_preview.text = _t("open_preview")
	open_preview.pressed.connect(_show_preview)
	add_child(open_preview)
	ui_text.open_preview = open_preview
	preview_summary = Label.new()
	preview_summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(preview_summary)

	_add_section("slice_section")
	frame_width = _add_spin("frame_width", 1, 4096, 16)
	frame_height = _add_spin("frame_height", 1, 4096, 16)
	margin_x = _add_spin("margin_x", 0, 4096, 0)
	margin_y = _add_spin("margin_y", 0, 4096, 0)
	spacing_x = _add_spin("spacing_x", 0, 4096, 0)
	spacing_y = _add_spin("spacing_y", 0, 4096, 0)
	base_column = _add_spin("base_column", 0, 4096, 0)
	fps = _add_spin("fps", 0.1, 120.0, 8.0, 0.1)
	fps.value_changed.connect(_default_fps_changed)
	var fps_hint := Label.new()
	fps_hint.text = _t("fps_hint")
	fps_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	fps_hint.modulate = Color(0.72, 0.74, 0.78)
	add_child(fps_hint)
	ui_text.fps_hint = fps_hint

	_add_section("states_section")
	var state_hint := Label.new()
	state_hint.text = _t("state_hint")
	state_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(state_hint)
	ui_text.state_hint = state_hint
	state_list = VBoxContainer.new()
	add_child(state_list)
	var add_state := Button.new()
	add_state.text = _t("add_state")
	add_state.pressed.connect(_add_state.bind("state", 1, false, -1))
	add_child(add_state)
	ui_text.add_state = add_state

	_add_section("directions_section")
	var direction_hint := Label.new()
	direction_hint.text = _t("direction_hint")
	direction_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(direction_hint)
	ui_text.direction_hint = direction_hint
	direction_list = VBoxContainer.new()
	add_child(direction_list)
	var add_direction := Button.new()
	add_direction.text = _t("add_direction")
	add_direction.pressed.connect(_add_direction.bind("direction", 0))
	add_child(add_direction)
	ui_text.add_direction = add_direction

	_add_section("output_section")
	var output_row := HBoxContainer.new()
	add_child(output_row)
	output_path = LineEdit.new()
	output_path.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	output_path.text = "res://generated/sprite_frames.tres"
	output_row.add_child(output_path)

	var generate := Button.new()
	generate.text = _t("generate")
	generate.pressed.connect(_generate)
	add_child(generate)
	ui_text.generate = generate
	status = Label.new()
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(status)


func set_language(language: String) -> void:
	current_language = "zh" if language.begins_with("zh") else "en"


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
	if is_instance_valid(overwrite_dialog):
		overwrite_dialog.queue_free()
	overwrite_dialog = null


func _add_defaults() -> void:
	_add_state("idle", 4, true, -1)
	_add_state("walk", 4, true, -1)
	_add_state("attack", 4, false, -1)
	_add_state("hit", 4, false, -1)
	_add_state("death", 4, false, -1)
	_add_direction("down", 1)
	_add_direction("left", 2)
	_add_direction("right", 3)
	_add_direction("up", 4)


func _add_section(text_key: String) -> void:
	add_child(HSeparator.new())
	var label := Label.new()
	label.text = _t(text_key)
	add_child(label)
	ui_text[text_key] = label


func _add_spin(label_key: String, min_value: float, max_value: float, value: float, step := 1.0) -> SpinBox:
	var row := HBoxContainer.new()
	add_child(row)
	var label := Label.new()
	label.text = _t(label_key)
	label.custom_minimum_size.x = 100
	row.add_child(label)
	ui_text[label_key] = label
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
	name_edit.placeholder_text = _t("state_name")
	name_edit.text = state_name
	name_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_edit.text_changed.connect(_text_changed)
	top.add_child(name_edit)
	var remove := Button.new()
	remove.text = _t("remove")
	top.add_child(remove)

	var options := HBoxContainer.new()
	column.add_child(options)
	var count_label := Label.new()
	count_label.text = _t("frame_count")
	options.add_child(count_label)
	var count_spin := SpinBox.new()
	count_spin.min_value = 1
	count_spin.max_value = 999
	count_spin.value = count
	count_spin.value_changed.connect(_setting_changed)
	options.add_child(count_spin)
	var loop_check := CheckBox.new()
	loop_check.text = _t("loop")
	loop_check.button_pressed = loop
	loop_check.toggled.connect(_toggle_changed)
	options.add_child(loop_check)

	var fps_row := HBoxContainer.new()
	column.add_child(fps_row)
	var use_default_fps := CheckBox.new()
	use_default_fps.text = _t("use_default_fps")
	use_default_fps.button_pressed = true
	fps_row.add_child(use_default_fps)
	var state_fps_label := Label.new()
	state_fps_label.text = _t("state_fps")
	fps_row.add_child(state_fps_label)
	var state_fps := SpinBox.new()
	state_fps.min_value = 0.1
	state_fps.max_value = 120.0
	state_fps.step = 0.1
	state_fps.value = fps.value if is_instance_valid(fps) else 8.0
	state_fps.editable = false
	state_fps.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	state_fps.value_changed.connect(_setting_changed)
	fps_row.add_child(state_fps)
	use_default_fps.toggled.connect(_state_default_fps_toggled.bind(state_fps))

	var start_row := HBoxContainer.new()
	column.add_child(start_row)
	var start_label := Label.new()
	start_label.text = _t("start_column_auto")
	start_row.add_child(start_label)
	var start_spin := SpinBox.new()
	start_spin.min_value = -1
	start_spin.max_value = 4096
	start_spin.value = start_column
	start_spin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	start_spin.value_changed.connect(_setting_changed)
	start_row.add_child(start_spin)

	state_entries.append({
		"panel": panel, "name": name_edit, "count": count_spin, "loop": loop_check,
		"use_default_fps": use_default_fps, "state_fps": state_fps,
		"state_fps_label": state_fps_label, "start": start_spin, "remove": remove,
		"count_label": count_label, "start_label": start_label
	})
	remove.pressed.connect(_remove_state.bind(panel))
	_refresh_preview()


func _remove_state(panel: Control) -> void:
	if state_entries.size() <= 1:
		_set_status(_t("keep_state"), true)
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
	name_edit.placeholder_text = _t("direction_name")
	name_edit.text = direction_name
	name_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_edit.text_changed.connect(_text_changed)
	row.add_child(name_edit)
	var row_label := Label.new()
	row_label.text = _t("row")
	row.add_child(row_label)
	var row_spin := SpinBox.new()
	row_spin.min_value = 0
	row_spin.max_value = 4096
	row_spin.value = row_index
	row_spin.value_changed.connect(_setting_changed)
	row.add_child(row_spin)
	var remove := Button.new()
	remove.text = _t("remove")
	row.add_child(remove)
	direction_entries.append({
		"row_control": row, "name": name_edit, "row": row_spin,
		"row_label": row_label, "remove": remove
	})
	remove.pressed.connect(_remove_direction.bind(row))
	_refresh_preview()


func _remove_direction(row_control: Control) -> void:
	if direction_entries.size() <= 1:
		_set_status(_t("keep_direction"), true)
		return
	for index in direction_entries.size():
		if direction_entries[index].row_control == row_control:
			direction_entries.remove_at(index)
			row_control.queue_free()
			break
	_refresh_preview()


func _choose_source() -> void:
	if editor_interface == null:
		_set_status(_t("editor_unavailable"), true)
		return
	var selected_paths := editor_interface.get_selected_paths()
	for path in selected_paths:
		var selected_path := String(path)
		if selected_path.get_extension().to_lower() in ["png", "webp", "svg"]:
			_source_selected(selected_path)
			return
	_set_status(_t("select_hint"), true)


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
	var toolbar := VBoxContainer.new()
	root.add_child(toolbar)
	var zoom_row := HBoxContainer.new()
	toolbar.add_child(zoom_row)
	var preview_title := Label.new()
	preview_title.text = _t("preview_title")
	preview_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	zoom_row.add_child(preview_title)
	ui_text.preview_title = preview_title
	var zoom_out := Button.new()
	zoom_out.text = "−"
	zoom_out.tooltip_text = _t("zoom_out")
	zoom_out.pressed.connect(_change_zoom.bind(0.5))
	zoom_row.add_child(zoom_out)
	ui_text.zoom_out = zoom_out
	zoom_label = Label.new()
	zoom_label.custom_minimum_size.x = 72
	zoom_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	zoom_row.add_child(zoom_label)
	var zoom_in := Button.new()
	zoom_in.text = "+"
	zoom_in.tooltip_text = _t("zoom_in")
	zoom_in.pressed.connect(_change_zoom.bind(2.0))
	zoom_row.add_child(zoom_in)
	ui_text.zoom_in = zoom_in
	var reset_zoom := Button.new()
	reset_zoom.text = "100%"
	reset_zoom.pressed.connect(_set_preview_zoom.bind(1.0))
	zoom_row.add_child(reset_zoom)
	var action_row := HBoxContainer.new()
	action_row.alignment = BoxContainer.ALIGNMENT_END
	toolbar.add_child(action_row)
	var pixel_zoom := Button.new()
	pixel_zoom.text = _t("pixel_4x")
	pixel_zoom.pressed.connect(_set_preview_zoom.bind(4.0))
	action_row.add_child(pixel_zoom)
	ui_text.pixel_4x = pixel_zoom
	var close_preview := Button.new()
	close_preview.text = _t("close")
	close_preview.pressed.connect(preview_window.hide)
	action_row.add_child(close_preview)
	ui_text.close = close_preview

	var preview_area := Control.new()
	preview_area.custom_minimum_size = Vector2(0, 420)
	preview_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	preview_area.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(preview_area)
	preview_scroll = ScrollContainer.new()
	preview_scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	preview_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	preview_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	preview_area.add_child(preview_scroll)
	preview = PreviewControl.new()
	preview.mouse_filter = Control.MOUSE_FILTER_PASS
	preview.set_empty_message(_t("no_texture"))
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
	var texture := load(path) as Texture2D
	if texture == null:
		_set_status(_t("texture_load_failed") % path, true)
		return
	source_path = path
	source_texture = texture
	source_value.text = path
	var output_file_name := "%s_frames.tres" % path.get_file().get_basename()
	output_path.text = path.get_base_dir().path_join(output_file_name)
	_set_status(_t("texture_loaded"), false)
	_refresh_preview()


func _setting_changed(_value: float) -> void:
	_refresh_preview()


func _default_fps_changed(value: float) -> void:
	for entry in state_entries:
		if entry.use_default_fps.button_pressed:
			entry.state_fps.value = value
	_refresh_preview()


func _state_default_fps_toggled(use_default: bool, state_fps: SpinBox) -> void:
	state_fps.editable = not use_default
	if use_default and is_instance_valid(fps):
		state_fps.value = fps.value
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
		var animation_fps: float = float(fps.value if entry.use_default_fps.button_pressed else entry.state_fps.value)
		result.append({
			"name": entry.name.text.strip_edges().to_snake_case(), "frame_count": count,
			"loop": entry.loop.button_pressed, "fps": animation_fps,
			"start_column": resolved_start
		})
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
		preview.configure(
			source_texture,
			Vector2i(int(frame_width.value), int(frame_height.value)),
			Vector2i(int(margin_x.value), int(margin_y.value)),
			Vector2i(int(spacing_x.value), int(spacing_y.value)),
			states,
			directions
		)
	var frames_per_direction := 0
	for state in states:
		frames_per_direction += int(state.frame_count)
	preview_summary.text = _t("summary") % [
		states.size(), directions.size(), states.size() * directions.size(),
		frames_per_direction * directions.size()
	]


func _generate() -> void:
	if source_path.is_empty() or source_texture == null:
		_set_status(_t("select_first"), true)
		return
	var states := _resolved_states()
	var directions := _resolved_directions()
	if not _validate(states, directions):
		return
	var save_path := _resolve_save_path()
	if save_path.is_empty():
		return
	if not _validate_regions(states, directions):
		return
	var existing_frames := _load_existing_sprite_frames(save_path)
	if ResourceLoader.exists(save_path):
		if existing_frames == null:
			return
		if confirmed_overwrite_path != save_path:
			_show_overwrite_confirmation(save_path)
			return
	confirmed_overwrite_path = ""
	var absolute_directory := ProjectSettings.globalize_path(save_path.get_base_dir())
	if not DirAccess.dir_exists_absolute(absolute_directory):
		var mkdir_error := DirAccess.make_dir_recursive_absolute(absolute_directory)
		if mkdir_error != OK:
			_set_status(_t("mkdir_failed"), true)
			return
	if not _is_output_writable(save_path):
		return

	var generated_frames := _build_sprite_frames(states, directions)
	var frames := generated_frames
	var backup_frames: SpriteFrames = null
	if existing_frames != null:
		backup_frames = existing_frames.duplicate(true) as SpriteFrames
		_copy_animations(generated_frames, existing_frames)
		frames = existing_frames
	var error := ResourceSaver.save(frames, save_path)
	if error != OK:
		if backup_frames != null:
			_copy_animations(backup_frames, frames)
			frames.emit_changed()
		_set_status(_t("save_failed") % error, true)
		return
	frames.emit_changed()
	_set_status(_t("generated") % [states.size() * directions.size(), _frame_total(states, directions), save_path], false)


func _load_existing_sprite_frames(save_path: String) -> SpriteFrames:
	if not ResourceLoader.exists(save_path):
		return null
	var frames := load(save_path) as SpriteFrames
	if frames == null:
		_set_status(_t("output_not_spriteframes") % save_path, true)
	return frames


func _build_sprite_frames(states: Array[Dictionary], directions: Array[Dictionary]) -> SpriteFrames:
	var frames := SpriteFrames.new()
	_clear_animations(frames)
	for state in states:
		for direction in directions:
			var animation_name := StringName("%s_%s" % [state.name, direction.name])
			frames.add_animation(animation_name)
			frames.set_animation_speed(animation_name, float(state.fps))
			frames.set_animation_loop_mode(animation_name, SpriteFrames.LOOP_LINEAR if state.loop else SpriteFrames.LOOP_NONE)
			for frame_index in int(state.frame_count):
				var region := _cell_region(int(state.start_column) + frame_index, int(direction.row))
				var atlas_frame := AtlasTexture.new()
				atlas_frame.atlas = source_texture
				atlas_frame.region = region
				frames.add_frame(animation_name, atlas_frame)
	return frames


func _show_overwrite_confirmation(save_path: String) -> void:
	if not is_instance_valid(overwrite_dialog):
		overwrite_dialog = ConfirmationDialog.new()
		add_child(overwrite_dialog)
		overwrite_dialog.confirmed.connect(_overwrite_confirmed)
	pending_overwrite_path = save_path
	overwrite_dialog.title = _t("overwrite_title")
	overwrite_dialog.dialog_text = _t("overwrite_message") % save_path
	overwrite_dialog.ok_button_text = _t("overwrite")
	overwrite_dialog.get_cancel_button().text = _t("cancel")
	overwrite_dialog.popup_centered()


func _overwrite_confirmed() -> void:
	confirmed_overwrite_path = pending_overwrite_path
	pending_overwrite_path = ""
	_generate()


func _copy_animations(source: SpriteFrames, target: SpriteFrames) -> void:
	# Keep the cached target resource alive for open editor inspectors and rollback.
	_clear_animations(target)
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


func _clear_animations(frames: SpriteFrames) -> void:
	for animation_name in frames.get_animation_names():
		frames.remove_animation(animation_name)


func _frame_total(states: Array[Dictionary], directions: Array[Dictionary]) -> int:
	var frames_per_direction := 0
	for state in states:
		frames_per_direction += int(state.frame_count)
	return frames_per_direction * directions.size()


func _resolve_save_path() -> String:
	var save_path := output_path.text.strip_edges()
	if save_path.is_empty():
		_set_status(_t("output_empty"), true)
		return ""
	if not save_path.begins_with("res://"):
		_set_status(_t("path_res"), true)
		return ""
	if save_path.ends_with("/"):
		_set_status(_t("output_directory") % save_path, true)
		return ""
	if DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(save_path)):
		_set_status(_t("output_directory") % save_path, true)
		return ""
	var extension := save_path.get_extension()
	if extension.is_empty():
		return "%s.tres" % save_path
	if extension.to_lower() != "tres":
		_set_status(_t("output_extension") % save_path, true)
		return ""
	return save_path


func _is_output_writable(save_path: String) -> bool:
	if FileAccess.file_exists(save_path):
		var output_file := FileAccess.open(save_path, FileAccess.READ_WRITE)
		if output_file == null:
			_set_status(_t("output_not_writable") % save_path, true)
			return false
		output_file.close()
		return true

	# Probe a new path without creating the actual output resource.
	var probe_path := "%s/.spriteframes_batch_importer_%d.tmp" % [save_path.get_base_dir(), Time.get_ticks_usec()]
	var probe_file := FileAccess.open(probe_path, FileAccess.WRITE)
	if probe_file == null:
		_set_status(_t("output_not_writable") % save_path, true)
		return false
	probe_file.close()
	if DirAccess.remove_absolute(ProjectSettings.globalize_path(probe_path)) != OK:
		_set_status(_t("output_not_writable") % save_path, true)
		return false
	return true


func _validate_regions(states: Array[Dictionary], directions: Array[Dictionary]) -> bool:
	for state in states:
		for direction in directions:
			var animation_name := "%s_%s" % [state.name, direction.name]
			for frame_index in int(state.frame_count):
				var region := _cell_region(int(state.start_column) + frame_index, int(direction.row))
				if (
					region.position.x < 0.0 or region.position.y < 0.0
					or region.end.x > source_texture.get_width()
					or region.end.y > source_texture.get_height()
				):
					_set_status(_t("out_of_bounds") % [animation_name, frame_index + 1], true)
					return false
	return true


func _validate(states: Array[Dictionary], directions: Array[Dictionary]) -> bool:
	var names: Dictionary = {}
	for state in states:
		if String(state.name).is_empty():
			_set_status(_t("empty_state"), true)
			return false
	for direction in directions:
		if String(direction.name).is_empty():
			_set_status(_t("empty_direction"), true)
			return false
	for state in states:
		for direction in directions:
			var combined := "%s_%s" % [state.name, direction.name]
			if names.has(combined):
				_set_status(_t("duplicate") % combined, true)
				return false
			names[combined] = true
	return true


func _cell_region(column: int, row: int) -> Rect2:
	return Rect2(
		margin_x.value + column * (frame_width.value + spacing_x.value),
		margin_y.value + row * (frame_height.value + spacing_y.value),
		frame_width.value,
		frame_height.value
	)


func _t(key: String) -> String:
	return String(TEXTS.get(current_language, TEXTS.en).get(key, key))


func _language_selected(index: int) -> void:
	current_language = "zh" if index == 0 else "en"
	_refresh_ui_text()


func _refresh_ui_text() -> void:
	if is_instance_valid(language_picker):
		var language_label := language_picker.get_parent().get_child(0) as Label
		if language_label != null:
			language_label.text = _t("language")
	var static_keys := [
		"title", "select_sheet", "open_preview", "preview_section", "slice_section",
		"frame_width", "frame_height", "margin_x", "margin_y", "spacing_x", "spacing_y", "base_column", "fps", "fps_hint",
		"states_section", "state_hint", "add_state", "directions_section", "direction_hint", "add_direction", "output_section", "generate",
		"preview_title", "pixel_4x", "close"
	]
	for key in static_keys:
		if ui_text.has(key) and is_instance_valid(ui_text[key]):
			ui_text[key].text = _t(key)
	if ui_text.has("zoom_out") and is_instance_valid(ui_text.zoom_out):
		ui_text.zoom_out.tooltip_text = _t("zoom_out")
	if ui_text.has("zoom_in") and is_instance_valid(ui_text.zoom_in):
		ui_text.zoom_in.tooltip_text = _t("zoom_in")
	for entry in state_entries:
		entry.name.placeholder_text = _t("state_name")
		entry.remove.text = _t("remove")
		entry.count_label.text = _t("frame_count")
		entry.loop.text = _t("loop")
		entry.use_default_fps.text = _t("use_default_fps")
		entry.state_fps_label.text = _t("state_fps")
		entry.start_label.text = _t("start_column_auto")
	for entry in direction_entries:
		entry.name.placeholder_text = _t("direction_name")
		entry.row_label.text = _t("row")
		entry.remove.text = _t("remove")
	if source_path.is_empty() and is_instance_valid(source_value):
		source_value.text = _t("no_texture")
	if is_instance_valid(status):
		status.text = ""
	if is_instance_valid(preview):
		preview.set_empty_message(_t("no_texture"))
	_refresh_preview()


func _set_status(message: String, is_error: bool) -> void:
	if not is_instance_valid(status):
		return
	status.text = message
	status.modulate = Color("ff7777") if is_error else Color("8ee6a1")
