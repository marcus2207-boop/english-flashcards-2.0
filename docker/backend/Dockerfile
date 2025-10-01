# Multi-stage Dockerfile for FastAPI backend (Python 3.11)
# Location: docker/backend/Dockerfile
FROM python:3.11-slim AS build

# Install build deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create app user
ARG APP_USER=app
ARG APP_HOME=/app
RUN useradd --create-home --shell /bin/bash $APP_USER

WORKDIR $APP_HOME

# Copy dependency manifests first for cache efficiency
# Copy either pyproject.toml/poetry.lock or requirements.txt depending on the project
COPY ./backend/pyproject.toml ./backend/poetry.lock* ./

# Install Poetry if using it (optional)
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    /root/.local/bin/poetry config virtualenvs.create false

# Install dependencies
RUN if [ -f "pyproject.toml" ]; then \
      /root/.local/bin/poetry install --no-dev --no-interaction --no-ansi; \
    elif [ -f "requirements.txt" ]; then \
      pip install --no-cache-dir -r requirements.txt; \
    fi

# Copy application code
COPY ./backend/ ./

# Ensure non-root ownership
RUN chown -R $APP_USER:$APP_USER $APP_HOME

# Final minimal runtime image
FROM python:3.11-slim AS runtime

ENV PYTHONUNBUFFERED=1
ENV APP_HOME=/app
WORKDIR $APP_HOME

# Create non-root user
ARG APP_USER=app
RUN useradd --create-home --shell /bin/bash $APP_USER

# Copy installed packages from build stage (if using pip-installed wheel path)
COPY --from=build /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=build /usr/local/bin /usr/local/bin

# Copy application code
COPY --from=build /app /app

# Create data folders and set permissions (db + audio-cache)
RUN mkdir -p /data/audio-cache && chown -R $APP_USER:$APP_USER /data

# Set non-root user
USER $APP_USER

EXPOSE 8000

# Entrypoint (uvicorn)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--proxy-headers"]