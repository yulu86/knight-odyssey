extends Node

var is_initialized: bool = false

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

var current_state: GameState = GameState.MENU


func _ready() -> void:
	_initialize()


func is_game_manager_initialized() -> bool:
	return is_initialized


func _initialize() -> void:
	if is_initialized:
		return

	is_initialized = true
	current_state = GameState.MENU
