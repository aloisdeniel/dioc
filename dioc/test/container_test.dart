import 'package:dioc/dioc.dart';
import 'package:test/test.dart';

class A {
  final String value;

  A([String value = null]) : value = value ?? "A";
}

class B extends A {
  B([String value = null]) : super(value ?? "B");
}

class C {
  final A a;
  final B b;
  C(this.a, this.b);
}

void main() {
  group('Registration', () {
    Container container;

    setUp(() {
      container = Container();
    });

    test('Registering a basic factory', () {
      expect(container.has<A>(), false);
      container.register<A>((c) => A());
      expect(container.has<A>(), true);
    });

    test('Creating an instance', () {
      container.register<A>((c) => A());
      var a = container.create<A>();
      expect(a.value, "A");
    });

    test('Creating a singleton', () {
      container.register<A>((c) => A());
      var a1 = container.singleton<A>();
      var a2 = container.singleton<A>();
      expect(a1, a2);
    });

    test('Getting a singleton with get', () {
      container.register<A>((c) => A());
      var a1 = container<A>();
      var a2 = container.get<A>();
      expect(a1 == a2, true);
    });

    test('Getting a created instance with get', () {
      container.register<A>((c) => A(), defaultMode: InjectMode.create);
      var a1 = container<A>();
      var a2 = container.get<A>();
      expect(a1 == a2, false);
    });

    test('Creating multiple instances', () {
      container.register<A>((c) => A());
      container.register<B>((c) => B());
      var a = container.create<A>();
      var b = container.create<B>();
      expect(a.value, "A");
      expect(b.value, "B");
    });

    test('Creating named instances', () {
      container.register<A>((c) => A("1"), name: "1");
      container.register<A>((c) => A("2"), name: "2");
      var a1 = container.create<A>(creator: "1");
      var a2 = container.create<A>(creator: "2");
      expect(a1.value, "1");
      expect(a2.value, "2");
    });

    test('Creating dependent services', () {
      container.register<A>((c) => A("1"));
      container.register<A>((c) => A("2"), name: "2");
      container.register<B>((c) => B());
      container.register<C>((c) => C(c.create<A>(), c.create<B>()));
      var c = container.create<C>();
      expect(c.a.value, "1");
      expect(c.b.value, "B");
    });
  });
}
