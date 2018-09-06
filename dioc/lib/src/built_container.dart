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
  final Type _implementation;
  final Type abstraction;
  Type get implementation => this._implementation ?? this.abstraction;
  final InjectMode defaultMode;
  const Provide.implemented(this.abstraction, { this.name = null, this.creator = null, this.defaultMode = InjectMode.unspecified }) : _implementation = null;
  const Provide(this.abstraction, this._implementation, { this.name = null, this.creator = null, this.defaultMode = InjectMode.unspecified });
}

class Bootsrapper {
  const Bootsrapper();
}

const inject = const Inject();

const singleton = const Inject(mode: InjectMode.singleton);

const bootsrapper = const Bootsrapper();