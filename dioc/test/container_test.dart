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
      container = new Container();
    });

    test('Registering a basic factory', () {
      expect(container.has(A), false);
      container.register(A, (c) => new A());
      expect(container.has(A), true);
    });

    test('Creating an instance', () {
      container.register(A, (c) => new A());
      A a = container.create(A);
      expect(a.value, "A");
    });

    test('Creating multiple instances', () {
      container.register(A, (c) => new A());
      container.register(B, (c) => new B());
      A a = container.create(A);
      B b = container.create(B);
      expect(a.value, "A");
      expect(b.value, "B");
    });

    test('Creating named instances', () {
      container.register(A, (c) => new A("1"), name: "1");
      container.register(A, (c) => new A("2"), name: "2");
      A a1 = container.create(A, factory: "1");
      A a2 = container.create(A, factory: "2");
      expect(a1.value, "1");
      expect(a2.value, "2");
    });

    test('Creating dependent services', () {
      container.register(A, (c) => new A("1"));
      container.register(A, (c) => new A("2"), name: "2");
      container.register(B, (c) => new B());
      container.register(C, (c) => new C(c.create(A), c.create(B)));
      C c = container.create(C);
      expect(c.a.value, "1");
      expect(c.b.value, "B");
    });
  });
}
