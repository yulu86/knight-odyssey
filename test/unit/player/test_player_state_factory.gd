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


func test_player_state_factory_has_register_state_method():
	# Test that PlayerStateFactory has register_state method
	var test_state = PlayerStateBase.new()
	_test_factory.register_state(PlayerState.State.IDLE, test_state)
	assert_true(_test_factory.states.has(PlayerState.State.IDLE), "register_state should add state to dictionary")
	test_state.queue_free()


func test_player_state_factory_has_get_state_method():
	# Test that PlayerStateFactory has get_state method
	# Should return null for non-existent state
	var result = _test_factory.get_state(PlayerState.State.IDLE)
	assert_null(result, "get_state should return null for non-existent state")


func test_player_state_factory_can_retrieve_registered_state():
	# Test that registered state can be retrieved
	var test_state = PlayerStateBase.new()
	_test_factory.register_state(PlayerState.State.IDLE, test_state)
	var retrieved = _test_factory.get_state(PlayerState.State.IDLE)
	assert_eq(retrieved, test_state, "Should retrieve registered state")
	test_state.queue_free()


func test_player_state_factory_returns_null_for_unknown_state():
	# Test that get_state returns null for unknown state type
	var result = _test_factory.get_state(999)
	assert_null(result, "get_state should return null for unknown state type")


func test_player_state_factory_can_store_multiple_states():
	# Test that factory can store multiple states
	var idle_state = PlayerStateBase.new()
	var move_state = PlayerStateBase.new()

	_test_factory.register_state(PlayerState.State.IDLE, idle_state)
	_test_factory.register_state(PlayerState.State.MOVE, move_state)

	assert_eq(_test_factory.get_state(PlayerState.State.IDLE), idle_state, "Should retrieve IDLE state")
	assert_eq(_test_factory.get_state(PlayerState.State.MOVE), move_state, "Should retrieve MOVE state")

	idle_state.queue_free()
	move_state.queue_free()


func test_player_state_factory_overwrites_existing_state():
	# Test that registering same state type twice overwrites
	var first_state = PlayerStateBase.new()
	var second_state = PlayerStateBase.new()

	_test_factory.register_state(PlayerState.State.IDLE, first_state)
	_test_factory.register_state(PlayerState.State.IDLE, second_state)

	var retrieved = _test_factory.get_state(PlayerState.State.IDLE)
	assert_eq(retrieved, second_state, "Second registration should overwrite first")

	first_state.queue_free()
	second_state.queue_free()
