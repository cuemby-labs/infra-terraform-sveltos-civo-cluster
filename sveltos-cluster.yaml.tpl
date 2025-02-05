---
apiVersion: lib.projectsveltos.io/v1beta1
kind: SveltosCluster
metadata:
  name: ${cluster_name}
  namespace: ${cluster_name}
  labels:
%{ for key, value in labels ~}
    ${key}: ${value}
%{ endfor ~}
    sveltos-agent: present
    projectsveltos.io/k8s-version: v${kubernetes_version}
spec:
  consecutiveFailureThreshold: 3