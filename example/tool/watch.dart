import 'dart:async';

import 'package:build_runner/build_runner.dart';
import 'package:source_gen/source_gen.dart';
import 'package:dioc_generator/bootstrapper_generator.dart';

Future main(List<String> args) async {
  await watch([
    new BuildAction(
        new PartBuilder([
          new BootstrapperGenerator(),
        ]),
        'example',
        inputs: const ['lib/*.dart'])
  ], deleteFilesByDefault: true);
}