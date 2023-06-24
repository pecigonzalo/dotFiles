create:
	k3d cluster create --config k3d.yaml

remove:
	k3d cluster delete --all

clean:
	sudo rm -rf ~/.k3d/storage/*

get-token:
	kubectl -n kubernetes-dashboard create token admin-user
