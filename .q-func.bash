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
		echo "Usage: q DECK [SQUAD] [watch|...]" >&2
		return 1
	}

	# DECK validation

	: "${1:?Deck name required}"

	declare -p Q_DECK >/dev/null 2>&1 || {
		echo "No any deck found" >&2
		return 1
	}

	[ -n "${Q_DECK["$1/config"]+ok}" ] \
	|| [ -n "${Q_DECK["$1/context"]+ok}" ] \
	|| [ -n "${Q_DECK["$1/namespace"]+ok}" ] \
	|| {
		echo "Deck does not exist: '$1'" >&2
		return 1
	}

	local cfg
	local ctx
	local nsp

	cfg="${Q_DECK[$1/config]:-${Q_DECK[?/config]:-}}"
	ctx="${Q_DECK[$1/context]:-${Q_DECK[?/context]:-}}"
	nsp="${Q_DECK[$1/namespace]:-${Q_DECK[?/namespace]:-}}"

	[ -n "$cfg" ] \
	|| [ -n "$ctx" ] \
	|| [ -n "$nsp" ] \
	|| {
		echo "Deck without any equipment: '$1'" >&2
		return 1
	}

	shift

	# SQUAD validation

	local sel

	# The common use
	# q DECK [SQUAD] ...
	# kubectl DECK [SQUAD] ...

	[ -n "${1+ok}" ] \
	&& [ "$1" != "watch" ] \
	&& declare -p Q_SQUAD >/dev/null 2>&1 \
	&& [ -n "${Q_SQUAD[$1]+ok}" ] \
	&& sel="${Q_SQUAD[$1]}" \
	&& shift

	# Special cases detection and handling

	if [ $# -eq 0 ]
	then
		# The special use 1: show pods
		# q DECK [SQUAD]
		# kubectl DECK [SQUAD] get pods
		set -- get pods
	elif [ $# -eq 1 ] && [ "$1" = "watch" ]
	then
		# The special use 2: show pods in watch mode
		# q DECK [SQUAD] watch
		# kubectl DECK [SQUAD] get pods --watch
		set -- get pods --watch
	fi

	# One more trick for commands or plugins
	# q DECK [SQUAD] CMD [...]
	# kubectl CMD DECK [SQUAD] [...]

	# Options are allowed before kubectl builtin commands only. In
	# the cases when the options precede a plugin name, they are
	# immediately declined with error. Let's become a bit friendly
	# and make it configurable: enable putting the deck and squad
	# options after the first argument if it looks like a command or
	# plugin name - a string is not empty and not starting with the
	# "-" dash symbol.

	local cmd

	[ "${Q_PUT_NAME_FIRST_THEN_OPTIONS:+ok}" ] \
	&& [[ ! "$1" =~ ^- ]] \
	&& cmd="$1" \
	&& shift

	# That's the final step now -- constructing the command.

	set -- kubectl \
	${cmd:+"$cmd"} \
	${cfg:+--kubeconfig="$cfg"} \
	${ctx:+--context="$ctx"} \
	${nsp:+--namespace="$nsp"} \
	${sel:+--selector="$sel"} \
	"$@"

	# Let's run it in the subshell. It makes much simpler checking
	# if we need echoing to STDERR, when debugging is turned on.

	(
		[ "${Q_DEBUG:+ok}" ] \
		&& set -- echo "$@" \
		&& exec >&2

		"$@"
	)
}

# =========================================================================

qcheck() {
	[ "${1+$1}" = "-u" ] && {
		shift

		local qdecl

		# shellcheck disable=SC1090
		qdecl="$( qcheck "$@" )" \
		&& echo "$qdecl" > ~/.q-decl.bash \
		&& . ~/.q-decl.bash \
		&& echo "q declarations updated" >&2

		return $?
	}

	[ $# -eq 0 ] \
	&& [ -t 0 ] \
	&& set -- ~/.q-decl.ini

	awk '
# Trim whitespaces, skip empty lines and comments

{
	sub(/^\s*(#.*)?/, "");
	sub(/\s*$/, "");
	if ( ! $0 ) next;
}

# Check sections

match($0, /^\[deck\/(\?|\w+)\]/, m) {
	what = "deck";
	name = m[1];
	next;
}

$0 == "[squad]" {
	what = "squad";
	next;
}

/^\[/ {
	error = "Illegal section";
	exit;
}

# Check parameters

match($0, /^(\w+)\s*=\s*("(.*)"|(.*))/, m) {
	key = m[1];
	val = m[3] m[4];
	gsub(/\\/, "\\\\", val);
	gsub(/"/, "\\\"", val);
}

what == "deck" && key ~ /^(config|context|namespace)$/ {
	if ( key == "config" ) sub(/^~\//, "$HOME/", val);
	deck[name "/" key] = val;
	next;
}

what == "squad" {
	squad[key] = val;
	next;
}

{
	error = "Illegal parameter";
	exit;
}

# Finalize

function print_decl(name, values,    d, n, i) {
	printf "\ndeclare -A Q_%s=(\n", name;
	n = asorti(values, d);
	for (i = 1; i <= n; i++) printf "  [%s]=\"%s\"\n", d[i], values[ d[i] ];
	printf ")\n";
}

END {
	if ( error ) {
		format = "Error: %s in file %s at line %s\n%s\n";
		printf format, error, FILENAME, NR, $0 > "/dev/stderr";
		exit 1;
	}

	print "# This file was created automatically.";
	print "# DO NOT EDIT IT DIRECTLY. Instead use qcheck -u.";
	print "# The source file is " FILENAME ".";

	print_decl("DECK", deck);
	print_decl("SQUAD", squad);
}
' "$@"
}

# =========================================================================

# EOF
