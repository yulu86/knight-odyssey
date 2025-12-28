extends GutTest

# Player Movement System Integration Tests
# Test complete movement cycles including state transitions

var _player_scene: PackedScene = null
var _player: Player = null
var _test_scene: Node2D = null


func before_each():
	# Create test scene
	_test_scene = Node2D.new()

	# Create ground
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

	# Load and instantiate player scene
	_player_scene = load("res://scenes/player/player.tscn")
	_player = _player_scene.instantiate()
	_player.position = Vector2(100, 80)
	_test_scene.add_child(_player)

	# Add to scene tree
	add_child_autofree(_test_scene)

	# Wait for physics to be ready
	await get_tree().physics_frame

	# Let player fall to ground completely
	for i in range(20):
		_player.move_and_slide()
		await get_tree().physics_frame
		if _player.is_on_floor():
			# Wait a few extra frames to ensure state settles
			for j in range(3):
				await get_tree().physics_frame
			break

	# Ensure starting in IDLE state
	_player.player_state_machine.change_state(PlayerState.State.IDLE)
	for i in range(2):
		await get_tree().physics_frame


func after_each():
	# Release any held input actions
	Input.action_release("move_left")
	Input.action_release("move_right")
	Input.action_release("jump")

	_player_scene = null
	_player = null
	_test_scene = null


# Test 1: Basic idle to walk transition
func test_integration_idle_to_walk():
	# Initial state should be IDLE
	assert_eq(_player.player_state_machine.current_state.state_type, PlayerState.State.IDLE,
		"Player should start in IDLE state")

	# Press right to trigger walking
	Input.action_press("move_right")
	for i in range(3):
		await get_tree().physics_frame

	# State should transition to MOVE
	assert_eq(_player.player_state_machine.current_state.state_type, PlayerState.State.MOVE,
		"Player should transition to MOVE when move_right is pressed")

	# Verify horizontal velocity is positive
	assert_true(_player.velocity.x > 0,
		"Player should have positive horizontal velocity")

	Input.action_release("move_right")


# Test 2: Walk to idle transition
func test_integration_walk_to_idle():
	# Start walking
	Input.action_press("move_right")
	for i in range(3):
		await get_tree().physics_frame
	assert_eq(_player.player_state_machine.current_state.state_type, PlayerState.State.MOVE,
		"Player should be in MOVE state")

	# Release input to stop walking
	Input.action_release("move_right")
	for i in range(10):
		await get_tree().physics_frame

	# State should return to IDLE
	assert_eq(_player.player_state_machine.current_state.state_type, PlayerState.State.IDLE,
		"Player should return to IDLE when movement input is released")

	# Verify horizontal velocity is near zero
	assert_true(abs(_player.velocity.x) < 1.0,
		"Player horizontal velocity should be near zero when idle")


# Test 3: Complete jump and fall cycle
func test_integration_jump_fall_cycle():
	# Start from IDLE
	assert_eq(_player.player_state_machine.current_state.state_type, PlayerState.State.IDLE,
		"Player should start in IDLE state")

	# Press jump
	Input.action_press("jump")
	for i in range(2):
		await get_tree().physics_frame

	# Should transition to JUMP
	assert_eq(_player.player_state_machine.current_state.state_type, PlayerState.State.JUMP,
		"Player should transition to JUMP when jump is pressed")

	# Verify negative vertical velocity (moving up)
	assert_true(_player.velocity.y < 0,
		"Player should have negative vertical velocity (moving up)")

	# Wait for jump to become fall (need ~21 frames for gravity to change -400 to positive)
	for i in range(25):
		await get_tree().physics_frame

	# Should transition to FALL
	assert_eq(_player.player_state_machine.current_state.state_type, PlayerState.State.FALL,
		"Player should transition to FALL when velocity becomes positive")

	# Verify positive vertical velocity (moving down)
	assert_true(_player.velocity.y > 0,
		"Player should have positive vertical velocity (falling)")

	# Release jump button before landing
	Input.action_release("jump")

	# Let player land
	for i in range(20):
		_player.move_and_slide()
		await get_tree().physics_frame
		if _player.is_on_floor():
			break

	# Wait a few frames for state to settle
	for i in range(5):
		await get_tree().physics_frame

	# Should transition to ground state (IDLE or MOVE)
	assert_true(_player.player_state_machine.current_state.state_type in [PlayerState.State.IDLE, PlayerState.State.MOVE],
		"Player should transition to ground state after landing")


# Test 4: Full movement cycle
func test_integration_full_movement_cycle():
	# IDLE -> MOVE
	Input.action_press("move_right")
	for i in range(3):
		await get_tree().physics_frame
	assert_eq(_player.player_state_machine.current_state.state_type, PlayerState.State.MOVE,
		"Player should be in MOVE state")

	# MOVE -> JUMP
	Input.action_press("jump")
	for i in range(2):
		await get_tree().physics_frame
	assert_eq(_player.player_state_machine.current_state.state_type, PlayerState.State.JUMP,
		"Player should transition to JUMP while moving")

	# JUMP -> FALL
	for i in range(25):
		await get_tree().physics_frame
	assert_eq(_player.player_state_machine.current_state.state_type, PlayerState.State.FALL,
		"Player should transition to FALL when falling")

	# Release jump button before landing
	Input.action_release("jump")

	# FALL -> MOVE (land while still holding move)
	for i in range(20):
		_player.move_and_slide()
		await get_tree().physics_frame
		if _player.is_on_floor():
			break

	# Wait a few frames for state to settle
	for i in range(5):
		await get_tree().physics_frame

	assert_eq(_player.player_state_machine.current_state.state_type, PlayerState.State.MOVE,
		"Player should transition to MOVE when landing with movement input")

	# MOVE -> IDLE
	Input.action_release("move_right")
	for i in range(30):
		await get_tree().physics_frame
	assert_eq(_player.player_state_machine.current_state.state_type, PlayerState.State.IDLE,
		"Player should transition to IDLE when movement stops")


# Test 5: Rapid input handling
func test_integration_rapid_input():
	# Rapidly alternate between left and right
	for i in range(10):
		Input.action_press("move_right")
		await get_tree().physics_frame
		Input.action_release("move_right")
		Input.action_press("move_left")
		await get_tree().physics_frame
		Input.action_release("move_left")

	# Wait for stabilization
	for i in range(5):
		await get_tree().physics_frame

	# State machine should remain stable
	var current_state = _player.player_state_machine.current_state.state_type
	assert_true(current_state in [PlayerState.State.IDLE, PlayerState.State.MOVE],
		"Player state should be valid after rapid input changes")


# Test 6: Air control
func test_integration_air_control():
	# Jump to get in the air
	Input.action_press("jump")
	for i in range(2):
		await get_tree().physics_frame
	assert_eq(_player.player_state_machine.current_state.state_type, PlayerState.State.JUMP,
		"Player should be in JUMP state")

	# Try moving right while in air
	Input.action_release("jump")
	Input.action_press("move_right")
	for i in range(5):
		await get_tree().physics_frame

	# Should have positive horizontal velocity
	assert_true(_player.velocity.x > 0,
		"Player should move right while in air")

	# Try moving left while in air - need to wait longer for friction to work
	Input.action_release("move_right")
	Input.action_press("move_left")
	for i in range(10):
		await get_tree().physics_frame

	# Should have negative horizontal velocity or at least reduced from right movement
	var velocity_x_after_left = _player.velocity.x
	assert_true(velocity_x_after_left < 0 or abs(velocity_x_after_left) < 10,
		"Player should move left while in air or at least decelerate from right movement (velocity: %s)" % velocity_x_after_left)

	# Let player land
	Input.action_release("move_left")
	for i in range(20):
		_player.move_and_slide()
		await get_tree().physics_frame
		if _player.is_on_floor():
			break


# Test 7: Landing precision
func test_integration_landing_precision():
	# Move player higher up
	_player.position = Vector2(100, -200)
	_player.velocity = Vector2.ZERO

	# Wait for player to fall and land
	var frames_waited = 0
	var landed = false
	for i in range(50):
		_player.move_and_slide()
		await get_tree().physics_frame
		frames_waited += 1
		if _player.is_on_floor():
			landed = true
			# Check state within 2 frames of landing
			for j in range(2):
				await get_tree().physics_frame
			break

	assert_true(landed, "Player should land after falling")
	assert_true(_player.player_state_machine.current_state.state_type in [PlayerState.State.IDLE, PlayerState.State.MOVE],
		"Player should transition to ground state immediately after landing")
