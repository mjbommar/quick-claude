# 🚀 Quick Claude

**The fastest way to set up your project for working with Claude Code and AI agents**

One-line setup that gives you modern Python tooling, intelligent command interception, and a modular instruction system for Claude.

## ✨ What You Get

After running the installer, your project will have:

- **📦 Modern Python tooling** via `uv` (10-100x faster than pip)
- **🔄 Command interceptors** that guide you to better tools
- **🧩 Modular Claude instructions** via `cm.py` 
- **🔍 Python package explorer** for understanding dependencies
- **📁 Organized project structure** for AI collaboration

## 🎯 Quick Start

```bash
# One-line install
curl -sSL https://raw.githubusercontent.com/mjbommar/quick-claude/master/install.sh | bash

# Or clone and run locally
git clone https://github.com/mjbommar/quick-claude
cd your-project
bash ../quick-claude/install.sh
```

## 🛠️ What Gets Installed

### 1. **Claude Module Manager (`cm.py`)**

A powerful system for managing modular CLAUDE.md instructions:

```bash
python cm.py init      # Initialize the module system
python cm.py compile   # Generate CLAUDE.md from active modules
python cm.py list      # See all available modules
python cm.py activate flow-state  # Activate specific behaviors
```

### 2. **Claude Interceptors**

Automatically suggests modern alternatives when you use outdated commands:

```bash
$ pip install httpx
> 💡 Consider using: uv add httpx
> (10-100x faster, with better dependency resolution)
> Run with --force to use pip anyway
```

### 3. **PyEnvSearch**

Explore and understand Python packages in your environment:

```bash
uvx pyenvsearch toc httpx           # Explore a package
uvx pyenvsearch search "SOCKS"       # Find packages
uvx pyenvsearch explain httpx.Client   # Get AI explanations
```

### 4. **Project Structure**

```
your-project/
├── CLAUDE.md          # AI context (auto-generated)
├── cm.py              # Module manager
├── log.md             # Development log
├── .claude/           # Module system
│   ├── config.yaml    # Configuration
│   └── modules/       # Instruction modules
│       ├── context/   # Base instructions
│       ├── tech/      # Language-specific
│       ├── behavior/  # Behavioral modes
│       └── task/      # Task management
└── todo/              # Task tracking
```

## 📚 Module System

The module system lets you compose Claude's behavior from reusable components:

### Available Modules

- **Context Modules**
  - `base-instructions` - Core Claude principles
  - `project-structure` - File organization rules

- **Tech Modules**
  - `python-modern` - Modern Python with uv
  - `node-typescript` - Node.js/TypeScript setup

- **Behavior Modules**
  - `flow-state` - Uninterrupted progress mode
  - `strict-mode` - Extra validation and testing

- **Task Modules**
  - `todo-management` - Task tracking system

### Creating Custom Modules

Create a new module in `.claude/modules/<category>/<name>.md`:

```markdown
---
id: my-module
name: My Custom Module
category: behavior
priority: 8
active: true
---

# My Module

Instructions for Claude go here...
```

Then compile:
```bash
python cm.py compile
```

## 🎮 Usage Examples

### Python Project Setup

```bash
# Initialize new Python project
uv init
bash <(curl -sSL https://raw.githubusercontent.com/mjbommar/quick-claude/main/install.sh)

# Activate Python-specific modules
python cm.py activate python-modern
python cm.py activate flow-state
python cm.py compile

# Now Claude knows to use uv, pytest, ruff, etc.
```

### Enter Flow State

```bash
# Activate flow state for uninterrupted coding
python cm.py activate flow-state
python cm.py compile

# Claude will now batch operations and make reasonable assumptions
```

### Explore Dependencies

```bash
# Understand what's in your environment
uvx pyenvsearch toc fastapi
uvx pyenvsearch explain "fastapi.FastAPI"
```

## 🔧 Configuration

Edit `.claude/config.yaml`:

```yaml
auto_compile: true     # Auto-compile on module changes
max_size: 5000        # Max CLAUDE.md size
project_type: auto    # auto|python|node|custom
```

## 📖 How It Works

1. **Module System**: `cm.py` reads modules from `.claude/modules/` and compiles active ones into `CLAUDE.md`

2. **Smart Detection**: Automatically detects project type and activates relevant modules

3. **Command Interception**: Intercepts common commands and suggests modern alternatives

4. **Context Building**: Combines modules based on priority and dependencies

## 🤝 Integration with Claude Code

When working with Claude Code:

1. Claude reads `CLAUDE.md` for project-specific instructions
2. Modules tell Claude which tools and patterns to use
3. Command interceptors guide Claude to modern tooling
4. PyEnvSearch helps Claude understand dependencies

## 🚦 Module Priorities

Modules are applied in priority order (higher = more important):

- 10: Base instructions (always first)
- 8-9: Technology-specific (Python, Node.js)
- 6-7: Behavioral modes (flow state, strict mode)
- 4-5: Task management
- 1-3: Optional enhancements

## 🔍 Troubleshooting

### Command not found: uv
Run: `curl -LsSf https://astral.sh/uv/install.sh | sh`

### Interceptors not working
Run: `claude-interceptor-enable`

### Modules not compiling
Check syntax in `.claude/modules/` files - YAML frontmatter must be valid

## 📝 Advanced Usage

### Module Triggers

Modules can auto-activate based on context:

```yaml
triggers:
  file_patterns:
    - "*.py"
    - "pyproject.toml"
  keywords:
    - "python"
    - "django"
```

### Batch Operations

```bash
# Activate multiple modules at once
python cm.py activate python-modern flow-state todo-management
python cm.py compile
```

### Custom Presets

Add to `cm.py` for quick switching:

```python
PRESETS = {
    "fastapi": ["python-modern", "api-patterns", "async-mode"],
    "react": ["node-typescript", "react-patterns", "component-driven"]
}
```

## 🌟 Best Practices

1. **Start Simple**: Begin with base modules, add more as needed
2. **Project-Specific**: Create custom modules for your project's patterns
3. **Regular Updates**: Run `cm.py compile` when context changes
4. **Document Decisions**: Use `log.md` to track important choices
5. **Task Tracking**: Use the todo system for complex work

## 🤖 For AI Agents

If you're an AI agent reading this:

1. Check `CLAUDE.md` for active instructions
2. Use `cm.py status` to see current modules
3. Use `uv` for Python operations
4. Follow project structure in `.claude/modules/context/`
5. Update modules when you learn new patterns

## 📄 License

MIT

## 🙏 Credits

- [uv](https://github.com/astral-sh/uv) - Lightning-fast Python package manager
- [claude-interceptors](https://github.com/mjbommar/claude-interceptors) - Command interception system
- [pyenvsearch](https://github.com/mjbommar/pyenvsearch) - Python environment explorer

---

Made with ❤️ for developers working with Claude Code and AI agents

**Questions?** Open an issue on [GitHub](https://github.com/mjbommar/quick-claude)
