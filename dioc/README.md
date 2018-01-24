# dioc

Inversion of control based on dependency injection through containers.

## Usage

A simple usage example:

```dart
final container = new Container();
container.register(Service, (c) => new MockService());
container.register(Controller, (c) => new Controller(c.create(Service)));

final created = container.create(Controller);
final singleton = container.singleton(Controller);
```

You can also name registrations if multiples instances or factories of the same type are needed.

```dart
final container = new Container();
container.register(Service, (c) => new WebService());
container.register(Service, (c) => new MockService(), name : "demo");

final web = container.create(Service);
final demo = container.create(Service, factory: "demo");
```

It is also possible to have multiple named singleton instances :

```dart
final container = new Container();
container.register(Service, (c) => new WebService());
container.register(Service, (c) => new MockService(), name : "demo");

final web = container.singleton(Service);
final demo = container.singleton(Service, name: "demo", factory: "demo");
```

If you want to reset your container use the `unregister` or `reset` methods.

## Code generation

A [dioc_generator](../dioc_generator) package is also available for simplifying injections based on constructor analysis. 

## Notes

All dependency resolution isn't based on mirrors because it is intended to be used with strong mode.

Currently, the package is intended to be used with Dart 1, but it will be migrated to Dart 2 very soon to use strong typed generics instead.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/aloisdeniel/dioc/issues
