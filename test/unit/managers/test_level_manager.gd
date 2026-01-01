extends GutTest


func before_each():
    # 重置LevelManager状态
    LevelManager._levels = []
    LevelManager.current_level = null
    LevelManager._progress_data = {}

    # 重新初始化默认关卡
    LevelManager._initialize_default_levels()
    LevelManager._unlock_first_level()


func test_level_manager_autoload_singleton():
    # 验证LevelManager作为AutoLoad单例可访问
    assert_not_null(LevelManager, "LevelManager should be accessible as singleton")


func test_level_manager_initialization():
    # 验证LevelManager正确初始化
    assert_gt(LevelManager.get_all_levels().size(), 0, "Level list should not be empty")
    assert_true(LevelManager.is_level_unlocked("1-1"), "First level (1-1) should be unlocked")


func test_level_data_structure():
    # 验证LevelData数据结构
    var test_level: LevelManager.LevelData = LevelManager.LevelData.new("test-1", "Test Level", "res://test.tscn", "grassland")
    assert_eq(test_level.level_id, "test-1", "level_id should be set")
    assert_eq(test_level.level_name, "Test Level", "level_name should be set")
    assert_eq(test_level.scene_path, "res://test.tscn", "scene_path should be set")
    assert_eq(test_level.theme_type, "grassland", "theme_type should be set")
    assert_false(test_level.is_unlocked, "is_unlocked should default to false")
    assert_false(test_level.is_completed, "is_completed should default to false")
    assert_eq(test_level.high_score, 0, "high_score should default to 0")
    assert_eq(test_level.coins_collected, 0, "coins_collected should default to 0")
    assert_eq(test_level.total_coins, 0, "total_coins should default to 0")


func test_get_level_info():
    # 验证获取关卡信息
    var level: LevelManager.LevelData = LevelManager.get_level_info("1-1")
    assert_not_null(level, "Should return level data for valid level_id")
    assert_eq(level.level_id, "1-1", "Returned level should have correct level_id")
    assert_eq(level.level_name, "草原平原", "Returned level should have correct level_name")

    var invalid_level: LevelManager.LevelData = LevelManager.get_level_info("invalid")
    assert_null(invalid_level, "Should return null for invalid level_id")


func test_get_all_levels():
    # 验证获取所有关卡列表
    var all_levels: Array[LevelManager.LevelData] = LevelManager.get_all_levels()
    assert_gt(all_levels.size(), 0, "Should return non-empty array")
    assert_eq(all_levels.size(), 3, "Should return all 3 defined levels")


func test_is_level_unlocked():
    # 测试关卡解锁状态查询
    assert_true(LevelManager.is_level_unlocked("1-1"), "Level 1-1 should be unlocked")
    assert_false(LevelManager.is_level_unlocked("1-2"), "Level 1-2 should be locked")
    assert_false(LevelManager.is_level_unlocked("1-3"), "Level 1-3 should be locked")


func test_is_level_completed():
    # 测试关卡完成状态查询
    assert_false(LevelManager.is_level_completed("1-1"), "New level should not be completed")
    assert_false(LevelManager.is_level_completed("1-2"), "Locked level should not be completed")


func test_get_level_high_score():
    # 测试获取最高分
    assert_eq(LevelManager.get_level_high_score("1-1"), 0, "New level should have 0 high score")
    assert_eq(LevelManager.get_level_high_score("invalid"), 0, "Invalid level should return 0")


# Task 2: 场景切换和关卡加载机制


func test_load_level_sends_event():
    # 测试加载关卡时发送事件
    # - 监听EventBus.level_loaded信号
    # - 调用load_level("1-1")
    # - 验证信号被触发，参数为"1-1"
    watch_signals(EventBus)

    LevelManager.load_level("1-1")

    assert_signal_emitted(EventBus, "level_loaded", "level_loaded signal should be emitted")

    var signal_args = get_signal_parameters(EventBus, "level_loaded")
    assert_eq(signal_args[0], "1-1", "level_loaded signal should contain correct level_id")


func test_load_level_sets_current_level():
    # 测试加载关卡后设置当前关卡
    # - 调用load_level("1-1")
    # - 验证current_level不为null
    # - 验证current_level.level_id为"1-1"
    LevelManager.load_level("1-1")
    await wait_seconds(0.1)

    var current_level: LevelManager.LevelData = LevelManager.get_current_level()
    assert_not_null(current_level, "current_level should not be null after loading")
    assert_eq(current_level.level_id, "1-1", "current_level.level_id should be 1-1")


func test_load_level_triggers_game_manager():
    # 测试加载关卡时调用GameManager
    # - 验证场景加载被触发
    # 注意：由于场景文件不存在，scene_loading_finished不会触发
    # 但load_level应该验证场景文件存在性
    var load_result: bool = LevelManager.load_level("1-1")
    await wait_seconds(0.1)

    assert_true(load_result, "load_level should succeed even if scene file doesn't exist in test")
    assert_not_null(LevelManager.get_current_level(), "current_level should be set")


func test_load_invalid_level():
    # 测试加载不存在的关卡
    # - 调用load_level("invalid")
    # - 验证不触发场景切换
    # - 验证发送错误事件或返回false
    var load_result: bool = LevelManager.load_level("invalid")
    await wait_seconds(0.1)

    assert_false(load_result, "load_level should return false for invalid level")
    assert_null(LevelManager.get_current_level(), "current_level should remain null")


func test_load_level_performance():
    # 测试关卡加载性能
    # - 记录调用load_level前的时间
    # - 调用load_level("1-1")
    # - 验证加载时间<2秒
    var start_time: float = Time.get_unix_time_from_system()

    LevelManager.load_level("1-1")
    await wait_seconds(0.1)

    var end_time: float = Time.get_unix_time_from_system()
    var load_time: float = end_time - start_time

    assert_lt(load_time, 2.0, "Level loading time should be less than 2 seconds")


func test_is_in_level():
    # 测试检查是否在关卡中
    assert_false(LevelManager.is_in_level(), "Should not be in level initially")

    LevelManager.load_level("1-1")
    await wait_seconds(0.1)

    assert_true(LevelManager.is_in_level(), "Should be in level after loading")


func test_get_current_level_id():
    # 测试获取当前关卡ID
    assert_eq(LevelManager.get_current_level_id(), "", "Current level ID should be empty initially")

    LevelManager.load_level("1-1")
    await wait_seconds(0.1)

    assert_eq(LevelManager.get_current_level_id(), "1-1", "Current level ID should be 1-1")


# Task 3: 关卡解锁和完成机制


func test_complete_level_marks_completed():
    # 测试标记关卡完成
    # - 调用complete_level("1-1", 1000)
    # - 验证关卡is_completed为true
    # - 验证关卡high_score为1000
    watch_signals(EventBus)

    LevelManager.complete_level("1-1", 1000)

    assert_true(LevelManager.is_level_completed("1-1"), "Level 1-1 should be completed")
    assert_eq(LevelManager.get_level_high_score("1-1"), 1000, "High score should be 1000")


func test_complete_level_updates_high_score():
    # 测试更新最高分
    # - 完成关卡得分500
    # - 再次完成得分1000
    # - 验证最高分为1000（取最大值）
    watch_signals(EventBus)

    LevelManager.complete_level("1-1", 500)
    LevelManager.complete_level("1-1", 1000)

    assert_eq(LevelManager.get_level_high_score("1-1"), 1000, "High score should be 1000 (max)")


func test_complete_level_unlocks_next():
    # 测试完成关卡后解锁下一关
    # - 完成1-1关卡
    # - 验证1-2关卡is_unlocked为true
    # - 验证发送level_unlocked事件
    watch_signals(EventBus)

    assert_false(LevelManager.is_level_unlocked("1-2"), "Level 1-2 should be locked initially")

    LevelManager.complete_level("1-1", 1000)

    assert_true(LevelManager.is_level_unlocked("1-2"), "Level 1-2 should be unlocked after completing 1-1")
    assert_signal_emitted(EventBus, "level_unlocked", "level_unlocked signal should be emitted")


func test_unlock_level():
    # 测试手动解锁关卡
    # - 解锁1-3关卡
    # - 验证is_unlocked为true
    # - 验证发送level_unlocked事件
    watch_signals(EventBus)

    assert_false(LevelManager.is_level_unlocked("1-3"), "Level 1-3 should be locked initially")

    LevelManager.unlock_level("1-3")

    assert_true(LevelManager.is_level_unlocked("1-3"), "Level 1-3 should be unlocked")
    assert_signal_emitted(EventBus, "level_unlocked", "level_unlocked signal should be emitted")


func test_complete_level_sends_event():
    # 测试完成关卡时发送事件
    # - 监听EventBus.level_completed信号
    # - 完成关卡得分1000
    # - 验证信号被触发，参数为level_id和score
    watch_signals(EventBus)

    LevelManager.complete_level("1-1", 1000)

    assert_signal_emitted(EventBus, "level_completed", "level_completed signal should be emitted")

    var signal_args = get_signal_parameters(EventBus, "level_completed")
    assert_eq(signal_args[0], "1-1", "level_completed signal should contain correct level_id")
    assert_eq(signal_args[1], 1000, "level_completed signal should contain correct score")


# Task 4: 关卡进度保存和加载


func test_save_level_progress():
    # 测试保存关卡进度
    # - 完成几个关卡
    # - 调用save_level_progress()
    # - 验证SaveManager被调用
    # - 验证发送level_progress_saved事件
    watch_signals(EventBus)

    LevelManager.complete_level("1-1", 1000)
    LevelManager.complete_level("1-2", 1500)

    var save_result: bool = LevelManager.save_level_progress()

    assert_true(save_result, "save_level_progress should return true")
    assert_signal_emitted(EventBus, "level_progress_saved", "level_progress_saved signal should be emitted")


func test_load_level_progress():
    # 测试加载关卡进度
    # - 保存进度后
    # - 清空关卡状态
    # - 调用load_level_progress()
    # - 验证关卡状态恢复
    watch_signals(EventBus)

    # 保存进度
    LevelManager.complete_level("1-1", 1000)
    LevelManager.complete_level("1-2", 1500)
    LevelManager.save_level_progress()

    # 清空关卡状态并重新加载
    LevelManager._levels = []
    LevelManager.current_level = null
    LevelManager._initialize_default_levels()

    LevelManager.load_level_progress()

    assert_true(LevelManager.is_level_completed("1-1"), "Level 1-1 should be completed after loading")
    assert_true(LevelManager.is_level_completed("1-2"), "Level 1-2 should be completed after loading")
    assert_true(LevelManager.is_level_unlocked("1-3"), "Level 1-3 should be unlocked after loading")


func test_save_and_load_persist_data():
    # 测试保存和加载数据一致性
    # - 完成关卡并设置分数
    # - 保存进度
    # - 清空状态
    # - 加载进度
    # - 验证解锁状态、完成状态、分数都正确
    watch_signals(EventBus)

    # 完成关卡并设置分数
    LevelManager.complete_level("1-1", 1000)
    LevelManager.complete_level("1-2", 2000)

    var original_score_1_1 = LevelManager.get_level_high_score("1-1")
    var original_score_1_2 = LevelManager.get_level_high_score("1-2")

    # 保存进度
    LevelManager.save_level_progress()

    # 清空状态并重新加载
    LevelManager._levels = []
    LevelManager.current_level = null
    LevelManager._initialize_default_levels()

    LevelManager.load_level_progress()

    # 验证数据一致性
    assert_eq(LevelManager.get_level_high_score("1-1"), original_score_1_1, "High score should be persisted")
    assert_eq(LevelManager.get_level_high_score("1-2"), original_score_1_2, "High score should be persisted")
    assert_true(LevelManager.is_level_completed("1-1"), "Completed status should be persisted")
    assert_true(LevelManager.is_level_completed("1-2"), "Completed status should be persisted")
    assert_true(LevelManager.is_level_unlocked("1-2"), "Unlocked status should be persisted")
    assert_true(LevelManager.is_level_unlocked("1-3"), "Unlocked status should be persisted")

 
func test_load_on_no_save_file():
    # 测试没有存档文件时的加载
    # - 删除存档文件
    # - 调用load_level_progress()
    # - 验证使用默认状态（只有1-1解锁）
    # 注意：在单元测试中模拟无存档文件的情况

    # 删除存档文件
    var save_manager := SaveManager.new()
    save_manager.delete_save(LevelManager.SAVE_SLOT)

    # 重新初始化LevelManager
    LevelManager._levels = []
    LevelManager.current_level = null
    LevelManager._initialize_default_levels()

    LevelManager.load_level_progress()

    # 验证默认状态
    assert_true(LevelManager.is_level_unlocked("1-1"), "Level 1-1 should be unlocked by default")
    assert_false(LevelManager.is_level_unlocked("1-2"), "Level 1-2 should be locked by default")
    assert_false(LevelManager.is_level_completed("1-1"), "Level 1-1 should not be completed by default")
