class_name JumpState
extends PlayerState

# 状态进入
func enter() -> void:
	# 触发跳跃
	player.velocity.y = player.jump_velocity
	# 播放跳跃动画
	play_animation("jump")


# 状态退出
func exit() -> void:
	# 清理状态相关资源
	pass


# 每帧更新
func update(delta: float) -> void:
	# 处理水平移动
	var input_direction = get_horizontal_movement_direction()
	move(input_direction, delta)
	update_sprite_facing(input_direction)


# 输入处理
func handle_input(_event: InputEvent) -> void:
	# Jump状态下主要处理移动输入
	pass



func update_velocity(player_velocity: Vector2, input_direction: float, delta: float) -> Vector2:
	player_velocity = super.update_velocity(player_velocity, input_direction, delta)

	# 在跳跃状态下应用重力，使速度逐渐减小
	player_velocity.y += player.gravity * delta

	# 检查是否应该开始下落
	if player_velocity.y >= 0:
		# 已经达到最高点，开始下落
		transition_to_state(PlayerStateMachine.State.FALL)
	
	return player_velocity
