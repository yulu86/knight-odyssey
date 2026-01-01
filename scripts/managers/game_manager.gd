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

var _loading_scene_path: String = ""
var _is_loading: bool = false


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
		_start_threaded_load(scene_path)
	else:
		_load_scene_immediate(scene_path)


func get_current_scene() -> String:
	return current_scene_path


func set_scene_switching_enabled(enabled: bool) -> void:
	_enable_scene_switching = enabled


func _process(_delta: float) -> void:
	if _is_loading and not _loading_scene_path.is_empty():
		_check_loading_progress()


func _start_threaded_load(scene_path: String) -> void:
	var status = ResourceLoader.load_threaded_request(scene_path)
	if status == OK:
		_loading_scene_path = scene_path
		_is_loading = true
		set_process(true)
	else:
		print("Error: Failed to start threaded load: ", scene_path)
		EventBus.scene_loading_finished.emit(scene_path)


func _check_loading_progress() -> void:
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(_loading_scene_path, progress)

	if progress.size() > 0:
		EventBus.scene_loading_progress.emit(progress[0])

	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var scene_resource = ResourceLoader.load_threaded_get(_loading_scene_path) as PackedScene
		if scene_resource:
			if _enable_scene_switching:
				get_tree().change_scene_to_packed(scene_resource)
			current_scene_path = _loading_scene_path
		_is_loading = false
		_loading_scene_path = ""
		set_process(false)
		EventBus.scene_loading_finished.emit(current_scene_path)
	elif status == ResourceLoader.THREAD_LOAD_FAILED:
		print("Error: Failed to load scene: ", _loading_scene_path)
		_is_loading = false
		_loading_scene_path = ""
		set_process(false)
		EventBus.scene_loading_finished.emit("")


func _load_scene_immediate(scene_path: String) -> void:
	var scene_resource = load(scene_path) as PackedScene
	if scene_resource:
		if _enable_scene_switching:
			get_tree().change_scene_to_packed(scene_resource)
		current_scene_path = scene_path
		EventBus.scene_loading_finished.emit(scene_path)
