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
  iam_lnd = {
    # # TODO: replace with custom role at the org level
    # "roles/bigquery.dataEditor" = [
    #   module.landing-sa-bq-0.iam_email,
    #   local.groups_iam.data-engineers
    # ]
    # "roles/bigquery.dataViewer" = [
    #   module.load-sa-df-0.iam_email,
    #   module.orch-sa-cmp-0.iam_email,
    #   local.groups_iam.data-scientists
    # ]
    # "roles/bigquery.jobUser" = [
    #   module.orch-sa-cmp-0.iam_email
    # ]
    # "roles/bigquery.user" = [
    #   module.load-sa-df-0.iam_email
    # ]
    # "roles/pubsub.editor" = [
    #   local.groups_iam.data-engineers
    # ]
    # "roles/pubsub.publisher" = [
    #   module.landing-sa-ps-0.iam_email
    # ]
    # "roles/pubsub.subscriber" = [
    #   module.load-sa-df-0.iam_email,
    #   module.orch-sa-cmp-0.iam_email
    # ]
    # "roles/pubsub.viewer" = [
    #   local.groups_iam.data-scientists
    # ]
    # "roles/storage.objectAdmin" = [
    #   module.load-sa-df-0.iam_email,
    # ]
    # "roles/storage.objectCreator" = [
    #   module.landing-sa-cs-0.iam_email,
    #   local.groups_iam.data-engineers
    # ]
    # "roles/storage.objectViewer" = [
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
    #   #TODO Added to temporarly fix impersonification
    #   local.groups_iam.data-engineers
    # ]
  }
  prefix_lnd = "${var.prefix}-lnd"
}

###############################################################################
#                                 Project                                     #
###############################################################################

module "lnd-prj" {
  source          = "../../../modules/project"
  name            = var.project_id["landing"]
  parent          = try(var.project_create.parent, null)
  billing_account = try(var.project_create.billing_account_id, null)
  project_create  = var.project_create != null
  prefix          = var.project_create == null ? null : var.prefix
  # additive IAM bindings avoid disrupting bindings in existing project
  iam          = var.project_create != null ? local.iam_lnd : {}
  iam_additive = var.project_create == null ? local.iam_lnd : {}
  services = concat(var.project_services, [
    "bigquery.googleapis.com",
    "bigqueryreservation.googleapis.com",
    "bigquerystorage.googleapis.com",
    "cloudkms.googleapis.com",
    "pubsub.googleapis.com",
    "storage.googleapis.com",
    "storage-component.googleapis.com",
  ])
}
