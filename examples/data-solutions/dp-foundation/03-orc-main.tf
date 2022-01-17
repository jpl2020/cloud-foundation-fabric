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
    "roles/bigquery.dataEditor" = [
      module.lod-sa-df-0.iam_email,
      module.trf-sa-df-0.iam_email,
      module.orc-sa-cmp-0.iam_email,
    ]
    "roles/bigquery.jobUser" = [
      module.lod-sa-df-0.iam_email,
      module.trf-sa-df-0.iam_email,
      module.orc-sa-cmp-0.iam_email,
    ]
    "roles/composer.worker" = [
      module.orc-sa-cmp-0.iam_email
    ]
    "roles/storage.objectAdmin" = [
      module.load-sa-df-0.iam_email,
      module.orch-sa-cmp-0.iam_email,
    ]
    "roles/storage.admin" = [
      module.lod-sa-df-0.iam_email,
      module.trf-sa-df-0.iam_email
    ]
  }
  iam_group_orc = {
    "roles/bigquery.dataEditor" = [
      local.groups_iam.data-engineers
    ]
    "roles/bigquery.dataViewer" = [
      local.groups_iam.data-scientists
    ]
    "roles/bigquery.jobUser" = [
      local.groups_iam.data-engineers,
    ]
    "roles/composer.admin" = [
      local.groups_iam.data-engineers
    ]
    "roles/composer.environmentAndStorageObjectAdmin" = [
      local.groups_iam.data-engineers
    ]
    "roles/composer.worker" = [
      module.orc-sa-cmp-0.iam_email
    ]
    "roles/iap.httpsResourceAccessor" = [
      local.groups_iam.data-engineers,
    ]
    "roles/storage.objectAdmin" = [
      local.groups_iam.data-engineers,
    ]
    "roles/storage.admin" = [
      local.groups_iam.data-engineers,
    ]
    "roles/cloudbuild.builds.editor" = [
      local.groups_iam.data-engineers
    ]
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
    "artifactregistry.googleapis.com",
    "bigquery.googleapis.com",
    "bigqueryreservation.googleapis.com",
    "bigquerystorage.googleapis.com",
    "cloudkms.googleapis.com",
    "composer.googleapis.com",
    "container.googleapis.com",
    "dataflow.googleapis.com",
    "pubsub.googleapis.com",
    "servicenetworking.googleapis.com",
    "storage.googleapis.com",
    "storage-component.googleapis.com"
  ])
}
