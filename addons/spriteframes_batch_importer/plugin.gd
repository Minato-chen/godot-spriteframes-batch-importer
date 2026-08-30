@tool
extends EditorPlugin

var dock: ScrollContainer
var dock_content: Control


func _enter_tree() -> void:
	dock = ScrollContainer.new()
	dock.name = "帧导入"
	dock.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	dock.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	dock.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dock.size_flags_vertical = Control.SIZE_EXPAND_FILL

	dock_content = preload("res://addons/spriteframes_batch_importer/spriteframes_batch_importer_dock.gd").new()
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
