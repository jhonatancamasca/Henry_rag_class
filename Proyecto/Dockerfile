FROM python:3.11-slim

# ── Metadata ──────────────────────────────────────────────────
LABEL maintainer="Henry"
LABEL description="RAG con Texto — Ollama + pgvector + Jupyter"

# ── Dependencias del sistema ──────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# ── Directorio de trabajo ─────────────────────────────────────
WORKDIR /app

# ── Dependencias Python ───────────────────────────────────────
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ── Puerto Jupyter ────────────────────────────────────────────
EXPOSE 8888

# ── Arrancar Jupyter sin token ni password (solo para uso local) ──
CMD ["jupyter", "notebook", \
     "--ip=0.0.0.0", \
     "--port=8888", \
     "--no-browser", \
     "--allow-root", \
     "--ServerApp.token=''", \
     "--ServerApp.password=''", \
     "--notebook-dir=/app"]