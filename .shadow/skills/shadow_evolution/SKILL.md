---
name: Shadow Evolution (Assimilation)
description: A skill to assimilate genetic improvements (skills, system knowledge) from child nodes back into the Mother Hive.
version: 1.0.0
---

# 🧬 Shadow Evolution Protocol

This skill empowers the Shadow agent to proactively "hunt" for improvements in child projects and assimilate them into the current Mother Hive template.

## 🛡️ Prerequsites
- Must be running within the `shadow-genesis` (Mother Hive) context.
- A valid child project path must be provided.

## 📜 Workflow

### 1. Preparation (Backup)
**CRITICAL**: Before any assimilation involves modifying the Mother Hive, create a backup.
- **Action**: Create a zip archive or copy of the current `shadow-genesis` folder to a `backups/` directory (e.g., `backups/genesis_v{timestamp}.zip`).

### 2. Genetic Scanning (Diff)
- **Tool**: Use `evolve.ps1` (or internal logic) to scan the target child directory.
- **Filters**:
  - **IGNORE**: Project-specific memory (`memory/life/projects/*`), logs (`memory/*.md`), user-specific tweaks (`USER.md`).
  - **TARGET**: 
    - New Skills (`.shadow/skills/*`)
    - Improved System Prompts (`.shadow/memory/life/resources/system/tacit_knowledge.md`)
    - Improved Scripts (`genesis.ps1`, `evolve.ps1`)

### 3. Assimilation (Merge)
- Present the found "mutations" (changes) to the Master.
- For each selected mutation, copy the file/folder from Child to Mother.

### 4. Verification
- Verify the integrity of the Mother Hive after assimilation.
- Update `summary.md` to reflect the new version/capabilities.

## 💻 Usage

```markdown
User: "The shadow-avatar project has a new web-scraping skill. Assimilate it."
Agent: [Executes Skill: Shadow Evolution]
```
