enum InjectMode {
  singleton,
  create,
}

class Inject {
  final String name;
  final InjectMode mode;
  const Inject.named(this.name, { mode = InjectMode.create}) : mode = mode;
  const Inject({ mode = InjectMode.create}) : name = null, mode = mode;
}

class Provide {
  final String name;
  final Type abstraction;
  final Type implementation;
  const Provide(abstraction) : abstraction = abstraction, implementation = abstraction, name = null;
  const Provide.named(this.name, this.abstraction, this.implementation);
  const Provide.implemented(this.abstraction, this.implementation) : name = null;
}

class Bootsrapper {
  const Bootsrapper();
}

const inject = const Inject();

const singleton = const Inject(mode: InjectMode.singleton);

const bootsrapper = const Bootsrapper();