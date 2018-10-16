// GENERATED CODE - DO NOT MODIFY BY HAND

part of example;

// **************************************************************************
// BootstrapperGenerator
// **************************************************************************

class _AppBootstrapper extends AppBootstrapper {
  Container base() {
    final container = Container();
    container.register<OtherService>(
        (c) => OtherService(c.create<Service>(),
            dependency2: c.singleton<Service>()),
        defaultMode: InjectMode.unspecified);
    return container;
  }

  Container development() {
    final container = this.base();
    container.register<Service>((c) => MockService(),
        name: 'test', defaultMode: InjectMode.unspecified);
    return container;
  }

  Container production() {
    final container = this.base();
    container.register<Service>((c) => WebService(),
        defaultMode: InjectMode.unspecified);
    return container;
  }
}

class AppBootstrapperBuilder {
  static final _AppBootstrapper instance = build();

  static _AppBootstrapper build() {
    return new _AppBootstrapper();
  }
}
