# GlOM

Or, *G*as*l*ands *O*ffline *M*anager, a fully offline Gaslands (https://gaslands.com/) vehicle squad manager.

# Dependecies

This this needs [Elm](http://elm-lang.org/) installed. Installing `create-elm-app` also helps.

# Development

1. `git clone --recurse-submodules https://github.com/milogert/glom`
2. `cd glom`
3. `make install`
4. `make start`
4. Navigate to `http://localhost:3000`.

# Building for production

1. Steps 1-3 in Development.
2. `make build`

# Deploying

1. Steps 1-3 in Development.
2. `make deploy`

# Hosting

A build of this application is located at https://milogert.github.io/glom/. Since the application is written in Elm it has PWA support so you can install a totally offline version on your phone.
