# PLAN

Python’s `subprocess.run` is designed exactly for this: spawn a process, feed it input, capture stdout/stderr, and inspect its exit code. [docs.python](https://docs.python.org//3/library/subprocess.html)

## Recommended layout

```text
uwu++ launcher
      |
      v
python bsctl
      |
      +-- subprocess --> cobol/bsgen
      |
      +-- subprocess --> rust/git-excuse
```

Each language remains sovereign:

- **Python**: user-facing CLI, config, formatting, orchestration.
- **COBOL**: bullshit generation only; reads a request, writes nonsense.
- **Rust**: Git inspection and excuse classification only.
- **UwU++**: ceremonial frontend; it calls `python3 bsctl ...`.

No C ABI, no `.so`, no headers, no pointer arithmetic, no ABI betrayal.

## Interface protocol

Use **one JSON object on stdin**, and one JSON object on stdout. That is “direct comm” at the process level, without pretending the languages share memory.

### COBOL request

```json
{
  "style": "corporate",
  "topic": "developer productivity",
  "seed": 42,
  "count": 3
}
```

### COBOL response

```json
{
  "statements": [
    "Developer productivity must synergize asynchronous leverage across cross-functional velocity vectors.",
    "Our resilience strategy operationalizes frictionless alignment paradigms.",
    "We must unlock scalable narrative coherence to maximize stakeholder serendipity."
  ]
}
```

### Rust request

```json
{
  "repo": ".",
  "style": "panic",
  "seed": 7,
  "diff_summary": {
    "files_changed": 14,
    "insertions": 812,
    "deletions": 37,
    "has_tests": false,
    "hour": 2
  }
}
```

### Rust response

```json
{
  "excuse": "refactor: perform strategic archaeology before the repository notices",
  "confidence": 0.91
}
```

## Python orchestration

```python
import json
import subprocess

def consult_cobol_oracle(request: dict) -> dict:
    result = subprocess.run(
        ["./cobol/bsgen"],
        input=json.dumps(request),
        capture_output=True,
        text=True,
        check=True,
    )
    return json.loads(result.stdout)

def consult_rust_excuse_department(request: dict) -> dict:
    result = subprocess.run(
        ["./target/release/git-excuse"],
        input=json.dumps(request),
        capture_output=True,
        text=True,
        check=True,
    )
    return json.loads(result.stdout)
```

`subprocess.run` handles arguments, stdin, captured output, and return codes; the docs specifically recommend it for cases it can cover. [docs.python](https://docs.python.org//3/library/subprocess.html)

## COBOL side

COBOL reads stdin, emits JSON to stdout. If parsing JSON in COBOL feels like a war crime, simplify the contract:

```text
STYLE=CORPORATE
TOPIC=DEVELOPER PRODUCTIVITY
SEED=42
COUNT=3
```

Then COBOL outputs:

```text
STATEMENT 1: WE MUST SYNERGIZE SCALABLE PARADIGMS ACROSS THE ENTERPRISE.
STATEMENT 2: OUR RESILIENCE STRATEGY OPERATIONALIZES FRICTIONLESS ALIGNMENT.
STATEMENT 3: WE MUST UNLOCK NARRATIVE COHERENCE TO MAXIMIZE SERENDIPITY.
```

Python parses that. COBOL remains pure and unaffected by modernity.

GnuCOBOL’s `CALL` is for COBOL subprograms, not the right tool for Python/Rust integration here; its docs describe it as control transfer to another COBOL subprogram.  Since you do not want the C ABI, avoid `CALL` across language boundaries entirely. [gnucobol.sourceforge](https://gnucobol.sourceforge.io/guides/GNUCobol2.pdf)

## Rust side

Rust reads stdin JSON, runs `git` commands through `std::process::Command`, and writes JSON to stdout.

```rust
use std::process::Command;

let output = Command::new("git")
    .args(["diff", "--cached", "--numstat"])
    .current_dir(repo)
    .output()?;
```

It can parse the diff summary itself, classify it, and return an excuse. This keeps Git knowledge in Rust and keeps Python as the overly formal middle manager.

## UwU++ launcher

Make UwU++ do one thing only:

```uwu++
stipulate user:requests\bullshit() {
    C:\Standard\System\process\execute("python3 bsctl.py bullshit --style corporate --topic 'developer productivity'")
}
```

It should not parse JSON, manage processes, or know what COBOL is. Its entire purpose is to add unnecessary reverence to a command that prints nonsense.

## Fallback design

If COBOL JSON becomes annoying, use this hierarchy:

1. **Plain-text key/value protocol**: easiest, most COBOL-friendly.
2. **Line-delimited JSON**: good middle ground.
3. **Direct process pipes with a tiny custom protocol**: most “direct,” still no C ABI.
4. **Just COBOL**: if Python/Rust integration becomes tedious, let COBOL be the whole bullshit generator and call it from Python with arguments only.

Unix-domain sockets are also an option if you want a long-running COBOL “oracle service,” but they are overkill for a CLI toy. Python supports `AF_UNIX` sockets, but for one-shot commands, subprocess pipes are much less work. [docs.python](https://docs.python.org//3/library/socket.html)

## My vote

**Python orchestrator + COBOL generator + Rust Git-excuse engine, all connected by subprocess stdin/stdout.**

Use plain-text key/value protocol first. Add JSON only if you start enjoying pain. UwU++ is the launcher, not the integration layer—because its true calling is to stand at the entrance and say, with great formality, “please consult the mainframe.”