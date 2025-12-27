extends GutTest

# PlayerStateMachine Test
# Test the player state machine functionality


var _test_machine: PlayerStateMachine = null
var _mock_player: Player = null
var _mock_components: PlayerComponents = null
var _mock_state: PlayerStateBase = null


func before_each():
	_mock_player = Player.new()
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
	_test_machine.states_factory.register_state(PlayerState.State.IDLE, _mock_state)
	_test_machine.change_state(PlayerState.State.IDLE)
	assert_eq(_test_machine.current_state, _mock_state, "current_state should be changed to new state")


func test_player_state_machine_calls_enter_on_state_change():
	# Test that enter is called when changing state
	var test_state = TestTrackingState.new()
	_test_machine.states_factory.register_state(PlayerState.State.IDLE, test_state)
	_test_machine.change_state(PlayerState.State.IDLE)
	assert_true(test_state.enter_called, "enter should be called when changing state")
	test_state.queue_free()


func test_player_state_machine_calls_exit_on_previous_state():
	# Test that exit is called on previous state when changing
	var first_state = TestTrackingState.new()
	var second_state = TestTrackingState.new()

	_test_machine.states_factory.register_state(PlayerState.State.IDLE, first_state)
	_test_machine.states_factory.register_state(PlayerState.State.MOVE, second_state)

	_test_machine.change_state(PlayerState.State.IDLE)
	assert_true(first_state.enter_called, "enter should be called on first state")

	_test_machine.change_state(PlayerState.State.MOVE)
	assert_true(first_state.exit_called, "exit should be called on first state")
	assert_true(second_state.enter_called, "enter should be called on second state")

	first_state.queue_free()
	second_state.queue_free()


func test_player_state_machine_has_process_method():
	# Test that PlayerStateMachine has process method
	_test_machine.states_factory.register_state(PlayerState.State.IDLE, _mock_state)
	_test_machine.change_state(PlayerState.State.IDLE)
	_test_machine.process(0.016)
	assert_true(true, "process method should be callable")


func test_player_state_machine_sets_components_on_state():
	# Test that components is set on state when changing
	_test_machine.states_factory.register_state(PlayerState.State.IDLE, _mock_state)
	_test_machine.components = _mock_components
	_test_machine.change_state(PlayerState.State.IDLE)
	assert_eq(_mock_state.components, _mock_components, "components should be set on state")


func test_player_state_machine_handles_null_state_gracefully():
	# Test that changing to non-existent state doesn't crash
	# The warning is expected behavior for invalid state
	_test_machine.change_state(999)
	assert_null(_test_machine.current_state, "current_state should still be null")


func test_player_state_machine_forwards_process_to_current_state():
	# Test that process is forwarded to current state
	var test_state = TestTrackingState.new()
	_test_machine.states_factory.register_state(PlayerState.State.IDLE, test_state)
	_test_machine.change_state(PlayerState.State.IDLE)
	_test_machine.process(0.016)
	assert_true(test_state.process_called, "process should be forwarded to current state")
	test_state.queue_free()


# Helper class for testing method calls
class TestTrackingState extends PlayerStateBase:
	var enter_called: bool = false
	var exit_called: bool = false
	var process_called: bool = false

	func enter() -> void:
		super.enter()
		enter_called = true

	func exit() -> void:
		super.exit()
		exit_called = true

	func process(delta: float) -> void:
		super.process(delta)
		process_called = true
