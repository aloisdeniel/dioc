import 'package:dioc/dioc.dart';

class Inject {
  final String name;
  final String creator;
  final InjectMode mode;
  const Inject({
    this.name,
    this.creator,
    this.mode = InjectMode.singleton,
  });
}

class Provide {
  final String name;
  final String creator;
  final Type abstraction;
  final Type implementation;
  final InjectMode defaultMode;
  const Provide.implemented(
    this.abstraction, {
    this.name,
    this.creator,
    this.defaultMode = InjectMode.unspecified,
  }) : implementation = abstraction;
  const Provide(
    this.abstraction,
    this.implementation, {
    this.name,
    this.creator,
    this.defaultMode = InjectMode.unspecified,
  });
}

class Bootstrapper {
  const Bootstrapper();
}

const inject = Inject();

const singleton = Inject(mode: InjectMode.singleton);

const bootstrapper = Bootstrapper();
