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
  final String action;
  final List<String> targets;
  final String configsPath;
  final String podsPath;

  const Configuration({
    this.dryRun = false,
    this.action = "",
    this.targets = const [],
    this.configsPath = "",
    this.podsPath = "",
  });
}

(String, Configuration) createAndValidateConfiguration(
  PoddarConfigData poddarConfigData,
  Arguments arguments,
) {
  final pods = poddarConfigData.configsPods;
  final groups = poddarConfigData.configsGroups;

  for (final entry in groups.entries) {
    if (entry.value.isEmpty) {
      return ("Group '${entry.key}' cannot be emtpy!", const Configuration());
    }
    if (pods.contains(entry.key)) {
      return (
        "Group with name '${entry.key}' already defined as pod!",
        const Configuration(),
      );
    }
  }

  final targets = arguments.targets;
  // use Set, because all targets can be added only once
  final Set<String> targetsSet = {};

  for (final target in targets) {
    // add target if found in pods list
    if (pods.contains(target)) {
      targetsSet.add(target);
      // if target is group, add all targets defined in group
    } else if (groups.containsKey(target)) {
      targetsSet.addAll(groups[target]!);
    } else {
      // looking for target in all groups
      var found = false;
      for (final entry in groups.entries) {
        if (entry.value.contains(target)) {
          targetsSet.add(target);
          found = true;
          break;
        }
      }
      // if target was not found, return error
      if (!found) {
        return ("Target '$target' not found in config!", const Configuration());
      }
    }
  }

  return (
    "",
    Configuration(
      // arguments dryRun overrides config dryRun if true, better safe than sorry
      dryRun: arguments.dryRun ? true : poddarConfigData.dryRun,
      action: arguments.action,
      targets: targetsSet.toList(),
      configsPath: poddarConfigData.configsPath,
      podsPath: poddarConfigData.podsPath,
    ),
  );
}
