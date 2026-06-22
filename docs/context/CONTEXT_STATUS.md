# Context 状态监控

> 最后更新：2026-06-22 22:10:55

## 当前估算

| 项目 | 数值 |
|------|------|
| session_id | `7f6345e8-945b-4ee7-9ccc-184da6958bd0` |
| transcript_path | `/Users/wangziyi/.claude/projects/-Users-wangziyi-ink-animation/7f6345e8-945b-4ee7-9ccc-184da6958bd0.jsonl` |
| JSONL 文件大小 | 10842.2 KB |
| 估算 Token 数 | 528,688 |
| 上限（估算） | 200,000 |
| 使用百分比 | **264.3%** |
| 风险等级 | 🔴 URGENT（>95%） |

## 建议操作

立即执行 /context-handoff，然后手动点击 New session，新对话第一句复制 NEXT_SESSION_PROMPT.md。

## 说明

- Token 估算方法：JSONL 文件字节数 ÷ 6（含 tool 输出全量，粗估）
- 真实 token 数以 Claude Code UI 显示为准
- 日志文件：`docs/context/context_guard.log`
