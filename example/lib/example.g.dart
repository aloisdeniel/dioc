// GENERATED CODE - DO NOT MODIFY BY HAND

part of example;

// **************************************************************************
// Generator: BootstrapperGenerator
// **************************************************************************

// Instance of 'AnnotatedElement'
// Instance of 'AnnotatedElement'
// provider: Instance of 'AnnotatedElement'
class _AppBootsrapper extends AppBootsrapper {
  Container base() {
    final container = new Container();
    container.register(
        OtherService, (c) => new OtherService(c.create(Service, name: 'test')));
    return container;
  }

  Container development() {
    final container = this.base();
    container.register(Service, (c) => new MockService());
    return container;
  }

  Container production() {
    final container = this.base();
    container.register(Service, (c) => new WebService());
    return container;
  }
}

class AppBootsrapperBuilder {
  static final _AppBootsrapper instance = build();

  static _AppBootsrapper build() {
    return new _AppBootsrapper();
  }
}
