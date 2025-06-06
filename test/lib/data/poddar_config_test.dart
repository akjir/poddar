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

import 'package:poddar/data/poddar_config.dart';
import 'package:test/test.dart';

void main() {
  group("loadPoddarConfig", () {
    test("should return error for empty file path", () async {
      final (error, poddarConfigData) = await loadPoddarConfig("");
      expect(error, "Configuration file path is empty.");
    });

    test(
      "should correctly load and parse a valid configuration file",
      () async {
        final (error, pcd) = await loadPoddarConfig(
          "./test/configs/poddar_config",
        );
        expect(pcd.dryRun, isTrue);
        expect(pcd.configsPath, "./test/configs/");
        expect(pcd.configsPods, equals(["pod1", "mega_pod", "poditlus"]));
        expect(pcd.configsGroups.containsKey("pocks"), isTrue);
        expect(pcd.configsGroups.containsKey("null"), isFalse);
        expect(pcd.configsGroups["nullplus"], equals(["notnull"]));
        expect(pcd.configsGroups["north"], equals(["jon", "ygritte"]));
        expect(pcd.podsPath, "/pods");
        expect(error, isEmpty);
      },
    );
  });
}
