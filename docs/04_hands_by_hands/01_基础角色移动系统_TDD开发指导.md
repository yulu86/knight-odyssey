# 基础角色移动系统 - TDD开发指导

**Story ID**: KO_20251216_001
**开发方法**: TDD（测试驱动开发）
**预计总时长**: 6.5天（26个微循环）
**更新日期**: 2025-12-21

---

## 📋 开发前准备

### 必需资源
- ✅ Godot 4.5 编辑器
- ✅ GUT测试框架
- ✅ 像素风格角色精灵图
- ✅ 配置文件模板

### 项目结构
```
scenes/
├── characters/
│   └── player.tscn
scripts/
├── characters/
│   ├── player.gd
│   └── test/
│       └── test_player.gd
test/
└── scenes/
    └── test_runner.tscn
```

---

## 🎯 TDD核心理念

### Red-Green-Refactor循环
1. **Red（3分钟）**：编写失败的测试
2. **Green（5分钟）**：写最少的代码让测试通过
3. **Refactor（2分钟）**：重构优化

### 开发节奏
- 每个微循环15-20分钟
- 每2-3个微循环有可运行的演示版本
- 小步快跑，持续可见进展

---

## 📝 微循环开发步骤

### 阶段一：基础移动控制（第1-8个微循环）

#### 微循环 #1: 项目初始化和第一个测试

**🔴 Red阶段 - 编写失败测试（3分钟）**
```gdscript
# scripts/characters/test/test_player.gd
extends GutTest

var player: Player

func before_each():
    # TODO: 初始化测试环境
    # - 创建Player实例
    # - 设置为autofree

func test_input_a_key_sets_velocity():
    # TODO: 测试输入响应
    # - 模拟按键输入
    # - 验证velocity变化
    # - 确保测试失败
```

**🟢 Green阶段 - 最少实现代码（5分钟）**
```gdscript
# scripts/characters/player.gd
extends CharacterBody2D
class_name Player

@export var move_speed: float = 150.0

func _process(delta):
    handle_input()

func handle_input():
    # TODO: 实现基础输入处理
    # - 检测左右方向键
    # - 设置velocity.x
    # - 使用move_speed参数
```

**⚪ 重构阶段（2分钟）**
- 提取输入处理逻辑
- 确保方法命名清晰

#### 微循环 #2: 移动方向验证

**🔴 Red阶段**
```gdscript
func test_move_right_direction():
    # TODO: 测试右移方向
    # - 验证velocity.x为正值

func test_move_left_direction():
    # TODO: 测试左移方向
    # - 验证velocity.x为负值
```

**🟢 Green阶段**
```gdscript
func handle_input():
    # TODO: 区分左右方向
    # - 使用elif避免同时触发
    # - 确保方向正确
```

**⚪ 重构阶段**
- 使用常量定义方向
- 优化if-elif结构

#### 微循环 #3: 配置文件集成

**🔴 Red阶段**
```gdscript
func test_move_speed_from_config():
    # TODO: 测试配置文件加载
    # - 验证ConfigManager工作
    # - 确保速度值从文件读取
```

**🟢 Green阶段**
```gdscript
# scripts/managers/config_manager.gd
extends Node
class_name ConfigManager

static var config: ConfigFile

static func load_config(path: String):
    # TODO: 实现配置文件加载
    # - 错误处理

static func get_value(section: String, key: String, default_val = null):
    # TODO: 实现配置值读取
    # - 提供默认值

# scripts/characters/player.gd
func _ready():
    # TODO: 在初始化时加载配置
    # - 从ConfigManager获取参数
```

**⚪ 重构阶段**
- 创建配置文件
- 添加默认值处理

#### 微循环 #4: 摩擦力系统

**🔴 Red阶段**
```gdscript
func test_friction_applied_when_no_input():
    # TODO: 测试摩擦力效果
    # - 设置初始速度
    # - 释放输入
    # - 验证速度减小
```

**🟢 Green阶段**
```gdscript
@export var friction: float = 1200.0

func _physics_process(delta):
    apply_friction(delta)
    move_and_slide()

func apply_friction(delta):
    # TODO: 实现摩擦力应用
    # - 检测无输入状态
    # - 逐渐减小速度到0
    # - 考虑方向和速度符号
```

**⚪ 重构阶段**
- 使用sign函数简化代码
- 提取摩擦力应用逻辑

#### 微循环 #5: 空中摩擦力区分

**🔴 Red阶段**
```gdscript
func test_air_friction_different_from_ground():
    # TODO: 测试空中和地面摩擦力差异
    # - 模拟两种状态
    # - 对比减速率
    # - 验证不同值
```

**🟢 Green阶段**
```gdscript
@export var air_friction: float = 600.0

func _physics_process(delta):
    apply_friction(delta)
    move_and_slide()

func get_current_friction() -> float:
    # TODO: 根据状态返回摩擦力
    # - 空中返回air_friction
    # - 地面返回friction
```

**⚪ 重构阶段**
- 创建摩擦力计算方法
- 优化条件判断

#### 微循环 #6: 加速度系统

**🔴 Red阶段**
```gdscript
func test_acceleration_applied():
    # TODO: 测试加速度效果
    # - 记录初始速度
    # - 应用输入
    # - 验证速度增加
```

**🟢 Green阶段**
```gdscript
@export var acceleration: float = 300.0

func _physics_process(delta):
    handle_acceleration(delta)
    apply_friction(delta)
    move_and_slide()

func handle_acceleration(delta):
    # TODO: 实现加速度应用
    # - 根据输入方向加速
    # - 限制最大速度
    # - 使用delta时间
```

**⚪ 重构阶段**
- 提取加速度逻辑
- 确保速度不超限

#### 微循环 #7: 动画系统基础

**🔴 Red阶段**
```gdscript
func test_animation_changes_with_movement():
    # TODO: 测试动画切换
    # - Mock AnimationPlayer
    # - 验证移动时播放walk动画
```

**🟢 Green阶段**
```gdscript
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta):
    handle_input()
    update_animation()

func update_animation():
    # TODO: 实现动画切换逻辑
    # - 移动时播放walk
    # - 静止时播放idle
```

**⚪ 重构阶段**
- 创建动画状态管理
- 防止动画重复播放

#### 微循环 #8: 场景设置和物理

**🔴 Red阶段**
```gdscript
func test_character_setup():
    # TODO: 测试物理设置
    # - 验证碰撞层
    # - 确保物理属性正确
```

**🟢 Green阶段**
```gdscript
# player.tscn场景结构：
# - CharacterBody2D (根节点)
#   - CollisionShape2D
#   - Sprite2D
#   - AnimationPlayer

func _ready():
    super._ready()
    # TODO: 设置物理属性
    # - 配置碰撞层
    # - 初始化组件
```

**⚪ 重构阶段**
- 设置正确的物理层
- 配置碰撞形状

---

### 阶段二：跳跃系统（第9-16个微循环）

#### 微循环 #9: 跳跃输入检测

**🔴 Red阶段**
```gdscript
func test_jump_input_detected():
    # TODO: 测试跳跃输入
    # - 模拟空格键按下
    # - 验证跳跃标志设置
```

**🟢 Green阶段**
```gdscript
var should_jump: bool = false
@export var jump_velocity: float = -320.0

func _process(delta):
    handle_input()
    update_animation()

func handle_input():
    # TODO: 添加跳跃输入检测
    # - 检测jump动作
    # - 设置should_jump标志
```

**⚪ 重构阶段**
- 提取跳跃输入处理
- 确保单次触发

#### 微循环 #10: 地面跳跃

**🔴 Red阶段**
```gdscript
func test_jump_only_on_ground():
    # TODO: 测试跳跃条件
    # - 地面可以跳跃
    # - 空中不能跳跃
```

**🟢 Green阶段**
```gdscript
func _physics_process(delta):
    handle_jump()
    handle_acceleration(delta)
    apply_friction(delta)
    move_and_slide()

func handle_jump():
    # TODO: 实现跳跃逻辑
    # - 检查地面状态
    # - 应用跳跃速度
    # - 清理跳跃标志
```

**⚪ 重构阶段**
- 分离跳跃逻辑
- 清理跳跃状态

#### 微循环 #11: 跳跃动画

**🔴 Red阶段**
```gdscript
func test_jump_animation():
    # TODO: 测试跳跃动画
    # - 上升时播放jump动画
    # - 验证动画切换
```

**🟢 Green阶段**
```gdscript
func update_animation():
    # TODO: 完善动画状态机
    # - 添加jump状态判断
    # - 根据velocity.y选择动画
```

**⚪ 重构阶段**
- 创建动画状态机逻辑
- 优化动画切换

#### 微循环 #12: 下落状态

**🔴 Red阶段**
```gdscript
func test_fall_state():
    # TODO: 测试下落状态
    # - 下落时播放fall动画
    # - 验证状态检测
```

**🟢 Green阶段**
```gdscript
# 动画逻辑已在上一步实现
# 只需要验证fall动画播放
```

**⚪ 重构阶段**
- 验证动画优先级
- 确保状态切换流畅

#### 微循环 #13-16: 重力和物理调优

继续完善以下功能：
- 重力加速度
- 最大下落速度
- 着陆检测
- 跳跃高度控制

---

### 阶段三：状态机架构（第17-26个微循环）

#### 微循环 #17: 状态机基础结构

**🔴 Red阶段**
```gdscript
func test_state_machine_initialization():
    # TODO: 测试状态机初始化
    # - 验证初始状态为IDLE
    # - 检查状态机组件
```

**🟢 Green阶段**
```gdscript
# scripts/characters/player_state_machine.gd
extends Node
class_name PlayerStateMachine

enum State { IDLE, WALK, JUMP, FALL }

var player: Player
var current_state: State = State.IDLE

func _init(p: Player):
    # TODO: 初始化状态机
    # - 保存玩家引用
    # - 设置初始状态
```

**⚪ 重构阶段**
- 设计状态机接口
- 规划状态转换逻辑

#### 微循环 #18-26: 实现完整状态机

逐步实现以下组件：

**状态基类**
```gdscript
# scripts/characters/states/player_state.gd
extends Node
class_name PlayerState

var player: Player

func _init(p: Player):
    player = p

func enter() -> void:
    pass

func exit() -> void:
    pass

func process(delta: float) -> void:
    pass

func physics_process(delta: float) -> void:
    pass
```

**具体状态类**
- PlayerIdleState
- PlayerWalkState
- PlayerJumpState
- PlayerFallState

**状态工厂**
```gdscript
# scripts/characters/player_state_factory.gd
extends Node
class_name PlayerStateFactory

func create_state(state_type: PlayerStateMachine.State) -> PlayerState:
    # TODO: 创建状态实例
    # - 根据类型返回对应状态
    pass
```

---

## 🎮 测试运行指南

### 运行单个测试
1. 打开Godot编辑器
2. 运行 test/scenes/test_runner.tscn
3. 在GUT面板选择测试
4. 点击运行

### 运行所有测试
1. 在test_runner.tscn中
2. 点击"Run All"
3. 查看结果

---

## 📊 进度跟踪

### 每日检查清单
- [ ] 完成计划的微循环数量
- [ ] 所有测试通过
- [ ] 代码通过重构
- [ ] 更新进度文档

### 演示版本节点
- **v0.1**（第3个微循环后）：基础左右移动
- **v0.2**（第6个微循环后）：带摩擦力的平滑移动
- **v0.3**（第10个微循环后）：完整的跳跃系统
- **v1.0**（第26个微循环后）：完整的状态机系统

---

## 🔧 常见问题

### 测试失败排查
1. 检查Input配置
2. 验证物理设置
3. 确认动画资源

### 代码重构提示
1. 保持测试通过
2. 小步重构
3. 及时提交

---

## 📝 配置文件示例

```ini
# configs/player_config.cfg
[player]
move_speed=150.0
acceleration=300.0
floor_friction=1200.0
air_friction=600.0
jump_velocity=-320.0
is_debug=false
```

---

## 🎯 完成标准

- ✅ 所有单元测试通过（90%以上覆盖率）
- ✅ 角色可以通过A/D键平滑移动
- ✅ 空格键可以跳跃，有空中控制
- ✅ 动画切换流畅，无延迟
- ✅ 配置文件可以调整所有参数
- ✅ 代码遵循GDScript规范
- ✅ 性能稳定在60FPS

---

**记住**：TDD的核心是小步快跑，每个微循环都要有可运行的版本！