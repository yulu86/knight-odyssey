class_name PlayerStateFactory


var states: Dictionary = {
	PlayerStateMachine.State.IDLE: IdleState,
	PlayerStateMachine.State.WALK: WalkState,
	PlayerStateMachine.State.JUMP: JumpState,
	PlayerStateMachine.State.FALL: FallState
}


func get_state(state: PlayerStateMachine.State) -> PlayerState:
	assert(states.has(state), "Invalid state")
	return states[state].new()
