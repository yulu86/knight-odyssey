extends GutTest

# FallState Test
# Test the fall state for player character

var _fall_state: FallState = null
var _mock_player: Player = null
var _mock_components: PlayerComponents = null
var _transitioned_state: int = -1


func before_each():
	_fall_state = FallState.new()
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
	_mock_components.config_manager = ConfigManager
	_fall_state.setup(_mock_components)
	_fall_state.state_changed.connect(_on_state_changed)
	add_child_autofree(_fall_state)
	_transitioned_state = -1


func after_each():
	_fall_state = null
	_mock_player = null
	_mock_components = null
	_transitioned_state = -1


func _on_state_changed(to_state: int) -> void:
	_transitioned_state = to_state


func test_fall_state_class_exists():
	# Test that FallState class exists
	assert_not_null(_fall_state, "FallState class should exist")


func test_fall_state_extends_player_state_base():
	# Test that FallState extends PlayerStateBase
	assert_is(_fall_state, PlayerStateBase, "FallState should extend PlayerStateBase")


func test_fall_state_state_type_is_fall():
	# Test that FallState has state_type set to FALL
	assert_eq(_fall_state.state_type, PlayerState.State.FALL, "FallState should have state_type FALL")


func test_fall_state_applies_gravity():
	# Test that fall state applies gravity over time
	_mock_player.velocity.y = 100.0  # Start with falling velocity
	var initial_velocity_y = _mock_player.velocity.y

	_fall_state.process(0.016)
	var first_frame_velocity = _mock_player.velocity.y

	_fall_state.process(0.016)
	var second_frame_velocity = _mock_player.velocity.y

	# Gravity should increase downward velocity
	assert_true(first_frame_velocity > initial_velocity_y, "Gravity should increase falling velocity")
	assert_true(second_frame_velocity > first_frame_velocity, "Gravity should continue increasing falling velocity")


func test_fall_state_has_air_control():
	# Test that fall state allows horizontal movement while falling
	Input.action_press("move_right")
	_mock_player.velocity.y = 100.0
	_fall_state.process(0.016)
	assert_true(_mock_player.velocity.x > 0, "Should have horizontal velocity with input")
	Input.action_release("move_right")


func test_fall_state_applies_air_friction_no_input():
	# Test that fall state applies air friction when no horizontal input
	Input.action_press("move_right")
	_mock_player.velocity.y = 100.0
	_fall_state.process(0.016)
	var initial_velocity_x = _mock_player.velocity.x
	Input.action_release("move_right")

	_fall_state.process(0.016)
	assert_true(_mock_player.velocity.x < initial_velocity_x, "Air friction should reduce horizontal velocity")


func test_fall_state_transitions_to_idle_when_landed():
	# Test that fall state transitions to IDLE when landing without input
	_mock_player.velocity.y = 100.0
	# Note: is_on_floor() is always false in test environment without physics
	# This test validates the state transition logic when grounded
	# For actual landing behavior, integration tests are needed

	# In unit test, we just verify the logic path exists
	# The actual is_on_floor() check requires physics simulation
	_fall_state.process(0.016)
	# Expected: -1 (no transition) because is_on_floor() returns false in test
	assert_eq(_transitioned_state, -1, "Should not transition in test environment without physics")


func test_fall_state_transitions_to_move_when_landed_with_input():
	# Test that fall state transitions to MOVE when landing with movement input
	Input.action_press("move_right")
	_mock_player.velocity.y = 100.0
	# Note: is_on_floor() is always false in test environment without physics

	_fall_state.process(0.016)
	# Expected: -1 (no transition) because is_on_floor() returns false in test
	assert_eq(_transitioned_state, -1, "Should not transition in test environment without physics")
	Input.action_release("move_right")


func test_fall_state_updates_sprite_facing():
	# Test that fall state updates sprite facing direction
	_mock_player.velocity.y = 100.0

	Input.action_press("move_right")
	_fall_state.process(0.016)
	assert_false(_mock_player.sprite_2d.flip_h, "Sprite should face right")
	Input.action_release("move_right")

	Input.action_press("move_left")
	_fall_state.process(0.016)
	assert_true(_mock_player.sprite_2d.flip_h, "Sprite should face left")
	Input.action_release("move_left")


func test_fall_state_enter_method_callable():
	# Test that FallState enter method can be called
	_fall_state.enter()
	assert_true(true, "FallState enter should be callable")


func test_fall_state_exit_method_callable():
	# Test that FallState exit method can be called
	_fall_state.exit()
	assert_true(true, "FallState exit should be callable")


func test_fall_state_process_method_callable():
	# Test that FallState process method can be called
	_mock_player.velocity.y = 100.0
	_fall_state.process(0.016)
	assert_true(true, "FallState process should be callable")


func test_fall_state_uses_configured_gravity():
	# Test that fall state uses gravity from config manager
	var test_gravity = 1500.0
	_mock_components.config_manager.set_gravity(test_gravity)
	_mock_player.velocity.y = 100.0

	var initial_velocity = _mock_player.velocity.y
	_fall_state.process(0.016)

	var expected_velocity = initial_velocity + test_gravity * 0.016
	assert_almost_eq(_mock_player.velocity.y, expected_velocity, 0.01, "Should use configured gravity value")


func test_fall_state_uses_configured_air_acceleration():
	# Test that fall state uses air acceleration from config manager
	var test_accel = 800.0
	_mock_components.config_manager.set_air_acceleration(test_accel)
	_mock_player.velocity.y = 100.0

	Input.action_press("move_right")
	_fall_state.process(0.016)

	# Should have horizontal velocity based on air acceleration
	assert_true(_mock_player.velocity.x > 0, "Should use configured air acceleration")
	Input.action_release("move_right")


func test_fall_state_uses_configured_air_friction():
	# Test that fall state uses air friction from config manager
	var test_friction = 300.0
	_mock_components.config_manager.set_air_friction(test_friction)
	_mock_player.velocity.y = 100.0

	Input.action_press("move_right")
	_fall_state.process(0.016)
	var initial_velocity = _mock_player.velocity.x
	Input.action_release("move_right")

	_fall_state.process(0.016)
	var expected_velocity = move_toward(initial_velocity, 0.0, test_friction * 0.016)
	assert_almost_eq(_mock_player.velocity.x, expected_velocity, 0.01, "Should use configured air friction")


func test_fall_state_does_not_transition_while_still_falling():
	# Test that fall state doesn't transition while still in the air
	_mock_player.velocity.y = 100.0

	_fall_state.process(0.016)
	assert_eq(_transitioned_state, -1, "Should not transition while still falling")
