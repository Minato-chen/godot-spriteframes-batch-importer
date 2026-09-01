@tool
extends RefCounted


class State:
	extends RefCounted

	var name: String
	var frame_count: int
	var loop: bool
	var fps: float
	var start_column: int

	static func from_dictionary(data: Dictionary) -> State:
		var state := State.new()
		state.name = String(data.get("name", ""))
		state.frame_count = int(data.get("frame_count", 0))
		state.loop = bool(data.get("loop", false))
		state.fps = float(data.get("fps", 0.0))
		state.start_column = int(data.get("start_column", 0))
		return state


class Direction:
	extends RefCounted

	var name: String
	var row: int

	static func from_dictionary(data: Dictionary) -> Direction:
		var direction := Direction.new()
		direction.name = String(data.get("name", ""))
		direction.row = int(data.get("row", 0))
		return direction
