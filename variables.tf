#
# Variables for Civo Kubernetes cluster
#

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "applications" {
  description = "Comma-separated list of applications to install"
  type        = string
  default     = "civo-cluster-autoscaler,helm"
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to use, list them running 'civo kubernetes versions'"
  type        = string
  default     = "1.28.7-k3s1"
}

variable "region" {
  description = "Civo region to deploy the cluster"
  type        = string
  default     = "NYC1"
}

variable "cluster_type" {
  description = "Type of cluster (e.g., talos, k3s)"
  type        = string
  default     = "k3s"
}

variable "cni" {
  description = "CNI plugin to use (e.g., flannel for talos, cilium for k3s)"
  type        = string
  default     = "cilium"
}

variable "node_size" {
  description = "Size of the nodes in the pool, list them running 'civo kubernetes size'"
  type        = string
  default     = "g4p.kube.small"
}

variable "node_count" {
  description = "Number of nodes in the pool"
  type        = number
  default     = 3
}

#
# Variables for Civo network
#

variable "network_cidr_v4" {
  description = "CIDR block for the network"
  type        = string
  default     = "192.168.0.0/24"
}

variable "network_nameservers_v4" {
  description = "List of nameservers for the network"
  type        = list(string)
  default     = ["8.8.8.8", "1.1.1.1"]
}

#
# Variables for Civo firewall
#

variable "external_network" {
  description = "external CIDR for kubectl access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "default_cidr" {
  description = "default CIDR 0.0.0.0/0"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "local_cidr" {
  description = "Local CIDR for ingress firewall rules"
  type        = list(string)
  default     = ["192.168.0.0/24"]
}

#
# Variables for Sveltos
#

variable "sveltos_labels" {
  description = "Dynamic labels for SveltosCluster."
  type        = map(string)
  default = {
    cp-cluster    = "core"
    cp-platform   = "common"
    dns           = "cloudflare"
    domain        = "domain.com"
    environment   = "dev"
    service-mesh  = "istio"
    sveltos-agent = "present"
  }
}

#
# Walrus Contextual Fields
#

variable "context" {
  description = <<-EOF
Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.

Examples:
```
context:
  project:
    name: string
    id: string
  environment:
    name: string
    id: string
  resource:
    name: string
    id: string
```
EOF
  type        = map(any)
  default     = {}
}