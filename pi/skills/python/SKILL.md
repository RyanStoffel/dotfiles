---
name: python
description: Set up, run, test, lint, and format Python projects. Use for Python repos — detect the tool (uv/poetry/pip) first.
---
# Python

## Detect
- `uv.lock` → uv · `poetry.lock` → poetry · else `requirements.txt` + venv.

## uv
- Sync: `uv sync` · Run: `uv run <cmd>` · Test: `uv run pytest` · Add: `uv add <pkg>`

## poetry
- Install: `poetry install` · Test: `poetry run pytest`

## pip / venv
- `python -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt`

Lint/format: `ruff check .` then `ruff format .` (fallback `black .`). Types: `mypy` if configured.
