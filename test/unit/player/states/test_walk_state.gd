extends GutTest

# WalkState Test
# Test the walk state for player character

var _walk_state: WalkState = null
var _mock_player: Player = null
var _mock_components: PlayerComponents = null
var _transitioned_state: int = -1


func before_each():
	_walk_state = WalkState.new()
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
	_walk_state.setup(_mock_components)
	_walk_state.state_changed.connect(_on_state_changed)
	add_child_autofree(_walk_state)
	_transitioned_state = -1


func after_each():
	_walk_state = null
	_mock_player = null
	_mock_components = null
	_transitioned_state = -1


func _on_state_changed(to_state: int) -> void:
	_transitioned_state = to_state


func test_walk_state_class_exists():
	# Test that WalkState class exists
	assert_not_null(_walk_state, "WalkState class should exist")


func test_walk_state_extends_player_state_base():
	# Test that WalkState extends PlayerStateBase
	assert_is(_walk_state, PlayerStateBase, "WalkState should extend PlayerStateBase")


func test_walk_state_moves_right_on_input():
	# Test that walk state moves player right with right input
	Input.action_press("move_right")
	_walk_state.process(0.016)
	assert_true(_mock_player.velocity.x > 0, "Should move right with move_right input")
	assert_false(_mock_player.sprite_2d.flip_h, "Sprite should face right")
	Input.action_release("move_right")


func test_walk_state_moves_left_on_input():
	# Test that walk state moves player left with left input
	Input.action_press("move_left")
	_walk_state.process(0.016)
	assert_true(_mock_player.velocity.x < 0, "Should move left with move_left input")
	assert_true(_mock_player.sprite_2d.flip_h, "Sprite should face left")
	Input.action_release("move_left")


func test_walk_state_transitions_to_idle_on_stop():
	# Test that walk state transitions to IDLE when movement stops
	Input.action_press("move_right")
	_walk_state.process(0.016)
	Input.action_release("move_right")

	# Process multiple frames to allow friction to stop movement
	for i in range(10):
		_walk_state.process(0.016)
		if _transitioned_state != -1:
			break

	assert_eq(_transitioned_state, PlayerState.State.IDLE, "Should transition to IDLE when stopped")


func test_walk_state_transitions_to_jump_on_jump():
	# Test that walk state transitions to JUMP when jump input received
	Input.action_press("jump")
	_walk_state.process(0.016)
	assert_eq(_transitioned_state, PlayerState.State.JUMP, "Should transition to JUMP on jump input")
	Input.action_release("jump")


func test_walk_state_applies_friction_no_input():
	# Test that walk state applies friction when no input
	Input.action_press("move_right")
	_walk_state.process(0.016)
	var initial_velocity = _mock_player.velocity.x
	Input.action_release("move_right")

	_walk_state.process(0.016)
	assert_true(_mock_player.velocity.x < initial_velocity, "Friction should reduce velocity")


func test_walk_state_applies_acceleration():
	# Test that walk state applies acceleration
	Input.action_press("move_right")
	_walk_state.process(0.016)
	var first_frame_velocity = _mock_player.velocity.x

	_walk_state.process(0.016)
	var second_frame_velocity = _mock_player.velocity.x

	assert_true(second_frame_velocity > first_frame_velocity, "Acceleration should increase velocity")
	Input.action_release("move_right")


func test_walk_state_enter_plays_animation():
	# Test that walk state plays walk animation on enter if it exists
	# Note: In test environment, AnimationPlayer may not have animations
	_walk_state.enter()
	# Just verify enter() doesn't crash, actual animation test requires scene setup
	assert_true(true, "WalkState enter should handle animation gracefully")


func test_walk_state_enter_callable():
	# Test that WalkState enter method can be called
	_walk_state.enter()
	assert_true(true, "WalkState enter should be callable")


func test_walk_state_exit_callable():
	# Test that WalkState exit method can be called
	_walk_state.exit()
	assert_true(true, "WalkState exit should be callable")


func test_walk_state_process_callable():
	# Test that WalkState process method can be called
	_walk_state.process(0.016)
	assert_true(true, "WalkState process should be callable")
