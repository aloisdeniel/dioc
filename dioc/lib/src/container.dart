/// An instance factory of a given type.
typedef dynamic Factory(Container container);

/// A container that stores how to build objects.
class Container {
  /// All factories for creating instances.
  Map<Type,Map<String, Factory>> _factories = new Map<Type,Map<String, Factory>>();

  /// All global instances.
  Map<Type,Map<String, dynamic>> _instances = new Map<Type,Map<String, dynamic>>();

  /// Registers a [factory] that describes how to build an instance of a
  /// given [T].
  void register(Type type, Factory factory, {String name = null}) {
    final map = this._factories.putIfAbsent(type, () => new Map<String,Factory>());
    map[name] = factory;
  }

  /// Gets the global instance of [type] with given [name]. It creates an instance at first call and
  /// then returns it each time it is requested.
  dynamic singleton(Type type, {String name = null}) {
    final map = this._instances.putIfAbsent(type, () => new Map<String,dynamic>());
    return map.putIfAbsent(name, () => this.create(type, name: name));
  }

  /// Creates an instance of [type] through the registered factory.
  dynamic create(Type type, {String name = null}) {
    final map = _factories[type];

    if(map == null)
      throw("No factory found for type $type");

    final factory = map[name];

    if(factory == null)
      throw("No factory found for type $type with name $name");

    return factory(this);
  }

  /// Indicates whether this container can build an instance of [type].
  bool has(Type type, {String name = null}) {

    final map = _factories[type];

    if(map == null)
      return false;

    return map.containsKey(name);
  }
}