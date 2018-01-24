# dioc_generator

A generator of code for [dioc](../dioc) containers.

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

  @Provide(Service, MockService)
  Container development();

  @Provide(Service, WebService)
  Container production();
}
```

To indicate how to inject dependencies, you can also decorate your class fields with `Inject` annotations (and `@inject`, `@singleton` shortcuts).


```dart
class OtherService {
  @inject
  final Service dependency;

  @singleton
  final Service dependency2;

  OtherService(this.dependency,{this.dependency2});
}
```

To trigger code generation, create a `tool/watch.dart` file into your project based on [watch.dart](tool/watch.dart) file and run the `dart tool/watch.dart` command at the root of your project. A `*.g.dart` will be contiously updated next to your bootstrapper.

A [complete example](../example) is also available.


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/aloisdeniel/dioc/issues
