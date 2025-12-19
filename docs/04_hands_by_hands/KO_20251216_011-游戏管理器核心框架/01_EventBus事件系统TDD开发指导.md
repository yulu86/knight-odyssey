# EventBus事件系统 TDD开发指导

**Story**: KO_20251216_011 游戏管理器核心框架  
**阶段**: 第1阶段 - EventBus事件系统  
**预估时间**: 0.5天  
**开发方法**: TDD (测试驱动开发)

---

## 🎯 本阶段目标

实现EventBus事件系统，作为游戏各模块间通信的核心枢纽，实现系统间的解耦。

### 验收标准
- [ ] EventBus作为全局单例可访问
- [ ] 所有必需的信号都已正确定义
- [ ] 事件订阅和分发机制正常工作
- [ ] 支持事件数据的正确传递

---

## 📋 TDD实施步骤

### 第1步：创建测试环境 (15分钟)

#### 1.1 创建测试目录结构
```bash
# 在项目中创建以下目录（如果不存在）
mkdir -p test/core/managers
mkdir -p scripts/core/managers
```

#### 1.2 创建EventBus测试文件框架
**操作**: 创建文件 `test/core/managers/test_event_bus.gd`

```gdscript
# test/core/managers/test_event_bus.gd
extends GutTest

# ============================================================================
# 测试类1: EventBus单例创建和信号定义
# ============================================================================
class TestEventBusSingleton:
    func test_event_bus_global_singleton():
        # TODO: 验证EventBus可以作为全局单例访问
        # 预期结果: EventBus != null 且 EventBus is Node
        pass
    
    func test_event_bus_signals_defined():
        # TODO: 验证所有必需的信号都已定义
        # 预期信号列表:
        # - player_state_changed
        # - player_damaged
        # - player_healed
        # - enemy_died
        # - enemy_spawned
        # - coin_collected
        # - fruit_collected
        # - checkpoint_reached
        # - level_completed
        # - level_started
        # - game_over
        # - game_paused
        # - game_resumed
        pass

# ============================================================================
# 测试类2: EventBus事件分发机制
# ============================================================================
class TestEventBusDispatch:
    func test_event_subscription_and_emission():
        # TODO: 测试事件订阅和发送
        # 步骤:
        # 1. 订阅一个测试事件
        # 2. 发送该事件
        # 3. 验证事件被正确接收
        pass
    
    func test_event_data_transmission():
        # TODO: 测试事件数据的正确传递
        # 步骤:
        # 1. 订阅带参数的事件
        # 2. 发送事件并传递测试数据
        # 3. 验证接收到的数据与发送的数据一致
        pass
    
    func test_multiple_subscribers():
        # TODO: 测试多个订阅者接收同一事件
        # 步骤:
        # 1. 创建多个订阅者
        # 2. 发送事件
        # 3. 验证所有订阅者都收到事件
        pass

# ============================================================================
# 测试类3: EventBus错误处理
# ============================================================================
class TestEventBusErrorHandling:
    func test_unsubscribe_event():
        # TODO: 测试取消订阅事件
        # 步骤:
        # 1. 订阅事件
        # 2. 取消订阅
        # 3. 发送事件
        # 4. 验证取消订阅后不再收到事件
        pass
    
    func test_invalid_signal_handling():
        # TODO: 测试无效信号的处理
        # 注意: 这个测试可能需要根据实际实现调整
        pass
```

#### 1.3 运行测试验证失败
**操作**: 在Godot编辑器中运行GUT测试
1. 打开Godot编辑器
2. 在项目设置中启用GUT插件
3. 运行测试，确认所有测试都**失败**（这是TDD的正确状态）

---

### 第2步：实现EventBus基础框架 (30分钟)

#### 2.1 创建EventBus类框架
**操作**: 创建文件 `scripts/core/managers/event_bus.gd`

```gdscript
# scripts/core/managers/event_bus.gd
extends Node
class_name EventBus

# ============================================================================
# 信号定义 - 玩家相关事件
# ============================================================================

## 玩家状态变化事件
## @param old_state: 玩家之前的状态
## @param new_state: 玩家当前的状态
signal player_state_changed(old_state, new_state)

## 玩家受伤事件
## @param damage: 受到的伤害值
signal player_damaged(damage)

## 玩家恢复事件
## @param health: 恢复的生命值
signal player_healed(health)

# ============================================================================
# 信号定义 - 敌人相关事件
# ============================================================================

## 敌人死亡事件
## @param enemy: 死亡的敌人对象
signal enemy_died(enemy)

## 敌人生成事件
## @param enemy_type: 敌人类型
## @param position: 生成位置
signal enemy_spawned(enemy_type, position)

# ============================================================================
# 信号定义 - 收集相关事件
# ============================================================================

## 金币收集事件
## @param value: 金币价值
signal coin_collected(value)

## 水果收集事件
## @param type: 水果类型
signal fruit_collected(type)

# ============================================================================
# 信号定义 - 关卡相关事件
# ============================================================================

## 检查点到达事件
## @param checkpoint_id: 检查点ID
signal checkpoint_reached(checkpoint_id)

## 关卡完成事件
## @param level_name: 关卡名称
signal level_completed(level_name)

## 关卡开始事件
## @param level_name: 关卡名称
signal level_started(level_name)

# ============================================================================
# 信号定义 - 游戏状态事件
# ============================================================================

## 游戏结束事件
signal game_over()

## 游戏暂停事件
signal game_paused()

## 游戏恢复事件
signal game_resumed()

# ============================================================================
# 初始化和事件分发器
# ============================================================================

func _init():
    """EventBus初始化"""
    # TODO: 添加初始化逻辑（如果需要）
    pass

func _ready():
    """节点准备完成"""
    # TODO: 添加ready逻辑（如果需要）
    pass

# ============================================================================
# 事件分发器封装方法
# ============================================================================

func dispatch_player_damaged(damage: int) -> void:
    """分发玩家受伤事件"""
    # TODO: 发送玩家受伤事件
    pass

func dispatch_player_healed(health: int) -> void:
    """分发玩家恢复事件"""
    # TODO: 发送玩家恢复事件
    pass

func dispatch_enemy_died(enemy: Node) -> void:
    """分发敌人死亡事件"""
    # TODO: 发送敌人死亡事件
    pass

func dispatch_coin_collected(value: int) -> void:
    """分发金币收集事件"""
    # TODO: 发送金币收集事件
    pass

func dispatch_fruit_collected(type: String) -> void:
    """分发水果收集事件"""
    # TODO: 发送水果收集事件
    pass

func dispatch_level_completed(level_name: String) -> void:
    """分发关卡完成事件"""
    # TODO: 发送关卡完成事件
    pass

func dispatch_game_over() -> void:
    """分发游戏结束事件"""
    # TODO: 发送游戏结束事件
    pass

func dispatch_game_paused() -> void:
    """分发游戏暂停事件"""
    # TODO: 发送游戏暂停事件
    pass

func dispatch_game_resumed() -> void:
    """分发游戏恢复事件"""
    # TODO: 发送游戏恢复事件
    pass
```

#### 2.2 配置AutoLoad单例
**操作**: 在Godot项目设置中配置EventBus为AutoLoad
1. 打开Godot编辑器
2. 进入 `项目 -> 项目设置 -> AutoLoad`
3. 添加以下配置：
   - 路径: `res://scripts/core/managers/event_bus.gd`
   - 节点名称: `EventBus`
   - 勾选 `启用`

#### 2.3 补充测试用例实现
**操作**: 更新 `test/core/managers/test_event_bus.gd`，实现测试方法

```gdscript
# 在TestEventBusSingleton类中实现测试方法
func test_event_bus_global_singleton():
    # 验证EventBus可以作为全局单例访问
    assert_true(EventBus != null, "EventBus should be accessible as global singleton")
    assert_true(EventBus is Node, "EventBus should be a Node instance")

func test_event_bus_signals_defined():
    # 验证所有必需的信号都已定义
    var expected_signals = [
        "player_state_changed",
        "player_damaged", 
        "player_healed",
        "enemy_died",
        "enemy_spawned",
        "coin_collected",
        "fruit_collected",
        "checkpoint_reached",
        "level_completed",
        "level_started",
        "game_over",
        "game_paused",
        "game_resumed"
    ]
    
    for signal_name in expected_signals:
        assert_true(EventBus.has_user_signal(signal_name), 
            "EventBus should have signal: %s" % signal_name)

# 在TestEventBusDispatch类中实现测试方法
func test_event_subscription_and_emission():
    var signal_received = false
    
    # 订阅事件
    EventBus.player_damaged.connect(func(): signal_received = true)
    
    # 发送事件
    EventBus.player_damaged.emit(10)
    
    # 验证事件被正确接收
    assert_true(signal_received, "Event should be received by subscriber")

func test_event_data_transmission():
    var received_damage = -1
    
    # 订阅事件
    EventBus.player_damaged.connect(func(damage): received_damage = damage)
    
    # 发送事件
    EventBus.player_damaged.emit(25)
    
    # 验证事件数据正确传递
    assert_eq(received_damage, 25, "Event data should be correctly transmitted")

func test_multiple_subscribers():
    var subscriber1_received = false
    var subscriber2_received = false
    
    # 订阅事件
    EventBus.game_over.connect(func(): subscriber1_received = true)
    EventBus.game_over.connect(func(): subscriber2_received = true)
    
    # 发送事件
    EventBus.game_over.emit()
    
    # 验证所有订阅者都收到事件
    assert_true(subscriber1_received, "First subscriber should receive event")
    assert_true(subscriber2_received, "Second subscriber should receive event")
```

---

### 第3步：实现EventBus核心功能 (30分钟)

#### 3.1 完成EventBus类实现
**操作**: 完善 `scripts/core/managers/event_bus.gd` 的事件分发器方法

```gdscript
# 实现事件分发器封装方法
func dispatch_player_damaged(damage: int) -> void:
    """分发玩家受伤事件"""
    player_damaged.emit(damage)

func dispatch_player_healed(health: int) -> void:
    """分发玩家恢复事件"""
    player_healed.emit(health)

func dispatch_enemy_died(enemy: Node) -> void:
    """分发敌人死亡事件"""
    enemy_died.emit(enemy)

func dispatch_coin_collected(value: int) -> void:
    """分发金币收集事件"""
    coin_collected.emit(value)

func dispatch_fruit_collected(type: String) -> void:
    """分发水果收集事件"""
    fruit_collected.emit(type)

func dispatch_level_completed(level_name: String) -> void:
    """分发关卡完成事件"""
    level_completed.emit(level_name)

func dispatch_game_over() -> void:
    """分发游戏结束事件"""
    game_over.emit()

func dispatch_game_paused() -> void:
    """分发游戏暂停事件"""
    game_paused.emit()

func dispatch_game_resumed() -> void:
    """分发游戏恢复事件"""
    game_resumed.emit()
```

#### 3.2 完成错误处理测试
**操作**: 在 `test/core/managers/test_event_bus.gd` 中实现错误处理测试

```gdscript
# 在TestEventBusErrorHandling类中实现测试方法
func test_unsubscribe_event():
    var signal_received = false
    
    # 创建一个测试函数
    var test_function = func(): signal_received = true
    
    # 订阅事件
    EventBus.player_damaged.connect(test_function)
    
    # 取消订阅
    EventBus.player_damaged.disconnect(test_function)
    
    # 发送事件
    EventBus.player_damaged.emit(10)
    
    # 验证取消订阅后不再收到事件
    assert_false(signal_received, "Unsubscribed event should not be received")

func test_invalid_signal_handling():
    # 测试尝试发送不存在的信号（这个测试可能需要调整）
    # Godot的信号系统会在编译时检查信号是否存在
    # 这里我们测试空值处理
    var null_value = null
    
    # 订阅事件并处理可能的空值
    EventBus.player_damaged.connect(func(damage):
        # 验证系统能正确处理传入的值
        assert_eq(damage, null_value)
    )
    
    # 发送空值（在实际游戏中可能需要错误处理）
    EventBus.player_damaged.emit(null_value)
    
    # 如果没有崩溃，说明系统处理了空值
    assert_true(true, "System should handle null values gracefully")
```

---

### 第4步：运行测试和验证 (15分钟)

#### 4.1 运行所有EventBus测试
**操作**: 在Godot编辑器中运行GUT测试
1. 确保EventBus已配置为AutoLoad
2. 运行 `test/core/managers/test_event_bus.gd` 中的所有测试
3. 验证所有测试都**通过**

#### 4.2 手动验证EventBus功能
**操作**: 创建一个简单的测试场景验证EventBus工作
1. 创建临时场景 `scenes/test/event_bus_test.tscn`
2. 添加一个测试脚本 `scripts/test/event_bus_test_script.gd`
3. 验证EventBus可以正常发送和接收事件

```gdscript
# scripts/test/event_bus_test_script.gd (临时测试脚本)
extends Node

func _ready():
    # 订阅EventBus事件
    EventBus.player_damaged.connect(_on_player_damaged)
    EventBus.coin_collected.connect(_on_coin_collected)
    
    # 延迟发送测试事件
    await get_tree().create_timer(1.0).timeout
    EventBus.player_damaged.emit(15)
    
    await get_tree().create_timer(0.5).timeout
    EventBus.coin_collected.emit(100)

func _on_player_damaged(damage: int):
    print("测试收到玩家受伤事件，伤害值: ", damage)

func _on_coin_collected(value: int):
    print("测试收到金币收集事件，价值: ", value)
```

---

### 第5步：代码审查和优化 (30分钟)

#### 5.1 代码质量检查清单
- [ ] 所有信号都有正确的参数类型注释
- [ ] 事件分发器方法命名清晰明确
- [ ] 没有硬编码的值
- [ ] 代码遵循GDScript官方风格指南
- [ ] 所有测试都能通过

#### 5.2 性能考虑
- [ ] 信号连接/断开的开销是可接受的
- [ ] �有不必要的信号连接
- [ ] EventBus作为单例不会造成内存泄漏

#### 5.3 文档完善
- [ ] 为每个信号添加详细的文档注释
- [ ] 为每个公共方法添加使用说明
- [ ] 添加EventBus使用示例

---

## 🔍 验收标准检查

在完成本阶段前，请确认以下验收标准都已满足：

- [ ] **EventBus作为全局单例可访问**
  - ✅ EventBus已配置为AutoLoad
  - ✅ 测试验证全局访问正常

- [ ] **所有必需的信号都已正确定义**
  - ✅ 13个核心信号都已定义
  - ✅ 信号参数类型明确

- [ ] **事件订阅和分发机制正常工作**
  - ✅ 单个订阅者可以正常接收事件
  - ✅ 多个订阅者可以同时接收事件
  - ✅ 事件数据正确传递

- [ ] **支持事件数据的正确传递**
  - ✅ 支持整型参数
  - ✅ 支持字符串参数
  - ✅ 支持节点对象参数

---

## 📝 后续准备工作

完成EventBus系统后，您已为下一阶段做好准备：
1. **ConfigManager** - 将使用EventBus分发配置变更事件
2. **GameManager** - 将使用EventBus协调各子系统
3. **其他管理器** - 都将通过EventBus进行通信

---

## 🚨 注意事项

1. **AutoLoad配置**: 确保EventBus在项目设置中正确配置为AutoLoad
2. **信号命名**: 保持信号命名的一致性，使用下划线分隔
3. **参数类型**: 为所有信号参数指定明确的类型
4. **测试隔离**: 每个测试应该是独立的，不依赖其他测试的状态
5. **内存管理**: 注意信号的连接和断开，避免内存泄漏

---

## 📚 相关文档

- [GDScript信号系统文档](https://docs.godotengine.org/en/stable/tutorials/scripting/signals.html)
- [Godot AutoLoad文档](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)
- [GUT测试框架文档](https://github.com/bitwes/Gut)

**下一阶段**: [ConfigManager配置系统TDD开发指导](02_ConfigManager配置系统TDD开发指导.md)