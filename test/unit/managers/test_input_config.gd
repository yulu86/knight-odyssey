extends GutTest

# Input Map Configuration Test
# 测试输入映射配置是否正确

var test_actions = ["move_left", "move_right", "jump"]

func before_each():
	# 每个测试前的准备工作
	pass

func after_each():
	# 每个测试后的清理工作
	pass

func test_move_left_action_exists():
	# 测试 "move_left" 动作是否存在
	assert_true(InputMap.has_action("move_left"), "move_left action should exist in InputMap")

	# 验证动作有绑定的事件
	var events = InputMap.action_get_events("move_left")
	assert_gt(events.size(), 0, "move_left action should have at least one event bound")

func test_move_right_action_exists():
	# 测试 "move_right" 动作是否存在
	assert_true(InputMap.has_action("move_right"), "move_right action should exist in InputMap")

	# 验证动作有绑定的事件
	var events = InputMap.action_get_events("move_right")
	assert_gt(events.size(), 0, "move_right action should have at least one event bound")

func test_jump_action_exists():
	# 测试 "jump" 动作是否存在
	assert_true(InputMap.has_action("jump"), "jump action should exist in InputMap")

	# 验证动作有绑定的事件
	var events = InputMap.action_get_events("jump")
	assert_gt(events.size(), 0, "jump action should have at least one event bound")

func test_all_required_actions_exist():
	# 测试所有必需的动作是否存在
	var all_actions = InputMap.get_actions()

	for action in test_actions:
		assert_has(all_actions, action, "Action '" + action + "' should exist in InputMap")

func test_move_left_action_has_valid_input():
	# 测试 move_left 动作是否有有效的输入绑定
	var events = InputMap.action_get_events("move_left")
	assert_gt(events.size(), 0, "move_left should have input events")

	# 检查至少有一个键盘输入
	var has_keyboard_input = false
	for event in events:
		if event is InputEventKey:
			has_keyboard_input = true
			break

	assert_true(has_keyboard_input, "move_left should have at least one keyboard input")

func test_move_right_action_has_valid_input():
	# 测试 move_right 动作是否有有效的输入绑定
	var events = InputMap.action_get_events("move_right")
	assert_gt(events.size(), 0, "move_right should have input events")

	# 检查至少有一个键盘输入
	var has_keyboard_input = false
	for event in events:
		if event is InputEventKey:
			has_keyboard_input = true
			break

	assert_true(has_keyboard_input, "move_right should have at least one keyboard input")

func test_jump_action_has_valid_input():
	# 测试 jump 动作是否有有效的输入绑定
	var events = InputMap.action_get_events("jump")
	assert_gt(events.size(), 0, "jump should have input events")

	# 检查至少有一个键盘输入
	var has_keyboard_input = false
	for event in events:
		if event is InputEventKey:
			has_keyboard_input = true
			break

	assert_true(has_keyboard_input, "jump should have at least one keyboard input")

func test_input_actions_not_empty():
	# 确保所有测试的动作都有有效的输入配置
	for action in test_actions:
		var events = InputMap.action_get_events(action)
		assert_true(events.size() > 0, "Action '" + action + "' should have at least one input event")
