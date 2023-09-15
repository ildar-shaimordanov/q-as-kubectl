# SYNOPSIS

    q DECK [SEL] [watch|...]

# DESCRIPTION

Consider youself sitting on some particular host where you spend a lot of time working with k8s instances and performing similar commands for different environments. For example, the development bench, few test beds and the production environment. Any of them can be configured to be living on different places, hosts and under different namespaces.

Aliasing is good approach for the first time. But times go and you have to invent and use more aliases and also have to invent some system for naming and to remember all of them.

The current project doesn't bring something revolutionarily new. It gives you yet another way to type less for frequently used commands and their options as it is possible.

## Terminology

*SEL* is the shorthand for selector, well-known term in k8s. The selector itself can be too long and is not convenient to remember. Technically, SEL is defined as a key for the selector value and stored in the special environment variable.

*DECK* is new word. It stands as a combination for a configuration file, context and namespace. It is stored as three separate variables similar to SEL.

# USAGE

Source the scripts in `.bashrc` or your script as follows:

    [ -f ~/.q-decl.bash ] && . ~/.q-decl.bash
    [ -f ~/.q-func.bash ] && . ~/.q-func.bash

The first file contains series of definitions for SEL and DECK. The second file declares the functions.

Also you would like to add the following commands into your `.bashrc`.

    complete -F __start_kubectl q
    complete -F __start_kubectl qq

# FUNCTIONS

There are two bash functions: the one is to see what will be executed and the another one is to execute commands. Everything you need is configured in special environment variables once and used a lot.

## `q`

Execute the command

    q DECK [SEL] [watch|...]

## `qq`

Show what is expected to be executed

    qq DECK [SEL] [watch|...]

There are few cases when some parameters are missing and what does it mean.

## Examples

Each example below consists of two parts: the first line is the command to be typed and the rest of the example is the command which will be really executed. Optional or omitted parameters are shown in the square brackets.

Everything written for `q` is true for `qq` as well.

Common use: do something

    q DECK [SEL} ...
    kubectl \
        [--kubeconfig=CONFIG] [--context=CTX] [--namespace=NS] \
        [--selector=SELECTOR] \
        ...

Show pods

    q DECK [SEL]
    kubectl \
        [--kubeconfig=CONFIG] [--context=CTX] [--namespace=NS] \
        [--selector=SELECTOR] \
        get pods

Show pods in the watch mode

    q DECK [SEL] watch
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

## SEL variables

### `Q_SEL`

The associative array for the selectors with the keys as the selector short names and the values as the selectors itself.

## Other variables

### `Q_DEBUG`

Any non-empty value means to show the command, not to execute. It is internally used variable. You don't need to set it explicitly. Instead, use `qq`.

# LICENSE

Copyright 2023 Ildar Shaimordanov

    MIT
