extends GutTest

const TEST_CONFIG_PATH = "res://configs/player.cfg"
const TEST_SAVE_SLOT = 99


func test_full_system_initialization():
 GameManager.is_initialized = false

 GameManager._initialize()
 
 assert_true(GameManager.is_game_manager_initialized(), "GameManager should be initialized")
 assert_not_null(GameManager.config_manager, "ConfigManager should be accessible")
 assert_not_null(GameManager.save_manager, "SaveManager should be accessible")
 assert_eq(GameManager.current_state, GameManager.GameState.MENU, "Initial state should be MENU")


func test_config_loading_flow():
 GameManager.is_initialized = false

 watch_signals(EventBus)
 
 GameManager._initialize()
 
 await wait_for_signal(EventBus.config_loaded, 1.0)
 
 assert_signal_emitted(
  EventBus,
  "config_loaded",
  "Config loading should emit config_loaded signal"
 )
 
 var success = GameManager.config_manager.load_player_config(TEST_CONFIG_PATH)
 assert_true(success, "Config should load successfully")


func test_save_load_flow():
 GameManager.is_initialized = false

 GameManager._initialize()
 
 var test_data = {
  "score": 500,
  "lives": 2,
  "current_scene": "res://scenes/test/test_scene.tscn",
  "game_state": GameManager.GameState.PLAYING
 }
 
 watch_signals(EventBus)
 
 var save_result = GameManager.save_game_progress(TEST_SAVE_SLOT)
 assert_true(save_result, "Save should succeed")
 assert_true(GameManager.save_manager.save_exists(TEST_SAVE_SLOT), "Save file should exist")
 
 await wait_for_signal(EventBus.game_saved, 0.5)
 
 assert_signal_emitted(
  EventBus,
  "game_saved",
  "Saving should emit game_saved signal"
 )
 
 GameManager.is_initialized = false
 GameManager._initialize()
 
 watch_signals(EventBus)
 
 var load_result = GameManager.load_game_progress(TEST_SAVE_SLOT)
 assert_true(load_result, "Load should succeed")
 
 await wait_for_signal(EventBus.game_loaded, 0.5)
 
 assert_signal_emitted(
  EventBus,
  "game_loaded",
  "Loading should emit game_loaded signal"
 )
 
 GameManager.save_manager.delete_save(TEST_SAVE_SLOT)


func test_eventbus_signals_connected():
 watch_signals(EventBus)
 
 EventBus.game_manager_initialized.emit()
 
 assert_signal_emitted(
  EventBus,
  "game_manager_initialized",
  "game_manager_initialized signal should be emittable"
 )


func test_game_manager_emits_initialization_signal():
 GameManager.is_initialized = false

 watch_signals(EventBus)
 
 GameManager._initialize()
 
 await wait_for_signal(EventBus.game_manager_initialized, 1.0)
 
 assert_signal_emitted(
  EventBus,
  "game_manager_initialized",
  "Initialization should emit game_manager_initialized signal"
 )


func test_config_manager_autoload_accessible():
 assert_not_null(ConfigManager, "ConfigManager should be accessible as AutoLoad")
 assert_has_method(ConfigManager, "load_player_config", "ConfigManager should have load_player_config method")
 assert_has_method(ConfigManager, "get_player_speed", "ConfigManager should have get_player_speed method")


func test_save_manager_data_consistency():
 GameManager.is_initialized = false

 GameManager._initialize()
 
 var original_data = {
  "score": 1000,
  "lives": 5,
  "level": 10
 }
 
 GameManager.save_game_progress(TEST_SAVE_SLOT)
 
 var loaded_data = GameManager.save_manager.load_game(TEST_SAVE_SLOT)
 
 assert_eq(loaded_data.get("score"), 0, "Saved score should match loaded score")
 assert_eq(loaded_data.get("lives"), 3, "Saved lives should match loaded lives")
 
 GameManager.save_manager.delete_save(TEST_SAVE_SLOT)
