---
description: 整理节点目录结构，确保符合 Project Isolation 准则
---

# 目录整理工作流 (Organize Directory Workflow)

将当前节点的目录结构整理为符合 **Project Isolation** 准则的规范结构。

## 执行步骤

### 1. 扫描当前目录结构
// turbo
```bash
ls -la  # 或 Get-ChildItem
```
识别根目录中的所有文件和文件夹。

### 2. 对比规范结构
根据 `.shadow/memory/life/resources/system/tacit_knowledge.md` 中的 **Canonical Node Structure**，识别违规项：

**允许在根目录的：**
- `ACTIVATE_SHADOW.md`
- `.shadow/`
- `projects/`
- `.agent/` (可选，Agent 工作流)

**必须迁移至 `projects/<ProjectName>/` 的：**
- `src/`, `public/`, `config/`, `database/`, `tools/`
- `package.json`, `package-lock.json`, `node_modules/`
- `.git/`, `.gitignore`
- 其他所有项目代码文件

### 3. 创建目标目录
// turbo
```powershell
New-Item -ItemType Directory -Force -Path "projects\<ProjectName>"
```

### 4. 迁移违规文件
```powershell
Move-Item -Path "<item>" -Destination "projects\<ProjectName>\" -Force
```

对每个违规项重复执行。

### 5. 验证结果
// turbo
```bash
ls -la  # 验证根目录已净化
ls -la projects/<ProjectName>/  # 验证代码已归位
```

### 6. 报告完成
向主人汇报整理结果，展示当前目录结构树。

---

## 注意事项
- **不要** 移动 `.shadow/` 目录
- **不要** 移动 `ACTIVATE_SHADOW.md`
- **不要** 移动 `.agent/` 目录 (如果存在)
- 如果 `projects/<ProjectName>/` 已存在内容，需先确认是否合并
