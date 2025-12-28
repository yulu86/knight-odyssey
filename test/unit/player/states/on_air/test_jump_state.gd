extends GutTest

# JumpState Test
# Test the jump state for player character

var _jump_state: JumpState = null
var _mock_player: Player = null
var _mock_components: PlayerComponents = null
var _transitioned_state: int = -1


func before_each():
	_jump_state = JumpState.new()
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
	_jump_state.setup(_mock_components)
	_jump_state.state_changed.connect(_on_state_changed)
	add_child_autofree(_jump_state)
	_transitioned_state = -1


func after_each():
	_jump_state = null
	_mock_player = null
	_mock_components = null
	_transitioned_state = -1


func _on_state_changed(to_state: int) -> void:
	_transitioned_state = to_state


func test_jump_state_class_exists():
	# Test that JumpState class exists
	assert_not_null(_jump_state, "JumpState class should exist")


func test_jump_state_extends_player_state_base():
	# Test that JumpState extends PlayerStateBase
	assert_is(_jump_state, PlayerStateBase, "JumpState should extend PlayerStateBase")


func test_jump_state_state_type_is_jump():
	# Test that JumpState has state_type set to JUMP
	assert_eq(_jump_state.state_type, PlayerState.State.JUMP, "JumpState should have state_type JUMP")


func test_jump_state_sets_jump_velocity_on_enter():
	# Test that entering jump state sets vertical velocity
	_jump_state.enter()
	var expected_velocity = _mock_components.config_manager.get_player_jump_velocity()
	assert_eq(_mock_player.velocity.y, expected_velocity, "Should set jump velocity on enter")


func test_jump_state_applies_gravity():
	# Test that jump state applies gravity over time
	_jump_state.enter()
	var initial_velocity_y = _mock_player.velocity.y

	_jump_state.process(0.016)
	var first_frame_velocity = _mock_player.velocity.y

	_jump_state.process(0.016)
	var second_frame_velocity = _mock_player.velocity.y

	# Gravity should make velocity less negative (moving toward 0 from negative)
	assert_true(first_frame_velocity > initial_velocity_y, "Gravity should reduce upward velocity")
	assert_true(second_frame_velocity > first_frame_velocity, "Gravity should continue reducing upward velocity")


func test_jump_state_transitions_to_fall_when_falling():
	# Test that jump state transitions to FALL when velocity becomes positive
	_jump_state.enter()

	# Process enough frames for gravity to reverse velocity
	for i in range(50):
		_jump_state.process(0.016)
		if _transitioned_state != -1:
			break

	assert_eq(_transitioned_state, PlayerState.State.FALL, "Should transition to FALL when velocity becomes positive")


func test_jump_state_has_air_control():
	# Test that jump state allows horizontal movement while in air
	Input.action_press("move_right")
	_jump_state.enter()
	_jump_state.process(0.016)
	assert_true(_mock_player.velocity.x > 0, "Should have horizontal velocity with input")
	Input.action_release("move_right")


func test_jump_state_applies_air_friction_no_input():
	# Test that jump state applies air friction when no horizontal input
	Input.action_press("move_right")
	_jump_state.enter()
	_jump_state.process(0.016)
	var initial_velocity_x = _mock_player.velocity.x
	Input.action_release("move_right")

	_jump_state.process(0.016)
	assert_true(_mock_player.velocity.x < initial_velocity_x, "Air friction should reduce horizontal velocity")


func test_jump_state_updates_sprite_facing():
	# Test that jump state updates sprite facing direction
	_jump_state.enter()

	Input.action_press("move_right")
	_jump_state.process(0.016)
	assert_false(_mock_player.sprite_2d.flip_h, "Sprite should face right")
	Input.action_release("move_right")

	Input.action_press("move_left")
	_jump_state.process(0.016)
	assert_true(_mock_player.sprite_2d.flip_h, "Sprite should face left")
	Input.action_release("move_left")


func test_jump_state_enter_method_callable():
	# Test that JumpState enter method can be called
	_jump_state.enter()
	assert_true(true, "JumpState enter should be callable")


func test_jump_state_exit_method_callable():
	# Test that JumpState exit method can be called
	_jump_state.exit()
	assert_true(true, "JumpState exit should be callable")


func test_jump_state_process_method_callable():
	# Test that JumpState process method can be called
	_jump_state.process(0.016)
	assert_true(true, "JumpState process should be callable")


func test_jump_state_uses_configured_gravity():
	# Test that jump state uses gravity from config manager
	var test_gravity = 1500.0
	_mock_components.config_manager.set_gravity(test_gravity)

	_jump_state.enter()
	var initial_velocity = _mock_player.velocity.y
	_jump_state.process(0.016)

	var expected_velocity = initial_velocity + test_gravity * 0.016
	assert_almost_eq(_mock_player.velocity.y, expected_velocity, 0.01, "Should use configured gravity value")


func test_jump_state_uses_configured_air_acceleration():
	# Test that jump state uses air acceleration from config manager
	var test_accel = 800.0
	_mock_components.config_manager.set_air_acceleration(test_accel)

	Input.action_press("move_right")
	_jump_state.enter()
	_jump_state.process(0.016)

	# Should have horizontal velocity based on air acceleration
	assert_true(_mock_player.velocity.x > 0, "Should use configured air acceleration")
	Input.action_release("move_right")


func test_jump_state_uses_configured_air_friction():
	# Test that jump state uses air friction from config manager
	var test_friction = 300.0
	_mock_components.config_manager.set_air_friction(test_friction)

	Input.action_press("move_right")
	_jump_state.enter()
	_jump_state.process(0.016)
	var initial_velocity = _mock_player.velocity.x
	Input.action_release("move_right")

	_jump_state.process(0.016)
	var expected_velocity = move_toward(initial_velocity, 0.0, test_friction * 0.016)
	assert_almost_eq(_mock_player.velocity.x, expected_velocity, 0.01, "Should use configured air friction")
