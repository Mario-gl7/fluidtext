#!/bin/bash
# Script para crear repo en GitHub con branch independiente y push automático

# Nombre del repositorio
REPO_NAME="$1"

if [ -z "$REPO_NAME" ]; then
  echo "Usage: ./create_repo.sh <repo-name>"
  exit 1
fi

# Configura usuario Git si no está configurado
git config --global user.name "Mario-gl7"
git config --global user.email "mariogutierrezlopezz@gmail.com"

# Crear repo en GitHub
echo "Creating GitHub repository '$REPO_NAME'..."
gh repo create "$REPO_NAME" --public --confirm

# Inicializar repo local si no existe
if [ ! -d ".git" ]; then
  git init
fi

# Crear branch independiente sin historial
git checkout --orphan independent_branch

# Añadir todos los archivos
git add .

# Commit inicial
git commit -m "Initial commit: LinguaReader full release"

# Configurar remoto origin (si no está)
git remote remove origin 2>/dev/null
git remote add origin https://github.com/$(gh api user --jq .login)/"$REPO_NAME".git

# Push del branch independiente
git push -u origin independent_branch

echo "Repository '$REPO_NAME' created with independent branch 'independent_branch'. Remember to set secrets: PONS_API_KEY"
