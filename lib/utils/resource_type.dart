class ResourceType {
  static ResourceType image = ResourceType._("img");
  static ResourceType text  = ResourceType._("txt");
  static ResourceType geopoint = ResourceType._("loc");

  static Iterable<ResourceType> get values => [text, image, geopoint];

  String label;
  ResourceType._(this.label);

  static ResourceType fromLabel(String label) {
    for (var t in values) {
      if (t.label == label)
        return t;
    }
    return ResourceType._("unknown");
  }
}