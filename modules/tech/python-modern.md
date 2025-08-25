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

## Package Management

**ALWAYS** use `uv` for Python package management:
- Create venv: `uv venv`
- Add dependencies: `uv add <package>`
- Add dev dependencies: `uv add --group dev <package>`
- Run scripts: `uv run python script.py`
- Run tools: `uvx <tool>`

**NEVER use pip, pip3, or python -m pip**. Always use `uv add` instead:
- ❌ WRONG: `pip install httpx`
- ✅ RIGHT: `uv add httpx`

## Code Quality

Always validate code with:
- Format: `uvx ruff format`
- Lint: `uvx ruff check --fix`
- Type check: `uvx mypy`

## Project Setup

Standard Python project structure:
```
project/
├── pyproject.toml
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