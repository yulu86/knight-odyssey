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
