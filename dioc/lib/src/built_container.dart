import 'package:dioc/dioc.dart';

class Inject {
  final String name;
  final String creator;
  final InjectMode mode;
  const Inject({ this.name = null, this.creator = null, this.mode = InjectMode.singleton});
}

class Provide {
  final String name;
  final String creator;
  final Type abstraction;
  final Type implementation;
  final InjectMode defaultMode;
  const Provide.implemented(this.abstraction, { this.name = null, this.creator = null, this.defaultMode = InjectMode.unspecified }) : implementation = abstraction;
  const Provide(this.abstraction, this.implementation, { this.name = null, this.creator = null, this.defaultMode = InjectMode.unspecified });
}

class Bootstrapper {
  const Bootstrapper();
}

const inject = const Inject();

const singleton = const Inject(mode: InjectMode.singleton);

const bootstrapper = const Bootstrapper();