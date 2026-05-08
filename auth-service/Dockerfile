FROM python:3.9 as builder

WORKDIR /app

RUN apt-get update -y && \
    apt-get install -y build-essential libpq-dev

COPY requirements.txt .

RUN pip install --no-cache-dir --user -r requirements.txt

COPY . .

FROM python:3.9-slim

WORKDIR /app

COPY --from=builder /root/.local /root/.local

COPY --from=builder /app /app

# Ensure the installed libraries are in the Python path
ENV PATH=/root/.local/bin:$PATH

EXPOSE 8080

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]