extends GutTest

# Animation Binding Test
# Test that each state plays the correct animation

var _player: Player = null
var _animation_player: AnimationPlayer = null
var _state_machine: PlayerStateMachine = null
var _test_scene: Node2D = null
var _original_process_mode: int = Node.PROCESS_MODE_INHERIT


func before_each():
	# Load the integration test scene which has ground
	var test_scene_packed = load("res://test/integration/player/test_player.tscn")
	_test_scene = test_scene_packed.instantiate()

	# Add to scene tree first to initialize all nodes
	add_child_autofree(_test_scene)

	# Wait for scene to be ready
	await get_tree().process_frame
	await get_tree().physics_frame

	# Get player and its nodes from the test scene
	_player = _test_scene.get_node("Player")
	_animation_player = _player.get_node("AnimationPlayer")
	_state_machine = _player.get_node("PlayerStateMachine")

	# Disable player's automatic processing during test setup
	_original_process_mode = _player.process_mode
	_player.process_mode = Node.PROCESS_MODE_DISABLED

	# Reset velocity and position - place player above ground
	_player.velocity = Vector2.ZERO
	_player.position = Vector2(100, 110)

	# Wait for physics to settle without processing
	for i in range(5):
		await get_tree().physics_frame

	# Re-enable player processing
	_player.process_mode = _original_process_mode

	# Wait for physics to process
	await get_tree().physics_frame

	# Reset to IDLE state after physics initializes floor state
	_state_machine.change_state(PlayerState.State.IDLE)
	await get_tree().process_frame
	await get_tree().physics_frame

	# Get the player and its nodes from the test scene
	_player = _test_scene.get_node("Player")
	_animation_player = _player.get_node("AnimationPlayer")
	_state_machine = _player.get_node("PlayerStateMachine")

	# Disable player's automatic processing during test setup
	_original_process_mode = _player.process_mode
	_player.process_mode = Node.PROCESS_MODE_DISABLED

	# Reset velocity and position - place player above ground
	_player.velocity = Vector2.ZERO
	_player.position = Vector2(100, 110)

	# Wait for physics to settle
	for i in range(5):
		await get_tree().physics_frame

	# Manually ensure player is on floor before enabling processing
	var floor_position_y = 131.0
	_player.position.y = floor_position_y - 8.0

	# Re-enable player processing
	_player.process_mode = _original_process_mode

	# Wait for physics to process
	await get_tree().physics_frame

	# Reset to IDLE state after move_and_slide initializes floor state
	_state_machine.change_state(PlayerState.State.IDLE)
	await get_tree().process_frame


func after_each():
	_player = null
	_animation_player = null
	_state_machine = null
	_test_scene = null


func test_idle_state_plays_idle_animation():
	# Test that entering idle state plays idle animation
	_state_machine.change_state(PlayerState.State.IDLE)
	await get_tree().process_frame
	assert_eq(_animation_player.current_animation, "idle", "Idle state should play idle animation")


func test_walk_state_plays_walk_animation():
	# Test that entering walk state plays walk animation
	# First press movement key
	Input.action_press("move_right")
	_state_machine.change_state(PlayerState.State.MOVE)
	await get_tree().process_frame
	assert_eq(_animation_player.current_animation, "walk", "Walk state should play walk animation")
	Input.action_release("move_right")


func test_jump_state_plays_jump_animation():
	# Test that entering jump state plays jump animation
	_state_machine.change_state(PlayerState.State.JUMP)
	await get_tree().process_frame
	assert_eq(_animation_player.current_animation, "jump", "Jump state should play jump animation")


func test_fall_state_plays_fall_animation():
	# Test that entering fall state plays fall animation
	# Disable player processing to prevent immediate state transition
	var was_processing = _player.process_mode
	_player.process_mode = Node.PROCESS_MODE_DISABLED

	# Move player into the air
	_player.position.y = 50.0

	# Change to fall state and verify animation is set immediately
	_state_machine.change_state(PlayerState.State.FALL)
	await get_tree().process_frame

	# Check that fall animation is playing
	assert_eq(_animation_player.current_animation, "fall", "Fall state should play fall animation")

	# Restore processing mode
	_player.process_mode = was_processing


func test_idle_animation_exists():
	# Test that idle animation exists in AnimationPlayer
	assert_true(_animation_player.has_animation("idle"), "Idle animation should exist")


func test_walk_animation_exists():
	# Test that walk animation exists in AnimationPlayer
	assert_true(_animation_player.has_animation("walk"), "Walk animation should exist")


func test_jump_animation_exists():
	# Test that jump animation exists in AnimationPlayer
	assert_true(_animation_player.has_animation("jump"), "Jump animation should exist")


func test_fall_animation_exists():
	# Test that fall animation exists in AnimationPlayer
	assert_true(_animation_player.has_animation("fall"), "Fall animation should exist")


func test_animation_transitions_from_idle_to_walk():
	# Test that animation transitions correctly from idle to walk
	_state_machine.change_state(PlayerState.State.IDLE)
	await get_tree().process_frame
	assert_eq(_animation_player.current_animation, "idle", "Should start with idle animation")

	Input.action_press("move_right")
	_state_machine.change_state(PlayerState.State.MOVE)
	await get_tree().process_frame
	assert_eq(_animation_player.current_animation, "walk", "Should transition to walk animation")
	Input.action_release("move_right")


func test_animation_transitions_from_walk_to_jump():
	# Test that animation transitions correctly from walk to jump
	Input.action_press("move_right")
	_state_machine.change_state(PlayerState.State.MOVE)
	await get_tree().process_frame
	assert_eq(_animation_player.current_animation, "walk", "Should start with walk animation")

	Input.action_press("jump")
	_state_machine.change_state(PlayerState.State.JUMP)
	await get_tree().process_frame
	assert_eq(_animation_player.current_animation, "jump", "Should transition to jump animation")
	Input.action_release("move_right")
	Input.action_release("jump")
