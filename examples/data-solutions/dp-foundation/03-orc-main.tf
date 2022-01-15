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
