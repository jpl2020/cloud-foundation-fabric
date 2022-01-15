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
  iam_lod = {
    # "roles/bigquery.jobUser" = [
    #   module.load-sa-df-0.iam_email
    # ]
    # "roles/compute.viewer" = [
    #   # module.orch-sa-cmp-0.iam_email,
    #   # module.load-sa-df-0.iam_email,
    #   local.groups_iam.data-engineers
    # ]
    # "roles/compute.serviceAgent" = [
    #   "serviceAccount:${module.load-project.service_accounts.robots.compute}"
    # ]
    # "roles/dataflow.admin" = [
    #   module.orch-sa-cmp-0.iam_email,
    #   local.groups_iam.data-engineers,
    #   # TODO: optimize permissions (worker)
    #   module.load-sa-df-0.iam_email
    # ]
    # "roles/dataflow.developer" = [
    #   module.orch-sa-cmp-0.iam_email,
    #   local.groups_iam.data-engineers
    # ]
    # "roles/dataflow.worker" = [
    #   module.load-sa-df-0.iam_email
    # ]
    # "roles/dataflow.serviceAgent" = [
    #   # module.load-sa-df-0.iam_email
    #   "serviceAccount:${module.load-project.service_accounts.robots.dataflow}"
    # ]
    # #TODO check if possible to restrict to object creator
    # "roles/storage.objectAdmin" = [
    #   module.load-sa-df-0.iam_email,
    #   module.orch-sa-cmp-0.iam_email,
    #   "serviceAccount:${module.load-project.service_accounts.robots.dataflow}"
    # ]
    # "roles/viewer" = [
    #   local.groups_iam.data-engineers
    # ]
  }
  prefix_lod = "${var.prefix}-lod"
}

###############################################################################
#                                 Project                                     #
###############################################################################

module "lod-prj" {
  source          = "../../../modules/project"
  name            = var.project_id["load"]
  parent          = try(var.project_create.parent, null)
  billing_account = try(var.project_create.billing_account_id, null)
  project_create  = var.project_create != null
  prefix          = var.project_create == null ? null : var.prefix
  # additive IAM bindings avoid disrupting bindings in existing project
  iam          = var.project_create != null ? local.iam_lod : {}
  iam_additive = var.project_create == null ? local.iam_lod : {}
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
