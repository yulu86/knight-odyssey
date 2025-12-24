extends GutTest

# IdleState Test
# Test the idle state for player character

var _idle_state: IdleState = null
var _mock_character: CharacterBody2D = null


func before_each():
	_idle_state = IdleState.new()
	_mock_character = CharacterBody2D.new()
	_idle_state.character = _mock_character
	add_child_autofree(_idle_state)
	add_child_autofree(_mock_character)


func after_each():
	_idle_state = null
	_mock_character = null


func test_idle_state_class_exists():
	# Test that IdleState class exists
	assert_not_null(_idle_state, "IdleState class should exist")


func test_idle_state_extends_player_state_base():
	# Test that IdleState extends PlayerStateBase
	assert_is(_idle_state, PlayerStateBase, "IdleState should extend PlayerStateBase")


func test_idle_state_state_type_is_idle():
	# Test that IdleState has state_type set to IDLE
	assert_eq(_idle_state.state_type, PlayerState.State.IDLE, "IdleState should have state_type IDLE")


func test_idle_state_resets_velocity_on_enter():
	# Test that idle state resets velocity when entering
	_mock_character.velocity = Vector2(100, 50)
	_idle_state.enter()
	assert_eq(_mock_character.velocity, Vector2.ZERO, "Velocity should be reset to ZERO on enter")


func test_idle_state_has_no_transition_when_no_input():
	# Test that idle state produces no transition when no movement input
	_idle_state.process(0.016)
	assert_eq(_idle_state.transition_state, -1, "transition_state should be -1 when no input")


func test_idle_state_transitions_to_move_on_right_input():
	# Test that idle state transitions to MOVE when right movement input is received
	Input.action_press("move_right")
	_idle_state.process(0.016)
	assert_eq(_idle_state.transition_state, PlayerState.State.MOVE, "Should transition to MOVE on move_right input")
	Input.action_release("move_right")


func test_idle_state_transitions_to_move_on_left_input():
	# Test that idle state transitions to MOVE when left movement input is received
	Input.action_press("move_left")
	_idle_state.process(0.016)
	assert_eq(_idle_state.transition_state, PlayerState.State.MOVE, "Should transition to MOVE on move_left input")
	Input.action_release("move_left")


func test_idle_state_enter_method_callable():
	# Test that IdleState enter method can be called
	_idle_state.enter()
	assert_true(true, "IdleState enter should be callable")


func test_idle_state_exit_method_callable():
	# Test that IdleState exit method can be called
	_idle_state.exit()
	assert_true(true, "IdleState exit should be callable")


func test_idle_state_process_method_callable():
	# Test that IdleState process method can be called
	_idle_state.process(0.016)
	assert_true(true, "IdleState process should be callable")
