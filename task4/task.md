# Task4

В рамках задания RBAC оформлен через Kubernetes `ServiceAccount` (в роли “пользователей”) и роли/привязки RBAC.
Решение разнесено на 3 отдельных скрипта:

- `task4/01-create-users.sh` \- создание “пользователей” (ServiceAccount) и нужных namespace
- `task4/02-create-roles.sh` \- создание ролей (ClusterRole/Role)
- `task4/03-bind-roles.sh` \- назначение ролей “пользователям” (bindings)

Также YAML\-манифесты лежат в `task4/manifests/`

## 1) Таблица ролей и групп пользователей

| Роль | Scope | Права роли (кратко) | Группы пользователей / кто это в решении |
|---|---|---|---|
| `platform-admin` | cluster\-wide | Полный доступ ко всем API\-ресурсам и non\-resource URL: `*/*`, все verbs; включая `namespaces`, `nodes`, `secrets`, `rbac`, `crds` и т\.\д\. | Платформенная команда/DevOps/SRE. ServiceAccount: `sa-platform-admin` в `kube-system`. |
| `cluster-viewer` | cluster\-wide | Только чтение (`get/list/watch`) всех ресурсов кластера; чтение базовых non\-resource endpoints (`/healthz`, `/readyz`, `/livez`, `/version`, `/api`, `/apis`). | Группа “только просмотр” (read\-only), аудит/наблюдение без изменений. ServiceAccount: `sa-cluster-viewer` в `kube-system`. |
| `cluster-operator` | cluster\-wide | Управление workload и базовыми ресурсами (create/update/patch/delete) для `pods`, `pods/log`, `services`, `endpoints`, `configmaps`, `events`, а также `deployments`, `replicasets`, `statefulsets`, `daemonsets`, `jobs`, `cronjobs`. Явно без доступа к `secrets`. | Группа “настройка кластера” (операторы), может конфигурировать приложения и ресурсы, но без привилегий на секреты. ServiceAccount: `sa-cluster-operator` в `kube-system`. |
| `developer` | namespace\-scoped (`apps`) | Управление ресурсами разработки в `apps`: `pods`, `pods/log`, `services`, `configmaps`, `events`, `deployments`, `replicasets` с verbs `get/list/watch/create/update/patch/delete`. Без `secrets`. | Разработчики (команда приложения) в рамках своего namespace. ServiceAccount: `sa-developer` в `apps`. |

### Комментарий про оргструктуру и разграничение по namespace
Разграничение “по оргструктуре” в текущей реализации сделано через отдельный namespace `apps` и namespace\-scoped роль `developer`.
Cluster\-wide роли применяются для платформенных/операторских задач и наблюдения.

## 2) Какие “пользователи” созданы
Созданы следующие ServiceAccount (используются как пользователи для демонстрации RBAC в Minikube):

- `kube-system/sa-platform-admin`
- `kube-system/sa-cluster-viewer`
- `kube-system/sa-cluster-operator`
- `apps/sa-developer`

Namespace `apps` создаётся отдельным шагом.

## 3) Как применить
Запускать по порядку:

1. `bash task4/01-create-users.sh`
2. `bash task4/02-create-roles.sh`
3. `bash task4/03-bind-roles.sh`
