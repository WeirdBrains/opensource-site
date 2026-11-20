/// The entrypoint for the **server** environment (static pre-rendering).
library;

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'app.dart';
import 'main.server.options.dart';
import 'site.dart';

void main() {
  Jaspr.initializeApp(options: defaultServerOptions);

  runApp(
    Document(
      title: siteTitle,
      lang: 'en',
      base: '/',
      head: [
        meta(name: 'theme-color', content: '#0A0F2C', attributes: {'media': '(prefers-color-scheme: dark)'}),
        meta(name: 'theme-color', content: '#FBF8FF', attributes: {'media': '(prefers-color-scheme: light)'}),
        link(
          href: 'fonts/space-grotesk-latin.woff2',
          rel: 'preload',
          attributes: {'as': 'font', 'type': 'font/woff2', 'crossorigin': ''},
        ),
        link(
          href: 'fonts/inter-latin.woff2',
          rel: 'preload',
          attributes: {'as': 'font', 'type': 'font/woff2', 'crossorigin': ''},
        ),
        link(href: 'styles.css', rel: 'stylesheet'),
        link(href: 'favicon.svg', rel: 'icon', type: 'image/svg+xml'),
        link(href: 'favicon-32.png', rel: 'icon', type: 'image/png', attributes: {'sizes': '32x32'}),
        link(href: 'favicon-16.png', rel: 'icon', type: 'image/png', attributes: {'sizes': '16x16'}),
        link(href: 'favicon.ico', rel: 'icon', attributes: {'sizes': 'any'}),
        link(href: 'apple-touch-icon.png', rel: 'apple-touch-icon'),
      ],
      body: const App(),
    ),
  );
}
