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
  final String config;
  final String action;
  final List<String> targets;

  const Arguments({
    this.showHelp = false,
    this.dryRun = false,
    this.config = "",
    this.action = "",
    this.targets = const [],
  });
}

(String, Arguments) parseAndValidateArguments(List<String> arguments) {
  if (arguments.isEmpty) {
    return ("", const Arguments(showHelp: true));
  }

  var config = "";
  var action = "";
  var targets = <String>[];
  var dryRun = false;

  for (int i = 0; i < arguments.length; i++) {
    var argument = arguments[i];
    if (argument.startsWith("--")) {
      if (argument == "--help") {
        return ("", const Arguments(showHelp: true));
      } else if (argument == "--config") {
        if (config != "") {
          return ("Duplicate option '--config'.", const Arguments());
        }
        if (i + 1 < arguments.length) {
          if (arguments[i + 1].startsWith("--")) {
            // check if the next argument is an option
            return (
              "Value for '--config' cannot be an option (e.g., start with '--').",
              const Arguments(),
            );
          }
          config = arguments[++i];
        } else {
          return ("Missing value for '--config'.", const Arguments());
        }
      } else if (argument == "--dryrun") {
        if (dryRun) {
          return ("Duplicate option '--dryrun'.", const Arguments());
        }
        dryRun = true;
      } else {
        return ("Unknown option '$argument'.", const Arguments());
      }
    } else {
      if (action == "") {
        argument = argument.toLowerCase();
        if (validActions.contains(argument)) {
          action = argument;
        } else {
          return ("Unknown action '$argument'.", const Arguments());
        }
      } else {
        targets.add(argument.toLowerCase());
      }
    }
  }
  if (action == "") {
    return ("Missing action.", const Arguments());
  }
  if (targets.isEmpty) {
    return ("Missing target.", const Arguments());
  }
  return (
    "",
    Arguments(config: config, dryRun: dryRun, action: action, targets: targets),
  );
}
