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
func physics_update(delta: float) -> void:
	# 获取移动输入
	var input_direction: float = get_movement_input()

	# 如果有移动输入，切换到行走状态
	if input_direction != 0.0:
		state_machine.change_state(PlayerStateMachine.State.WALK)
		return

	# 应用摩擦力使角色停止
	player.apply_movement(0.0, delta)
	player.execute_movement()


## 输入处理
func handle_input(_event: InputEvent) -> void:
	# 目前空闲状态不需要特殊输入处理
	pass