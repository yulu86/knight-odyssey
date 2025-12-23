extends GutTest

# StateMachine Test
# 测试状态机的核心功能
class_name TestStateMachine

var _test_machine: StateMachine = null
var _mock_character: CharacterBody2D = null
var _mock_state: State = null


func before_each():
	_mock_character = CharacterBody2D.new()
	_test_machine = StateMachine.new()
	_test_machine.character = _mock_character
	_mock_state = State.new()


func after_each():
	if _mock_state != null:
		_mock_state.queue_free()
	if _test_machine != null:
		_test_machine.queue_free()
	if _mock_character != null:
		_mock_character.queue_free()
	_mock_state = null
	_test_machine = null
	_mock_character = null


func test_state_machine_class_exists():
	# 测试 StateMachine 类是否存在
	assert_not_null(_test_machine, "StateMachine class should exist")


func test_state_machine_has_current_state():
	# 测试 StateMachine 是否有 current_state 属性
	assert_not_null(_test_machine, "StateMachine instance should exist")
	# current_state should be null initially
	assert_null(_test_machine.current_state, "current_state should be null initially")


func test_state_machine_has_states_factory():
	# 测试 StateMachine 是否有 states_factory 属性
	assert_not_null(_test_machine, "StateMachine instance should exist")
	# states_factory should exist
	assert_not_null(_test_machine.states_factory, "StateMachine should have states_factory")


func test_state_machine_has_character_property():
	# 测试 StateMachine 是否有 character 属性
	assert_not_null(_test_machine, "StateMachine instance should exist")
	_test_machine.character = _mock_character
	assert_eq(_test_machine.character, _mock_character, "StateMachine should have character property")


func test_state_machine_change_state():
	# 测试状态机的状态切换功能
	assert_not_null(_test_machine, "StateMachine instance should exist")

	# Set up factory with a state
	_test_machine.states_factory.register_state("test", _mock_state)

	# Change to the state
	_test_machine.change_state("test")

	# Verify current_state changed
	assert_eq(_test_machine.current_state, _mock_state, "current_state should be changed to new state")


func test_state_machine_calls_enter_on_state_change():
	# 测试状态切换时调用 enter 方法
	assert_not_null(_test_machine, "StateMachine instance should exist")

	# Create a test state that tracks enter calls
	var test_state = TestTrackingState.new()
	_test_machine.states_factory.register_state("test", test_state)
	_test_machine.change_state("test")

	assert_true(test_state.enter_called, "enter should be called when changing state")

	test_state.queue_free()


func test_state_machine_calls_exit_on_previous_state():
	# 测试状态切换时调用前一个状态的 exit 方法
	assert_not_null(_test_machine, "StateMachine instance should exist")

	# Create test states that track method calls
	var first_state = TestTrackingState.new()
	var second_state = TestTrackingState.new()

	_test_machine.states_factory.register_state("first", first_state)
	_test_machine.states_factory.register_state("second", second_state)

	# Change to first state
	_test_machine.change_state("first")
	assert_true(first_state.enter_called, "enter should be called on first state")

	# Change to second state
	_test_machine.change_state("second")
	assert_true(first_state.exit_called, "exit should be called on first state")
	assert_true(second_state.enter_called, "enter should be called on second state")

	first_state.queue_free()
	second_state.queue_free()


func test_state_machine_has_process_method():
	# 测试 StateMachine 是否有 process 方法
	assert_not_null(_test_machine, "StateMachine instance should exist")
	# Set up a state
	_test_machine.states_factory.register_state("test", _mock_state)
	_test_machine.change_state("test")
	# process should be callable without errors
	_test_machine.process(0.016)


func test_state_machine_has_physics_process_method():
	# 测试 StateMachine 是否有 physics_process 方法
	assert_not_null(_test_machine, "StateMachine instance should exist")
	# Set up a state
	_test_machine.states_factory.register_state("test", _mock_state)
	_test_machine.change_state("test")
	# physics_process should be callable without errors
	_test_machine.physics_process(0.016)


func test_state_machine_is_node():
	# 测试 StateMachine 是否继承自 Node
	assert_is(_test_machine, Node, "StateMachine should extend Node")


# Helper class for testing method calls
class TestTrackingState extends State:
	var enter_called: bool = false
	var exit_called: bool = false

	func enter() -> void:
		super.enter()
		enter_called = true

	func exit() -> void:
		super.exit()
		exit_called = true
