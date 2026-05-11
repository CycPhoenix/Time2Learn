/**
 * Time2Learn â€“ Main JavaScript (External JS)
 *
 * Animation strategy (progressive enhancement):
 *  1. Add 'js-ready' to <body> â†’ CSS hides [data-reveal] elements
 *  2. IntersectionObserver adds '.is-visible' â†’ CSS transitions them in
 *  3. If JS fails â†’ elements stay visible (no opacity:0 orphans)
 *
 * NO dynamic CSS injection. All animation styles live in style.css.
 */

/* =====================================================
   1. PROGRESSIVE ENHANCEMENT â€“ Mark JS as loaded
   ===================================================== */
document.documentElement.classList.add('js');
document.body.classList.add('js-ready');

/* =====================================================
   2. SCROLL REVEAL â€“ IntersectionObserver
      Targets [data-reveal] attributes added in HTML.
      Falls back gracefully if observer unavailable.
   ===================================================== */
(function initScrollReveal() {
  const targets = document.querySelectorAll('[data-reveal]');
  if (!targets.length) return;

  if (!('IntersectionObserver' in window)) {
    // Fallback: just show everything
    targets.forEach(el => el.classList.add('is-visible'));
    return;
  }

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          observer.unobserve(entry.target); // animate once
        }
      });
    },
    { threshold: 0.08, rootMargin: '0px 0px -40px 0px' }
  );

  targets.forEach(el => observer.observe(el));
})();

/* =====================================================
   3. STICKY NAV â€“ add .scrolled class on scroll
   ===================================================== */
(function initStickyNav() {
  const nav = document.querySelector('.nav');
  if (!nav) return;

  const onScroll = () => {
    nav.classList.toggle('scrolled', window.scrollY > 10);
  };

  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll(); // run once on load
})();

/* =====================================================
   4. NAV SEARCH â€“ go to courses on Enter
   ===================================================== */
(function initNavSearch() {
  const input = document.getElementById('navSearch');
  if (!input) return;
  input.addEventListener('keypress', function (e) {
    if (e.key === 'Enter' && this.value.trim()) {
      window.location.href = 'courses.html';
    }
  });
})();


/* =====================================================
   6. FORM VALIDATION UTILITIES
   ===================================================== */
function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim());
}
function isStrongPassword(pw) {
  return pw.length >= 8 && /[0-9]/.test(pw) && /[^A-Za-z0-9]/.test(pw);
}
function showFieldError(inputEl, errorEl, message) {
  if (!inputEl || !errorEl) return;
  inputEl.classList.add('error');
  inputEl.classList.remove('success');
  if (message) errorEl.textContent = message;
  errorEl.style.display = 'block';
  errorEl.classList.add('visible');
}
function showFieldSuccess(inputEl, errorEl) {
  if (!inputEl) return;
  inputEl.classList.remove('error');
  inputEl.classList.add('success');
  if (errorEl) { errorEl.style.display = 'none'; errorEl.classList.remove('visible'); }
}

/* =====================================================
   9. PASSWORD TOGGLE
   ===================================================== */
function togglePassword(id, btn) {
  const input = document.getElementById(id);
  if (!input) return;
  const isPassword = input.type === 'password';
  input.type = isPassword ? 'text' : 'password';
  btn.textContent  = isPassword ? 'ðŸ™ˆ' : 'ðŸ‘';
}

/* =====================================================
  10. PASSWORD STRENGTH METER
   ===================================================== */
function checkStrength(val) {
  const fill  = document.getElementById('strengthFill');
  const label = document.getElementById('strengthLabel');
  if (!fill || !label) return;

  let score = 0;
  if (val.length >= 8)           score++;
  if (/[A-Z]/.test(val))        score++;
  if (/[0-9]/.test(val))        score++;
  if (/[^A-Za-z0-9]/.test(val)) score++;

  const colors = ['', '#ef4444', '#f59e0b', '#3b82f6', '#22c55e'];
  const labels = ['', 'Weak',    'Fair',    'Good',    'Strong' ];

  fill.style.width      = (score * 25) + '%';
  fill.style.background = colors[score] || '';
  label.textContent     = score ? labels[score] : '';
  label.style.color     = colors[score] || '';
}

/* =====================================================
  11. TOAST NOTIFICATION
   ===================================================== */
function showToast(message, type = 'success') {
  const colors = { success: '#22c55e', error: '#ef4444', info: '#3b82f6', warning: '#f59e0b' };
  const toast   = document.createElement('div');
  toast.className  = 'toast';
  toast.textContent = message;
  toast.style.background = colors[type] || colors.success;
  document.body.appendChild(toast);

  // Slide out after 3 s
  setTimeout(() => {
    toast.classList.add('toast--exit');
    setTimeout(() => toast.remove(), 320);
  }, 3000);
}

/* =====================================================
  12. ACTIVE NAV LINK
   ===================================================== */
(function highlightActiveNav() {
  const page = window.location.pathname.split('/').pop() || 'landingpage.html';
  document.querySelectorAll('.nav__link').forEach(link => {
    const href = link.getAttribute('href');
    link.classList.toggle('nav__link--active', href === page);
  });
})();

/* =====================================================
  13. ANIMATED PROGRESS BARS ON PAGE LOAD
      Only for pages that have progress bars.
   ===================================================== */
document.addEventListener('DOMContentLoaded', () => {
  // Store target widths, reset to 0, then animate
  document.querySelectorAll('.progress-bar__fill').forEach(bar => {
    const target = bar.style.width || bar.getAttribute('data-width') || '0%';
    bar.style.width = '0%';
    bar.setAttribute('data-width', target);
    // Will animate via CSS `growWidth` keyframe when `.is-visible` is added,
    // or trigger directly for in-viewport bars
    setTimeout(() => { bar.style.width = target; }, 400);
  });

  // Rating bar fills
  document.querySelectorAll('.rating-bar-row .bar-fill').forEach(fill => {
    const w = fill.style.width;
    fill.style.width = '0%';
    setTimeout(() => { fill.style.width = w; }, 500);
  });
});

/* =====================================================
  14. CURRICULUM ACCORDION
   ===================================================== */
function toggleSection(header) {
  const body = header.nextElementSibling;
  if (!body) return;
  const isOpen = body.style.display !== 'none' && body.style.display !== '';
  body.style.display = isOpen ? 'none' : 'block';
  // Flip chevron text
  const chevronEl = header.querySelector('span:last-child');
  if (chevronEl) {
    chevronEl.textContent = chevronEl.textContent
      .replace(isOpen ? 'â–¾' : 'â–¸', isOpen ? 'â–¸' : 'â–¾');
  }
}
function expandAll() {
  document.querySelectorAll('.curriculum-section__body').forEach(b => b.style.display = 'block');
}

/* =====================================================
  15. TAB SWITCHER (Course detail)
   ===================================================== */
function switchTab(btn, id) {
  document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
  document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
  btn.classList.add('active');
  const panel = document.getElementById('tab-' + id);
  if (panel) panel.classList.add('active');
}

/* =====================================================
  16. WISHLIST TOGGLE
   ===================================================== */
function addToWishlist() {
  const btn = document.querySelector('.course-sticky .btn--outline');
  if (!btn) return;
  btn.textContent      = 'â™¥ Added to Wishlist';
  btn.style.background = 'var(--primary-light)';
  btn.style.color      = 'var(--primary)';
  showToast('Added to your wishlist!', 'success');
}

/* =====================================================
  17. SOCIAL OAUTH PLACEHOLDERS
   ===================================================== */
function socialLogin(provider)  { showToast(provider + ' OAuth â€” connects to auth server in full .NET build', 'info'); }
function socialSignup(provider) { showToast(provider + ' signup â€” connects to auth server in full .NET build', 'info'); }

/* =====================================================
  18. DASHBOARD â€“ Section switcher
   ===================================================== */
function showSection(name) {
  document.querySelectorAll('[id^="section-"]').forEach(s => s.style.display = 'none');
  const section = document.getElementById('section-' + name);
  if (section) { section.style.display = 'block'; section.style.animation = 'fadeUp 0.35s ease both'; }
  document.querySelectorAll('.sidebar__nav-item').forEach(i => i.classList.remove('active'));
  const navItem = document.querySelector(`.sidebar__nav-item[onclick="showSection('${name}')"]`);
  if (navItem) navItem.classList.add('active');
}
function saveProfile() { showToast('Profile saved! (SQL UPDATE in full .NET build)', 'success'); }

/* =====================================================
  19. ADMIN â€“ Section switcher
   ===================================================== */
const adminTitles = {
  overview: 'Dashboard Overview', courses: 'Course Management',
  users: 'User Management', enrollments: 'Enrollment Records',
  reviews: 'Reviews Moderation', settings: 'Site Settings'
};
function showAdminSection(name, el) {
  document.querySelectorAll('[id^="admin-"]').forEach(s => s.style.display = 'none');
  const sec = document.getElementById('admin-' + name);
  if (sec) { sec.style.display = 'block'; sec.style.animation = 'fadeUp 0.3s ease both'; }
  document.querySelectorAll('.admin-nav__item').forEach(i => i.classList.remove('active'));
  if (el) el.classList.add('active');
  const titleEl = document.getElementById('adminPageTitle');
  if (titleEl) titleEl.textContent = adminTitles[name] || name;
}
function openModal(editBtn)     { document.getElementById('courseModal').classList.add('open'); document.getElementById('modalTitle').textContent = editBtn ? 'Edit Course' : 'Add New Course'; }
function closeModal()           { document.getElementById('courseModal').classList.remove('open'); }
function openUserModal(editBtn) { document.getElementById('userModal').classList.add('open'); document.getElementById('userModalTitle').textContent = editBtn ? 'Edit User' : 'Add New User'; }
function closeUserModal()       { document.getElementById('userModal').classList.remove('open'); }
function editUser(btn)          { openUserModal(btn); }
function deleteRow(btn) {
  if (confirm('Delete this record?')) {
    btn.closest('tr').style.animation = 'fadeIn 0.3s ease reverse forwards';
    setTimeout(() => { btn.closest('tr').remove(); showToast('Record deleted (SQL DELETE in full .NET build)', 'success'); }, 280);
  }
}

/* =====================================================
  20. DEV CONSOLE INFO
   ===================================================== */
console.info('%cTime2Learn', 'font-size:20px;font-weight:800;color:#a435f0;letter-spacing:-0.02em;');
console.info('%cCT050-3-2-WAPP | HTML5 Â· CSS3 Â· JavaScript Â· ASP.NET Framework', 'color:#6a6f73;font-size:11px;');
/* =====================================================
  21. CART -- localStorage-backed cart state
   ===================================================== */
function addToCart(course) {
  var cart = [];
  try { cart = JSON.parse(localStorage.getItem('t2l_cart') || '[]'); } catch(e) {}
  var exists = cart.some(function(c) { return c.id === course.id; });
  if (!exists) { cart.push(course); localStorage.setItem('t2l_cart', JSON.stringify(cart)); }
  updateCartBadge();
}

function updateCartBadge() {
  var cart = [];
  try { cart = JSON.parse(localStorage.getItem('t2l_cart') || '[]'); } catch(e) {}
  var count = cart.length;
  document.querySelectorAll('.nav__cart-badge').forEach(function(badge) {
    if (count > 0) {
      badge.textContent = count;
      badge.style.display = 'block';
    } else {
      badge.style.display = 'none';
    }
  });
}

document.addEventListener('DOMContentLoaded', function() {
  updateCartBadge();

  /* =====================================================
    22. HIDE "TEACH ON TIME2LEARN" FOOTER LINK WHEN LOGGED IN
     ===================================================== */
  if (sessionStorage.getItem('t2l_user')) {
    document.querySelectorAll('.footer-wf__links a[href="instructor-registration.html"]')
      .forEach(function(el) { el.style.display = 'none'; });
  }
});

/* =====================================================
   23. DARK MODE TOGGLE
   CSS handles all visual changes via [data-theme="dark"].
   This file is only loaded by: cart, course-detail,
   course-payment, curriculum-coding. For all other pages
   the inline <script> in <head> defines toggleTheme().
   ===================================================== */
function toggleTheme() {
  var next = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
  document.documentElement.setAttribute('data-theme', next);
  localStorage.setItem('t2l_theme', next);
}
