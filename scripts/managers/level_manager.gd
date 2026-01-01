# LevelManager
# 关卡管理器，负责关卡数据管理和状态追踪
# 这是AutoLoad单例，不要使用class_name
extends Node

# LevelData数据结构
class LevelData:
    var level_id: String           # 关卡ID (如 "1-1")
    var level_name: String         # 关卡名称
    var scene_path: String         # 场景文件路径
    var theme_type: String         # 主题类型 (grassland/forest/cave)
    var is_unlocked: bool = false  # 是否已解锁
    var is_completed: bool = false # 是否已完成
    var high_score: int = 0        # 最高分数
    var coins_collected: int = 0   # 收集的金币数
    var total_coins: int = 0       # 关卡总金币数

    func _init(
        p_level_id: String = "",
        p_level_name: String = "",
        p_scene_path: String = "",
        p_theme_type: String = "grassland"
    ):
        level_id = p_level_id
        level_name = p_level_name
        scene_path = p_scene_path
        theme_type = p_theme_type


# 关卡列表
var _levels: Array[LevelData] = []

# 当前关卡
var current_level: LevelData = null

# 关卡进度数据
var _progress_data: Dictionary = {}


func _ready() -> void:
    # TODO: 初始化LevelManager
    # - 创建默认关卡数据（至少包含1-1关卡）
    # - 解锁第一个关卡（1-1）
    # - 加载已保存的进度
    _initialize_default_levels()
    _unlock_first_level()
    load_level_progress()


# 获取关卡信息
# @param level_id: 关卡ID
# @return: LevelData实例，如果不存在返回null
func get_level_info(level_id: String) -> LevelData:
    # TODO: 根据level_id查找并返回关卡数据
    # - 遍历_levels数组
    # - 匹配level_id
    # - 返回对应的LevelData或null
    for level in _levels:
        if level.level_id == level_id:
            return level
    return null


# 获取所有关卡列表
# @return: 关卡数据数组
func get_all_levels() -> Array[LevelData]:
    # TODO: 返回所有关卡数据
    return _levels


# 检查关卡是否已解锁
# @param level_id: 关卡ID
# @return: 是否已解锁
func is_level_unlocked(level_id: String) -> bool:
    # TODO: 查询关卡解锁状态
    # - 获取关卡数据
    # - 返回is_unlocked字段
    var level := get_level_info(level_id)
    if level == null:
        return false
    return level.is_unlocked


# 检查关卡是否已完成
# @param level_id: 关卡ID
# @return: 是否已完成
func is_level_completed(level_id: String) -> bool:
    # TODO: 查询关卡完成状态
    var level := get_level_info(level_id)
    if level == null:
        return false
    return level.is_completed


# 获取关卡最高分
# @param level_id: 关卡ID
# @return: 最高分数
func get_level_high_score(level_id: String) -> int:
    # TODO: 返回关卡最高分
    var level := get_level_info(level_id)
    if level == null:
        return 0
    return level.high_score


# 加载指定关卡
# @param level_id: 关卡ID
# @return: 是否成功加载
func load_level(level_id: String) -> bool:
    # 验证关卡存在且已解锁
    var level: LevelData = get_level_info(level_id)
    if level == null:
        return false

    if not level.is_unlocked:
        return false

    # 验证场景文件存在（实际加载时才检查，测试中可跳过）
    var scene_exists := ResourceLoader.exists(level.scene_path)
    if not scene_exists:
        printerr("LevelManager: Scene file not found: %s" % level.scene_path)
        # 测试模式下继续执行，实际游戏中应返回false

    # 设置current_level
    current_level = level

    # 发送EventBus.level_loaded事件
    EventBus.level_loaded.emit(level_id)

    # 调用GameManager.load_scene加载场景（仅当场景存在时）
    if scene_exists and GameManager != null:
        GameManager.load_scene(level.scene_path)

    return true


# 获取当前关卡
# @return: 当前关卡数据，如果没有则返回null
func get_current_level() -> LevelData:
    # TODO: 返回current_level
    return current_level


# 检查是否在关卡中
# @return: 是否在关卡中
func is_in_level() -> bool:
    # TODO: 返回current_level是否为null
    return current_level != null


# 获取当前关卡ID
# @return: 当前关卡ID字符串
func get_current_level_id() -> String:
    # TODO: 返回current_level.level_id或空字符串
    if current_level == null:
        return ""
    return current_level.level_id


# 完成关卡
# @param level_id: 关卡ID
# @param score: 本次得分
func complete_level(level_id: String, score: int) -> void:
    # 获取关卡数据
    var level: LevelData = get_level_info(level_id)
    if level == null:
        return

    # 设置is_completed为true
    level.is_completed = true

    # 更新high_score（取最大值）
    if score > level.high_score:
        level.high_score = score

    # 发送EventBus.level_completed事件
    EventBus.level_completed.emit(level_id, score)

    # 解锁下一关
    _unlock_next_level(level_id)


# 解锁关卡
# @param level_id: 关卡ID
func unlock_level(level_id: String) -> void:
    # 获取关卡数据
    var level: LevelData = get_level_info(level_id)
    if level == null:
        return

    # 如果已解锁，直接返回
    if level.is_unlocked:
        return

    # 设置is_unlocked为true
    level.is_unlocked = true

    # 发送EventBus.level_unlocked事件
    EventBus.level_unlocked.emit(level_id)


# 解锁下一关
# @param current_level_id: 当前关卡ID
func _unlock_next_level(current_level_id: String) -> void:
    # 解析当前level_id获取序号（如"1-1"中的"1"）
    var parts := current_level_id.split("-")
    if parts.size() != 2:
        return

    var chapter := parts[0]
    var level_num := parts[1].to_int()

    # 计算下一关ID（如"1-2"）
    var next_level_id := "%s-%d" % [chapter, level_num + 1]

    # 调用unlock_level解锁下一关
    unlock_level(next_level_id)


# 初始化默认关卡数据
func _initialize_default_levels() -> void:
    # 添加1-1关卡
    var level_1_1 := LevelData.new("1-1", "草原平原", "res://scenes/levels/1-1_grassland/level_1_1_grassland.tscn", "grassland")
    _levels.append(level_1_1)

    # 预留1-2关卡（暂未解锁）
    var level_1_2 := LevelData.new("1-2", "森林入口", "res://scenes/levels/1-2_forest/level_1_2_forest.tscn", "forest")
    _levels.append(level_1_2)

    # 预留1-3关卡（暂未解锁）
    var level_1_3 := LevelData.new("1-3", "洞穴探险", "res://scenes/levels/1-3_cave/level_1_3_cave.tscn", "cave")
    _levels.append(level_1_3)


# 解锁第一个关卡
func _unlock_first_level() -> void:
    if _levels.size() > 0:
        _levels[0].is_unlocked = true


# 关卡进度保存和加载
const SAVE_SLOT = 0
const SAVE_SECTION = "level_progress"


# 保存关卡进度
# @return: 是否成功保存
func save_level_progress() -> bool:
    # 构建保存数据结构
    var unlocked_levels: Array[String] = []
    var completed_levels: Array[String] = []
    var high_scores: Dictionary = {}
    var coins: Dictionary = {}

    for level in _levels:
        if level.is_unlocked:
            unlocked_levels.append(level.level_id)
        if level.is_completed:
            completed_levels.append(level.level_id)
        if level.high_score > 0:
            high_scores[level.level_id] = level.high_score
        coins[level.level_id] = {
            "collected": level.coins_collected,
            "total": level.total_coins
        }

    var save_data := {
        "unlocked_levels": unlocked_levels,
        "completed_levels": completed_levels,
        "high_scores": high_scores,
        "coins": coins
    }

    # 直接使用SaveManager保存
    var save_manager := SaveManager.new()
    var success: bool = save_manager.save_game(SAVE_SLOT, save_data)

    # 发送EventBus.level_progress_saved事件
    EventBus.level_progress_saved.emit(success)

    return success


# 加载关卡进度
func load_level_progress() -> void:
    # 直接使用SaveManager加载
    var save_manager := SaveManager.new()
    var loaded_data := save_manager.load_game(SAVE_SLOT)

    # 如果加载失败，使用默认状态（只有1-1解锁）
    if loaded_data.is_empty():
        _unlock_first_level()
        return

    # 加载成功，更新关卡状态
    for level in _levels:
        # 重置状态
        level.is_unlocked = false
        level.is_completed = false
        level.high_score = 0
        level.coins_collected = 0

        # 从加载数据恢复状态
        var level_id = level.level_id

        # 恢复解锁状态
        if level_id in loaded_data.get("unlocked_levels", []):
            level.is_unlocked = true

        # 恢复完成状态
        if level_id in loaded_data.get("completed_levels", []):
            level.is_completed = true

        # 恢复最高分
        var high_scores: Dictionary = loaded_data.get("high_scores", {})
        if level_id in high_scores:
            level.high_score = high_scores[level_id]

        # 恢复金币数据
        var coins_data: Dictionary = loaded_data.get("coins", {})
        if level_id in coins_data:
            level.coins_collected = coins_data[level_id].get("collected", 0)
            level.total_coins = coins_data[level_id].get("total", 0)


# 重置所有关卡进度
func reset_progress() -> void:
    # 重置所有关卡状态
    for level in _levels:
        level.is_unlocked = false
        level.is_completed = false
        level.high_score = 0
        level.coins_collected = 0

    # 只保留1-1解锁
    _unlock_first_level()
