PACKAGES=elm@0.18.0-exp5 create-elm-app@1.10.4 elm-github-install node-sass gh-pages@1.0.0
NPX=/usr/bin/env npx

STYLESHEET=public/css/stylesheet.css


install: init elmdeps css

init:
	/usr/bin/env npm install $(PACKAGES)

elmdeps: init
	$(NPX) elm-github-install

css: init
	rm $(STYLESHEET)
	$(NPX) node-sass --output-style compressed public/scss/custom.scss > $(STYLESHEET)
	
start:
	$(NPX) elm-app start

build: FORCE
	#PUBLIC_URL=./ $(NPX) elm-app build
	$(NPX) elm-app build

deploy: build
	$(NPX) gh-pages -d build

FORCE: ;
