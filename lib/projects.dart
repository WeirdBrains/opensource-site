import 'dart:convert';
import 'dart:io';

/// One project in the directory. The list lives in `data/projects.json`.
class Project {
  const Project({
    required this.slug,
    required this.name,
    required this.kind,
    required this.blurb,
    required this.site,
    required this.repo,
    this.tags = const [],
    this.license,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    slug: json['slug'] as String,
    name: json['name'] as String,
    kind: json['kind'] as String,
    blurb: json['blurb'] as String,
    site: json['site'] as String,
    repo: json['repo'] as String?,
    tags: [for (final t in (json['tags'] as List<dynamic>? ?? const [])) t as String],
    license: json['license'] as String?,
  );

  /// Also the screenshot file name: `web/images/projects/<slug>.webp`.
  final String slug;
  final String name;
  final String kind;
  final String blurb;
  final String site;
  final String? repo;

  /// Main languages and technologies, shown as badges.
  final List<String> tags;

  /// SPDX id of the project's license, when the repository has one.
  final String? license;

  /// The host shown on the card, such as `morph.weirdbrains.com`.
  String get host => Uri.parse(site).host;
}

/// Reads `data/projects.json`; runs on the server while pre-rendering.
List<Project> loadProjects() {
  final raw = jsonDecode(File('data/projects.json').readAsStringSync()) as List<dynamic>;
  return [for (final p in raw) Project.fromJson(p as Map<String, dynamic>)];
}
