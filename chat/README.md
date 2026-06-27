# Chat prompts

Pasteable instructions for consumer chat interfaces. These are not API system
prompts and are not installed by `scripts/link-system-prompts.sh`.

```text
chat/
  claude/instructions.md             # Claude chat personal/project instructions
  chatgpt/custom-instructions.md     # ChatGPT custom instructions
```

The chat prompts should stay conceptually aligned, but they do not need a
byte-identical shared core. Claude can carry more structure; ChatGPT's prompt
must stay within the Custom Instructions character limit. Verify the ChatGPT
file before shipping:

```sh
wc -m chat/chatgpt/custom-instructions.md
```
