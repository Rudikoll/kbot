# kbot — Telegram Bot CI/CD

Telegram-бот на Go з повністю автоматизованим CI/CD пайплайном через GitHub Actions, ghcr.io та ArgoCD на Kubernetes.

## Workflow схема

```
Developer → push → develop branch
                        │
            ┌───────────▼───────────┐
            │   GitHub Actions      │
            │                       │
            │  Build & Test         │
            │  (go build, go test)  │
            │          │            │
            │  Docker Build & Push  │──────► ghcr.io
            │  (linux/amd64)        │        kbot:v1.0.0-<sha>
            │          │            │
            │  Update Helm Chart    │
            │  (values.yaml tag)    │
            │          │            │
            │  ArgoCD Sync trigger  │
            └───────────────────────┘
                        │
                 ┌──────▼──────┐
                 │   ArgoCD    │──────► Kubernetes
                 │  (watches   │        (deploys pod)
                 │   git repo) │
                 └─────────────┘
                        │
              ┌─────────▼──────────┐
              │  Telegram Bot live │
              │  in Kubernetes     │
              └────────────────────┘
```

## Умови запуску

- **Подія:** `push` до гілки `develop`
- **Платформа:** `linux/amd64`
- **Registry:** `ghcr.io`
- **Deploy:** ArgoCD + Kubernetes

## Формат тегу образу

```
ghcr.io/<owner>/kbot:v1.0.0-<short_sha>-linux-amd64
```

Де:
- `v1.0.0` — версія з останнього git-тегу
- `<short_sha>` — 7 символів SHA коміту

## Helm chart параметри

```yaml
image:
  registry: "ghcr.io"
  repository: "<owner>/kbot"
  tag: "v1.0.0-<short_sha>"   # оновлюється автоматично
  os: linux
  arch: amd64
```

## Кроки пайплайну

### 1. Build & Push
- Checkout репозиторію
- Збірка Go-бінарника (`CGO_ENABLED=0`)
- Docker buildx для `linux/amd64`
- Push до `ghcr.io`

### 2. Update Helm
- `sed` оновлює `tag` в `helm/values.yaml`
- Автоматичний git commit & push

### 3. ArgoCD Deploy
- ArgoCD відслідковує зміни в репозиторії
- Автоматично синхронізує Helm chart в Kubernetes

## Локальний запуск

```bash
# Збірка
make build

# Збірка та push образу
make image push

# Перевірка тегу
make version

# Оновлення Helm chart
make helm-update
```

## Секрети

| Secret | Опис |
|--------|------|
| `GITHUB_TOKEN` | Автоматично надається GitHub Actions |
| `TELE_TOKEN` | Telegram Bot API токен (Kubernetes Secret) |

## Структура репозиторію

```
.
├── .github/
│   └── workflows/
│       └── cicd.yml       # GitHub Actions pipeline
├── helm/
│   ├── Chart.yaml
│   ├── values.yaml        # ← tag оновлюється автоматично
│   └── templates/
│       ├── deployment.yaml
│       └── _helpers.tpl
├── Dockerfile
├── Makefile
└── README.md
```
