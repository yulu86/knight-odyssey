# Task 5: 场景创建操作指南

**Story ID**: `KO_20251216_007`
**Task**: Task 5 - 创建基础关卡场景
**状态**: 脚本已完成，需要创建场景文件

---

## ✅ 已完成的工作

### 1. LevelBase基类脚本
- 文件路径：`scripts/levels/level_base.gd`
- 实现了关卡基础功能：
  - `level_ready`信号
  - `level_started`事件发送
  - `spawn_player()` - 玩家生成
  - `on_player_entered()` - 玩家进入关卡
  - `on_player_exited()` - 玩家离开关卡
  - `on_goal_reached()` - 到达终点逻辑

### 2. Level_1_1_Grassland脚本
- 文件路径：`scripts/levels/level_1_1_grassland.gd`
- 继承自LevelBase
- 设置了关卡参数：
  - level_id = "1-1"
  - level_name = "草原平原"
  - theme_type = "grassland"

### 3. 单元测试
- 文件路径：`test/unit/levels/test_level_base.gd`
- 6个测试用例全部通过✅
  - test_level_emits_ready_signal
  - test_level_emits_started_event
  - test_spawn_player_creates_player
  - test_spawn_player_emits_signal
  - test_on_player_entered_saves_reference
  - test_on_player_exited_clears_reference

---

## 🎯 需要完成的任务

### Step 5.1: 创建关卡场景结构

**请在Godot编辑器中按以下步骤操作：**

#### 1. 创建关卡目录

项目目录应该已经存在以下结构：
```
scenes/
└── levels/
    └── 1-1_grassland/
        └── level_1_1_grassland.tscn  ← 需要创建
```

如果不存在，请在文件系统中手动创建文件夹。

#### 2. 创建关卡场景文件

**操作步骤：**

1. 打开Godot编辑器
2. 点击顶部菜单：**场景** → **新场景**
3. 在弹出的节点选择对话框中：
   - 搜索并选择 **Node2D**
   - 点击右下角 **"添加为根节点"** 按钮
4. 在右侧检查器（Inspector）中：
   - 找到节点的Name字段
   - 重命名为：`Level_1_1_Grassland`
5. 保存场景：
   - 点击顶部菜单：**场景** → **保存场景**（或按Ctrl+S/Cmd+S）
   - 导航到：`scenes/levels/1-1_grassland/`
   - 文件名：`level_1_1_grassland.tscn`
   - 点击 **"保存"** 按钮

#### 3. 添加关卡节点结构

**在场景树中，按照以下结构添加节点：**

```
Level_1_1_Grassland (Node2D) - 挂载脚本 level_1_1_grassland.gd
├── TileMap (TileMap) - 地形绘制
├── PlayerSpawn (Marker2D) - 玩家出生点
├── Enemies (Node2D) - 敌人容器
├── Collectibles (Node2D) - 收集物容器
└── Goal (Area2D) - 终点区域
    ├── CollisionShape2D (CollisionShape2D)
    └── Sprite2D (Sprite2D)
```

**详细操作步骤：**

**添加TileMap：**
1. 在场景树中，右键点击 `Level_1_1_Grassland`
2. 选择 **添加子节点**
3. 搜索并选择 **TileMap**
4. 重命名为：`TileMap`

**添加PlayerSpawn：**
1. 右键点击 `Level_1_1_Grassland`
2. 选择 **添加子节点**
3. 搜索并选择 **Marker2D**
4. 重命名为：`PlayerSpawn`
5. 在2D视图中，将其移动到关卡起点位置（建议：x=100, y=300）

**添加Enemies容器：**
1. 右键点击 `Level_1_1_Grassland`
2. 选择 **添加子节点**
3. 搜索并选择 **Node2D**
4. 重命名为：`Enemies`

**添加Collectibles容器：**
1. 右键点击 `Level_1_1_Grassland`
2. 选择 **添加子节点**
3. 搜索并选择 **Node2D**
4. 重命名为：`Collectibles`

**添加Goal区域：**
1. 右键点击 `Level_1_1_Grassland`
2. 选择 **添加子节点**
3. 搜索并选择 **Area2D**
4. 重命名为：`Goal`

**为Goal添加碰撞体：**
1. 右键点击 `Goal`
2. 选择 **添加子节点**
3. 搜索并选择 **CollisionShape2D**
4. 在检查器中，找到 **Shape** 属性
5. 点击下拉菜单，选择 **"新建RectangleShape2D"**

**为Goal添加Sprite：**
1. 右键点击 `Goal`
2. 选择 **添加子节点**
3. 搜索并选择 **Sprite2D**
4. 在检查器中，找到 **Texture** 属性
5. 点击下拉菜单，选择 **"加载"**
6. 选择 `assets/sprites/coin.png` 作为临时旗帜图标（后续替换为旗帜图标）
7. 在检查器中，设置 **Offset**：y = -16（向上偏移）
8. 在检查器中，设置 **Scale**：x = 2, y = 2（放大2倍）

#### 4. 配置关卡脚本

**操作步骤：**

1. 在场景树中选择 `Level_1_1_Grassland` 根节点
2. 在检查器中找到 **脚本（Script）** 属性
3. 点击右侧的文件夹图标
4. 在弹出的对话框中：
   - 选择 `scripts/levels/level_1_1_grassland.gd`
   - 点击 **"打开"** 按钮
5. 脚本应该自动挂载，你会看到导出变量：
   - `Level ID`: `1-1`
   - `Level Name`: `草原平原`
   - `Theme Type`: `grassland`

6. 保存场景（Ctrl+S/Cmd+S）

#### 5. 配置Goal碰撞体

**操作步骤：**

1. 在场景树中展开 `Goal`
2. 选择 `CollisionShape2D`
3. 在2D视图中，你会看到一个绿色的矩形
4. 拖动矩形控制点，调整大小以覆盖终点区域（建议：50x50像素）
5. 将Goal节点移动到关卡终点位置（建议：x=1500, y=300）

#### 6. 配置Goal监测层

**操作步骤：**

1. 选择 `Goal` (Area2D) 节点
2. 在检查器中，找到 **Monitoring** 属性
3. 确保勾选 ✓ **Monitoring**（启用监测）
4. 找到 **Monitorable** 属性
5. 确保勾选 ✓ **Monitorable**（允许被监测）
6. 找到 **Collision Layer** 属性
7. 勾选第1层（Layer 1）
8. 找到 **Collision Mask** 属性
9. 勾选第2层（Layer 2）- 玩家通常在第2层

#### 7. 创建终点检测脚本

由于这步涉及到新文件创建，我建议暂时跳过，先完成TileMap配置。终点检测功能将在Task 6中实现。

---

### Step 5.4: 配置TileMap

**目标：** 创建一个简单的测试关卡地形

#### 1. 创建TileSet资源

**操作步骤：**

1. 在场景树中选择 `TileMap` 节点
2. 在检查器中找到 **Tile Set** 属性
3. 点击右侧的下拉菜单，选择 **"新建TileSet"**
4. 点击下拉菜单右侧的 **"保存"** 图标
5. 保存到：`assets/resources/tileset/grassland_tileset.tres`
6. 点击 **"保存"** 按钮

#### 2. 配置TileSet地形图集

**操作步骤：**

1. 在检查器中，找到 **TileSet** 资源（点击它进入编辑模式）
2. 在底部面板中，选择 **"Tile Set"** 标签
3. 找到 **Physics Layers** 部分
4. 点击 **"添加 Physics Layer"** 按钮
5. 你会看到一个新的物理层（Layer 0）

#### 3. 导入地形图集

**操作步骤：**

1. 在场景树中选择 `TileMap` 节点
2. 在底部面板中，选择 **"TileMap"** 标签
3. 在右上角，找到 **"Setup"** 部分的 **"Tile Set"**
4. 确保已经设置为：`res://assets/resources/tileset/grassland_tileset.tres`
5. 在底部面板的 **Tile Set** 标签中：
   - 点击 **"添加 Atlas Source"** 按钮
   - 在弹出的对话框中：
     - 点击 **"Texture"** 属性的下拉菜单
     - 选择 **"加载"**
     - 导航到：`assets/sprites/platforms.png`
     - 点击 **"打开"** 按钮
   - 点击 **"添加"** 按钮

#### 4. 配置地形碰撞

**操作步骤：**

1. 在底部 **Tile Set** 标签中，你会看到导入的地形图集
2. 选择第一个地形块（左上角的方块）
3. 在右侧面板中，找到 **Physics Layer 0** 部分
4. 点击 **"添加 Polygon"** 按钮
5. 地形块会显示碰撞形状（通常是一个矩形）
6. 如果碰撞形状不正确，可以：
   - 拖动顶点调整形状
   - 点击 "+" 添加新顶点
   - 点击 "x" 删除顶点
7. 为其他需要碰撞的地形块重复此步骤

#### 5. 绘制测试关卡

**操作步骤：**

1. 确保在场景树中选择了 `TileMap` 节点
2. 在底部面板中，选择 **TileMap** 标签
3. 在 **选择** 面板中，点击一个地形块
4. 在2D视图中：
   - 点击开始绘制地形
   - 拖动鼠标连续绘制
   - 右键可以擦除

**绘制建议（从左到右）：**

- 地面平台（y=350）：
  - 从x=0到x=2000
  - 使用实心地形块

- 起点平台（y=250）：
  - 从x=100到x=200
  - 与地面平台相连

- 中间平台1（y=200）：
  - 从x=400到x=500

- 中间平台2（y=150）：
  - 从x=600到x=700

- 终点平台（y=250）：
  - 从x=1400到x=1500
  - 与地面平台相连

- 墙壁（可选）：
  - 添加一些垂直墙壁作为障碍物

#### 6. 保存场景

完成绘制后，保存场景（Ctrl+S/Cmd+S）

---

## ✅ 验收标准检查

完成以上步骤后，请验证以下内容：

### 场景结构检查
- [ ] `scenes/levels/1-1_grassland/level_1_1_grassland.tscn` 文件已创建
- [ ] 场景树包含所有必需节点：TileMap, PlayerSpawn, Enemies, Collectibles, Goal
- [ ] Goal节点包含CollisionShape2D和Sprite2D子节点
- [ ] Level_1_1_Grassland节点挂载了`level_1_1_grassland.gd`脚本

### TileMap检查
- [ ] TileSet资源已创建：`assets/resources/tileset/grassland_tileset.tres`
- [ ] 导入了地形图集：`assets/sprites/platforms.png`
- [ ] 地形块配置了碰撞形状（Physics Layer 0）
- [ ] 绘制了至少一个地面平台
- [ ] PlayerSpawn位置合理（x≈100, y≈300）
- [ ] Goal位置合理（x≈1500, y≈300）

### 功能检查
- [ ] 场景可以正常打开
- [ ] 没有脚本错误或警告
- [ ] TileMap地形正确显示
- [ ] Goal的碰撞区域设置正确

---

## 🚀 下一步：Task 6

完成场景创建后，下一步将：
1. 创建Goal检测脚本（GoalArea）
2. 实现关卡完成逻辑
3. 创建结算界面UI
4. 测试完整流程

---

## 📝 注意事项

### 常见问题

**问题1：TileMap不显示地形**
- 检查TileSet是否正确加载
- 确认地形图集路径正确
- 查看是否选择了正确的Atlas Source

**问题2：碰撞不生效**
- 检查TileMap的Physics Layer是否设置
- 确认地形块配置了碰撞形状
- 验证Player的Collision Mask是否包含Layer 0

**问题3：Goal区域无法触发**
- 检查Goal的Collision Mask是否包含Player层
- 确认Player的Collision Layer正确
- 验证Goal的CollisionShape2D大小和位置

### 调试技巧

1. **使用调试视图：**
   - 点击菜单：**调试** → **可调试碰撞形状**
   - 可以看到所有碰撞形状的可视化

2. **检查节点属性：**
   - 确保所有必需的属性都已设置
   - 查看检查器中是否有错误提示

3. **查看输出窗口：**
   - 按F3打开输出窗口
   - 查看是否有错误或警告信息

---

## 📚 参考资源

- Godot官方TileMap教程：https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html
- 项目TileMap图集：`assets/sprites/platforms.png`
- 项目TileMap图集：`assets/sprites/world_tileset.png`

---

**操作指南结束**

如有任何问题，请参考上述调试技巧或查看Godot官方文档。
