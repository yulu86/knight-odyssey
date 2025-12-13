class_name JumpState
extends PlayerState

# 状态进入
func enter() -> void:
	# 触发跳跃
	player.jump()
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

	# 检查状态转换
	check_state_transition()


# 输入处理
func handle_input(_event: InputEvent) -> void:
	# Jump状态下主要处理移动输入
	pass


# 私有方法 - 检查状态转换
func check_state_transition() -> void:
	# 当垂直速度向下时，转换到FallState
	if player.velocity.y > 0:
		transition_to_state(PlayerStateMachine.State.FALL)