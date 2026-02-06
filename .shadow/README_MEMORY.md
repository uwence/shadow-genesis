# OpenClaw 代理记忆协议 (Agentic Memory Protocol)
> **为 AI 赋予持久化、结构化、仿生的记忆系统**

本手册详细记录了 OpenClaw 记忆系统的架构、设计哲学及操作指南。该系统旨在将 AI 从“只有7秒记忆的金鱼”（基于会话）转变为“首席参谋长”（具备长期连续性）。

---

## 🏗️ 1. 架构：三层记忆模型

该系统模仿人类大脑，分为三个不同的层级：

### 第一层：知识图谱 (语义记忆)
**位置:** `.shadow/memory/life/`
**结构:** P.A.R.A. 方法 (项目、领域、资源、归档)
**目的:** 存储*关于世界的事实*。即知道“是什么 (What)”和“是谁 (Who)”。

*   **Projects (项目)**: 有截止日期的活跃目标 (例如: `shadow-legion-forge`)。
*   **Areas (领域)**: 长期维护的责任区 (例如: `finance` 财务, `health` 健康)。
*   **Resources (资源)**: 感兴趣的参考资料。
*   **Archives (归档)**: 已完成或不再活跃的项目。

**存储格式:**
每个实体（例如一个具体项目）都有一个专属文件夹，包含：
*   `summary.md`: **简历**。简明扼要的高层概述。**默认加载**。
*   `items.json`: **档案柜**。海量的原子事实列表。**按需加载**。

### 第二层：每日笔记 (情景记忆)
**位置:** `.shadow/memory/YYYY-MM-DD.md`
**目的:** 存储*时间线上的事件*。即知道“何时 (When)”。
*   原始的、按时间顺序的对话日志。
*   历史记录的唯一真理来源。
*   用于提取并转化到第一层的“矿源”。

### 第三层：隐性知识 (程序性记忆)
**位置:** `.shadow/memory/life/resources/system/tacit_knowledge.md`
**目的:** 存储*操作模式*。即知道“如何 (How)”。
*   AI 人格设定 (例如: "Shadow/幽影")。
*   用户偏好 (沟通风格、工具选择)。
*   规则与边界。
*   **始终加载**，以确保人格的一致性。

---

## ⚙️ 2. 核心机制

### 🔍 分级检索 (Tiered Retrieval)
为了节省 Token 并提高效率，系统采用两级检索：
1.  **一级 (扫描)**: AI 读取 `summary.md`。获取要点：状态、截止日期、当前焦点。
2.  **二级 (深潜)**: 当你询问细节（“上周二的错误日志是什么？”）时，AI 才会读取 `items.json`。

### ⚛️ 原子事实 (Atomic Facts)
`items.json` 中的事实**永不删除 (NEVER DELETED)**。

**完整数据结构:**
```json
{
  "id": "fact-001",
  "fact": "项目使用 PostgreSQL 作为数据库",
  "status": "active | superseded",
  "createdAt": "2026-01-15T10:00:00+08:00",
  "lastAccessed": "2026-02-01T14:30:00+08:00",
  "accessCount": 5,
  "supersededBy": null,
  "supersededAt": null
}
```

**字段说明:**
| 字段 | 类型 | 说明 |
| :--- | :--- | :--- |
| `id` | string | 唯一标识符 |
| `fact` | string | 事实内容 |
| `status` | enum | `active` (有效) 或 `superseded` (已过时) |
| `createdAt` | ISO8601 | 创建时间 |
| `lastAccessed` | ISO8601 | 最后访问时间 (用于计算温度) |
| `accessCount` | integer | 访问次数 (用于计算重要性权重) |
| `supersededBy` | string/null | 指向替代此事实的新事实 ID |
| `supersededAt` | ISO8601/null | 被替代的时间 |

**更新逻辑**: 如果事实发生变化，旧事实会被标记为 `superseded` 并通过 `supersededBy` 指向新事实。这保留了*变化的历史*。

### 📉 记忆衰退 (仿生相关性)
并非所有事实都同等重要。系统根据 **近期性 (Recency)** 和 **访问频率 (Frequency)** 双维度对信息进行优先级排序。

**温度计算公式 (v0.4.0+)**:
```
时间衰减 = daysSinceLastAccess
频率加成 = log2(accessCount + 1) * 3  // 高频访问可抵消最多 ~15 天的时间衰减
有效衰减 = max(0, 时间衰减 - 频率加成)
```

**示例**: 一个 10 天未访问但被访问过 8 次的事实:
- 时间衰减 = 10
- 频率加成 = log2(9) * 3 ≈ 9.5
- 有效衰减 = max(0, 10 - 9.5) = 0.5 → 仍为 🔥 Hot

| 温度 | 有效衰减范围 | 位置 | 操作 |
| :--- | :--- | :--- | :--- |
| 🔥 **Hot** | < 7 | `summary.md` 顶部 | 关键信息，优先展示 |
| ♨️ **Warm** | 7-30 | `summary.md` 中部 | 背景信息 |
| 🧊 **Cold** | > 30 | 仅 `items.json` | 从 `summary.md` 移除（安全保存在 JSON 中等待唤醒） |

---

## 🕹️ 3. 操作手册

### 📥 日常工作流 (交互)

**A. 会话启动:**
AI 自动按照顺序读取：`.shadow/USER.md` -> `.shadow/memory/life/resources/system/tacit_knowledge.md` -> 今天的 Daily Note。

**B. 记录 (Write):**
相关会话日志记录到 `.shadow/memory/YYYY-MM-DD.md`。
> "记录这个决策：我们最终选择了 SQLite 而不是 Postgres。"

**C. 回忆 (Read):**
要求 AI 切换上下文。
> "加载 Shadow Legion 项目的上下文。"
> *(AI 读取 `.shadow/memory/life/projects/[项目名]/summary.md`)*

### 🛠️ 维护 (心跳提取)

**触发**: 定期运行（每周或重大里程碑后）。
**指令**: `memory-extract` 或 "整理记忆"。

**AI 将执行：**
1.  **扫描** 最近的 Daily Notes。
2.  **提取** 新的持久化事实 (Durable Facts)。
3.  **更新** 相关 Project/Area 中的 `items.json`。
4.  **重组** `summary.md`，应用记忆衰退算法（提升热记忆，隐藏冷记忆）。

---

## 🔗 系统链接
*   **隐性知识**: `.shadow/memory/life/resources/system/tacit_knowledge.md`
*   **开发调试经验库**: `.shadow/memory/life/resources/dev_knowledge/summary.md`
*   **用户指针**: `.shadow/USER.md`
