FROM debian:12

WORKDIR /app

FROM debian:12

WORKDIR /app

# Actualizar repositorios y agregar dependencias necesarias
RUN apt-get update && apt-get install -y \
        mariadb-client python3-dev python3.11-venv git python3 \
        default-libmysqlclient-dev build-essential pkg-config \
        && rm -rf /var/lib/apt/lists/*

COPY . /app/

# Crear y activar entorno virtual, luego instalar dependencias
RUN python3 -m venv venv
RUN ./venv/bin/pip install --upgrade pip
RUN ./venv/bin/pip install --no-cache-dir -r /app/requirements.txt

# Instalar mysqlclient
RUN ./venv/bin/pip install mysqlclient

EXPOSE 8000

ENV DB_NAME=publicaciones_db
ENV DB_USER=admin
ENV DB_PASSWORD=admin
ENV DB_HOST=db
ENV DB_PORT=3306

COPY script.sh /app/script.sh
RUN chmod +x /app/script.sh

CMD ["/app/script.sh"]

