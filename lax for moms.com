// LaxForMoms — script.js

// Nav scroll shadow
const nav = document.getElementById('nav');
window.addEventListener('scroll', () => {
  nav.classList.toggle('scrolled', window.scrollY > 10);
});

// Mobile nav toggle
const toggle = document.getElementById('navToggle');
const links  = document.getElementById('navLinks');
toggle.addEventListener('click', () => links.classList.toggle('open'));
document.querySelectorAll('.nav-link, .nav-cta').forEach(l =>
  l.addEventListener('click', () => links.classList.remove('open'))
);

// Smooth scroll
document.querySelectorAll('a[href^="#"]').forEach(a => {
  a.addEventListener('click', function(e) {
    const target = document.querySelector(this.getAttribute('href'));
    if (target) {
      e.preventDefault();
      window.scrollTo({ top: target.getBoundingClientRect().top + window.scrollY - 72, behavior: 'smooth' });
    }
  });
});

// Email form
const emailForm = document.getElementById('emailForm');
if (emailForm) {
  emailForm.addEventListener('submit', e => {
    e.preventDefault();
    const email = emailForm.querySelector('input[type="email"]').value;
    if (email) {
      emailForm.innerHTML = `<p style="color:var(--gold);font-family:var(--font-display);font-size:1.2rem;font-style:italic;text-align:center;">✦ You're in — welcome to the inner circle.</p>`;
      // TODO: Connect to Mailchimp, Kit, ConvertKit, etc.
    }
  });
}

// Fade-in on scroll
const io = new IntersectionObserver(entries => {
  entries.forEach(e => {
    if (e.isIntersecting) {
      e.target.style.opacity = '1';
      e.target.style.transform = 'translateY(0)';
    }
  });
}, { threshold: 0.08 });

document.querySelectorAll(
  '.product-card, .blog-card, .zach-card, .teaser-card, .cg-item, .float-badge'
).forEach(el => {
  el.style.opacity = '0';
  el.style.transform = 'translateY(18px)';
  el.style.transition = 'opacity 0.55s ease, transform 0.55s ease';
  io.observe(el);
});

// Product buttons — swap # with real links when ready
document.querySelectorAll('[data-product]').forEach(btn => {
  btn.addEventListener('click', e => {
    const links = {
      'survival-guide': '#', // Replace: https://gumroad.com/l/YOUR-LINK
      'rules-guide':    '#'  // Replace: https://gumroad.com/l/YOUR-LINK
    };
    if (links[btn.dataset.product] === '#') {
      e.preventDefault();
      alert('Shop link coming soon — check back shortly!');
    }
  });
});
