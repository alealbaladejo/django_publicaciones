#!/bin/bash
export $(grep -v '^#' .env |  xargs)
# Esperar hasta que la base de datos esté lista
echo "Esperando a que la base de datos esté disponible..."
while ! mysql -u${DB_USER} -p${DB_PASSWORD} -h ${DB_HOST} -e "SHOW DATABASES;" &> /dev/null; do
    echo "Esperando a que MySQL esté disponible..."
    sleep 1
done

echo "Base de datos disponible. Ejecutando migraciones y el servidor Django."

source venv/bin/activate
# Aplicar las migraciones de Django
python3 manage.py migrate

# Crear un superusuario si es necesario
echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('${ADMIN_USER}', '${ADMIN_EMAIL}', '${ADMIN_PASS}')" | python manage.py shell

# Ejecutar el servidor de Django
python3 manage.py runserver 0.0.0.0:8000
