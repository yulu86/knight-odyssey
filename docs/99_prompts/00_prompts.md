# 1. 创建PRD

```
ultrathink 请根据 docs/00_scratch/ 目录下的图片，设计2D平台跳跃游戏`骑士的奥德赛大冒险`，按照GDD模版，输出游戏需求GDD文档到 docs/01_GDD/ 目录下。
要求:
- 游戏平台：支持PC、Mac
- 操作：支持键盘、Xbox手柄操作
游戏资产：
- 游戏资产: assets/
参考：
- GDD模版：docs/99_prompts/templates/GDD.md
```

---

# 2. 架构设计

```
ultrathink use context7 请输出游戏架构概要设计:
1. 读取`游戏需求GDD`，理解游戏需求
3. 结合业界最佳实践中的成熟方案和合理的设计模式， 使用 `godot-copilot`技能进行架构设计
3. 委托 tech-docs-writer 输出详架构概要设计文档到 docs/02_arch/
约束：
- 概要设计文档输出架构设计需要按照`架构设计模版`输出
- 禁止输出详细实现代码 
参考文档:
- 游戏需求GDD: docs/01_GDD/01_游戏设计文档_骑士的奥德赛大冒险.md
- 架构设计模版: docs/99_prompts/templates/ARCH.md
```

---

# 3. sprint计划

```
ultrathink 请根据游戏GDD文档和架构概要设计文档，创建sprint开发计划:
1. 读取游戏需求GDD和游戏架构概要设计，遵循相关设计
2. 按照sprint开发方法论，支持迭代开发，分解story
3. 按照story维度，按照story模版输出story文档，保存到 docs/03_sprint/02_stroy/ 
4. 创建backlog文档，把所有story纳入其中，安排开发计划，并标记所有story为待开发状态，保存到 docs/03_sprint/01_backlog.md
约束：
- 禁止输出详细实现代码 
参考文档:
- 游戏需求GDD: docs/01_GDD/01_游戏设计文档_骑士的奥德赛大冒险.md
- 游戏架构概要设计: docs/02_arch/01_游戏架构概要设计_骑士的奥德赛大冒险.md
- story模版: docs/99_prompts/templates/STORY.md
```

---

# 4. Story手把手开发指导

```
use context7 请给出 US_20251213154200_02 02_基础跳跃机制.md 的手把手开发指导:
1. 读取Story文档和游戏架构概要设计
2. 详细设计Story实现方案
3. 让我确认设计方案
4. 等我确认设计方案准确无误后，输出手把手详细开发指导到 docs/04_hands_by_hands/ 
要求:
- 请严格遵守游戏架构概要设计
- 输出的设计和指导中只需要包含代码框架, 例如：类、方法的签名(方法名、参入、返回值)设计
- 需要我执行的操作，请在手把手指导中给出详细说明
约束：
- 必须使用`godot-copilot`技能 设计并输出指导
- 仅输出设计和指导，禁止编写代码
- 指导中禁止包含详细实现代码，例如
    ```gdscript
    func _physics_process(delta: float) -> void:
        # 处理输入
        var input_direction = Input.get_axis("move_left", "move_right")

        # 更新状态机
        state_machine.physics_update(delta)

        # 处理朝向（确保始终面向正确方向）
        if velocity.x != 0:
            sprite.flip_h = velocity.x < 0
    ```
参考文档：
- 游戏需求GDD: docs/01_GDD/01_游戏设计文档_骑士的奥德赛大冒险.md
- 游戏架构概要设计: docs/02_arch/01_游戏架构概要设计_骑士的奥德赛大冒险.md
- story文档：docs/03_sprint/02_story/02_基础跳跃机制.md
```

---

# 5. Story协同开发

```
use context7 请与我与我协开发 US_20251213154200_02 02_基础跳跃机制.md:
1. 切换到开发分支
2. 读取手把手开发指导
3. 严格遵守指导，使用`godot-copilot`技能与我协同开发，在需要我手动操作时暂停执行
4. 开发完成后，输出测试指导，并暂停执行
5. 等待我反馈测试结果
6. 更新backlog中的进展
7. 提醒我提交代码
约束：
- 必须遵守上下文和技能中声明的宪法(不可协商)
- 开发分支名称：{story id}_{story名称英文名，中划线连接单词}, 例如： US_20251207153000_01_Player-Basic-Movement
参考文档：
- 游戏需求GDD: docs/01_GDD/01_游戏设计文档_骑士的奥德赛大冒险.md
- 游戏架构概要设计: docs/02_arch/01_游戏架构概要设计_骑士的奥德赛大冒险.md
- backlog：docs/03_sprint/01_backlog.md
- story文档：docs/03_sprint/02_story/02_基础跳跃机制.md
- 手把手开发指导: docs/04_hands_by_hands/US_20251213154200_01_基础角色移动_手把手开发指导.md
```