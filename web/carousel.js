// Project carousel for the hero. Plain JavaScript, no dependencies.
// Without JavaScript the slides stay a horizontally scrollable, snap-aligned strip.
(function () {
  'use strict';
  var root = document.querySelector('.carousel');
  if (!root) return;
  var track = root.querySelector('.carousel-track');
  var slides = Array.prototype.slice.call(root.querySelectorAll('.slide'));
  var dots = Array.prototype.slice.call(root.querySelectorAll('.car-dot'));
  var prev = root.querySelector('.car-prev');
  var next = root.querySelector('.car-next');
  var play = root.querySelector('.car-play');
  var status = root.querySelector('[data-carousel-status]');
  if (!track || slides.length < 2) return;

  var interval = parseInt(root.getAttribute('data-interval'), 10) || 6000;
  var reduce = window.matchMedia('(prefers-reduced-motion: reduce)');
  var index = 0;
  var timer = null;
  var progressAnim = null;
  var hovered = false;
  var focused = false;
  // People who ask for reduced motion start with the slideshow paused.
  var userPaused = reduce.matches;
  var announceNext = false;
  var lockUntil = 0;

  var progress = document.createElement('div');
  progress.className = 'car-progress';
  progress.setAttribute('aria-hidden', 'true');
  progress.appendChild(document.createElement('span'));
  root.appendChild(progress);
  root.classList.add('is-ready');

  function behavior() { return reduce.matches ? 'auto' : 'smooth'; }

  function render() {
    slides.forEach(function (slide, i) {
      var active = i === index;
      if (active) slide.removeAttribute('aria-hidden'); else slide.setAttribute('aria-hidden', 'true');
      slide.querySelectorAll('.slide-info a').forEach(function (a) {
        if (active) a.removeAttribute('tabindex'); else a.setAttribute('tabindex', '-1');
      });
    });
    dots.forEach(function (dot, i) {
      if (i === index) dot.setAttribute('aria-current', 'true'); else dot.removeAttribute('aria-current');
    });
    if (announceNext && status) {
      status.textContent = slides[index].getAttribute('aria-label');
      announceNext = false;
    }
  }

  function goTo(i, fromUser) {
    var n = slides.length;
    index = ((i % n) + n) % n;
    if (fromUser) announceNext = true;
    lockUntil = Date.now() + (reduce.matches ? 0 : 900);
    track.scrollTo({ left: slides[index].offsetLeft - slides[0].offsetLeft, behavior: behavior() });
    render();
    schedule();
  }

  function playing() { return !userPaused && !hovered && !focused && !document.hidden; }

  function stopProgress() {
    if (progressAnim) { progressAnim.cancel(); progressAnim = null; }
  }

  function schedule() {
    clearTimeout(timer);
    stopProgress();
    root.classList.toggle('is-playing', playing());
    if (!playing()) return;
    var bar = progress.firstChild;
    if (bar.animate && !reduce.matches) {
      progressAnim = bar.animate([{ transform: 'scaleX(0)' }, { transform: 'scaleX(1)' }], { duration: interval, easing: 'linear' });
    }
    timer = setTimeout(function () { goTo(index + 1, false); }, interval);
  }

  function setPaused(p) {
    userPaused = p;
    play.setAttribute('aria-pressed', p ? 'true' : 'false');
    play.setAttribute('aria-label', p ? 'Play slideshow' : 'Pause slideshow');
    schedule();
  }

  // Keep the index in step when people swipe or scroll the strip themselves.
  var scrollFrame = null;
  track.addEventListener('scroll', function () {
    if (Date.now() < lockUntil) return;
    if (scrollFrame) cancelAnimationFrame(scrollFrame);
    scrollFrame = requestAnimationFrame(function () {
      var w = track.clientWidth || 1;
      var i = Math.round(track.scrollLeft / w);
      if (i !== index && i >= 0 && i < slides.length) {
        index = i;
        render();
        schedule();
      }
    });
  }, { passive: true });

  prev.addEventListener('click', function () { goTo(index - 1, true); });
  next.addEventListener('click', function () { goTo(index + 1, true); });
  play.addEventListener('click', function () { setPaused(!userPaused); });
  dots.forEach(function (dot, i) { dot.addEventListener('click', function () { goTo(i, true); }); });

  track.addEventListener('keydown', function (e) {
    if (e.key === 'ArrowRight') { e.preventDefault(); goTo(index + 1, true); }
    else if (e.key === 'ArrowLeft') { e.preventDefault(); goTo(index - 1, true); }
    else if (e.key === 'Home') { e.preventDefault(); goTo(0, true); }
    else if (e.key === 'End') { e.preventDefault(); goTo(slides.length - 1, true); }
  });

  // Pause while a pointer rests on the carousel or focus is inside it.
  root.addEventListener('mouseenter', function () { hovered = true; schedule(); });
  root.addEventListener('mouseleave', function () { hovered = false; schedule(); });
  root.addEventListener('focusin', function () { focused = true; schedule(); });
  root.addEventListener('focusout', function (e) {
    if (!root.contains(e.relatedTarget)) { focused = false; schedule(); }
  });
  // A touch swipe restarts the timer instead of fighting the finger.
  track.addEventListener('touchstart', function () { clearTimeout(timer); stopProgress(); }, { passive: true });
  track.addEventListener('touchend', function () { schedule(); }, { passive: true });
  document.addEventListener('visibilitychange', schedule);

  var onMotionChange = function () { if (reduce.matches) setPaused(true); };
  if (reduce.addEventListener) reduce.addEventListener('change', onMotionChange);
  else if (reduce.addListener) reduce.addListener(onMotionChange);

  setPaused(userPaused);
  render();
})();
