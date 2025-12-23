extends GutTest

# State Base Class Test
# 测试状态基类的核心功能
class_name TestState

var _test_state: State = null


func before_each():
	_test_state = State.new()


func after_each():
	if _test_state != null:
		_test_state.queue_free()
	_test_state = null


func test_state_class_exists():
	# 测试 State 类是否存在
	assert_not_null(_test_state, "State class should exist")


func test_state_has_state_machine_property():
	# 测试 State 是否有 state_machine 属性
	assert_not_null(_test_state, "State instance should exist")
	# State should be able to hold state_machine reference
	var dummy_machine = StateMachine.new()
	_test_state.state_machine = dummy_machine
	assert_eq(_test_state.state_machine, dummy_machine, "State should have state_machine property")


func test_state_has_character_property():
	# 测试 State 是否有 character 属性
	assert_not_null(_test_state, "State instance should exist")
	# State should be able to hold character reference
	var dummy_character = CharacterBody2D.new()
	_test_state.character = dummy_character
	assert_eq(_test_state.character, dummy_character, "State should have character property")


func test_state_has_enter_method():
	# 测试 State 是否有 enter 方法
	assert_not_null(_test_state, "State instance should exist")
	# enter should be callable without errors
	_test_state.enter()


func test_state_has_exit_method():
	# 测试 State 是否有 exit 方法
	assert_not_null(_test_state, "State instance should exist")
	# exit should be callable without errors
	_test_state.exit()


func test_state_has_process_method():
	# 测试 State 是否有 process 方法
	assert_not_null(_test_state, "State instance should exist")
	# process should be callable with delta parameter
	_test_state.process(0.016)


func test_state_has_physics_process_method():
	# 测试 State 是否有 physics_process 方法
	assert_not_null(_test_state, "State instance should exist")
	# physics_process should be callable with delta parameter
	_test_state.physics_process(0.016)


func test_state_is_node():
	# 测试 State 是否继承自 Node
	assert_is(_test_state, Node, "State should extend Node")
