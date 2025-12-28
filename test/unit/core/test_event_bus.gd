extends GutTest

# Test EventBus singleton existence
func test_event_bus_is_singleton():
	# Verify EventBus can be accessed as singleton
	assert_not_null(EventBus, "EventBus should be accessible as singleton")

# Test score_updated signal exists and works
func test_score_updated_signal_exists():
	# Verify score_updated signal is defined and working
	watch_signals(EventBus)
	EventBus.score_updated.emit(100)
	assert_signal_emitted(EventBus, "score_updated", "score_updated signal should be emitted")

# Test lives_updated signal exists and works
func test_lives_updated_signal_exists():
	watch_signals(EventBus)
	EventBus.lives_updated.emit(3)
	assert_signal_emitted(EventBus, "lives_updated", "lives_updated signal should be emitted")

# Test game_paused signal exists and works
func test_game_paused_signal_exists():
	watch_signals(EventBus)
	EventBus.game_paused.emit(true)
	assert_signal_emitted(EventBus, "game_paused", "game_paused signal should be emitted")

# Test coin_collected signal exists and works
func test_coin_collected_signal_exists():
	watch_signals(EventBus)
	EventBus.coin_collected.emit(10)
	assert_signal_emitted(EventBus, "coin_collected", "coin_collected signal should be emitted")

# Test player_damaged signal exists and works
func test_player_damaged_signal_exists():
	watch_signals(EventBus)
	EventBus.player_damaged.emit(1)
	assert_signal_emitted(EventBus, "player_damaged", "player_damaged signal should be emitted")
