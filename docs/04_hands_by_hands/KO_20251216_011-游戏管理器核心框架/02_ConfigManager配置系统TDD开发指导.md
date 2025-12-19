# ConfigManager配置系统 TDD开发指导

**Story**: KO_20251216_011 游戏管理器核心框架  
**阶段**: 第2阶段 - ConfigManager配置系统  
**预估时间**: 0.5天  
**开发方法**: TDD (测试驱动开发)

---

## 🎯 本阶段目标

实现ConfigManager配置管理系统，负责加载和管理游戏的各种配置参数，支持从文件读取配置并提供默认值机制。

### 验收标准
- [ ] ConfigManager作为全局单例可访问
- [ ] 能够从配置文件加载玩家和游戏参数
- [ ] 支持默认值机制，配置不存在时返回默认值
- [ ] 支持配置文件的重新加载
- [ ] 能够保存配置到文件

---

## 📋 TDD实施步骤

### 第1步：创建测试环境 (15分钟)

#### 1.1 创建测试配置文件
**操作**: 创建测试配置目录和文件
```bash
# 创建测试配置目录
mkdir -p test/test_configs

# 创建测试玩家配置文件
# test/test_configs/test_player_config.cfg
[default_profile]
name = "Test Player"
move_speed = 150.0
jump_velocity = -320.0
acceleration = 300.0
floor_friction = 1200.0
air_friction = 1800.0
is_debug = false

[graphics]
resolution_x = 1920
resolution_y = 1080
fullscreen = false
vsync = true

[gameplay]
default_lives = 3
difficulty = "normal"
```

#### 1.2 创建ConfigManager测试文件框架
**操作**: 创建文件 `test/core/managers/test_config_manager.gd`

```gdscript
# test/core/managers/test_config_manager.gd
extends GutTest

# 测试前准备
func before_each():
    # 每个测试前重置ConfigManager状态
    pass

func after_each():
    # 每个测试后清理
    pass

# ============================================================================
# 测试类1: ConfigManager单例和初始化
# ============================================================================
class TestConfigManagerSingleton:
    func test_config_manager_global_singleton():
        # TODO: 验证ConfigManager可以作为全局单例访问
        # 预期结果: ConfigManager != null 且 ConfigManager is Node
        pass
    
    func test_config_manager_initialization():
        # TODO: 验证ConfigManager正确初始化
        # 预期结果: 配置文件被加载，内部状态正确
        pass

# ============================================================================
# 测试类2: 配置文件加载和读取
# ============================================================================
class TestConfigManagerLoading:
    func test_load_player_config():
        # TODO: 测试加载玩家配置文件
        # 步骤:
        # 1. 创建测试配置文件
        # 2. 加载配置
        # 3. 验证配置值被正确读取
        pass
    
    func test_load_game_config():
        # TODO: 测试加载游戏配置文件
        # 步骤:
        # 1. 创建测试游戏配置
        # 2. 加载配置
        # 3. 验证游戏配置值
        pass
    
    func test_invalid_config_file():
        # TODO: 测试无效配置文件的处理
        # 步骤:
        # 1. 提供无效的配置文件路径
        # 2. 尝试加载
        # 3. 验证使用默认值
        pass

# ============================================================================
# 测试类3: 默认值机制
# ============================================================================
class TestConfigManagerDefaults:
    func test_default_value_fallback():
        # TODO: 测试配置不存在时返回默认值
        # 步骤:
        # 1. 请求不存在的配置项
        # 2. 验证返回指定的默认值
        pass
    
    func test_different_type_defaults():
        # TODO: 测试不同类型的默认值
        # 步骤:
        # 1. 测试字符串默认值
        # 2. 测试数值默认值
        # 3. 测试布尔默认值
        pass

# ============================================================================
# 测试类4: 配置保存和重新加载
# ============================================================================
class TestConfigManagerPersistence:
    func test_save_player_config():
        # TODO: 测试保存玩家配置
        # 步骤:
        # 1. 修改配置值
        # 2. 保存配置到文件
        # 3. 验证文件被正确写入
        pass
    
    func test_reload_configs():
        # TODO: 测试重新加载配置
        # 步骤:
        # 1. 修改配置文件
        # 2. 调用重新加载
        # 3. 验证新配置被读取
        pass

# ============================================================================
# 测试类5: 配置访问接口
# ============================================================================
class TestConfigManagerInterface:
    func test_get_player_value_interface():
        # TODO: 测试玩家配置访问接口
        # 预期: get_player_value(key, default) 正确工作
        pass
    
    func test_get_game_value_interface():
        # TODO: 测试游戏配置访问接口
        # 预期: get_game_value(key, default) 正确工作
        pass
    
    func test_set_player_value_interface():
        # TODO: 测试设置玩家配置值接口
        # 步骤:
        # 1. 设置新值
        # 2. 验证值被正确更新
        pass
```

#### 1.3 运行测试验证失败
**操作**: 在Godot编辑器中运行GUT测试
1. 确保ConfigManager测试文件已创建
2. 运行测试，确认所有测试都**失败**（这是TDD的正确状态）

---

### 第2步：实现ConfigManager基础框架 (30分钟)

#### 2.1 创建ConfigManager类框架
**操作**: 创建文件 `scripts/core/managers/config_manager.gd`

```gdscript
# scripts/core/managers/config_manager.gd
extends Node
class_name ConfigManager

# ============================================================================
# 常量定义 - 配置文件路径
# ============================================================================

## 玩家配置文件路径
const PLAYER_CONFIG_PATH = "res://configs/player_config.cfg"

## 游戏配置文件路径  
const GAME_CONFIG_PATH = "res://configs/game_config.cfg"

## 用户配置保存路径
const USER_CONFIG_PATH = "user://player_config.cfg"

# ============================================================================
# 私有成员变量
# ============================================================================

## 玩家配置对象
var player_config: ConfigFile

## 游戏配置对象
var game_config: ConfigFile

## 是否已初始化
var _is_initialized: bool = false

## 配置变更事件
signal config_changed(config_type: String, key: String, value: Variant)

# ============================================================================
# 初始化方法
# ============================================================================

func _init():
    """ConfigManager初始化"""
    # TODO: 初始化配置管理器
    pass

func _ready():
    """节点准备完成"""
    # TODO: 加载所有配置文件
    pass

func initialize() -> bool:
    """
    初始化配置管理器
    
    @return: 初始化是否成功
    """
    # TODO: 实现初始化逻辑
    # 1. 创建ConfigFile实例
    # 2. 加载玩家配置
    # 3. 加载游戏配置
    # 4. 设置初始化标志
    return false

# ============================================================================
# 配置文件加载方法
# ============================================================================

func load_all_configs() -> bool:
    """
    加载所有配置文件
    
    @return: 加载是否成功
    """
    # TODO: 实现配置文件加载
    return false

func load_player_config() -> bool:
    """
    加载玩家配置文件
    
    @return: 加载是否成功
    """
    # TODO: 实现玩家配置加载逻辑
    return false

func load_game_config() -> bool:
    """
    加载游戏配置文件
    
    @return: 加载是否成功
    """
    # TODO: 实现游戏配置加载逻辑
    return false

# ============================================================================
# 配置访问接口
# ============================================================================

func get_player_value(key: String, section: String = "player", default_value: Variant = null) -> Variant:
    """
    获取玩家配置值
    
    @param key: 配置键
    @param section: 配置节，默认为"player"
    @param default_value: 默认值
    @return: 配置值
    """
    # TODO: 实现玩家配置值获取
    return default_value

func get_game_value(key: String, section: String = "game", default_value: Variant = null) -> Variant:
    """
    获取游戏配置值
    
    @param key: 配置键
    @param section: 配置节，默认为"game"  
    @param default_value: 默认值
    @return: 配置值
    """
    # TODO: 实现游戏配置值获取
    return default_value

func set_player_value(key: String, value: Variant, section: String = "player") -> void:
    """
    设置玩家配置值
    
    @param key: 配置键
    @param value: 配置值
    @param section: 配置节，默认为"player"
    """
    # TODO: 实现玩家配置值设置
    pass

func set_game_value(key: String, value: Variant, section: String = "game") -> void:
    """
    设置游戏配置值
    
    @param key: 配置键  
    @param value: 配置值
    @param section: 配置节，默认为"game"
    """
    # TODO: 实现游戏配置值设置
    pass

# ============================================================================
# 配置保存方法
# ============================================================================

func save_player_config() -> bool:
    """
    保存玩家配置到文件
    
    @return: 保存是否成功
    """
    # TODO: 实现玩家配置保存
    return false

func save_game_config() -> bool:
    """
    保存游戏配置到文件
    
    @return: 保存是否成功
    """
    # TODO: 实现游戏配置保存
    return false

func save_all_configs() -> bool:
    """
    保存所有配置文件
    
    @return: 保存是否成功
    """
    # TODO: 实现所有配置保存
    return false

# ============================================================================
# 配置重新加载方法
# ============================================================================

func reload_configs() -> bool:
    """
    重新加载所有配置文件
    
    @return: 重新加载是否成功
    """
    # TODO: 实现配置重新加载
    return false

func reload_player_config() -> bool:
    """
    重新加载玩家配置文件
    
    @return: 重新加载是否成功
    """
    # TODO: 实现玩家配置重新加载
    return false

func reload_game_config() -> bool:
    """
    重新加载游戏配置文件
    
    @return: 重新加载是否成功
    """
    # TODO: 实现游戏配置重新加载
    return false

# ============================================================================
# 实用方法
# ============================================================================

func is_initialized() -> bool:
    """
    检查配置管理器是否已初始化
    
    @return: 是否已初始化
    """
    return _is_initialized

func get_all_player_values(section: String = "player") -> Dictionary:
    """
    获取指定节的所有玩家配置值
    
    @param section: 配置节
    @return: 配置值字典
    """
    # TODO: 实现获取所有玩家配置值
    return {}

func get_all_game_values(section: String = "game") -> Dictionary:
    """
    获取指定节的所有游戏配置值
    
    @param section: 配置节
    @return: 配置值字典
    """
    # TODO: 实现获取所有游戏配置值
    return {}
```

#### 2.2 创建默认配置文件
**操作**: 创建默认配置文件目录和文件
```bash
# 创建配置文件目录
mkdir -p configs

# 创建默认玩家配置文件
# configs/player_config.cfg
[player]
name = "Knight"
move_speed = 150.0
acceleration = 300.0
floor_friction = 1200.0
air_friction = 1800.0
jump_velocity = -320.0
double_jump_velocity = -280.0
is_debug = false

[controls]
move_left_key = "A"
move_right_key = "D"
jump_key = "Space"
stomp_key = "S"

[graphics]
camera_smoothing = 5.0
screen_shake_enabled = true
particle_effects_enabled = true
```

#### 2.3 配置AutoLoad单例
**操作**: 在Godot项目设置中配置ConfigManager为AutoLoad
1. 打开Godot编辑器
2. 进入 `项目 -> 项目设置 -> AutoLoad`
3. 添加以下配置：
   - 路径: `res://scripts/core/managers/config_manager.gd`
   - 节点名称: `ConfigManager`
   - 勾选 `启用`

---

### 第3步：实现ConfigManager核心功能 (45分钟)

#### 3.1 实现初始化和加载方法
**操作**: 完善 `scripts/core/managers/config_manager.gd` 的初始化逻辑

```gdscript
# 实现初始化方法
func _init():
    """ConfigManager初始化"""
    player_config = ConfigFile.new()
    game_config = ConfigFile.new()

func _ready():
    """节点准备完成"""
    initialize()

func initialize() -> bool:
    """
    初始化配置管理器
    
    @return: 初始化是否成功
    """
    if _is_initialized:
        return true
    
    var success = load_all_configs()
    if success:
        _is_initialized = true
        print("ConfigManager initialized successfully")
    else:
        print("ConfigManager initialization failed")
    
    return success

func load_all_configs() -> bool:
    """
    加载所有配置文件
    
    @return: 加载是否成功
    """
    var player_success = load_player_config()
    var game_success = load_game_config()
    
    return player_success and game_success

func load_player_config() -> bool:
    """
    加载玩家配置文件
    
    @return: 加载是否成功
    """
    # 首先尝试从用户目录加载（自定义配置）
    if FileAccess.file_exists(USER_CONFIG_PATH):
        var load_result = player_config.load(USER_CONFIG_PATH)
        if load_result == OK:
            print("Player config loaded from: ", USER_CONFIG_PATH)
            return true
    
    # 如果用户配置不存在，使用默认配置
    if FileAccess.file_exists(PLAYER_CONFIG_PATH):
        var load_result = player_config.load(PLAYER_CONFIG_PATH)
        if load_result == OK:
            print("Player config loaded from: ", PLAYER_CONFIG_PATH)
            return true
    else:
        print("Warning: Player config file not found at: ", PLAYER_CONFIG_PATH)
    
    # 加载失败，使用空配置
    print("Using empty player config (will use defaults)")
    return true

func load_game_config() -> bool:
    """
    加载游戏配置文件
    
    @return: 加载是否成功
    """
    if FileAccess.file_exists(GAME_CONFIG_PATH):
        var load_result = game_config.load(GAME_CONFIG_PATH)
        if load_result == OK:
            print("Game config loaded from: ", GAME_CONFIG_PATH)
            return true
    else:
        print("Warning: Game config file not found at: ", GAME_CONFIG_PATH)
    
    # 加载失败，使用空配置
    print("Using empty game config (will use defaults)")
    return true
```

#### 3.2 实现配置访问接口
**操作**: 完善配置访问方法

```gdscript
func get_player_value(key: String, section: String = "player", default_value: Variant = null) -> Variant:
    """
    获取玩家配置值
    
    @param key: 配置键
    @param section: 配置节，默认为"player"
    @param default_value: 默认值
    @return: 配置值
    """
    if not _is_initialized:
        print("Warning: ConfigManager not initialized, returning default value")
        return default_value
    
    if player_config.has_section_key(section, key):
        return player_config.get_value(section, key)
    else:
        return default_value

func get_game_value(key: String, section: String = "game", default_value: Variant = null) -> Variant:
    """
    获取游戏配置值
    
    @param key: 配置键
    @param section: 配置节，默认为"game"  
    @param default_value: 默认值
    @return: 配置值
    """
    if not _is_initialized:
        print("Warning: ConfigManager not initialized, returning default value")
        return default_value
    
    if game_config.has_section_key(section, key):
        return game_config.get_value(section, key)
    else:
        return default_value

func set_player_value(key: String, value: Variant, section: String = "player") -> void:
    """
    设置玩家配置值
    
    @param key: 配置键
    @param value: 配置值
    @param section: 配置节，默认为"player"
    """
    if not _is_initialized:
        print("Warning: ConfigManager not initialized, cannot set value")
        return
    
    var old_value = null
    if player_config.has_section_key(section, key):
        old_value = player_config.get_value(section, key)
    
    player_config.set_value(section, key, value)
    
    # 发送配置变更事件
    config_changed.emit("player", key, value)
    
    if old_value != value:
        print("Player config updated: ", section, ".", key, " = ", value)

func set_game_value(key: String, value: Variant, section: String = "game") -> void:
    """
    设置游戏配置值
    
    @param key: 配置键  
    @param value: 配置值
    @param section: 配置节，默认为"game"
    """
    if not _is_initialized:
        print("Warning: ConfigManager not initialized, cannot set value")
        return
    
    var old_value = null
    if game_config.has_section_key(section, key):
        old_value = game_config.get_value(section, key)
    
    game_config.set_value(section, key, value)
    
    # 发送配置变更事件
    config_changed.emit("game", key, value)
    
    if old_value != value:
        print("Game config updated: ", section, ".", key, " = ", value)
```

#### 3.3 实现保存和重新加载方法
**操作**: 完善保存和重新加载功能

```gdscript
func save_player_config() -> bool:
    """
    保存玩家配置到文件
    
    @return: 保存是否成功
    """
    if not _is_initialized:
        print("Warning: ConfigManager not initialized, cannot save")
        return false
    
    var save_result = player_config.save(USER_CONFIG_PATH)
    if save_result == OK:
        print("Player config saved to: ", USER_CONFIG_PATH)
        return true
    else:
        print("Error: Failed to save player config, error code: ", save_result)
        return false

func save_game_config() -> bool:
    """
    保存游戏配置文件
    
    @return: 保存是否成功
    """
    if not _is_initialized:
        print("Warning: ConfigManager not initialized, cannot save")
        return false
    
    var save_result = game_config.save(GAME_CONFIG_PATH)
    if save_result == OK:
        print("Game config saved to: ", GAME_CONFIG_PATH)
        return true
    else:
        print("Error: Failed to save game config, error code: ", save_result)
        return false

func reload_configs() -> bool:
    """
    重新加载所有配置文件
    
    @return: 重新加载是否成功
    """
    print("Reloading all configurations...")
    _is_initialized = false
    return load_all_configs()

func get_all_player_values(section: String = "player") -> Dictionary:
    """
    获取指定节的所有玩家配置值
    
    @param section: 配置节
    @return: 配置值字典
    """
    var values = {}
    
    if not _is_initialized or not player_config.has_section(section):
        return values
    
    for key in player_config.get_section_keys(section):
        values[key] = player_config.get_value(section, key)
    
    return values
```

---

### 第4步：完善测试用例 (30分钟)

#### 4.1 实现ConfigManager测试方法
**操作**: 更新 `test/core/managers/test_config_manager.gd`

```gdscript
# 在TestConfigManagerSingleton类中实现测试方法
func test_config_manager_global_singleton():
    # 验证ConfigManager可以作为全局单例访问
    assert_true(ConfigManager != null, "ConfigManager should be accessible as global singleton")
    assert_true(ConfigManager is Node, "ConfigManager should be a Node instance")

func test_config_manager_initialization():
    # 验证ConfigManager正确初始化
    assert_true(ConfigManager.is_initialized(), "ConfigManager should be initialized")

# 在TestConfigManagerLoading类中实现测试方法
func test_load_player_config():
    # 测试加载玩家配置文件
    var move_speed = ConfigManager.get_player_value("move_speed", 100.0)
    assert_eq(move_speed, 150.0, "Move speed should be loaded from config")
    
    var jump_velocity = ConfigManager.get_player_value("jump_velocity", -300.0)
    assert_eq(jump_velocity, -320.0, "Jump velocity should be loaded from config")
    
    var is_debug = ConfigManager.get_player_value("is_debug", true)
    assert_false(is_debug, "Is debug should be false from config")

func test_invalid_config_file():
    # 测试无效配置文件的处理
    var non_existent_value = ConfigManager.get_player_value("non_existent_key", "default")
    assert_eq(non_existent_value, "default", "Should return default value for non-existent key")

# 在TestConfigManagerDefaults类中实现测试方法
func test_default_value_fallback():
    # 测试配置不存在时返回默认值
    var default_string = ConfigManager.get_player_value("fake_string_key", "test_default")
    assert_eq(default_string, "test_default", "Should return string default value")
    
    var default_int = ConfigManager.get_player_value("fake_int_key", 42)
    assert_eq(default_int, 42, "Should return int default value")
    
    var default_bool = ConfigManager.get_player_value("fake_bool_key", true)
    assert_true(default_bool, "Should return bool default value")

func test_different_type_defaults():
    # 测试不同类型的默认值
    var string_val = ConfigManager.get_player_value("name", "Anonymous")
    assert_true(string_val is String, "Should return String type")
    
    var float_val = ConfigManager.get_player_value("move_speed", 100.0)
    assert_true(float_val is float, "Should return float type")
    
    var bool_val = ConfigManager.get_player_value("is_debug", false)
    assert_true(bool_val is bool, "Should return bool type")

# 在TestConfigManagerPersistence类中实现测试方法
func test_save_player_config():
    # 测试保存玩家配置
    var test_value = "TestPlayer"
    
    # 设置新值
    ConfigManager.set_player_value("test_name", test_value)
    
    # 保存配置
    var save_result = ConfigManager.save_player_config()
    assert_true(save_result, "Config save should succeed")
    
    # 验证值被设置
    assert_eq(ConfigManager.get_player_value("test_name", ""), test_value, "Value should be set correctly")

func test_reload_configs():
    # 测试重新加载配置
    # 修改配置值
    ConfigManager.set_player_value("reload_test", "before_reload")
    
    # 重新加载
    var reload_result = ConfigManager.reload_configs()
    assert_true(reload_result, "Reload should succeed")
    
    # 验证重新加载后的状态
    assert_true(ConfigManager.is_initialized(), "Should still be initialized after reload")

# 在TestConfigManagerInterface类中实现测试方法
func test_get_player_value_interface():
    # 测试玩家配置访问接口
    var move_speed = ConfigManager.get_player_value("move_speed", 100.0, "player")
    assert_eq(move_speed, 150.0, "Should get player move speed correctly")
    
    # 测试自定义节
    var controls_key = ConfigManager.get_player_value("move_left_key", "", "controls")
    assert_eq(controls_key, "A", "Should get control key from controls section")

func test_get_game_value_interface():
    # 测试游戏配置访问接口
    # 这个测试依赖于game_config.cfg的存在
    var test_value = ConfigManager.get_game_value("test_key", "game_default")
    assert_eq(test_value, "game_default", "Should return default value for game config")

func test_set_player_value_interface():
    # 测试设置玩家配置值接口
    var test_key = "set_test_key"
    var test_value = "test_value"
    
    # 设置值
    ConfigManager.set_player_value(test_key, test_value)
    
    # 验证值被正确设置
    var retrieved_value = ConfigManager.get_player_value(test_key, "")
    assert_eq(retrieved_value, test_value, "Value should be correctly set and retrieved")
```

---

### 第5步：运行测试和验证 (30分钟)

#### 5.1 运行所有ConfigManager测试
**操作**: 在Godot编辑器中运行GUT测试
1. 确保ConfigManager已配置为AutoLoad
2. 确保配置文件 `configs/player_config.cfg` 已创建
3. 运行 `test/core/managers/test_config_manager.gd` 中的所有测试
4. 验证所有测试都**通过**

#### 5.2 手动验证ConfigManager功能
**操作**: 创建临时测试场景
```gdscript
# scripts/test/config_manager_test_script.gd (临时测试脚本)
extends Node

func _ready():
    print("=== ConfigManager 测试开始 ===")
    
    # 测试基本配置读取
    var move_speed = ConfigManager.get_player_value("move_speed", 0.0)
    print("移动速度: ", move_speed)
    
    # 测试默认值
    var fake_value = ConfigManager.get_player_value("fake_key", "default_value")
    print("默认值测试: ", fake_value)
    
    # 测试设置新值
    ConfigManager.set_player_value("test_runtime_key", "runtime_value")
    var runtime_value = ConfigManager.get_player_value("test_runtime_key", "")
    print("运行时设置值: ", runtime_value)
    
    # 测试配置变更事件
    ConfigManager.config_changed.connect(_on_config_changed)
    ConfigManager.set_player_value("event_test_key", "event_value")
    
    print("=== ConfigManager 测试完成 ===")

func _on_config_changed(config_type: String, key: String, value: Variant):
    print("配置变更事件: ", config_type, ".", key, " = ", value)
```

---

### 第6步：代码审查和优化 (30分钟)

#### 6.1 代码质量检查清单
- [ ] 所有方法都有类型提示
- [ ] 文档注释完整且准确
- [ ] 没有硬编码的配置键
- [ ] 错误处理逻辑完善
- [ ] 性能考虑（避免频繁文件I/O）

#### 6.2 性能优化建议
- [ ] 配置值缓存机制（如果需要）
- [ ] 延迟加载配置文件
- [ ] 配置变更事件批量处理

#### 6.3 安全性考虑
- [ ] 配置文件路径安全检查
- [ ] 输入值验证
- [ ] 文件权限检查

---

## 🔍 验收标准检查

在完成本阶段前，请确认以下验收标准都已满足：

- [ ] **ConfigManager作为全局单例可访问**
  - ✅ ConfigManager已配置为AutoLoad
  - ✅ 测试验证全局访问正常

- [ ] **能够从配置文件加载玩家和游戏参数**
  - ✅ player_config.cfg正确加载
  - ✅ 所有配置项都可以正确读取

- [ ] **支持默认值机制，配置不存在时返回默认值**
  - ✅ get_*_value方法支持默认值
  - ✅ 测试验证默认值返回机制

- [ ] **支持配置文件的重新加载**
  - ✅ reload_*_config方法实现
  - ✅ 测试验证重新加载功能

- [ ] **能够保存配置到文件**
  - ✅ save_*_config方法实现
  - ✅ 配置变更事件机制

---

## 📝 后续准备工作

完成ConfigManager系统后，您已为下一阶段做好准备：
1. **GameManager** - 将使用ConfigManager加载游戏配置
2. **LevelManager** - 将使用ConfigManager管理关卡配置
3. **其他系统** - 都将通过ConfigManager获取配置参数

---

## 🚨 注意事项

1. **配置文件格式**: 确保配置文件符合INI格式规范
2. **路径处理**: 注意res://和user://路径的区别
3. **错误处理**: 配置文件加载失败时应该有适当的降级机制
4. **性能考虑**: 避免在游戏循环中频繁访问配置
5. **线程安全**: ConfigManager不是线程安全的，避免在多线程环境中使用

---

## 📚 相关文档

- [Godot ConfigFile文档](https://docs.godotengine.org/en/stable/classes/class_configfile.html)
- [Godot文件系统文档](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html)
- [GUT测试框架文档](https://github.com/bitwes/Gut)

**下一阶段**: [GameManager核心框架TDD开发指导](03_GameManager核心框架TDD开发指导.md)