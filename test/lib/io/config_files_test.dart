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
import 'package:test/test.dart';

void main() {
  group("loadConfig", () {
    test("should return error for empty file path", () async {
      final (error, configMap) = await loadConfig("");
      expect(error, "Configuration file path is empty.");
      expect(configMap, isEmpty);
    });

    test("should return error for non-existent file name", () async {
      final (error, configMap) = await loadConfig("notfound");
      expect(error, "Configuration file not found: 'notfound.yaml'.");
      expect(configMap, isEmpty);
    });

    test("should return error for non-existent file path", () async {
      final (error, configMap) = await loadConfig("/unlikly/notfound");
      expect(error, "Configuration file not found: '/unlikly/notfound.yaml'.");
      expect(configMap, isEmpty);
    });

    test(
      "should load a basic valid config file and parse the name field",
      () async {
        final (error, configMap) = await loadConfig("./test/configs/basic");
        expect(configMap, isNotEmpty);
        final name = configMap["name"];
        expect(name, isA<String>());
        expect(name, "basic");
        expect(error, isEmpty);
      },
    );

    test("should return null for unknown fields", () async {
      /* mabye this test is unnecessary */
      final (error, configMap) = await loadConfig("./test/configs/basic");
      final unkown = configMap["unknown"];
      expect(unkown, isNull);
      expect(error, isEmpty);
    });
  });
}
