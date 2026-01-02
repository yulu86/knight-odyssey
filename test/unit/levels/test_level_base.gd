extends GutTest

var LevelBaseClass = preload("res://scripts/levels/level_base.gd")

var test_level: Node
var test_level_scene: PackedScene


func before_each():
	# 创建测试关卡实例
	test_level = LevelBaseClass.new()
	add_child_autofree(test_level)


func after_each():
	# 清理测试实例
	if test_level:
		test_level.queue_free()


func test_level_emits_ready_signal():
	# 测试关卡就绪信号
	# - 监听level_ready信号
	# - 验证信号被触发
	watch_signals(test_level)

	test_level._ready()

	assert_signal_emitted(test_level, "level_ready", "level_ready signal should be emitted")


func test_level_emits_started_event():
	# 测试关卡发送level_started事件
	# - 设置level_id
	# - 调用_ready
	# - 验证EventBus.level_started被发送
	test_level.level_id = "1-1"

	watch_signals(EventBus)
	test_level._ready()

	assert_signal_emitted(EventBus, "level_started", "level_started signal should be emitted")


func test_spawn_player_creates_player():
	# 测试玩家生成功能
	# - 创建测试玩家场景
	# - 调用spawn_player
	# - 验证玩家被创建并添加到场景
	var player_scene = load("res://scenes/player/player.tscn")
	if player_scene:
		test_level.spawn_player(player_scene)
		assert_true(test_level.get_child_count() > 0, "Player should be added to level")


func test_spawn_player_emits_signal():
	# 测试玩家生成信号
	# - 监听player_spawned信号
	# - 生成玩家
	# - 验证信号被触发
	watch_signals(test_level)

	var player_scene = load("res://scenes/player/player.tscn")
	if player_scene:
		test_level.spawn_player(player_scene)
		assert_signal_emitted(test_level, "player_spawned", "player_spawned signal should be emitted")


func test_on_player_entered_saves_reference():
	# 测试保存玩家引用
	# - 调用on_player_entered
	# - 验证玩家引用被保存
	var player = Node2D.new()

	test_level.on_player_entered(player)

	assert_not_null(test_level.get("_player"), "Player reference should be saved")
	assert_eq(test_level.get("_player"), player, "Player reference should match")


func test_on_player_exited_clears_reference():
	# 测试清理玩家引用
	# - 设置玩家
	# - 调用on_player_exited
	# - 验证玩家引用被清理
	var player = Node2D.new()
	test_level.set("_player", player)

	test_level.on_player_exited()

	assert_null(test_level.get("_player"), "Player reference should be null after exit")
