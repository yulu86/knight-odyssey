class_name WalkState
extends PlayerState

## 状态进入
func enter() -> void:
	# 播放walk动画
	play_animation("walk")


## 状态退出
func exit() -> void:
	# 清理状态相关逻辑（目前不需要）
	pass


## 物理更新
func update(delta: float) -> void:
	# 获取移动输入
	var input_direction: float = get_input_direction()

	# 如果没有移动输入，切换到空闲状态
	if not has_input_direction(input_direction):
		state_changed.emit(PlayerStateMachine.State.IDLE)

	# 应用移动
	move(input_direction, delta)

	# 更新精灵朝向
	update_sprite_facing(input_direction)


## 输入处理
func handle_input(event: InputEvent) -> void:
	# 检测跳跃输入
	if event.is_action_pressed("jump") and is_on_ground():
		transition_to_state(PlayerStateMachine.State.JUMP)
