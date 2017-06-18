# RBD and CephFS Example
First, add the client key to current namespace：
```sh
$ sed "s/CLIENT_KEY/`cat /etc/ceph/ceph-client-key`/g" client-key.yml | kubectl create -f -
$ kubectl get secrets
NAME                  TYPE                                  DATA      AGE
ceph-client-key       Opaque                                1          1m
```

Create a test rbd image:
```sh
$ export PODNAME=`kubectl -n ceph get pods --selector="app=ceph,daemon=mon" --output=template --template="{{with index .items 0}}{{.metadata.name}}{{end}}"`
$ kubectl -n ceph exec -it ${PODNAME} -- rbd create ceph-rbd-test --size 20G
$ kubectl -n ceph exec -it ${PODNAME} -- rbd info ceph-rbd-test
```

Create a new `StorageClass` for rbd(pls, change kube-controller-manager image to [quay.io/attcomdev/kube-controller-manager:{version}](https://quay.io/repository/attcomdev/kube-controller-manager?tag=v1.6.1&tab=tags)):
```sh
# Create a osd pool
$ export PODNAME=`kubectl -n ceph get pods --selector="app=ceph,daemon=mon" --output=template --template="{{with index .items 0}}{{.metadata.name}}{{end}}"`
$ kubectl -n ceph exec -it ${PODNAME} -- ceph osd pool create kube 64 64
$ kubectl -n ceph exec -it ${PODNAME} -- ceph osd pool ls

# Create auth keys
$ kubectl -n ceph exec -it ${PODNAME} -- ceph auth get-or-create client.kube mon 'allow r' osd 'allow rwx pool=kube'
$ $ kubectl -n ceph exec -it ${PODNAME} -- ceph auth get-key client.admin > ceph-admin-key
$ kubectl -n ceph exec -it ${PODNAME} -- ceph auth get-key client.kube > ceph-kube-key
$ kubectl create secret generic --type="kubernetes.io/rbd" admin-key --from-file=./ceph-admin-key -n kube-system
$ kubectl create secret generic --type="kubernetes.io/rbd" kube-key --from-file=./ceph-kube-key

$ MONITORS=$(kubectl -n ceph get pods -l daemon=mon -o template --template="{{range .items}}{{if .status.podIP}}{{.status.podIP}}:6789{{end}},{{end}}" | sed 's/,$//g')
$ sed "s/MONITORS/${MONITORS}/g" -i rbd-sc.yml
$ kubectl -n kube-system create -f rbd-sc.yml
$ kubectl create -f rbd-dyn-pvc.yml
```
