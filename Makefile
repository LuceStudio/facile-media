network:
	docker network inspect facile >/dev/null || docker network create --driver bridge facile

prod:
	make network
	docker-compose up

dev:
	make network
	docker-compose -f docker-compose.dev.yml up

build:
	docker build --tag=facile-media .

tag:
	docker tag facile-media lucestudio/facile-media:v$(v) .

push:
	docker push lucestudio/facile:tagname:v$(v)

cluster:
	gcloud container clusters create facile --num-nodes=2

get-cluster:
	gcloud container clusters get-credentials facile

deploy:
	kubectl run facile --image=gcr.io/luce-studio-site/facile:v$(v) --port 8000

roll-up:
	kubectl set facile deployment/facile facile=gcr.io/luce-studio-site/facile:v$(v)

expose:
	kubectl expose deployment facile --type=LoadBalancer --port 80 --target-port 8000

service:
	kubectl get service