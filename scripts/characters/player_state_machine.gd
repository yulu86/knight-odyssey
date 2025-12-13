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
var current_state: State
var current_player_state: PlayerState
var state_factory: PlayerStateFactory
## 玩家引用
var player: Player


## 初始化状态机
func init(player_node: Player) -> void:
	player = player_node
	state_factory = PlayerStateFactory.new()

	# 设置初始状态为IDLE
	change_state(State.IDLE)


## 物理更新 - 委托给当前状态
func update(delta: float) -> void:
	if current_player_state:
		current_player_state.update(delta)


## 输入处理
func handle_input(event: InputEvent) -> void:
	if current_player_state:
		current_player_state.handle_input(event)


## 状态切换方法
func change_state(new_state: State) -> void:
	# 如果已经是目标状态，直接返回
	if current_player_state and current_state == new_state:
		return

	# 退出当前状态
	if current_player_state:
		current_player_state.exit()

	# 进入新状态
	current_player_state = state_factory.get_state(new_state)
	if current_player_state:
		current_player_state.enter()
