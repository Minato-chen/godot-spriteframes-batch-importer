@tool
extends EditorPlugin

const DOCK_CONTENT = preload("res://addons/spriteframes_batch_importer/spriteframes_batch_importer_dock.gd")

var dock: ScrollContainer
var dock_content: Control


func _enter_tree() -> void:
	var language := "zh" if TranslationServer.get_locale().begins_with("zh") else "en"
	dock = ScrollContainer.new()
	dock.name = "帧导入" if language == "zh" else "Frame Import"
	dock.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	dock.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	dock.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dock.size_flags_vertical = Control.SIZE_EXPAND_FILL

	dock_content = DOCK_CONTENT.new()
	dock_content.set_language(language)
	dock_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dock_content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dock.add_child(dock_content)
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)
	dock_content.setup_editor(get_editor_interface())


func _exit_tree() -> void:
	if is_instance_valid(dock_content):
		dock_content.cleanup_dialogs()
	if is_instance_valid(dock):
		remove_control_from_docks(dock)
		dock.free()
	dock_content = null
	dock = null
