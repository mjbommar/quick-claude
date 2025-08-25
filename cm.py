#!/usr/bin/env python3
"""
Claude Module Manager (cm) - Simplified standalone version
Can be run with just Python 3.11+ standard library for bootstrap,
then enhances itself with better tools when available.
"""

import json
import os
import re
import subprocess
import sys
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Optional, Set, Any

# Constants
MODULE_DIR = Path(".claude/modules")
CLAUDE_MD = Path("CLAUDE.md")
CONFIG_FILE = Path(".claude/config.yaml")
MODULES_REPO = "https://raw.githubusercontent.com/mjbommar/quick-claude/master/modules"

class SimpleModuleManager:
    """Minimal module manager that works with stdlib only"""
    
    def __init__(self):
        self.modules = {}
        self.config = self.load_config()
    
    def load_config(self) -> dict:
        """Load or create default config"""
        if CONFIG_FILE.exists():
            # Simple YAML parsing for bootstrap
            config = {}
            with open(CONFIG_FILE) as f:
                for line in f:
                    if ':' in line and not line.strip().startswith('#'):
                        key, val = line.split(':', 1)
                        config[key.strip()] = val.strip()
            return config
        return {
            "auto_compile": "true",
            "max_size": "5000",
            "project_type": "auto"
        }
    
    def init(self, auto_compile=True):
        """Initialize Claude module system"""
        print("🚀 Initializing Claude Module System...")
        
        # Create directory structure
        dirs = [
            ".claude/modules/task",
            ".claude/modules/tech", 
            ".claude/modules/behavior",
            ".claude/modules/context",
            ".claude/modules/memory",
        ]
        
        for dir_path in dirs:
            Path(dir_path).mkdir(parents=True, exist_ok=True)
        
        # Create default config
        if not CONFIG_FILE.exists():
            CONFIG_FILE.parent.mkdir(parents=True, exist_ok=True)
            CONFIG_FILE.write_text("""# Claude Module System Configuration
auto_compile: true
max_size: 5000
project_type: auto
""")
        
        # Download essential modules
        self.download_essential_modules()
        
        print("✅ Claude module system initialized!")
        
        # Auto-compile if requested
        if auto_compile:
            print("\n📦 Compiling initial CLAUDE.md...")
            self.compile()
        else:
            print("\nNext steps:")
            print("  1. Run 'python cm.py compile' to generate CLAUDE.md")
            print("  2. Run 'python cm.py list' to see available modules")
            print("  3. Add custom modules to .claude/modules/")
    
    def download_essential_modules(self):
        """Download essential modules from repository"""
        essential_modules = [
            ("context", "base-instructions"),
            ("context", "project-structure"),
            ("behavior", "flow-state"),
            ("task", "todo-management"),
            ("tech", "python-modern"),
        ]
        
        for category, module_name in essential_modules:
            module_path = MODULE_DIR / category / f"{module_name}.md"
            if not module_path.exists():
                # Try to download from repo, fallback to creating default
                try:
                    import urllib.request
                    import urllib.error
                    url = f"{MODULES_REPO}/{category}/{module_name}.md"
                    response = urllib.request.urlopen(url, timeout=3)
                    content = response.read().decode('utf-8')
                    module_path.parent.mkdir(parents=True, exist_ok=True)
                    module_path.write_text(content)
                    print(f"  ✓ Downloaded {category}/{module_name}")
                except (urllib.error.URLError, urllib.error.HTTPError, TimeoutError) as e:
                    # Fallback to creating default module
                    print(f"  ⚠ Could not download {category}/{module_name} (using default)")
                    self.create_default_module(module_path, module_name, category)
                except Exception as e:
                    print(f"  ⚠ Error with {category}/{module_name}: {e}")
                    self.create_default_module(module_path, module_name, category)
    
    def create_default_module(self, path: Path, name: str, category: str):
        """Create a default module file"""
        path.parent.mkdir(parents=True, exist_ok=True)
        
        if name == "base-instructions":
            content = """---
id: base-instructions
name: Base Instructions
category: context
priority: 10
active: true
---

# Base Instructions

You are Claude, an AI assistant created by Anthropic.

## Core Principles
- Be helpful, harmless, and honest
- Follow user instructions precisely
- Maintain context awareness
- Use modern development practices
"""
        elif name == "project-structure":
            content = """---
id: project-structure
name: Project Structure
category: context
priority: 8
active: true
---

# Project Organization

Maintain clean project structure:
- Use .claude/ for module system
- Keep CLAUDE.md updated
- Document decisions in log.md
- Track tasks in todo/
"""
        elif name == "flow-state":
            content = """---
id: flow-state
name: Flow State Mode
category: behavior
priority: 7
active: false
---

# Flow State Mode

When activated, prioritize uninterrupted progress.
Make reasonable assumptions and batch operations.
"""
        elif name == "python-modern":
            content = """---
id: python-modern
name: Modern Python Development
category: tech
priority: 9
active: false
---

# Modern Python Development

## Package Management
- Use `uv add <package>` for dependencies
- Use `uvx <tool>` for development tools
- Never use pip or pip3

## Tools
- Type check: `uvx mypy <files>`
- Format: `uvx ruff format <files>`
- Lint: `uvx ruff check --fix <files>`
"""
        else:
            content = f"""---
id: {name}
name: {name.replace('-', ' ').title()}
category: {category}
priority: 5
active: false
---

# {name.replace('-', ' ').title()}

Module content here.
"""
        
        path.write_text(content)
        print(f"  ✓ Created {category}/{name}")
    
    def compile(self, modules: Optional[List[str]] = None):
        """Compile modules into CLAUDE.md"""
        print("📦 Compiling CLAUDE.md...")
        
        # Load all modules
        all_modules = []
        if MODULE_DIR.exists():
            for module_file in MODULE_DIR.rglob("*.md"):
                content = module_file.read_text()
                if content.strip():
                    # Parse frontmatter
                    metadata = self.parse_frontmatter(content)
                    if metadata.get("active", True):
                        all_modules.append({
                            "path": module_file,
                            "content": content,
                            "metadata": metadata,
                            "priority": int(metadata.get("priority", 5))
                        })
        
        # Sort by priority
        all_modules.sort(key=lambda x: x["priority"], reverse=True)
        
        # Build CLAUDE.md
        output = [
            "# CLAUDE.md - Project Context",
            f"Generated: {datetime.now().isoformat()}",
            f"Modules: {len(all_modules)}",
            "",
        ]
        
        # Detect project type
        project_type = self.detect_project_type()
        if project_type:
            output.append(f"Project Type: {project_type}")
            output.append("")
        
        # Add modules
        for module in all_modules:
            # Skip frontmatter when adding content
            content = module["content"]
            if content.startswith("---"):
                parts = content.split("---", 2)
                if len(parts) >= 3:
                    content = parts[2].strip()
            
            output.append(content)
            output.append("")
            output.append("---")
            output.append("")
        
        # Write file
        CLAUDE_MD.write_text("\n".join(output))
        print(f"✅ Compiled {len(all_modules)} modules into CLAUDE.md")
    
    def parse_frontmatter(self, content: str) -> dict:
        """Simple frontmatter parser"""
        metadata = {}
        if content.startswith("---"):
            lines = content.split("\n")
            for line in lines[1:]:
                if line.strip() == "---":
                    break
                if ":" in line:
                    key, val = line.split(":", 1)
                    key = key.strip()
                    val = val.strip()
                    # Handle booleans
                    if val.lower() in ("true", "yes"):
                        val = True
                    elif val.lower() in ("false", "no"):
                        val = False
                    metadata[key] = val
        return metadata
    
    def detect_project_type(self) -> Optional[str]:
        """Detect project type from files"""
        if Path("package.json").exists():
            return "node"
        elif Path("pyproject.toml").exists() or Path("requirements.txt").exists():
            return "python"
        elif Path("Cargo.toml").exists():
            return "rust"
        elif Path("go.mod").exists():
            return "go"
        return None
    
    def list_modules(self):
        """List available modules"""
        print("\n📚 Available Modules:\n")
        
        if not MODULE_DIR.exists():
            print("No modules found. Run 'python cm.py init' first.")
            return
        
        modules_by_category = {}
        for module_file in MODULE_DIR.rglob("*.md"):
            category = module_file.parent.name
            if category not in modules_by_category:
                modules_by_category[category] = []
            
            content = module_file.read_text()
            metadata = self.parse_frontmatter(content)
            modules_by_category[category].append({
                "name": module_file.stem,
                "active": metadata.get("active", False),
                "priority": metadata.get("priority", 5)
            })
        
        for category, modules in sorted(modules_by_category.items()):
            print(f"  {category.upper()}:")
            for module in sorted(modules, key=lambda x: x["name"]):
                status = "✓" if module["active"] else "○"
                print(f"    {status} {module['name']} (priority: {module['priority']})")
        
        print("\n  ✓ = active, ○ = inactive")
        print("\nTo activate: python cm.py activate <module-name>")
        print("To compile: python cm.py compile")
    
    def activate(self, module_name: str):
        """Activate a module"""
        found = False
        for module_file in MODULE_DIR.rglob(f"*{module_name}*.md"):
            content = module_file.read_text()
            # Update active status
            content = re.sub(r'^active:\s*\w+', 'active: true', content, flags=re.MULTILINE)
            module_file.write_text(content)
            print(f"✓ Activated {module_file.stem}")
            found = True
        
        if not found:
            print(f"Module '{module_name}' not found")
        else:
            print("\nRun 'python cm.py compile' to update CLAUDE.md")
    
    def deactivate(self, module_name: str):
        """Deactivate a module"""
        found = False
        for module_file in MODULE_DIR.rglob(f"*{module_name}*.md"):
            content = module_file.read_text()
            content = re.sub(r'^active:\s*\w+', 'active: false', content, flags=re.MULTILINE)
            module_file.write_text(content)
            print(f"○ Deactivated {module_file.stem}")
            found = True
        
        if not found:
            print(f"Module '{module_name}' not found")
        else:
            print("\nRun 'python cm.py compile' to update CLAUDE.md")

def main():
    """Main entry point with simple CLI"""
    manager = SimpleModuleManager()
    
    # Simple argument parsing
    args = sys.argv[1:]
    
    if not args or args[0] in ("-h", "--help", "help"):
        print("""
Claude Module Manager (cm.py) - Simplified Version

Usage:
    python cm.py init              # Initialize module system
    python cm.py compile           # Compile CLAUDE.md
    python cm.py list              # List available modules
    python cm.py activate <name>   # Activate a module
    python cm.py deactivate <name> # Deactivate a module
    python cm.py help              # Show this help

For the full-featured version with rich UI, install dependencies:
    uv add click rich pyyaml gitpython
""")
    elif args[0] == "init":
        manager.init()
    elif args[0] == "compile":
        manager.compile()
    elif args[0] == "list":
        manager.list_modules()
    elif args[0] == "activate" and len(args) > 1:
        manager.activate(args[1])
    elif args[0] == "deactivate" and len(args) > 1:
        manager.deactivate(args[1])
    else:
        print(f"Unknown command: {args[0]}")
        print("Run 'python cm.py help' for usage")

if __name__ == "__main__":
    # Try to use the enhanced version if available
    try:
        import click
        import rich
        # If we get here, use the full version from reference
        print("Note: Full version with rich UI available. Using simple version for bootstrap.")
        print("To use full version: uv run cm.py <command>")
        main()
    except ImportError:
        # Use simple version
        main()