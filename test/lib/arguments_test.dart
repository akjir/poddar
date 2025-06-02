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

import 'package:test/test.dart';
import 'package:poddar/arguments.dart';

void main() {
  group("parseAndValidateArguments", () {
    test("should return showHelp true for no arguments", () {
      final result = parseAndValidateArguments([]);
      expect(result.showHelp, isTrue);
      expect(result.error, isEmpty);
    });

    test("should return showHelp true for --help", () {
      final result = parseAndValidateArguments(["--help"]);
      expect(result.showHelp, isTrue);
      expect(result.error, isEmpty);
    });

    test("should return error for duplicate --config argument", () {
      final result = parseAndValidateArguments([
        "--config",
        "path1",
        "--config",
        "path2",
      ]);
      expect(result.error, "Duplicate argument '--config'.");
    });

    test("should return error for missing argument for --config", () {
      final result = parseAndValidateArguments(["--config"]);
      expect(result.error, "Missing argument for '--config'.");
    });

    test("should correctly parse --config with a value", () {
      final result = parseAndValidateArguments([
        "create",
        "target",
        "--config",
        "myconfig",
      ]);
      expect(result.config, "myconfig");
      expect(result.error, isEmpty);
    });

    test("should return error for unknown argument", () {
      final result = parseAndValidateArguments(["--unknown"]);
      expect(result.error, "Unknown argument '--unknown'.");
    });

    test("should return error for unknown argument", () {
      final result = parseAndValidateArguments([
        "--config",
        "myconfig.yaml",
        "--unknown",
      ]);
      expect(result.error, "Unknown argument '--unknown'.");
    });

    test("should return error for unknown action", () {
      final result = parseAndValidateArguments(["build"]);
      expect(result.error, "Unknown action 'build'.");
    });

    test(
      "should return error for missing action when only options are provided",
      () {
        final result = parseAndValidateArguments(["--config", "myconfig"]);
        expect(result.error, "Missing action.");
      },
    );

    test("should return a valid action with a single target", () {
      final result = parseAndValidateArguments(["CreAte", "tArgeT"]);
      expect(result.action, "create");
      expect(result.targets, equals(["target"]));
      expect(result.error, isEmpty);
      expect(result.showHelp, isFalse);
    });

    test(
      "should return error for missing target when an action is present but no targets",
      () {
        final result = parseAndValidateArguments(["create"]);
        // action isn't important here
        expect(result.error, "Missing target.");
      },
    );

    test("should correctly parse multiple targets after an action", () {
      final result = parseAndValidateArguments([
        "update",
        "target1",
        "target2",
        "target3",
      ]);
      expect(result.action, "update");
      expect(result.targets, equals(["target1", "target2", "target3"]));
      expect(result.error, isEmpty);
      expect(result.showHelp, isFalse);
    });

    test("should correctly parse --config, action, and multiple targets", () {
      final result = parseAndValidateArguments([
        "--config",
        "/path/to/myconfig",
        "recreate",
        "target1",
        "target2",
      ]);
      expect(result.config, "/path/to/myconfig");
      expect(result.action, "recreate");
      expect(result.targets, equals(["target1", "target2"]));
      expect(result.error, isEmpty);
      expect(result.showHelp, isFalse);
    });

    test("should prioritize --help even with other arguments present", () {
      final result = parseAndValidateArguments([
        "--config",
        "config",
        "recreate",
        "target1",
        "--help",
        "target2",
      ]);
      expect(result.showHelp, isTrue);
      // When --help is present and there is no other error, other fields
      // should ideally be in their default state or ignored as the help message
      // is the primary output. The current implementation of parseAndValidateArguments
      // returns immediately for --help when parsed.
      expect(result.error, isEmpty);
      expect(result.config, isEmpty);
      expect(result.action, isEmpty);
      expect(result.targets, isEmpty);
    });

    test(
      "should return error if --config value is another option like --help",
      () {
        final result = parseAndValidateArguments(["--config", "--help"]);
        expect(
          result.error,
          "Value for '--config' cannot be an option (e.g., start with '--').",
        );
        expect(result.config, isEmpty);
        expect(
          result.showHelp,
          isFalse,
        ); // Error for --config should be caught first
      },
    );
  });
}
