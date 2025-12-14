class_name DoubleJumpState
extends PlayerState


# 状态进入
func enter() -> void:
	# 设置二段跳垂直速度
	player.velocity.y = player.double_jump_velocity
	# 增加跳跃计数
	player.jump_count += 1
	# 播放二段跳动画（需后续在AnimationPlayer中创建）
	play_animation("double_jump")
	# 触发粒子特效（需后续在场景中添加节点）
	if player.has_node("DoubleJumpParticles"):
		player.get_node("DoubleJumpParticles").emitting = true


# 状态退出
func exit() -> void:
	# 停止粒子特效
	if player.has_node("DoubleJumpParticles"):
		player.get_node("DoubleJumpParticles").emitting = false


# 每帧更新
func update(delta: float) -> void:
	# 检查状态转换：当开始下落时转换到FALL状态
	if player.velocity.y >= 0:
		transition_to_state(PlayerStateMachine.State.FALL)
	
	super.update(delta)


# 输入处理
func handle_input(event: InputEvent) -> void:
	super.handle_input(event)
	
	# 二段跳状态中不再响应跳跃输入（避免无限跳）
	if event.is_action_pressed("jump"):
		# 忽略跳跃输入，防止三段跳
		pass