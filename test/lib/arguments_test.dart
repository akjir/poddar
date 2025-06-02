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
      final (error, arguments) = parseAndValidateArguments([]);
      expect(arguments.showHelp, isTrue);
      expect(error, isEmpty);
    });

    test("should return showHelp true for --help", () {
      final (error, arguments) = parseAndValidateArguments(["--help"]);
      expect(arguments.showHelp, isTrue);
      expect(error, isEmpty);
    });

    test("should return error for duplicate --config argument", () {
      final (error, _) = parseAndValidateArguments([
        "--config",
        "path1",
        "--config",
        "path2",
      ]);
      expect(error, "Duplicate option '--config'.");
    });

    test("should return error for missing argument for --config", () {
      final (error, _) = parseAndValidateArguments(["--config"]);
      expect(error, "Missing value for '--config'.");
    });

    test("should correctly parse --config with a value", () {
      final (error, arguments) = parseAndValidateArguments([
        "create",
        "target",
        "--config",
        "myconfig",
      ]);
      expect(arguments.config, "myconfig");
      expect(error, isEmpty);
    });

    test("should return error for unknown option", () {
      final (error, _) = parseAndValidateArguments(["--unknown"]);
      expect(error, "Unknown option '--unknown'.");
    });

    test("should return error for unknown option after --config", () {
      final (error, _) = parseAndValidateArguments([
        "--config",
        "myconfig.yaml",
        "--unknown",
      ]);
      expect(error, "Unknown option '--unknown'.");
    });

    test("should return error for unknown action", () {
      final (error, _) = parseAndValidateArguments(["build"]);
      expect(error, "Unknown action 'build'.");
    });

    test(
      "should return error for missing action when only options are provided",
      () {
        final (error, _) = parseAndValidateArguments(["--config", "myconfig"]);
        expect(error, "Missing action.");
      },
    );

    test("should return a valid action with a single target", () {
      final (error, arguments) = parseAndValidateArguments([
        "CreAte",
        "tArgeT",
      ]);
      expect(arguments.action, "create");
      expect(arguments.targets, equals(["target"]));
      expect(arguments.showHelp, isFalse);
      expect(error, isEmpty);
    });

    test(
      "should return error for missing target when an action is present but no targets",
      () {
        final (error, _) = parseAndValidateArguments(["create"]);
        // action isn't important here
        expect(error, "Missing target.");
      },
    );

    test("should correctly parse multiple targets after an action", () {
      final (error, arguments) = parseAndValidateArguments([
        "update",
        "target1",
        "target2",
        "target3",
      ]);
      expect(arguments.action, "update");
      expect(arguments.targets, equals(["target1", "target2", "target3"]));
      expect(arguments.showHelp, isFalse);
      expect(error, isEmpty);
    });

    test("should correctly parse --config, action, and multiple targets", () {
      final (error, arguments) = parseAndValidateArguments([
        "--config",
        "/path/to/myconfig",
        "recreate",
        "target1",
        "target2",
      ]);
      expect(arguments.config, "/path/to/myconfig");
      expect(arguments.action, "recreate");
      expect(arguments.targets, equals(["target1", "target2"]));
      expect(arguments.showHelp, isFalse);
      expect(error, isEmpty);
    });

    test("should prioritize --help even with other arguments present", () {
      final (error, arguments) = parseAndValidateArguments([
        "--config",
        "myconfig",
        "recreate",
        "target1",
        "--help",
        "target2",
      ]);
      expect(arguments.showHelp, isTrue);
      // When --help is present and there is no other error, other fields
      // should ideally be in their default state or ignored as the help message
      // is the primary output. The current implementation of parseAndValidateArguments
      // returns immediately for --help when parsed.
      expect(arguments.config, isEmpty);
      expect(arguments.action, isEmpty);
      expect(arguments.targets, isEmpty);
      expect(error, isEmpty);
    });

    test(
      "should return error if --config value is another option like --help",
      () {
        final (error, arguments) = parseAndValidateArguments([
          "--config",
          "--help",
        ]);
        expect(
          error,
          "Value for '--config' cannot be an option (e.g., start with '--').",
        );
        expect(arguments.config, isEmpty);
        expect(
          arguments.showHelp,
          isFalse,
        ); // error for --config should be caught first
      },
    );

    test("should correctly parse --dryrun option", () {
      final (error, arguments) = parseAndValidateArguments([
        "--dryrun",
        "create",
        "target",
      ]);
      expect(arguments.dryRun, isTrue);
      expect(arguments.action, "create");
      expect(arguments.targets, equals(["target"]));
      expect(arguments.showHelp, isFalse);
      expect(error, isEmpty);
    });

    test("should correctly parse --dryrun with --config and action", () {
      final (error, arguments) = parseAndValidateArguments([
        "--config",
        "myconfig",
        "--dryrun",
        "update",
        "target1",
      ]);
      expect(arguments.dryRun, isTrue);
      expect(arguments.config, "myconfig");
      expect(arguments.action, "update");
      expect(arguments.targets, equals(["target1"]));
      expect(arguments.showHelp, isFalse);
      expect(error, isEmpty);
    });

    test("should prioritize --help even if --dryrun is present", () {
      final (error, arguments) = parseAndValidateArguments([
        "--dryrun",
        "--help",
        "create", // no error because of missing targets
      ]);
      expect(arguments.showHelp, isTrue);
      expect(
        arguments.dryRun,
        isFalse,
      ); // should be default as --help takes over
      expect(arguments.action, isEmpty);
      expect(arguments.targets, isEmpty);
      expect(error, isEmpty);
    });

    test("should return error for duplicate --dryrun argument", () {
      final (error, _) = parseAndValidateArguments([
        "--dryrun",
        "create",
        "--dryrun",
        "target",
      ]);
      expect(error, "Duplicate option '--dryrun'.");
    });
  });
}
