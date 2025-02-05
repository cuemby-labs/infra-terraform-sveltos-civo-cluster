---
apiVersion: v1
kind: ConfigMap
metadata:
  name: civo-cluster-${cluster_name}
  namespace: projectsveltos
data:
  values: |
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