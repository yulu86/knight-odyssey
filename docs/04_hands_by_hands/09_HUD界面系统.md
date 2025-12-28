# HUD界面系统 - TDD开发指导

**Story ID**: KO_20251216_009
**Story标题**: HUD界面系统
**优先级**: P0 (5个Story点)
**更新日期**: 2025-12-28

---

## 目录

1. [Story概述](#story概述)
2. [验收标准](#验收标准)
3. [Task拆分方案](#task拆分方案)
4. [前置条件检查](#前置条件检查)
5. [详细开发步骤](#详细开发步骤)
6. [验收测试](#验收测试)

---

## Story概述

### 用户故事
**作为**一名玩家
**我想要**在游戏过程中看到关键的游戏信息
**以便**了解我的游戏进度和状态

### 可视化成果
📊 显示生命值、分数等UI

---

## 验收标准

| ID | 验收标准 | 优先级 |
|----|----------|--------|
| AC1 | 游戏进行中显示当前分数 | P0 |
| AC2 | 用心形图标显示剩余生命 | P0 |
| AC3 | 收集物品时分数实时更新并有动画效果 | P1 |
| AC4 | 失去生命时生命值显示立即更新并闪红 | P1 |
| AC5 | 按ESC键显示暂停菜单 | P0 |
| AC6 | 暂停时显示当前关卡和进度信息 | P1 |
| AC7 | HUD使用像素风格字体，不遮挡游戏画面 | P0 |

---

## Task拆分方案

根据Story的复杂度和TDD最佳实践，将HUD界面系统拆分为以下8个Task：

| Task ID | Task名称 | 预估时间 | 依赖 | 责任方 |
|---------|----------|----------|------|--------|
| Task 1 | 创建EventBus单例系统 | 0.5h | 无 | AI助手 |
| Task 2 | 配置暂停输入映射 | 0.5h | 无 | 用户 |
| Task 3 | 创建HUD基础场景结构 | 1h | Task 1 | 用户 |
| Task 4 | 实现分数显示功能 | 1h | Task 3 | AI助手 |
| Task 5 | 实现生命值显示功能 | 1h | Task 3 | AI助手 |
| Task 6 | 实现更新动画效果 | 1.5h | Task 4,5 | AI助手 |
| Task 7 | 创建暂停菜单场景 | 1.5h | Task 2 | AI助手 |
| Task 8 | 集成测试和验收 | 1h | 所有Task | AI助手 |

**总预估时间**: 8小时

---

## 前置条件检查

### 资源准备

在开始开发前，确认以下资源已准备就绪：

- [x] 像素字体资源：`assets/fonts/PixelOperator8.ttf`
- [x] 像素字体资源：`assets/fonts/PixelOperator8-Bold.ttf`
- [x] 像素字体资源：`assets/fonts/zpix.ttf`
- [x] 心形图标（实心）：`assets/sprites/ui/heart_ui_full.png` ✅ 已准备
- [x] 心形图标（空心）：`assets/sprites/ui/heart_ui_empty.png` ✅ 已准备

### 依赖确认

- [x] Godot 4.5 引擎已安装
- [x] GUT测试框架已配置
- [x] 项目基础结构已创建
- [ ] EventBus单例已实现 (Task 1完成)

---

## 详细开发步骤

### Task 1: 创建EventBus单例系统

**目标**: 实现全局事件总线，支持游戏内各系统间的解耦通信。

**TDD微循环**:

#### 1.1 Red阶段 - 编写测试

**文件**: `test/unit/core/test_event_bus.gd`

```gdscript
extends GutTest

# 测试EventBus是否为单例
func test_event_bus_is_singleton():
    # TODO: 验证EventBus可以作为单例访问
    # - 验证EventBus.instance()不为null
    pass

# 测试信号定义存在性
func test_score_updated_signal_exists():
    # TODO: 验证score_updated信号已定义
    # - 验证信号可以被连接
    pass

# 测试生命值更新信号
func test_lives_updated_signal_exists():
    # TODO: 验证lives_updated信号已定义
    # - 验证信号可以被连接
    pass

# 测试游戏暂停信号
func test_game_paused_signal_exists():
    # TODO: 验证game_paused信号已定义
    pass

# 测试信号发送
func test_emit_signal_works():
    # TODO: 验证信号可以正确发送
    # - 发送score_updated信号
    # - 验证监听者能收到
    pass
```

**AI助手任务**: 编写上述测试框架

**用户任务**: 无

#### 1.2 Green阶段 - 实现最小代码

**文件**: `scripts/core/event_bus.gd`

```gdscript
# TODO: 定义EventBus类
# - 不使用class_name (因为是AutoLoad单例)
# - 定义以下信号:
#   - score_updated(new_score: int)
#   - lives_updated(new_lives: int)
#   - game_paused(is_paused: bool)
#   - coin_collected(value: int)
#   - player_damaged(damage: int)

signal score_updated(new_score: int)
signal lives_updated(new_lives: int)
signal game_paused(is_paused: bool)
signal coin_collected(value: int)
signal player_damaged(damage: int)

# TODO: 如果需要，添加单例辅助方法
```

**AI助手任务**: 实现EventBus基础信号定义

**用户任务**: 无

#### 1.3 配置AutoLoad

**操作步骤** (用户执行):

1. 打开Godot编辑器
2. 点击 `项目` → `项目设置`
3. 选择 `AutoLoad` 标签页
4. 点击 `路径` 右侧的文件夹图标
5. 选择 `scripts/core/event_bus.gd`
6. 在 `节点名称` 输入框中输入: `EventBus`
7. 点击 `添加` 按钮
8. 确认EventBus出现在AutoLoad列表中，且顺序为第一
9. 点击 `关闭`

**验证**:
- 在Godot编辑器底部的脚本编辑器中，输入 `EventBus.` 看是否能看到自动补全提示

#### 1.4 运行测试

**命令** (AI助手执行):

```bash
'/Users/xuyulu/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot' -s addons/gut/gut_cmdln.gd -gdir=res://test/unit/core -ginclude_subdirs -gexit
```

**预期结果**: 所有测试通过

#### 1.5 Refactor阶段

**检查点**:
- [ ] 信号命名符合规范（snake_case）
- [ ] 信号参数有类型提示
- [ ] 代码符合GDScript风格指南

---

### Task 2: 配置暂停输入映射

**目标**: 在项目设置中配置ESC键作为暂停输入。

**责任方**: 用户

#### 2.1 配置步骤

**操作步骤** (用户执行):

1. 打开Godot编辑器
2. 点击 `项目` → `项目设置`
3. 选择 `输入映射` 标签页
4. 在 `添加新操作` 输入框中输入: `pause`
5. 点击 `添加` 按钮
6. 点击 `pause` 操作展开配置
7. 点击 `加号` → 选择 `键盘` → 输入/选择 `Escape`
8. 点击 `添加` 按钮
9. 点击 `关闭`

#### 2.2 验证配置

**文件**: `project.godot`

确认在 `[input]` 部分有以下配置:

```ini
pause={
"deadzone": 0.5,
"events": [Object(InputEventKey, "resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":4194305,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
]
}
```

---

### Task 3: 创建HUD基础场景结构

**目标**: 创建HUD场景的节点结构和基础配置。

**责任方**: 用户

#### 3.1 场景结构设计

**目标场景树**:

```
HUD (CanvasLayer)
├─ MarginContainer (MarginContainer)
│  ├─ HBoxContainer (HBoxContainer)
│  │  ├─ ScoreLabel (Label)
│  │  └─ LivesContainer (HBoxContainer)
│  │     ├─ Heart1 (TextureRect)
│  │     ├─ Heart2 (TextureRect)
│  │     └─ Heart3 (TextureRect)
└─ PauseMenu (Control) - 初始visible=false
   ├─ Background (ColorRect)
   ├─ VBoxContainer (VBoxContainer)
   │  ├─ TitleLabel (Label)
   │  ├─ LevelLabel (Label)
   │  ├─ ResumeButton (Button)
   │  └─ QuitButton (Button)
```

#### 3.2 创建HUD场景

**操作步骤** (用户执行):

1. 在Godot编辑器中，点击 `场景` → `新建场景`
2. 选择 `其他节点` → 搜索 `CanvasLayer` → 点击 `创建`
3. 将根节点重命名为 `HUD`
4. 保存场景为: `scenes/ui/hud.tscn`

#### 3.3 创建主容器

**操作步骤** (用户执行):

1. 选中 `HUD` 节点
2. 点击 `+` 添加子节点 → 搜索 `MarginContainer` → 点击 `创建`
3. 选中 `MarginContainer` 节点，在右侧属性面板中设置:
   - `Top`: 10
   - `Left`: 10
   - `Right`: 10
   - `Bottom`: 10

#### 3.4 创建顶部水平布局

**操作步骤** (用户执行):

1. 选中 `MarginContainer` 节点
2. 点击 `+` 添加子节点 → 搜索 `HBoxContainer` → 点击 `创建`
3. 这将作为分数和生命值的容器

#### 3.5 创建分数标签

**操作步骤** (用户执行):

1. 选中 `HBoxContainer` 节点
2. 点击 `+` 添加子节点 → 搜索 `Label` → 点击 `创建`
3. 将节点重命名为 `ScoreLabel`
4. 选中 `ScoreLabel` 节点，在右侧属性面板中设置:
   - `Text`: "SCORE: 0"
   - `Theme Overrides` → `Fonts` → `Font`: 选择 `PixelOperator8-Bold` (需要先创建Theme或直接设置)
   - `Theme Overrides` → `Font Sizes` → `Font Size`: 16
   - `Horizontal Alignment`: `Left`
   - `Vertical Alignment`: `Center`
   - `Size` → `Horizontal`: `Shrink Begin` → `Expand`: 勾选

#### 3.6 创建生命值容器

**操作步骤** (用户执行):

1. 选中 `HBoxContainer` 节点
2. 点击 `+` 添加子节点 → 搜索 `HBoxContainer` → 点击 `创建`
3. 将节点重命名为 `LivesContainer`
4. 选中 `LivesContainer` 节点，在右侧属性面板中设置:
   - `Separation`: 5
   - `Size` → `Horizontal`: `Shrink End` → `Expand`: 勾选

#### 3.7 创建心形图标

**操作步骤** (用户执行):

在 `LivesContainer` 下创建3个心形图标:

1. 选中 `LivesContainer` 节点
2. 点击 `+` 添加子节点 → 搜索 `TextureRect` → 点击 `创建`
3. 将节点重命名为 `Heart1`
4. 重复步骤1-3两次，创建 `Heart2` 和 `Heart3`

**设置每个心形图标**:
- 选中心形节点
- 在右侧属性面板中设置:
  - `Size` → `Horizontal`: `Custom` → `Size`: 16
  - `Size` → `Vertical`: `Custom` → `Size`: 16
  - `Texture`: 暂时留空 (Task 5中会设置)

#### 3.8 创建暂停菜单根节点

**操作步骤** (用户执行):

1. 选中 `HUD` 节点
2. 点击 `+` 添加子节点 → 搜索 `Control` → 点击 `创建`
3. 将节点重命名为 `PauseMenu`
4. 选中 `PauseMenu` 节点，在右侧属性面板中设置:
   - `Visible`: 取消勾选 (初始隐藏)
   - `Layout` → `Anchors Preset`: `Full Rect`
   - `Size` → `Horizontal`: `Expand`
   - `Size` → `Vertical`: `Expand`

#### 3.9 创建暂停菜单背景

**操作步骤** (用户执行):

1. 选中 `PauseMenu` 节点
2. 点击 `+` 添加子节点 → 搜索 `ColorRect` → 点击 `创建`
3. 将节点重命名为 `Background`
4. 选中 `Background` 节点，在右侧属性面板中设置:
   - `Color`: `rgba(0, 0, 0, 0.7)` (半透明黑色)
   - `Layout` → `Anchors Preset`: `Full Rect`

#### 3.10 创建暂停菜单布局

**操作步骤** (用户执行):

1. 选中 `PauseMenu` 节点
2. 点击 `+` 添加子节点 → 搜索 `VBoxContainer` → 点击 `创建`
3. 选中 `VBoxContainer` 节点，在右侧属性面板中设置:
   - `Layout` → `Anchors Preset`: `Center`
   - `Separation`: 20

#### 3.11 创建暂停菜单标题

**操作步骤** (用户执行):

1. 选中 `VBoxContainer` 节点
2. 点击 `+` 添加子节点 → 搜索 `Label` → 点击 `创建`
3. 将节点重命名为 `TitleLabel`
4. 选中 `TitleLabel` 节点，在右侧属性面板中设置:
   - `Text`: "PAUSED"
   - `Theme Overrides` → `Font Sizes` → `Font Size`: 32
   - `Horizontal Alignment`: `Center`

#### 3.12 创建关卡信息标签

**操作步骤** (用户执行):

1. 选中 `VBoxContainer` 节点
2. 点击 `+` 添加子节点 → 搜索 `Label` → 点击 `创建`
3. 将节点重命名为 `LevelLabel`
4. 选中 `LevelLabel` 节点，在右侧属性面板中设置:
   - `Text`: "Level: 1-1"
   - `Theme Overrides` → `Font Sizes` → `Font Size`: 16
   - `Horizontal Alignment`: `Center`

#### 3.13 创建按钮

**操作步骤** (用户执行):

创建两个按钮:

**Resume按钮**:
1. 选中 `VBoxContainer` 节点
2. 点击 `+` 添加子节点 → 搜索 `Button` → 点击 `创建`
3. 将节点重命名为 `ResumeButton`
4. 选中 `ResumeButton` 节点，在右侧属性面板中设置:
   - `Text`: "Resume"

**Quit按钮**:
1. 选中 `VBoxContainer` 节点
2. 点击 `+` 添加子节点 → 搜索 `Button` → 点击 `创建`
3. 将节点重命名为 `QuitButton`
4. 选中 `QuitButton` 节点，在右侧属性面板中设置:
   - `Text`: "Quit to Menu"

#### 3.14 创建HUD脚本

**文件**: `scripts/ui/hud.gd`

```gdscript
extends CanvasLayer

# TODO: 定义节点引用
# @onready var score_label: Label = $MarginContainer/HBoxContainer/ScoreLabel
# @onready var lives_container: HBoxContainer = $MarginContainer/HBoxContainer/LivesContainer
# @onready var pause_menu: Control = $PauseMenu
# @onready var resume_button: Button = $PauseMenu/VBoxContainer/ResumeButton
# @onready var quit_button: Button = $PauseMenu/VBoxContainer/QuitButton

# TODO: 定义内部变量
# var current_score: int = 0
# var current_lives: int = 3
# var heart_textures: Array[Texture2D] = []

# TODO: 定义_ready函数
# func _ready() -> void:
#     - 连接EventBus信号
#     - 连接按钮信号
#     - 初始化心形纹理加载
#     - 初始化UI显示

# TODO: 定义更新分数方法
# func update_score(score: int) -> void:
#     - 更新current_score变量
#     - 更新ScoreLabel文本
#     - 触发分数更新动画 (Task 6)

# TODO: 定义更新生命值方法
# func update_lives(lives: int) -> void:
#     - 更新current_lives变量
#     - 显示/隐藏心形图标
#     - 触发生命值闪烁效果 (Task 6)

# TODO: 定义切换暂停菜单方法
# func toggle_pause_menu(show: bool) -> void:
#     - 设置pause_menu.visible
#     - 暂停/恢复游戏树

# TODO: 定义按钮回调方法
# func _on_resume_button_pressed() -> void:
#     - 隐藏暂停菜单
#     - 恢复游戏

# func _on_quit_button_pressed() -> void:
#     - 返回主菜单
```

**AI助手任务**: 提供脚本框架和TODO注释

**用户任务**: 在编辑器中创建节点结构

#### 3.15 附加脚本到场景

**操作步骤** (用户执行):

1. 在Godot编辑器中选中 `HUD` 根节点
2. 在右侧属性面板中点击 `附加脚本` 图标
3. 浏览到 `scripts/ui/hud.gd`
4. 点击 `打开`

#### 3.16 验证场景

**检查点**:
- [ ] 场景树结构符合设计
- [ ] 所有节点命名正确
- [ ] 场景文件保存为 `scenes/ui/hud.tscn`
- [ ] 脚本已附加到根节点

---

### Task 4: 实现分数显示功能

**目标**: 实现分数的显示和实时更新。

**TDD微循环**:

#### 4.1 Red阶段 - 编写测试

**文件**: `test/unit/ui/test_hud.gd`

```gdscript
extends GutTest

var HUD_scene = preload("res://scenes/ui/hud.tscn")
var hud: CanvasLayer

func before_each():
    hud = HUD_scene.instantiate()
    add_child(hud)
    await wait_frames(1)

func after_each():
    hud.queue_free()

# 测试初始分数显示
func test_initial_score_display():
    # TODO: 验证初始分数为0
    # - 断言ScoreLabel文本为"SCORE: 0"
    pass

# 测试分数更新
func test_score_update():
    # TODO: 验证分数可以正确更新
    # - 调用update_score(100)
    # - 断言ScoreLabel文本为"SCORE: 100"
    pass

# 测试分数累加
func test_score_accumulation():
    # TODO: 验证分数可以累加
    # - 调用update_score(100)
    # - 调用update_score(50)
    # - 断言ScoreLabel文本为"SCORE: 150"
    pass

# 测试EventBus信号连接
func test_score_updated_signal_connection():
    # TODO: 验证EventBus.score_updated信号已连接
    # - 发送EventBus.score_updated信号
    # - 验证分数已更新
    pass
```

**AI助手任务**: 编写测试框架

#### 4.2 Green阶段 - 实现最小代码

**文件**: `scripts/ui/hud.gd`

在 `hud.gd` 中实现:

```gdscript
@onready var score_label: Label = $MarginContainer/HBoxContainer/ScoreLabel

var current_score: int = 0

func _ready() -> void:
    EventBus.score_updated.connect(_on_score_updated)
    update_score(0)

func update_score(score: int) -> void:
    current_score = score
    score_label.text = "SCORE: %d" % current_score

func _on_score_updated(new_score: int) -> void:
    update_score(new_score)
```

**AI助手任务**: 实现最小可工作代码

#### 4.3 运行测试

**命令**:

```bash
'/Users/xuyulu/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot' -s addons/gut/gut_cmdln.gd -gdir=res://test/unit/ui -ginclude_subdirs -gexit
```

**预期结果**: 所有测试通过

#### 4.4 Refactor阶段

**检查点**:
- [ ] 代码符合DRY原则
- [ ] 变量命名清晰
- [ ] 没有硬编码

---

### Task 5: 实现生命值显示功能

**目标**: 实现生命值的图标显示和更新。

**TDD微循环**:

#### 5.1 Red阶段 - 编写测试

**文件**: `test/unit/ui/test_hud.gd` (继续添加)

```gdscript
# 测试初始生命值显示
func test_initial_lives_display():
    # TODO: 验证初始显示3个心形
    # - 验证3个心形都可见
    pass

# 测试生命值减少
func test_lives_decrease():
    # TODO: 验证生命值减少时图标更新
    # - 调用update_lives(2)
    # - 验证只有2个心形可见
    pass

# 测试生命值增加
func test_lives_increase():
    # TODO: 验证生命值增加时图标更新
    # - 先调用update_lives(2)
    # - 再调用update_lives(3)
    # - 验证3个心形都可见
    pass

# 测试最大生命值限制
func test_max_lives_limit():
    # TODO: 验证最大生命值为5
    # - 调用update_lives(6)
    # - 验证最多显示5个心形
    pass

# 测试EventBus信号连接
func test_lives_updated_signal_connection():
    # TODO: 验证EventBus.lives_updated信号已连接
    pass
```

**AI助手任务**: 编写测试框架

#### 5.2 Green阶段 - 实现最小代码

**文件**: `scripts/ui/hud.gd`

在 `hud.gd` 中添加:

```gdscript
@onready var lives_container: HBoxContainer = $MarginContainer/HBoxContainer/LivesContainer

var current_lives: int = 3
const MAX_LIVES: int = 5
var heart_nodes: Array[TextureRect] = []

func _ready() -> void:
    # TODO: 初始化心形节点数组
    # - 从lives_container获取所有TextureRect子节点
    # - 存储到heart_nodes数组中

    EventBus.lives_updated.connect(_on_lives_updated)
    update_lives(3)

func update_lives(lives: int) -> void:
    # TODO: 更新生命值显示
    # - 限制lives在0到MAX_LIVES之间
    # - 更新current_lives
    # - 遍历heart_nodes数组
    # - 根据index < current_lives设置heart_ui_full纹理
    # - 根据index >= current_lives设置heart_ui_empty纹理
    pass

func _on_lives_updated(new_lives: int) -> void:
    update_lives(new_lives)
```

**AI助手任务**: 实现最小可工作代码

#### 5.3 运行测试

**命令**:

```bash
'/Users/xuyulu/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot' -s addons/gut/gut_cmdln.gd -gdir=res://test/unit/ui -ginclude_subdirs -gexit
```

**预期结果**: 所有测试通过

#### 5.4 加载心形图标资源

**用户任务**:

**已准备资源**:
- ✅ `assets/sprites/ui/heart_ui_full.png` - 实心红心（有生命状态）
- ✅ `assets/sprites/ui/heart_ui_empty.png` - 空心红心（失去生命状态）

**资源规格**:
- 格式: PNG, 带透明通道
- 已自动导入到Godot (存在.import文件)

#### 5.5 设置心形纹理

**操作步骤** (用户执行):

**步骤1: 预加载心形纹理资源**

在 `scripts/ui/hud.gd` 的顶部添加资源预加载:

```gdscript
extends CanvasLayer

# TODO: 预加载心形纹理资源
# const HEART_FULL_TEXTURE = preload("res://assets/sprites/ui/heart_ui_full.png")
# const HEART_EMPTY_TEXTURE = preload("res://assets/sprites/ui/heart_ui_empty.png")
```

**步骤2: 为每个Heart节点设置初始纹理**

对于每个 `Heart` 节点 (Heart1, Heart2, Heart3):
1. 选中 `Heart1` 节点
2. 在右侧属性面板中:
   - `Texture`: 浏览选择 `res://assets/sprites/ui/heart_ui_full.png`
   - `Expand Mode`: `Ignore Size` (保持比例)
   - `Size` → `Horizontal`: `Custom` → `Size`: 24 (推荐尺寸)
   - `Size` → `Vertical`: `Custom` → `Size`: 24

3. 重复以上步骤为 Heart2 和 Heart3 设置

**注意**:
- 所有心形节点初始都设置为 `heart_ui_full.png`
- 在 `update_lives()` 函数中动态切换纹理

---

### Task 6: 实现更新动画效果

**目标**: 为分数更新和生命值变化添加动画效果。

**TDD微循环**:

#### 6.1 Red阶段 - 编写测试

**文件**: `test/unit/ui/test_hud_animations.gd`

```gdscript
extends GutTest

var HUD_scene = preload("res://scenes/ui/hud.tscn")
var hud: CanvasLayer

func before_each():
    hud = HUD_scene.instantiate()
    add_child(hud)
    await wait_frames(1)

func after_each():
    hud.queue_free()

# 测试分数更新动画
func test_score_update_animation():
    # TODO: 验证分数更新时播放动画
    # - 调用update_score_with_animation(100)
    # - 验证Label的scale或modulate发生变化
    pass

# 测试生命值减少闪烁效果
func test_lives_decrease_flash():
    # TODO: 验证失去生命时心形闪烁红色
    # - 调用update_lives(2)
    # - 验证心形图标的modulate变为红色
    pass

# 测试动画完成
func test_animation_completion():
    # TODO: 验证动画能正确完成
    # - 等待动画时间
    # - 验证UI恢复正常状态
    pass
```

**AI助手任务**: 编写测试框架

#### 6.2 Green阶段 - 实现动画

**文件**: `scripts/ui/hud.gd`

在 `hud.gd` 中添加:

```gdscript
@onready var score_label: Label = $MarginContainer/HBoxContainer/ScoreLabel

# TODO: 定义动画相关变量
# var tween: Tween
# const SCORE_ANIMATION_DURATION: float = 0.3
# const DAMAGE_FLASH_COLOR: Color = Color(1, 0, 0, 1)
# const DAMAGE_FLASH_DURATION: float = 0.5

func _ready() -> void:
    # TODO: 创建Tween节点
    # tween = create_tween()
    # tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

func update_score(score: int) -> void:
    current_score = score
    score_label.text = "SCORE: %d" % current_score

    # TODO: 添加分数更新动画
    # - 使用tween创建scale动画 (1.0 -> 1.2 -> 1.0)
    # - 持续时间: SCORE_ANIMATION_DURATION
    pass

func update_lives(lives: int) -> void:
    var old_lives: int = current_lives
    current_lives = clamp(lives, 0, MAX_LIVES)

    # TODO: 更新心形显示
    # - 遍历heart_nodes
    # - 设置visible属性

    # TODO: 如果生命值减少，触发闪烁效果
    # if current_lives < old_lives:
    #     _flash_hearts_red()
    pass

func _flash_hearts_red() -> void:
    # TODO: 实现心形闪烁红色效果
    # - 遍历所有可见的心形
    # - 使用tween创建modulate动画
    # - Color.WHITE -> DAMAGE_FLASH_COLOR -> Color.WHITE
    # - 持续时间: DAMAGE_FLASH_DURATION
    pass
```

**AI助手任务**: 实现动画逻辑

#### 6.3 运行测试

**命令**:

```bash
'/Users/xuyulu/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot' -s addons/gut/gut_cmdln.gd -gdir=res://test/unit/ui -ginclude_subdirs -gexit
```

#### 6.4 Refactor阶段

**检查点**:
- [ ] 动画参数可配置 (使用常量)
- [ ] 动画时长合理 (不超过0.5秒)
- [ ] 多个动画不会冲突

---

### Task 7: 创建暂停菜单功能

**目标**: 实现暂停菜单的显示和控制。

**TDD微循环**:

#### 7.1 Red阶段 - 编写测试

**文件**: `test/unit/ui/test_pause_menu.gd`

```gdscript
extends GutTest

var HUD_scene = preload("res://scenes/ui/hud.tscn")
var hud: CanvasLayer

func before_each():
    hud = HUD_scene.instantiate()
    add_child(hud)
    await wait_frames(1)

func after_each():
    hud.queue_free()

# 测试暂停菜单初始隐藏
func test_pause_menu_initially_hidden():
    # TODO: 验证pause_menu初始不可见
    pass

# 测试显示暂停菜单
func test_show_pause_menu():
    # TODO: 验证可以显示暂停菜单
    # - 调用show_pause_menu()
    # - 验证pause_menu.visible为true
    pass

# 测试隐藏暂停菜单
func test_hide_pause_menu():
    # TODO: 验证可以隐藏暂停菜单
    pass

# 测试暂停游戏树
func test_pause_game_tree():
    # TODO: 验证显示暂停菜单时游戏暂停
    # - 验证get_tree().paused为true
    pass

# 测试恢复游戏树
func test_resume_game_tree():
    # TODO: 验证隐藏暂停菜单时游戏恢复
    # - 验证get_tree().paused为false
    pass

# 测试ESC键触发
func test_esc_key_toggles_pause():
    # TODO: 模拟按下ESC键
    # - 使用InputEventKey
    # - 验证暂停菜单切换状态
    pass

# 测试Resume按钮
func test_resume_button():
    # TODO: 模拟点击Resume按钮
    # - 验证暂停菜单隐藏
    # - 验证游戏恢复
    pass
```

**AI助手任务**: 编写测试框架

#### 7.2 Green阶段 - 实现功能

**文件**: `scripts/ui/hud.gd`

在 `hud.gd` 中添加:

```gdscript
@onready var pause_menu: Control = $PauseMenu
@onready var resume_button: Button = $PauseMenu/VBoxContainer/ResumeButton
@onready var quit_button: Button = $PauseMenu/VBoxContainer/QuitButton

func _ready() -> void:
    # TODO: 连接按钮信号
    # resume_button.pressed.connect(_on_resume_button_pressed)
    # quit_button.pressed.connect(_on_quit_button_pressed)

    # TODO: 设置暂停菜单初始状态
    # pause_menu.hide()

func _input(event: InputEvent) -> void:
    # TODO: 处理ESC键输入
    # if event.is_action_pressed("pause"):
    #     _toggle_pause_menu()

func _toggle_pause_menu() -> void:
    # TODO: 切换暂停菜单状态
    # pause_menu.visible = not pause_menu.visible
    # get_tree().paused = pause_menu.visible

func show_pause_menu() -> void:
    # TODO: 显示暂停菜单
    # pause_menu.show()
    # get_tree().paused = true

func hide_pause_menu() -> void:
    # TODO: 隐藏暂停菜单
    # pause_menu.hide()
    # get_tree().paused = false

func _on_resume_button_pressed() -> void:
    # TODO: Resume按钮回调
    hide_pause_menu()

func _on_quit_button_pressed() -> void:
    # TODO: Quit按钮回调
    # get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
```

**AI助手任务**: 实现暂停菜单逻辑

#### 7.3 运行测试

**命令**:

```bash
'/Users/xuyulu/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot' -s addons/gut/gut_cmdln.gd -gdir=res://test/unit/ui -ginclude_subdirs -gexit
```

#### 7.4 Refactor阶段

**检查点**:
- [ ] 暂停/恢复逻辑清晰
- [ ] 输入处理使用is_action_pressed
- [ ] 代码符合单一职责原则

---

### Task 8: 集成测试和验收

**目标**: 完成集成测试，验证所有验收标准。

#### 8.1 单元测试回顾

**检查清单**:

- [ ] EventBus信号测试通过
- [ ] HUD分数显示测试通过
- [ ] HUD生命值显示测试通过
- [ ] 动画效果测试通过
- [ ] 暂停菜单测试通过

**命令**:

```bash
'/Users/xuyulu/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot' -s addons/gut/gut_cmdln.gd -gdir=res://test/unit -ginclude_subdirs -gexit
```

#### 8.2 集成测试

**文件**: `test/integration/ui/test_hud_integration.gd`

```gdscript
extends GutTest

# 测试HUD完整流程
func test_complete_hud_flow():
    # TODO: 创建完整游戏场景
    # - 包含Player
    # - 包含HUD
    # - 模拟游戏事件

    # TODO: 验证初始状态
    # - 分数为0
    # - 生命值为3
    # - 暂停菜单隐藏

    # TODO: 模拟收集金币
    # - 发送EventBus.coin_collected(10)
    # - 验证分数更新

    # TODO: 模拟玩家受伤
    # - 发送EventBus.player_damaged(1)
    # - 验证生命值减少
    # - 验证闪烁效果

    # TODO: 模拟暂停
    # - 模拟ESC键
    # - 验证暂停菜单显示
    # - 验证游戏暂停

    # TODO: 模拟恢复
    # - 点击Resume按钮
    # - 验证暂停菜单隐藏
    # - 验证游戏恢复
    pass
```

**AI助手任务**: 编写集成测试

#### 8.3 手动验收测试

**验收标准检查表**:

| AC | 描述 | 测试步骤 | 预期结果 | 状态 |
|----|------|----------|----------|------|
| AC1 | 游戏进行中显示当前分数 | 1. 启动游戏<br>2. 观察HUD | 屏幕左上角显示"SCORE: 0" | ⬜ |
| AC2 | 用心形图标显示剩余生命 | 1. 启动游戏<br>2. 观察HUD | 分数右侧显示3个红色心形图标 | ⬜ |
| AC3 | 收集物品时分数实时更新并有动画效果 | 1. 收集金币<br>2. 观察分数 | 分数增加，Label有缩放动画 | ⬜ |
| AC4 | 失去生命时生命值显示立即更新并闪红 | 1. 碰到敌人<br>2. 观察生命值 | 心形图标减少，剩余心形闪烁红色 | ⬜ |
| AC5 | 按ESC键显示暂停菜单 | 1. 游戏中按ESC | 屏幕出现半透明暂停菜单 | ⬜ |
| AC6 | 暂停时显示当前关卡和进度信息 | 1. 打开暂停菜单<br>2. 查看内容 | 显示"PAUSED"标题和"Level: 1-1" | ⬜ |
| AC7 | HUD使用像素风格字体，不遮挡游戏画面 | 1. 观察整体UI | 字体为像素风格，HUD布局合理不遮挡游戏 | ⬜ |

**用户任务**: 执行手动验收测试

#### 8.4 性能测试

**性能指标检查**:

- [ ] 帧率保持60FPS (无显著下降)
- [ ] 内存使用合理 (HUD加载后无内存泄漏)
- [ ] UI响应时间 < 100ms

**测试方法**:
1. 使用Godot Debugger监控帧率
2. 使用Memory Profiler检查内存
3. 观察UI更新的响应性

#### 8.5 兼容性测试

**测试场景**:

- [ ] 不同分辨率下HUD显示正常 (1280x720, 1920x1080)
- [ ] 窗口缩放时UI适配正确
- [ ] 像素字体在不同DPI下清晰可读

---

## 完成标准

### 代码质量

- [ ] 所有单元测试通过 (覆盖率 > 80%)
- [ ] 所有集成测试通过
- [ ] 代码符合GDScript风格指南
- [ ] 无GUT测试警告或错误
- [ ] 场景树结构清晰规范

### 功能完整性

- [ ] 所有验收标准满足
- [ ] 手动测试通过
- [ ] 无已知bug
- [ ] 性能指标达标

### 文档更新

- [ ] 代码注释完整
- [ ] 测试文档已更新
- [ ] Backlog状态已更新为"已完成"

---

## 附录

### A. 节点路径速查表

| 节点名称 | 路径 | 类型 |
|----------|------|------|
| HUD | / | CanvasLayer |
| ScoreLabel | /MarginContainer/HBoxContainer/ScoreLabel | Label |
| LivesContainer | /MarginContainer/HBoxContainer/LivesContainer | HBoxContainer |
| Heart1 | /MarginContainer/HBoxContainer/LivesContainer/Heart1 | TextureRect |
| PauseMenu | /PauseMenu | Control |
| Background | /PauseMenu/Background | ColorRect |
| TitleLabel | /PauseMenu/VBoxContainer/TitleLabel | Label |
| ResumeButton | /PauseMenu/VBoxContainer/ResumeButton | Button |

### B. EventBus信号列表

| 信号名 | 参数 | 用途 |
|--------|------|------|
| score_updated | new_score: int | 分数更新时发送 |
| lives_updated | new_lives: int | 生命值更新时发送 |
| game_paused | is_paused: bool | 游戏暂停状态变化时发送 |
| coin_collected | value: int | 收集金币时发送 |
| player_damaged | damage: int | 玩家受伤时发送 |

### C. 常量配置

```gdscript
# HUD配置
const MAX_LIVES: int = 5
const INITIAL_LIVES: int = 3
const INITIAL_SCORE: int = 0

# 心形纹理资源
const HEART_FULL_TEXTURE = preload("res://assets/sprites/ui/heart_ui_full.png")
const HEART_EMPTY_TEXTURE = preload("res://assets/sprites/ui/heart_ui_empty.png")

# 动画配置
const SCORE_ANIMATION_DURATION: float = 0.3
const DAMAGE_FLASH_COLOR: Color = Color(1, 0, 0, 1)
const DAMAGE_FLASH_DURATION: float = 0.5

# 字体配置
const HUD_FONT_SIZE: int = 16
const TITLE_FONT_SIZE: int = 32
```

### D. 心形图标资源说明

**资源路径**:
- 实心红心: `res://assets/sprites/ui/heart_ui_full.png`
- 空心红心: `res://assets/sprites/ui/heart_ui_empty.png`

**使用方式**:
```gdscript
# 在scripts/ui/hud.gd中预加载
const HEART_FULL_TEXTURE = preload("res://assets/sprites/ui/heart_ui_full.png")
const HEART_EMPTY_TEXTURE = preload("res://assets/sprites/ui/heart_ui_empty.png")

# 在update_lives()函数中动态设置纹理
func update_lives(lives: int) -> void:
    current_lives = clamp(lives, 0, MAX_LIVES)

    for i in range(heart_nodes.size()):
        var heart: TextureRect = heart_nodes[i]
        if i < current_lives:
            heart.texture = HEART_FULL_TEXTURE
        else:
            heart.texture = HEART_EMPTY_TEXTURE
```

**视觉效果**:
- `heart_ui_full.png`: 显示实心红心，表示该生命值存在
- `heart_ui_empty.png`: 显示空心红心，表示该生命值已失去

**推荐尺寸**: 24x24 像素（可根据实际UI调整）

### E. 常见问题解决

**Q1: 心形图标不显示**
- 检查: TextureRect的Texture属性是否已设置
- 检查: 图片资源路径是否正确 (`res://assets/sprites/ui/heart_ui_full.png`)
- 检查: 图片是否已导入 (.import文件存在)
- 检查: TextureRect的Size设置 (建议24x24)

**Q1.1: 心形图标不切换纹理**
- 检查: `heart_nodes`数组是否正确初始化
- 检查: `update_lives()`函数中的纹理赋值逻辑
- 检查: 常量`HEART_FULL_TEXTURE`和`HEART_EMPTY_TEXTURE`是否预加载
- 调试: 在`update_lives()`中打印`current_lives`值

**Q2: 字体不生效**
- 检查: 字体资源是否已导入
- 检查: Label的Theme Overrides → Fonts是否已设置
- 检查: Font Size是否合理

**Q3: 暂停菜单不显示**
- 检查: PauseMenu的Visible属性
- 检查: CanvasLayer的Layer设置 (应该 > 0)
- 检查: _input函数是否正确处理ESC键

**Q4: 动画不播放**
- 检查: Tween是否正确创建
- 检查: tween.set_pause_mode设置
- 检查: 动画时长是否过短

### E. 参考文档

- Godot 4.5 官方文档: https://docs.godotengine.org/
- CanvasLayer文档: https://docs.godotengine.org/en/stable/classes/class_canvaslayer.html
- Tween文档: https://docs.godotengine.org/en/stable/classes/class_tween.html
- 项目架构文档: `docs/02_arch/01_游戏架构概要设计_骑士的奥德赛大冒险.md`

---

**文档版本**: 1.0
**最后更新**: 2025-12-28
**作者**: Godot Developer Skill
