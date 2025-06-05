/* 
 * PodDar
 * Copyright (C) 2025  Stefan Stark
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <https://www.gnu.org/licenses/>. 
 */

import 'package:poddar/arguments.dart';
import 'package:poddar/data/poddar_config.dart';

class Configuration {
  final bool dryRun;

  Configuration(this.dryRun);
}

(String, Configuration) parseAndValidateConfiguration(
  PoddarConfigData poddarConfigData,
  Arguments arguments,
) {
  var dryRun = poddarConfigData.dryRun;

  // arguments dryRun overrides config dryRun if true, better safe than sorry
  if (arguments.dryRun) {
    dryRun = true;
  }
  return ("", Configuration(dryRun));
}
