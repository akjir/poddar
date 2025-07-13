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
import 'package:poddar/data/app_config.dart';
import 'package:test/test.dart';

void main() {
  group("createAndValidateConfiguration", () {
    test("", () async {
      final arguments = const Arguments(action: "create");
      final (_, appConfigData) = await readAppConfigData(
        "./test/configs/poddar_config_2",
      );
      final (error, configuration) = createAndValidateConfiguration(
        appConfigData,
        arguments,
      );
      expect(configuration.action, "create");
      expect(configuration.dryRun, isTrue);
      expect(configuration.configsPath, "./test/configs/");
      expect(configuration.podsPath, "/pods/");
      expect(error, isEmpty);
    });

    test(
      "should override config dryRun with arguments dryRun if true",
      () async {
        final arguments = const Arguments(dryRun: true);
        final (pcderror, appConfigData) = await readAppConfigData(
          "./test/configs/poddar_config",
        );
        expect(pcderror, "");
        expect(appConfigData.dryRun, isFalse);
        final (error, configuration) = createAndValidateConfiguration(
          appConfigData,
          arguments,
        );
        expect(configuration.dryRun, isTrue);
        expect(error, isEmpty);
      },
    );

    test("should return error for config with an empty group", () async {
      final arguments = const Arguments(dryRun: true);
      final (pcderror, appConfigData) = await readAppConfigData(
        "./test/configs/poddar_config_empty_group",
      );
      expect(pcderror, "");
      final (error, configuration) = createAndValidateConfiguration(
        appConfigData,
        arguments,
      );
      expect(error, "Group 'empty' cannot be emtpy!");
    });

    test("should return error for config with an empty group 2", () async {
      final arguments = const Arguments(dryRun: true);
      final (pcderror, appConfigData) = await readAppConfigData(
        "./test/configs/poddar_config_empty_group_2",
      );
      expect(pcderror, "");
      final (error, configuration) = createAndValidateConfiguration(
        appConfigData,
        arguments,
      );
      expect(error, "Group 'empty' cannot be emtpy!");
    });

    test(
      "should return error when group name already defined as pod",
      () async {
        final arguments = const Arguments(dryRun: true);
        final (pcderror, poddarConfigData) = await readAppConfigData(
          "./test/configs/poddar_config_double_name",
        );
        expect(pcderror, "");
        final (error, configuration) = createAndValidateConfiguration(
          poddarConfigData,
          arguments,
        );
        expect(error, "Group with name 'pod1' already defined as pod!");
      },
    );

    test("should return error when target is not found in config", () async {
      final arguments = const Arguments(targets: ["pod1", "group1", "missing"]);
      final (pcderror, poddarConfigData) = await readAppConfigData(
        "./test/configs/poddar_config_2",
      );
      expect(pcderror, "");
      final (error, configuration) = createAndValidateConfiguration(
        poddarConfigData,
        arguments,
      );
      expect(error, "Target 'missing' not found in config!");
    });

    test(
      "should return correct targets when a target is only defined in a group",
      () async {
        final arguments = const Arguments(targets: ["pod1", "pod3", "pod5"]);
        final (pcderror, poddarConfigData) = await readAppConfigData(
          "./test/configs/poddar_config_2",
        );
        expect(pcderror, "");
        final (error, configuration) = createAndValidateConfiguration(
          poddarConfigData,
          arguments,
        );
        expect(error, "");
        expect(configuration.targets, equals(["pod1", "pod3", "pod5"]));
      },
    );

    test("should return the correct targets list", () async {
      final arguments = const Arguments(targets: ["pod1", "group2", "pod5"]);
      final (pcderror, poddarConfigData) = await readAppConfigData(
        "./test/configs/poddar_config_2",
      );
      expect(pcderror, "");
      final (error, configuration) = createAndValidateConfiguration(
        poddarConfigData,
        arguments,
      );
      expect(error, "");
      expect(
        configuration.targets,
        equals(["pod1", "pod2", "pod3", "pod5", "pod42"]),
      );
    });

    test("pod targets can only be added once", () async {
      final arguments = const Arguments(targets: ["pod1", "pod1", "pod1"]);
      final (pcderror, poddarConfigData) = await readAppConfigData(
        "./test/configs/poddar_config_2",
      );
      expect(pcderror, "");
      final (error, configuration) = createAndValidateConfiguration(
        poddarConfigData,
        arguments,
      );
      expect(error, "");
      expect(configuration.targets, equals(["pod1"]));
    });
  });
}
