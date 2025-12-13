class_name IdleState
extends PlayerState

## 状态进入
func enter() -> void:
	# 播放idle动画
	play_animation("idle")


## 状态退出
func exit() -> void:
	# 清理状态相关逻辑（目前不需要）
	pass


## 物理更新
func update(delta: float) -> void:
	# 如果有水平移动输入，切换到行走状态
	if !has_no_horizontal_input():
		state_changed.emit(PlayerStateMachine.State.WALK)

	# 应用摩擦力使角色停止
	move(0.0, delta)


## 输入处理
func handle_input(event: InputEvent) -> void:
	# 检测跳跃输入
	if event.is_action_pressed("jump") and is_on_ground():
		transition_to_state(PlayerStateMachine.State.JUMP)
