#!/bin/bash
set -e

# Arrancar Ollama en background
echo "Arrancando Ollama..."
ollama serve &
OLLAMA_PID=$!

# Esperar a que Ollama esté listo
echo "Esperando a que Ollama esté listo..."
until ollama list > /dev/null 2>&1; do
  sleep 1
done
echo "✓ Ollama listo"

# Descargar modelos si no existen
pull_if_missing() {
  MODEL=$1
  if ollama list 2>/dev/null | grep -q "${MODEL}"; then
    echo "✓ ${MODEL} ya está descargado"
  else
    echo "↓ Descargando ${MODEL}..."
    ollama pull "${MODEL}"
    echo "✓ ${MODEL} listo"
  fi
}

pull_if_missing "nomic-embed-text"
pull_if_missing "llama3.2:1b"   # 1B params — rápido en CPU, ~1.3GB

echo "=== Todos los modelos listos — Ollama corriendo ==="

wait $OLLAMA_PID