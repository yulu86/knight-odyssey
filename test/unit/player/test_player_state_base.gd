extends GutTest

# PlayerStateBase Test
# Test the base class for all player states

var _test_state: PlayerStateBase = null


func before_each():
	_test_state = PlayerStateBase.new()


func after_each():
	if _test_state != null:
		_test_state.queue_free()
	_test_state = null


func test_player_state_base_class_exists():
	# Test that PlayerStateBase class exists
	assert_not_null(_test_state, "PlayerStateBase class should exist")


func test_player_state_base_is_node():
	# Test that PlayerStateBase extends Node
	assert_is(_test_state, Node, "PlayerStateBase should extend Node")


func test_player_state_base_has_setup_method():
	# Test that PlayerStateBase has setup method
	assert_not_null(_test_state, "PlayerStateBase instance should exist")
	# setup should be callable with PlayerComponents parameter
	var dummy_player = Player.new()
	var dummy_components = PlayerComponents.new(dummy_player)
	_test_state.setup(dummy_components)
	assert_eq(_test_state.player, dummy_player, "setup should set player reference")
	dummy_player.queue_free()


func test_player_state_base_has_enter_method():
	# Test that PlayerStateBase has enter method
	assert_not_null(_test_state, "PlayerStateBase instance should exist")
	# enter should be callable without errors
	_test_state.enter()


func test_player_state_base_has_exit_method():
	# Test that PlayerStateBase has exit method
	assert_not_null(_test_state, "PlayerStateBase instance should exist")
	# exit should be callable without errors
	_test_state.exit()


func test_player_state_base_has_process_method():
	# Test that PlayerStateBase has process method
	assert_not_null(_test_state, "PlayerStateBase instance should exist")
	# process should be callable with delta parameter
	_test_state.process(0.016)
