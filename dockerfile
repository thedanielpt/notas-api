FROM python:3.12-slim AS base
WORKDIR /app

FROM base AS test
COPY requirements.txt requirements-dev.txt ./
RUN pip install -r requirements-dev.txt
COPY . .
CMD ["pytest", "-v"]

FROM base AS dev
COPY requirements.txt requirements-dev.txt ./
RUN pip install -r requirements-dev.txt
COPY . .
EXPOSE 5000
CMD ["flask", "--app", "run", "run", "--debug", "--host", "0.0.0.0"]

FROM base AS production
COPY requirements.txt ./
RUN pip install -r requirements.txt && pip install gunicorn
COPY . .
EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "run:app"]