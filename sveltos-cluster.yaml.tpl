apiVersion: v1
kind: Namespace
metadata:
  name: ${cluster_name}
---
apiVersion: v1
kind: Secret
metadata:
  name: ${cluster_name}-kubeconfig
  namespace: ${cluster_name}
data:
  kubeconfig: >-
    kubeconfig
  re-kubeconfig: >-
    kubeconfig
type: Opaque
---
apiVersion: lib.projectsveltos.io/v1beta1
kind: SveltosCluster
metadata:
  labels:
%{ for key, value in labels ~}
    ${key}: ${value}
%{ endfor ~}
    sveltos-agent: present
spec:
  consecutiveFailureThreshold: 3