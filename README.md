<!-- toc-begin -->
# Table of Content
* [SYNOPSIS](#synopsis)
* [DESCRIPTION](#description)
  * [Terminology](#terminology)
* [USAGE](#usage)
* [FUNCTIONS](#functions)
  * [`q`](#q)
  * [`qq`](#qq)
  * [Examples](#examples)
* [ENVIRONMENT](#environment)
  * [DECK variables](#deck-variables)
    * [`Q_CONFIG`](#q_config)
    * [`Q_CTX`](#q_ctx)
    * [`Q_NS`](#q_ns)
  * [SQUAD variables](#squad-variables)
    * [`Q_SQUAD`](#q_squad)
  * [Other variables](#other-variables)
    * [`Q_DEBUG`](#q_debug)
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

The commands are addressed to squads or the whole crew and executed on their basic places. The routine commands are short as less as possible, some routine commands can have additional options and others can be more or less extended.

*DECK* is the place where something happens and is executed. It can consist of few things. Reverting to the more convenient words, there are kubeconfig file, context and namespace.

*SQUAD* is the team executing commands which can be routine or some special. Again in k8s words, squad is selector.

# USAGE

Source the scripts in `.bashrc` or your script as follows:

    [ -f ~/.q-decl.bash ] && . ~/.q-decl.bash
    [ -f ~/.q-func.bash ] && . ~/.q-func.bash

The first file contains series of definitions for SQUAD and DECK. The second file declares the functions.

Also you would like to add the following commands into your `.bashrc`.

    complete -F __start_kubectl q
    complete -F __start_kubectl qq

# FUNCTIONS

There are two bash functions: the one is to see what will be executed and the another one is to execute commands. Everything you need is configured in special environment variables once and used a lot.

## `q`

Execute the command

    q DECK [SQUAD] [watch|...]

## `qq`

Show what is expected to be executed

    qq DECK [SQUAD] [watch|...]

There are few cases when some parameters are missing and what does it mean.

## Examples

Each example below consists of two parts: the first line is the command to be typed and the rest of the example is the command which will be really executed. Optional or omitted parameters are shown in the square brackets.

Everything written for `q` is true for `qq` as well.

Common use: do something

    q DECK [SQUAD} ...
    kubectl \
        [--kubeconfig=CONFIG] [--context=CTX] [--namespace=NS] \
        [--selector=SELECTOR] \
        ...

Show pods

    q DECK [SQUAD]
    kubectl \
        [--kubeconfig=CONFIG] [--context=CTX] [--namespace=NS] \
        [--selector=SELECTOR] \
        get pods

Show pods in the watch mode

    q DECK [SQUAD] watch
    kubectl \
        [--kubeconfig=CONFIG] [--context=CTX] [--namespace=NS] \
        [--selector=SELECTOR] \
        get pods --watch

# ENVIRONMENT

## DECK variables

DECK variables may have the special key `[?]` implying any deck name, when the typed deck name is not presented.

### `Q_CONFIG`

The associative array for the kubeconfig files with the keys as the deck names and the values as the kubeconfig files.

### `Q_CTX`

The same as above but for the contexts.

### `Q_NS`

The same as above but for the namespaces.

## SQUAD variables

### `Q_SQUAD`

The associative array for the selectors with the keys as the selector short names and the values as the selectors itself.

The `Q_SQUAD` variable doesn't support the special `[?]` key.

The `watch` word is reserved for the special command and cannot be used as a squad name.

## Other variables

### `Q_DEBUG`

Any non-empty value means to show the command, not to execute. It is internally used variable. You don't need to set it explicitly. Instead, use `qq`.

# LICENSE

Copyright 2023 Ildar Shaimordanov

    MIT
