all: build

build:
	@docker build --tag=jcenzano/loadtestv1 .