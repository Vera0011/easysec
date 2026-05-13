# EasySec - Español
## Introducción
EasySec es un repositorio el cual incluye múltiples roles, documentación y herramientas con el objetivo de ayudar a las PYMEs con la aplicación de medidas de seguridad en sus propias empresas, además de fomentar ejercicios de pentesting y red teaming. Este archivo será usado como índice, para poder revisar y analizar las herramientas y documentación disponibles de manera más fácil. Las herramientas y flujos implementados son idempotentes. Esto significa que sin importar la cantidad de veces ejecutado, el resultado será siempre el mismo.

## Disclaimer y contribuciones
Este proyecto es completamente open source, creado por Vera y con licencia [MIT](./../../LICENSE.md). Cualquier aporte, sugerencia o implementación puede ser pedido en la sección de "Pull requests".

## Configuración
Hay dos scripts disponibles en [`scripts/`](../../scripts/):
- **execute.sh**: Interfaz de línea de comandos interactiva para seleccionar y ejecutar módulos o flujos de trabajo específicos en Vagrant
- **test.sh**: Ejecuta todos los módulos y flujos de trabajo en Vagrant; se utiliza para validar la configuración

### Entorno
La configuración recomendada utiliza [UV](https://github.com/astral-sh/uv) para la gestión del entorno de Python. Estas son las acciones recomendadas:
```bash
uv python pin                       # Utiliza el archivo .python-version y selecciona la versión específica del intérprete
uv venv .venv                       # Crea el entorno virtual
source .venv/bin/activate           # Activa el entorno virtual
uv pip install -r requirements.txt  # Instala las dependencias necesarias
```

### Ejecución
El script se puede ejecutar (desde la ruta raíz del proyecto) con:
```bash
./script/execute.sh
```
> [!NOTE]
> Asegúrate de que Vagrant y VirtualBox estén instalados y en ejecución antes de ejecutar cualquier script

## Roadmap
Según cómo vaya el proyecto, estas son las herramientas y entornos que me gustaría implementar:
- [X] Proxychains + Tor
- [X] Lynis
- [X] Grype
- [X] Syft
- [X] Grant
- [X] Keycloak
- [ ] OpenLDAP
- [ ] Netmaker
- [ ] Pomerium
- [ ] Netbird
- [ ] MISP
- [ ] TheHive
- [ ] Suricata
- [ ] Nftables
- [ ] Iptables
- [ ] UFW
- [ ] Teleport
- [ ] Jenkins
- [ ] Graylog
- [ ] OpenSCAP
- [ ] InSpec
- [ ] OpenVAS
- [ ] Nessus
- [ ] Trivy
- [ ] Entorno SOC - Wazuh
- [ ] Entorno SOAR - Shuffle
- [ ] Bandit
- [ ] HashiCorp Vault
- [ ] Checkov
- [ ] Trivy
- [ ] Gitleaks
- [ ] Betterleaks
- [ ] Fail2ban
- [ ] Aikido Safe-chain
- [ ] ScoutSuite
- [ ] NixOS - Basado en [Sécurix](https://github.com/cloud-gouv/securix)
- [ ] Entorno Red Teaming - Herramientas necesarias

## Recursos
### Red team
#### Herramientas
- Proxychains - Un software para usar proxies de manera más cómoda. Información sobre la implementación [aquí](./tools/red/proxychains.md)

### Blue team
#### Herramientas
- Lynis - Un software para analizar y generar reportes (en base a ciertas directrices) de máquinas y contenedores. Información sobre la implementación [aquí](./tools/blue/lynis.md)
- Grype - Un software para analizar y generar reportes de máquinas, contenedores y repositorios. Información sobre la implementación [aquí](./tools/blue/grype.md)
- Syft - Un software para generar SBOMs. Información sobre la implementación [aquí](./tools/blue/syft.md)
- Grant - Un software para analizar las licencias de las dependencias empleadas. Información sobre la implementación [aquí](./tools/blue/grant.md)
- SSL - Una conjunto de herramientas que trabajan en conjunto para generar certificados SSL para dominios y usando proveedores DNS. Información sobre la implementación [aquí](./tools/blue/ssl.md)
- PostgreSQL - Instalación y configuración de la base de datos. Información sobre la implementación [aquí](./tools/blue/postgresql.md)

#### Workflows
- Anchore - Workflow que incluye varias herramientas para analizar dependencias y licencias. Información sobre la implementación [aquí](./workflows/blue/anchore.md)