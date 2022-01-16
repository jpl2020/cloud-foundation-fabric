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

module "orc-sa-cmp-0" {
  source     = "../../../modules/iam-service-account"
  project_id = module.orc-prj.project_id
  name       = "cmp-0"
  prefix     = local.prefix_orc
  iam = {
    # "roles/iam.serviceAccountTokenCreator" = [
    #   local.groups_iam.data-engineers
    # ],
    # "roles/iam.serviceAccountUser" = [
    #   module.orch-sa-cmp-0.iam_email,
    #   local.groups_iam.data-engineers
    # ]
  }
}

resource "google_composer_environment" "orc-cmp-0" {
  name     = "${local.prefix_orc}-cmp-0"
  region   = var.composer_config.region
  provider = google-beta
  project  = module.orc-prj.project_id
  config {
    node_count = 3
    node_config {
      zone            = "${var.composer_config.region}-b"
      service_account = module.orc-sa-cmp-0.email
      network         = module.orc-vpc[0].self_link
      subnetwork      = module.orc-vpc[0].subnet_self_links["${var.composer_config.region}/subnet"]
      ip_allocation_policy {
        use_ip_aliases                = "true"
        cluster_secondary_range_name  = "pods"
        services_secondary_range_name = "services"
      }
    }
    software_config {
      env_variables = {
        BQ_L0_DATASET      = module.dtl-0-bq-0.dataset_id
        BQ_L1_DATASET      = module.dtl-1-bq-0.dataset_id
        BQ_L2_DATASET      = module.dtl-2-bq-0.dataset_id
        BQ_EXP_DATASET     = module.dtl-exp-bq-0.dataset_id
        GCS_L0             = module.dtl-0-cs-0.url
        GCS_L1             = module.dtl-1-cs-0.url
        GCS_L2             = module.dtl-2-cs-0.url
        GCS_EXP            = module.dtl-exp-cs-0.url
        GCS_LAND           = module.lnd-cs-0.url
        GCS_LOAD_STAGING   = module.lod-cs-df-0.url
        GCS_TRANSF_STAGING = module.trf-cs-df-0.url
        GCP_REGION         = var.composer_config.region
        NET_VPC            = module.orc-vpc[0].self_link
        NET_SUBNET         = module.orc-vpc[0].subnet_self_links["${var.composer_config.region}/subnet"]
        PRJ_L0             = module.dtl-0-prj.project_id
        PRJ_L1             = module.dtl-1-prj.project_id
        PRJ_L2             = module.dtl-2-prj.project_id
        PRJ_LAND           = module.lnd-prj.project_id
        PRJ_LOAD           = module.lod-prj.project_id
        PRJ_ORCH           = module.orc-prj.project_id
        PRJ_TRANSF         = module.trf-prj.project_id
        SA_DATAFLOW_LOD    = module.lod-sa-df-0.email
        SA_DATAFLOW_TRF    = module.lod-sa-df-0.email
      }
    }
    private_environment_config {
      enable_private_endpoint    = "true"
      master_ipv4_cidr_block     = var.composer_config.ip_range_gke_master
      cloud_sql_ipv4_cidr_block  = var.composer_config.ip_range_cloudsql
      web_server_ipv4_cidr_block = var.composer_config.ip_range_web_server
    }

    # web_server_network_access_control {
    #   allowed_ip_range {
    #     value       = "172.16.0.0/12"
    #     description = "rete GEDI"
    #   }
    # }
  }
}
