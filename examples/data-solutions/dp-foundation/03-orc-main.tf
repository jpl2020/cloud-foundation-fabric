# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

locals {
  iam_orc = {
    # "roles/bigquery.dataEditor" = [
    #   module.load-sa-df-0.iam_email,
    #   module.transf-sa-df-0.iam_email,
    #   module.orch-sa-cmp-0.iam_email,
    #   local.groups_iam.data-engineers
    # ]
    # "roles/bigquery.dataViewer" = [
    #   local.groups_iam.cloud-architects,
    #   local.groups_iam.data-scientists
    # ]
    # "roles/bigquery.jobUser" = [
    #   module.load-sa-df-0.iam_email,
    #   module.transf-sa-df-0.iam_email,
    #   module.orch-sa-cmp-0.iam_email,
    #   local.groups_iam.data-engineers,
    #   local.groups_iam.cloud-architects
    # ]
    # "roles/composer.admin" = [
    #   local.groups_iam.cloud-architects
    # ]
    # "roles/composer.environmentAndStorageObjectAdmin" = [
    #   local.groups_iam.data-engineers
    # ]
    # "roles/composer.worker" = [
    #   module.orch-sa-cmp-0.iam_email
    # ]
    # "roles/iap.httpsResourceAccessor" = [
    #   local.groups_iam.data-engineers,
    #   local.groups_iam.cloud-architects
    # ]
    # "roles/storage.objectAdmin" = [
    #   module.load-sa-df-0.iam_email,
    #   module.orch-sa-cmp-0.iam_email,
    #   local.groups_iam.data-engineers,
    #   local.groups_iam.cloud-architects
    # ]
    # "roles/storage.admin" = [
    #   local.groups_iam.data-engineers,
    #   local.groups_iam.cloud-architects,
    #   # TODO: restrict to storage.buckets.list/get (role for this does not natively exist)
    #   module.load-sa-df-0.iam_email,
    #   module.transf-sa-df-0.iam_email
    # ]
    # "roles/cloudbuild.builds.editor" = [
    #   local.groups_iam.cloud-architects
    # ]
  }
  prefix_orc = "${var.prefix}-orc"
}

module "orc-prj" {
  source          = "../../../modules/project"
  name            = var.project_id["orchestration"]
  parent          = try(var.project_create.parent, null)
  billing_account = try(var.project_create.billing_account_id, null)
  project_create  = var.project_create != null
  prefix          = var.project_create == null ? null : var.prefix
  # additive IAM bindings avoid disrupting bindings in existing project
  iam          = var.project_create != null ? local.iam_orc : {}
  iam_additive = var.project_create == null ? local.iam_orc : {}
  services = concat(var.project_services, [
    "bigquery.googleapis.com",
    "bigqueryreservation.googleapis.com",
    "bigquerystorage.googleapis.com",
    "composer.googleapis.com",
    "container.googleapis.com",
    "dataflow.googleapis.com",
    "pubsub.googleapis.com",
    "servicenetworking.googleapis.com",
    "storage.googleapis.com",
    "storage-component.googleapis.com"
  ])
}

module "orc-sa-cmp-0" {
  source     = "../../../modules/iam-service-account"
  project_id = module.orc-prj.project_id
  name       = "orc-cmp-0"
  prefix     = local.prefix_orc
  iam = {
    # "roles/iam.serviceAccountTokenCreator" = [local.groups_iam.data-engineers]
  }
}

###############################################################################
#                                   GCS                                       #
###############################################################################

module "orch-bucket-cf-0" {
  source     = "../../../modules/gcs"
  project_id = module.orc-prj.project_id
  name       = "orc-cs-0"
  prefix     = local.prefix_orc
}

###############################################################################
#                                Composer                                     #
###############################################################################

# resource "google_composer_environment" "orch-env-cmp-0" {
#   count    = var.prep_stage ? 0 : 1
#   name     = "orch-env-cmp-0"
#   region   = var.composer_config.region
#   provider = google-beta
#   project  = module.orch-project.project_id
#   labels   = { component = "orchestration" }
#   config {
#     node_count = 3
#     node_config {
#       zone            = "${var.composer_config.region}-b"
#       machine_type    = "n1-highmem-2"
#       service_account = module.orch-sa-cmp-0.email
#       network         = module.globals.values.networking["spoke-${var.environment}"].vpc
#       subnetwork      = module.globals.values.networking["spoke-${var.environment}"].subnets["europe-west1/${var.prefix}-${local.short_env}-net-core-sub-spoke-0"]
#       tags            = ["composer-worker"]
#       ip_allocation_policy {
#         use_ip_aliases                = "true"
#         cluster_secondary_range_name  = "pods"
#         services_secondary_range_name = "services"
#       }
#     }
#     software_config {
#       image_version = "composer-1.17.5-airflow-2.1.4"
#       env_variables = {
#         BQ_L0_DATASET      = module.dp-hub-dl-0-bq-dataset-0.dataset_id
#         BQ_L1_DATASET      = module.dp-hub-dl-1-bq-dataset-0.dataset_id
#         BQ_L2_DATASET      = module.dp-hub-dl-2-bq-dataset-0.dataset_id
#         GCS_LAND           = module.landing-bucket-cs-0.url
#         GCS_LOAD_STAGING   = module.load-bucket-df-0.url
#         GCS_TRANSF_STAGING = module.transf-bucket-cs-0.url
#         GCP_REGION         = var.composer_config.region
#         NET_VPC            = module.globals.values.networking.spoke-dev.vpc
#         NET_SUBNET         = module.globals.values.networking["spoke-${var.environment}"].subnets["europe-west1/${var.prefix}-${local.short_env}-net-core-sub-spoke-0"]
#         PRJ_L0             = module.lake-0-project.project_id
#         PRJ_L1             = module.lake-1-project.project_id
#         PRJ_L2             = module.lake-2-project.project_id
#         PRJ_LAND           = module.landing-project.project_id
#         PRJ_LOAD           = module.load-project.project_id
#         PRJ_ORCH           = module.orch-project.project_id
#         PRJ_TRANSF         = module.transf-project.project_id
#         SA_DATAFLOW        = module.load-sa-df-0.email
#       }
#     }
#     private_environment_config {
#       enable_private_endpoint    = "true"
#       master_ipv4_cidr_block     = var.composer_config.ip_range_gke_master
#       cloud_sql_ipv4_cidr_block  = var.composer_config.ip_range_cloudsql
#       web_server_ipv4_cidr_block = var.composer_config.ip_range_web_server
#     }

#     # web_server_network_access_control {
#     #   allowed_ip_range {
#     #     value       = "172.16.0.0/12"
#     #     description = "rete GEDI"
#     #   }
#     # }
#   }
# }
