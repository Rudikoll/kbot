graph TD

A[Push develop] --> B[GitHub Actions]
B --> C[Build Docker]
C --> D[Push ghcr.io]
D --> E[Update Helm]

E --> F[Git commit]
F --> G[ArgoCD]

G --> H[Kubernetes]
H --> I[Bot Running]
