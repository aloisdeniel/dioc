import 'dart:async';

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:dioc/src/built_container.dart';
import 'dart:mirrors';

class BootstrapperGenerator extends Generator {
  final bool forClasses, forLibrary;

  const BootstrapperGenerator({this.forClasses: true, this.forLibrary: false});


  @override
  Future<String> generate(LibraryReader library, _) async {

    var output = new StringBuffer();

    final providers = library.annotatedWith(const TypeChecker.fromRuntime(Provide));
    final bootsrappers = library.annotatedWith(const TypeChecker.fromRuntime(Bootsrapper));

    final classes = <Class>[];

    bootsrappers.forEach((bootsrapper) {

      final element = bootsrapper.element;

      if(element is ClassElement) {

        final bootstrapperClassBuilder = new ClassBuilder()
          ..name = "_${element.name}"
          ..extend = refer(element.name, element.librarySource.uri.toString());

        // Default environment
        final defaultProviders = providers.where((p) => p.element == element)
            .toList();
        bootstrapperClassBuilder.methods.add(
            _generateEnvironmentMethod("base", true, defaultProviders));

        // Environments
        element.methods.forEach((method) {
          if (method.returnType.name != "Container")
            throw("A bootstrapper must have only method with a Container returnType");
          final methodProviders = const TypeChecker.fromRuntime(Provide)
                                                   .annotationsOf(method)
                                                   .map((c) => new AnnotatedElement(new ConstantReader(c), element));
          bootstrapperClassBuilder.methods.add(
              _generateEnvironmentMethod(method.name, false, methodProviders));
        });

        classes.add(bootstrapperClassBuilder.build());

        // Builder class
        final bootstrapperBuilderClassBuilder = new ClassBuilder()
          ..name = "${element.name}Builder";

        bootstrapperBuilderClassBuilder.fields.add(new Field((b) => b
          ..name = "instance"
          ..static = true
          ..modifier = FieldModifier.final$
          ..type = refer("_${element.name}")
          ..assignment = new Code("build()")
        ));

        bootstrapperBuilderClassBuilder.methods.add(new Method((b) => b
          ..name = "build"
          ..static = true
          ..returns = refer("_${element.name}")
          ..body = new Code("return new _AppBootsrapper();")
        ));

        classes.add(bootstrapperBuilderClassBuilder.build());
      }
    });

    // Outputs code for each method

    final emitter = new DartEmitter();
    classes.forEach((c) {
      output.writeln(new DartFormatter().format(
          '${c.accept(emitter)}'));
    });
    return '$output';
  }

  Method _generateEnvironmentMethod(String name, bool createContainer, List<AnnotatedElement> providers) {

    var code = new BlockBuilder();

    if(createContainer) {
      code.statements.add(new Code("final container = new Container();"));
    }
    else {
      code.statements.add(new Code("final container = this.base();"));
    }

    providers.forEach((provide) {
      var annotation = provide.annotation.objectValue;
      var name = annotation.getField("name").toStringValue();
      DartType abstraction = annotation.getField("abstraction").toTypeValue();
      DartType implementation = annotation.getField("implementation").toTypeValue();
      name = name != null ? ", name: '$name'" : "";

      // Scanning constructor
      final implementationClass = implementation.element.library.getType(implementation.name);

      final parameters = implementationClass.unnamedConstructor.parameters.map((c) => _generateParameter(implementationClass, c)).join(", ");

      code.statements.add(new Code("container.register(${abstraction.name}, (c) => new ${implementation.name}($parameters)$name);"));
    });

    code.statements.add(new Code("return container;"));

    var method = new MethodBuilder()
      ..name = name ?? "base"
      ..returns = refer('Container', 'package:dioc/dioc.dart')
      ..body = code.build();

    return method.build();
  }

  String _generateParameter(ClassElement implementationClass, ParameterElement c) {

    var field = implementationClass.getField(c.name);
    final injectAnnotation = const TypeChecker.fromRuntime(Inject).firstAnnotationOf(field);

    var name = injectAnnotation?.getField("name")?.toStringValue();
    name = name != null ? ", name: '$name'" : "";

    var modeIndex = injectAnnotation?.getField("mode")?.getField("index")?.toIntValue() ?? 0;
    var mode = InjectMode.values[modeIndex].toString().substring(11);

    return (c.parameterKind == ParameterKind.NAMED ? c.name + ": " : "") +  "c.$mode(${c.type.name}$name)";
  }

  @override
  String toString() => 'BootstrapperGenerator';
}