# AWS Lab — Project Instructions

Esta es una infraestructura como código (IaC) basada en **Terraform** diseñada para gestionar recursos de AWS de forma modular y multi-entorno.

## Arquitectura y Estructura

El proyecto se divide en capas de despliegue:

1.  **Foundation (Cimientos):** Recursos base requeridos por todo lo demás.
    *   `foundation/tfstate`: Bucket S3 y DynamoDB para el backend remoto.
    *   `foundation/networking`: VPC, subnets, gateways y endpoints.
    *   `foundation/iam`: Usuarios, grupos, roles (incluyendo OIDC para GitHub Actions). Access keys almacenadas en SSM Parameter Store.
    *   `foundation/billing`: Presupuestos y alertas de costos.
    *   `foundation/secrets`: Recursos de AWS Secrets Manager.
2.  **Modules:** Recursos reutilizables.
    *   `modules/common-tags`: Genera los tags estándar obligatorios.
    *   `modules/ssm`: Helper para escribir parámetros en SSM Parameter Store.
3.  **Projects:** Aplicaciones o servicios específicos que consumen la infraestructura base.
    *   `projects/ec2_hermes_workspace`: Workspace EC2 ARM64 (Graviton) con Docker y cloudflared.
    *   `projects/ec2_n8n`: Instancia EC2 para automatización con n8n.
    *   `projects/rds_db`: Capa de base de datos RDS.

## Comandos y Flujo de Trabajo

### Gestión de Entornos (Terraform Workspaces)
El proyecto utiliza una distinción entre módulos **GLOBALES** y **POR-ENTORNO**:

*   **Módulos GLOBALES** (`tfstate`, `iam`): Se despliegan una vez por cuenta.
    ```bash
    cd foundation/iam
    terraform init
    terraform plan
    terraform apply
    ```
*   **Módulos POR-ENTORNO** (`networking`, `billing`, `projects/*`): Utilizan workspaces (`dev`, `staging`, `prod`).
    ```bash
    cd foundation/networking
    terraform workspace select dev # o staging/prod
    terraform plan
    ```

### Scripts de Utilidad
*   `./scripts/new-project.sh <nombre>`: Crea un nuevo proyecto basado en la plantilla `projects/_template`.
*   `./scripts/cost-report.sh`: Genera reportes de costos de AWS.
*   `./scripts/tf-docs.sh`: Actualiza la documentación de los módulos automáticamente. Preserva el contenido manual (ej. sección `## Features`) que esté antes de `## Requirements` en el README existente.

## Convenciones de Desarrollo

*   **Versiones mínimas:** Terraform `>= 1.15.0`, AWS Provider `~> 6.0`.
*   **Estrategia de Git:** Trunk-Based Development. Ramas cortas (`feature/*`, `fix/*`) que se integran a `master`.
*   **Etiquetado (Tagging):** Todos los recursos deben incluir el módulo `common-tags`. Tags mandatorios: `ManagedBy`, `Owner`, `Environment`, `Project`.
*   **Backend:** Siempre usar backend remoto configurado en `foundation/tfstate`.
*   **Seguridad:**
    *   Usar roles de IAM y OIDC para CI/CD (GitHub Actions).
    *   No hardcodear credenciales; usar variables de entorno o AWS CLI configurado.

## CI/CD (GitHub Actions)
Actualmente `.github/workflows/` contiene un workflow exploratorio comentado para probar GitHub Actions y AWS OIDC. No asumir que existe una pipeline activa de Terraform para plan/apply automático hasta que se agregue un workflow productivo.

La estrategia esperada está documentada en `docs/git-strategy.md`: cambios contra `master`, planes en PR, apply automático a `dev` al merge y promoción manual a `staging`/`prod` mediante `workflow_dispatch`.

---
*Nota: Este archivo contiene instrucciones para agentes de IA que trabajen en este repositorio. Para documentación orientada a usuarios, consultar el `README.md`.*
