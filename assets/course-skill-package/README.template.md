# <课程名>配套 Skills

本目录保存学员复现课程所需的 Skills。第三方项目应在对应目录保留许可证与上游来源；官方插件不复制源码，只在课程说明中提供官方安装入口。

## 包含内容

| Skill | 用途 | 来源或许可证 |
|---|---|---|
| `<skill-name>` | `<课程中的用途>` | `<自有 / 许可证 / 上游地址>` |

## 一键安装

在本目录打开 PowerShell，执行：

```powershell
powershell -ExecutionPolicy Bypass -File .\install-course-skills.ps1
```

脚本默认安装到 `$HOME\.codex\skills`，已有同名 Skill 时会跳过。确认需要替换时才使用：

```powershell
powershell -ExecutionPolicy Bypass -File .\install-course-skills.ps1 -Force
```

`-Force` 会先备份旧版本。安装后重新打开 Codex，并按课程讲义中的检查提示词确认 Skill 已加载。
