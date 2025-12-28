extends GutTest

# Animation Binding Test
# Test that each state plays the correct animation

var _player: Player = null
var _animation_player: AnimationPlayer = null
var _state_machine: PlayerStateMachine = null


func before_each():
	# Create player scene
	var player_scene = load("res://scenes/player/player.tscn")
	_player = player_scene.instantiate()

	# Get references to nodes
	_animation_player = _player.get_node("AnimationPlayer")
	_state_machine = _player.get_node("PlayerStateMachine")

	# Add to scene tree so @onready variables work
	add_child_autofree(_player)


func after_each():
	_player = null
	_animation_player = null
	_state_machine = null


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
	_state_machine.change_state(PlayerState.State.FALL)
	await get_tree().process_frame
	assert_eq(_animation_player.current_animation, "fall", "Fall state should play fall animation")


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
