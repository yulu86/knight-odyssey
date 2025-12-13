class_name PlayerStateMachine
extends Node

## 状态枚举定义
enum State {
	IDLE,
	WALK,
	JUMP,
	FALL
}

## 当前状态实例
var current_state: PlayerState
## 状态字典，存储所有状态实例
var states: Dictionary = {}
## 玩家引用
var player: Player


## 初始化状态机
func init(player_node: Player) -> void:
	player = player_node

	# 创建所有状态实例
	_create_states()

	# 设置初始状态为IDLE
	change_state(State.IDLE)


## 创建所有状态实例
func _create_states() -> void:
	states[State.IDLE] = IdleState.new()
	states[State.WALK] = WalkState.new()
	states[State.JUMP] = JumpState.new()
	states[State.FALL] = FallState.new()

	# 初始化所有状态
	for state in states.values():
		state.init(player, self)


## 物理更新 - 委托给当前状态
func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)


## 输入处理
func handle_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)


## 状态切换方法
func change_state(new_state: State) -> void:
	# 如果已经是目标状态，直接返回
	if current_state and get_current_state_type() == new_state:
		return

	# 退出当前状态
	if current_state:
		current_state.exit()

	# 进入新状态
	current_state = states[new_state]
	if current_state:
		current_state.enter()


## 获取当前状态类型
func get_current_state_type() -> State:
	for state_type in states:
		if states[state_type] == current_state:
			return state_type
	return State.IDLE


## 获取当前状态名称（调试用）
func get_state_name() -> String:
	match get_current_state_type():
		State.IDLE:
			return "Idle"
		State.WALK:
			return "Walk"
		State.JUMP:
			return "Jump"
		State.FALL:
			return "Fall"
		_:
			return "Unknown"
