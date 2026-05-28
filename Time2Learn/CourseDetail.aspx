<%@ Page Title="Course Detial - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CourseDetail.aspx.cs" Inherits="Time2Learn.CourseDetail" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Tab bar */
        .tab-bar { display:flex;gap:0;border-bottom:2px solid var(--border);margin-bottom:32px; }
        .tab-btn { padding:12px 22px;font-weight:600;font-size:0.95rem;cursor:pointer;border-bottom:3px solid transparent;margin-bottom:-2px;color:var(--text-light);transition:var(--t-fast);background:none;border-top:none;border-left:none;border-right:none; }
        .tab-btn.active,.tab-btn:hover { color:var(--primary);border-bottom-color:var(--primary); }
        .tab-panel { display:none; }
        .tab-panel.active { display:block; }

        /* What you'll learn */
        .what-learn { display:grid;grid-template-columns:1fr 1fr;gap:10px;background:var(--bg-light);border:1px solid var(--border);border-radius:var(--radius);padding:24px;margin-bottom:32px; }
        .learn-item { display:flex;align-items:flex-start;gap:10px;font-size:0.9rem; }
        .learn-item::before { content:'✓';color:#22c55e;font-weight:800;font-size:1rem;flex-shrink:0;margin-top:1px; }

        /* Requirements */
        .requirements { padding-left:20px; }
        .requirements li { margin-bottom:8px;font-size:0.92rem;color:var(--text-mid);list-style:disc; }

        /* Review cards */
        .review-summary { display:flex;align-items:center;gap:32px;margin-bottom:28px;padding:24px;background:var(--bg-light);border-radius:var(--radius);border:1px solid var(--border); }
        .review-summary__score { text-align:center;flex-shrink:0; }
        .review-summary__num { font-size:3.5rem;font-weight:800;color:var(--text-dark);line-height:1; }
        .review-summary__stars { color:#f59e0b;font-size:1.2rem;margin:4px 0; }
        .review-summary__count { font-size:0.82rem;color:var(--text-light); }
        .review-bars { flex:1; }
        .review-bar { display:flex;align-items:center;gap:10px;margin-bottom:6px;font-size:0.85rem; }
        .review-bar__label { width:10px;text-align:right;flex-shrink:0;color:var(--text-mid); }
        .review-bar__track { flex:1;height:8px;background:var(--border);border-radius:4px;overflow:hidden; }
        .review-bar__fill { height:100%;background:#f59e0b;border-radius:4px; }
        .review-bar__count { width:20px;flex-shrink:0;color:var(--text-light);font-size:0.8rem; }
        .review-list { display:flex;flex-direction:column;gap:20px;margin-top:8px; }
        .review-card { padding:20px;border:1px solid var(--border);border-radius:var(--radius);background:white; }
        .review-card__top { display:flex;align-items:center;gap:14px;margin-bottom:12px; }
        .review-avatar { width:42px;height:42px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.82rem;font-weight:700;color:white;flex-shrink:0; }
        .review-card__name { font-weight:700;font-size:0.92rem;margin-bottom:3px;color:var(--text-dark); }
        .review-card__stars { font-size:0.95rem;line-height:1; }
        .star--filled { color:#f59e0b; }
        .star--empty { color:var(--border); }
        .review-card__text { font-size:0.9rem;color:var(--text-mid);line-height:1.65;margin:0; }

        /* Write review */
        .write-review { margin-top:32px;padding:28px;border:1.5px solid var(--border);border-radius:var(--radius);background:white; }
        .write-review__title { font-size:1rem;font-weight:700;margin-bottom:18px;color:var(--text-dark); }
        .review-form__label { display:block;font-size:0.85rem;font-weight:600;color:var(--text-mid);margin-bottom:8px; }
        .star-picker { display:flex;gap:6px;margin-bottom:16px;font-size:2rem;cursor:pointer; }
        .star-picker__star { color:var(--border);transition:var(--t-fast); }
        .star-picker__star.active { color:#f59e0b; }
        .review-form__textarea { width:100%;padding:12px 16px;border:1.5px solid var(--border);border-radius:var(--radius);font-size:0.92rem;line-height:1.6;resize:vertical;min-height:100px;font-family:inherit;margin-bottom:16px; }
        .review-form__textarea:focus { outline:none;border-color:var(--primary); }
        .review-form__actions { display:flex;justify-content:flex-end; }

        /* Back bar */
        .admin-back-bar { background:#f0f2f5;border-bottom:1px solid var(--border);padding:10px 0; }
        .admin-back-bar a { display:inline-flex;align-items:center;gap:6px;font-size:0.88rem;font-weight:600;color:var(--primary);text-decoration:none;transition:var(--t-fast); }
        .admin-back-bar a:hover { color:var(--primary-dark); }

        /* Lesson list */
        .lesson-list { list-style:none;margin:0;padding:0; }
        .lesson-list li { display:flex;align-items:center;gap:12px;padding:12px 0;border-bottom:1px solid var(--border);font-size:0.9rem; }
        .lesson-list li:last-child { border-bottom:none; }
        .lesson-icon { width:32px;height:32px;border-radius:50%;background:var(--bg-light);display:flex;align-items:center;justify-content:center;font-size:0.9rem;flex-shrink:0; }

        .empty-state { padding:32px 0;color:var(--text-light);font-size:0.9rem; }

        /* Dark mode */
        [data-theme="dark"] .admin-back-bar { background:#1c1d1f; border-color:#333; }
        [data-theme="dark"] .what-learn { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .review-summary { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .review-summary__num { color:#fff; }
        [data-theme="dark"] .review-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .review-card__name { color:#fff; }
        [data-theme="dark"] .write-review { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .write-review__title { color:#fff; }
        [data-theme="dark"] .review-form__textarea { background:#1c1d1f; border-color:#444; color:#fff; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Back Bar -->
    <div class="admin-back-bar" id="adminBackBar" style="display:none;">
        <div class="container">
            <a href="#" id="adminBackLink">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="15 18 9 12 15 6"/></svg>
                <span id="adminBackLabel">Back</span>
            </a>
        </div>
    </div>

    <!-- Course Hero -->
    <div class="course-hero">
        <div class="container">
            <div class="course-hero__inner">
                <div class="course-hero__info">
                    <div class="course-hero__breadcrumb">
                        <a href="Courses.aspx">Courses</a> / <asp:Literal ID="litCatName" runat="server" />
                    </div>
                    <div class="course-hero__badge-row" style="margin-bottom:10px;">
                        <span style="font-size:0.78rem;color:#c084fc;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;"><asp:Literal ID="litCatName2" runat="server" /></span>
                    </div>
                    <h1><asp:Literal ID="litTitle" runat="server" /></h1>
                    <p class="course-hero__subtitle"><asp:Literal ID="litDesc" runat="server" /></p>
                    <div class="course-hero__badges">
                        <span class="course-hero__badge">🌐 English</span>
                        <span class="course-hero__badge">♾️ Lifetime Access</span>
                        <span class="course-hero__badge">📊 <asp:Literal ID="litLevel" runat="server" /></span>
                    </div>
                    <div class="course-hero__rating">
                        <span class="course-hero__stars" style="color:#f59e0b;">★★★★★</span>
                        <strong style="color:#f59e0b;margin-left:4px;"><asp:Literal ID="litRating" runat="server" /></strong>
                        <span style="font-size:0.85rem;color:#aaa;">· <asp:Literal ID="litEnrollCount" runat="server" /> students</span>
                    </div>
                    <p class="course-hero__instructor">Created by <asp:Literal ID="litInstructor" runat="server" /></p>
                </div>

                <!-- Sticky Card -->
                <div class="course-sticky">
                    <div class="course-sticky__video">
                        <div class="course-sticky__play" onclick="showToast('Video preview will be available in the full build.', 'info')">
                            <svg viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg>
                        </div>
                        <div style="position:absolute;bottom:12px;left:0;right:0;text-align:center;color:white;font-size:0.8rem;">▶ Preview this course</div>
                    </div>
                    <div class="course-sticky__body">
                        <div class="course-sticky__price">RM <asp:Literal ID="litPrice" runat="server" /></div>
                        <div class="course-sticky__meta" style="margin-bottom:14px;">
                            <span>📜 Certificate of completion</span>
                            <span>♾️ Full lifetime access</span>
                            <span>📱 Access on mobile &amp; desktop</span>
                        </div>
                        <asp:Panel ID="pnlEnrolled" runat="server" Visible="false">
                            <div style="background:#d1fae5;border-radius:var(--radius);padding:12px 16px;text-align:center;font-size:0.88rem;font-weight:600;color:#065f46;margin-bottom:10px;">✓ Already Enrolled</div>
                            <a href="#" id="aContinue" runat="server" class="btn btn--primary btn--full">Continue Learning</a>
                        </asp:Panel>
                        <asp:Panel ID="pnlNotEnrolled" runat="server">
                            <asp:Button ID="btnEnrollNow" runat="server" Text="Enrol Now" CssClass="btn btn--primary btn--full btn--lg" OnClick="btnEnrollNow_Click" style="margin-bottom:10px;" />
                            <asp:Button ID="btnAddCart" runat="server" Text="Add to Cart" CssClass="btn btn--outline btn--full" OnClick="btnAddCart_Click" />
                        </asp:Panel>
                        <asp:Label ID="lblMsg" runat="server" style="font-size:0.85rem;margin-top:8px;display:block;" />
                        <div style="text-align:center;margin-top:12px;">
                            <a href="#" style="font-size:0.8rem;color:var(--text-light);">30-Day Money-Back Guarantee</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Course Content -->
    <div class="container" style="padding-top:40px;padding-bottom:60px;">
        <div style="max-width:780px;">

            <!-- Tabs -->
            <div class="tab-bar">
                <button type="button" class="tab-btn active" onclick="switchTab(this,'overview')">Overview</button>
                <button type="button" class="tab-btn" onclick="switchTab(this,'curriculum')">Curriculum</button>
                <button type="button" class="tab-btn" onclick="switchTab(this,'reviews')">Reviews</button>
            </div>

            <!-- Overview Tab -->
            <div class="tab-panel active" id="tab-overview">
                <h2 style="margin-bottom:20px;">What you'll learn</h2>
                <div class="what-learn">
                    <div class="learn-item">Write programs from scratch with confidence</div>
                    <div class="learn-item">Understand core programming concepts</div>
                    <div class="learn-item">Apply Object-Oriented Programming principles</div>
                    <div class="learn-item">Work with files, data, and external APIs</div>
                    <div class="learn-item">Build and deploy real-world projects</div>
                    <div class="learn-item">Use popular libraries and frameworks</div>
                    <div class="learn-item">Connect to databases professionally</div>
                    <div class="learn-item">Debug and test applications</div>
                </div>

                <h3 style="margin-bottom:14px;">Requirements</h3>
                <ul class="requirements">
                    <li>A computer with internet access (Windows, Mac, or Linux)</li>
                    <li>No prior experience needed — we start from scratch</li>
                    <li>Motivation to learn and practice regularly</li>
                </ul>

                <div class="divider"></div>

                <h3 style="margin-bottom:14px;">Course Description</h3>
                <p>This course is designed for learners at all levels. You'll build real projects and gain hands-on experience that prepares you for the real world.</p>
            </div>

            <!-- Curriculum Tab -->
            <div class="tab-panel" id="tab-curriculum">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;">
                    <div><strong><asp:Literal ID="litLessonCount" runat="server" /> lessons</strong></div>
                    <button type="button" onclick="expandAll()" style="color:var(--primary);font-weight:600;font-size:0.9rem;background:none;border:none;cursor:pointer;">Expand All</button>
                </div>

                <div class="curriculum">
                    <div class="curriculum-section">
                        <div class="curriculum-section__header" onclick="toggleSection(this)">
                            <span>Course Lessons</span>
                            <span style="font-size:0.82rem;color:var(--text-light);">▾</span>
                        </div>
                        <div class="curriculum-section__body">
                            <ul class="lesson-list">
                                <asp:Repeater ID="rptLessons" runat="server">
                                    <ItemTemplate>
                                        <li>
                                            <div class="lesson-icon">▶</div>
                                            <span><%# Eval("LessonTitle") %></span>
                                        </li>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </ul>
                            <asp:Panel ID="pnlNoLessons" runat="server" Visible="false">
                                <div class="empty-state">No lessons added yet.</div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Reviews Tab -->
            <div class="tab-panel" id="tab-reviews">

                <!-- Rating summary -->
                <div class="review-summary">
                    <div class="review-summary__score">
                        <div class="review-summary__num" id="ratingDisplay">4.5</div>
                        <div class="review-summary__stars">★★★★★</div>
                        <div class="review-summary__count">Course Rating</div>
                    </div>
                    <div class="review-bars">
                        <div class="review-bar"><span class="review-bar__label">5</span><div class="review-bar__track"><div class="review-bar__fill" style="width:70%;"></div></div><span class="review-bar__count"></span></div>
                        <div class="review-bar"><span class="review-bar__label">4</span><div class="review-bar__track"><div class="review-bar__fill" style="width:20%;"></div></div><span class="review-bar__count"></span></div>
                        <div class="review-bar"><span class="review-bar__label">3</span><div class="review-bar__track"><div class="review-bar__fill" style="width:7%;"></div></div><span class="review-bar__count"></span></div>
                        <div class="review-bar"><span class="review-bar__label">2</span><div class="review-bar__track"><div class="review-bar__fill" style="width:2%;"></div></div><span class="review-bar__count"></span></div>
                        <div class="review-bar"><span class="review-bar__label">1</span><div class="review-bar__track"><div class="review-bar__fill" style="width:1%;"></div></div><span class="review-bar__count"></span></div>
                    </div>
                </div>

                <!-- Review cards -->
                <div class="review-list" id="reviewList">
                    <div id="noReviewsMsg" style="display:none;text-align:center;padding:48px 24px;color:var(--text-light);">
                        <div style="font-size:2.4rem;margin-bottom:14px;">💬</div>
                        <p style="font-size:1rem;font-weight:600;color:var(--text-mid);margin-bottom:6px;">No reviews yet</p>
                        <p style="font-size:0.9rem;">Be the first to share your experience with this course.</p>
                    </div>
                    <asp:Repeater ID="rptReviews" runat="server">
                        <ItemTemplate>
                            <div class="review-card">
                                <div class="review-card__top">
                                    <div class="review-avatar" style="background:var(--primary);"><%# Eval("Avatar") %></div>
                                    <div>
                                        <div class="review-card__name"><%# Eval("FirstName") %> <%# Eval("LastName") %></div>
                                        <div class="review-card__stars"><%# new string('★', Convert.ToInt32(Eval("Rating"))) %></div>
                                    </div>
                                </div>
                                <p class="review-card__text"><%# Eval("Comment") %></p>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <asp:Panel ID="pnlNoReviews" runat="server" Visible="false">
                    <div class="empty-state">No reviews yet. Be the first!</div>
                </asp:Panel>

                <!-- Write a Review (shown only when arriving from My Courses) -->
                <div class="write-review" id="writeReviewSection" style="display:none;">
                    <div class="write-review__title">✏️ Write a Review</div>
                    <label class="review-form__label">Your Rating</label>
                    <div class="star-picker" id="starPicker">
                        <span class="star-picker__star" data-v="1">★</span>
                        <span class="star-picker__star" data-v="2">★</span>
                        <span class="star-picker__star" data-v="3">★</span>
                        <span class="star-picker__star" data-v="4">★</span>
                        <span class="star-picker__star" data-v="5">★</span>
                    </div>
                    <label class="review-form__label">Your Review</label>
                    <textarea class="review-form__textarea" id="reviewText" placeholder="Share your experience with this course — what did you enjoy? What could be improved?"></textarea>
                    <div class="review-form__actions">
                        <button class="btn btn--primary" onclick="submitReview()">Submit Review ›</button>
                    </div>
                </div>

            </div><!-- /#tab-reviews -->

        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
// switchTab, toggleSection, expandAll already in script.js

// Show Write Review when arriving from My Courses
(function () {
    var params = new URLSearchParams(window.location.search);
    if (params.get('from') === 'mycourse') {
        var section = document.getElementById('writeReviewSection');
        if (section) section.style.display = 'block';
    }
})();

// Back bar
(function () {
    var params = new URLSearchParams(window.location.search);
    var from = params.get('from');
    var backConfig = {
        admin: { label: 'Back to Admin Dashboard', href: 'Admin.aspx' },
        instructor: { label: 'Back to Instructor Dashboard', href: 'Instructor.aspx' },
        courses: { label: 'Back to Course Catalogue', href: 'Courses.aspx' },
        mycourse: { label: 'Back to Dashboard', href: 'Student.aspx' }
    };
    var cfg = backConfig[from];
    if (cfg) {
        var bar = document.getElementById('adminBackBar');
        var link = document.getElementById('adminBackLink');
        var labelEl = document.getElementById('adminBackLabel');
        if (bar) bar.style.display = 'block';
        if (labelEl) labelEl.textContent = cfg.label;
        if (link) link.href = cfg.href;
    }

    // Disable Enroll when coming from My Courses (already enrolled)
    if (from === 'mycourse') {
        var btns = document.querySelectorAll('[id$="btnEnrollNow"]');
        btns.forEach(function (btn) {
            btn.disabled = true;
            btn.value = 'Enrolled ✓';
            btn.style.opacity = '0.6';
            btn.style.cursor = 'not-allowed';
        });
    }
})();

// Star picker
var _selectedRating = 0;
(function () {
    var stars = document.querySelectorAll('#starPicker .star-picker__star');
    stars.forEach(function (star, idx) {
        star.addEventListener('click', function () {
            _selectedRating = idx + 1;
            highlightStars(stars, _selectedRating);
        });
        star.addEventListener('mouseenter', function () { highlightStars(stars, idx + 1); });
        star.addEventListener('mouseleave', function () { highlightStars(stars, _selectedRating); });
    });
})();

function highlightStars(stars, upTo) {
    stars.forEach(function (s, i) { s.classList.toggle('active', i < upTo); });
}

function submitReview() {
    var text = document.getElementById('reviewText').value.trim();
    if (_selectedRating === 0) { showToast('Please select a star rating first.', 'warning'); return; }
    if (!text) { showToast('Please write your review before submitting.', 'warning'); return; }
    var stars = '';
    for (var i = 1; i <= 5; i++) {
        stars += '<span class="' + (i <= _selectedRating ? 'star--filled' : 'star--empty') + '">★</span>';
    }
    var card = document.createElement('div');
    card.className = 'review-card';
    card.style.animation = 'fadeUp 0.35s ease both';
    card.innerHTML =
        '<div class="review-card__top"><div class="review-avatar" style="background:var(--primary);">ME</div><div>' +
        '<div class="review-card__name">You</div><div class="review-card__stars">' + stars + '</div></div></div>' +
        '<p class="review-card__text">' + text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;') + '</p>';
    var list = document.getElementById('reviewList');
    if (list) list.insertBefore(card, list.firstChild);
    document.getElementById('reviewText').value = '';
    _selectedRating = 0;
    document.querySelectorAll('#starPicker .star-picker__star').forEach(function (s) { s.classList.remove('active'); });
    document.getElementById('writeReviewSection').style.display = 'none';
    showToast('Review submitted! Thank you for your feedback. ✓', 'success');
}

// Check empty state on load
(function () {
    var list = document.getElementById('reviewList');
    var msg = document.getElementById('noReviewsMsg');
    if (list && msg) {
        msg.style.display = list.querySelectorAll('.review-card').length === 0 ? 'block' : 'none';
    }
})();
</script>
</asp:Content>
