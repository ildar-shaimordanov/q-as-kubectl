# =========================================================================
#
# q as kubectl
#
# =========================================================================

# Here are definitions for DECK and SEL.

# Q_CONFIG, Q_CTX and Q_NS are parts of DECK.

# Q_SEL is for SEL.

# Each variable is associative array with pairs of keys and values. The
# key is supposed to be typed for substituting the corresponding value
# in the command line.

# Empty values are applicable and mean nothing to substitute.

# DECK variables support the special key "[?]" for substituting default
# values if the typed key doesn't exist.

# SEL variable doesn't support it.

# =========================================================================

# Kubeconfig: uncomment one of two or declare your own in the same way

#declare -A Q_CONFIG=(
#	# Use the config file as it's agreed by default
#	[?]=~/.kube/config
#)

#declare -A Q_CONFIG=(
#	# Use this one to skip kubeconfig
#	[?]=''
#)

# =========================================================================

# Context

declare -A Q_CTX=(
	# Example for DEV
	[dev]='dev-ctx'

	[test]='test-ctx'
	[hf]='test-ctx'
	[alt]='test-ctx'

	# Also we could enable everything as the context name
	# [?]='test-ctx'

	# PROD has its separate context (it also can be obscure with rbac)
	[prod]='prod-ctx'
)

# =========================================================================

# Namespace

declare -A Q_NS=(
	# DEV has its own namespace
	[dev]='dev-ns'

	# Test beds have their own namespaces
	[test]='test-ns'
	[hf]='hotfix-ns'
	[alt]='alternative-ns'

	# PROD may not have public namspace but it must be specified
	[prod]=''
)

# =========================================================================

# Selectors

declare -A Q_SEL=(
	[backend]='app.kubernetes.io/name=backend'
	[frontend]='app.kubernetes.io/name=frontend'
	[java]='language=java'
)

# =========================================================================

# EOF
