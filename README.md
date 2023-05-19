Docker-Compose инструмент для создания и запуска многоконтейнерных Docker приложений. В Compose, вы используете специальный файл для конфигурирования ваших сервисов приложения. Затем, используется простая команда, для создания и запуска всех сервисов из конфигурационного файла. 

Compose превосходен для разработки, тестирования и настройки среды, а также непрерывной интеграции. Вы этом разделе вы можете узнать более подробно о решаемых задачах.

Использование Compose обычно разделяется на три этапа:
1. Определение окружения вашего приложения в Dockerfile, это можно сделать в любом месте.
2. Определение сервисов из которых будет состоять ваше приложение в docker-compose.yml, в последствии они смогут быть запущены все вместе в изолированном окружении.
3. И наконец, выполнение команды docker-compose up которая запустит все ваше приложение.

Оглавление
Введение в docker-compose CLI
Переменные окружения CLI
  COMPOSE_PROJECT_NAME
  COMPOSE_FILE
  COMPOSE_API_VERSION
  DOCKER_HOST
  DOCKER_TLS_VERIFY
  DOCKER_CERT_PATH
  COMPOSE_HTTP_TIMEOUT
  COMPOSE_TLS_VERSION
Расширение сервисов и Compose файлов
  Несколько Compose файлов
  Общие сведения о нескольких файлах Compose
  Пример варианта использования
Переменные окружения в Compose
  Подстановка переменных среды в Compose файлах
  Задание переменных окружения в контейнерах
  Передача переменных окружения в контейнеры
  Опция env_file
  Установка переменных окружения с помощью команды docker-compose run
  Файл .env
Руководство по Docker Compose файлу
  Руководство по конфигурации сервисов
  build
    context
  dockerfile
  args
  cap_add, cap_drop
  command
  cgroup_parent
  container_name
  devices
  depends_on
  dns
  dns_search
  tmpfs
  entrypoint
  env_file
  environment
  expose
  extends
  external_links
  extra_hosts
  image
  labels
  links
  logging
  log_driver
  log_opt
  net
  network_mode
  networks
  aliases
  ipv4_address, ipv6_address
  pid
  ports
  security_opt
  stop_signal
  ulimits
  volumes, volume_driver
  volumes_from
  cpu_shares, cpu_quota, cpuset, domainname, hostname, ipc, mac_address, mem_limit, memswap_limit, privileged, read_only, restart, shm_size, stdin_open, tty, user, working_dir
Volume configuration reference
  driver
  driver_opts
  external
Network configuration reference
  driver
  driver_opts
  ipam
  external
Версии
  Version 1
  Version 2
  Upgrading
Variable substitution
Мои примеры  
Введение в docker-compose CLI
Эта страница содержит информацию об использовании docker-compose команд. Вы также можете увидеть данную информацию выполнив команду docker-compose --help в командной строке.

Определяйте и запускайте многоконтейнерные приложения с помощью Docker.

Использование:
  docker-compose [-f=<arg>...] [options] [COMMAND] [ARGS...]
  docker-compose -h|--help

Опции:
  -f, --file FILE             Укажите альтернативный файл для компоновки (по умолчанию: docker-compose.yml)
  -p, --project-name NAME     Укажите альтернативное имя проекта (по умолчанию: имя каталога)
  --verbose                   Показать больше результатов
  -v, --version              Версия
  -H, --host HOST           Хост демона

  --tls                      Используйте TLS; подразумевается --tlsverify
  --tlscacert CA_PATH         Сертификаты доверия, подписанные только этим ЦС
  --tlscert CLIENT_CERT_PATH  Путь к файлу сертификата TLS
  --tlskey TLS_KEY_PATH       Путь к ключевому файлу TLS
  --tlsverify                 Использовать TLS и проверить удаленно
  --skip-hostname-check       Не сверяйте имя хоста демона с именем, указанным
                                              в сертификате клиента (например, если ваш хост
                                              докера является IP-адресом)

Команды:
  build              Build or rebuild services
  config             Validate and view the compose file
  create             Create services
  down               Stop and remove containers, networks, images, and volumes
  events             Receive real time events from containers
  help               Get help on a command
  kill               Kill containers
  logs               View output from containers
  pause              Pause services
  port               Print the public port for a port binding
  ps                 List containers
  pull               Pulls service images
  restart            Restart services
  rm                 Remove stopped containers
  run                Run a one-off command
  scale              Set number of containers for a service
  start              Start services
  stop               Stop services
  unpause            Unpause services
  up                 Create and start containers
  version            Show the Docker-Compose version information
 
Docker Compose является бинарником. Команда docker-compose используется для сборки и управления несколькими сервисами в Docker контейнере.

Используйте флаг -f для указания местоположения конфигурационного файла Compose. Вы можете использовать несколько конфигурациооных файлов, при этом Compose комбинирует их в единую конфигурацию. Compose собирает конфигурацию в том порядке в котором вы указали файлы. Последующие файлы добавляются к предыдущим.

Для примера, рассмотрим эту команду:
$ docker-compose -f docker-compose.yml -f docker-compose.admin.yml run backup_db`
Файл docker-compose.yml определяет сервис webapp:

webapp:
  image: examples/web
  ports:
    - "8000:8000"
  volumes:
    - "/data"
Если в файле docker-compose.admin.yml так же задан этот сервис, любые соответствующие поля будут заменять значения в предыдущем файле. Новые значения добавляются к конфигурации сервиса webapp.

webapp:
  build: .
  environment:
    - DEBUG=1
Используйте флаг -f вместе с - (тире) вместо имени файла для чтения конфигурации из stdin. Когда используется stdin все пути конфигурационных файлов считаются относительными текущей рабочей директории.

Флаг -f является не обязательным. Если вы не используете данный флаг в командной строке, Compose проверяет текущую директорию и родительские в поисках файлов docker-compose.yml и docker-compose.override.yml. Должен быть хотя бы файл docker-compose.yml. Если оба файла присутствуют в одном каталоге, Compose комбинирует оба файла в единую конфигурацию. Конфигурационный файл docker-compose.override.ymlприменяется поверх файла docker-compose.yml.

Каждая конфигурация имеет имя проекта. С помощью флага -p, вы можете задать имя проекта. Если вы не используете данный флаг, Compose использует имя каталога с проектом. 

Переменные окружения CLI
существует несколько переменных окружения для конфигурирования поведения командной строки Docker Compose.

Переменные начинающиеся с DOCKER_ те же что и используются в конфигурационном файле клиента командной строки Docker. Если вы используете docker-machine, тогда команда eval "$(docker-machine env my-docker-vm)" установит их в корректные значение. (В этом примере, my-docker-vm имя созданной вами машины.)

Примечание: некоторые из этих переменных также могут быть заданы с помощью файла окружения

COMPOSE_PROJECT_NAME
Устанавливает название проекта. Это значение выступает префиксом перед именем службы для контейнера при пуске. К примеру, если название проекта myapp и включает два сервиса db и web, то compose запустит контейнеры с названиями myapp_db_1 и myapp_web_1.

Задается при необходимости. Если вы не задали данную переменную, то значение COMPOSE_PROJECT_NAME будет установлено из названия директории проекта. Читайте также про опцию командной строки -p.

COMPOSE_FILE
Задает путь к файлу Compose. Если не задано, Compose ищет файл с именем docker-compose.yml в текущем каталоге, а затем в каждом из родительских каталогов пока файл не будет найден.

Данная переменная поддерживает множественные значения, при этом имена файлов отделяются разделителем путей (в Linux и OSX :, в Windows ;). Например, так: COMPOSE_FILE=docker-compose.yml:docker-compose.prod.yml

COMPOSE_API_VERSION
Docker API поддерживает только запросы от клиентов которые сообщают версию API. Если вы видите сообщение об ошибке client and server don't have same version error при использовании docker-compose, вы можете обойти эту ошибку, установив данную переменную окружения. Установите значение версии соответствующее версии сервера.

Установка этой переменной предназначена в качестве временного решения для ситуаций, когда необходимо работать с несоответствующими версиями клиента и сервера. Например, если вы обновили версию клиента и ждете обновления версии на сервере.

Запуск с данной переменной может привести к тому что некоторые возможности Docker не будут работать должным образом. Функции которые не будут работать зависят от версии Docker клиента и сервера. По этой причине, использовать данную переменную рекомендуется только в качестве временной меры.

Если вы столкнулись с проблемами при запуске с данной переменной, устраните несоответствие версий клиента и сервера и удалите переменную прежде чем обращаться в службу поддержки.

DOCKER_HOST
Устанавливает URL docker демона. По умолчанию Docker клиент использует значение unix:///var/run/docker.sock.

DOCKER_TLS_VERIFY
Если установить что-то кроме пустой строки, будет активирован TLS при обмене между docker демоном.

DOCKER_CERT_PATH
Задает путь к ca.pem, cert.pem и key.pem файлам для TLS верификации. По умолчанию ~/.docker.

COMPOSE_HTTP_TIMEOUT
Задает время тайм аута (в секундах) на ответ Docker демона, после чего Compose считает запрос не удачным. По умолчанию 60 секунд.

COMPOSE_TLS_VERSION
Задает TLS версию используемую для обмена с docker демоном. По умолчанию TLSv1. поддерживаемые значения: TLSv1, TLSv1_1, TLSv1_2

Расширение сервисов и Compose файлов
Compose поддерживает два метода совместного использования общей конфигурации:

Расширение файла Compose с помощью нескольких файлов Compose
Расширением отдельных сервисов с помощью поля extends
Несколько Compose файлов
Использование нескольких Compose файлов позволяет настроить Compose приложение для различных сред и рабочих процессов.

Общие сведения о нескольких файлах Compose
По умолчанию, Compose читает два файла, docker-compose.yml и опционально docker-compose.override.yml файл. Условно, docker-compose.yml содержит базовую конфигурацию. Файл переопределения, как следует из его названия, может содержать измененную конфигурацию существующих сервисов или совершенно новых.

Если сервис определен в обоих файлах, то Compose объединяет конфигурации используя правила описанные в разделе добавление и замена конфигураций.

Для использования нескольких файлов переопределения или переопределяющий файл с другим именем, вы можете использовать опцию -f что бы указать список файлов. Compose объединяет файлы в том же порядке в котором они были указаны в командной строке. 

Когда вы используете несколько конфигурационных файлов, вы должны удостовериться что все пути в файлах являются относительными по отношению к базовому Compose файлу (первый файл указанный после -f). Это требуется по тому что файлы переопределения могут быть не действительными Compose файлами. Файлы переопределения могут содержать небольшие фрагменты конфигурации. Отслеживание того какой фрагмент сервиса относится к какому пути является сложным и запутанным, по этому для облегчения восприятия путей все они должны быть определены относительно базового файла.

Пример варианта использования
В этом разделе представлены два общих сценария использования нескольких docker compose файлов: изменение Compose приложения для различных сред и выполнение административных задач в приложении Compose.

Различные среды
Обычным случаем для использования нескольких файлов является изменение Compose приложения для разработки на продакшн окружение или CI. Для поддержки подобных различий, вы можете разделить вашу Compose конфигурацию на несколько разных файлов:

Начнем с главного файла который определяет базовую конфигурацию сервисов.

docker-compose.yml

web:
  image: example/my_web_app:latest
  links:
    - db
    - cache

db:
  image: postgres:latest

cache:
  image: redis:latest
В данном примере конфигурация для разработки линкует несколько портов к хосту, монтирует наш код в том данных и строит web образ.

docker-compose.override.yml

web:
  build: .
  volumes:
    - '.:/code'
  ports:
    - 8883:80
  environment:
    DEBUG: 'true'

db:
  command: '-d'
  ports:
    - 5432:5432

cache:
  ports:
    - 6379:6379
Когда вы выполняете docker-compose up он автоматически читает файлы переопределения.

Теперь, было бы не плохо использовать данное Compose приложение с продакшн окружением. Итак, создадим другой файл переопределения (который может быть размещен в другом git репозитории и управляться другой командой разработчиков).

docker-compose.prod.yml

web:
  ports:
    - 80:80
  environment:
    PRODUCTION: 'true'

cache:
  environment:
    TTL: '500'
Для развертывания с использованием данного продакшн Compose файла вы можете выполнить следующую команду:

docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
Данная команда разворачивает все три сервиса используя конфигурацию из файлов docker-compose.yml и docker-compose.prod.yml (но не из конфигурации для разработки docker-compose.override.yml).

Переменные окружения в Compose
Есть несколько частей Compose, которые имеют дело с переменными окружения в том или ином смысле. Эта страница поможет вам найти нужную информацию.

Подстановка переменных среды в Compose файлах
В оболочке можно использовать переменные среды для заполнения значений внутри файла Compose:

web:
  image: "webapp:${TAG}"
Задание переменных окружения в контейнерах
Вы можете задать переменные окружения в контейнере сервиса с помощью ключевого слова environment, также как и в случае docker run -e VARIABLE=VALUE ...:

web:
  environment:
    - DEBUG=1
Передача переменных окружения в контейнеры
Вы можете передать переменные окружения из вашей оболочки прямо в контейнеры сервиса с помощью ключевого слова environment но не задавая значение, так же как и в docker run -e VARIABLE ...:

web:
  environment:
    - DEBUG
Значение переменной DEBUG в контейнере будет взято из значения той же переменной в оболочке из которой был запущен Compose.

Опция env_file
Вы можете передать несколько переменных окружения из внешнего файла tв контейнеры сервиса с помощью опции env_file, также как и в docker run --env-file=FILE ...:

web:
  env_file:
    - web-variables.env
Установка переменных окружения с помощью команды docker-compose run
Так же как и в docker run -e, вы можете задать переменные окружения в контейнере с помощью docker-compose run -e:

$ docker-compose run -e DEBUG=1 web python console.py
Вы так же можете передать переменную из shell если не будете задавать ее значение:

$ docker-compose run -e DEBUG web python console.py
Значение переменной DEBUG в контейнере будет взято из значения той же переменной в оболочке из которой был запущен Compose.

Файл .env
Вы можете установить значения по умолчанию для любых переменных среды, указанных в Compose файле или использовать для настройки Compose файл среды с именем .env:

$ cat .env
TAG=v1.5

$ cat docker-compose.yml
version: '2.0'
services:
  web:
    image: "webapp:${TAG}"
Когда вы запускаете docker-compose up, сервис web определенный выше использует образ webapp:v1.5. Вы можете убедиться в этом с помощью команды настроек, которая выводит настройки вашего приложения в терминал:

$ docker-compose config
version: '2.0'
services:
  web:
    image: 'webapp:v1.5'
Значения из оболочки имеют приоритет над переменными из .env файла. Если вы установите TAG в другое значение в вашей оболочке, будет произведена следующая подстановка:

$ export TAG=v2.0

$ docker-compose config
version: '2.0'
services:
  web:
    image: 'webapp:v2.0'


Руководство по Docker Compose файлу
Compose файл использует YAML формат и определяет сервисы, сети и тома. По умолчанию Compose файл имеет имя ./docker-compose.yml и располагается в корне проекта.

Определение сервиса contains configuration which will be applied to each container started for that service, much like passing command-line parameters to docker run. Также, network and volume definitions are analogous to docker network create and docker volume create.

As with docker run, options specified in the Dockerfile (e.g., CMD, EXPOSE, VOLUME, ENV) are respected by default - you don’t need to specify them again in docker-compose.yml.

Вы можете использовать переменные окружения in configuration values with a Bash-like ${VARIABLE} syntax - see variable substitution for full details.

Руководство по конфигурации сервисов
Примечание: Существует две версии формата Compose файла, версия 1 (устаревший формат, который не поддерживает тома и сети) и версия 2 (самая современная). Более подробную информацию вы можете получить в разделе Версии.

В этом разделе содержится список всех параметров конфигурации, поддерживаемых определением службы.

build
Параметры конфигурации, которые применяются во время сборки.

build можно указать либо как строку, содержащую путь к контексту сборки, либо как объект с путем, указанным в контексте и, возможно, dockerfile и args.

build: ./dir  
build:
  context: ./dir
  dockerfile: Dockerfile-alternate
  args:
    buildno: 1
If you specify image as well as build, then Compose names the built image with the webapp and optional tag specified in image:

build: ./dir
image: webapp:tag
This will result in an image named webapp and tagged tag, built from ./dir.

Note: In the version 1 file format, build is different in two ways:

Only the string form (build: .) is allowed - not the object form.
Using build together with image is not allowed. Attempting to do so results in an error.
context
Version 2 file format only. In version 1, just use build.

Either a path to a directory containing a Dockerfile, or a url to a git repository.

When the value supplied is a relative path, it is interpreted as relative to the location of the Compose file. This directory is also the build context that is sent to the Docker daemon.

Compose will build and tag it with a generated name, and use that image thereafter.

build:
  context: ./dir
dockerfile
Alternate Dockerfile.

Compose will use an alternate file to build with. A build path must also be specified.

build:
  context: .
  dockerfile: Dockerfile-alternate
Note: In the version 1 file format, dockerfile is different in two ways:

It appears alongside build, not as a sub-option:

build: .
dockerfile: Dockerfile-alternate
Using dockerfile together with image is not allowed. Attempting to do so results in an error.

args
Version 2 file format only.

Add build arguments, which are environment variables accessible only during the build process.

First, specify the arguments in your Dockerfile:

ARG buildno
ARG password

RUN echo "Build number: $buildno"
RUN script-requiring-password.sh "$password"
Then specify the arguments under the build key. You can pass either a mapping or a list:

build:
  context: .
  args:
    buildno: 1
    password: secret

build:
  context: .
  args:
    - buildno=1
    - password=secret
You can omit the value when specifying a build argument, in which case its value at build time is the value in the environment where Compose is running.

args:
  - buildno
  - password
Note: YAML boolean values (true, false, yes, no, on, off) must be enclosed in quotes, so that the parser interprets them as strings.

cap_add, cap_drop
Add or drop container capabilities. See man 7 capabilities for a full list.

cap_add:
  - ALL

cap_drop:
  - NET_ADMIN
  - SYS_ADMIN
command
Override the default command.

command: bundle exec thin -p 3000
The command can also be a list, in a manner similar to dockerfile:

command: [bundle, exec, thin, -p, 3000]
cgroup_parent
Specify an optional parent cgroup for the container.

cgroup_parent: m-executor-abcd
container_name
Specify a custom container name, rather than a generated default name.

container_name: my-web-container
Because Docker container names must be unique, you cannot scale a service beyond 1 container if you have specified a custom name. Attempting to do so results in an error.

devices
List of device mappings. Uses the same format as the --device docker client create option.

devices:
  - "/dev/ttyUSB0:/dev/ttyUSB0"
depends_on
Express dependency between services, which has two effects:

docker-compose up will start services in dependency order. In the following example, db and redis will be started before web.

docker-compose up SERVICE will automatically include SERVICE’s dependencies. In the following example, docker-compose up web will also create and start db and redis.

Simple example:

version: '2'
services:
  web:
    build: .
    depends_on:
      - db
      - redis
  redis:
    image: redis
  db:
    image: postgres
Note: depends_on will not wait for db and redis to be “ready” before starting web - only until they have been started. If you need to wait for a service to be ready, see Controlling startup order for more on this problem and strategies for solving it.

dns
Custom DNS servers. Can be a single value or a list.

dns: 8.8.8.8
dns:
  - 8.8.8.8
  - 9.9.9.9
dns_search
Custom DNS search domains. Can be a single value or a list.

dns_search: example.com
dns_search:
  - dc1.example.com
  - dc2.example.com
tmpfs
Version 2 file format only.

Mount a temporary file system inside the container. Can be a single value or a list.

tmpfs: /run
tmpfs:
  - /run
  - /tmp
entrypoint
Override the default entrypoint.

entrypoint: /code/entrypoint.sh
The entrypoint can also be a list, in a manner similar to dockerfile:

entrypoint:
    - php
    - -d
    - zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20100525/xdebug.so
    - -d
    - memory_limit=-1
    - vendor/bin/phpunit
env_file
Add environment variables from a file. Can be a single value or a list.

If you have specified a Compose file with docker-compose -f FILE, paths in env_file are relative to the directory that file is in.

Environment variables specified in environment override these values.

env_file: .env  
env_file:
  - ./common.env
  - ./apps/web.env
  - /opt/secrets.env
Compose ожидает что каждая строка в env файле будет в формате VAR=VAL. Строки начинающиеся с # (например, комментарии) игнорируются также как и пустые строки.

# Set Rails/Rack environment
RACK_ENV=development
Note: If your service specifies a build option, variables defined in environment files will not be automatically visible during the build. Use the args sub-option of build to define build-time environment variables.

environment
Add environment variables. You can use either an array or a dictionary. Any boolean values; true, false, yes no, need to be enclosed in quotes to ensure they are not converted to True or False by the YML parser.

Environment variables with only a key are resolved to their values on the machine Compose is running on, which can be helpful for secret or host-specific values.

environment:
  RACK_ENV: development
  SHOW: 'true'
  SESSION_SECRET:

environment:
  - RACK_ENV=development
  - SHOW=true
  - SESSION_SECRET
Note: If your service specifies a build option, variables defined in environment will not be automatically visible during the build. Use the args sub-option of build to define build-time environment variables.

expose
Expose ports without publishing them to the host machine - they’ll only be accessible to linked services. Only the internal port can be specified.

expose:
 - "3000"
 - "8000"
extends
Extend another service, in the current file or another, optionally overriding configuration.

You can use extends on any service together with other configuration keys. The extends value must be a dictionary defined with a required service and an optional file key.

extends:
  file: common.yml
  service: webapp
The service the name of the service being extended, for example web or database. The file is the location of a Compose configuration file defining that service.

If you omit the file Compose looks for the service configuration in the current file. The file value can be an absolute or relative path. If you specify a relative path, Compose treats it as relative to the location of the current file.

You can extend a service that itself extends another. You can extend indefinitely. Compose does not support circular references and docker-compose returns an error if it encounters one.

For more on extends, see the the extends documentation.

external_links
Link to containers started outside this docker-compose.yml or even outside of Compose, especially for containers that provide shared or common services. external_links follow semantics similar to links when specifying both the container name and the link alias (CONTAINER:ALIAS).

external_links:
 - redis_1
 - project_db_1:mysql
 - project_db_1:postgresql
Note: If you’re using the version 2 file format, the externally-created containers must be connected to at least one of the same networks as the service which is linking to them.

extra_hosts
Add hostname mappings. Use the same values as the docker client --add-host parameter.

extra_hosts:
 - "somehost:162.242.195.82"
 - "otherhost:50.31.209.229"
An entry with the ip address and hostname will be created in /etc/hosts inside containers for this service, e.g:

162.242.195.82  somehost
50.31.209.229   otherhost
image
Specify the image to start the container from. Can either be a repository/tag or a partial image ID.

image: redis
image: ubuntu:14.04
image: tutum/influxdb
image: example-registry.com:4000/postgresql
image: a4bc65fd
If the image does not exist, Compose attempts to pull it, unless you have also specified build, in which case it builds it using the specified options and tags it with the specified tag.

Note: In the version 1 file format, using build together with image is not allowed. Attempting to do so results in an error.

labels
Add metadata to containers using Docker labels. You can use either an array or a dictionary.

It’s recommended that you use reverse-DNS notation to prevent your labels from conflicting with those used by other software.

labels:
  com.example.description: "Accounting webapp"
  com.example.department: "Finance"
  com.example.label-with-empty-value: ""

labels:
  - "com.example.description=Accounting webapp"
  - "com.example.department=Finance"
  - "com.example.label-with-empty-value"
links
Link to containers in another service. Either specify both the service name and a link alias (SERVICE:ALIAS), or just the service name.

web:
  links:
   - db
   - db:database
   - redis
Containers for the linked service will be reachable at a hostname identical to the alias, or the service name if no alias was specified.

Links also express dependency between services in the same way as depends_on, so they determine the order of service startup.

Note: If you define both links and networks, services with links between them must share at least one network in common in order to communicate.

logging
Version 2 file format only. In version 1, use log_driver and log_opt.

Logging configuration for the service.

logging:
  driver: syslog
  options:
    syslog-address: "tcp://192.168.0.42:123"
The driver name specifies a logging driver for the service’s containers, as with the --log-driver option for docker run (documented here).

The default value is json-file.

driver: "json-file"
driver: "syslog"
driver: "none"
Note: Only the json-file driver makes the logs available directly from docker-compose up and docker-compose logs. Using any other driver will not print any logs.

Specify logging options for the logging driver with the options key, as with the --log-opt option for docker run.

Logging options are key-value pairs. An example of syslog options:

driver: "syslog"
options:
  syslog-address: "tcp://192.168.0.42:123"
log_driver
Version 1 file format only. In version 2, use logging.

Specify a log driver. The default is json-file.

log_driver: syslog
log_opt
Version 1 file format only. In version 2, use logging.

Specify logging options as key-value pairs. An example of syslog options:

log_opt:
  syslog-address: "tcp://192.168.0.42:123"
net
Version 1 file format only. In version 2, use network_mode.

Network mode. Use the same values as the docker client --net parameter. The container:... form can take a service name instead of a container name or id.

net: "bridge"
net: "host"
net: "none"
net: "container:[service name or container name/id]"
network_mode
Version 2 file format only. In version 1, use net.

Network mode. Use the same values as the docker client --net parameter, plus the special form service:[service name].

network_mode: "bridge"
network_mode: "host"
network_mode: "none"
network_mode: "service:[service name]"
network_mode: "container:[container name/id]"
networks
Version 2 file format only. In version 1, use net.

Networks to join, referencing entries under the top-level networks key.

services:
  some-service:
    networks:
     - some-network
     - other-network
aliases
Aliases (alternative hostnames) for this service on the network. Other containers on the same network can use either the service name or this alias to connect to one of the service’s containers.

Since aliases is network-scoped, the same service can have different aliases on different networks.

Note: A network-wide alias can be shared by multiple containers, and even by multiple services. If it is, then exactly which container the name will resolve to is not guaranteed.

The general format is shown here.

services:
  some-service:
    networks:
      some-network:
        aliases:
         - alias1
         - alias3
      other-network:
        aliases:
         - alias2
In the example below, three services are provided (web, worker, and db), along with two networks (new and legacy). The db service is reachable at the hostname db or database on the new network, and at db or mysql on the legacy network.

version: '2'

services:
  web:
    build: ./web
    networks:
      - new

  worker:
    build: ./worker
    networks:
    - legacy

  db:
    image: mysql
    networks:
      new:
        aliases:
          - database
      legacy:
        aliases:
          - mysql

networks:
  new:
  legacy:
ipv4_address, ipv6_address
Specify a static IP address for containers for this service when joining the network.

The corresponding network configuration in the top-level networks section must have an ipam block with subnet and gateway configurations covering each static address. If IPv6 addressing is desired, the com.docker.network.enable_ipv6 driver option must be set to true.

An example:

version: '2'

services:
  app:
    image: busybox
    command: ifconfig
    networks:
      app_net:
        ipv4_address: 172.16.238.10
        ipv6_address: 2001:3984:3989::10

networks:
  app_net:
    driver: bridge
    driver_opts:
      com.docker.network.enable_ipv6: "true"
    ipam:
      driver: default
      config:
      - subnet: 172.16.238.0/24
        gateway: 172.16.238.1
      - subnet: 2001:3984:3989::/64
        gateway: 2001:3984:3989::1
pid
pid: "host"
Sets the PID mode to the host PID mode. This turns on sharing between container and the host operating system the PID address space. Containers launched with this flag will be able to access and manipulate other containers in the bare-metal machine’s namespace and vise-versa.

ports
Expose ports. Either specify both ports (HOST:CONTAINER), or just the container port (a random host port will be chosen).

Note: When mapping ports in the HOST:CONTAINER format, you may experience erroneous results when using a container port lower than 60, because YAML will parse numbers in the format xx:yy as sexagesimal (base 60). For this reason, we recommend always explicitly specifying your port mappings as strings.

ports:
 - "3000"
 - "3000-3005"
 - "8000:8000"
 - "9090-9091:8080-8081"
 - "49100:22"
 - "127.0.0.1:8001:8001"
 - "127.0.0.1:5000-5010:5000-5010"
security_opt
Override the default labeling scheme for each container.

security_opt:
  - label:user:USER
  - label:role:ROLE
stop_signal
Sets an alternative signal to stop the container. By default stop uses SIGTERM. Setting an alternative signal using stop_signal will cause stop to send that signal instead.

stop_signal: SIGUSR1
ulimits
Override the default ulimits for a container. You can either specify a single limit as an integer or soft/hard limits as a mapping.

ulimits:
  nproc: 65535
  nofile:
    soft: 20000
    hard: 40000
volumes, volume_driver
Mount paths or named volumes, optionally specifying a path on the host machine (HOST:CONTAINER), or an access mode (HOST:CONTAINER:ro). For version 2 files, named volumes need to be specified with the top-level volumes key. When using version 1, the Docker Engine will create the named volume automatically if it doesn’t exist.

You can mount a relative path on the host, which will expand relative to the directory of the Compose configuration file being used. Relative paths should always begin with . or ...

volumes:
  # Just specify a path and let the Engine create a volume
  - /var/lib/mysql

  # Specify an absolute path mapping
  - /opt/data:/var/lib/mysql

  # Path on the host, relative to the Compose file
  - ./cache:/tmp/cache

  # User-relative path
  - ~/configs:/etc/configs/:ro

  # Named volume
  - datavolume:/var/lib/mysql
If you do not use a host path, you may specify a volume_driver.

volume_driver: mydriver
Note that for version 2 files, this driver will not apply to named volumes (you should use the driver option when declaring the volume instead). For version 1, both named volumes and container volumes will use the specified driver.

Note: No path expansion will be done if you have also specified a volume_driver.

See Docker Volumes and Volume Plugins for more information.

volumes_from
Mount all of the volumes from another service or container, optionally specifying read-only access (ro) or read-write (rw). If no access level is specified, then read-write will be used.

volumes_from:
 - service_name
 - service_name:ro
 - container:container_name
 - container:container_name:rw
Note: The container:... formats are only supported in the version 2 file format. In version 1, you can use container names without marking them as such:

- service_name
- service_name:ro
- container_name
- container_name:rw
cpu_shares, cpu_quota, cpuset, domainname, hostname, ipc, mac_address, mem_limit, memswap_limit, privileged, read_only, restart, shm_size, stdin_open, tty, user, working_dir
Each of these is a single value, analogous to its docker run counterpart.

cpu_shares: 73
cpu_quota: 50000
cpuset: 0,1

user: postgresql
working_dir: /code

domainname: foo.com
hostname: foo
ipc: host
mac_address: 02:42:ac:11:65:43

mem_limit: 1000000000
memswap_limit: 2000000000
privileged: true

restart: always

read_only: true
shm_size: 64M
stdin_open: true
tty: true
Volume configuration reference
While it is possible to declare volumes on the fly as part of the service declaration, this section allows you to create named volumes that can be reused across multiple services (without relying on volumes_from), and are easily retrieved and inspected using the docker command line or API. See the docker volume subcommand documentation for more information.

driver
Specify which volume driver should be used for this volume. Defaults to local. The Docker Engine will return an error if the driver is not available.

 driver: foobar
driver_opts
Specify a list of options as key-value pairs to pass to the driver for this volume. Those options are driver-dependent - consult the driver’s documentation for more information. Optional.

 driver_opts:
   foo: "bar"
   baz: 1
external
If set to true, specifies that this volume has been created outside of Compose. docker-compose up will not attempt to create it, and will raise an error if it doesn’t exist.

external cannot be used in conjunction with other volume configuration keys (driver, driver_opts).

In the example below, instead of attemping to create a volume called [projectname]_data, Compose will look for an existing volume simply called data and mount it into the db service’s containers.

version: '2'

services:
  db:
    image: postgres
    volumes:
      - data:/var/lib/postgresql/data

volumes:
  data:
    external: true
You can also specify the name of the volume separately from the name used to refer to it within the Compose file:

volumes:
  data:
    external:
      name: actual-name-of-volume
Network configuration reference
The top-level networks key lets you specify networks to be created. For a full explanation of Compose’s use of Docker networking features, see the Networking guide.

driver
Specify which driver should be used for this network.

The default driver depends on how the Docker Engine you’re using is configured, but in most instances it will be bridge on a single host and overlay on a Swarm.

The Docker Engine will return an error if the driver is not available.

driver: overlay
driver_opts
Specify a list of options as key-value pairs to pass to the driver for this network. Those options are driver-dependent - consult the driver’s documentation for more information. Optional.

  driver_opts:
    foo: "bar"
    baz: 1
ipam
Specify custom IPAM config. This is an object with several properties, each of which is optional:

driver: Custom IPAM driver, instead of the default.
config: A list with zero or more config blocks, each containing any of the following keys:
subnet: Subnet in CIDR format that represents a network segment
ip_range: Range of IPs from which to allocate container IPs
gateway: IPv4 or IPv6 gateway for the master subnet
aux_addresses: Auxiliary IPv4 or IPv6 addresses used by Network driver, as a mapping from hostname to IP
A full example:

ipam:
  driver: default
  config:
    - subnet: 172.28.0.0/16
      ip_range: 172.28.5.0/24
      gateway: 172.28.5.254
      aux_addresses:
        host1: 172.28.1.5
        host2: 172.28.1.6
        host3: 172.28.1.7
external
If set to true, specifies that this network has been created outside of Compose. docker-compose up will not attempt to create it, and will raise an error if it doesn’t exist.

external cannot be used in conjunction with other network configuration keys (driver, driver_opts, ipam).

In the example below, proxy is the gateway to the outside world. Instead of attemping to create a network called [projectname]_outside, Compose will look for an existing network simply called outside and connect the proxy service’s containers to it.

version: '2'

services:
  proxy:
    build: ./proxy
    networks:
      - outside
      - default
  app:
    build: ./app
    networks:
      - default

networks:
  outside:
    external: true
You can also specify the name of the network separately from the name used to refer to it within the Compose file:

networks:
  outside:
    external:
      name: actual-name-of-network
Версии
There are two versions of the Compose file format:

Version 1, the legacy format. This is specified by omitting a version key at the root of the YAML.
Version 2, the recommended format. This is specified with a version: '2' entry at the root of the YAML.
To move your project from version 1 to 2, see the Upgrading section.

Note: If you’re using multiple Compose files or extending services, each file must be of the same version - you cannot mix version 1 and 2 in a single project.

Several things differ depending on which version you use:

The structure and permitted configuration keys
The minimum Docker Engine version you must be running
Compose’s behaviour with regards to networking
These differences are explained below.

Version 1
Compose files that do not declare a version are considered “version 1”. In those files, all the services are declared at the root of the document.

Version 1 is supported by Compose up to 1.6.x. It will be deprecated in a future Compose release.

Version 1 files cannot declare named volumes, networks or build arguments.

Example:

web:
  build: .
  ports:
   - "5000:5000"
  volumes:
   - .:/code
  links:
   - redis
redis:
  image: redis
Version 2
Compose files using the version 2 syntax must indicate the version number at the root of the document. All services must be declared under the services key.

Version 2 files are supported by Compose 1.6.0+ and require a Docker Engine of version 1.10.0+.

Named volumes can be declared under the volumes key, and networks can be declared under the networks key.

Simple example:

version: '2'
services:
  web:
    build: .
    ports:
     - "5000:5000"
    volumes:
     - .:/code
  redis:
    image: redis
A more extended example, defining volumes and networks:

version: '2'
services:
  web:
    build: .
    ports:
     - "5000:5000"
    volumes:
     - .:/code
    networks:
      - front-tier
      - back-tier
  redis:
    image: redis
    volumes:
      - redis-data:/var/lib/redis
    networks:
      - back-tier
volumes:
  redis-data:
    driver: local
networks:
  front-tier:
    driver: bridge
  back-tier:
    driver: bridge
Upgrading
In the majority of cases, moving from version 1 to 2 is a very simple process:

Indent the whole file by one level and put a services: key at the top.
Add a version: '2' line at the top of the file.
It’s more complicated if you’re using particular configuration features:

dockerfile: This now lives under the build key:

build:
  context: .
  dockerfile: Dockerfile-alternate
log_driver, log_opt: These now live under the logging key:

logging:
  driver: syslog
  options:
    syslog-address: "tcp://192.168.0.42:123"
links with environment variables: As documented in the environment variables reference, environment variables created by links have been deprecated for some time. In the new Docker network system, they have been removed. You should either connect directly to the appropriate hostname or set the relevant environment variable yourself, using the link hostname:

web:
  links:
    - db
  environment:
    - DB_PORT=tcp://db:5432
external_links: Compose uses Docker networks when running version 2 projects, so links behave slightly differently. In particular, two containers must be connected to at least one network in common in order to communicate, even if explicitly linked together.

Either connect the external container to your app’s default network, or connect both the external container and your service’s containers to an external network.

net: This is now replaced by network_mode:

net: host    ->  network_mode: host
net: bridge  ->  network_mode: bridge
net: none    ->  network_mode: none

If you’re using net: "container:[service name]", you must now use network_mode: "service:[service name]" instead.

net: "container:web"  ->  network_mode: "service:web"

If you’re using net: "container:[container name/id]", the value does not need to change.

net: "container:cont-name"  ->  network_mode: "container:cont-name"
net: "container:abc12345"   ->  network_mode: "container:abc12345"
volumes with named volumes: these must now be explicitly declared in a top-level volumes section of your Compose file. If a service mounts a named volume called data, you must declare a data volume in your top-level volumes section. The whole file might look like this:

version: '2'
services:
  db:
    image: postgres
    volumes:
      - data:/var/lib/postgresql/data
volumes:
  data: {}

By default, Compose creates a volume whose name is prefixed with your project name. If you want it to just be called data, declare it as external:

volumes:
  data:
    external: true
Variable substitution
Your configuration options can contain environment variables. Compose uses the variable values from the shell environment in which docker-compose is run. For example, suppose the shell contains EXTERNAL_PORT=8000 and you supply this configuration:

web:
  build: .
  ports:
    - "${EXTERNAL_PORT}:5000"
When you run docker-compose up with this configuration, Compose looks for the EXTERNAL_PORT environment variable in the shell and substitutes its value in. In this example, Compose resolves the port mapping to "8000:5000" before creating the web container.

If an environment variable is not set, Compose substitutes with an empty string. In the example above, if EXTERNAL_PORT is not set, the value for the port mapping is :5000 (which is of course an invalid port mapping, and will result in an error when attempting to create the container).

Both $VARIABLE and ${VARIABLE} syntax are supported. Extended shell-style features, such as ${VARIABLE-default} and ${VARIABLE/foo/bar}, are not supported.

You can use a $$ (double-dollar sign) when your configuration needs a literal dollar sign. This also prevents Compose from interpolating a value, so a $$ allows you to refer to environment variables that you don’t want processed by Compose.

web:
  build: .
  command: "$$VAR_NOT_INTERPOLATED_BY_COMPOSE"
If you forget and use a single dollar sign ($), Compose interprets the value as an environment variable and will warn you:

The VAR_NOT_INTERPOLATED_BY_COMPOSE is not set. Substituting an empty string.
