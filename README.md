<!-- toc-begin -->
# Table of Content
* [SYNOPSIS](#synopsis)
* [DESCRIPTION](#description)
  * [Terminology](#terminology)
* [REQUIREMENTS](#requirements)
* [USAGE](#usage)
* [FUNCTIONS](#functions)
  * [`q`](#q)
  * [`qq`](#qq)
  * [`qcheck`](#qcheck)
  * [Examples](#examples)
* [ENVIRONMENT](#environment)
  * [`Q_DECK` variable](#q_deck-variable)
  * [`Q_SQUAD` variable](#q_squad-variable)
  * [Other variables](#other-variables)
    * [`Q_DEBUG`](#q_debug)
* [SEE ALSO](#see-also)
* [LICENSE](#license)
<!-- toc-end -->

# SYNOPSIS

    q DECK [SQUAD] [watch|...]

# DESCRIPTION

Consider youself sitting on some particular host where you spend a lot of time working with k8s instances and performing similar commands for different environments. For example, the development bench, few test beds and the production environment. Any of them can be configured to be living on different places, hosts and under different namespaces.

Aliasing is good approach for the first time. But times go and you have to invent and use more aliases and also have to invent some system for naming and to remember all of them.

The current project doesn't bring something revolutionarily new. It gives you yet another way to type less for frequently used commands and their options as it is possible.

## Terminology

Keeping use a marine terminology, let's introduce two new words.

The commands are addressed to squads or the whole crew and executed on decks, their basic places. The routine commands are short as less as possible, some routine commands can have additional options and others can be more or less extended.

*DECK* is a place where something happens and is executed. It can consist of few things. Reverting to the more convenient words, there are kubeconfig file, context and namespace.

*SQUAD* is a team executing commands which can be routine or some special. Again in k8s words, squad is a selector.

# REQUIREMENTS

All this stuff was developed under Cygwin 3.1.7. Further it was probed with success under modern Linux shipped with GNU Awk 4.0.2 and GNU Bash 4.2.46. Everything is working fine as expected.

* GNU Bash 4+
* GNU Awk 5+

# USAGE

Source these files in your `~/.bashrc` file:

    [ -f ~/.q-decl.bash ] && . ~/.q-decl.bash
    [ -f ~/.q-func.bash ] && . ~/.q-func.bash

The first file contains series of definitions for SQUAD and DECK. The second file declares the functions that you will use.

Also you would like to enable a command completion adding the following commands into your `.bashrc`.

    complete -F __start_kubectl q
    complete -F __start_kubectl qq

In addition there is `qcheck` function giving you another way to declare your decks and squads. Just edit the file `~/.q-decl.ini` following the given recommendations as you need and run the command:

    qcheck -u

Specifying another file you can alternate an input file.

# FUNCTIONS

There are three bash functions: the one is to see what will be executed and the another one is to execute commands. Everything you need is configured in special environment variables once and used a lot. The last one is used to check and redeclare settings.

## `q`

Execute a command

    q DECK [SQUAD] [watch|...]

## `qq`

Show what is expected to be executed

    qq DECK [SQUAD] [watch|...]

## `qcheck`

Parse a given file (or `~/.q-decl.ini`, if nothing specified) and update settings with the `-u` option writing results to `~/.q-decl.bash`.

Be careful using this function. It overwrites your settings added manually.

    qcheck [-u] [FILE]


## Examples

There are few cases when some parameters are missing and what does it mean.

Each example below consists of two parts: the first line is the command to be typed and the rest of the example is the command which will be really executed. Optional or omitted parameters are shown in the square brackets.

Everything written for `q` is true for `qq` as well.

Common use: do something

    q DECK [SQUAD} ...
    kubectl \
        [--kubeconfig=CONFIG] [--context=CONTEXT] [--namespace=NAMESPACE] \
        [--selector=SELECTOR] \
        ...

Special use 1: show pods

    q DECK [SQUAD]
    kubectl \
        [--kubeconfig=CONFIG] [--context=CONTEXT] [--namespace=NAMESPACE] \
        [--selector=SELECTOR] \
        get pods

Special use 2: show pods in the watch mode

    q DECK [SQUAD] watch
    kubectl \
        [--kubeconfig=CONFIG] [--context=CONTEXT] [--namespace=NAMESPACE] \
        [--selector=SELECTOR] \
        get pods --watch

# ENVIRONMENT

## `Q_DECK` variable

The `Q_DECK` variable describes the place where kubectl commands is supposed to be executed. In its guts, it is the associative array in the very common form:

    declare -A Q_DECK=(
        [name/key]=value
    )

where `name` stands for a deck name, `key` is one of `config`, `context` and `namespace` and `value` is something for `--kubeconfig`, `--context` and `--namespace` options, respectively.

## `Q_SQUAD` variable

The `Q_SQUAD` variable is simpler than `Q_DECK`. Generally, it has the following form:

    declare -A Q_SQUAD=(
        [key]=value
    )

with `key` as a squad name and `value` as a value for a `--selector` option.

**NOTE**: The `watch` word is reserved for the special command and cannot be used as the squad name.

## Other variables

### `Q_DEBUG`

Any non-empty value means to show the command, not to execute. It is internally used variable. You don't need to set it explicitly. Instead, use `qq`.

# SEE ALSO

Probably some of the projects below could have some relationship to this project.

* https://github.com/Dbz/kube-aliases
* https://github.com/aabouzaid/kubech
* https://github.com/ahmetb/kubectx

# LICENSE

Copyright 2023 Ildar Shaimordanov

    MIT
