PACKAGES=yarn elm@0.19.0-bugfix2 create-elm-app@3.0.2 elm-github-install node-sass gh-pages@1.0.0 elm-test
YARN=/usr/bin/env yarn

STYLESHEET=public/css/stylesheet.css


install: init elmdeps css

init:
	/usr/bin/env npm install $(PACKAGES)

elmdeps: init
	$(YARN) elm-github-install

css:
	rm $(STYLESHEET)
	$(YARN) node-sass --output-style compressed scss/custom.scss > $(STYLESHEET)
	
start:
	$(YARN) elm-app start

build: FORCE
	#PUBLIC_URL=./ $(YARN) elm-app build
	$(YARN) elm-app build

deploy: build
	$(YARN) gh-pages -d build

test: FORCE
	$(YARN) elm-test

FORCE: ;
