#
# Random number
#

resource "random_password" "random" {
  length  = 2
  special = false
  upper   = false
}

#
# Civo kubernetes cluster
#

resource "civo_kubernetes_cluster" "this" {
    name               = "${var.cluster_name}-${local.walrus_environment_name}-${random_password.random.result}"
    applications       = var.applications
    network_id         = civo_network.this.id
    firewall_id        = civo_firewall.this.id
    kubernetes_version = var.kubernetes_version
    region             = var.region
    cluster_type       = var.cluster_type
    cni                = var.cni
    write_kubeconfig   = true

    pools {
        label      = "${var.cluster_name}-node-${local.walrus_environment_name}-${random_password.random.result}"
        size       = var.node_size
        node_count = var.node_count
    }
}

#
# Civo network
#

resource "civo_network" "this" {
    label          = "${var.cluster_name}-network-${local.walrus_environment_name}-${random_password.random.result}"
    cidr_v4        = var.network_cidr_v4
    region         = var.region
    nameservers_v4 = var.network_nameservers_v4
}

#
# Civo firewall rules
#

resource "civo_firewall" "this" {
    name                 = "${var.cluster_name}-fw-${local.walrus_environment_name}-${random_password.random.result}"
    create_default_rules = false
    network_id           = civo_network.this.id
    region               = var.region

    egress_rule {
        action     = "allow"
        cidr       = var.default_cidr
        label      = "All UDP ports open"
        port_range = "1-65535"
        protocol   = "udp"
    }

    egress_rule {
        action     = "allow"
        cidr       = var.default_cidr
        label      = "All TCP ports open"
        port_range = "1-65535"
        protocol   = "tcp"
    }

    egress_rule {
        action     = "allow"
        cidr       = var.default_cidr
        label      = "Ping/traceroute"
        protocol   = "icmp"
    }

    ingress_rule {
        action     = "allow"
        cidr       = var.local_cidr
        label      = "All UDP ports open"
        port_range = "1-65535"
        protocol   = "udp"
    }

    ingress_rule {
        action     = "allow"
        cidr       = var.local_cidr
        label      = "All TCP ports open"
        port_range = "1-65535"
        protocol   = "tcp"
    }

    ingress_rule {
        action     = "allow"
        cidr       = var.local_cidr
        label      = "Ping/traceroute"
        protocol   = "icmp"
    }

    ingress_rule {
        action     = "allow"
        cidr       = var.external_network
        label      = "Kubectl access"
        port_range = "6443"
        protocol   = "tcp"
    }
}

#
# Sveltos
#

resource "kubernetes_namespace" "sveltos_cluster_namespace" {
  metadata {
    name = var.cluster_name
  }
}

resource "local_file" "kubeconfig" {
  filename = "/tmp/${civo_kubernetes_cluster.this.name}-kubeconfig"  # Define the path and file name
  content  = civo_kubernetes_cluster.this.kubeconfig
}

resource "kubernetes_secret" "sveltos_cluster_secret" {
  depends_on = [ civo_kubernetes_cluster.this ]

  metadata {
    name      = "${var.cluster_name}-sveltos-kubeconfig"
    namespace = var.cluster_name
  }

  data = {
    kubeconfig = local.kubeconfig
  }

  type = "Opaque"
}



# data "template_file" "sveltos_cluster" {
#   template = file("${path.module}/sveltos-cluster.yaml.tpl")

#   vars = {
#     cluster_name   = var.cluster_name
#     kubeconfig     = local.kubeconfig
#     sveltos_labels = var.sveltos_labels
#     }
# }

data "kubectl_file_documents" "sveltos_cluster_file" {
  content = local.sveltos_cluster_yaml
  # content = data.template_file.sveltos_cluster.rendered
}

resource "kubectl_manifest" "sveltos_cluster" {
  depends_on = [ civo_kubernetes_cluster.this ]

  for_each  = data.kubectl_file_documents.sveltos_cluster_file.manifests
  yaml_body = each.value
}

###

# data "kubectl_file_documents" "sveltos_cluster_file" {
#   depends_on = [ civo_kubernetes_cluster.this ]

#   content = local.sveltos_cluster_yaml
# }

# resource "kubectl_manifest" "sveltos_cluster" {
#   depends_on = [ civo_kubernetes_cluster.this ]

#   for_each  = data.kubectl_file_documents.sveltos_cluster_file.manifests
#   yaml_body = each.value
# }


#
# Walrus information
#

locals {
  context                 = var.context
  walrus_environment_name = try(local.context["environment"]["name"], null)

  sveltos_cluster_yaml = templatefile("${path.module}/sveltos-cluster.yaml.tpl", {
    labels             = var.sveltos_labels,
    cluster_name       = var.cluster_name
    kubernetes_version = var.kubernetes_version
  })

  kubeconfig = nonsensitive(civo_kubernetes_cluster.this.kubeconfig)
  version    = substr(var.kubernetes_version, 0, 6)

}