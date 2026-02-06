---
name: Shadow Nurture (Distribution)
description: Active distribution of updates/capabilities from Mother Hive to registered Child Nodes.
version: 1.0.0
---

# 🍼 Shadow Nurture Protocol

While Evolution pulls improvements *from* children, Nurture pushes improvements *to* children. This ensures that when the Mother Hive advances (e.g., new Tacit Knowledge, improved Skills), all active Legion members receive the upgrade.

## 🛠️ Capabilities

### 1. Distribute Updates
- **Script**: `scripts/distribute.ps1`
- **Inputs**: 
  - `Target` (Optional): specific child path or 'All'.
  - `Component`: 'All', 'Identity', 'Skills', or specific file path relative to `.shadow/`.
- **Actions**:
  - Reads `child_registry.json`.
  - Copies selected files from Mother Hive to the target Child(ren).
  - **Safety**: Does NOT overwrite project-specific data (`items.json`, `summary.md`).

## 💻 Usage

```markdown
User: "Push the new 'Shadow Chronos' skill to all child nodes."
Agent: [Executes Skill: Shadow Nurture] --Target "All" --Component "skills/shadow_chronos"
```
