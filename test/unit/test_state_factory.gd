extends GutTest

# StateFactory Test
# 测试状态工厂的核心功能
class_name TestStateFactory

var _test_factory: StateFactory = null


func before_each():
	_test_factory = StateFactory.new()


func after_each():
	if _test_factory != null:
		_test_factory.queue_free()
	_test_factory = null


func test_state_factory_class_exists():
	# 测试 StateFactory 类是否存在
	assert_not_null(_test_factory, "StateFactory class should exist")


func test_state_factory_has_states_dictionary():
	# 测试 StateFactory 是否有 states 字典
	assert_not_null(_test_factory, "StateFactory instance should exist")
	# states should be initialized as empty dictionary
	assert_not_null(_test_factory.states, "StateFactory should have states property")


func test_state_factory_has_get_state_method():
	# 测试 StateFactory 是否有 get_state 方法
	assert_not_null(_test_factory, "StateFactory instance should exist")
	# get_state should be callable
	var result = _test_factory.get_state("test_key")
	# Should return null for non-existent state
	assert_null(result, "get_state should return null for non-existent state")


func test_state_factory_has_register_state_method():
	# 测试 StateFactory 是否有 register_state 方法
	assert_not_null(_test_factory, "StateFactory instance should exist")
	# Should be able to register a state
	var test_state = State.new()
	_test_factory.register_state("test_key", test_state)
	# Should retrieve the same state
	var retrieved = _test_factory.get_state("test_key")
	assert_eq(retrieved, test_state, "Should retrieve registered state")


func test_state_factory_is_node():
	# 测试 StateFactory 是否继承自 Node
	assert_is(_test_factory, Node, "StateFactory should extend Node")
