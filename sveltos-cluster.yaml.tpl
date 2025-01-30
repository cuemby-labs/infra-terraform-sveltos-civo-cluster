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
spec:
  consecutiveFailureThreshold: 3