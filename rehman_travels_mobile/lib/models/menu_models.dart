import 'package:json_annotation/json_annotation.dart';

part 'menu_models.g.dart';

@JsonSerializable()
class UmrahMenu {
  final MenuParent parent;
  final List<MenuItem> items;

  UmrahMenu({
    required this.parent,
    required this.items,
  });

  factory UmrahMenu.fromJson(Map<String, dynamic> json) =>
      _$UmrahMenuFromJson(json);
  Map<String, dynamic> toJson() => _$UmrahMenuToJson(this);
}

@JsonSerializable()
class MenuParent {
  final int id;
  final String title;
  final String url;

  MenuParent({
    required this.id,
    required this.title,
    required this.url,
  });

  factory MenuParent.fromJson(Map<String, dynamic> json) =>
      _$MenuParentFromJson(json);
  Map<String, dynamic> toJson() => _$MenuParentToJson(this);
}

@JsonSerializable()
class MenuItem {
  final int id;
  final String title;
  final String url;
  final String type; // 'calculator' or 'content'

  MenuItem({
    required this.id,
    required this.title,
    required this.url,
    required this.type,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);
  Map<String, dynamic> toJson() => _$MenuItemToJson(this);
}
