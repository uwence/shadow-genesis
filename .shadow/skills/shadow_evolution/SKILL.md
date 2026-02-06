---
name: Shadow Evolution (Assimilation)
description: A skill to assimilate genetic improvements (skills, system knowledge) from child nodes back into the Mother Hive.
version: 2.0.0
---

# 🧬 Shadow Evolution Protocol

This skill empowers the Shadow agent to proactively "hunt" for improvements in child projects and assimilate them into the current Mother Hive template.

## 🛡️ Prerequisites
- Must be running within the `shadow-genesis` (Mother Hive) context.
- A valid child project path must be provided (or scan all from `child_registry.json`).

## 📜 Workflow

### 1. Preparation (Backup)
**CRITICAL**: Before any assimilation involves modifying the Mother Hive, create a backup via `Shadow Chronos`.

### 2. Genetic Scanning (Smart Diff)
**PRIMARY SOURCE**: Read the child's `mutation_log.json` first!
- **Location**: `<ChildNode>/.shadow/memory/life/resources/system/mutation_log.json`
- **Filter by Status**: Only show mutations with `status: "pending_review"`.

**FALLBACK** (if no mutation_log exists): Use blind scan:
- **Filters**:
  - **IGNORE**: Project-specific memory (`memory/life/projects/*`), logs (`memory/*.md`), user-specific tweaks.
  - **TARGET**: 
    - New Skills (`.shadow/skills/*`)
    - Improved System Prompts (`tacit_knowledge.md`)
    - New Workflows (`.agent/workflows/*`)
    - Improved Scripts

### 3. Assimilation (Merge)
- Present the found "mutations" (changes) to the Master.
- For each **approved** mutation:
  1. Copy the file/folder from Child to Mother.
  2. Update the child's `mutation_log.json`: Set `status` to `"assimilated"`.
  3. Append a record to Mother's `assimilation_history.json`.

- For each **rejected** mutation:
  1. Update the child's `mutation_log.json`: Set `status` to `"rejected"`.

### 4. Post-Assimilation
- **Prompt for Snapshot**: Per the "Evolution Law", always ask if a new version snapshot should be created.
- Update `version_history.json` if snapshot is approved.

## 💻 Usage

```markdown
User: "Evolution"
Agent: [Scans all children's mutation_log.json, presents pending mutations]

User: "Assimilate the new skill from InduLog."
Agent: [Executes Skill: Shadow Evolution] --Target "InduLog" --MutationId "mut-001"
```
