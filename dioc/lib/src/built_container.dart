enum InjectMode {
  singleton,
  create,
}

class Inject {
  final String name;
  final String factory;
  final InjectMode mode;
  const Inject({ this.name = null, this.factory = null, this.mode = InjectMode.create});
}

class Provide {
  final String name;
  final String factory;
  final Type abstraction;
  final Type implementation;
  const Provide.implemented(abstraction, { this.name = null, this.factory = null }) : abstraction = abstraction, implementation = abstraction;
  const Provide(this.abstraction, this.implementation, { this.name = null, this.factory = null });
}

class Bootsrapper {
  const Bootsrapper();
}

const inject = const Inject();

const singleton = const Inject(mode: InjectMode.singleton);

const bootsrapper = const Bootsrapper();