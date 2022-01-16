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
  iam_dtl = {
    # # TODO: replace with custom role at the org level
    # "roles/bigquery.dataEditor" = [
    #   module.load-sa-df-0.iam_email,
    #   module.transf-sa-df-0.iam_email,
    #   module.transf-sa-bq-0.iam_email,
    #   module.orch-sa-cmp-0.iam_email,
    #   local.groups_iam.data-engineers
    # ]
    # "roles/bigquery.dataViewer" = [
    #   local.groups_iam.data-scientists
    # ]
    # "roles/bigquery.jobUser" = [
    #   module.load-sa-df-0.iam_email,
    #   module.transf-sa-df-0.iam_email,
    #   local.groups_iam.data-scientists
    # ]
    # "roles/storage.objectCreator" = [
    #   module.load-sa-df-0.iam_email,
    #   module.transf-sa-df-0.iam_email,
    #   module.transf-sa-bq-0.iam_email,
    #   module.orch-sa-cmp-0.iam_email,
    #   local.groups_iam.data-engineers
    # ]
    # "roles/storage.objectViewer" = [
    #   module.transf-sa-df-0.iam_email,
    #   module.transf-sa-bq-0.iam_email,
    #   module.orch-sa-cmp-0.iam_email,
    #   local.groups_iam.data-engineers,
    #   local.groups_iam.data-scientists
    # ]
    # "roles/viewer" = [
    #   local.groups_iam.data-engineers
    # ]
    # # TODO: restrict to storage.buckets.list/get (role for this does not natively exist)
    # "roles/storage.admin" = [
    #   module.load-sa-df-0.iam_email,
    #   module.transf-sa-df-0.iam_email,
    #   #TODO Added to temporarly fix impersonification
    #   local.groups_iam.data-engineers
    # ]
  }
  prefix_dtl = "${var.prefix}-dtl"
}

###############################################################################
#                                 Project                                     #
###############################################################################

module "dtl-0-prj" {
  source          = "../../../modules/project"
  name            = "${var.project_id["datalake"]}-0"
  parent          = try(var.project_create.parent, null)
  billing_account = try(var.project_create.billing_account_id, null)
  project_create  = var.project_create != null
  prefix          = var.project_create == null ? null : var.prefix
  # additive IAM bindings avoid disrupting bindings in existing project
  iam          = var.project_create != null ? local.iam_dtl : {}
  iam_additive = var.project_create == null ? local.iam_dtl : {}
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

module "dtl-1-prj" {
  source          = "../../../modules/project"
  name            = "${var.project_id["datalake"]}-1"
  parent          = try(var.project_create.parent, null)
  billing_account = try(var.project_create.billing_account_id, null)
  project_create  = var.project_create != null
  prefix          = var.project_create == null ? null : var.prefix
  # additive IAM bindings avoid disrupting bindings in existing project
  iam          = var.project_create != null ? local.iam_dtl : {}
  iam_additive = var.project_create == null ? local.iam_dtl : {}
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

module "dtl-2-prj" {
  source          = "../../../modules/project"
  name            = "${var.project_id["datalake"]}-2"
  parent          = try(var.project_create.parent, null)
  billing_account = try(var.project_create.billing_account_id, null)
  project_create  = var.project_create != null
  prefix          = var.project_create == null ? null : var.prefix
  # additive IAM bindings avoid disrupting bindings in existing project
  iam          = var.project_create != null ? local.iam_dtl : {}
  iam_additive = var.project_create == null ? local.iam_dtl : {}
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

module "dtl-exp-prj" {
  source          = "../../../modules/project"
  name            = "${var.project_id["datalake"]}-exp"
  parent          = try(var.project_create.parent, null)
  billing_account = try(var.project_create.billing_account_id, null)
  project_create  = var.project_create != null
  prefix          = var.project_create == null ? null : var.prefix
  # additive IAM bindings avoid disrupting bindings in existing project
  iam          = var.project_create != null ? local.iam_dtl : {}
  iam_additive = var.project_create == null ? local.iam_dtl : {}
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
