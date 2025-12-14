class_name PlayerStateFactory


var states: Dictionary = {
	PlayerStateMachine.State.IDLE: IdleState,
	PlayerStateMachine.State.WALK: WalkState,
	PlayerStateMachine.State.JUMP: JumpState,
	PlayerStateMachine.State.FALL: FallState,
	PlayerStateMachine.State.DOUBLE_JUMP: DoubleJumpState,  # 新增：二段跳状态
}


func get_state(state: PlayerStateMachine.State) -> PlayerState:
	assert(states.has(state), "Invalid state")
	return states[state].new()
