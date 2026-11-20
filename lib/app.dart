import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'projects.dart';
import 'site.dart';

const _external = {'rel': 'noopener noreferrer'};

Component _t(String text) => Component.text(text);

Component _ext(String label, String href, {String? classes, Map<String, String>? attributes}) => a(
  [_t(label)],
  href: href,
  target: Target.blank,
  classes: classes,
  attributes: {..._external, ...?attributes},
);

/// A Weird Brains mention in prose, linked to weirdbrains.com.
Component _wb() => _ext('Weird Brains', weirdBrainsUrl);

String _pad(int n) => n.toString().padLeft(2, '0');

/// The whole site: a hero with a project carousel, then the full directory.
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
          'twitter:card': 'summary_large_image',
          'twitter:title': siteTitle,
          'twitter:description': siteDescription,
          'twitter:image': '$siteUrl/og-image.png',
        },
        children: [
          meta(attributes: {'property': 'og:type'}, content: 'website'),
          meta(attributes: {'property': 'og:site_name'}, content: siteTitle),
          meta(attributes: {'property': 'og:title'}, content: siteTitle),
          meta(attributes: {'property': 'og:description'}, content: siteDescription),
          meta(attributes: {'property': 'og:url'}, content: url),
          meta(attributes: {'property': 'og:image'}, content: '$siteUrl/og-image.png'),
          meta(attributes: {'property': 'og:image:width'}, content: '1200'),
          meta(attributes: {'property': 'og:image:height'}, content: '630'),
          meta(
            attributes: {'property': 'og:image:alt'},
            content: 'Weird Brains open source logo: a brain split into code brackets',
          ),
          link(href: url, rel: 'canonical'),
        ],
      ),
      a([_t('Skip to content')], href: '#content', classes: 'skip-link'),
      _siteHeader(),
      _hero(projects),
      Component.element(
        tag: 'main',
        id: 'content',
        children: [
          _directory(projects),
          _contribute(projects.length),
        ],
      ),
      _siteFooter(),
      script(src: 'carousel.js', defer: true),
    ]);
  }

  Component _brand() => a(
    [
      img(src: 'logo.svg', alt: '', width: 40, height: 40, classes: 'brand-mark'),
      span([
        span([_t('Weird Brains')], classes: 'brand-name'),
        span([_t('Open Source')], classes: 'brand-sub'),
      ], classes: 'brand-text'),
    ],
    href: '#top',
    classes: 'brand',
    attributes: {'aria-label': 'Weird Brains Open Source, back to top'},
  );

  Component _siteHeader() => header([
    div([
      _brand(),
      nav(
        [
          a([_t('Projects')], href: '#projects'),
          a([_t('Contribute')], href: '#contribute', classes: 'hide-sm'),
          _ext('GitHub', orgUrl),
          _ext('weirdbrains.com', weirdBrainsUrl, classes: 'nav-pill'),
        ],
        classes: 'site-nav',
        attributes: {'aria-label': 'Main'},
      ),
    ], classes: 'header-inner wrap'),
  ], classes: 'site-header');

  Component _hero(List<Project> projects) => section(
    [
      div([], classes: 'hero-sky', attributes: {'aria-hidden': 'true'}),
      div([
        div([
          p([
            span([], classes: 'pulse', attributes: {'aria-hidden': 'true'}),
            _t('${projects.length} open source projects'),
          ], classes: 'eyebrow'),
          h1([
            _t('Weird ideas, '),
            span([_t('built in the open.')], classes: 'grad'),
          ], id: 'hero-title'),
          p([
            _t('Every public project from '),
            _wb(),
            _t(
              ' that has a website of its own: browsers, terminals, peer-to-peer crates, data tools and more. '
              'Read the code, run it, and make it weirder.',
            ),
          ], classes: 'lede'),
          div([
            a([_t('Browse all projects')], href: '#projects', classes: 'btn btn-primary'),
            _ext('WeirdBrains on GitHub', orgUrl, classes: 'btn btn-ghost'),
          ], classes: 'hero-actions'),
        ], classes: 'hero-copy'),
        _carousel(projects),
      ], classes: 'hero-grid wrap'),
    ],
    id: 'top',
    classes: 'hero',
    attributes: {'aria-labelledby': 'hero-title'},
  );

  Component _carousel(List<Project> projects) {
    final total = projects.length;
    return section(
      [
        h2([_t('Featured projects')], id: 'carousel-title', classes: 'visually-hidden'),
        div(
          [
            for (var i = 0; i < total; i++) _slide(projects[i], i, total),
          ],
          classes: 'carousel-track',
          id: 'carousel-track',
          attributes: {'tabindex': '0', 'aria-label': 'Project slides, scroll sideways or use the buttons'},
        ),
        div([
          button(
            [
              span([_t('←')], attributes: {'aria-hidden': 'true'}),
            ],
            type: ButtonType.button,
            classes: 'car-btn car-prev',
            attributes: {'aria-label': 'Previous project', 'aria-controls': 'carousel-track'},
          ),
          div(
            [
              for (var i = 0; i < total; i++)
                button(
                  [],
                  type: ButtonType.button,
                  classes: 'car-dot',
                  attributes: {
                    'aria-label': 'Show ${projects[i].name}',
                    'aria-controls': 'carousel-track',
                    'data-index': '$i',
                    if (i == 0) 'aria-current': 'true',
                  },
                ),
            ],
            classes: 'car-dots',
          ),
          button(
            [
              span([_t('→')], attributes: {'aria-hidden': 'true'}),
            ],
            type: ButtonType.button,
            classes: 'car-btn car-next',
            attributes: {'aria-label': 'Next project', 'aria-controls': 'carousel-track'},
          ),
          button(
            [
              span([], classes: 'car-play-icon', attributes: {'aria-hidden': 'true'}),
            ],
            type: ButtonType.button,
            classes: 'car-btn car-play',
            attributes: {'aria-label': 'Pause slideshow', 'aria-pressed': 'false'},
          ),
        ], classes: 'car-controls'),
        p(
          [],
          classes: 'visually-hidden',
          attributes: {'aria-live': 'polite', 'aria-atomic': 'true', 'data-carousel-status': ''},
        ),
      ],
      classes: 'carousel',
      attributes: {
        'aria-roledescription': 'carousel',
        'aria-labelledby': 'carousel-title',
        'data-interval': '6000',
      },
    );
  }

  Component _slide(Project pr, int index, int total) => div(
    [
      a(
        [
          div(
            [
              span([], classes: 'dot'),
              span([], classes: 'dot'),
              span([], classes: 'dot'),
              span([_t(pr.host)], classes: 'frame-url'),
            ],
            classes: 'frame-bar',
            attributes: {'aria-hidden': 'true'},
          ),
          img(
            src: 'images/projects/${pr.slug}.webp',
            alt: 'Screenshot of the ${pr.name} website',
            width: 1200,
            height: 750,
            attributes: {'loading': index == 0 ? 'eager' : 'lazy', 'decoding': 'async'},
          ),
        ],
        href: pr.site,
        target: Target.blank,
        classes: 'slide-shot',
        attributes: {..._external, 'tabindex': '-1', 'aria-hidden': 'true'},
      ),
      div([
        p([
          span([_t('${_pad(index + 1)} / ${_pad(total)}')], classes: 'slide-count'),
          span([_t(pr.kind)], classes: 'kind'),
        ], classes: 'slide-meta'),
        h3([_t(pr.name)]),
        p([_t(pr.blurb)], classes: 'slide-blurb'),
        div([
          _ext('Visit ${pr.host}', pr.site, classes: 'btn btn-primary btn-sm'),
          if (pr.repo != null)
            _ext(
              'Source',
              pr.repo!,
              classes: 'btn btn-ghost btn-sm',
              attributes: {'aria-label': '${pr.name} source on GitHub'},
            ),
        ], classes: 'actions'),
      ], classes: 'slide-info'),
    ],
    classes: 'slide',
    attributes: {
      'role': 'group',
      'aria-roledescription': 'slide',
      'aria-label': '${index + 1} of $total: ${pr.name}',
      'data-index': '$index',
    },
  );

  Component _directory(List<Project> projects) => section(
    [
      div([
        p([_t('The directory')], classes: 'section-eyebrow'),
        h2([_t('Every project, one page')], id: 'projects'),
        p([
          _t(
            'Each card links to the project’s own website and to its source on GitHub. '
            'Most of it is Rust underneath.',
          ),
        ], classes: 'section-intro'),
      ], classes: 'section-head'),
      div([for (var i = 0; i < projects.length; i++) _card(projects[i], i)], classes: 'grid'),
    ],
    classes: 'wrap directory',
    attributes: {'aria-labelledby': 'projects'},
  );

  Component _card(Project pr, int index) => article([
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
      p([
        span([_t(pr.kind)], classes: 'kind'),
        span([_t(_pad(index + 1))], classes: 'card-num', attributes: {'aria-hidden': 'true'}),
      ], classes: 'card-meta'),
      h3([_t(pr.name)]),
      p([_t(pr.blurb)], classes: 'blurb'),
      ul(
        [
          for (final tag in pr.tags) li([_t(tag)], classes: 'badge'),
          if (pr.license != null) li([_t(pr.license!)], classes: 'badge badge-license'),
        ],
        classes: 'badges',
        attributes: {'aria-label': 'Technologies and license'},
      ),
      div([
        _ext(
          'Visit site',
          pr.site,
          classes: 'btn btn-primary btn-sm',
          attributes: {'aria-label': 'Visit the ${pr.name} website, ${pr.host}'},
        ),
        if (pr.repo != null)
          _ext(
            'Source',
            pr.repo!,
            classes: 'btn btn-ghost btn-sm',
            attributes: {'aria-label': '${pr.name} source on GitHub'},
          ),
      ], classes: 'actions'),
    ], classes: 'body'),
  ], classes: 'card');

  Component _contribute(int count) => section(
    [
      div([
        div([
          p([_t('Join in')], classes: 'section-eyebrow'),
          h2([_t('Bring your weird brain')], id: 'contribute'),
          p([
            _t('All $count projects are developed in the open by '),
            _wb(),
            _t(
              '. Open an issue, send a patch, or fork one and make it stranger. '
              'A project is listed here once its repository is public and its website is live.',
            ),
          ], classes: 'section-intro'),
        ], classes: 'cta-copy'),
        div([
          _ext('Explore the GitHub organization', orgUrl, classes: 'btn btn-primary'),
          _ext('Source for this site', repoUrl, classes: 'btn btn-ghost'),
        ], classes: 'cta-actions'),
      ], classes: 'cta'),
    ],
    classes: 'wrap contribute',
    attributes: {'aria-labelledby': 'contribute'},
  );

  Component _siteFooter() => footer([
    div([
      div([
        img(src: 'logo.svg', alt: '', width: 48, height: 48, classes: 'footer-mark'),
        div([
          p([_ext('A Weird Brains project', weirdBrainsUrl, classes: 'footer-wb')]),
          p([_t(siteTagline)], classes: 'footer-tagline'),
        ]),
      ], classes: 'footer-brand'),
      nav(
        [
          a([_t('Projects')], href: '#projects'),
          a([_t('Contribute')], href: '#contribute'),
          _ext('GitHub', orgUrl),
          _ext('weirdbrains.com', weirdBrainsUrl),
        ],
        classes: 'footer-nav',
        attributes: {'aria-label': 'Footer'},
      ),
      div([
        p([
          _ext('© $copyrightYear Weird Brains LLC', weirdBrainsUrl),
          _t('. Site source on '),
          _ext('GitHub', repoUrl),
          _t(' under the BSD 3-Clause License.'),
        ]),
        p([_t('Set in Space Grotesk and Inter, self-hosted under the SIL Open Font License.')], classes: 'footer-fine'),
      ], classes: 'footer-legal'),
    ], classes: 'footer-inner wrap'),
  ], classes: 'site-footer');
}
