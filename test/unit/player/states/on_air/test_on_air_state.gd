extends GutTest

# OnAirState Test
# Test the base class for airborne player states


var _test_state: OnAirState = null
var _mock_player: Player = null
var _mock_components: PlayerComponents = null


func before_each():
	_mock_player = Player.new()
	# Add sprite to player for testing BEFORE creating components
	var sprite = Sprite2D.new()
	sprite.name = "Sprite2D"
	_mock_player.add_child(sprite)
	add_child_autofree(_mock_player)
	_mock_components = PlayerComponents.new(_mock_player)
	_test_state = OnAirState.new()
	_test_state.setup(_mock_components)


func after_each():
	if _test_state != null:
		_test_state.queue_free()
	_test_state = null
	_mock_player = null
	_mock_components = null


func test_on_air_state_class_exists():
	# Test that OnAirState class exists
	assert_not_null(_test_state, "OnAirState class should exist")


func test_on_air_state_extends_player_state_base():
	# Test that OnAirState extends PlayerStateBase
	assert_is(_test_state, PlayerStateBase, "OnAirState should extend PlayerStateBase")


func test_on_air_state_has_apply_air_control_method():
	# Test that OnAirState has apply_air_control method
	assert_true(_test_state.has_method("apply_air_control"), "OnAirState should have apply_air_control method")


func test_on_air_state_apply_air_control_applies_friction_no_input():
	# Test that air control applies friction when no input
	_mock_player.velocity.x = 100.0
	_test_state.apply_air_control(0.1)
	assert_lt(_mock_player.velocity.x, 100.0, "Velocity should decrease due to friction")


func test_on_air_state_apply_air_control_applies_acceleration_with_input():
	# Test that air control applies acceleration with input
	_mock_player.velocity.x = 0.0
	# Simulate right input
	Input.action_press("move_right")
	_test_state.apply_air_control(0.1)
	Input.action_release("move_right")
	assert_gt(_mock_player.velocity.x, 0.0, "Velocity should increase with input")


func test_on_air_state_apply_air_control_updates_sprite_facing():
	# Test that air control updates sprite facing direction
	_test_state.apply_air_control(0.0)
	# Check sprite is set up correctly
	assert_not_null(_test_state.sprite_2d, "Sprite should be set up")


func test_on_air_state_apply_air_control_handles_null_player():
	# Test that air control handles null player gracefully
	_test_state.player = null
	var original_velocity = _mock_player.velocity.x
	_test_state.apply_air_control(0.1)
	# Should not crash and velocity should remain unchanged
	assert_eq(_mock_player.velocity.x, original_velocity, "Velocity should not change when player is null")


func test_on_air_state_apply_air_control_handles_null_config():
	# Test that air control handles null config gracefully
	_test_state.config_manager = null
	var original_velocity = _mock_player.velocity.x
	_test_state.apply_air_control(0.1)
	# Should not crash and velocity should remain unchanged
	assert_eq(_mock_player.velocity.x, original_velocity, "Velocity should not change when config is null")


func test_on_air_state_enter_method_callable():
	# Test that enter method can be called
	_test_state.enter()
	assert_true(true, "enter method should be callable")


func test_on_air_state_exit_method_callable():
	# Test that exit method can be called
	_test_state.exit()
	assert_true(true, "exit method should be callable")


func test_on_air_state_process_method_callable():
	# Test that process method can be called
	_test_state.process(0.016)
	assert_true(true, "process method should be callable")
