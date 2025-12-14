class_name JumpState
extends PlayerState

# 状态进入
func enter() -> void:
	# 增加跳跃计数（第一次跳跃）
	player.jump_count += 1
	# 触发跳跃
	player.velocity.y = player.jump_velocity
	# 播放跳跃动画
	play_animation("jump")


# 状态退出
func exit() -> void:
	# 清理状态相关资源
	pass


func update(delta: float) -> void:
	if player.velocity.y >= 0:
		# 已经达到最高点，开始下落
		transition_to_state(PlayerStateMachine.State.FALL)

	super.update(delta)

# 输入处理
func handle_input(event: InputEvent) -> void:
	super.handle_input(event)
	
	# 检测二段跳输入
	if event.is_action_pressed("jump") and player.jump_count < player.max_jump_count:
		# 转换到二段跳状态
		transition_to_state(PlayerStateMachine.State.DOUBLE_JUMP)
