class_name LevelBase
extends Node2D

@export var level_id: String = ""
@export var level_name: String = ""
@export var theme_type: String = "grassland"

var _player: Node = null

signal level_ready
signal player_spawned(player)


func _ready() -> void:
	emit_signal("level_ready")

	if not level_id.is_empty():
		EventBus.level_started.emit(level_id)


func spawn_player(player_scene: PackedScene) -> void:
	if player_scene == null:
		return

	var player = player_scene.instantiate()

	if player:
		add_child(player)
		emit_signal("player_spawned", player)


func on_player_entered(player: Node) -> void:
	_player = player


func on_player_exited() -> void:
	_player = null


func on_goal_reached() -> void:
	var current_score = 0
	LevelManager.complete_level(level_id, current_score)
	LevelManager.save_level_progress()
