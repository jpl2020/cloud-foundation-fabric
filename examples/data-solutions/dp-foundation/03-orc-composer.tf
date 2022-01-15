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
