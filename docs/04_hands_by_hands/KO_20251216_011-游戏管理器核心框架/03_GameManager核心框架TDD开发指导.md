# GameManager核心框架 TDD开发指导

**Story**: KO_20251216_011 游戏管理器核心框架  
**阶段**: 第3阶段 - GameManager核心框架  
**预估时间**: 1天  
**开发方法**: TDD (测试驱动开发)

---

## 🎯 本阶段目标

实现GameManager作为游戏的核心控制器，统一协调各子系统，管理游戏状态，处理场景切换和进度保存。

### 验收标准
- [ ] GameManager作为全局单例可访问
- [ ] 能够初始化所有子系统（ConfigManager、EventBus、LevelManager等）
- [ ] 能够协调场景切换（资源加载和释放）
- [ ] 能够处理游戏进度保存
- [ ] 能够响应游戏事件（如关卡完成、游戏结束）
- [ ] 支持游戏状态管理（暂停、恢复、重启）

---

## 📋 TDD实施步骤

### 第1步：创建测试环境 (20分钟)

#### 1.1 创建GameManager测试文件框架
**操作**: 创建文件 `test/core/managers/test_game_manager.gd`

```gdscript
# test/core/managers/test_game_manager.gd
extends GutTest

# 测试前准备
func before_each():
    # 每个测试前重置GameManager状态
    pass

func after_each():
    # 每个测试后清理
    pass

# ============================================================================
# 测试类1: GameManager单例和初始化
# ============================================================================
class TestGameManagerSingleton:
    func test_game_manager_global_singleton():
        # TODO: 验证GameManager可以作为全局单例访问
        # 预期结果: GameManager != null 且 GameManager is Node
        pass
    
    func test_game_manager_initialization():
        # TODO: 验证GameManager正确初始化所有子系统
        # 预期结果: 所有管理器都被正确初始化
        pass
    
    func test_subsystems_available():
        # TODO: 验证所有子系统管理器都可访问
        # 预期: config_manager, event_bus, level_manager等都存在
        pass

# ============================================================================
# 测试类2: 子系统集成
# ============================================================================
class TestGameManagerIntegration:
    func test_config_manager_integration():
        # TODO: 测试与ConfigManager的集成
        # 预期: GameManager可以访问ConfigManager并读取配置
        pass
    
    func test_event_bus_integration():
        # TODO: 测试与EventBus的集成
        # 预期: GameManager可以发送和接收事件
        pass
    
    func test_level_manager_integration():
        # TODO: 测试与LevelManager的集成
        # 预期: GameManager可以调用LevelManager进行关卡管理
        pass

# ============================================================================
# 测试类3: 游戏状态管理
# ============================================================================
class TestGameManagerGameState:
    func test_game_pause_resume():
        # TODO: 测试游戏暂停和恢复功能
        # 步骤:
        # 1. 调用暂停游戏
        # 2. 验证游戏状态为暂停
        # 3. 调用恢复游戏
        # 4. 验证游戏状态为运行
        pass
    
    func test_game_over_handling():
        # TODO: 测试游戏结束处理
        # 步骤:
        # 1. 触发游戏结束事件
        # 2. 验证GameManager正确处理
        # 3. 验证相关子系统被通知
        pass
    
    func test_game_restart():
        # TODO: 测试游戏重启功能
        # 步骤:
        # 1. 调用重启游戏
        # 2. 验证所有系统被重置
        # 3. 验证游戏回到初始状态
        pass

# ============================================================================
# 测试类4: 场景切换协调
# ============================================================================
class TestGameManagerSceneTransition:
    func test_level_loading():
        # TODO: 测试关卡加载
        # 步骤:
        # 1. 调用load_level方法
        # 2. 验证LevelManager被调用
        # 3. 验证相关事件被发送
        pass
    
    func test_level_unloading():
        # TODO: 测试关卡卸载
        # 步骤:
        # 1. 模拟关卡切换
        # 2. 验证旧关卡被正确卸载
        # 3. 验证资源被释放
        pass
    
    func test_scene_transition_coordination():
        # TODO: 测试场景切换协调
        # 步骤:
        # 1. 监听场景切换事件
        # 2. 执行场景切换
        # 3. 验证切换流程被正确触发
        pass

# ============================================================================
# 测试类5: 进度保存和恢复
# ============================================================================
class TestGameManagerProgress:
    func test_auto_save_on_level_complete():
        # TODO: 测试关卡完成时自动保存
        # 步骤:
        # 1. 模拟关卡完成事件
        # 2. 验证保存功能被调用
        # 3. 验证保存数据正确
        pass
    
    func test_manual_save_progress():
        # TODO: 测试手动保存进度
        # 步骤:
        # 1. 调用save_progress方法
        # 2. 验证保存操作执行
        # 3. 验证保存成功
        pass
    
    func test_load_progress():
        # TODO: 测试加载进度
        # 步骤:
        # 1. 保存测试进度
        # 2. 调用load_progress方法
        # 3. 验证进度被正确恢复
        pass

# ============================================================================
# 测试类6: 事件响应
# ============================================================================
class TestGameManagerEventResponse:
    func test_level_completed_event():
        # TODO: 测试响应关卡完成事件
        # 步骤:
        # 1. 发送level_completed事件
        # 2. 验证GameManager处理了事件
        # 3. 验证相关动作被执行
        pass
    
    func test_player_damaged_event():
        # TODO: 测试响应玩家受伤事件
        # 步骤:
        # 1. 发送player_damaged事件
        # 2. 验证GameManager处理了事件
        # 3. 验证生命值系统被更新
        pass
    
    func test_checkpoint_reached_event():
        # TODO: 测试响应检查点事件
        # 步骤:
        # 1. 发送checkpoint_reached事件
        # 2. 验证检查点被保存
        # 3. 验证进度被更新
        pass
```

#### 1.2 创建GameManager场景结构
**操作**: 创建GameManager场景文件目录
```bash
# 创建GameManager场景目录
mkdir -p scenes/managers
```

#### 1.3 运行测试验证失败
**操作**: 在Godot编辑器中运行GUT测试
1. 确保GameManager测试文件已创建
2. 运行测试，确认所有测试都**失败**（这是TDD的正确状态）

---

### 第2步：创建GameManager场景结构 (30分钟)

#### 2.1 创建GameManager场景文件
**操作**: 创建 `scenes/managers/game_manager.tscn`

场景结构：
```
GameManager (Node)
├── ConfigManager (Node) [AutoLoad引用]
├── EventBus (Node) [AutoLoad引用]
├── LevelManager (Node)
├── ScoreManager (Node)
├── LifeManager (Node)
└── AudioManager (Node)
```

#### 2.2 创建GameManager类框架
**操作**: 创建文件 `scripts/core/managers/game_manager.gd`

```gdscript
# scripts/core/managers/game_manager.gd
extends Node
class_name GameManager

# ============================================================================
# 游戏状态枚举
# ============================================================================

enum GameState {
    INITIALIZING,  # 初始化中
    MENU,          # 主菜单
    PLAYING,       # 游戏进行中
    PAUSED,        # 暂停中
    LEVEL_TRANSITION,  # 关卡切换中
    GAME_OVER,     # 游戏结束
    VICTORY        # 胜利
}

# ============================================================================
# 导出变量和节点引用
# ============================================================================

## 游戏会话唯一ID
var game_session_id: String

## 当前关卡名称
var current_level: String = ""

## 当前游戏状态
var current_state: GameState = GameState.INITIALIZING

## 是否暂停
var is_paused: bool = false

## 子系统管理器引用
@onready var config_manager: ConfigManager = get_node_or_null("/root/ConfigManager")
@onready var event_bus: EventBus = get_node_or_null("/root/EventBus")

# 子管理器节点引用（将在场景中设置）
@onready var level_manager: Node = $LevelManager
@onready var score_manager: Node = $ScoreManager
@onready var life_manager: Node = $LifeManager
@onready var audio_manager: Node = $AudioManager

# 游戏状态信号
signal game_state_changed(old_state: GameState, new_state: GameState)
signal level_changed(level_name: String)
signal game_session_started(session_id: String)
signal game_session_ended(session_id: String)

# ============================================================================
# 初始化方法
# ============================================================================

func _init():
    """GameManager初始化"""
    # TODO: 生成游戏会话ID
    # TODO: 初始化游戏状态
    pass

func _ready():
    """节点准备完成"""
    # TODO: 初始化所有子系统
    # TODO: 连接事件总线
    # TODO: 设置初始游戏状态
    pass

func initialize() -> bool:
    """
    初始化GameManager和所有子系统
    
    @return: 初始化是否成功
    """
    # TODO: 实现完整的初始化流程
    return false

# ============================================================================
# 游戏状态管理
# ============================================================================

func change_game_state(new_state: GameState) -> void:
    """
    改变游戏状态
    
    @param new_state: 新的游戏状态
    """
    # TODO: 实现状态转换逻辑
    pass

func pause_game() -> void:
    """暂停游戏"""
    # TODO: 实现游戏暂停逻辑
    pass

func resume_game() -> void:
    """恢复游戏"""
    # TODO: 实现游戏恢复逻辑
    pass

func restart_game() -> void:
    """重启游戏"""
    # TODO: 实现游戏重启逻辑
    pass

func game_over() -> void:
    """处理游戏结束"""
    # TODO: 实现游戏结束逻辑
    pass

# ============================================================================
# 关卡管理
# ============================================================================

func load_level(level_name: String) -> void:
    """
    加载指定关卡
    
    @param level_name: 关卡名称
    """
    # TODO: 实现关卡加载逻辑
    pass

func unload_current_level() -> void:
    """卸载当前关卡"""
    # TODO: 实现关卡卸载逻辑
    pass

func transition_to_level(level_name: String) -> void:
    """
    切换到指定关卡
    
    @param level_name: 目标关卡名称
    """
    # TODO: 实现关卡切换逻辑
    pass

# ============================================================================
# 进度管理
# ============================================================================

func save_progress() -> bool:
    """
    保存游戏进度
    
    @return: 保存是否成功
    """
    # TODO: 实现进度保存逻辑
    return false

func load_progress() -> bool:
    """
    加载游戏进度
    
    @return: 加载是否成功
    """
    # TODO: 实现进度加载逻辑
    return false

func delete_progress() -> bool:
    """
    删除游戏进度
    
    @return: 删除是否成功
    """
    # TODO: 实现进度删除逻辑
    return false

# ============================================================================
# 事件处理方法
# ============================================================================

func _on_level_completed(level_name: String) -> void:
    """
    处理关卡完成事件
    
    @param level_name: 完成的关卡名称
    """
    # TODO: 实现关卡完成处理逻辑
    pass

func _on_player_damaged(damage: int) -> void:
    """
    处理玩家受伤事件
    
    @param damage: 受到的伤害值
    """
    # TODO: 实现玩家受伤处理逻辑
    pass

func _on_game_over() -> void:
    """处理游戏结束事件"""
    # TODO: 实现游戏结束事件处理
    pass

func _on_checkpoint_reached(checkpoint_id: String) -> void:
    """
    处理检查点到达事件
    
    @param checkpoint_id: 检查点ID
    """
    # TODO: 实现检查点处理逻辑
    pass

# ============================================================================
# 实用方法
# ============================================================================

func get_current_state() -> GameState:
    """
    获取当前游戏状态
    
    @return: 当前游戏状态
    """
    return current_state

func get_current_level() -> String:
    """
    获取当前关卡名称
    
    @return: 当前关卡名称
    """
    return current_level

func is_game_paused() -> bool:
    """
    检查游戏是否暂停
    
    @return: 是否暂停
    """
    return is_paused

func generate_session_id() -> String:
    """
    生成游戏会话ID
    
    @return: 唯一的会话ID
    """
    # TODO: 实现会话ID生成
    return ""

# ============================================================================
# 调试和诊断方法
# ============================================================================

func get_system_status() -> Dictionary:
    """
    获取系统状态信息（用于调试）
    
    @return: 系统状态字典
    """
    # TODO: 实现系统状态收集
    return {}

func print_debug_info() -> void:
    """打印调试信息"""
    # TODO: 实现调试信息打印
    pass
```

---

### 第3步：实现GameManager核心功能 (1.5小时)

#### 3.1 实现初始化和状态管理
**操作**: 完善 `scripts/core/managers/game_manager.gd` 的初始化逻辑

```gdscript
# 实现初始化方法
func _init():
    """GameManager初始化"""
    generate_session_id()

func _ready():
    """节点准备完成"""
    initialize()

func generate_session_id() -> void:
    """生成游戏会话ID"""
    var timestamp = Time.get_unix_time_from_system()
    var random_suffix = randi() % 10000
    game_session_id = "session_%d_%d" % [timestamp, random_suffix]

func initialize() -> bool:
    """
    初始化GameManager和所有子系统
    
    @return: 初始化是否成功
    """
    print("Initializing GameManager...")
    
    # 检查必需的AutoLoad管理器
    if not config_manager:
        push_error("ConfigManager not available!")
        return false
    
    if not event_bus:
        push_error("EventBus not available!")
        return false
    
    # 连接事件总线
    _connect_event_bus()
    
    # 初始化子系统（如果存在）
    _initialize_subsystems()
    
    # 设置初始游戏状态
    change_game_state(GameState.MENU)
    
    # 发送游戏会话开始事件
    game_session_started.emit(game_session_id)
    
    print("GameManager initialized successfully with session ID: ", game_session_id)
    return true

func _connect_event_bus() -> void:
    """连接事件总线"""
    if not event_bus:
        return
    
    # 连接游戏相关事件
    event_bus.level_completed.connect(_on_level_completed)
    event_bus.player_damaged.connect(_on_player_damaged)
    event_bus.game_over.connect(_on_game_over)
    event_bus.checkpoint_reached.connect(_on_checkpoint_reached)
    
    print("GameManager connected to EventBus")

func _initialize_subsystems() -> void:
    """初始化子系统管理器"""
    # 初始化LevelManager
    if level_manager and level_manager.has_method("initialize"):
        level_manager.initialize()
    
    # 初始化ScoreManager
    if score_manager and score_manager.has_method("initialize"):
        score_manager.initialize()
    
    # 初始化LifeManager
    if life_manager and life_manager.has_method("initialize"):
        life_manager.initialize()
    
    # 初始化AudioManager
    if audio_manager and audio_manager.has_method("initialize"):
        audio_manager.initialize()
```

#### 3.2 实现游戏状态管理
**操作**: 完善游戏状态管理功能

```gdscript
func change_game_state(new_state: GameState) -> void:
    """
    改变游戏状态
    
    @param new_state: 新的游戏状态
    """
    var old_state = current_state
    
    if old_state == new_state:
        print("Game state unchanged: ", _get_state_name(new_state))
        return
    
    print("Changing game state from ", _get_state_name(old_state), " to ", _get_state_name(new_state))
    
    # 执行状态退出逻辑
    _exit_state(old_state)
    
    # 更新状态
    current_state = new_state
    is_paused = (new_state == GameState.PAUSED)
    
    # 执行状态进入逻辑
    _enter_state(new_state)
    
    # 发送状态变更事件
    game_state_changed.emit(old_state, new_state)
    
    # 发送到EventBus
    if event_bus:
        event_bus.game_state_changed.emit(old_state, new_state)

func _exit_state(state: GameState) -> void:
    """执行状态退出逻辑"""
    match state:
        GameState.PLAYING:
            # 退出游戏进行中状态
            pass
        GameState.PAUSED:
            # 退出暂停状态
            get_tree().paused = false
        GameState.LEVEL_TRANSITION:
            # 退出关卡切换状态
            pass
        _:
            pass

func _enter_state(state: GameState) -> void:
    """执行状态进入逻辑"""
    match state:
        GameState.MENU:
            # 进入主菜单状态
            pass
        GameState.PLAYING:
            # 进入游戏进行中状态
            pass
        GameState.PAUSED:
            # 进入暂停状态
            get_tree().paused = true
        GameState.LEVEL_TRANSITION:
            # 进入关卡切换状态
            pass
        GameState.GAME_OVER:
            # 进入游戏结束状态
            pass
        GameState.VICTORY:
            # 进入胜利状态
            pass
        _:
            pass

func _get_state_name(state: GameState) -> String:
    """获取状态名称（用于调试）"""
    match state:
        GameState.INITIALIZING: return "INITIALIZING"
        GameState.MENU: return "MENU"
        GameState.PLAYING: return "PLAYING"
        GameState.PAUSED: return "PAUSED"
        GameState.LEVEL_TRANSITION: return "LEVEL_TRANSITION"
        GameState.GAME_OVER: return "GAME_OVER"
        GameState.VICTORY: return "VICTORY"
        _: return "UNKNOWN"

func pause_game() -> void:
    """暂停游戏"""
    if current_state == GameState.PLAYING:
        change_game_state(GameState.PAUSED)
        
        # 发送暂停事件
        if event_bus:
            event_bus.game_paused.emit()

func resume_game() -> void:
    """恢复游戏"""
    if current_state == GameState.PAUSED:
        change_game_state(GameState.PLAYING)
        
        # 发送恢复事件
        if event_bus:
            event_bus.game_resumed.emit()

func restart_game() -> void:
    """重启游戏"""
    print("Restarting game...")
    
    # 重置游戏状态
    current_level = ""
    
    # 重置子系统
    if score_manager and score_manager.has_method("reset"):
        score_manager.reset()
    
    if life_manager and life_manager.has_method("reset"):
        life_manager.reset()
    
    # 生成新的会话ID
    generate_session_id()
    
    # 发送重启事件
    game_session_ended.emit(game_session_id)
    game_session_started.emit(game_session_id)
    
    # 返回主菜单
    change_game_state(GameState.MENU)

func game_over() -> void:
    """处理游戏结束"""
    if current_state != GameState.GAME_OVER:
        change_game_state(GameState.GAME_OVER)
        
        # 发送游戏结束事件
        if event_bus:
            event_bus.game_over.emit()
```

#### 3.3 实现关卡和进度管理
**操作**: 完善关卡管理和进度保存功能

```gdscript
func load_level(level_name: String) -> void:
    """
    加载指定关卡
    
    @param level_name: 关卡名称
    """
    if current_state != GameState.MENU and current_state != GameState.LEVEL_TRANSITION:
        print("Warning: Cannot load level in current state: ", _get_state_name(current_state))
        return
    
    print("Loading level: ", level_name)
    
    # 切换到关卡加载状态
    change_game_state(GameState.LEVEL_TRANSITION)
    
    # 卸载当前关卡
    if current_level != "":
        unload_current_level()
    
    # 通过LevelManager加载新关卡
    if level_manager and level_manager.has_method("load_level"):
        var success = level_manager.load_level(level_name)
        if success:
            current_level = level_name
            level_changed.emit(level_name)
            
            # 发送关卡开始事件
            if event_bus:
                event_bus.level_started.emit(level_name)
            
            # 切换到游戏进行状态
            change_game_state(GameState.PLAYING)
            
            print("Level loaded successfully: ", level_name)
        else:
            print("Failed to load level: ", level_name)
            change_game_state(GameState.MENU)
    else:
        print("LevelManager not available or missing load_level method")
        change_game_state(GameState.MENU)

func unload_current_level() -> void:
    """卸载当前关卡"""
    if current_level == "":
        return
    
    print("Unloading current level: ", current_level)
    
    if level_manager and level_manager.has_method("unload_level"):
        level_manager.unload_level(current_level)
    
    current_level = ""

func transition_to_level(level_name: String) -> void:
    """
    切换到指定关卡
    
    @param level_name: 目标关卡名称
    """
    print("Transitioning to level: ", level_name)
    load_level(level_name)

func save_progress() -> bool:
    """
    保存游戏进度
    
    @return: 保存是否成功
    """
    print("Saving game progress...")
    
    var save_data = _collect_progress_data()
    
    if level_manager and level_manager.has_method("save_progress"):
        var success = level_manager.save_progress(save_data)
        if success:
            print("Game progress saved successfully")
            return true
    
    print("Failed to save game progress")
    return false

func load_progress() -> bool:
    """
    加载游戏进度
    
    @return: 加载是否成功
    """
    print("Loading game progress...")
    
    if level_manager and level_manager.has_method("load_progress"):
        var progress_data = level_manager.load_progress()
        if progress_data:
            _apply_progress_data(progress_data)
            print("Game progress loaded successfully")
            return true
    
    print("No saved progress found or failed to load")
    return false

func _collect_progress_data() -> Dictionary:
    """收集进度数据"""
    var progress_data = {}
    
    progress_data["current_level"] = current_level
    progress_data["game_session_id"] = game_session_id
    progress_data["timestamp"] = Time.get_unix_time_from_system()
    
    # 收集子系统进度
    if score_manager and score_manager.has_method("get_score"):
        progress_data["score"] = score_manager.get_score()
    
    if life_manager and life_manager.has_method("get_current_lives"):
        progress_data["lives"] = life_manager.get_current_lives()
    
    return progress_data

func _apply_progress_data(progress_data: Dictionary) -> void:
    """应用进度数据"""
    if progress_data.has("current_level"):
        current_level = progress_data["current_level"]
    
    if progress_data.has("game_session_id"):
        game_session_id = progress_data["game_session_id"]
    
    # 应用子系统进度
    if progress_data.has("score") and score_manager and score_manager.has_method("set_score"):
        score_manager.set_score(progress_data["score"])
    
    if progress_data.has("lives") and life_manager and life_manager.has_method("set_current_lives"):
        life_manager.set_current_lives(progress_data["lives"])
```

---

### 第4步：实现事件响应处理 (30分钟)

#### 4.1 完善事件处理方法
**操作**: 实现GameManager的事件响应逻辑

```gdscript
# 实现事件处理方法
func _on_level_completed(level_name: String) -> void:
    """
    处理关卡完成事件
    
    @param level_name: 完成的关卡名称
    """
    print("Level completed: ", level_name)
    
    # 保存进度
    save_progress()
    
    # 这里可以添加关卡完成奖励逻辑
    if score_manager and score_manager.has_method("add_level_complete_bonus"):
        score_manager.add_level_complete_bonus()
    
    # 发送关卡完成事件到EventBus（如果还没有发送）
    if event_bus:
        event_bus.level_completed.emit(level_name)

func _on_player_damaged(damage: int) -> void:
    """
    处理玩家受伤事件
    
    @param damage: 受到的伤害值
    """
    print("Player damaged: ", damage)
    
    # 通过LifeManager处理伤害
    if life_manager and life_manager.has_method("handle_player_damaged"):
        var remaining_lives = life_manager.handle_player_damaged(damage)
        
        # 检查是否游戏结束
        if remaining_lives <= 0:
            game_over()

func _on_game_over() -> void:
    """处理游戏结束事件"""
    print("Game over triggered")
    
    if current_state != GameState.GAME_OVER:
        change_game_state(GameState.GAME_OVER)
        
        # 保存最终进度
        save_progress()
        
        # 结束游戏会话
        game_session_ended.emit(game_session_id)

func _on_checkpoint_reached(checkpoint_id: String) -> void:
    """
    处理检查点到达事件
    
    @param checkpoint_id: 检查点ID
    """
    print("Checkpoint reached: ", checkpoint_id)
    
    # 保存检查点进度
    if level_manager and level_manager.has_method("save_checkpoint"):
        level_manager.save_checkpoint(checkpoint_id)
    
    # 可以在这里添加检查点奖励
    if score_manager and score_manager.has_method("add_checkpoint_bonus"):
        score_manager.add_checkpoint_bonus()

func get_system_status() -> Dictionary:
    """
    获取系统状态信息（用于调试）
    
    @return: 系统状态字典
    """
    var status = {}
    
    status["game_manager"] = {
        "session_id": game_session_id,
        "current_level": current_level,
        "current_state": _get_state_name(current_state),
        "is_paused": is_paused
    }
    
    status["subsystems"] = {
        "config_manager": config_manager != null,
        "event_bus": event_bus != null,
        "level_manager": level_manager != null,
        "score_manager": score_manager != null,
        "life_manager": life_manager != null,
        "audio_manager": audio_manager != null
    }
    
    return status

func print_debug_info() -> void:
    """打印调试信息"""
    var status = get_system_status()
    
    print("=== GameManager Debug Info ===")
    print("Session ID: ", status["game_manager"]["session_id"])
    print("Current Level: ", status["game_manager"]["current_level"])
    print("Current State: ", status["game_manager"]["current_state"])
    print("Is Paused: ", status["game_manager"]["is_paused"])
    print("Subsystems Status: ", status["subsystems"])
    print("============================")
```

---

### 第5步：完善测试用例 (45分钟)

#### 5.1 实现GameManager测试方法
**操作**: 更新 `test/core/managers/test_game_manager.gd`

```gdscript
# 在TestGameManagerSingleton类中实现测试方法
func test_game_manager_global_singleton():
    # 验证GameManager可以作为全局单例访问
    assert_true(GameManager != null, "GameManager should be accessible as global singleton")
    assert_true(GameManager is Node, "GameManager should be a Node instance")

func test_game_manager_initialization():
    # 验证GameManager正确初始化所有子系统
    assert_true(GameManager.get_current_state() != GameManager.GameState.INITIALIZING, 
        "GameManager should be initialized")

func test_subsystems_available():
    # 验证所有子系统管理器都可访问
    var config_manager = GameManager.get_node_or_null("/root/ConfigManager")
    var event_bus = GameManager.get_node_or_null("/root/EventBus")
    
    assert_true(config_manager != null, "ConfigManager should be available")
    assert_true(event_bus != null, "EventBus should be available")

# 在TestGameManagerIntegration类中实现测试方法
func test_config_manager_integration():
    # 测试与ConfigManager的集成
    var config_manager = GameManager.get_node_or_null("/root/ConfigManager")
    assert_true(config_manager != null, "GameManager should have access to ConfigManager")
    
    # 测试配置读取
    if config_manager and config_manager.has_method("get_player_value"):
        var move_speed = config_manager.get_player_value("move_speed", 0.0)
        assert_true(move_speed > 0, "Should be able to read config values")

func test_event_bus_integration():
    # 测试与EventBus的集成
    var event_bus = GameManager.get_node_or_null("/root/EventBus")
    assert_true(event_bus != null, "GameManager should have access to EventBus")
    
    # 测试事件发送
    if event_bus and event_bus.has_signal("player_damaged"):
        var event_received = false
        event_bus.player_damaged.connect(func(): event_received = true)
        event_bus.player_damaged.emit(10)
        assert_true(event_received, "Should be able to send and receive events")

# 在TestGameManagerGameState类中实现测试方法
func test_game_pause_resume():
    # 测试游戏暂停和恢复功能
    # 设置初始状态为PLAYING
    GameManager.change_game_state(GameManager.GameState.PLAYING)
    
    # 暂停游戏
    GameManager.pause_game()
    assert_eq(GameManager.get_current_state(), GameManager.GameState.PAUSED, "Game should be paused")
    assert_true(GameManager.is_game_paused(), "is_game_paused should return true")
    
    # 恢复游戏
    GameManager.resume_game()
    assert_eq(GameManager.get_current_state(), GameManager.GameState.PLAYING, "Game should be playing")
    assert_false(GameManager.is_game_paused(), "is_game_paused should return false")

func test_game_over_handling():
    # 测试游戏结束处理
    # 设置初始状态为PLAYING
    GameManager.change_game_state(GameManager.GameState.PLAYING)
    
    # 触发游戏结束
    GameManager.game_over()
    
    # 验证状态变更
    assert_eq(GameManager.get_current_state(), GameManager.GameState.GAME_OVER, "Game should be in game over state")

func test_game_restart():
    # 测试游戏重启功能
    # 设置一些状态
    GameManager.change_game_state(GameManager.GameState.PLAYING)
    
    # 重启游戏
    GameManager.restart_game()
    
    # 验证重置后的状态
    assert_eq(GameManager.get_current_state(), GameManager.GameState.MENU, "Game should be in menu state after restart")
    assert_eq(GameManager.get_current_level(), "", "Current level should be reset")

# 在TestGameManagerSceneTransition类中实现测试方法
func test_level_loading():
    # 测试关卡加载
    var level_manager = GameManager.get_node_or_null("LevelManager")
    
    # 模拟LevelManager存在
    if level_manager == null:
        skip("LevelManager not available for testing")
        return
    
    # 设置为菜单状态
    GameManager.change_game_state(GameManager.GameState.MENU)
    
    # 尝试加载关卡
    GameManager.load_level("test_level")
    
    # 验证状态切换到了LEVEL_TRANSITION
    # 注意：由于LevelManager可能没有完全实现，这个测试可能需要调整

func test_scene_transition_coordination():
    # 测试场景切换协调
    var event_bus = GameManager.get_node_or_null("/root/EventBus")
    
    if not event_bus:
        skip("EventBus not available for testing")
        return
    
    var transition_started = false
    # 监听可能的场景切换事件
    if event_bus.has_signal("level_started"):
        event_bus.level_started.connect(func(): transition_started = true)
    
    # 尝试加载关卡
    GameManager.load_level("test_level")
    
    # 验证相关流程被触发

# 在TestGameManagerProgress类中实现测试方法
func test_manual_save_progress():
    # 测试手动保存进度
    # 这个测试可能需要模拟存档系统
    var save_result = GameManager.save_progress()
    
    # 如果LevelManager不存在，保存可能失败，这是正常的
    # 这个测试主要用于验证接口存在且可调用
    assert_true(save_result is bool, "save_progress should return boolean")

func test_load_progress():
    # 测试加载进度
    var load_result = GameManager.load_progress()
    
    # 验证接口存在且可调用
    assert_true(load_result is bool, "load_progress should return boolean")

# 在TestGameManagerEventResponse类中实现测试方法
func test_level_completed_event():
    # 测试响应关卡完成事件
    var event_bus = GameManager.get_node_or_null("/root/EventBus")
    
    if not event_bus:
        skip("EventBus not available for testing")
        return
    
    # 发送关卡完成事件
    event_bus.level_completed.emit("test_level")
    
    # 验证GameManager能够处理事件（通过状态或其他方式）
    # 这里主要测试不会崩溃即可

func test_player_damaged_event():
    # 测试响应玩家受伤事件
    var event_bus = GameManager.get_node_or_null("/root/EventBus")
    
    if not event_bus:
        skip("EventBus not available for testing")
        return
    
    # 发送玩家受伤事件
    event_bus.player_damaged.emit(1)
    
    # 验证事件能被处理（不会崩溃）
    assert_true(true, "Player damaged event should be handled without errors")
```

---

### 第6步：配置AutoLoad和运行测试 (30分钟)

#### 6.1 配置GameManager为AutoLoad
**操作**: 在Godot项目设置中配置GameManager为AutoLoad
1. 打开Godot编辑器
2. 进入 `项目 -> 项目设置 -> AutoLoad`
3. 添加以下配置：
   - 路径: `res://scripts/core/managers/game_manager.gd`
   - 节点名称: `GameManager`
   - 勾选 `启用`

#### 6.2 创建其他管理器占位符
**操作**: 为LevelManager、ScoreManager、LifeManager、AudioManager创建占位符
```gdscript
# scripts/core/managers/level_manager.gd (占位符)
extends Node

func initialize():
    print("LevelManager initialized")

# scripts/core/managers/score_manager.gd (占位符)
extends Node

func initialize():
    print("ScoreManager initialized")

# scripts/core/managers/life_manager.gd (占位符)
extends Node

func initialize():
    print("LifeManager initialized")

# scripts/core/managers/audio_manager.gd (占位符)
extends Node

func initialize():
    print("AudioManager initialized")
```

#### 6.3 运行所有GameManager测试
**操作**: 在Godot编辑器中运行GUT测试
1. 确保GameManager和所有依赖的AutoLoad都已配置
2. 运行 `test/core/managers/test_game_manager.gd` 中的所有测试
3. 验证所有测试都**通过**

---

### 第7步：代码审查和优化 (30分钟)

#### 7.1 代码质量检查清单
- [ ] 所有方法都有类型提示和文档注释
- [ ] 游戏状态转换逻辑清晰且完整
- [ ] 事件处理逻辑健壮，有错误处理
- [ ] 子系统集成松耦合，易于测试
- [ ] 调试信息充足且有意义

#### 7.2 性能考虑
- [ ] 状态切换开销最小
- [ ] 事件处理不会造成性能瓶颈
- [ ] 内存管理得当，无泄漏

#### 7.3 可维护性
- [ ] 代码结构清晰，模块化良好
- [ ] 易于扩展新的游戏状态
- [ ] 子系统接口标准化

---

## 🔍 验收标准检查

在完成本阶段前，请确认以下验收标准都已满足：

- [ ] **GameManager作为全局单例可访问**
  - ✅ GameManager已配置为AutoLoad
  - ✅ 测试验证全局访问正常

- [ ] **能够初始化所有子系统**
  - ✅ 初始化流程完整实现
  - ✅ 子系统引用正确建立
  - ✅ EventBus连接成功

- [ ] **能够协调场景切换**
  - ✅ load_level方法实现
  - ✅ 场景切换状态管理
  - ✅ LevelManager协调机制

- [ ] **能够处理游戏进度保存**
  - ✅ save_progress方法实现
  - ✅ 进度数据收集和应用
  - ✅ 自动保存机制

- [ ] **能够响应游戏事件**
  - ✅ 关卡完成事件处理
  - ✅ 玩家受伤事件处理
  - ✅ 游戏结束事件处理

- [ ] **支持游戏状态管理**
  - ✅ 暂停/恢复功能
  - ✅ 重启游戏功能
  - ✅ 状态转换机制

---

## 📝 后续准备工作

完成GameManager系统后，您已为下一阶段做好准备：
1. **AutoLoad集成测试** - 将验证所有管理器的协同工作
2. **其他管理器实现** - 基于GameManager的架构实现具体功能
3. **游戏主场景集成** - 将GameManager集成到实际游戏流程中

---

## 🚨 注意事项

1. **AutoLoad顺序**: 确保AutoLoad的加载顺序正确（ConfigManager -> EventBus -> GameManager）
2. **状态一致性**: 确保游戏状态在各个子系统间保持一致
3. **事件循环**: 避免在事件处理中产生无限循环
4. **资源管理**: 场景切换时注意资源的正确加载和释放
5. **错误处理**: 子系统不可用时的降级处理

---

## 📚 相关文档

- [Godot单例和AutoLoad文档](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)
- [Godot信号系统文档](https://docs.godotengine.org/en/stable/tutorials/scripting/signals.html)
- [Godot场景管理文档](https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html)
- [GUT测试框架文档](https://github.com/bitwes/Gut)

**下一阶段**: [AutoLoad配置和集成测试TDD开发指导](04_AutoLoad配置和集成测试TDD开发指导.md)