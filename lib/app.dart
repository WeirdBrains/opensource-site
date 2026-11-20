import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'projects.dart';
import 'site.dart';

const _external = {'rel': 'noopener noreferrer'};

Component _ext(String label, String href, {String? classes}) =>
    a([Component.text(label)], href: href, target: Target.blank, classes: classes, attributes: _external);

/// The whole site: one page with a card per project.
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    final projects = loadProjects();
    const url = '$siteUrl/';
    return Component.fragment([
      Document.head(
        title: siteTitle,
        meta: {
          'description': siteDescription,
          'twitter:card': 'summary',
          'twitter:title': siteTitle,
          'twitter:description': siteDescription,
        },
        children: [
          meta(attributes: {'property': 'og:type'}, content: 'website'),
          meta(attributes: {'property': 'og:site_name'}, content: siteTitle),
          meta(attributes: {'property': 'og:title'}, content: siteTitle),
          meta(attributes: {'property': 'og:description'}, content: siteDescription),
          meta(attributes: {'property': 'og:url'}, content: url),
          link(href: url, rel: 'canonical'),
        ],
      ),
      a([Component.text('Skip to content')], href: '#content', classes: 'skip-link'),
      header([
        div([
          _ext('Weird Brains', weirdBrainsUrl, classes: 'logo'),
          nav([
            a([Component.text('Projects')], href: '#projects'),
            _ext('GitHub', orgUrl),
            _ext('weirdbrains.com', weirdBrainsUrl),
          ], classes: 'site-nav'),
        ], classes: 'header-inner wrap'),
      ], classes: 'site-header'),
      Component.element(
        tag: 'main',
        id: 'content',
        children: [
          section([
            p([Component.text('Open source')], classes: 'eyebrow'),
            h1([Component.text('Open source from Weird Brains')]),
            p([
              Component.text('The public projects from '),
              _ext('Weird Brains', weirdBrainsUrl),
              Component.text(' that have a website of their own. Each card links to the project’s site and its source.'),
            ], classes: 'lede'),
          ], classes: 'hero wrap'),
          section([
            h2([Component.text('Projects')], id: 'projects'),
            div([for (final item in projects) _card(item)], classes: 'grid'),
          ], classes: 'wrap projects'),
        ],
      ),
      footer([
        div([
          p([
            _ext('A Weird Brains project', weirdBrainsUrl),
            Component.text('. Source for this site is on '),
            _ext('GitHub', repoUrl),
            Component.text(', released under the BSD 3-Clause License.'),
          ]),
        ], classes: 'footer-inner wrap'),
      ], classes: 'site-footer'),
    ]);
  }

  Component _card(Project pr) {
    return article([
      a(
        [
          img(
            src: 'images/projects/${pr.slug}.webp',
            alt: 'Screenshot of the ${pr.name} website, ${pr.host}',
            width: 1200,
            height: 750,
            attributes: {'loading': 'lazy', 'decoding': 'async'},
          ),
        ],
        href: pr.site,
        target: Target.blank,
        classes: 'shot',
        attributes: {..._external, 'tabindex': '-1', 'aria-hidden': 'true'},
      ),
      div([
        p([Component.text(pr.kind)], classes: 'kind'),
        h3([Component.text(pr.name)]),
        p([Component.text(pr.blurb)], classes: 'blurb'),
        div([
          _ext('Visit ${pr.host}', pr.site, classes: 'btn'),
          if (pr.repo != null) _ext('Source', pr.repo!, classes: 'btn btn-ghost'),
        ], classes: 'actions'),
      ], classes: 'body'),
    ], classes: 'card');
  }
}
