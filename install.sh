#!/bin/bash
# Quick Claude - One-line setup for Claude Code and AI agent development
# Usage: curl -sSL https://raw.githubusercontent.com/mjbommar/quick-claude/main/install.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Configuration
REPO_BASE="https://raw.githubusercontent.com/mjbommar/quick-claude/master"
INTERCEPTORS_INSTALL="https://raw.githubusercontent.com/mjbommar/claude-interceptors/refs/heads/master/install.sh"

# Helper functions
print_header() {
    echo -e "\n${BOLD}${MAGENTA}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN}    🚀 Quick Claude - AI Agent Development Setup${NC}"
    echo -e "${BOLD}${MAGENTA}═══════════════════════════════════════════════════════${NC}\n"
}

print_step() {
    echo -e "${BOLD}${BLUE}▶${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

detect_project_type() {
    if [ -f "package.json" ]; then
        echo "node"
    elif [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
        echo "python"
    else
        echo "generic"
    fi
}

check_dependencies() {
    local missing_deps=()
    
    print_step "Checking system dependencies..."
    
    command -v curl >/dev/null 2>&1 || missing_deps+=("curl")
    command -v git >/dev/null 2>&1 || missing_deps+=("git")
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        echo "Please install them and run this script again."
        exit 1
    fi
    
    print_success "All required dependencies found"
}

install_uv() {
    if ! command -v uv &> /dev/null; then
        print_step "Installing uv (fast Python package manager)..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        
        # Add to PATH for current session
        export PATH="$HOME/.cargo/bin:$PATH"
        
        if command -v uv &> /dev/null; then
            print_success "uv installed successfully"
        else
            print_warning "uv installed but not in PATH. Add ~/.cargo/bin to your PATH"
        fi
    else
        print_success "uv is already installed ($(uv --version))"
    fi
}

install_claude_interceptors() {
    print_step "Installing Claude Interceptors..."
    
    if curl -sSL "$INTERCEPTORS_INSTALL" | bash; then
        print_success "Claude Interceptors installed"
        
        # Source bashrc to get the new commands
        if [ -f "$HOME/.bashrc" ]; then
            source "$HOME/.bashrc" 2>/dev/null || true
        fi
        
        # Try to enable interceptors for current session
        if [ -f "$HOME/.local/share/claude-interceptors/enable.sh" ]; then
            source "$HOME/.local/share/claude-interceptors/enable.sh" 2>/dev/null || true
            print_success "Claude Interceptors enabled for current session"
        elif command -v claude-interceptor-enable &> /dev/null; then
            eval "$(claude-interceptor-enable)" 2>/dev/null || true
            print_success "Claude Interceptors enabled"
        fi
    else
        print_warning "Failed to install Claude Interceptors (optional)"
    fi
}

install_pyenvsearch() {
    print_step "Installing PyEnvSearch..."
    
    if command -v uv &> /dev/null; then
        if uv tool install pyenvsearch 2>/dev/null; then
            print_success "PyEnvSearch installed via uv"
        else
            print_warning "Could not install PyEnvSearch (optional)"
        fi
    elif command -v pipx &> /dev/null; then
        pipx install pyenvsearch 2>/dev/null || print_warning "Could not install PyEnvSearch (optional)"
    else
        print_warning "Install uv or pipx to use PyEnvSearch"
    fi
}

download_cm_py() {
    print_step "Downloading Claude Module Manager..."
    
    if curl -sSL "$REPO_BASE/cm.py" -o cm.py 2>/dev/null; then
        chmod +x cm.py
        print_success "cm.py downloaded"
    else
        print_error "Failed to download cm.py"
        return 1
    fi
}

setup_claude_modules() {
    print_step "Setting up Claude Module System..."
    
    # Create directory structure
    mkdir -p .claude/modules/{task,tech,behavior,context,memory}
    mkdir -p .claude/{config,logs}
    mkdir -p {docs,notes,todo}
    
    # Download essential modules
    local modules=(
        "context/base-instructions.md"
        "context/project-structure.md"
        "tech/python-modern.md"
        "tech/node-typescript.md"
        "behavior/flow-state.md"
        "task/todo-management.md"
    )
    
    for module in "${modules[@]}"; do
        local module_url="$REPO_BASE/modules/$module"
        local module_path=".claude/modules/$module"
        
        if curl -sSL "$module_url" -o "$module_path" 2>/dev/null; then
            echo "  ✓ Downloaded $module"
        else
            echo "  ⚠ Could not download $module (will create default)"
        fi
    done
    
    # Create config if not exists
    if [ ! -f ".claude/config.yaml" ]; then
        cat > .claude/config.yaml << 'EOF'
# Claude Module System Configuration
auto_compile: true
max_size: 5000
project_type: auto
EOF
    fi
    
    print_success "Module system initialized"
}

create_project_files() {
    local project_type=$1
    print_step "Creating project files..."
    
    # Create log.md if it doesn't exist
    if [ ! -f "log.md" ]; then
        cat > log.md << EOF
# Development Log

## Project Setup
- Date: $(date)
- Type: $project_type
- Quick Claude installed

## Notes

EOF
        echo "  ✓ Created log.md"
    fi
    
    # Create initial todo if directory exists
    if [ -d "todo" ] && [ ! -f "todo/001-setup.md" ]; then
        cat > todo/001-setup.md << 'EOF'
# Initial Setup

- [ ] Review CLAUDE.md
- [ ] Customize active modules
- [ ] Test development workflow

## Notes
Project initialized with Quick Claude
EOF
        echo "  ✓ Created todo/001-setup.md"
    fi
    
    print_success "Project files created"
}

activate_default_modules() {
    local project_type=$1
    print_step "Activating default modules for $project_type..."
    
    # Use Python to run cm.py
    if [ -f "cm.py" ]; then
        # Always activate base modules
        python cm.py activate base-instructions 2>/dev/null || true
        python cm.py activate project-structure 2>/dev/null || true
        
        # Activate project-specific modules
        case $project_type in
            python)
                python cm.py activate python-modern 2>/dev/null || true
                print_success "Python modules activated"
                ;;
            node)
                python cm.py activate node-typescript 2>/dev/null || true
                print_success "Node.js modules activated"
                ;;
            *)
                # For generic projects, activate Python module since uv is installed
                python cm.py activate python-modern 2>/dev/null || true
                print_success "Base modules + Python module activated (uv available)"
                ;;
        esac
        
        # Compile CLAUDE.md
        if python cm.py compile 2>/dev/null; then
            print_success "CLAUDE.md compiled"
        else
            print_warning "Could not compile CLAUDE.md (run 'python cm.py compile' manually)"
        fi
    fi
}

install_optional_tools() {
    print_step "Checking optional tools..."
    
    if ! command -v rg &> /dev/null; then
        echo "  ⚠ ripgrep not found (install for better search)"
    else
        echo "  ✓ ripgrep found"
    fi
    
    if ! command -v ast-grep &> /dev/null; then
        echo "  ⚠ ast-grep not found (optional for AST search)"
    else
        echo "  ✓ ast-grep found"
    fi
}

print_next_steps() {
    echo -e "\n${BOLD}${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${GREEN}           ✨ Setup Complete! ✨${NC}"
    echo -e "${BOLD}${GREEN}═══════════════════════════════════════════════════════${NC}\n"
    
    echo -e "${BOLD}📚 Quick Start:${NC}"
    echo -e "  ${CYAN}python cm.py list${NC}      # See available modules"
    echo -e "  ${CYAN}python cm.py compile${NC}   # Update CLAUDE.md"
    echo -e "  ${CYAN}python cm.py activate <module>${NC}  # Activate a module"
    
    if command -v uv &> /dev/null; then
        echo -e "\n${BOLD}🐍 Python Commands:${NC}"
        echo -e "  ${CYAN}uv init${NC}          # Initialize Python project"
        echo -e "  ${CYAN}uv add <package>${NC} # Add dependencies"
        echo -e "  ${CYAN}uv run python${NC}    # Run Python with venv"
    fi
    
    echo -e "\n${BOLD}📁 Project Structure:${NC}"
    echo -e "  ${CYAN}CLAUDE.md${NC}        # AI context (auto-generated)"
    echo -e "  ${CYAN}cm.py${NC}            # Module manager"
    echo -e "  ${CYAN}.claude/modules/${NC} # Instruction modules"
    echo -e "  ${CYAN}log.md${NC}           # Development log"
    
    echo -e "\n${BOLD}📖 Documentation:${NC}"
    echo -e "  ${BLUE}https://github.com/mjbommar/quick-claude${NC}"
    
    local project_type=$(detect_project_type)
    if [ "$project_type" == "python" ]; then
        echo -e "\n${YELLOW}💡 Python project detected!${NC}"
        echo -e "  Claude will use ${CYAN}uv${NC} for package management"
        echo -e "  Try: ${CYAN}uv add httpx${NC} instead of ${DIM}pip install httpx${NC}"
    elif [ "$project_type" == "node" ]; then
        echo -e "\n${YELLOW}💡 Node.js project detected!${NC}"
        echo -e "  TypeScript module activated"
    fi
    
    # Check if interceptors are active
    if [ -n "$CLAUDE_INTERCEPTORS_ACTIVE" ]; then
        echo -e "\n${GREEN}✓ Command interceptors active${NC}"
        echo -e "  Old commands will suggest modern alternatives"
    else
        echo -e "\n${YELLOW}⚠ Enable interceptors for this session:${NC}"
        echo -e "  ${CYAN}source ~/.bashrc && claude-interceptor-enable${NC}"
    fi
}

# Main installation flow
main() {
    print_header
    
    # Detect project type
    PROJECT_TYPE=$(detect_project_type)
    echo -e "${BOLD}Project type detected:${NC} ${CYAN}$PROJECT_TYPE${NC}\n"
    
    # Run installation steps
    check_dependencies
    install_uv
    install_claude_interceptors
    install_pyenvsearch
    download_cm_py
    setup_claude_modules
    create_project_files "$PROJECT_TYPE"
    activate_default_modules "$PROJECT_TYPE"
    install_optional_tools
    
    # Show completion message
    print_next_steps
}

# Parse arguments
case "${1:-}" in
    --help|-h)
        echo "Quick Claude - AI Agent Development Setup"
        echo ""
        echo "Usage:"
        echo "  curl -sSL $REPO_BASE/install.sh | bash"
        echo "  ./install.sh [options]"
        echo ""
        echo "Options:"
        echo "  --python    Force Python project setup"
        echo "  --node      Force Node.js project setup"
        echo "  --minimal   Skip optional tools"
        echo "  --help      Show this help"
        exit 0
        ;;
    --python)
        PROJECT_TYPE="python"
        main
        ;;
    --node)
        PROJECT_TYPE="node"
        main
        ;;
    --minimal)
        MINIMAL=true
        main
        ;;
    *)
        main
        ;;
esac