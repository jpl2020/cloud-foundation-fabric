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
#                                  Network                                    #
###############################################################################

module "orc-vpc" {
  count      = var.network != null ? 1 : 0
  source     = "../../../modules/net-vpc"
  project_id = module.orc-prj.project_id
  name       = "${local.prefix_orc}-vpc"
  subnets = [
    {
      ip_cidr_range      = var.vpc_subnet_range
      name               = "subnet"
      region             = var.region
      secondary_ip_range = {}
    }
  ]
}

module "orc-vpc-firewall" {
  count        = var.network != null ? 1 : 0
  source       = "../../../modules/net-vpc-firewall"
  project_id   = module.orc-prj.project_id
  network      = module.orc-vpc[0].name
  admin_ranges = [var.vpc_subnet_range]
}

module "orc-nat" {
  count          = var.network != null ? 1 : 0
  source         = "../../../modules/net-cloudnat"
  project_id     = module.orc-prj.project_id
  region         = var.region
  name           = "${local.prefix_orc}-default"
  router_network = module.orc-vpc[0].name
}
