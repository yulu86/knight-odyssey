extends GutTest

const TEST_SCENE_PATH = "res://scenes/test/test_scene.tscn"

func test_game_manager_is_autoload_singleton():
 GameManager.is_initialized = false

 GameManager._initialize()
 
 assert_true(GameManager != null, "GameManager should be accessible globally")


func test_game_manager_auto_initialized():
 GameManager.is_initialized = false

 GameManager._initialize()
 
 assert_true(GameManager.is_game_manager_initialized(), "GameManager should be initialized after calling _initialize")


func test_game_manager_singleton_unique():
 var first_ref = GameManager
 var second_ref = GameManager
 
 assert_same(first_ref, second_ref, "All references to GameManager should point to the same instance")


func test_game_manager_has_correct_initial_state():
 GameManager.is_initialized = false

 GameManager._initialize()
 
 assert_eq(GameManager.current_state, GameManager.GameState.MENU, "Initial game state should be MENU")
 assert_true(GameManager.is_game_manager_initialized(), "GameManager should be initialized")


func test_game_manager_config_manager_initialized():
 GameManager.is_initialized = false

 GameManager._initialize()
 
 assert_not_null(GameManager.config_manager, "ConfigManager should be initialized")


func test_game_manager_save_manager_initialized():
 GameManager.is_initialized = false

 GameManager._initialize()
 
 assert_not_null(GameManager.save_manager, "SaveManager should be initialized")


func test_initialize_idempotent():
 GameManager.is_initialized = false

 GameManager._initialize()
 var first_init = GameManager.is_game_manager_initialized()
 
 GameManager._initialize()
 var second_init = GameManager.is_game_manager_initialized()
 
 assert_true(first_init, "First initialization should succeed")
 assert_true(second_init, "Second initialization should not change state")
