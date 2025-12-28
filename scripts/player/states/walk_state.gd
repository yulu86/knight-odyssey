# Walk State
# Player moves left/right on ground
# 移动状态：玩家在地面上左右移动

class_name WalkState
extends PlayerStateBase

## Movement speed for walk state
const WALK_SPEED: float = 200.0

## Acceleration when starting to move
const ACCELERATION: float = 800.0

## Friction when stopping movement
const FRICTION: float = 800.0


func _init() -> void:
	state_type = PlayerState.State.MOVE


func enter() -> void:
	# Play walk animation when entering walk state
	if animation_player != null and animation_player.has_animation(&"walk"):
		animation_player.play(&"walk")


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

	# Handle movement with acceleration and friction
	if is_zero_approx(direction):
		# Apply friction when no input
		player.velocity.x = move_toward(
			player.velocity.x,
			0.0,
			FRICTION * delta
		)

		# Transition to idle when stopped
		if is_zero_approx(player.velocity.x):
			transition_state(PlayerState.State.IDLE)
	else:
		# Apply acceleration in the input direction
		player.velocity.x = move_toward(
			player.velocity.x,
			direction * WALK_SPEED,
			ACCELERATION * delta
		)

		# Update sprite facing direction
		update_sprite_facing(direction)
	
	player.move_and_slide()