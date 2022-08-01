# Kubernetes on GCP

Tutorial on [Zero-to-JupyterHub](https://zero-to-jupyterhub.readthedocs.io/).

Install `kubectl`:
```
sudo apt-get install kubectl
```

Create a cluster:
```
gcloud container clusters create \
  --machine-type n2-standard-8 \
  --num-nodes 2 \
  --zone us-west2-a \
  --cluster-version latest \
  --addons=GcePersistentDiskCsiDriver \
  lange-symposium-workshop
```
`--addons=GcePersistentDiskCsiDriver` flag enables [Compute Engine persistent disk CSI Driver](https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/gce-pd-csi-driver) required to use persistent disks with multiple users (`ReadOnlyMany` access).

If you are a collaborator that did not create the cluster, run the following to access the cluster:
```
gcloud container clusters get-credentials lange-symposium-workshop --zone us-west2-a --project lange-symposium-workshop-2022
```
`lange-symposium-workshop-2022` is the project name. 

Give your account permissions to perform all administrative actions needed.
```
kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole=cluster-admin \
  --user=huazhou@g.ucla.edu
```

Create a node pool for users (optional):
```
gcloud beta container node-pools create user-pool \
  --machine-type n1-standard-2 \
  --num-nodes 0 \
  --enable-autoscaling \
  --min-nodes 0 \
  --max-nodes 3 \
  --node-labels hub.jupyter.org/node-purpose=user \
  --node-taints hub.jupyter.org_dedicated=user:NoSchedule \
  --zone us-west2-a \
  --cluster lange-symposium-workshop
```

Install helm:
```
curl https://raw.githubusercontent.com/helm/helm/HEAD/scripts/get-helm-3 | bash
```


Create namespace:
```
kubectl create namespace jhub
```

If we use a shared dataset, create a read-only `PersistentVolume` as in the final section. 

Install JupyterHub by helm:
```
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update
helm upgrade --cleanup-on-fail \
  --install jhub-1-5-0 jupyterhub/jupyterhub \
  --namespace jhub \
  --create-namespace \
  --version 1.2.0 \
  --values config.yaml
```
Note release name cannot be numeric like 20220622 (took me hours to figure out).

List container cluster:
```
gcloud container clusters list
```

List Kubernetes service:
```
kubectl get service --namespace jhub
```

List pods:
```
kubectl get pod --namespace jhub
```

Show resource usage by pod:

```
kubectl top pod --namespace=jhub
```

And show resorce usage by node:
```
kubectl top node --namespace=jhub
```


If any changes to `config.yaml`, upgrade Kubernetes cluster by
```
helm upgrade --cleanup-on-fail \
  jhub-1-5-0 jupyterhub/jupyterhub \
  --namespace jhub \
  --version=1.2.0 \
  --values config.yaml
```

# On the day before workshop

Freeze Docker image `kose/jsm2022-julia-short-course` by a tag. Change the tag in `docker-compose.yml` and `config.yaml` from `latest` to the new tag.

Scale the cluster:
```
gcloud container clusters resize \
    <YOUR-CLUSTER-NAME> \
    --num-nodes <NEW-SIZE> \
    --zone us-west2-a
```

# Creating PVC with `ReadOnlyMany` access

Create a zonal-SSD `mimic-iv` for MIMIC IV v1.0 data.
```
gcloud compute disks create mimic-iv --size=10GB --type=pd-ssd --project=lange-symposium-workshop-2022 --zone=us-west2-a --source-snapshot=https://www.googleapis.com/compute/v1/projects/biostat-203b-2022winter/global/snapshots/mimic-iv
```

We are setting up a [persistent disk with multiple users](https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/readonlymany-disks). __The data has to be written inside a Kubernetes pod__ in order to make a clone with `ReadOnlyMany` access.

Create `PersistentVolume` from a persistent disk `mimic-iv` with name `mimic-iv-pvc`.
<https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/preexisting-pd>
```
kubectl apply -f mimic_iv_volume.yaml
```

And create a separate empty `PersistentVolume` named `mimic-iv-pvc-tmp`.
```
kubectl apply -f new-pvc.yaml
```

And create a pod named `task-pv-pod` to copy the data between two volumes:
```
kubectl apply -f simplepod.yaml
```

With this, mimic-iv disk is mounted at `/data/` and the empty volume is mounted at `/data2/`.  We copy the data from `/data/` to `/data2/`. 
```
kubectl exec -it pod/task-pv-pod --namespace jhub  -- cp -r /data/. /data2/
```

It may be desirable to remove the pod after copying the data.
```
kubectl delete pod task-pv-pod --namespace jhub
```

Then we create a `ReadOnlyMany` clone of `mimic-iv-tmp` called `mimic-iv-rom`.
```
kubectl apply -f cloning-pvc.yaml
```


Sometimes, you might have to delete and re-create some of the pods, pvs, and pvcs. If pv and pvc get stuck in `Terminating` state, do the following:

```
kubectl patch pv <pv-name> -p '{"metadata":{"finalizers":null}}' --namespace jhub
kubectl patch pvc <pvc-name> -p '{"metadata":{"finalizers":null}}'--namespace jhub
```

