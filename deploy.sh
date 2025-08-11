IMAGE_NAME="docker-evaluation"
CONTAINER_NAME="docker-evaluation-container"
PORT=8080

echo "Verificando si docker está instalado"
if ! command -v docker &> /dev/null; then
    echo "Docker no está instalado, por favor, instalelo antes de continuar"
    exit 1
fi

echo "Docker está instalado"

echo "Construyendo la imagen automáticamente"
if ! docker build -t $IMAGE_NAME .; then
    echo "Error al construir la imagen"
    exit 1
fi

echo "Imagen construida correctamente"

echo "Ejecutando contenedor"
docker rm -f $CONTAINER_NAME &> /dev/null
if ! docker run -d --name $CONTAINER_NAME -p $PORT:3000 \
    -e PORT=$PORT \
    -e NODE_ENV=production \
    $IMAGE_NAME; then
    echo "Error al ejecutarse el contenedor"
    exit 1
fi

echo "Contenedor ejecutandose"

echo "Probando"
sleep 3
if curl -s http://localhost:$PORT | grep -Fq "Bienvenido a la aplicación de evaluación DevOps"; then
    echo "La aplicación funciona correctamente"
else
    echo "La aplicación no funciona como se esperaba"
    exit 1
fi
