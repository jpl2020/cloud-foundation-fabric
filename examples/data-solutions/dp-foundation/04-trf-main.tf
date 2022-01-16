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
  iam_trf = {
    # "roles/bigquery.dataViewer" = [
    #   module.orch-sa-cmp-0.iam_email
    # ]
    # "roles/bigquery.jobUser" = [
    #   module.transf-sa-bq-0.iam_email,
    #   local.groups_iam.data-engineers,
    #   local.groups_iam.data-scientists
    # ]
    # "roles/dataflow.admin" = [
    #   module.orch-sa-cmp-0.iam_email,
    #   local.groups_iam.data-engineers
    # ]
    # "roles/dataflow.worker" = [
    #   module.transf-sa-df-0.iam_email
    # ]
    # "roles/storage.objectAdmin" = [
    #   module.transf-sa-df-0.iam_email,
    #   module.orch-sa-cmp-0.iam_email,
    #   "serviceAccount:${module.transf-project.service_accounts.robots.dataflow}"
    # ]
    # "roles/viewer" = [
    #   local.groups_iam.cloud-architects,
    #   local.groups_iam.data-engineers
    # ]
  }
  prefix_trf = "${var.prefix}-trf"
}

###############################################################################
#                                 Project                                     #
###############################################################################

module "trf-prj" {
  source          = "../../../modules/project"
  name            = var.project_id["trasformation"]
  parent          = try(var.project_create.parent, null)
  billing_account = try(var.project_create.billing_account_id, null)
  project_create  = var.project_create != null
  prefix          = var.project_create == null ? null : var.prefix
  # additive IAM bindings avoid disrupting bindings in existing project
  iam          = var.project_create != null ? local.iam_trf : {}
  iam_additive = var.project_create == null ? local.iam_trf : {}
  services = concat(var.project_services, [
    "bigquery.googleapis.com",
    "bigqueryreservation.googleapis.com",
    "bigquerystorage.googleapis.com",
    "cloudkms.googleapis.com",
    "compute.googleapis.com",
    "dataflow.googleapis.com",
    "pubsub.googleapis.com",
    "servicenetworking.googleapis.com",
    "storage.googleapis.com",
    "storage-component.googleapis.com"
  ])
}
