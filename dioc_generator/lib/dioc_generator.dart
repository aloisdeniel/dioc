import 'dart:async';

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:dioc/dioc.dart';
import 'package:source_gen/source_gen.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:dioc/src/built_container.dart';

class BootstrapperGenerator extends Generator {
  final bool forClasses, forLibrary;

  const BootstrapperGenerator({this.forClasses: true, this.forLibrary: false});

  @override
  Future<String> generate(LibraryReader library, _) async {
    var output = new StringBuffer();

    final bootstrappers = library.annotatedWith(const TypeChecker.fromRuntime(Bootstrapper));

    final classes = <Class>[];

    bootstrappers.forEach((bootstrapper) {
      final element = bootstrapper.element;

      if (element is ClassElement) {
        final bootstrapperClassBuilder = new ClassBuilder()
          ..name = "_${element.name}"
          ..extend = refer(element.name, element.librarySource.uri.toString());

        // Default environment
        final defaultProviders = _findAnnotation(element, Provide);
        ;

        bootstrapperClassBuilder.methods
            .add(_generateEnvironmentMethod("base", true, defaultProviders));

        // Environments
        element.methods.forEach((method) {
          if (method.returnType.name != "Container")
            throw ("A bootstrapper must have only method with a Container returnType");

          final methodProviders = _findAnnotation(method, Provide);
          bootstrapperClassBuilder.methods
              .add(_generateEnvironmentMethod(method.name, false, methodProviders));
        });

        classes.add(bootstrapperClassBuilder.build());

        // Builder class
        final bootstrapperBuilderClassBuilder = new ClassBuilder()..name = "${element.name}Builder";

        bootstrapperBuilderClassBuilder.fields.add(new Field((b) => b
          ..name = "instance"
          ..static = true
          ..modifier = FieldModifier.final$
          ..type = refer("_${element.name}")
          ..assignment = new Code("build()")));

        bootstrapperBuilderClassBuilder.methods.add(new Method((b) => b
          ..name = "build"
          ..static = true
          ..returns = refer("_${element.name}")
          ..body = new Code("return new _${element.name}();")));

        classes.add(bootstrapperBuilderClassBuilder.build());
      }
    });

    // Outputs code for each method

    final emitter = new DartEmitter();
    classes.forEach((c) {
      output.writeln(new DartFormatter().format('${c.accept(emitter)}'));
    });
    return '$output';
  }

  Method _generateEnvironmentMethod(
      String name, bool createContainer, List<AnnotatedElement> providers) {
    var code = new BlockBuilder();

    code.statements
        .add(new Code("final container = ${createContainer ? "Container()" : "this.base()"};"));
    for (var i = 0; i < providers.length; i++) {
      final provide = providers[i];
      var statement = _generateRegistration(provide, i);
      code.statements.add(statement);
    }

    code.statements.add(new Code("return container;"));

    var method = new MethodBuilder()
      ..name = name ?? "base"
      ..returns = refer('Container', 'package:dioc/dioc.dart')
      ..body = code.build();

    return method.build();
  }

  Code _generateRegistration(AnnotatedElement provide, int index) {
    final annotation = provide.annotation.objectValue;
    var name = annotation.getField("name").toStringValue();
    name = name != null ? ", name: '$name'" : "";
    DartType abstraction = annotation.getField("abstraction").toTypeValue();
    DartType implementation = annotation.getField("implementation").toTypeValue();
    if (implementation == null) {
      print('annotation = $annotation');
      return new Code('// TODO: Not found implementation of ${name ?? abstraction?.name}, index of providers = $index');
    }
    // Scanning constructor
    final implementationClass = implementation.element.library.getType(implementation.name);
    final parameters = implementationClass.unnamedConstructor.parameters
        .map((c) => _generateParameter(implementationClass, c))
        .join(", ");

    var modeIndex = annotation?.getField("defaultMode")?.getField("index")?.toIntValue() ?? 0;
    var defaultMode = InjectMode.values[modeIndex].toString().substring(11);

    return new Code(
        "container.register<${abstraction.name}>((c) => ${implementation.name}($parameters)$name, defaultMode: InjectMode.$defaultMode);");
  }

  String _generateParameter(ClassElement implementationClass, ParameterElement c) {
    var field = implementationClass.getField(c.name);
    final injectAnnotation = const TypeChecker.fromRuntime(Inject).firstAnnotationOf(field);

    var name = injectAnnotation?.getField("name")?.toStringValue();
    name = name != null ? "name: '$name'" : "";

    var creator = injectAnnotation?.getField("creator")?.toStringValue();
    creator = creator != null ? (name != "" ? ", " : "") + "creator: '$creator'" : "";

    var modeIndex = injectAnnotation?.getField("mode")?.getField("index")?.toIntValue() ?? 0;
    var mode = modeIndex == 0 ? "get" : InjectMode.values[modeIndex].toString().substring(11);

    return (c.parameterKind == ParameterKind.NAMED ? c.name + ": " : "") +
        "c.$mode<${c.type.name}>($name$creator)";
  }

  List<AnnotatedElement> _findAnnotation(Element element, Type annotation) {
    return new TypeChecker.fromRuntime(annotation)
        .annotationsOf(element)
        .map((c) => new AnnotatedElement(new ConstantReader(c), element))
        .toList();
  }

  @override
  String toString() => 'BootstrapperGenerator';
}
