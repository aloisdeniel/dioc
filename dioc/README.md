# dioc

Inversion of control based on dependency injection through containers.

## Usage

A simple usage example:

```dart
final container = Container();
container.register<Service>((c) => MockService());
container.register<Service>((c) => Controller(c.create(Service)));

final created = container.create<Controller>();
final singleton = container.singleton<Controller>();
```

You can also name registrations if multiple instances or factories of the same type are needed. The default behaviour when registering is `InjectMode.Singleton` (the instance will be resolved on first access and returned on successive calls).

```dart
final container = Container();
container.register<Service>((c) => WebService());
container.register<Service>((c) => MockService(), name : "demo");

final web = container<Service>(); 
final demo = container<Service>(factory: "demo");
```

The default `get` behaviour can be changed at registration time with `defaultMode` :

```dart
final container = Container();
container.register<Service>((c) => WebService(), defaultMode: InjectMode.Create);

final web = container<Service>(); 
final web2 = container<Service>(); // A new instance is created on each call.
```

It is also possible to call explicitely `singleton` or `create` method for a specific resolution.

```dart
final container = Container();
container.register<Service>((c) => WebService());

final web = container.singleton<Service>();
final web2 = container.singleton<Service>();
final web3 = container.create<Service>();
// web == web2 but web != web3
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
