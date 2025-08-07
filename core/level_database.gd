extends Node
class_name LevelDatabase

@export var level_data: Array[LevelInfo]

var level_count: int:
	get:
		return level_data.size()

var win_game_score: int:
	get:
		return get_level_max_score(level_count - 1)

func get_total_max_score() -> int:
	var total: int = 0
	for data in level_data:
		total += data.max_score
	return total

func get_level_max_score(index: int) -> int:
	if index >= 0 and index < level_data.size():
		return level_data[index].max_score
	return 0
