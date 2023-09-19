# =========================================================================
#
# q as kubectl
#
# =========================================================================

# Here are definitions for DECK and SQUAD variables.

# Q_CONFIG, Q_CTX and Q_NS are parts of DECK.

# Q_SEL is part of SQUAD.

# Each variable is an associative array with pairs of keys and values. The
# keys are the names of decks or squads that supposed to be typed for
# substitution of the corresponding values in the command line.

# Empty values are allowed and mean nothing for substitution.

# DECK variables support a special key "[?]" for substituting a default
# value for any deck name, it the typed one doesn't exist.

# SQUAD variables don't support "[?]".

# SQUAD can't have the "watch" name. It's reserved for another purpose.

# =========================================================================

# Kubeconfig

# Uncomment one of two or declare your own in the same way

declare -A Q_CONFIG=(
#	# Use the config file as it's agreed by default
#	[?]=~/.kube/config

#	# Use this one to skip kubeconfig
#	[?]=''
)

# =========================================================================

# Context

declare -A Q_CTX=(
	# Example for DEV
	[dev]='dev-ctx'

	# Example for TEST beds: they have the single context for all
	[test]='test-ctx'
	[hf]='test-ctx'
	[alt]='test-ctx'

#	# Also we can set the default value for TEST beds
#	[?]='test-ctx'

	# PROD has its separate context
	[prod]='prod-ctx'
)

# =========================================================================

# Namespace

declare -A Q_NS=(
	# DEV has its own namespace
	[dev]='dev-ns'

	# Each TEST bed has its own namespaces
	[test]='test-ns'
	[hf]='hotfix-ns'
	[alt]='alternative-ns'

	# PROD may not have public namspace but the empty value must
	# be specified
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
