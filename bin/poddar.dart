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
import 'package:poddar/configuration.dart';
import 'package:poddar/constant.dart' as constant;
import 'package:poddar/data/pod_config.dart';
import 'package:poddar/data/app_config.dart';

void main(List<String> args) async {
  // handle arguments
  final (errorArguments, arguments) = parseAndValidateArguments(args);
  if (errorArguments.isNotEmpty) {
    print(errorArguments);
  } else if (arguments.showHelp) {
    // print help and exit
    _printHelp();
  } else {
    // if app config file path is not definded as an arguement us default
    final appConfigFilePath = arguments.config.isNotEmpty
        ? arguments.config
        : constant.defaultAppConfigFilePath;
    // read app config file
    final (errorAppConfigData, appConfigData) = await readAppConfigData(
      appConfigFilePath,
    );
    if (errorAppConfigData.isNotEmpty) {
      print(errorAppConfigData);
    } else {
      // create and validate app configuration
      final (errorConfiguration, configuration) =
          createAndValidateConfiguration(appConfigData, arguments);
      if (errorConfiguration.isNotEmpty) {
        print(errorConfiguration);
      } else {
        //
        var errorPodConfiguration = "";
        for (final target in configuration.targets) {
          final (error, podConfigData) = await readPodConfigData(
            configuration.configsPath + target,
          );
          if (error.isNotEmpty) {
            errorPodConfiguration = error;
            break;
          } else {
            print(target);
            // command buffer, contains info or command
            // buildCommands(commandBuffer?, podConfigData, configuration)
          }
        }

        if (errorPodConfiguration.isNotEmpty) {
          print(errorPodConfiguration);
        } else {
          // exec commands
        }
      }
    }
  }
}

void _printHelp() {
  print("PODDAR ${constant.version}");
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
  print(
    "  --dryrun           print intended commands without actual execution",
  );
  print("  --help             display this help and exit");
}
