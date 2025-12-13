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