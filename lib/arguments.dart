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

  Arguments({
    this.showHelp = false,
    this.dryRun = false,
    this.config = "",
    this.action = "",
    this.targets = const [],
  });
}

(String, Arguments) parseAndValidateArguments(List<String> arguments) {
  if (arguments.isEmpty) {
    return ("", Arguments(showHelp: true));
  }

  var config = "";
  var action = "";
  var targets = <String>[];
  var dryRun = false;

  for (int i = 0; i < arguments.length; i++) {
    var argument = arguments[i];
    if (argument.startsWith("--")) {
      if (argument == "--help") {
        return ("", Arguments(showHelp: true));
      } else if (argument == "--config") {
        if (config != "") {
          return ("Duplicate option '--config'.", Arguments());
        }
        if (i + 1 < arguments.length) {
          if (arguments[i + 1].startsWith("--")) {
            // check if the next argument is an option
            return (
              "Value for '--config' cannot be an option (e.g., start with '--').",
              Arguments(),
            );
          }
          config = arguments[++i];
        } else {
          return ("Missing value for '--config'.", Arguments());
        }
      } else if (argument == "--dryrun") {
        if (dryRun) {
          return ("Duplicate option '--dryrun'.", Arguments());
        }
        dryRun = true;
      } else {
        return ("Unknown option '$argument'.", Arguments());
      }
    } else {
      if (action == "") {
        argument = argument.toLowerCase();
        if (validActions.contains(argument)) {
          action = argument;
        } else {
          return ("Unknown action '$argument'.", Arguments());
        }
      } else {
        targets.add(argument.toLowerCase());
      }
    }
  }
  if (action == "") {
    return ("Missing action.", Arguments());
  }
  if (targets.isEmpty) {
    return ("Missing target.", Arguments());
  }
  return (
    "",
    Arguments(config: config, dryRun: dryRun, action: action, targets: targets),
  );
}
