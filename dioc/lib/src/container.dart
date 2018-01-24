/// An instance factory of a given type.
typedef dynamic Factory(Container container);

/// A dependency container responsible for instantiating objects.
class Container {
  /// All registered factories.
  Map<Type,Map<String, Factory>> _factories = new Map<Type,Map<String, Factory>>();

  /// All global instances.
  Map<Type,Map<String, dynamic>> _singletons = new Map<Type,Map<String, dynamic>>();

  /// Registers a [factory] that describes how to build an instance of a
  /// given [type] and optional [name].
  void register(Type type, Factory factory, {String name = null}) {
    final map = this._factories.putIfAbsent(type, () => new Map<String,Factory>());
    map[name] = factory;
  }

  /// Unregisters the factory for [type] and optional [name].
  void unregister(Type type, {String name = null}) {
    final map = _factories[type];
    map?.remove(name);
  }

  /// Unregisters all factories if [factories] is true and all singletons if [singletons].
  void reset({ bool factories = true, bool singletons = true }) {
    if(factories) _factories = new Map<Type,Map<String, Factory>>();
    if(singletons) _singletons = new Map<Type,Map<String, dynamic>>();
  }

  /// Gets the global instance of [type] with an optional [name]. It creates an instance
  /// at first call and then returns it each time it is requested.
  /// A [factory] name could be precised to use specific registered factory for first
  /// instantiation.
  dynamic singleton(Type type, {String name = null, String factory = null}) {
    final map = this._singletons.putIfAbsent(type, () => new Map<String,dynamic>());
    return map.putIfAbsent(name, () => this.create(type, factory: factory));
  }

  /// Creates a new instance of [type] through the registered factory. A [factory] name could be precised
  /// to use specific registered factory.
  dynamic create(Type type, {String factory = null}) {
    final map = _factories[type];

    if(map == null)
      throw("No factory found for type '$type'");

    final builder = map[factory];

    if(builder == null)
      throw("No factory  with name '$factory' found for type '$type'");

    return builder(this);
  }

  /// Indicates whether this container has a factory for [type] with the given [factory] name.
  bool has(Type type, {String factory = null}) {
    final map = _factories[type];
    return (map != null) && map.containsKey(factory);
  }
}