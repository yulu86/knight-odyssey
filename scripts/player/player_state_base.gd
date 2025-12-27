extends Node

# Player State Base Class
# Base class for all player states
# 子类必须实现具体的行为逻辑
class_name PlayerStateBase


## Signal emitted when requesting a state transition
## 发出状态转换请求时触发此信号
## @param to_state: The target state to transition to
signal state_changed(to_state: PlayerState.State)


## Reference to the player state machine managing this state
var state_machine: Node = null

## Reference to the player components this state operates on
var components: PlayerComponents = null


## Called when entering this state
## 进入此状态时调用
func enter() -> void:
	pass


## Called when exiting this state
## 退出此状态时调用
func exit() -> void:
	pass


## Called every frame
## 每帧调用
## @param delta: Time since the last frame
func process(_delta: float) -> void:
	pass


## Request a transition to another state
## 请求转换到另一个状态
## @param to_state: The target state to transition to
func transition_state(to_state: PlayerState.State) -> void:
	state_changed.emit(to_state)
