##########################################
###### RAG con Texto — 100% Local   ######
###### Ollama + pgvector + Jupyter  ######
##########################################

## ¿Que encontrarás en este repositorio?
Un sistema de preguntas y respuestas sobre documentos PDF que corre completamente en tu máquina. Sin API keys, sin costos por token.

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

| Componente | Herramienta |
|---|---|
| Embedding | `nomic-embed-text` via Ollama |
| Generación | `llama3.2:1b` via Ollama (optimizado para CPU) |
| Vector store | PostgreSQL + pgvector (Docker) |
| Notebook | Jupyter (Docker) |

---

## Requisitos previos

Solo necesitás tener instalado:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/): Para mayor detalle de la instalación, consultar con la documentación de Docker https://docs.docker.com/desktop/

> No es necesario instalar Jupyter, PostgreSQL ni Ollama localmente. Todo corre dentro de contenedores aisladoss.

---

## Instalación y uso

### 1. Descargar el archivo ZIP del repositorio y descomprimirlo. 
### Desde VSCODE apuntar a la ruta de la carpeta

```bash
cd .../Proyecto
```

### 3. Levantar todos los servicios

```bash
docker compose up --build
```

El comando 'compose up' levanta tres servicios automáticamente:
- **db** — PostgreSQL con pgvector en el puerto `5432`
- **ollama** — Servidor Ollama en el puerto `11434`. Descarga `nomic-embed-text` y `llama3.2:1b` automáticamente la primera vez
- **jupyter** — Jupyter Notebook en el puerto `8888`. Arranca cuando Ollama y la DB están listos

> La primera vez tarda unos minutos mientras se descargan los modelos (~1.5 GB en total). Las siguientes veces arranca en segundos.

### 4. Cuando todos los modelos estén listos, abrir el siguiente enlace en un navegador para acceder a Jupyter

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

| Variable | Descripción | Default |
|---|---|---|
| `DB_HOST` | Host de PostgreSQL | `localhost` |
| `DB_PORT` | Puerto de PostgreSQL | `5432` |
| `DB_NAME` | Nombre de la base de datos | `rag_demo` |
| `DB_USER` | Usuario de PostgreSQL | `postgres` |
| `DB_PASSWORD` | Contraseña de PostgreSQL | `postgres` |

> Con Docker Compose `DB_HOST` y `OLLAMA_HOST` se sobreescriben automáticamente para apuntar a los servicios internos.

---

## Comandos útiles

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
