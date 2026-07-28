#!/bin/bash

# Script para detectar inconsistencias en comandos de validación
# Busca comandos de validación hardcodeados en skills que deberían usar validation-commands.md

SHARED_DIR="$(dirname "$0")/../_shared"
VALIDATION_COMMANDS_FILE="$SHARED_DIR/validation-commands.md"
SKILLS_DIR="$(dirname "$0")/.."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🔍 Buscando inconsistencias en comandos de validación..."
echo ""

# Comandos estandarizados que deberían estar en validation-commands.md
STANDARD_COMMANDS=(
    "./scripts/docker-helper.sh test -m unit"
    "cd frontend && npm test -- --filter=<name>"
    "./scripts/docker-helper.sh exec api uv run ruff check"
    "./scripts/docker-helper.sh exec api uv run ty check"
)

# Verificar que validation-commands.md existe
if [ ! -f "$VALIDATION_COMMANDS_FILE" ]; then
    echo -e "${RED}❌ Error: validation-commands.md no existe en $SHARED_DIR${NC}"
    exit 1
fi

echo -e "${GREEN}✓ validation-commands.md encontrado${NC}"
echo ""

# Buscar comandos hardcodeados en SKILL.md files
echo "📋 Buscando comandos hardcodeados en archivos SKILL.md..."
echo ""

FOUND_ISSUES=0

for skill_dir in "$SKILLS_DIR"/*/; do
    skill_file="$skill_dir/SKILL.md"
    if [ -f "$skill_file" ]; then
        skill_name=$(basename "$skill_dir")
        
        # Buscar comandos de validación hardcodeados
        for cmd in "${STANDARD_COMMANDS[@]}"; do
            # Escapar caracteres especiales para grep
            escaped_cmd=$(echo "$cmd" | sed 's/[[\.*^$()+?{|\\]/\\&/g')
            
            if grep -q "$escaped_cmd" "$skill_file"; then
                # Verificar si el skill ya referencia validation-commands.md
                if ! grep -q "validation-commands.md" "$skill_file"; then
                    echo -e "${YELLOW}⚠️  $skill_name: Contiene comando hardcodeado pero no referencia validation-commands.md${NC}"
                    echo "   Comando: $cmd"
                    echo "   Archivo: $skill_file"
                    echo ""
                    FOUND_ISSUES=1
                fi
            fi
        done
    fi
done

# Verificar symlinks rotos
echo "🔗 Verificando symlinks de validation-commands.md..."
echo ""

for skill_dir in "$SKILLS_DIR"/*/; do
    references_dir="$skill_dir/references"
    if [ -d "$references_dir" ]; then
        symlink="$references_dir/validation-commands.md"
        if [ -L "$symlink" ]; then
            if [ ! -e "$symlink" ]; then
                echo -e "${RED}❌ Symlink roto: $symlink${NC}"
                FOUND_ISSUES=1
            else
                echo -e "${GREEN}✓ Symlink válido: $symlink${NC}"
            fi
        fi
    fi
done

echo ""

if [ $FOUND_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✅ No se encontraron inconsistencias${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  Se encontraron inconsistencias que deben corregirse${NC}"
    exit 1
fi
