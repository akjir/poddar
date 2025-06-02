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

import 'package:poddar/arguments.dart' show parseAndValidateArguments;
import 'package:poddar/constant.dart';

void main(List<String> args) {
  final arguments = parseAndValidateArguments(args);
  if (arguments.error.isNotEmpty) {
    print(arguments.error);
  } else if (arguments.showHelp) {
    _printHelp();
  } else {
    print(arguments.toString());
  }
}

void _printHelp() {
  print("PODDAR $version");
  print("");
  print("Usage: poddar [OPTIONS] ACTION [TARGETS]");
  print("");
  print("ACTION:");
  print("  create             create a new pod");
  print("  recreate           removes and then creates a new pod");
  print("  remove             remove a running pod");
  print("  update             update all defined images of the pod");
  print("");
  print("TARGETS:             names of valid PodConfigs or groups defined");
  print("                     in a config, separeted by whitespaces");
  print("");
  print("OPTIONS:");
  print(
    "  --config [NAME]    use config with given name ('.yaml' is optional)",
  );
  print("  --help             display this help and exit");
}
