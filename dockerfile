# ---------- BASE ----------
FROM python:3.12-slim AS base

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY . .


# ---------- TEST ----------
FROM base AS test

COPY requirements.txt .
COPY requirements-dev.txt .

RUN pip install --no-cache-dir -r requirements-dev.txt

CMD ["pytest", "-v"]


# ---------- DEV ----------
FROM base AS dev

COPY requirements.txt .
COPY requirements-dev.txt .

RUN pip install --no-cache-dir -r requirements-dev.txt

EXPOSE 5000

CMD ["flask", "--app", "run", "run", "--debug", "--host", "0.0.0.0", "--port", "5000"]


# ---------- PRODUCTION ----------
FROM base AS production

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir gunicorn

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "run:app"]