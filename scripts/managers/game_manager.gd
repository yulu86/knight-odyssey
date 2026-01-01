extends Node

var is_initialized: bool = false

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

var current_state: GameState = GameState.MENU

var current_scene_path: String = ""
var _enable_scene_switching: bool = true


func _ready() -> void:
	_initialize()


func is_game_manager_initialized() -> bool:
	return is_initialized


func _initialize() -> void:
	if is_initialized:
		return

	is_initialized = true
	current_state = GameState.MENU


func load_scene(scene_path: String, show_progress: bool = false) -> void:
	if not ResourceLoader.exists(scene_path):
		print("Error: Scene file not found: ", scene_path)
		return

	EventBus.scene_loading_started.emit(scene_path)

	if show_progress:
		ResourceLoader.load_threaded_request(scene_path)
	else:
		var scene_resource = load(scene_path) as PackedScene
		if scene_resource:
			if _enable_scene_switching:
				get_tree().change_scene_to_packed(scene_resource)
			current_scene_path = scene_path
			EventBus.scene_loading_finished.emit(scene_path)


func get_current_scene() -> String:
	return current_scene_path


func set_scene_switching_enabled(enabled: bool) -> void:
	_enable_scene_switching = enabled
