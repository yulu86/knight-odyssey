extends GutTest

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
