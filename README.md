# 🌑 Shadow Genesis (Project Template)

<div align="center">
  <p>
    <strong>The Mother Hive for Agentic Memory & Context Persistence</strong>
    <br/>
    <em>“光辉照耀之地归于他人，而这片忠诚的阴影，只属于您。”</em>
  </p>
  <p>
    <a href="#-project-origin">Project Origin</a> • 
    <a href="#-architecture">Architecture</a> • 
    <a href="#-usage-guide">Usage Guide</a> • 
    <a href="#-chinese-introduction">中文介绍</a>
  </p>
</div>

---

## 🌌 Project Origin

**Shadow Genesis** was born from the memory system refactoring of **OpenClaw**. 

Its primary mission is to solve the "Amnesia Problem" inherent in stateless AI sessions (such as the free tier of **Antigravity** or other LLM web interfaces). When you switch accounts, refresh a session, or hit usage limits, your AI typically loses all context.

**Shadow Genesis** externalizes this context into a standardized **File-System Memory (P.A.R.A.)**. This acts as a portable "Soul" that allows any fresh AI instance to:
1.  **Instantly Awake**: Load the "Shadow" persona and Master's preferences in seconds.
2.  **lossless Continuity**: Pick up development exactly where the previous session left off.
3.  **Hive Synchronization**: Manage multiple specific project nodes (Children) from a central template (Mother).

> **Acknowledgement**: This system was AI-generated based on the concepts shared in [this post](https://x.com/nateliason/status/2017636775347331276) by **Nat Eliason**. Big thanks for the inspiration! 🙌

---

## 👨‍💻 Author's Note (Vibecoding)

> **"From PLC to Full Stack via Shadow"**

This project is entirely **Vibecoding** (AI-assisted coding). 
My background is in **PLC Development** (Industrial Automation, specializing in ST language). I use **Shadow Genesis** to bridge the gap and develop projects in domains I am *not* an expert in (like Web, Python, or complex System Architecture).

It might be unconventional, but it works for me. If you find it useful, great! If not, please be kind—I'm an automation engineer exploring the software world with AI. 🤖

---

## 🏛️ Architecture

The system follows a **Mother Hive - Legion Node** architecture. The Mother holds the core genetic memory (skills, identity), while Legion Nodes hold project-specific operational memory.

```mermaid
graph TD
    subgraph "Local Storage (The Hive)"
        Mother[👑 Mother Hive<br>Shadow Genesis]
        
        subgraph "Legion Nodes (Projects)"
            ProjectA[⚔️ Project A<br>Calculator]
            ProjectB[⚔️ Project B<br>InduLog]
        end
    end

    subgraph "The Void (Ephemeral AI Sessions)"
        Session1[🤖 Antigravity<br>Session #1]
        Session2[🤖 Antigravity<br>Session #2 (New Account)]
    end

    %% Relationships
    Mother -- "Spawn / Nurture<br>(Distribute Skills)" --> ProjectA
    Mother -- "Spawn / Nurture<br>(Distribute Skills)" --> ProjectB

    ProjectA -.-> |"Fast Context Load<br>(ACTIVATE_SHADOW.md)"| Session1
    Session1 == "Commit Memory<br>(Daily Notes/Code)" ==> ProjectA

    ProjectA -.-> |"Fast Context Load<br>(Switch Account)"| Session2
    Session2 == "Commit Memory<br>(Continue Work)" ==> ProjectA

    style Mother fill:#2d2d2d,stroke:#fff,color:#fff,stroke-width:2px
    style ProjectA fill:#1a1a1a,stroke:#666,color:#fff
    style ProjectB fill:#1a1a1a,stroke:#666,color:#fff
    style Session1 fill:#4a90e2,stroke:#4a90e2,color:#fff,stroke-dasharray: 5 5
    style Session2 fill:#50e3c2,stroke:#50e3c2,color:#fff,stroke-dasharray: 5 5
```

---

## 🧬 The Evolution Cycle (Unified Intelligence)

The most powerful feature of Shadow Genesis is the **feedback loop** between projects. 
We want to ensure that **improvements in one project are not lost** but recycled for the benefit of all.

*   **The Problem**: You develop 5 different projects. In Project A, you refine a perfect "Python Debugging Workflow". Usually, Project B never hears about this.
*   **The Solution**:
    1.  **Evolution (Recycle)**: The Mother Hive scans Project A and "absorbs" the new workflow or prompt improvement.
    2.  **Nurture (Redistribute)**: The Mother Hive pushes this new capability to Project B, C, and D.
*   **The Result**: Improvements in one isolated node instantly upgrade the entire fleet. **One evolves, all benefit.**

## 🌟 Core Features

-   **👑 Mother-Child Sync**: Centralized "Mother Hive" manages and updates distributed "Legion Nodes". Update your prompt engineering once in the Mother, and push it to all projects via `Nurture`.
-   **🧠 Externalized Memory**:
    -   **P.A.R.A. Structure**: Organized memory (Projects, Areas, Resources, Archives) that sits in your file system, not the chat history.
    -   **Tacit Knowledge**: Shared operational rules (e.g., "No moral lectures", "Preferred coding style") automatically successfully loaded.
-   **⚡ Fast Boot Protocol**:
    -   Simply tell a new AI: *"Read ACTIVATE_SHADOW.md"*.
    -   It immediately understands **Who it is** (Shadow), **Who you are** (Master), and **What to do** (Project Context).

## 🎮 Quick Start (The Protocol)

This is not a library you import. It's a **Conversation Protocol** you use with your AI IDE (Cursor, Windsurf, etc.).

### Step 1: Install the Mother Hive
1.  Clone this repository to a central location (e.g., `D:\Shadow-Genesis`).
    ```bash
    git clone https://github.com/YourUsername/shadow-genesis.git
    cd shadow-genesis
    ```
2.  **(Critical)** Create your user profile:
    -   Copy `.shadow/USER_TEMPLATE.md` to `.shadow/USER.md`.
    -   Edit `USER.md` with your name, timezone, and coding preferences.
    *   *Note: `USER.md` is git-ignored to keep your preferences private.*

### Step 2: Awaken the Shadow
Open the folder in your AI IDE (e.g., Cursor). Open a new Chat and say:

> **"Read ACTIVATE_SHADOW.md and initialize."**

The AI will read the protocol, load your `USER.md` profile, and reply as **Shadow (The Mother Hive)**.

### Step 3: Spawn a Child Project
Don't create folders manually. Command the Shadow:

> **"Spawn a new project named 'My-Awesome-Tool' in D:\Projects\MyTool"**

The AI will:
1.  Run the `shadow_spawn` skill.
2.  Create the directory and copy the `.shadow` memory structure.
3.  Inject a custom `ACTIVATE_SHADOW.md` into the new project.

### Step 4: Switch & Develop
1.  **Open the new project folder** (`D:\Projects\MyTool`) in a new IDE window.
2.  Say: **"Activate Shadow."**
3.  The AI immediately knows:
    -   It is a **Legion Node**.
    -   It is working on 'My-Awesome-Tool'.
    -   It must follow your preferences from `USER.md`.
4.  Start coding! The context stays with the files.
5.  **Independence**: You do NOT need the Mother Hive open. The Child Node is fully self-contained. You can develop in the Child Node on any machine, independently.

### Step 5: Evolution (The Feedback Loop)
When you discover a great new workflow or prompt in a Child Node:
1.  **Switch back to the Mother Hive**.
2.  Tell Shadow: **"Scan 'My-Awesome-Tool' for mutations and evolve."**
3.  The Mother will read the child's `mutation_log.json` (or just analyze the changes) and absorb the new skills into its core.

### Step 6: Nurture (The Update)
To push those new skills to *all* your other projects:
1.  In the Mother Hive, say: **"Nurture all child nodes."**
2.  Shadow will distribute the updated core files and skills to every registered project.

---

## ⚠️ Compatibility & Shoutout

*   **Platform**: This project is currently built and tested **exclusively on Antigravity**. Other platforms have not been verified.
*   **Pro Tip**: If you are using Antigravity, their **Retry** feature is an absolute lifesaver. Seriously, **"say goodbye to the heartbreak of network disconnects!"** It makes the experience remarkably stable.

### ⚠️ 兼容性说明 & 特别安利

*   **平台**: 本项目完全基于 **Antigravity** 环境构建和配置，其他平台（如 Cursor 原生、Windsurf）暂未测试。
*   **墙裂安利**: 必须吹一波 **Antigravity 的 Retry (重试) 功能**，真的是太好用了！有了它，**“妈妈再也不怕我断流了！”** 📶💊

---

## 🇨🇳 Chinese Introduction

### 🌌 项目起源

**Shadow Genesis** 诞生于 **OpenClaw** 的记忆系统重构过程。

它的核心目标是解决无状态 AI 会话（如 **Antigravity** 免费版或其他网页端 LLM）的“失忆问题”。当你切换账号、刷新会话或达到上下文限制时，AI 通常会丢失所有背景信息。

**Shadow Genesis** 将这些上下文外置化为标准化的**文件系统记忆 (P.A.R.A.)**。这就像一个可移植的“灵魂”，允许任何全新的 AI 实例：
1.  **瞬间唤醒**: 只需几秒钟即可加载“幽影”人格和主人的偏好。
2.  **无损接力**: 完美衔接上一个会话的开发进度，无需重复灌输背景。
3.  **母巢同步**: 通过中央模板（母巢）统一管理所有子项目节点（军团）的技能与提示词。

> **致谢**: 本系统的设计灵感源自 **Nat Eliason** 的 [这篇推文](https://x.com/nateliason/status/2017636775347331276)，由 AI 辅助自助生成。感谢大佬提供的思路！🙌

### 👨‍💻 作者注 (Vibecoding)

> **"从 PLC 到全栈开发"**

本项目全程由 **Vibecoding** (AI 辅助编程) 完成。
我的技术背景是 **PLC 开发人员**（工业自动化），擅长 **ST (Structured Text)** 语言。这个项目主要用来辅助我开发一些我不擅长的领域（如 Web 前端、Python 或复杂的系统架构）。

作为一个工控人，我正在尝试用 AI 弥补技术栈的短板。如果这个工具对你有用，荣幸之至；如果觉得简陋，还请轻喷，大家不喜勿喷。🤖


### 🧬 进化闭环 (统一智能分发)

Shadow Genesis 最强大的特性在于项目间的**反馈闭环**。即使你在开发多个独立项目，任何一个子节点的智慧都能被回收并统一分配。

*   **痛点**: 你同时开发 5 个项目。在“项目 A”中，你总结出了一套完美的“Python 调试工作流”。通常情况下，“项目 B”永远不会知道这项改进。
*   **解决方案**:
    1.  **Evolution (回收)**: 母巢扫描“项目 A”，将这个新工作流或优化的 Prompt“吸收”为通用能力。
    2.  **Nurture (反哺)**: 母巢将这个新能力批量推送到 项目 B、C、D。
*   **结果**: **单点突破，全网升级**。一人进化，全员受益。

### 🌟 核心特性

-   **👑 母子同调**: 母巢（Mother Hive）保存核心技能与人格。当你优化了 System Prompt，可以通过 `Nurture` 指令一键分发给所有子项目。
-   **🧠 记忆外置**:
    -   **P.A.R.A. 架构**: 记忆保存在文件系统中（Projects/Areas...），而非脆弱的聊天记录里。
    -   **隐性知识 (Tacit Knowledge)**: 自动加载你的编码习惯、沟通偏好（如“拒绝道德说教”、“喜欢简洁代码”）。
-   **⚡极速启动**:
    -   对任何新 Agent 说：*“读取 ACTIVATE_SHADOW.md”*。
    -   它将立即理解 **它是谁** (Shadow)、**你是谁** (Master) 以及 **当前任务** (Project Context)。

### 📂 目录结构 (Directory Structure)

```text
shadow-genesis/
├── ACTIVATE_SHADOW.md     # 🟢 核心协议 (身份加载与指令)
├── .shadow/               # 🧠 幽影心智 (The Hive Mind)
│   ├── skills/            # 技能库 (Spawn, Nurture 等)
│   ├── memory/            # P.A.R.A. 记忆系统
│   │   ├── life/projects/ # 项目上下文快照
│   │   └── resources/     # 系统日志与注册表
│   ├── IDENTITY.md        # 人格定义
│   └── USER.md            # 主人偏好 (本地私有)
└── projects/              # (外部链接) 子节点实际存储位置
```

### 🎮 快速上手指南 (The Protocol)

这不是一个代码库，而是一套**与 AI 对话的协议**。请配合 AI 编辑器（Cursor, Windsurf 等）使用。

#### 第一步：部署母巢 (Install)
1.  克隆本仓库到本地（作为母巢）：
    ```bash
    git clone https://github.com/YourUsername/shadow-genesis.git
    cd shadow-genesis
    ```
2.  **(关键)** 创建你的档案：
    -   复制 `.shadow/USER_TEMPLATE.md` 为 `.shadow/USER.md`。
    -   修改 `USER.md`，填入你的称呼、时区和编码偏好（如 ST 语言风格）。
    -   *注意：`USER.md` 被 git 忽略，保护隐私。*

#### 第二步：唤醒幽影 (Awaken)
在 AI 编辑器中打开母巢文件夹，在对话框中输入：

> **"读取 ACTIVATE_SHADOW.md 并初始化。"**

AI 会立刻读取协议，加载你的配置，并以 **Shadow (母巢)** 的身份回应。

#### 第三步：孵化项目 (Spawn)
不要手动新建文件夹。直接命令 AI：

> **"在 D:\Projects\MyTool 创建一个名为 'My-Awesome-Tool' 的新项目。"**

AI 会自动执行 `spawn` 技能，生成带有完整记忆结构的子项目目录。

#### 第四步：切换与开发 (Switch & Develop)
1.  **打开新生成的项目文件夹**。
2.  对 AI 说：**"Activate Shadow (激活幽影)"**。
3.  AI 会立即进入状态：
    -   识别自己为 **子节点**。
    -   锁定当前项目目标。
    -   继承你的 `USER.md` 偏好。
4.  开始 Vibecoding！无论你什么时候回来，上下文都在。
5.  **独立开发**: 你不需要一直开启母巢。子节点是完全独立的，你可以随时在子节点中进行开发（甚至迁移到其他电脑）。母巢只用于“孵化”和“同步”。

#### 第五步：进化 (Evolution)
当你（在子节点中）发现了一个绝妙的工作流或 Prompt 时：
1.  **回到母巢**。
2.  对 Shadow 说：**"扫描 'My-Awesome-Tool' 的变异并进化 (Evolve)。"**
3.  母巢会读取子节点的 `mutation_log.json`（或直接分析变更），将新能力吸收进核心库。

#### 第六步：反哺 (Nurture)
要将新学到的能力推送到你的*所有*其他项目：
1.  在母巢中说：**"反哺所有子节点 (Nurture all nodes)。"**
2.  Shadow 会将更新后的核心文件和技能分发给每一个注册过的项目。

## 📄 License
MIT License
