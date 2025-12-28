extends GutTest

# IdleState Test
# Test the idle state for player character

var _idle_state: IdleState = null
var _mock_player: Player = null
var _mock_components: PlayerComponents = null
var _transitioned_state: int = -1
var _test_scene: Node2D = null
var _original_process_mode: int = Node.PROCESS_MODE_INHERIT


func before_each():
	# Create a simple test scene with player and ground
	_test_scene = Node2D.new()

	# Create a ground StaticBody2D with proper collision settings
	var ground = StaticBody2D.new()
	ground.position = Vector2(0, 100)
	ground.collision_layer = 1
	ground.collision_mask = 1
	var ground_collision = CollisionShape2D.new()
	var ground_shape = RectangleShape2D.new()
	ground_shape.size = Vector2(1000, 10)
	ground_collision.shape = ground_shape
	ground.add_child(ground_collision)
	_test_scene.add_child(ground)

	# Load player scene
	var player_packed = load("res://scenes/player/player.tscn")
	_mock_player = player_packed.instantiate()
	_mock_player.position = Vector2(100, 80)
	_test_scene.add_child(_mock_player)

	# Create components
	_mock_components = PlayerComponents.new(_mock_player)

	# Create idle state
	_idle_state = IdleState.new()
	_idle_state.setup(_mock_components)
	_idle_state.state_changed.connect(_on_state_changed)
	add_child_autofree(_idle_state)

	# Disable player's automatic processing during test setup
	_original_process_mode = _mock_player.process_mode
	_mock_player.process_mode = Node.PROCESS_MODE_DISABLED

	# Add to scene tree
	add_child_autofree(_test_scene)

	# Re-enable player processing
	_mock_player.process_mode = _original_process_mode

	# Wait for physics to be ready
	await get_tree().physics_frame

	# Let player fall to ground with gravity
	_mock_player.velocity = Vector2.ZERO
	for i in range(10):
		# Apply gravity manually
		_mock_player.velocity.y += _mock_components.config_manager.get_gravity() * 0.016
		_mock_player.move_and_slide()
		if _mock_player.is_on_floor():
			break
		await get_tree().physics_frame

	# Reset to IDLE state
	_mock_player.player_state_machine.change_state(PlayerState.State.IDLE)

	_transitioned_state = -1


func after_each():
	_idle_state = null
	_mock_player = null
	_mock_components = null
	_test_scene = null
	_transitioned_state = -1


func _on_state_changed(to_state: int) -> void:
	_transitioned_state = to_state


func test_idle_state_class_exists():
	# Test that IdleState class exists
	assert_not_null(_idle_state, "IdleState class should exist")


func test_idle_state_extends_player_state_base():
	# Test that IdleState extends PlayerStateBase
	assert_is(_idle_state, PlayerStateBase, "IdleState should extend PlayerStateBase")


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


func test_idle_state_transitions_to_jump_on_jump_input():
	# Test that idle state transitions to JUMP when jump input is received
	Input.action_press("jump")
	_idle_state.process(0.016)
	assert_eq(_transitioned_state, PlayerState.State.JUMP, "Should transition to JUMP on jump input")
	Input.action_release("jump")


func test_idle_state_jump_has_priority_over_movement():
	# Test that jump input has priority over movement input
	Input.action_press("move_right")
	Input.action_press("jump")
	_idle_state.process(0.016)
	assert_eq(_transitioned_state, PlayerState.State.JUMP, "Jump should have priority over movement")
	Input.action_release("move_right")
	Input.action_release("jump")
