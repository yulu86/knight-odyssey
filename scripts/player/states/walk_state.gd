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
	# Stop movement when exiting walk state
	if player != null:
		player.velocity.x = 0


func process(delta: float) -> void:
	if player == null:
		return

	# Check for jump input first (priority over movement)
	if Input.is_action_pressed("jump"):
		transition_state(PlayerState.State.JUMP)
		return

	# Get movement input direction
	var direction = Input.get_axis("move_left", "move_right")

	# Handle movement with acceleration and friction
	if not is_zero_approx(direction):
		# Apply acceleration in the input direction
		player.velocity.x = move_toward(
			player.velocity.x,
			direction * WALK_SPEED,
			ACCELERATION * delta
		)

		# Update sprite facing direction
		if sprite_2d != null:
			if direction > 0:
				sprite_2d.flip_h = false
			else:
				sprite_2d.flip_h = true
	else:
		# Apply friction when no input
		player.velocity.x = move_toward(
			player.velocity.x,
			0.0,
			FRICTION * delta
		)

		# Transition to idle when stopped
		if is_zero_approx(player.velocity.x):
			transition_state(PlayerState.State.IDLE)
