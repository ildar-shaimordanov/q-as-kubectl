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
		echo "Usage: q DECK [SEL] [watch|...]"
		return
	}

	: "${1:?Deck name required}"

	local cfg
	local ctx
	local ns
	local sel

	declare -p Q_CONFIG >/dev/null 2>&1 \
	&& : "${cfg:=${Q_CONFIG[$1]-${Q_CONFIG[?]?Bad deck: $1}}}"

	declare -p Q_CTX >/dev/null 2>&1 \
	&& : "${ctx=${Q_CTX[$1]-${Q_CTX[?]?Bad deck: $1}}}"

	declare -p Q_NS >/dev/null 2>&1 \
	&& : "${ns=${Q_NS[$1]-${Q_NS[?]?Bad deck: $1}}}"

	# The pointer to the next parameter following the mandatory DECK
	# and the optional SEL.
	local k_next=2

	# q DECK SEL ...
	# kubectl --context=CTX --namespace=NS --selector=SELECTOR ...
	[ -n "$2" ] && [ "$2" != "watch" ] && [ -n "${Q_SEL[$2]}" ] \
	&& k_next=3 \
	&& set -- "$1" --selector="${Q_SEL[$2]}" "${@:3}"

	if [ $# -lt $k_next ]
	then
		# q DECK [SEL]
		# kubectl DECK [SEL] get pods
		set -- "$@" get pods
	elif [ $# -eq $k_next ] && [ "${@:$#}" = "watch" ]
	then
		# q DECK [SEL] watch
		# kubectl DECK [SEL] get pods --watch
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
