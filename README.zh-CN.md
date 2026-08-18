<div align="center">

# longgraph

**面向 Claude Code / Cursor / Codex / Grok Build 的长周期智能体 skill。**

用持久 ledger、清洁上下文监督者与可验证闸门，抑制 agent 漂移。
同一 loop 可持续消化多个长任务（不必彼此相关）；中途换宿主时，
对着同一批文件重发提示词即可继续。

设计一次 → 编译成持久 loop-graph → 一路验证到真正完成。

[![GitHub stars](https://img.shields.io/github/stars/levi-qiao/longgraph-skill?style=flat-square&color=6C63FF)](https://github.com/levi-qiao/longgraph-skill/stargazers)
[![License: MIT](https://img.shields.io/badge/License-MIT-14B8A6?style=flat-square)](LICENSE)
[![欢迎 PR](https://img.shields.io/badge/PRs-welcome-22C55E?style=flat-square)](CONTRIBUTING.md)
![宿主：Claude Code · Cursor · Codex · Grok Build](https://img.shields.io/badge/Hosts-Claude%20Code%20·%20Cursor%20·%20Codex%20·%20Grok%20Build-111827?style=flat-square)
![类型：agent skill · 提示词库](https://img.shields.io/badge/Type-agent%20skill%20·%20prompt%20library-0EA5E9?style=flat-square)
[English](README.md) · 简体中文

</div>

<img alt="执行者与清洁上下文监督者两个 loop 并排运行" src="assets/graph.png" width="100%" />

**longgraph**（`longgraph-skill`）是一套精选的 **智能体 skill** 与跨宿主
**提示词库**，面向 **长周期 / long-horizon** 智能体任务——多小时编码、多里程碑迁移、
**同一 loop 里持续消化多个长任务**（彼此不必相关），以及任何会撑破单次上下文窗口的
工作。它是 **面向 agent 的图工程**：把执行者、监督者、侦察者等专门角色，用持久、可检查的
文件连成小图——**不是**又一个编排运行时。记分牌在磁盘上，因此可以 **中途换宿主**：
打开同一工作区，重发已固化的节点提示词，即可继续。

> **一张持久图，跨宿主运行。** 简单、自包含的目标直接交给宿主的普通 task
> 或 goal；longgraph 只在持久图结构真正有价值时出场。

> **已从 octopus 更名。** 同一套库；主品牌现为 **longgraph** /
> `longgraph-skill` / `/longgraph` / `.longgraph/`。旧帖里的
> `octopus-skill`、`/octopus`、`.octopus/` 仍可通过 GitHub 仓库重定向、
> install 遗留 symlink、以及进行中的 run 目录别名继续使用（见
> [快速开始](#快速开始) 与 [更名说明](#从-octopus-更名)）。

## 证据

这些不是单轮 demo。longgraph 是 **Markdown skill / 提示词库**（不是编排运行时）。
下表混合了 **可复算的公开 Git**、**仅功能层的脱敏多日模式**，以及 **教学合成**。

| 案例 | 读者可核验的内容 | 类型 |
| --- | --- | --- |
| [**本 skill 自迭代**](skills/loop-graph/examples/self-iteration-longgraph-skill/README.zh-CN.md) | **87** 次公开 commit，跨越约 **14 个日历日**（2026-07-19 → 2026-08-02），触及 **74** 个文件；无 wake 边、gate-wait backlog、阻塞≠停机、热边有界、生成期≠运行期等规则写回库内 | 公开 Git 事实 — 固定锚点 `6efcb7f` |
| [**多日控制面模式**](skills/loop-graph/examples/redacted-multiday-control-plane/README.zh-CN.md) | 多日 wall-clock、数十轮、多条 directives：持久 ledger、清洁上下文监督者推翻自报证据、不可跳过闸门、阻塞旁路、owner A/B/C — **只写功能**，无私有载荷 | 脱敏真实 run 模式 |
| [**migrate-blob-storage**](skills/loop-graph/examples/migrate-blob-storage/README.md) | 多里程碑 ledger：试点→全量、强制收敛、监督者推翻自报证据、不可跳过闸门 + 阻塞旁路 | 教学合成（虚构应用） |
| [**add-tests-to-cli**](skills/loop-graph/examples/add-tests-to-cli/README.md) | 最小完整 run：三轮、register-then-defer、清洁上下文监督意图 | 教学合成（虚构 CLI） |

**时钟怎么读。** 自迭代窗口里的约 14 天 / 约 340 小时是 **项目 wall-clock**
（首个公开 commit → 冻结锚点），不是连续模型执行时长，也不是无人值守生产自治。
Git 复算命令见[自迭代案例](skills/loop-graph/examples/self-iteration-longgraph-skill/README.zh-CN.md)。
脱敏多日卡只用 **粗粒度桶**，**不能**用私有 Git 复算——见其证据边界。

后续案例的发布规则见：
[公开 / 私有边界](docs/public-private-boundary.md)。

## 什么时候用

出现下面任一需求时，优先考虑 longgraph：

- **长周期 agent** 在上下文压缩 / 会话重置后仍能继续推进
- 需要 **持久任务 ledger**（唯一记分牌），而不是靠聊天记忆记进度
- **一个 loop 里连续做多个长任务**——队列式推进，任务之间可以不相关
- **宿主可换、进度不断**——Claude Code ↔ Cursor ↔ Codex ↔ Grok Build 中途切换，对着同一批文件重发提示词即可
- 需要 **独立的清洁上下文监督者**——而不是同一 agent 自评
- **可验证的完成**：针对真实产物重跑验收门，而不是自我报告 “done”
- 多里程碑、**不可跳过闸门**、明确的 owner 红线
- 需要跨 **Claude Code · Cursor · Codex · Grok Build** 的 **Markdown skill / 提示词库**

### 什么时候*不要*用

- 一次性小改动、PR 体量任务，或单次干净会话就能做完
- 你要的是 **运行时框架**（LangGraph、CrewAI、AutoGen、自建 agent 服务）
- 只需要一段短提示词，不需要 ledger、闸门或独立复审

### 和常见方案比

| 方案 | 需要运行时/服务？ | 独立验证器 | 持久记分牌 | 多任务队列 + 中途换宿主 |
| --- | --- | --- | --- | --- |
| LangGraph / CrewAI / AutoGen | 是 | 自己写 | 通常有 | 绑框架 / 部署栈 |
| 单条超长 prompt / 单个 skill | 否 | 无（自评） | 弱（聊天记忆） | 弱——进度跟着会话死 |
| **longgraph（本仓库）** | **否——纯 Markdown** | **有（监督者节点）** | **有（`ledger.md`）** | **有——文件即 run，重发提示词即可** |

相关搜索词：*longgraph skill*、*长周期智能体 skill*、*long-horizon agent skill*、
*防止 agent 漂移*、*多任务 agent loop*、*中途切换 AI 编程宿主*、
*Claude Code 多 agent 监督*、*Grok Build agent loop*、*agent ledger*、*loop-graph*、
*agent 图工程*、*清洁上下文复审*。

## 为什么需要 longgraph

长周期智能体往往以相似方式漂移：范围不断膨胀，“完成”变成自我报告，测试不再证明真实
路径，早期决定则随着上下文丢失。longgraph 把保护机制搬到模型记忆之外：

- **完成必须经过验证** —— 针对真实产物重新运行验收门。
- **状态持久可查** —— ledger 跨越上下文丢失，并始终作为唯一记分牌。
- **多长任务、一个 loop** —— ledger 是持续队列；条目可以彼此独立（迁移、测试债、
  文档、闸门），不必硬塞进同一个「大目标」叙事。
- **宿主可移植** —— 进度在 `.longgraph/<日期-slug>/` 的文件里，不在聊天记录里。
  换宿主打开同一工作区，重发已编译的节点提示词，即可从下一个未关闭条目继续。
- **清洁上下文复审** —— 独立监督者能发现执行者身处同一历史时看不到的漂移。
- **强制收敛** —— 定期停止增长、测量变化并做减法。
- **低负担 owner 裁决** —— 真正需要 owner 的问题会变成简短、有推荐的 A/B/C
  选择题，而不是一份技术作业。

它是 Markdown 提示词，不是编排框架：无需应用运行时、服务端或厂商绑定。
可作为 **Claude Code 插件**安装，或用 install 脚本 symlink 到 **Codex / Cursor /
Grok Build**。Grok Build 上的运行节点仍是 prompts-only：两条 `/loop`，不直接拉起。

## 多任务 loop 与中途换宿主

**一个 loop 是队列，不是单一故事。** 每轮仍只做完一个 ledger 条目（实现 → 验证 →
记账），但 ledger 可以同时挂很多长条目——相关里程碑，或互不相关的 backlog
（gate-wait backlog 是极端情形：与当前审计对象无依赖的有用工作）。下一个长任务换了
主题，也不必重开一张图。

**宿主可换，文件不可丢。** 编译后的 loop-graph run 把提示词与状态固化在
`.longgraph/<日期-slug>/`。要换地方继续：

1. 使用能看到这些文件（以及项目本身）的工作区。
2. 在新宿主上重发同一份已固化的执行者（若有监督者则一并）提示词。
3. 节点读取 `ledger.md` / `directives.md`，从下一个未关闭条目继续。

不需要导出聊天 transcript。启动语法仍遵循各宿主方言（见
[按宿主拆分的 reference](skills/loop-graph/references/)）——可移植的是 **进度**，不是会话气泡。

## 该不该用 longgraph？

| 你的任务形态 | 选择 | 得到什么 |
| --- | --- | --- |
| 一个普通 task / 单次会话能完成的自包含目标 | 直接用宿主的普通 task 或 goal | 不加 longgraph 包装，不多一层 prompt |
| 多轮、持久状态、不可跳过的闸门、owner 边界、中途换宿主或独立验证 | [**longgraph / loop-graph**](skills/loop-graph/README.zh-CN.md) | 执行者 loop + 清洁上下文监督者，通过持久文件协作 |
| 多轮删无用 / 去重 / 复用 / 瘦身（同一张双节点图） | [**`/loop-converge`**](skills/loop-converge/README.zh-CN.md) | 已预填收敛绑包的 loop-graph 作者 |

**一句话：**不需要这张图，就不要用 longgraph。

## 快速开始

### Claude Code

从 marketplace 安装插件：

```text
/plugin marketplace add levi-qiao/longgraph-skill
/plugin install longgraph@longgraph-skill
```

### Codex、Cursor 或 Grok Build

安装库，并把 `/longgraph` 与 `/loop-converge`（以及遗留 `/octopus`）symlink 到会跟随链接的宿主：

```sh
curl -fsSL https://raw.githubusercontent.com/levi-qiao/longgraph-skill/main/install.sh | sh
```

本地克隆时，在仓库根目录运行 `./install.sh`。

在 Grok Build 上搭图：装好后直接 `/longgraph`。两个运行节点仍是 prompts-only，粘编译好的
`/loop` 行——见 [Grok Build](skills/loop-graph/references/grok.md)。Cursor 与
shell/cron 同样走 prompts-only 执行——见[宿主兼容性](#宿主兼容性)。

### 设计一次 run

调用 `/longgraph`（删无用 / 去重 / 瘦身用 `/loop-converge`）。它会自动识别
当前宿主、先检查工作区，只询问无法推断的 owner 决策，
再编译 loop-graph run。在 Codex 或 Claude Code 上选择“直接创建”后，它会在当前宿主启动两个运行节点；
选择 prompts-only 才需要手动或跨宿主启动（含 Grok Build）。也可以直接调用 `loop-graph`。

生成期与运行期严格分离：author skill 只编译，不执行。生成的节点遵循
`.longgraph/<日期-slug>/` 下已固化的本次 run 契约。

## 这张图怎么运行

| 角色 | 职责 | 持久边 |
| --- | --- | --- |
| **执行者** | 每轮只做一个 ledger 条目，同轮验证，再记录结果 | 读写 `ledger.md` |
| **监督者** | 在独立上下文中重新验证、为通过的工作建立 checkpoint，并纠正漂移 | 只读 ledger；只通过 directives 边纠偏（live queue + cold archive） |
| **侦察者**（可选） | 在关键路径之外研究一个有边界的问题 | 写 findings 文件，仅在 ledger 引用时读取 |

最关键的规则是：**一个节点 = 一段提示词 + 一条单写者边。** ledger 永远只有一个写者。
监督者不共享执行者上下文、不编辑记分牌，只能通过单向 directives 边来纠偏。

每条约束背后的理由见[方法论](lib/methodology.md)，节点与边模型见
[loop-graph 模型](skills/loop-graph/docs/model.md)。

## 宿主兼容性

| 宿主 | loop-graph 运行方式 |
| --- | --- |
| [**Codex**](skills/loop-graph/references/codex.md) | ✅ 自动识别宿主并直接创建两个运行节点 |
| [**Claude Code**](skills/loop-graph/references/claude-code.md) | ✅ 自动识别宿主；能力检查通过后直接创建两个后台运行会话 |
| [**Grok Build**](skills/loop-graph/references/grok.md) | prompts-only — 两个 `/loop` 任务（执行者 + 监督者），无 wake 边 |
| [**Cursor**](skills/loop-graph/references/cursor.md) | 仅作为 prompts-only 执行目标 |
| [**shell / cron**](skills/loop-graph/references/shell-cron.md) | 仅作为 prompts-only 执行目标 |

权威语法、节奏行为、上下文携带模型和宿主 hook 分别维护在
[按宿主拆分的 reference](skills/loop-graph/references/) 中；生成时只加载选中的宿主。
中途换宿主时复用同一套持久 run 目录，变的只是每一 tick 如何启动。

## 从 octopus 更名

| 曾经（遗留 / 仍接受） | 现在（主品牌） |
| --- | --- |
| 产品 `octopus`、仓库 `octopus-skill` | **longgraph**、仓库 **longgraph-skill** |
| 斜杠 `/octopus` | **`/longgraph`**（install 仍会把 `/octopus` symlink 到同一树） |
| 插件 `octopus@octopus-skill` | **`longgraph@longgraph-skill`** |
| run 目录 `.octopus/<日期-slug>/` | **`.longgraph/<日期-slug>/`**（进行中的 `.octopus/` run 原位继续） |
| 契约 `octopus.loop-graph.*` | **`longgraph.loop-graph.*`**（已有文件上的旧头仍属同一契约族） |

GitHub 更名会重定向旧的 clone/curl URL。请重新跑一次 `install.sh` 或重装插件，让磁盘上的主名称生效。

## 仓库地图

| 路径 | 用途 |
| --- | --- |
| [根 `SKILL.md`](SKILL.md) | `/longgraph` 入口；检查是否适用，再交给 loop-graph 生成 |
| [Loop-graph author](skills/loop-graph/SKILL.md) | 生成执行者、监督者、ledger 与 directive 产物 |
| [loop-converge](skills/loop-converge/SKILL.md) | 预设入口：代码收敛面试 → 同一套 loop-graph 编译 |
| [`lib/`](lib) | 共享方法论 |
| [宿主 references](skills/loop-graph/references) | 每个宿主一份、按需加载的运行事实 owner |
| [完整示例](skills/loop-graph/examples) | 公开 Git 自迭代 + 虚构 ledger，展示闸门运作 |
| [公开 / 私有边界](docs/public-private-boundary.md) | 什么可以进公开树，什么必须留在项目本地 |

## 治理

longgraph 把自己的 anti-bloat 规则用在库本身：**没有真实 run 证明过价值的提示词，不进库。**
精选、有主见，胜过大而全。

欢迎贡献，请先阅读[贡献指南](CONTRIBUTING.md)。

## 致谢

loop-graph skill 来自真实运行与社区输入。
[公开 Git 自迭代案例](skills/loop-graph/examples/self-iteration-longgraph-skill/README.zh-CN.md)
记录了方法如何被打磨进本库。特别感谢
[@BrightProgrammer7](https://github.com/BrightProgrammer7) 提供
`migrate-blob-storage` 示例，并参与打磨里程碑闸门与节点/边词汇。

## 许可

[MIT](LICENSE) © 2026 [levi-qiao](https://github.com/levi-qiao)
