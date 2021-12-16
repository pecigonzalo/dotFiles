create:
	k3d cluster create \
	--servers=1 \
	--agents=2 \
	-p8080:80@loadbalancer \
	-p8443:443@loadbalancer \
	-v ~/.k3d/storage:/var/lib/rancher/k3s/storage \
	-v ~/.k3d/registries.yaml:/etc/rancher/k3s/registries.yaml \
	-v ~/.k3d/manifests/:/var/lib/rancher/k3s/server/manifests/mounted@server[*] \
	--k3s-server-arg "--no-deploy=traefik" \
	--wait

	docker network connect k3d-k3s-default registry.local || true

remove:
	docker network disconnect k3d-k3s-default registry.local || true
	k3d cluster delete --all

registry:
	docker volume create local-registry  || true
	docker network create local-registry || true
	docker container run -d \
	--name registry.local \
	--network local-registry \
	-v local-registry:/var/lib/registry \
	--restart always \
	-p 5000:5000 \
	registry:2

clean:
	sudo rm -rf ~/.k3d/storage/*

get-token:
	kubectl -n kubernetes-dashboard describe secret admin-user-token | grep '^token'
