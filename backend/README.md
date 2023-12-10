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

####
