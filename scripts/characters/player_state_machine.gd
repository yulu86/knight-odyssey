class_name PlayerStateMachine
extends Node

## 状态枚举定义
enum State {
	IDLE,
	WALK,
	JUMP,
	FALL
}

@export var is_debug := false

## 当前状态实例
var current_state: State
var current_player_state: PlayerState
var state_factory: PlayerStateFactory
## 玩家引用
var player: Player
var player_components: PlayerComponents


## 初始化状态机
func init(context_player: Player, context_player_components: PlayerComponents) -> void:
	player = context_player
	player_components = context_player_components
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

	if is_debug:
		print("StateMachine: %s => %s" % [get_state_name(current_state), get_state_name(new_state)])

	# 退出当前状态
	if current_player_state:
		current_player_state.exit()

	# 新状态初始化
	current_state = new_state
	current_player_state = state_factory.get_state(new_state)
	current_player_state.init(player_components)
	current_player_state.state_changed.connect(change_state)

	# 进入新状态
	if current_player_state:
		current_player_state.enter()


func get_state_name(state: State) -> String:
	return str(State.keys()[state])
