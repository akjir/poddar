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

import 'package:poddar/constant.dart' show validActions;

class Arguments {
  final bool showHelp;
  final bool dryRun;
  final String error;
  final String config;
  final String action;
  final List<String> targets;

  Arguments({
    this.showHelp = false,
    this.dryRun = false,
    this.error = "",
    this.config = "",
    this.action = "",
    this.targets = const [],
  });
}

Arguments parseAndValidateArguments(List<String> arguments) {
  if (arguments.isEmpty) {
    return Arguments(showHelp: true);
  }

  var config = "";
  var action = "";
  var targets = <String>[];
  var dryRun = false;

  for (int i = 0; i < arguments.length; i++) {
    var argument = arguments[i];
    if (argument.startsWith("--")) {
      if (argument == "--help") {
        return (Arguments(showHelp: true));
      } else if (argument == "--config") {
        if (config != "") {
          return (Arguments(error: "Duplicate option '--config'."));
        }
        if (i + 1 < arguments.length) {
          if (arguments[i + 1].startsWith("--")) {
            // Check if the next argument is an option
            return (Arguments(
              error:
                  "Value for '--config' cannot be an option (e.g., start with '--').",
            ));
          }
          config = arguments[++i];
        } else {
          return (Arguments(error: "Missing value for '--config'."));
        }
      } else if (argument == "--dryrun") {
        if (dryRun) {
          return (Arguments(error: "Duplicate option '--dryrun'."));
        }
        dryRun = true;
      } else {
        return (Arguments(error: "Unknown option '$argument'."));
      }
    } else {
      if (action == "") {
        argument = argument.toLowerCase();
        if (validActions.contains(argument)) {
          action = argument;
        } else {
          return (Arguments(error: "Unknown action '$argument'."));
        }
      } else {
        targets.add(argument.toLowerCase());
      }
    }
  }
  if (action == "") {
    return (Arguments(error: "Missing action."));
  }
  if (targets.isEmpty) {
    return (Arguments(error: "Missing target."));
  }
  return Arguments(
    config: config,
    dryRun: dryRun,
    action: action,
    targets: targets,
  );
}
