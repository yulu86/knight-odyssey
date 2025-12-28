# Walk State
# Player moves left/right on ground
# 移动状态：玩家在地面上左右移动

class_name WalkState
extends OnFloorState


const WALK_ANIMATION_NAME := &"walk"


func _init() -> void:
	state_type = PlayerState.State.MOVE


func enter() -> void:
	# Play walk animation when entering walk state
	if animation_player != null and animation_player.has_animation(WALK_ANIMATION_NAME):
		animation_player.play(WALK_ANIMATION_NAME)


func exit() -> void:
	# Clean up when exiting walk state
	pass


func process(delta: float) -> void:
	if player == null:
		return

	# Check for jump input first (priority over movement)
	if Input.is_action_pressed("jump"):
		transition_state(PlayerState.State.JUMP)
		return

	# Get movement input direction
	var direction = get_input_direction()

	# Get movement configuration from ConfigManager
	var walk_speed = config_manager.get_walk_speed() if config_manager != null else 200.0
	var acceleration = config_manager.get_acceleration() if config_manager != null else 800.0
	var friction = config_manager.get_friction() if config_manager != null else 800.0

	# Handle movement with acceleration and friction
	if is_zero_approx(direction):
		# Apply friction when no input
		player.velocity.x = move_toward(
			player.velocity.x,
			0.0,
			friction * delta
		)

		# Transition to idle when stopped
		if is_zero_approx(player.velocity.x):
			transition_state(PlayerState.State.IDLE)
	else:
		# Apply acceleration in the input direction
		player.velocity.x = move_toward(
			player.velocity.x,
			direction * walk_speed,
			acceleration * delta
		)

		# Update sprite facing direction
		update_sprite_facing(direction)

	player.move_and_slide()