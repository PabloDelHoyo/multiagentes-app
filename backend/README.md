# multiagentes-backend

## Despligue
Para ejecutarlo con el fin de desplegarlo, sitúa tu directorio de trabajo en esta
carpeta. A continuación, haz una copia del archivo `compose.template.yml` con el nombre de `compose.yml`. Una vez hayas adaptado el `compose.yml` a tus necesidades y hayas guardado los archivos txt con los "secretos" requeridos para que el backend funcione, ejecuta lo siguiente

```bash
$ docker compose up -d
```

Para pararlo, ejecuta lo siguiente
```bash
$ docker compose down
```

## Configuración del `compose.yml`
### Servicio `mineriadb`
#### No obligar a que las conexiones sean seguras
Si la base de datos se está ejecutando en la misma máquina en la que lo está haciendo la API, no hace falta cifrar los datos porque no se exponen a los mismos riesgos que cuando se envían por Internet.

Para quitar esa obligación, elimina lo siguiente

```yaml
- command: --require-secure-transport=ON
```

### Servicio `mineriaapi`
El comportamiento de este servicio puede modificarse a través del archivo `compose.yml` por medio de variables de entorno. Las variables de entorno que define la API son

#### `ROOT_PATH`
Esto es un parámetro que definido por el estándar ASGI que indica la ruta donde se monta la API. En el caso concreto de FastAPI, el parámetro es utilizado principalmente para que el pequeño frontend utilizado para documentar los endpoints (situado en `/doc` o `/redoc`) sepa a qué URL pedir el archivo que contiene esa información.

#### `DB_USERNAME_FILE`
Ruta del archivo que contiene el nombre de usuario que se utilizará para conectarse a la base de datos. Si no se especifica, el valro por defecto es `root`. Al tratarse de información que puede considerarse sensible, lo más recomendable es pasar esta información usando [secretos](https://docs.docker.com/compose/use-secrets/)

#### `DB_PASSWORD_FILE`
Ruta del archivo que contiene la contreseña de usuario que se usará para conectarse a la base de datos. Esta variable de entorno es obligatoria. Si no se especifica, el servicio fallará. Al tratarse de información sensible, lo más recomendable es pasar esta información usando [secretos](https://docs.docker.com/compose/use-secrets/)

#### `DB_HOST`
El host de la base de datos. Como lo más usual es ejecutar la base de datos junto a la API a través de `docker compose` y, por tanto, en la misma red virtual, el valor por defecto es el `network alias` que recibe el servicio, es decir, `mineriadb`.

La imagen base utilizada para la construcción de la imagen de la API es [uvicorn-gunicorn-fastapi-docker](https://github.com/tiangolo/uvicorn-gunicorn-fastapi-docker). Este crea un proceso master [`gunicorn`](https://gunicorn.org/) que creará, por defecto, tantos trabajadores (workers) [`uvicorn`](https://www.uvicorn.org/) como núcleos tenga la máquina sobre la que se está ejecutando. Los workers son procesos que contiene copias del programa que implementa la API. La imagen trae configuraciones por defecto que funcionan para la gran mayoría de situaciones (sensible defaults) pero si se desea cambiarlos, consulta la [documentación](https://github.com/tiangolo/uvicorn-gunicorn-fastapi-docker#advanced-usage) de la imagen.

La variable de entorno que utiliza la imagen base que probablemente se desee modificar es `WEB_CONCURRENCY`. El valor que recibe es un número entero positivo que representa el número de workers que quieres que se generen.