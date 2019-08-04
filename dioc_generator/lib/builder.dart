import 'package:build/build.dart';

import 'package:dioc_generator/dioc_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder dioc(BuilderOptions _) =>
    SharedPartBuilder([BootstrapperGenerator()], 'dioc');
