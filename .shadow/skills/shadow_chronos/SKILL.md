---
name: Shadow Chronos (Version Control)
description: Manages the temporal state of the Mother Hive. Allows version tagging, rollback, and restoration.
version: 1.0.0
---

# ⏳ Shadow Chronos

Grants the Mother Hive the ability to perceive and manipulate its own timeline. It manages a local `backups/` repository to ensure evolution is never destructive.

## 🛠️ Capabilities

### 1. Create Snapshot (Tag)
- **Script**: `scripts/snapshot.ps1`
- **Action**: Archives the current state of `shadow-genesis` into `backups/v{VERSION}_{TIMESTAMP}.zip`. 
- **Usage**: Automatically called before `Evolution` or manual triggered before major edits.

### 2. Rollback (Time Travel)
- **Script**: `scripts/rollback.ps1`
- **Action**: Reverts the Mother Hive to a previous snapshot.
- **Warning**: This is destructive to current changes. It wipes the current directory (except backups) and unzips the target archive.

## 💻 Usage

```markdown
User: "The latest evolution broke something. Rollback to version 0.9.0."
Agent: [Executes Skill: Shadow Chronos] --Action "Rollback" --Version "0.9.0"
```
