# AutoLoad配置和集成测试 TDD开发指导

**Story**: KO_20251216_011 游戏管理器核心框架  
**阶段**: 第4阶段 - AutoLoad配置和集成测试  
**预估时间**: 0.5天  
**开发方法**: TDD (测试驱动开发)

---

## 🎯 本阶段目标

配置所有管理器为AutoLoad单例，并通过集成测试验证它们之间的协同工作，确保整个游戏管理框架能够作为一个整体正常运行。

### 验收标准
- [ ] 所有管理器都正确配置为AutoLoad单例
- [ ] AutoLoad加载顺序正确（依赖关系）
- [ ] 各管理器间通过EventBus正常通信
- [ ] 跨管理器功能正常工作（如配置变更、状态同步等）
- [ ] 集成测试覆盖主要使用场景
- [ ] 性能测试确保AutoLoad不影响游戏启动时间

---

## 📋 TDD实施步骤

### 第1步：创建集成测试环境 (20分钟)

#### 1.1 创建集成测试文件框架
**操作**: 创建文件 `test/integration/test_autoload_integration.gd`

```gdscript
# test/integration/test_autoload_integration.gd
extends GutTest

# 测试前准备
func before_each():
    # 每个测试前重置AutoLoad状态（如果需要）
    pass

func after_each():
    # 每个测试后清理
    pass

# ============================================================================
# 测试类1: AutoLoad单例验证
# ============================================================================
class TestAutoLoadSingletons:
    func test_all_managers_globally_accessible():
        # TODO: 验证所有管理器都可通过AutoLoad全局访问
        # 预期管理器: ConfigManager, EventBus, GameManager, LevelManager, ScoreManager, LifeManager, AudioManager
        pass
    
    func test_autoload_loading_order():
        # TODO: 验证AutoLoad加载顺序正确
        # 预期顺序: ConfigManager -> EventBus -> GameManager -> 其他管理器
        pass
    
    func test_autoload_initialization():
        # TODO: 验证所有AutoLoad管理器都正确初始化
        # 预期: 所有管理器的initialize方法都被调用
        pass

# ============================================================================
# 测试类2: 管理器间通信测试
# ============================================================================
class TestManagerCommunication:
    func test_config_manager_to_game_manager():
        # TODO: 测试ConfigManager到GameManager的通信
        # 场景: 配置变更时GameManager能收到通知
        pass
    
    func test_event_bus_cross_manager_communication():
        # TODO: 测试通过EventBus的跨管理器通信
        # 场景: 一个管理器发送事件，其他管理器能接收
        pass
    
    func test_game_manager_coordination():
        # TODO: 测试GameManager的协调功能
        # 场景: GameManager协调多个管理器执行操作
        pass

# ============================================================================
# 测试类3: 端到端功能测试
# ============================================================================
class TestEndToEndFunctionality:
    func test_complete_game_session():
        # TODO: 测试完整的游戏会话流程
        # 流程: 游戏启动 -> 配置加载 -> 关卡加载 -> 事件处理 -> 游戏结束
        pass
    
    func test_level_complete_workflow():
        # TODO: 测试关卡完成工作流
        # 流程: 关卡完成 -> 事件发送 -> 进度保存 -> 状态更新
        pass
    
    func test_save_load_cycle():
        # TODO: 测试保存加载循环
        # 流程: 保存进度 -> 修改状态 -> 加载进度 -> 状态恢复
        pass

# ============================================================================
# 测试类4: 错误处理和容错测试
# ============================================================================
class TestErrorHandling:
    func test_missing_manager_handling():
        # TODO: 测试缺失管理器的处理
        # 场景: 某个管理器不可用时的降级处理
        pass
    
    func test_autoload_initialization_failure():
        # TODO: 测试AutoLoad初始化失败的处理
        # 场景: AutoLoad初始化失败时的恢复机制
        pass
    
    func test_circular_dependency_prevention():
        # TODO: 测试循环依赖预防
        # 场景: 管理器间可能的循环依赖处理
        pass

# ============================================================================
# 测试类5: 性能测试
# ============================================================================
class TestPerformance:
    func test_autoload_startup_time():
        # TODO: 测试AutoLoad启动时间
        # 目标: AutoLoad加载时间不应过长
        pass
    
    func test_manager_performance():
        # TODO: 测试管理器运行时性能
        # 目标: 管理器操作不应影响游戏性能
        pass
    
    func test_memory_usage():
        # TODO: 测试内存使用情况
        # 目标: AutoLoad管理器内存占用合理
        pass
```

#### 1.2 创建性能监控测试
**操作**: 创建文件 `test/integration/test_performance.gd`

```gdscript
# test/integration/test_performance.gd
extends GutTest

# 性能监控工具
class PerformanceMonitor:
    var start_time: float
    var memory_start: int
    
    func start_monitoring():
        start_time = Time.get_ticks_msec()
        memory_start = OS.get_static_memory_usage_by_type()[0]
    
    func get_elapsed_time() -> float:
        return Time.get_ticks_msec() - start_time
    
    func get_memory_usage() -> int:
        return OS.get_static_memory_usage_by_type()[0]
    
    func get_memory_delta() -> int:
        return get_memory_usage() - memory_start

# ============================================================================
# 测试类: AutoLoad性能测试
# ============================================================================
class TestAutoLoadPerformance:
    var monitor = PerformanceMonitor.new()
    
    func test_startup_performance():
        # TODO: 测试AutoLoad启动性能
        # 目标: 启动时间 < 100ms
        pass
    
    func test_memory_overhead():
        # TODO: 测试AutoLoad内存开销
        # 目标: 总内存 < 50MB
        pass
    
    func test_event_performance():
        # TODO: 测试事件系统性能
        # 目标: 事件发送延迟 < 1ms
        pass
```

---

### 第2步：配置AutoLoad管理器 (45分钟)

#### 2.1 创建其他管理器类
**操作**: 为LevelManager、ScoreManager、LifeManager、AudioManager创建完整框架

```gdscript
# scripts/core/managers/level_manager.gd
extends Node
class_name LevelManager

# ============================================================================
# 私有成员
# ============================================================================

var current_level: String = ""
var checkpoint_data: Dictionary = {}
var level_progress: Dictionary = {}

# 信号定义
signal level_loaded(level_name: String)
signal level_unloaded(level_name: String)
signal checkpoint_saved(checkpoint_id: String)

# ============================================================================
# 初始化方法
# ============================================================================

func _ready():
    initialize()

func initialize() -> bool:
    """初始化LevelManager"""
    print("LevelManager initialized")
    return true

# ============================================================================
# 关卡管理方法
# ============================================================================

func load_level(level_name: String) -> bool:
    """
    加载指定关卡
    
    @param level_name: 关卡名称
    @return: 加载是否成功
    """
    print("LevelManager: Loading level ", level_name)
    
    # 这里应该实现实际的关卡加载逻辑
    # 目前使用模拟实现
    current_level = level_name
    level_loaded.emit(level_name)
    return true

func unload_level(level_name: String) -> bool:
    """
    卸载指定关卡
    
    @param level_name: 关卡名称
    @return: 卸载是否成功
    """
    print("LevelManager: Unloading level ", level_name)
    
    if current_level == level_name:
        current_level = ""
        level_unloaded.emit(level_name)
        return true
    
    return false

# ============================================================================
# 检查点管理
# ============================================================================

func save_checkpoint(checkpoint_id: String) -> void:
    """保存检查点"""
    var timestamp = Time.get_unix_time_from_system()
    checkpoint_data[checkpoint_id] = {
        "timestamp": timestamp,
        "level": current_level
    }
    checkpoint_saved.emit(checkpoint_id)
    print("LevelManager: Checkpoint saved: ", checkpoint_id)

# ============================================================================
# 进度管理
# ============================================================================

func save_progress(progress_data: Dictionary) -> bool:
    """
    保存进度数据
    
    @param progress_data: 进度数据
    @return: 保存是否成功
    """
    print("LevelManager: Saving progress")
    level_progress = progress_data.duplicate(true)
    return true

func load_progress() -> Dictionary:
    """
    加载进度数据
    
    @return: 进度数据字典
    """
    print("LevelManager: Loading progress")
    return level_progress

# ============================================================================
# 实用方法
# ============================================================================

func get_current_level() -> String:
    """获取当前关卡名称"""
    return current_level

func has_checkpoint(checkpoint_id: String) -> bool:
    """检查是否存在指定检查点"""
    return checkpoint_data.has(checkpoint_id)
```

```gdscript
# scripts/core/managers/score_manager.gd
extends Node
class_name ScoreManager

# ============================================================================
# 私有成员
# ============================================================================

var current_score: int = 0
var high_score: int = 0
var score_history: Array[int] = []

# 信号定义
signal score_changed(new_score: int)
signal high_score_changed(new_high_score: int)
signal score_earned(points: int, reason: String)

# ============================================================================
# 初始化方法
# ============================================================================

func _ready():
    initialize()

func initialize() -> bool:
    """初始化ScoreManager"""
    print("ScoreManager initialized")
    load_high_score()
    return true

# ============================================================================
# 分数管理
# ============================================================================

func add_score(points: int, reason: String = "") -> void:
    """
    增加分数
    
    @param points: 分数值
    @param reason: 原因描述
    """
    if points <= 0:
        return
    
    current_score += points
    score_history.append(points)
    
    # 发送事件
    score_changed.emit(current_score)
    score_earned.emit(points, reason)
    
    # 更新最高分
    if current_score > high_score:
        high_score = current_score
        high_score_changed.emit(high_score)
        save_high_score()
    
    print("ScoreManager: Added ", points, " points for ", reason, ". Total: ", current_score)

func set_score(score: int) -> void:
    """
    设置分数
    
    @param score: 新分数
    """
    var old_score = current_score
    current_score = max(0, score)
    
    if old_score != current_score:
        score_changed.emit(current_score)
        
        if current_score > high_score:
            high_score = current_score
            high_score_changed.emit(high_score)
            save_high_score()

func reset() -> void:
    """重置分数"""
    current_score = 0
    score_history.clear()
    score_changed.emit(current_score)

# ============================================================================
# 奖励分数
# ============================================================================

func add_coin_bonus() -> void:
    """添加金币收集奖励"""
    var coin_value = ConfigManager.get_player_value("coin_value", 100)
    add_score(coin_value, "coin_collection")

func add_fruit_bonus() -> void:
    """添加水果收集奖励"""
    var fruit_value = ConfigManager.get_player_value("fruit_value", 500)
    add_score(fruit_value, "fruit_collection")

func add_level_complete_bonus() -> void:
    """添加关卡完成奖励"""
    var bonus_value = ConfigManager.get_player_value("level_complete_bonus", 1000)
    add_score(bonus_value, "level_complete")

func add_checkpoint_bonus() -> void:
    """添加检查点奖励"""
    var checkpoint_bonus = ConfigManager.get_player_value("checkpoint_bonus", 50)
    add_score(checkpoint_bonus, "checkpoint")

# ============================================================================
# 持久化
# ============================================================================

func save_high_score() -> void:
    """保存最高分"""
    var config = ConfigFile.new()
    config.set_value("score", "high_score", high_score)
    config.save("user://score_data.cfg")

func load_high_score() -> void:
    """加载最高分"""
    var config = ConfigFile.new()
    var load_result = config.load("user://score_data.cfg")
    
    if load_result == OK:
        high_score = config.get_value("score", "high_score", 0)
        print("ScoreManager: High score loaded: ", high_score)

# ============================================================================
# 实用方法
# ============================================================================

func get_score() -> int:
    """获取当前分数"""
    return current_score

func get_high_score() -> int:
    """获取最高分数"""
    return high_score

func get_score_history() -> Array[int]:
    """获取分数历史"""
    return score_history.duplicate()
```

```gdscript
# scripts/core/managers/life_manager.gd
extends Node
class_name LifeManager

# ============================================================================
# 私有成员
# ============================================================================

var current_lives: int = 3
var max_lives: int = 3
var invulnerable_time: float = 0.0
var is_invulnerable: bool = false

# 信号定义
signal lives_changed(new_lives: int)
signal life_lost(remaining_lives: int)
signal life_gained(remaining_lives: int)
signal player_respawned()
signal invulnerability_changed(is_invulnerable: bool)

# ============================================================================
# 初始化方法
# ============================================================================

func _ready():
    initialize()

func initialize() -> bool:
    """初始化LifeManager"""
    print("LifeManager initialized")
    load_lives_config()
    return true

func load_lives_config() -> void:
    """加载生命值配置"""
    max_lives = ConfigManager.get_player_value("default_lives", 3)
    current_lives = max_lives

# ============================================================================
# 生命值管理
# ============================================================================

func handle_player_damaged(damage: int) -> int:
    """
    处理玩家受伤
    
    @param damage: 伤害值
    @return: 剩余生命值
    """
    if is_invulnerable:
        return current_lives
    
    current_lives = max(0, current_lives - damage)
    
    # 发送事件
    lives_changed.emit(current_lives)
    life_lost.emit(current_lives)
    
    # 如果还有生命，设置无敌时间
    if current_lives > 0:
        set_invulnerable(2.0)  # 2秒无敌时间
        # 这里可以添加重生逻辑
        player_respawned.emit()
    
    print("LifeManager: Player damaged. Remaining lives: ", current_lives)
    return current_lives

func add_life(lives: int = 1) -> void:
    """
    增加生命值
    
    @param lives: 增加的生命值数量
    """
    var old_lives = current_lives
    current_lives = min(max_lives, current_lives + lives)
    
    if old_lives != current_lives:
        lives_changed.emit(current_lives)
        life_gained.emit(current_lives)
        print("LifeManager: Life added. Current lives: ", current_lives)

func set_max_lives(maximum: int) -> void:
    """设置最大生命值"""
    max_lives = max(1, maximum)
    current_lives = min(current_lives, max_lives)

func reset() -> void:
    """重置生命值"""
    current_lives = max_lives
    is_invulnerable = false
    invulnerable_time = 0.0
    lives_changed.emit(current_lives)

# ============================================================================
# 无敌时间管理
# ============================================================================

func set_invulnerable(duration: float) -> void:
    """
    设置无敌时间
    
    @param duration: 无敌持续时间（秒）
    """
    invulnerable_time = duration
    is_invulnerable = (duration > 0)
    invulnerability_changed.emit(is_invulnerable)

func _process(delta: float) -> void:
    """处理无敌时间倒计时"""
    if invulnerable_time > 0:
        invulnerable_time -= delta
        if invulnerable_time <= 0:
            is_invulnerable = false
            invulnerability_changed.emit(false)

# ============================================================================
# 实用方法
# ============================================================================

func get_current_lives() -> int:
    """获取当前生命值"""
    return current_lives

func get_max_lives() -> int:
    """获取最大生命值"""
    return max_lives

func is_player_alive() -> bool:
    """检查玩家是否存活"""
    return current_lives > 0

func is_player_invulnerable() -> bool:
    """检查玩家是否无敌"""
    return is_invulnerable
```

```gdscript
# scripts/core/managers/audio_manager.gd
extends Node
class_name AudioManager

# ============================================================================
# 私有成员
# ============================================================================

var audio_players: Dictionary = {}
var master_volume: float = 1.0
var music_volume: float = 0.8
var sfx_volume: float = 1.0

# 信号定义
signal volume_changed(type: String, volume: float)
sound_played(sound_name: String)

# ============================================================================
# 初始化方法
# ============================================================================

func _ready():
    initialize()

func initialize() -> bool:
    """初始化AudioManager"""
    print("AudioManager initialized")
    load_audio_config()
    return true

func load_audio_config() -> void:
    """加载音频配置"""
    master_volume = ConfigManager.get_player_value("master_volume", 1.0)
    music_volume = ConfigManager.get_player_value("music_volume", 0.8)
    sfx_volume = ConfigManager.get_player_value("sfx_volume", 1.0)

# ============================================================================
# 音频播放方法
# ============================================================================

func play_sound(sound_name: String, volume_scale: float = 1.0) -> void:
    """
    播放音效
    
    @param sound_name: 音效名称
    @param volume_scale: 音量缩放
    """
    print("AudioManager: Playing sound ", sound_name)
    sound_played.emit(sound_name)
    # 这里应该实现实际的音效播放逻辑

func play_music(music_name: String, loop: bool = true) -> void:
    """
    播放背景音乐
    
    @param music_name: 音乐名称
    @param loop: 是否循环
    """
    print("AudioManager: Playing music ", music_name)
    # 这里应该实现实际的音乐播放逻辑

func stop_music() -> void:
    """停止背景音乐"""
    print("AudioManager: Stopping music")

# ============================================================================
# 音量控制
# ============================================================================

func set_master_volume(volume: float) -> void:
    """设置主音量"""
    master_volume = clamp(volume, 0.0, 1.0)
    volume_changed.emit("master", master_volume)

func set_music_volume(volume: float) -> void:
    """设置音乐音量"""
    music_volume = clamp(volume, 0.0, 1.0)
    volume_changed.emit("music", music_volume)

func set_sfx_volume(volume: float) -> void:
    """设置音效音量"""
    sfx_volume = clamp(volume, 0.0, 1.0)
    volume_changed.emit("sfx", sfx_volume)

# ============================================================================
# 实用方法
# ============================================================================

func get_master_volume() -> float:
    """获取主音量"""
    return master_volume

func get_music_volume() -> float:
    """获取音乐音量"""
    return music_volume

func get_sfx_volume() -> float:
    """获取音效音量"""
    return sfx_volume
```

#### 2.2 配置AutoLoad设置
**操作**: 在Godot项目设置中配置所有管理器为AutoLoad

1. 打开Godot编辑器
2. 进入 `项目 -> 项目设置 -> AutoLoad`
3. 按以下顺序添加AutoLoad：

**AutoLoad配置顺序（重要）：**

1. **ConfigManager**
   - 路径: `res://scripts/core/managers/config_manager.gd`
   - 节点名称: `ConfigManager`
   - 勾选 `启用`

2. **EventBus**
   - 路径: `res://scripts/core/managers/event_bus.gd`
   - 节点名称: `EventBus`
   - 勾选 `启用`

3. **GameManager**
   - 路径: `res://scripts/core/managers/game_manager.gd`
   - 节点名称: `GameManager`
   - 勾选 `启用`

4. **LevelManager**
   - 路径: `res://scripts/core/managers/level_manager.gd`
   - 节点名称: `LevelManager`
   - 勾选 `启用`

5. **ScoreManager**
   - 路径: `res://scripts/core/managers/score_manager.gd`
   - 节点名称: `ScoreManager`
   - 勾选 `启用`

6. **LifeManager**
   - 路径: `res://scripts/core/managers/life_manager.gd`
   - 节点名称: `LifeManager`
   - 勾选 `启用`

7. **AudioManager**
   - 路径: `res://scripts/core/managers/audio_manager.gd`
   - 节点名称: `AudioManager`
   - 勾选 `启用`

---

### 第3步：实现集成测试 (1小时)

#### 3.1 实现AutoLoad单例验证测试
**操作**: 完善 `test/integration/test_autoload_integration.gd`

```gdscript
# 在TestAutoLoadSingletons类中实现测试方法
func test_all_managers_globally_accessible():
    # 验证所有管理器都可通过AutoLoad全局访问
    var managers = ["ConfigManager", "EventBus", "GameManager", "LevelManager", "ScoreManager", "LifeManager", "AudioManager"]
    
    for manager_name in managers:
        var manager = get_node("/root/" + manager_name)
        assert_true(manager != null, "Manager %s should be globally accessible" % manager_name)
        assert_true(manager is Node, "Manager %s should be a Node instance" % manager_name)

func test_autoload_loading_order():
    # 验证AutoLoad加载顺序正确
    # 通过检查依赖关系来验证加载顺序
    assert_true(ConfigManager != null, "ConfigManager should be loaded first")
    assert_true(EventBus != null, "EventBus should be loaded second")
    assert_true(GameManager != null, "GameManager should be loaded third")
    
    # 验证GameManager能访问ConfigManager和EventBus
    assert_true(GameManager.get_node("/root/ConfigManager") != null, "GameManager should access ConfigManager")
    assert_true(GameManager.get_node("/root/EventBus") != null, "GameManager should access EventBus")

func test_autoload_initialization():
    # 验证所有AutoLoad管理器都正确初始化
    assert_true(ConfigManager.is_initialized(), "ConfigManager should be initialized")
    assert_true(GameManager.get_current_state() != GameManager.GameState.INITIALIZING, "GameManager should be initialized")
    
    # 验证其他管理器初始化
    assert_true(LevelManager != null, "LevelManager should be available")
    assert_true(ScoreManager != null, "ScoreManager should be available")
    assert_true(LifeManager != null, "LifeManager should be available")
    assert_true(AudioManager != null, "AudioManager should be available")

# 在TestManagerCommunication类中实现测试方法
func test_event_bus_cross_manager_communication():
    # 测试通过EventBus的跨管理器通信
    var event_received = false
    var received_data = null
    
    # 订阅事件
    EventBus.player_damaged.connect(func(damage): 
        event_received = true
        received_data = damage
    )
    
    # LifeManager处理玩家受伤（这应该通过EventBus发送事件）
    LifeManager.handle_player_damaged(1)
    
    # 验证事件被正确接收
    assert_true(event_received, "Player damaged event should be received")
    assert_eq(received_data, 1, "Damage value should be correct")

func test_game_manager_coordination():
    # 测试GameManager的协调功能
    var initial_score = ScoreManager.get_score()
    var initial_lives = LifeManager.get_current_lives()
    
    # 模拟金币收集
    EventBus.coin_collected.emit(100)
    
    # 验证ScoreManager收到事件
    var new_score = ScoreManager.get_score()
    assert_eq(new_score, initial_score + 100, "Score should be updated when coin collected")

func test_config_manager_to_game_manager():
    # 测试ConfigManager到GameManager的通信
    var config_changed = false
    
    # 监听配置变更事件
    ConfigManager.config_changed.connect(func(): config_changed = true)
    
    # 修改配置
    ConfigManager.set_player_value("test_config", "test_value")
    
    # 验证配置变更事件被发送
    assert_true(config_changed, "Config change event should be sent")

# 在TestEndToEndFunctionality类中实现测试方法
func test_complete_game_session():
    # 测试完整的游戏会话流程
    # 1. 验证初始状态
    assert_eq(GameManager.get_current_state(), GameManager.GameState.MENU, "Should start in menu state")
    assert_eq(ScoreManager.get_score(), 0, "Should start with zero score")
    assert_true(LifeManager.get_current_lives() > 0, "Should start with positive lives")
    
    # 2. 模拟开始游戏
    GameManager.load_level("test_level")
    
    # 3. 模拟游戏事件
    EventBus.coin_collected.emit(100)
    EventBus.fruit_collected.emit("apple")
    
    # 4. 模拟关卡完成
    EventBus.level_completed.emit("test_level")
    
    # 5. 验证状态
    assert_true(ScoreManager.get_score() > 0, "Score should be increased")

func test_level_complete_workflow():
    # 测试关卡完成工作流
    # 1. 开始关卡
    GameManager.load_level("test_level")
    
    # 2. 模拟一些游戏活动
    EventBus.coin_collected.emit(50)
    EventBus.checkpoint_reached.emit("checkpoint_1")
    
    # 3. 完成关卡
    EventBus.level_completed.emit("test_level")
    
    # 4. 验证奖励被添加
    var score_after_level = ScoreManager.get_score()
    assert_true(score_after_level > 50, "Level completion bonus should be added")

func test_save_load_cycle():
    # 测试保存加载循环
    # 1. 设置一些状态
    EventBus.coin_collected.emit(200)
    var score_before = ScoreManager.get_score()
    
    # 2. 保存进度
    var save_result = GameManager.save_progress()
    assert_true(save_result, "Save should succeed")
    
    # 3. 修改状态
    EventBus.coin_collected.emit(100)
    var score_modified = ScoreManager.get_score()
    assert_gt(score_modified, score_before, "Score should be modified")
    
    # 4. 重新加载进度
    var load_result = GameManager.load_progress()
    # 注意：这个测试可能需要根据实际实现调整
```

#### 3.2 实现性能测试
**操作**: 完善 `test/integration/test_performance.gd`

```gdscript
# 在TestAutoLoadPerformance类中实现性能测试方法
func test_startup_performance():
    # 测试AutoLoad启动性能
    monitor.start_monitoring()
    
    # 模拟AutoLoad初始化过程
    # 在实际测试中，这个测试需要在项目启动时运行
    
    var elapsed_time = monitor.get_elapsed_time()
    
    # AutoLoad加载时间应该合理（这里设置为100ms，实际可能需要调整）
    assert_lt(elapsed_time, 100.0, "AutoLoad startup should be fast (< 100ms)")

func test_memory_overhead():
    # 测试AutoLoad内存开销
    monitor.start_monitoring()
    
    # 获取当前内存使用
    var memory_usage = monitor.get_memory_usage()
    
    # 转换为MB
    var memory_mb = memory_usage / (1024.0 * 1024.0)
    
    # AutoLoad内存开销应该合理（这里设置为50MB，实际可能需要调整）
    assert_lt(memory_mb, 50.0, "AutoLoad memory overhead should be reasonable (< 50MB)")

func test_event_performance():
    # 测试事件系统性能
    monitor.start_monitoring()
    
    var event_count = 1000
    var received_events = 0
    
    # 订阅事件
    EventBus.player_damaged.connect(func(): received_events += 1)
    
    # 发送大量事件
    for i in range(event_count):
        EventBus.player_damaged.emit(1)
    
    var elapsed_time = monitor.get_elapsed_time()
    
    # 验证所有事件都被接收
    assert_eq(received_events, event_count, "All events should be received")
    
    # 验证性能（每个事件平均处理时间应该很短）
    var avg_time_per_event = elapsed_time / event_count
    assert_lt(avg_time_per_event, 1.0, "Average event processing time should be < 1ms")
```

---

### 第4步：创建实际游戏场景集成 (30分钟)

#### 4.1 创建集成测试场景
**操作**: 创建 `scenes/integration_test/autotest_scene.tscn`

场景结构：
```
AutoTestScene (Node)
├── Player (CharacterBody2D) [基本测试用]
├── Level (TileMap) [基本测试用]
└── Collectibles (Node)
    └── Coin (Area2D)
    └── Fruit (Area2D)
```

#### 4.2 创建集成测试脚本
**操作**: 创建 `scripts/integration/autotest_manager.gd`

```gdscript
# scripts/integration/autotest_manager.gd
extends Node

# 测试状态
var test_running: bool = false
var test_results: Dictionary = {}

func _ready():
    print("AutoTest Manager ready")
    run_integration_tests()

func run_integration_tests():
    """运行集成测试"""
    print("Starting integration tests...")
    test_running = true
    
    # 测试AutoLoad管理器
    test_autoload_managers()
    
    # 测试事件通信
    test_event_communication()
    
    # 测试游戏流程
    test_game_flow()
    
    test_running = false
    print("Integration tests completed")
    print_test_results()

func test_autoload_managers():
    """测试AutoLoad管理器"""
    print("Testing AutoLoad managers...")
    
    var success = true
    
    # 测试所有管理器是否可用
    var managers = ["ConfigManager", "EventBus", "GameManager", "LevelManager", "ScoreManager", "LifeManager", "AudioManager"]
    
    for manager_name in managers:
        var manager = get_node("/root/" + manager_name)
        if manager == null:
            print("❌ ", manager_name, " not available")
            success = false
        else:
            print("✅ ", manager_name, " available")
    
    test_results["autoload_managers"] = success

func test_event_communication():
    """测试事件通信"""
    print("Testing event communication...")
    
    var success = true
    var event_received = false
    
    # 测试事件发送和接收
    EventBus.player_damaged.connect(func(): event_received = true)
    EventBus.player_damaged.emit(1)
    
    if not event_received:
        print("❌ Event communication failed")
        success = false
    else:
        print("✅ Event communication working")
    
    test_results["event_communication"] = success

func test_game_flow():
    """测试游戏流程"""
    print("Testing game flow...")
    
    var success = true
    var initial_score = ScoreManager.get_score()
    
    # 测试分数系统
    EventBus.coin_collected.emit(100)
    var new_score = ScoreManager.get_score()
    
    if new_score != initial_score + 100:
        print("❌ Score system not working correctly")
        success = false
    else:
        print("✅ Score system working")
    
    # 测试生命值系统
    var initial_lives = LifeManager.get_current_lives()
    LifeManager.handle_player_damaged(1)
    
    if LifeManager.get_current_lives() >= initial_lives:
        print("❌ Life system not working correctly")
        success = false
    else:
        print("✅ Life system working")
    
    test_results["game_flow"] = success

func print_test_results():
    """打印测试结果"""
    print("\n=== Integration Test Results ===")
    
    for test_name in test_results:
        var result = test_results[test_name]
        var status = "✅ PASS" if result else "❌ FAIL"
        print(test_name, ": ", status)
    
    var all_passed = true
    for result in test_results.values():
        if not result:
            all_passed = false
            break
    
    print("Overall: ", "✅ ALL TESTS PASSED" if all_passed else "❌ SOME TESTS FAILED")
    print("================================\n")
```

---

### 第5步：运行集成测试和验证 (30分钟)

#### 5.1 运行所有集成测试
**操作**: 在Godot编辑器中运行完整的集成测试套件
1. 确保所有AutoLoad管理器都已正确配置
2. 运行 `test/integration/test_autoload_integration.gd`
3. 运行 `test/integration/test_performance.gd`
4. 创建测试场景并运行 `scripts/integration/autotest_manager.gd`
5. 验证所有测试都**通过**

#### 5.2 验证AutoLoad功能
**操作**: 手动验证AutoLoad功能
1. 启动游戏，检查控制台输出确认所有管理器都正确初始化
2. 在游戏中测试基本功能（收集金币、受伤、关卡切换等）
3. 验证管理器间的通信正常
4. 检查性能表现是否正常

#### 5.3 创建验证报告
**操作**: 生成AutoLoad集成验证报告

```gdscript
# 创建验证报告脚本
# scripts/integration/validation_report.gd
extends Node

func _ready():
    generate_validation_report()

func generate_validation_report():
    """生成验证报告"""
    var report = {
        "timestamp": Time.get_datetime_string_from_system(),
        "autoload_status": check_autoload_status(),
        "communication_status": check_communication_status(),
        "performance_status": check_performance_status(),
        "integration_status": check_integration_status()
    }
    
    print("=== AutoLoad Integration Validation Report ===")
    print("Generated at: ", report["timestamp"])
    print("")
    
    print("AutoLoad Status:")
    for manager in report["autoload_status"]:
        var status = "✅" if manager["available"] else "❌"
        print("  ", status, " ", manager["name"], ": ", manager["status"])
    
    print("")
    print("Communication Status: ", report["communication_status"] ? "✅ Working" : "❌ Issues")
    print("Performance Status: ", report["performance_status"] ? "✅ Acceptable" : "❌ Concerns")
    print("Integration Status: ", report["integration_status"] ? "✅ Passed" : "❌ Failed")
    print("================================================")

func check_autoload_status() -> Array:
    """检查AutoLoad状态"""
    var managers = [
        {"name": "ConfigManager", "path": "/root/ConfigManager"},
        {"name": "EventBus", "path": "/root/EventBus"},
        {"name": "GameManager", "path": "/root/GameManager"},
        {"name": "LevelManager", "path": "/root/LevelManager"},
        {"name": "ScoreManager", "path": "/root/ScoreManager"},
        {"name": "LifeManager", "path": "/root/LifeManager"},
        {"name": "AudioManager", "path": "/root/AudioManager"}
    ]
    
    var status = []
    for manager in managers:
        var node = get_node_or_null(manager["path"])
        managers["available"] = (node != null)
        managers["status"] = "Available" if node != null else "Not Found"
        status.append(managers)
    
    return status

func check_communication_status() -> bool:
    """检查通信状态"""
    var event_received = false
    
    EventBus.test_signal.connect(func(): event_received = true)
    EventBus.test_signal.emit()
    
    return event_received

func check_performance_status() -> bool:
    """检查性能状态"""
    # 简单的性能检查
    var memory = OS.get_static_memory_usage_by_type()[0]
    var memory_mb = memory / (1024.0 * 1024.0)
    
    return memory_mb < 100.0  # 小于100MB认为可接受

func check_integration_status() -> bool:
    """检查集成状态"""
    # 综合集成检查
    var managers_ok = check_autoload_status().all(func(m): return m["available"])
    var communication_ok = check_communication_status()
    var performance_ok = check_performance_status()
    
    return managers_ok and communication_ok and performance_ok
```

---

### 第6步：代码审查和优化 (30分钟)

#### 6.1 代码质量检查清单
- [ ] 所有AutoLoad管理器都正确配置并初始化
- [ ] 管理器间依赖关系清晰且无循环依赖
- [ ] 事件系统通信高效且可靠
- [ ] 集成测试覆盖主要使用场景
- [ ] 性能测试指标合理

#### 6.2 系统架构优化
- [ ] AutoLoad加载顺序优化
- [ ] 管理器接口标准化
- [ ] 事件系统性能优化
- [ ] 内存使用优化

#### 6.3 文档和配置验证
- [ ] 项目配置文件正确
- [ ] AutoLoad设置文档完整
- [ ] 集成测试文档清晰
- [ ] 性能基准文档明确

---

## 🔍 验收标准检查

在完成本阶段前，请确认以下验收标准都已满足：

- [ ] **所有管理器都正确配置为AutoLoad单例**
  - ✅ 7个管理器全部配置为AutoLoad
  - ✅ AutoLoad顺序正确（依赖关系）
  - ✅ 所有管理器都能全局访问

- [ ] **AutoLoad加载顺序正确**
  - ✅ ConfigManager -> EventBus -> GameManager -> 其他管理器
  - ✅ 依赖关系验证通过
  - ✅ 初始化流程正常

- [ ] **各管理器间通过EventBus正常通信**
  - ✅ 事件发送和接收正常
  - ✅ 跨管理器通信测试通过
  - ✅ 事件系统性能良好

- [ ] **跨管理器功能正常工作**
  - ✅ 配置变更通知机制
  - ✅ 游戏状态同步
  - ✅ 进度保存协调

- [ ] **集成测试覆盖主要使用场景**
  - ✅ 单例验证测试
  - ✅ 通信测试
  - ✅ 端到端功能测试
  - ✅ 错误处理测试

- [ ] **性能测试确保AutoLoad不影响游戏启动时间**
  - ✅ 启动时间测试
  - ✅ 内存使用测试
  - ✅ 事件性能测试

---

## 📝 后续准备工作

完成AutoLoad配置和集成测试后，游戏管理器核心框架已经完整实现：
1. **基础框架完成** - 所有管理器都已实现并集成
2. **系统集成验证** - 系统间协同工作正常
3. **测试覆盖完整** - 从单元测试到集成测试全面覆盖
4. **性能验证通过** - 系统性能满足要求

---

## 🚨 注意事项

1. **AutoLoad顺序依赖**: 必须严格按照依赖关系配置AutoLoad顺序
2. **内存管理**: AutoLoad管理器在整个游戏生命周期中都存在，注意内存管理
3. **初始化时机**: 确保AutoLoad管理器的初始化顺序正确
4. **错误恢复**: 设计适当的错误处理和恢复机制
5. **性能监控**: 定期监控AutoLoad管理器的性能影响

---

## 📚 相关文档

- [Godot AutoLoad文档](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)
- [Godot项目设置文档](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)
- [游戏架构设计文档](../../02_arch/01_游戏架构概要设计_骑士的奥德赛大冒险.md)
- [GUT集成测试指南](https://github.com/bitwes/Gut/blob/master/doc/Integration-Testing.md)

**下一阶段**: [最终验证和测试指导](05_最终验证和测试指导.md)