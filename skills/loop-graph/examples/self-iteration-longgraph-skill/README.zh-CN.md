# 示例：longgraph 自迭代（公开 Git 证据）

这是一条 **public-safe、可用 commit 核验** 的案例。它不是虚构项目 run，也不是私有
客户轨迹，而是 **本仓库**（证据窗口期内曾以 `octopus-skill` 发布；产品品牌现为
**longgraph** / `longgraph-skill`）在把 loop-graph 方法固化成可发布 skill 期间的公开历史。

给首次读者的结论：longgraph 不只是方法论长文。唯一记分牌、清洁上下文监督者、无
wake 边、gate-wait backlog、热文件有界等规则，都来自多日 agent 工作中的真实
失败模式，并写回了公开库。

## 证据窗口（冻结）

| 信号 | 数值 |
| --- | --- |
| 固定锚点 commit | `6efcb7f0e8cb834027e3722342fee57c26cb2fdf` |
| 锚点说明 | `fix(loop-graph): give the snapshot a drain and stop mirroring the repo's own routing (#56)` |
| 公开 Git 窗口 | 2026-07-19 10:53 +08:00 → 2026-08-02 14:48 +08:00 |
| 日历跨度 | 约 14.2 天（约 340 小时 *项目存活* wall-clock） |
| 窗口内公开 commit | 87 |
| 触及的独立文件数 | 74 |
| 累计插入 / 删除 | 6981 / 3958 |
| 至少有一次提交的日历日 | 12 |

**如何读这些数字。** 它们是 **公开 Git 事实**，不是连续模型执行小时，也不是无人值守
生产自治声明。日历跨度是从首个公开 commit 到锚点的 wall-clock 项目时间。读者可对
固定锚点复算：

```bash
# 对照固定锚点复算（不要用“当前 HEAD 随便多少”）
ANCHOR=6efcb7f0e8cb834027e3722342fee57c26cb2fdf
git rev-list --count $ANCHOR
git log --name-only --pretty=format: $ANCHOR | sort -u | grep -v '^$' | wc -l
git log --numstat --pretty=format: $ANCHOR | awk 'NF==3{a+=$1;d+=$2} END{print a,d}'
git log --format="%ad" --date=short $ANCHOR | sort -u
git log --oneline --reverse $ANCHOR | head
```

若 `HEAD` 已越过锚点，上表仍以冻结窗口为准，而不是“当前 tip 随便多少”。

## 窗口说明了什么

大约两周公开开发里，skill 从最初的 loop+监督者草图，收敛成一套有立场的图工程
提示词库。工作不是单个 demo PR，而是跨宿主打包、生成期与运行期分离、定时器设计、
gate-wait 行为、ledger 边界，以及教人理解这张图的文档。

### 本窗口蒸馏出的方法规则

每一条都落成公开树里的产品行为（模板、方法论或宿主 reference），而不只是聊天建议：

| 蒸馏出的规则 | 公开证据（标题 + 短 SHA） |
| --- | --- |
| **生成期与运行期分离** | `324373c` feat: separate authoring and runtime skills (#30) |
| 按宿主建模 **上下文延续**（不假设每次 fire 都是冷启动） | `220bbe5` feat(loop-graph): model per-host context carry… (#33) |
| 里程碑受审时的 **可审计 gate-wait backlog** | `63cac58` feat(loop-graph): add audit-safe gate-wait backlog |
| **阻塞 ≠ 停机**——写集解耦的旁路继续推进 | `8a8b055` feat(loop-graph): blocked is not parked… (#48) |
| **每节点自驱定时器；执行者与监督者之间无 wake 边** | `8750d1b` feat(loop-graph)!: give each node its own timer; drop the wake edge (#53) |
| **每条持久段有界**，热边不会无限涨 | `e3617d2` chore(loop-graph): convergence round — bound every durable section (#52) |
| **按里程碑定 fire 体量**，而不是按轮数硬切 | `95a400d` feat(loop-graph): size the fire to the milestone… (#55) |
| **“目标已达成”是写进状态的事实**，不是感觉 | `3e46252` fix(loop-graph): make reaching the goal a state the run writes down (#54) |
| 显式支持 **多任务 loop** 与 **中途换宿主** | `29a3bb4` docs: surface multi-task loops and mid-run host switches (#37) |
| 从真实 run 的失败模式硬回图词汇 | `ac05d60` docs+quest+scout: … quest hardening from real runs… (#19) (#20) |

这些 commit 在 GitHub 与任意 clone 上可检。对本案而言，它们就是“效率证据”：控制
形态在真实压力下反复修订，却始终保持 **Markdown skill**，而不是新写一个 runtime
kernel。

## 叙事（控制面，不是客户域）

1. **触发。** 长编码目标撑破单次上下文。同一循环里的自评，只能从产生漂移的同一段历史里给自己打分。
2. **形状。** 设计一次 → 把执行者/监督者提示词与 ledger 冻在 `.longgraph/<日期-slug>/` → 每节点自有定时器、只写自己的边。
3. **倒逼产品改动的失败模式。** 会拖死对端的 wake 边；一阻塞就整机停；里程碑审计时执行者空转；热文件涨到截断读；宿主 fire 看似冷启动其实带着旧上下文。
4. **写回。** 每种失败模式变成模板与方法论里的持久规则，再变成窗口内的公开 commit。
5. **读者收获。** 不必私有会话日志，也能从 Git 找回“图为什么长这样”。

## 本案明确不是什么

- 不是连续多日、无人干预的 LLM 运行声明。
- 不是生产自动驾驶或编排服务。
- 不是脱敏后的私有客户记分卡（那些留在项目本地；见
  [公开/私有边界](../../../../docs/public-private-boundary.md)）。
- 不替代教学型虚构例子（[`add-tests-to-cli`](../add-tests-to-cli/)、
  [`migrate-blob-storage`](../migrate-blob-storage/)）——后者展示 *ledger 形态*。

## 证据边界

**本案允许写入**

- 本仓库的公开 commit SHA、标题与日期
- 来自 `git log --numstat` 的文件数与增删行
- 已在 `AGENTS.md` / 方法论中公开的产品规则
- 指向本仓库其他 **公开** 示例的链接

**刻意排除**

- 私有客户名、业务域或语料指标
- 本机绝对路径、内网主机名、凭据
- 原始 agent 会话、session JSONL、私有 `.longgraph/` ledger
- 把日历小时等同于模型 GPU 小时或无人值守自治的说法

## 相关阅读

- [公开 / 私有边界](../../../../docs/public-private-boundary.md)
- [方法论](../../../../lib/methodology.md)
- [migrate-blob-storage](../migrate-blob-storage/) — 更长的*虚构* run，展示闸门与监督者推翻“自报证据”
- 根目录 [证据](../../../../README.zh-CN.md#证据) 一节
