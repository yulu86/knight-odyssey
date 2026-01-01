extends GutTest

const TEST_SCENE_PATH = "res://scenes/player/player.tscn"


func test_load_scene_method_exists() -> void:
	var game_manager = GameManager

	assert_true(
		game_manager.has_method("load_scene"),
		"GameManager should have load_scene method"
	)


func test_scene_switch_emits_event() -> void:
	var game_manager = GameManager

	game_manager.set_scene_switching_enabled(false)

	watch_signals(EventBus)

	game_manager.load_scene(TEST_SCENE_PATH)

	await wait_for_signal(EventBus.scene_loading_finished, 1.0)

	assert_signal_emitted(
		EventBus,
		"scene_loading_finished",
		"GameManager should emit scene_loading_finished signal"
	)

	assert_eq(
		game_manager.get_current_scene(),
		TEST_SCENE_PATH,
		"Current scene path should match loaded scene"
	)

	game_manager.set_scene_switching_enabled(true)


func test_scene_loading_progress() -> void:
	var game_manager = GameManager

	game_manager.set_scene_switching_enabled(false)

	watch_signals(EventBus)

	game_manager.load_scene(TEST_SCENE_PATH, true)

	assert_signal_emitted(
		EventBus,
		"scene_loading_started",
		"GameManager should emit scene_loading_started signal"
	)

	game_manager.set_scene_switching_enabled(true)
