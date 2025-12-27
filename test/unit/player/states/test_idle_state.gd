extends GutTest

# IdleState Test
# Test the idle state for player character

var _idle_state: IdleState = null
var _mock_player: Player = null
var _mock_components: PlayerComponents = null
var _transitioned_state: int = -1


func before_each():
	_idle_state = IdleState.new()
	_mock_player = Player.new()

	# Add required child nodes BEFORE adding player to scene tree
	var sprite = Sprite2D.new()
	sprite.name = "Sprite2D"
	_mock_player.add_child(sprite)

	var anim_player = AnimationPlayer.new()
	anim_player.name = "AnimationPlayer"
	_mock_player.add_child(anim_player)

	var state_machine = PlayerStateMachine.new()
	state_machine.name = "PlayerStateMachine"
	_mock_player.add_child(state_machine)

	# Now add to scene tree so @onready variables work
	add_child_autofree(_mock_player)

	# Create components AFTER player is in scene tree (so @onready vars are set)
	_mock_components = PlayerComponents.new(_mock_player)
	_idle_state.setup(_mock_components)
	_idle_state.state_changed.connect(_on_state_changed)
	add_child_autofree(_idle_state)
	_transitioned_state = -1


func after_each():
	_idle_state = null
	_mock_player = null
	_mock_components = null
	_transitioned_state = -1


func _on_state_changed(to_state: int) -> void:
	_transitioned_state = to_state


func test_idle_state_class_exists():
	# Test that IdleState class exists
	assert_not_null(_idle_state, "IdleState class should exist")


func test_idle_state_extends_player_state_base():
	# Test that IdleState extends PlayerStateBase
	assert_is(_idle_state, PlayerStateBase, "IdleState should extend PlayerStateBase")


func test_idle_state_resets_velocity_on_enter():
	# Test that idle state resets velocity when entering
	_mock_player.velocity = Vector2(100, 50)
	_idle_state.enter()
	assert_eq(_mock_player.velocity, Vector2.ZERO, "Velocity should be reset to ZERO on enter")


func test_idle_state_has_no_transition_when_no_input():
	# Test that idle state produces no transition when no movement input
	_idle_state.process(0.016)
	assert_eq(_transitioned_state, -1, "Should not transition when no input")


func test_idle_state_transitions_to_move_on_right_input():
	# Test that idle state transitions to MOVE when right movement input is received
	Input.action_press("move_right")
	_idle_state.process(0.016)
	assert_eq(_transitioned_state, PlayerState.State.MOVE, "Should transition to MOVE on move_right input")
	Input.action_release("move_right")


func test_idle_state_transitions_to_move_on_left_input():
	# Test that idle state transitions to MOVE when left movement input is received
	Input.action_press("move_left")
	_idle_state.process(0.016)
	assert_eq(_transitioned_state, PlayerState.State.MOVE, "Should transition to MOVE on move_left input")
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
