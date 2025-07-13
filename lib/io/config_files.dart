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

import 'dart:io';
import 'package:yaml/yaml.dart';

Future<(String, Map<String, dynamic>)> readConfigData(String filePath) async {
  if (filePath.isEmpty) {
    return ("Configuration file path is empty.", <String, dynamic>{});
  }

  if (!filePath.endsWith(".yaml")) {
    filePath = "$filePath.yaml";
  }

  final file = File(filePath);
  if (!await file.exists()) {
    return ("Configuration file not found: '$filePath'.", <String, dynamic>{});
  }

  try {
    final content = await file.readAsString();
    final yamlDoc = loadYaml(content);

    if (yamlDoc is! YamlMap) {
      return (
        "Configuration file content is not a valid YAML map.",
        <String, dynamic>{},
      );
    }

    // Convert YamlMap to Map<String, dynamic> for easier processing
    final Map<String, dynamic> configMap = Map<String, dynamic>.fromEntries(
      yamlDoc.nodes.entries.map(
        (entry) => MapEntry(entry.key.toString(), entry.value.value),
      ),
    );
    return ("", configMap);
  } on YamlException catch (e) {
    return (
      "Error parsing YAML configuration file: ${e.message}",
      <String, dynamic>{},
    );
  } catch (e) {
    return (
      "An unexpected error occurred while loading configuration: $e",
      <String, dynamic>{},
    );
  }
}
