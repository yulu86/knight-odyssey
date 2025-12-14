# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

**游戏名称**：骑士的奥德赛大冒险  
**游戏类型**：2D像素风格平台跳跃游戏  
**开发引擎**：Godot 4.5  
**项目目标**：开发一个包含5个关卡的像素平台游戏，实现基础移动、跳跃、踩踏攻击、收集系统等核心功能。

## 常用命令

### 运行和测试
```bash
# 启动Godot编辑器（需要安装Godot 4.5）
godot --editor --path "."

# 运行测试场景
godot --path "." scenes/test/test.tscn

# 运行游戏（使用主场景）
godot --path "."
```

### 项目结构管理
```bash
# 查看项目目录树（ASCII格式）
tree /f /a

# 查看Git状态
git status

# 添加所有变更
git add .

# 提交变更
git commit -m "feat: 添加新功能"

# 推送到远程
git push origin master
```

## 高层架构

### 核心系统架构

项目采用基于状态机（State Machine）的架构设计，主要包含以下核心系统：

1. **玩家系统（PlayerSystem）**
   - 基于状态机的角色控制
   - 支持空闲、行走、跳跃、二段跳、下落、踩踏、受伤等状态
   - 位置：`scripts/characters/`

2. **游戏管理系统（GameManager）**
   - AutoLoad单例模式
   - 负责游戏状态管理、进度保存、关卡切换
   - 计划实现中

3. **关卡系统（LevelSystem）**
   - 基于TileMap的关卡构建
   - 使用world_tileset.png和platforms.png资源
   - 计划实现中

4. **敌人系统（EnemySystem）**
   - 包含绿色史莱姆和紫色史莱姆
   - 状态机控制敌人行为
   - 计划实现中

### 关键设计模式

1. **状态机模式（State Machine）**
   - 玩家控制的核心架构
   - 清晰的状态转换逻辑
   - 易于扩展新状态

2. **单例模式（Singleton）**
   - 使用Godot的AutoLoad机制
   - GameManager、AudioManager、UIManager

3. **工厂模式（Factory）**
   - PlayerStateFactory管理状态创建
   - 便于状态对象的统一管理

### 文件组织结构

```
knight-odyssey/
├── assets/              # 游戏资源
│   ├── fonts/          # 字体文件
│   ├── music/          # 背景音乐
│   ├── sounds/         # 音效文件
│   └── sprites/        # 精灵图片
├── configs/            # 配置文件
│   └── player_config.cfg # 玩家配置
├── scenes/             # Godot场景文件
│   ├── characters/     # 角色场景
│   └── test/          # 测试场景
├── scripts/            # GDScript脚本
│   ├── characters/     # 角色脚本
│   │   └── states/     # 玩家状态脚本
│   ├── enemies/        # 敌人脚本
│   ├── levels/         # 关卡脚本
│   └── managers/       # 管理器脚本
│       └── config_manager.gd # 配置管理器
├── docs/               # 项目文档
│   ├── 01_GDD/        # 游戏设计文档
│   ├── 02_arch/       # 架构设计文档
│   └── 03_sprint/     # 敏捷开发文档
└── test/               # 单元测试
```

## 开发指南

### 状态机开发规范

1. **新增玩家状态**
   - 继承`PlayerState`基类
   - 实现必要的虚方法：`enter()`, `exit()`, `update()`, `handle_input()`
   - 在`PlayerStateFactory`中注册新状态
   - 更新`PlayerStateMachine`的State枚举

2. **状态转换规则**
   - 必须通过`state_changed.emit(new_state)`信号进行状态切换
   - 避免状态间直接依赖
   - 使用信号机制保持解耦

### 代码规范

1. **命名规范**
   - 类名：PascalCase（如`PlayerStateMachine`）
   - 文件名：snake_case（如`player_state_machine.gd`）
   - 变量名：snake_case（如`move_speed`）
   - 常量名：UPPER_SNAKE_CASE（如`MAX_JUMP_COUNT`）

2. **GDScript特性**
   - 使用`@export`标记可在检查器中配置的变量
   - 使用`@onready`延迟初始化节点引用
   - 避免使用中文字符
   - 使用类型注解提高代码可读性

3. **节点引用**
   - 优先使用相对路径获取子节点
   - 使用`$`符号简化路径书写
   - 避免深层次的节点依赖

### 资源管理

1. **音频资源**
   - 背景音乐：assets/music/（.mp3格式）
   - 音效：assets/sounds/（.wav格式）
   - 使用AudioManager统一管理

2. **图像资源**
   - 角色精灵：assets/sprites/knight.png
   - 场景瓦片：assets/sprites/world_tileset.png
   - 平台资源：assets/sprites/platforms.png
   - 收集物：assets/sprites/coin.png, fruit.png

3. **字体资源**
   - 主要字体：PixelOperator8.ttf
   - 强调字体：PixelOperator8-Bold.ttf
   - 特殊字体：zpix.ttf

### 配置管理

1. **配置文件系统**
   - 使用Godot ConfigFile格式（.cfg）
   - 配置文件位置：`configs/player_config.cfg`
   - ConfigManager单例负责加载和管理配置

2. **玩家移动配置**
   ```ini
   [player]
   move_speed=150.0        # 水平移动速度
   acceleration=300.0      # 加速度
   floor_friction=1200.0   # 地面摩擦力
   air_friction=1800.0     # 空气摩擦力
   jump_velocity=-320.0    # 跳跃初速度
   is_debug=false         # 调试开关
   ```

3. **使用配置系统**
   - ConfigManager已注册为AutoLoad单例
   - 在Player._ready()中自动加载配置
   - 使用`ConfigManager.get_player_value(key, default)`获取配置
   - 配置文件不存在时自动使用默认值

4. **配置文件修改**
   - 直接编辑`configs/player_config.cfg`文件
   - 修改后重启游戏生效
   - 所有数值类型需使用英文小数点格式

## 已实现功能

### 玩家控制系统
- ✅ 基础角色移动（A/D键）
- ✅ 空闲和行走状态
- ✅ 状态机基础架构
- ✅ 动画系统集成（idle, walk）
- ✅ 配置文件系统（移动参数外部化）

### 待实现功能（按优先级）

**Must Have（必须）**
1. 跳跃机制和物理系统
2. 二段跳系统
3. 踩踏攻击机制
4. 敌人系统（绿色/紫色史莱姆）
5. 生命值系统

**Should Have（应该）**
1. 收集系统（金币、水果）
2. 计分系统
3. 5个基础关卡

**Could Have（可以）**
1. UI界面（HUD、暂停菜单）
2. 背景音乐和音效系统
3. 关卡选择界面

## 开发工作流

1. **创建新功能**
   - 先在`docs/03_sprint/02_story/`创建详细的Story文档
   - 实现核心功能代码
   - 创建或更新对应的测试场景
   - 更新backlog.md状态

2. **测试流程**
   - 使用`scenes/test/test.tscn`进行快速测试
   - 验证状态转换是否正确
   - 检查动画和物理效果

3. **提交规范**
   - 使用语义化提交信息
   - feat: 新功能
   - fix: 修复bug
   - docs: 文档更新
   - refactor: 代码重构

## 调试技巧

1. **状态机调试**
   - 在状态切换时添加print语句
   - 使用Godot调试器监视状态变量
   - 检查动画播放是否与状态匹配

2. **物理调试**
   - 启用碰撞形状可视化
   - 监控velocity值变化
   - 检查is_on_floor()状态

3. **性能监控**
   - 使用Godot性能分析器
   - 监控帧率是否稳定在60FPS
   - 注意内存使用情况

## 注意事项

1. **Godot版本**
   - 项目使用Godot 4.5
   - 确保GDScript语法符合4.5规范

2. **AutoLoad配置**
   - 需要在项目设置中配置AutoLoad单例
   - singleton脚本中禁止使用class_name

3. **物理设置**
   - 项目使用像素物理单位
   - 重力值需要适合平台跳跃手感

4. **资源导入**
   - 图片资源需要正确设置导入设置
   - 音频资源注意循环设置

## 相关文档

- 游戏设计文档：`docs/01_GDD/01_游戏设计文档_骑士的奥德赛大冒险.md`
- 架构设计文档：`docs/02_arch/01_游戏架构概要设计_骑士的奥德赛大冒险.md`
- 产品Backlog：`docs/03_sprint/01_backlog.md`
- 详细Story：`docs/03_sprint/02_story/`

## 开发环境要求

- Godot Engine 4.5
- Python 3.8+（用于工具脚本）
- Git（版本控制）

## 联系方式

如需了解项目详情或有技术问题，请参考项目文档或查看Git提交历史。