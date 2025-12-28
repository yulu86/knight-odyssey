extends GutTest

# PlayerStateFactory Test
# Test the factory for creating and managing player states


var _test_factory: PlayerStateFactory = null


func before_each():
	_test_factory = PlayerStateFactory.new()


func after_each():
	if _test_factory != null:
		_test_factory.queue_free()
	_test_factory = null


func test_player_state_factory_class_exists():
	# Test that PlayerStateFactory class exists
	assert_not_null(_test_factory, "PlayerStateFactory class should exist")


func test_player_state_factory_is_node():
	# Test that PlayerStateFactory extends Node
	assert_is(_test_factory, Node, "PlayerStateFactory should extend Node")


func test_player_state_factory_has_states_dictionary():
	# Test that PlayerStateFactory has states dictionary
	assert_not_null(_test_factory.states, "PlayerStateFactory should have states property")
	assert_eq(typeof(_test_factory.states), TYPE_DICTIONARY, "states should be a Dictionary")


func test_player_state_factory_returns_idle_state():
	# Test that get_state returns IdleState for IDLE type
	var state = _test_factory.get_state(PlayerState.State.IDLE)
	assert_not_null(state, "get_state should return IdleState")
	assert_is(state, IdleState, "Should return IdleState instance")
	if state != null:
		state.queue_free()


func test_player_state_factory_returns_move_state():
	# Test that get_state returns WalkState for MOVE type
	var state = _test_factory.get_state(PlayerState.State.MOVE)
	assert_not_null(state, "get_state should return WalkState")
	assert_is(state, WalkState, "Should return WalkState instance")
	if state != null:
		state.queue_free()


func test_player_state_factory_returns_jump_state():
	# Test that get_state returns JumpState for JUMP type
	var state = _test_factory.get_state(PlayerState.State.JUMP)
	assert_not_null(state, "get_state should return JumpState")
	assert_is(state, JumpState, "Should return JumpState instance")
	if state != null:
		state.queue_free()


func test_player_state_factory_returns_fall_state():
	# Test that get_state returns FallState for FALL type
	var state = _test_factory.get_state(PlayerState.State.FALL)
	assert_not_null(state, "get_state should return FallState")
	assert_is(state, FallState, "Should return FallState instance")
	if state != null:
		state.queue_free()


func test_player_state_factory_returns_null_for_unknown_state():
	# Test that get_state returns null for unknown state type
	var result = _test_factory.get_state(999)
	assert_null(result, "get_state should return null for unknown state type")


func test_player_state_factory_returns_new_instance_each_call():
	# Test that get_state creates new instance each time
	var state1 = _test_factory.get_state(PlayerState.State.IDLE)
	var state2 = _test_factory.get_state(PlayerState.State.IDLE)
	assert_not_null(state1, "First call should return state")
	assert_not_null(state2, "Second call should return state")
	assert_ne(state1.get_instance_id(), state2.get_instance_id(), "Should return different instances")
	if state1 != null:
		state1.queue_free()
	if state2 != null:
		state2.queue_free()
