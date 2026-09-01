@tool
extends RefCounted

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
