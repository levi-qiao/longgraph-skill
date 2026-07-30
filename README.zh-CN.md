<div align="center">

# octopus 🐙

**面向长周期智能体任务的图工程。**

设计一次，编译成 loop 或 goal，一路验证到真正完成。

[![GitHub stars](https://img.shields.io/github/stars/levi-qiao/octopus-skill?style=flat-square&color=6C63FF)](https://github.com/levi-qiao/octopus-skill/stargazers)
[![License: MIT](https://img.shields.io/badge/License-MIT-14B8A6?style=flat-square)](LICENSE)
[![欢迎 PR](https://img.shields.io/badge/PRs-welcome-22C55E?style=flat-square)](CONTRIBUTING.md)
![宿主：Claude Code · Grok · Cursor · Codex](https://img.shields.io/badge/Hosts-Claude%20Code%20·%20Grok%20·%20Cursor%20·%20Codex-111827?style=flat-square)

[English](README.md) · 简体中文

</div>

<img alt="执行者与清洁上下文监督者两个 loop 并排运行" src="assets/graph.png" width="100%" />

octopus 是一个面向长周期智能体任务的精选提示词库。它不继续堆叠单个 loop 的复杂度，
而是把执行者、监督者、侦察者等专门角色连接成一个小图，只通过持久、可检查的文件通信。

> **一个脑子，多条腕。** 方法纪律保持不变，每条腕把它编译成宿主原生的运行形态。

## 为什么需要 octopus

长周期智能体往往以相似方式漂移：范围不断膨胀，“完成”变成自我报告，测试不再证明真实
路径，早期决定则随着上下文丢失。octopus 把保护机制搬到模型记忆之外：

- **完成必须经过验证** —— 针对真实产物重新运行验收门。
- **状态持久可查** —— ledger 跨越上下文丢失，并始终作为唯一记分牌。
- **清洁上下文复审** —— 独立监督者能发现执行者身处同一历史时看不到的漂移。
- **强制收敛** —— 定期停止增长、测量变化并做减法。
- **明确 owner 边界** —— 破坏性或未授权操作会让 run 硬停。

它是 Markdown 提示词，不是编排框架：无需应用运行时、服务端或厂商绑定。

## 30 秒选腕

| 你的任务形态 | 选择 | 得到什么 |
| --- | --- | --- |
| 一个能自驱到可验证完成的自包含目标 | [**quest**](skills/quest/SKILL.md) | 一段任务特有的 objective，运行时加载聚焦的 [**quest-executor**](skills/quest-executor/SKILL.md) 纪律 |
| 多里程碑、不可跳过的闸门、owner 审批，或需要真正独立的验证器 | [**loop-graph**](skills/loop-graph/README.zh-CN.md) | 一个执行者 loop + 一个清洁上下文监督者 loop，通过持久文件协作 |

**一句话：**任务形态决定用哪条腕，宿主只排除不可用的选项。

## 快速开始

### Claude Code

从 marketplace 安装插件：

```text
/plugin marketplace add levi-qiao/octopus-skill
/plugin install octopus@octopus-skill
```

### Codex 或 Cursor

安装库并链接到支持的宿主：

```sh
curl -fsSL https://raw.githubusercontent.com/levi-qiao/octopus-skill/main/install.sh | sh
```

从本地克隆安装时，在仓库根目录运行 `./install.sh`。

### 设计一次 run

调用 `/octopus`。它会采访你的目标、验收证据、里程碑、红线和宿主，再编译出合适的腕。
如果已经知道任务形态，也可以直接调用 `quest` 或 `loop-graph`。

生成期与运行期严格分离：author skill 只编译，不执行。编译后的 quest 只选择
`quest-executor`；loop-graph 生成的节点则遵循 `.octopus/<日期-slug>/` 下已固化的
本次 run 契约。

## 这张图怎么运行

| 角色 | 职责 | 持久边 |
| --- | --- | --- |
| **执行者** | 每轮只做一个 ledger 条目，同轮验证，再记录结果 | 读写 `ledger.md` |
| **监督者** | 从清洁上下文重新验证、为通过的工作建立 checkpoint，并纠正漂移 | 只读 ledger；只写 `directives.md` |
| **侦察者**（可选） | 在关键路径之外研究一个有边界的问题 | 写 findings 文件，仅在 ledger 引用时读取 |

最关键的规则是：**一个节点 = 一段提示词 + 一条单写者边。** ledger 永远只有一个写者。
监督者不共享执行者上下文、不编辑记分牌，只能通过单向 directives 边来纠偏。

每条约束背后的理由见[方法论](lib/methodology.md)，节点与边模型见
[loop-graph 模型](skills/loop-graph/docs/model.md)。

## 宿主兼容性

| 宿主 | **quest** —— 单一自包含目标 | **loop-graph** —— 有闸门或独立验证 |
| --- | --- | --- |
| **Grok** | ✅ `/goal <objective>`，自带原生对抗式验证器 | ✅ 执行者 `/loop` + 监督者 `/loop`；每次 fire 会串接上下文，需规划重置点 |
| **Codex** | ✅ `/goal`，或直接把 objective 作为 task 发出 | ✅ 两个节点都用定间隔 `/loop` 心跳；停泊节点绝不使用 `/goal` |
| **Claude Code** | ⚠️ 一个自定步 `/loop`；无独立验证器 | ✅ 自定步执行者 `/loop` + 监督者 `/loop` |
| **Cursor** | ❌ 无 goal 原语 | ✅ 执行者 `/loop` + 监督者 `/loop`，在同一会话内；若改用云端后台 agent，则每轮上限约 20 分钟 |
| **shell / cron** | ❌ 无 goal 原语 | ✅ 调度两个 loop；唯一每 tick 真正冷启动的宿主 |

权威语法、节奏行为、各宿主的**上下文携带模型**（下一轮从什么开始、代价多大）
和宿主特有 hook 统一维护在 [宿主方言矩阵](lib/host-dialects.md)。

## 仓库地图

| 路径 | 用途 |
| --- | --- |
| [根 `SKILL.md`](SKILL.md) | `/octopus` 生成期路由，只选腕，绝不执行生成结果 |
| [Quest author](skills/quest/SKILL.md) | 采访、编译并交付一段 goal objective |
| [Quest executor](skills/quest-executor/SKILL.md) | 仅由编译后 quest 加载的聚焦运行纪律 |
| [Loop-graph author](skills/loop-graph/SKILL.md) | 生成执行者、监督者、ledger 与 directive 产物 |
| [`lib/`](lib) | 共享方法论与宿主特有事实的单一 owner |
| [完整示例](skills/loop-graph/examples) | 展示 ledger 与闸门实际运行的具体 loop-graph run |

## 治理

octopus 把自己的 anti-bloat 规则用在库本身：**没有真实 run 证明过价值的提示词，不进库。**
精选、有主见，胜过大而全。

欢迎贡献，请先阅读[贡献指南](CONTRIBUTING.md)。

## 致谢

loop-graph 腕来自真实运行与社区输入。特别感谢
[@BrightProgrammer7](https://github.com/BrightProgrammer7) 提供
`migrate-blob-storage` 示例，并参与打磨里程碑闸门与节点/边词汇。

## 许可

[MIT](LICENSE) © 2026 [levi-qiao](https://github.com/levi-qiao)
