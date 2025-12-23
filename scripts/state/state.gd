extends Node

# State base class for the state machine pattern
# 状态机模式的状态基类
class_name State

## Reference to the state machine managing this state
var state_machine: Node

## Reference to the character (CharacterBody2D) this state operates on
var character: Node2D


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
func process(delta: float) -> void:
	pass


## Called every physics frame
## 每个物理帧调用
func physics_process(delta: float) -> void:
	pass
