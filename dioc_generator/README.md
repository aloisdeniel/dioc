# dioc_generator

A generator of code for [dioc](https://pub.dartlang.org/packages/dioc) containers.

## Usage

All registrations are made by annotating a partial bootstrapper class.

Various environments could be declared as methods that return a `Container`. You have to decorate these methods with `Provide` annotations to register dependencies.

```dart
library example;

import 'package:dioc/src/container.dart';
import 'package:dioc/src/built_container.dart';

part "example.g.dart";

@bootsrapper
@Provide.implemented(OtherService) // Default registration for all environments
abstract class AppBootsrapper extends Bootsrapper {

  @Provide<Service>(Service, MockService)
  Container development();

  @Provide(Service, WebService)
  Container production();
}
```

To indicate how to inject dependencies, you have two options : specifying a default mode, or declaring specific injections.

For a default inject mode, add it to `Provide` constructor.

```dart
@bootsrapper
@Provide.implemented(OtherService)
abstract class AppBootsrapper extends Bootsrapper {
  @Provide(Service, MockService, defaultMode: InjectMode.singleton)
  Container development();
}
```

Getting an instances and default injections will then use the default mode :

```dart
final service = container<Service>();
```


Decorate your class fields with `Inject` annotations (and `@inject`, `@singleton` shortcuts) to declare specific injections.


```dart
class OtherService {
  @inject
  final Service dependency;

  @singleton
  final Service dependency2;

  OtherService(this.dependency,{this.dependency2});
}
```

To trigger code generation, run the command :

```bash
pub run build_runner build
```

Then simply use the provided builder to create your `Container`.

```dart
final container = AppBootsrapperBuilder.instance.development();
```

A [complete example](https://github.com/aloisdeniel/dioc/tree/master/example) is also available.


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/aloisdeniel/dioc/issues
