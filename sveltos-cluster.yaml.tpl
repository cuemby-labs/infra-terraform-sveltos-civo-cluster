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