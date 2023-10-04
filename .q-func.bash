# =========================================================================
#
# q as kubectl
#
# Copyright 2023 Ildar Shaimordanov
# MIT License
#
# =========================================================================

qq() {
	Q_DEBUG=1 q "$@"
}

# =========================================================================

q() {
	[ $# -gt 0 ] || {
		echo "Usage: q DECK [SQUAD] [watch|...]"
		return
	}

	# DECK validation

	: "${1:?Deck name required}"

	local cfg
	local ctx
	local ns

	declare -p Q_CONFIG >/dev/null 2>&1 \
	&& [ -n "${!Q_CONFIG[*]}" ] \
	&& : "${cfg:=${Q_CONFIG[$1]-${Q_CONFIG[?]:?Bad deck: $1}}}"

	declare -p Q_CTX >/dev/null 2>&1 \
	&& [ -n "${!Q_CTX[*]}" ] \
	&& : "${ctx:=${Q_CTX[$1]-${Q_CTX[?]:?Bad deck: $1}}}"

	declare -p Q_NS >/dev/null 2>&1 \
	&& [ -n "${!Q_NS[*]}" ] \
	&& : "${ns:=${Q_NS[$1]-${Q_NS[?]:?Bad deck: $1}}}"

	[ -n "${cfg:+$cfg}" ] \
	|| [ -n "${ctx:+$ctx}" ] \
	|| [ -n "${ns:+$ns}" ] \
	|| {
		echo "None part is specified for DECK='$1'" >&2
		return 1
	}

	# SQUAD validation

	local sel

	# The pointer to the next parameter following the mandatory DECK
	# and the optional SQUAD.
	local q_next=2

	# q DECK [SQUAD] ...
	# kubectl DECK [SQUAD] ...
	[ $# -ge 2 ] \
	&& [ -n "$2" ] \
	&& [ "$2" != "watch" ] \
	&& declare -p Q_SEL >/dev/null 2>&1 \
	&& [ -n "${Q_SEL[$2]:+${Q_SEL[$2]}}" ] \
	&& q_next=3 \
	&& set -- "$1" --selector="${Q_SEL[$2]}" "${@:3}"

	if [ $# -lt $q_next ]
	then
		# Special use 1: show pods
		# q DECK [SQUAD]
		# kubectl DECK [SQUAD] get pods
		set -- "$@" get pods
	elif [ $# -eq $q_next ] && [ "${@:$#}" = "watch" ]
	then
		# Special use 2: show pods in watch mode
		# q DECK [SQUAD] watch
		# kubectl DECK [SQUAD] get pods --watch
		set -- "${@:1:$#-1}" get pods --watch
	fi

	${Q_DEBUG:+echo} kubectl \
	${cfg:+--kubeconfig="$cfg"} \
	${ctx:+--context="$ctx"} \
	${ns:+--namespace="$ns"} \
	"${@:2}"
}

# =========================================================================

# EOF
