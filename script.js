const menuButton = document.querySelector('.menu-button');
const nav = document.querySelector('#nav');

const ua = navigator.userAgent || '';
if (/MQQBrowser|QQ\//i.test(ua)) {
  document.documentElement.classList.add('lite');
}

menuButton?.addEventListener('click', () => {
  const open = nav.classList.toggle('open');
  menuButton.setAttribute('aria-expanded', String(open));
});

document.querySelectorAll('#nav a').forEach((link) => {
  link.addEventListener('click', () => {
    nav.classList.remove('open');
    menuButton?.setAttribute('aria-expanded', 'false');
  });
});

document.querySelector('#year').textContent = new Date().getFullYear();

const navLinks = Array.from(document.querySelectorAll('#nav a[href^="#"]'));
const sections = navLinks
  .map((link) => document.querySelector(link.getAttribute('href')))
  .filter(Boolean);

function updateActiveNav() {
  const pos = window.scrollY + 120;
  let current = sections[0];
  for (const section of sections) {
    if (section.offsetTop <= pos) current = section;
  }
  const id = current ? `#${current.id}` : '';
  navLinks.forEach((link) => {
    link.classList.toggle('active', link.getAttribute('href') === id);
  });
}

window.addEventListener('scroll', updateActiveNav, { passive: true });
window.addEventListener('resize', updateActiveNav);
updateActiveNav();

const revealEls = document.querySelectorAll('.section');
if ('IntersectionObserver' in window && revealEls.length) {
  revealEls.forEach((el) => el.classList.add('js-reveal'));
  const io = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('revealed');
          io.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.12 }
  );
  revealEls.forEach((el) => io.observe(el));
}

