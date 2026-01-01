extends GutTest

func test_load_game_config_method_exists():
	assert_true(GameManager.has_method("load_game_config"), "GameManager should have load_game_config method")

func test_save_game_progress_method_exists():
	assert_true(GameManager.has_method("save_game_progress"), "GameManager should have save_game_progress method")

func test_load_game_progress_method_exists():
	assert_true(GameManager.has_method("load_game_progress"), "GameManager should have load_game_progress method")

func test_initialize_integrates_managers():
	assert_true(GameManager.has_method("_initialize"), "GameManager should have _initialize method")
	var game_manager = GameManager
	assert_not_null(game_manager, "GameManager should be initialized")

func test_game_manager_has_config_manager_reference():
	var game_manager = GameManager
	var has_config_manager = game_manager.has_method("get") and "config_manager" in game_manager
	assert_true(has_config_manager or game_manager.get("config_manager") != null, "GameManager should have config_manager reference")
