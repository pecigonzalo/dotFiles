create:
	k3d cluster create \
	--agents=2 \
	-p8080:80@loadbalancer \
	-p8443:443@loadbalancer \
	-v ~/.k3d/storage:/var/lib/rancher/k3s/storage \
	-v ~/.k3d/registries.yaml:/etc/rancher/k3s/registries.yaml \
	-v ~/.k3d/manifests/:/var/lib/rancher/k3s/server/manifests/mounted \
	--k3s-server-arg "--no-deploy=traefik" \
	--switch-context --wait

	docker network connect --alias registry.local k3d-k3s-default local-docker-registry || true

remove:
	docker network disconnect k3d-k3s-default local-docker-registry
	k3d cluster delete --all

clean:
	sudo rm -rf ~/.k3d/storage/*

get-token:
	kubectl -n kubernetes-dashboard describe secret admin-user-token | grep '^token'
