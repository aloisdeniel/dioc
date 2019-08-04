import 'dart:async';
import 'package:build/build.dart';
import 'package:dioc_generator/dioc_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';
import 'package:build_test/build_test.dart';

final String pkgName = 'pkg';

final Builder builder = PartBuilder([BootstrapperGenerator()], ".g.dart");

Future<String> generate(String source) async {
  final srcs = <String, String>{
    '$pkgName|lib/value.dart': source,
  };

  final writer = InMemoryAssetWriter();
  await testBuilder(builder, srcs, rootPackage: pkgName, writer: writer);
  return String.fromCharCodes(
      writer.assets[AssetId(pkgName, 'lib/value.g.dart')] ?? []);
}

void main() {
  group('A group of tests', () {
    setUp(() {});

    test('suggests to import part file', () async {
      expect(await generate('''library example;

import 'dart:async';
import 'package:dioc/src/built_container.dart';
import 'package:dioc/src/container.dart';

abstract class Service {
  Future<String> getContent(String id);
}

class MockService implements Service {
  @override
  Future<String> getContent(String id) async => "TEST";
}


class OtherService {
  @inject
  final Service dependency;

  OtherService(this.dependency);
}


class WebService implements Service {
  @override
  Future<String> getContent(String id) async => "TEST";
}

@bootstrapper
@Provide(OtherService)
abstract class AppBootstrapper extends Bootstrapper {
  @Provide.implemented(Service, MockService)
  Container development();

  @Provide.implemented(Service, WebService)
  Container production();
}'''), contains("1. Import generated part: part 'value.g.dart';"));
    });
  });
}
