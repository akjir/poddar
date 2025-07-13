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

import 'package:poddar/io/config_files.dart';

class AppConfigData {
  final bool dryRun;
  final String configsPath;
  final List<String> configsPods;
  final Map<String, List<String>> configsGroups;
  final String podsPath;

  const AppConfigData({
    this.dryRun = true,
    this.configsPath = "",
    this.configsPods = const [],
    this.configsGroups = const {},
    this.podsPath = "",
  });
}

Future<(String, AppConfigData)> readAppConfigData(final configPath) async {
  final (error, configMap) = await readConfigData(configPath);
  if (error.isNotEmpty) {
    return (error, const AppConfigData());
  }

  /* options */
  final dryRun = _getOrDefault(configMap, "dryrun", true);

  /* configs */
  final configsData = _getMap(configMap, "configs");

  final configsPath = _getOrDefault(configsData, "path", "");

  final rawConfigPods = _getList(configsData, "pods");
  final configsPods = rawConfigPods.whereType<String>().toList();

  final rawConfigGroups = _getMap(configsData, "groups");
  final Map<String, List<String>> configsGroups = {};
  rawConfigGroups.forEach((key, value) {
    // groups without value are ignored, value == null
    if (key is String && value is List) {
      final List<String> stringList = value
          .whereType<String>()
          .map((s) => s.toLowerCase())
          .toList();
      configsGroups[key.toLowerCase()] = stringList;
    }
  });

  /* pods */
  final podsData = _getMap(configMap, "pods");

  final String podsPath = _getOrDefault(podsData, "path", "");

  return (
    "",
    AppConfigData(
      dryRun: dryRun,
      configsPath: configsPath,
      configsPods: configsPods,
      configsGroups: configsGroups,
      podsPath: podsPath,
    ),
  );
}

// Helper to safely extract a value of a specific type from a map, or return a default.
T _getOrDefault<T>(Map<dynamic, dynamic> map, String key, T defaultValue) {
  final value = map[key];
  if (value is T) {
    return value;
  }
  return defaultValue;
}

// Helper to safely extract a map, or return an empty map.
Map<dynamic, dynamic> _getMap(Map<dynamic, dynamic> map, String key) {
  final value = map[key];
  return value is Map<dynamic, dynamic> ? value : {};
}

// Helper to safely extract a list, or return an empty list.
List<dynamic> _getList(Map<dynamic, dynamic> map, String key) {
  final value = map[key];
  return value is List<dynamic> ? value : [];
}
