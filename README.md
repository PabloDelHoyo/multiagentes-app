# multiagentes-app
Una simple aplicación web para explorar datos relacionados con el sector de la automoción, con un especial
interés en el vehículo eléctrico. TODO: incluir la parte de predicción

## Desarrollo
WIP.

## Despliegue
### Backend
Para desplegar el backend, sitúate en la directorio
backend.
```bash
$ cd backend/
```
A continuación, haz una copia del archivo `compose.template.yml` con el nombre `compose.yml` y adáptalo a tus necesidades concretas. Para más información sobre cómo configurar este archivo, pincha [aquí](https://github.com/PabloDelHoyo/multiagentes-app/tree/master/backend/README.md).

De la forma en la que está la plantilla, solo tienes que crear un archivo llamado `root_password.txt` en el que se
debe incluir la contraseña que el usuario `root` de la base
de datos tendrá. 

Una vez hecho lo anterior, ejecuta lo siguiente

```bash
$ docker compose up -d 
```
Por defecto, el servicio escuchará en todas las direcciones IP que tenga la máquina en el puerto 8000. Esto puede cambiarse en el archivo `compose.yml`. Además también se expone el puerto 3306 de la base de datos.





Para parar el servicio, deberás ejecutar lo siguiente
```bash
$ docker compose down
```
Lo anterior no elimina el volumen que el contenedor de la base de datos crea para que los datos sean persistentes. Si quieres eliminarlo, deberás emplear `docker volume rm <nombre-volumen>`.

Ten en cuenta que la primer vez que ejecutas el comando anterior, se montará una nueva base de datos que estará vacía. Para que la API haga algo útil, tendrás que insertar previamente los datos. Si por alguna razón, solo quisieras levantar la base de datos (por ejemplo, para insertar los datos), puedes hacer lo siguiente

```bash
$ docker compose run --rm --service-ports -d mineriadb
```