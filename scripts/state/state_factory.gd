extends Node

# Factory class for creating and managing state instances
# 用于创建和管理状态实例的工厂类
class_name StateFactory

## Dictionary mapping state keys to state instances
var states: Dictionary = {}


## Register a state with a key
## 使用键注册状态
func register_state(key: String, state: Node) -> void:
	states[key] = state


## Get a state by key
## 通过键获取状态
func get_state(key: String) -> Node:
	if states.has(key):
		return states[key]
	return null
