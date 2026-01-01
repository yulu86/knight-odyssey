extends GutTest

func test_game_manager_initialized_signal_exists():
	assert_true(EventBus.has_signal("game_manager_initialized"), "EventBus should have game_manager_initialized signal")

func test_config_loaded_signal_exists():
	assert_true(EventBus.has_signal("config_loaded"), "EventBus should have config_loaded signal")

func test_game_saved_signal_exists():
	assert_true(EventBus.has_signal("game_saved"), "EventBus should have game_saved signal")

func test_game_loaded_signal_exists():
	assert_true(EventBus.has_signal("game_loaded"), "EventBus should have game_loaded signal")

func test_save_data_loaded_signal_exists():
	assert_true(EventBus.has_signal("save_data_loaded"), "EventBus should have save_data_loaded signal")
