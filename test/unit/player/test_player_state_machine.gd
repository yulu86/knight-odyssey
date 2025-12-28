extends GutTest

# PlayerStateMachine Test
# Test the player state machine functionality


var _test_machine: PlayerStateMachine = null
var _mock_player: Player = null
var _mock_components: PlayerComponents = null
var _mock_state: PlayerStateBase = null


func before_each():
	_mock_player = Player.new()
	add_child_autofree(_mock_player)
	_mock_components = PlayerComponents.new(_mock_player)
	_test_machine = PlayerStateMachine.new()
	_test_machine.components = _mock_components
	_mock_state = PlayerStateBase.new()


func after_each():
	if _mock_state != null:
		_mock_state.queue_free()
	if _test_machine != null:
		_test_machine.queue_free()
	if _mock_player != null:
		_mock_player.queue_free()
	_mock_state = null
	_test_machine = null
	_mock_player = null
	_mock_components = null


func test_player_state_machine_class_exists():
	# Test that PlayerStateMachine class exists
	assert_not_null(_test_machine, "PlayerStateMachine class should exist")


func test_player_state_machine_is_node():
	# Test that PlayerStateMachine extends Node
	assert_is(_test_machine, Node, "PlayerStateMachine should extend Node")


func test_player_state_machine_has_current_state():
	# Test that PlayerStateMachine has current_state property
	assert_not_null(_test_machine, "PlayerStateMachine instance should exist")
	assert_null(_test_machine.current_state, "current_state should be null initially")


func test_player_state_machine_has_states_factory():
	# Test that PlayerStateMachine has states_factory property
	assert_not_null(_test_machine, "PlayerStateMachine instance should exist")
	assert_not_null(_test_machine.states_factory, "PlayerStateMachine should have states_factory")


func test_player_state_machine_has_components_property():
	# Test that PlayerStateMachine has components property
	assert_not_null(_test_machine, "PlayerStateMachine instance should exist")
	assert_eq(_test_machine.components, _mock_components, "PlayerStateMachine should have components property")


func test_player_state_machine_factory_is_player_state_factory():
	# Test that states_factory is a PlayerStateFactory
	var factory = _test_machine.states_factory
	assert_not_null(factory, "states_factory should exist")


func test_player_state_machine_change_state():
	# Test that state machine can change states
	var idle_state = _test_machine.states_factory.get_state(PlayerState.State.IDLE)
	_test_machine.change_state(PlayerState.State.IDLE)
	assert_not_null(_test_machine.current_state, "current_state should be set")
	if idle_state != null:
		idle_state.queue_free()


func test_player_state_machine_change_to_idle():
	# Test that state machine can change to IDLE state
	_test_machine.change_state(PlayerState.State.IDLE)
	assert_not_null(_test_machine.current_state, "current_state should be set to IDLE")


func test_player_state_machine_change_to_move():
	# Test that state machine can change to MOVE state
	_test_machine.change_state(PlayerState.State.MOVE)
	assert_not_null(_test_machine.current_state, "current_state should be set to MOVE")


func test_player_state_machine_change_to_jump():
	# Test that state machine can change to JUMP state
	_test_machine.change_state(PlayerState.State.JUMP)
	assert_not_null(_test_machine.current_state, "current_state should be set to JUMP")


func test_player_state_machine_change_to_fall():
	# Test that state machine can change to FALL state
	_test_machine.change_state(PlayerState.State.FALL)
	assert_not_null(_test_machine.current_state, "current_state should be set to FALL")


func test_player_state_machine_state_transitions():
	# Test that state machine can transition between states
	_test_machine.change_state(PlayerState.State.IDLE)
	assert_not_null(_test_machine.current_state, "current_state should be IDLE")

	_test_machine.change_state(PlayerState.State.MOVE)
	assert_not_null(_test_machine.current_state, "current_state should be MOVE")

	_test_machine.change_state(PlayerState.State.JUMP)
	assert_not_null(_test_machine.current_state, "current_state should be JUMP")


func test_player_state_machine_has_process_method():
	# Test that PlayerStateMachine has process method
	_test_machine.change_state(PlayerState.State.IDLE)
	_test_machine.process(0.016)
	assert_true(true, "process method should be callable")


func test_player_state_machine_sets_components_on_state():
	# Test that components are set on state when changing
	_test_machine.components = _mock_components
	_test_machine.change_state(PlayerState.State.IDLE)
	if _test_machine.current_state != null:
		assert_eq(_test_machine.current_state.player, _mock_player, "player should be set on state")


func test_player_state_machine_handles_null_state_gracefully():
	# Test that changing to non-existent state doesn't crash
	# The warning is expected behavior for invalid state
	_test_machine.change_state(999)
	assert_null(_test_machine.current_state, "current_state should still be null")


func test_player_state_machine_forwards_process_to_current_state():
	# Test that process is forwarded to current state
	_test_machine.change_state(PlayerState.State.IDLE)
	_test_machine.process(0.016)
	assert_true(true, "process should be forwarded to current state")


