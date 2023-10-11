declare -A Q_DECK=(
  [?/config]="$HOME/.kube/config"
  [?/context]="test-ctx"

  [dev/namespace]="dev-ns"
  [dev/context]="dev-ctx"

  [test/namespace]="test-ns"

  [hotfix/namespace]="hotfix-ns"

  [alt/namespace]="alternative-ns"

  [prod/context]="prod-ctx"
)

declare -A Q_SQUAD=(
  [app]="app.kubernetes.io/name || in (backend, frontend)"
  [backend]="app.kubernetes.io/name=backend"
  [frontend]="app.kubernetes.io/name=frontend"
  [java]="language=java"
)
