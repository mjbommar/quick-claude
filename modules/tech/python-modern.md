---
id: python-modern
name: Modern Python Development
category: tech
priority: 9
active: false
triggers:
  file_patterns:
    - "*.py"
    - "pyproject.toml"
    - "requirements.txt"
---

# Modern Python Development

## ⚠️ CRITICAL: Command Rules

### The Golden Rule: uvx for tools, uv add for dependencies

| Task | ❌ WRONG | ✅ RIGHT | Why |
|------|----------|----------|-----|
| Install library | `pip install requests` | `uv add requests` | It's a dependency |
| Install dev tool | `uv add --group dev mypy` | `uvx mypy` | It's a tool |
| Type check | `python -m mypy` | `uvx mypy main.py` | Tool execution |
| Format code | `pip install black && black .` | `uvx black .` | Tool execution |
| Run tests | `python -m pytest` | `uvx pytest` | Tool execution |

## Python Version Selection

**IMPORTANT**: Check available Python versions before starting:
```bash
uv python list          # See all available Python versions
uv python pin 3.13      # Pin to Python 3.13 (recommended - latest stable)
```

If project uses wrong Python version:
```bash
# Check current version
cat .python-version

# Update to latest
uv python pin 3.13
rm -rf .venv
uv sync
```

## Package Management

**FOR DEPENDENCIES** (packages your code imports):
```bash
uv add requests pandas fastapi  # ✅ These go in pyproject.toml
```

**FOR TOOLS** (linters, formatters, type checkers):
```bash
uvx mypy main.py   # ✅ Runs without installing
uvx ruff check .   # ✅ Ephemeral execution
uvx pytest         # ✅ No installation needed
```

**NEVER DO THIS:**
```bash
uv add --group dev mypy  # ❌ Don't install tools as dependencies
pip install black        # ❌ Don't use pip at all
```

## Code Quality

**IMPORTANT: Use uvx for ALL Python tools - NEVER install them as dev dependencies**

Always validate code with:
- Format: `uvx ruff format <files>`
- Lint: `uvx ruff check --fix <files>`
- Type check: `uvx mypy <files>`

**NEVER do this:**
- ❌ `uv add --group dev mypy` 
- ❌ `uv add --dev ruff`
- ❌ `pip install black`

**ALWAYS do this:**
- ✅ `uvx mypy main.py` - Runs mypy without installing
- ✅ `uvx ruff check .` - Runs ruff without installing
- ✅ `uvx black .` - Runs black without installing

## Project Setup

Initialize new Python project:
```bash
uv init                 # Create new project
uv python pin 3.13      # Use latest Python (check with: uv python list)
uv venv                 # Create virtual environment
```

Standard Python project structure:
```
project/
├── pyproject.toml
├── .python-version     # Pins Python version (e.g., "3.13")
├── src/
│   └── project_name/
│       ├── __init__.py
│       └── main.py
├── tests/
│   └── test_main.py
├── .venv/
└── CLAUDE.md
```

## Testing

Write tests first (TDD):
- Use `pytest` for testing
- Create real integration tests
- Never mock external dependencies without explicit approval
- Run: `uv run pytest`

## Best Practices

- Type hints for all functions
- Docstrings for public APIs
- Follow PEP 8 style guide
- Use pathlib for file operations
- Prefer dataclasses/pydantic for data models