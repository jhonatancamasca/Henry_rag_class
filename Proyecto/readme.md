
# RAG con Texto — 100% Local (Ollama + pgvector + Jupyter ) 

---

### Este repositorio contiene un sistema de Generación Aumentada por Recuperación (RAG) que corre completamente en tu máquina.  Despliega un sistema de preguntas y respuestas sobre documentos PDF que corre completamente en tu máquina. Sin API keys, sin costos por token.

## ¿Qué hace?

1. Toma un PDF y lo divide en fragmentos (chunks)
2. Convierte cada fragmento en un vector numérico (embedding)
3. Guarda los vectores en PostgreSQL + pgvector
4. Cuando haces una pregunta, busca los fragmentos más relevantes y se los pasa a un LLM para que responda

```
Fase de Ingesta: Lo que ocurre al leer el documento y guardarlo en la base de datos de vectores.

PDF  →  Chunking  →  nomic-embed-text  →  pgvector

Fase de Inferencia (RAG): Lo que ocurre al hacer una pregunta

Pregunta  →  nomic-embed-text  →  pgvector (<=>)  →  top-K chunks  →  llama3.2:1b  →  Respuesta
```

---

## Stack 

Para que este sistema funcione, combinamos cuatro pilares fundamentales de la ingeniería de datos e IA:

| Componente | Herramienta |
|---|---|
| Embedding | `nomic-embed-text` via Ollama | El motor que transforma texto legible en vectores que representan conceptos semántico
| Generación | `llama3.2:1b` via Ollama (optimizado para CPU) | versión extremadamente rápida sin sacrificar coherencia en tareas de RAG
| Vector store | PostgreSQL + pgvector (Docker) |  No se limita a buscar palabras exactas, pgvector permite realizar búsquedas por "similitud" matemática
| Notebook | Jupyter (Docker) | El Orquestador que garantiza que el entorno sea idéntico para todos

---

## Requisitos previos

Solo necesitás tener instalado:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/): Para mayor detalle de la instalación, consultar con la documentación de Docker https://docs.docker.com/desktop/

> No es necesario instalar Jupyter, PostgreSQL ni Ollama localmente. Todo corre dentro de contenedores aisladoss.

---

## Instalación y uso

### 1. Descargar el archivo ZIP del repositorio o clonarlo desde la ruta en Github

```bash
git clone https://github.com/jhonatancamasca/Henry_rag_class.git
cd Henry_rag_class
```

### 2. Después de ubicarse en la carpeta, levantar todos los servicios

```bash
docker compose up --build
```

El comando 'compose up' levanta tres servicios automáticamente:
- **db** — PostgreSQL con pgvector en el puerto `5432`
- **ollama** — Servidor Ollama en el puerto `11434`. Descarga `nomic-embed-text` y `llama3.2:1b` automáticamente la primera vez
- **jupyter** — Jupyter Notebook en el puerto `8888`. Arranca cuando Ollama y la DB están listos

> La primera vez tarda unos minutos mientras se descargan los modelos (~1.5 GB en total). Las siguientes veces arranca en segundos.

### 3. Acceder a la clase
Cuando todos los modelos estén listos, abre en tu navegador para acceder a Jupyter

```
http://localhost:8888
```
---

## Estructura del proyecto
### En Jupyter encontrarás la siguiente estructura del proyecto
```
.
├── Dockerfile                  # Imagen Python + Jupyter
├── docker-compose.yml          # Orquesta db + ollama + jupyter
├── entrypoint_ollama.sh        # Descarga modelos automáticamente al arrancar
├── requirements.txt            # Dependencias Python
├── .env                        # Variables de entorno (no commitear)
├── .env.example                # Plantilla del .env (sí commitear)
├── .gitignore
└── rag_clase_final.ipynb       # Notebook principal
```

---

### Abre `rag_clase_final.ipynb`, y ejecuta las celdas línea por línea de arriba a abajo.


## Variables de entorno

Estos son los serviciones que llama Docker según su nombre de red

| Variable | Descripción | Default |
|---|---|---|
| `DB_HOST` | Host de PostgreSQL | `localhost` |
| `DB_PORT` | Puerto de PostgreSQL | `5432` |
| `DB_NAME` | Nombre de la base de datos | `rag_demo` |
| `DB_USER` | Usuario de PostgreSQL | `postgres` |
| `DB_PASSWORD` | Contraseña de PostgreSQL | `postgres` |

> Con Docker Compose `DB_HOST` y `OLLAMA_HOST` se sobreescriben automáticamente para apuntar a los servicios internos.

---

## Otros comandos útiles

```bash
# Levantar en background
docker compose up -d --build

# Ver logs en tiempo real
docker compose logs -f

# Ver solo logs de ollama (útil para ver la descarga de modelos)
docker compose logs -f ollama

# Apagar (conserva la base de datos y los modelos)
docker compose down

# Apagar y borrar todo (base de datos + modelos descargados)
docker compose down -v

# Reconstruir solo la imagen de Jupyter
docker compose up --build jupyter
```
