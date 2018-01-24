library example;

import 'dart:async';
import 'package:dioc/src/built_container.dart';
import 'package:dioc/src/container.dart';

part "example.g.dart";

abstract class Service {
  Future<String> getContent(String id);
}

class MockService implements Service {
  @override
  Future<String> getContent(String id) async => "TEST";
}


class OtherService {
  @Inject.named("test", mode: InjectMode.create)
  final Service dependency;

  @inject
  final Service dependency2;

  OtherService(this.dependency,{this.dependency2});
}


class WebService implements Service {
  @override
  Future<String> getContent(String id) async => "TEST";
}

@bootsrapper
@Provide.implemented(OtherService)
abstract class AppBootsrapper extends Bootsrapper {
  @Provide(Service, MockService)
  Container development();

  @Provide(Service, WebService)
  Container production();
}