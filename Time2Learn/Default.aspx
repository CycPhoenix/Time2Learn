<%@ Page Title="Time2Learn - Programming & Computer Science" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Time2Learn.Default" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .trending-badge { position:absolute;top:10px;left:10px;background:#f59e0b;color:white;font-size:0.7rem;font-weight:700;padding:3px 9px;border-radius:4px;text-transform:uppercase;letter-spacing:0.05em; }
        .course-card { position:relative; }
        .hero__stat + .hero__stat { border-left:1px solid rgba(164,53,240,0.2);padding-left:32px; }
        .instructors-row { display:grid;grid-template-columns:repeat(4,1fr);gap:24px; }
        .instructor-card { text-align:center;padding:28px 20px;border-radius:var(--radius-lg);border:1px solid var(--border);transition:var(--t-base);cursor:pointer; }
        .instructor-card:hover { box-shadow:0 8px 24px rgba(0,0,0,0.1);transform:translateY(-3px); }
        .instructor-card__avatar { width:80px;height:80px;border-radius:50%;background:linear-gradient(135deg,#a435f0,#7c3aed);display:flex;align-items:center;justify-content:center;font-size:2rem;font-weight:700;color:white;margin:0 auto 14px; }
        .instructor-card h4 { margin-bottom:4px; }
        .instructor-card p { font-size:0.85rem;color:var(--text-light);margin-bottom:8px; }
        .instructor-card__rating { font-size:0.82rem;color:#b45309;font-weight:600; }
        .stats-bar { background:#1c1d1f;padding:32px 0; }
        .stats-bar__inner { display:grid;grid-template-columns:repeat(4,1fr); }
        .stats-bar__item { text-align:center;padding:0 24px;border-right:1px solid #2a2a2a; }
        .stats-bar__item:last-child { border-right:none; }
        .stats-bar__number { font-size:2.2rem;font-weight:800;color:white;margin-bottom:4px; }
        .stats-bar__label { font-size:0.85rem;color:#888; }
        .top-banner { background:linear-gradient(90deg,var(--primary),#7c3aed);color:white;text-align:center;padding:10px 24px;font-size:0.88rem;font-weight:500; }
        .top-banner a { color:#fde68a;font-weight:700;text-decoration:underline; }
        .explore-cats { display:grid;grid-template-columns:repeat(4,1fr);gap:20px; }
        .explore-cat-card { display:flex;flex-direction:column;align-items:center;justify-content:center;gap:12px;padding:32px 20px;border:1.5px solid var(--border);border-radius:var(--radius-lg);background:white;cursor:pointer;text-align:center;transition:var(--t-base);text-decoration:none; }
        .explore-cat-card:hover { border-color:var(--primary);transform:translateY(-4px);box-shadow:0 8px 24px rgba(164,53,240,0.15); }
        .explore-cat-card__icon { font-size:2.4rem; }
        .explore-cat-card__name { font-size:0.95rem;font-weight:700;color:var(--text-dark); }
        .explore-cat-card__count { font-size:0.8rem;color:var(--text-light); }
        .community-row { display:grid;grid-template-columns:1fr 1fr;gap:40px;align-items:center; }
        .community-posts { display:flex;flex-direction:column;gap:16px; }
        .community-post { padding:18px 20px;border-radius:var(--radius);border:1.5px solid var(--border);background:white;transition:var(--t-base); }
        .community-post:hover { border-color:var(--primary);box-shadow:0 2px 8px rgba(0,0,0,0.06); }
        .community-post__title { font-weight:700;font-size:0.95rem;margin-bottom:6px;color:var(--text-dark); }
        .community-post__meta { font-size:0.8rem;color:var(--text-light);display:flex;gap:16px; }
        .community-post__tag { font-size:0.72rem;font-weight:700;background:var(--primary-light);color:var(--primary);padding:2px 8px;border-radius:4px;margin-bottom:8px;display:inline-block; }
        .chatbot-row { display:grid;grid-template-columns:1fr 1fr;gap:48px;align-items:center; }
        .chatbot-demo { background:white;border-radius:var(--radius-lg);box-shadow:0 8px 32px rgba(0,0,0,0.1);overflow:hidden; }
        .chatbot-demo__header { background:var(--primary);padding:14px 20px;display:flex;align-items:center;gap:10px;color:white; }
        .chatbot-demo__dot { width:8px;height:8px;border-radius:50%;background:#4ade80;animation:bounceDot 1.2s ease-in-out infinite; }
        .chatbot-demo__body { padding:20px;display:flex;flex-direction:column;gap:12px; }
        .chatbot-msg { display:flex;gap:10px;align-items:flex-start; }
        .chatbot-msg--user { flex-direction:row-reverse; }
        .chatbot-msg__bubble { max-width:80%;padding:10px 14px;border-radius:var(--radius);font-size:0.875rem;line-height:1.5; }
        .chatbot-msg--bot .chatbot-msg__bubble { background:var(--bg-light);color:var(--text-dark);border-radius:4px var(--radius) var(--radius) var(--radius); }
        .chatbot-msg--user .chatbot-msg__bubble { background:var(--primary);color:white;border-radius:var(--radius) 4px var(--radius) var(--radius); }
        .chatbot-msg__avatar { width:30px;height:30px;border-radius:50%;background:var(--primary);display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;color:white;flex-shrink:0; }
        .chatbot-msg--user .chatbot-msg__avatar { background:var(--bg-dark); }
        .signup-pair { display:grid;grid-template-columns:1fr 1fr;gap:28px; }
        .signup-card { padding:44px 40px;border-radius:var(--radius-xl);display:flex;flex-direction:column;gap:16px; }
        .signup-card--learner { background:var(--primary-light);border:2px solid rgba(164,53,240,0.15); }
        .signup-card--educator { background:var(--bg-dark);color:white; }
        .signup-card--educator p { color:#bbb; }
        .signup-card__icon { font-size:2.8rem; }
        .signup-card h3 { font-size:1.5rem; }
        .faq-list { display:flex;flex-direction:column;gap:8px;max-width:780px;margin:0 auto; }
        .faq-item { border:1.5px solid var(--border);border-radius:var(--radius);overflow:hidden; }
        .faq-item__question { width:100%;text-align:left;padding:18px 22px;font-weight:600;font-size:0.97rem;color:var(--text-dark);display:flex;justify-content:space-between;align-items:center;background:white;cursor:pointer;transition:var(--t-fast);border:none; }
        .faq-item__question:hover,.faq-item.open .faq-item__question { color:var(--primary);background:var(--primary-light); }
        .faq-item__question svg { flex-shrink:0;transition:transform 0.25s ease; }
        .faq-item.open .faq-item__question svg { transform:rotate(180deg); }
        .faq-item__answer { display:none;padding:0 22px 18px;font-size:0.92rem;color:var(--text-mid);line-height:1.75;background:white; }
        .faq-item.open .faq-item__answer { display:block; }

        /* Dark mode */
        [data-theme="dark"] .hero { background:linear-gradient(135deg,#0d0d0f 0%,#1a0a2e 50%,#12091f 100%); }
        [data-theme="dark"] .hero__label { background:#2a1a3e; border-color:#4a2a6e; }
        [data-theme="dark"] .hero__title { color:#fff; }
        [data-theme="dark"] .hero__subtitle { color:#bbb; }
        [data-theme="dark"] .hero__stat strong { color:#fff; }
        [data-theme="dark"] .hero__card-main { background:#2a2a2e; box-shadow:0 8px 32px rgba(0,0,0,0.4); }
        [data-theme="dark"] .hero__card-body h4 { color:#fff; }
        [data-theme="dark"] .hero__card-body p { color:#aaa; }
        [data-theme="dark"] .hero__floating { background:#2a2a2e; color:#fff; box-shadow:0 4px 16px rgba(0,0,0,0.5); }

        /* Feature cards (Why us) */
        [data-theme="dark"] .feature-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .feature-card h3 { color:#fff; }
        [data-theme="dark"] .feature-card p { color:#aaa; }
        [data-theme="dark"] .feature-card__icon { background:rgba(164,53,240,0.2); }

        /* Testimonial cards */
        [data-theme="dark"] .testimonial-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .testimonial-card__quote { color:#ccc; }
        [data-theme="dark"] .testimonial-card__name { color:#fff; }

        /* Instructor cards */
        [data-theme="dark"] .instructor-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .instructor-card h4 { color:#fff; }
        [data-theme="dark"] .explore-cat-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .explore-cat-card__name { color:#fff; }
        [data-theme="dark"] .community-post { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .community-post__title { color:#fff; }
        [data-theme="dark"] .chatbot-demo { background:#2a2a2e; box-shadow:none; }
        [data-theme="dark"] .chatbot-msg--bot .chatbot-msg__bubble { background:#333; color:#e5e7eb; }
        [data-theme="dark"] .faq-item { border-color:#333; }
        [data-theme="dark"] .faq-item__question { background:#2a2a2e; color:#fff; }
        [data-theme="dark"] .faq-item__question:hover,[data-theme="dark"] .faq-item.open .faq-item__question { background:#3a2a4e; color:var(--primary); }
        [data-theme="dark"] .faq-item__answer { background:#2a2a2e; color:#aaa; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Top Banner -->
    <div class="top-banner">
        🎉 New courses added this month! <a href="Courses.aspx">Browse all courses →</a>
    </div>

    <!-- Hero -->
    <section class="hero">
        <div class="hero__inner">
            <div class="hero__content">
                <div class="hero__label">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z"/></svg>
                    #1 Platform for CS &amp; Programming
                </div>
                <h1 class="hero__title">
                    The smartest way to<br />
                    <em>master coding &amp; tech</em>
                </h1>
                <p class="hero__subtitle">
                    Learn Python, Web Development, AI, Data Science, and more —
                    from beginner to pro, at your own pace with expert-led courses.
                </p>
                <div class="hero__actions">
                    <a href="Register.aspx" class="btn btn--primary btn--lg">Start Learning Free</a>
                    <a href="Courses.aspx" class="btn btn--outline btn--lg">Browse Courses</a>
                </div>
                <div class="hero__stats">
                    <div class="hero__stat">
                        <strong><asp:Literal ID="litStudentCount" runat="server">50,000</asp:Literal>+</strong>
                        <span>Students enrolled</span>
                    </div>
                    <div class="hero__stat">
                        <strong><asp:Literal ID="litCourseCount" runat="server">320</asp:Literal>+</strong>
                        <span>Expert courses</span>
                    </div>
                    <div class="hero__stat">
                        <strong><asp:Literal ID="litInstructorCount" runat="server">85</asp:Literal>+</strong>
                        <span>Expert instructors</span>
                    </div>
                </div>
            </div>
            <div class="hero__visual">
                <div class="hero__card-main">
                    <div class="hero__card-main-img">
                        <svg viewBox="0 0 24 24"><path d="M9.4 16.6L4.8 12l4.6-4.6L8 6l-6 6 6 6 1.4-1.4zm5.2 0l4.6-4.6-4.6-4.6L16 6l6 6-6 6-1.4-1.4z"/></svg>
                    </div>
                    <div class="hero__card-body">
                        <h4>Python for AI &amp; Machine Learning</h4>
                        <p>Master Python from scratch and build real ML models</p>
                        <div style="display:flex;align-items:center;gap:8px;">
                            <span style="color:#f59e0b;font-size:0.85rem;">★★★★★</span>
                            <span style="font-size:0.8rem;color:#888;">(4,821 reviews)</span>
                        </div>
                    </div>
                </div>
                <div class="hero__floating hero__floating--1">
                    <div class="dot"></div>
                    <span>1,240 learners online now</span>
                </div>
                <div class="hero__floating hero__floating--2">
                    <span style="font-size:1.1rem;">🏆</span>
                    <span>Certificate included</span>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Bar -->
    <div class="stats-bar">
        <div class="container">
            <div class="stats-bar__inner">
                <div class="stats-bar__item">
                    <div class="stats-bar__number">50K+</div>
                    <div class="stats-bar__label">Active Learners</div>
                </div>
                <div class="stats-bar__item">
                    <div class="stats-bar__number">320+</div>
                    <div class="stats-bar__label">Courses Available</div>
                </div>
                <div class="stats-bar__item">
                    <div class="stats-bar__number">85+</div>
                    <div class="stats-bar__label">Expert Instructors</div>
                </div>
                <div class="stats-bar__item">
                    <div class="stats-bar__number">98%</div>
                    <div class="stats-bar__label">Satisfaction Rate</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Featured Courses -->
    <section class="section">
        <div class="container">
            <div class="section-header" style="display:flex;align-items:flex-end;justify-content:space-between;flex-wrap:wrap;gap:16px;">
                <div>
                    <div class="badge">🔥 Most Popular</div>
                    <h2>Featured Courses</h2>
                    <p>Handpicked by our team — the courses learners love the most.</p>
                </div>
                <a href="Courses.aspx" class="btn btn--outline">View All Courses →</a>
            </div>
            <div class="courses-grid" id="coursesGrid">
                <asp:Repeater ID="rptFeatured" runat="server">
                    <ItemTemplate>
                        <a href="CourseDetail.aspx?id=<%# Eval("CourseID") %>" class="course-card" data-reveal>
                            <div class="course-card__img-placeholder" style="background:linear-gradient(135deg,#a435f0,#7c2bd1);">📚</div>
                            <div class="course-card__body">
                                <div class="course-card__category"><%# Eval("CategoryName") %></div>
                                <div class="course-card__title"><%# Eval("CourseTitle") %></div>
                                <div class="course-card__instructor"><%# Eval("InstructorName") %></div>
                                <div class="course-card__footer">
                                    <span class="course-card__price">RM <%# Eval("Price", "{0:0.00}") %></span>
                                    <span class="course-card__level"><%# Eval("DifficultyLevel") %></span>
                                </div>
                            </div>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- Why Time2Learn -->
    <section class="section section--gray">
        <div class="container">
            <div class="section-header text-center">
                <div class="badge">Why Us</div>
                <h2>What makes Time2Learn different</h2>
                <p>We don't just teach you to code — we prepare you for a career in tech.</p>
            </div>
            <div class="features-grid">
                <div class="feature-card" data-reveal>
                    <div class="feature-card__icon">🎓</div>
                    <h3>Industry-Expert Instructors</h3>
                    <p>Every course is created by working professionals with 10+ years of real-world experience in their domain.</p>
                </div>
                <div class="feature-card" data-reveal>
                    <div class="feature-card__icon">🏆</div>
                    <h3>Verified Certificates</h3>
                    <p>Earn shareable certificates recognised by top tech companies — add them to LinkedIn and your resume instantly.</p>
                </div>
                <div class="feature-card" data-reveal>
                    <div class="feature-card__icon">🛠️</div>
                    <h3>Project-Based Learning</h3>
                    <p>Every course includes hands-on projects and real-world assignments so you build a portfolio while you learn.</p>
                </div>
                <div class="feature-card" data-reveal>
                    <div class="feature-card__icon">⚡</div>
                    <h3>Learn at Your Own Pace</h3>
                    <p>Lifetime access to all your enrolled courses. Learn on any device, anytime — from mobile to desktop.</p>
                </div>
                <div class="feature-card" data-reveal>
                    <div class="feature-card__icon">💬</div>
                    <h3>Community &amp; Mentorship</h3>
                    <p>Join a community of 50,000+ learners. Get help in our Q&amp;A forums and connect with mentors directly.</p>
                </div>
                <div class="feature-card" data-reveal>
                    <div class="feature-card__icon">💰</div>
                    <h3>Affordable &amp; Risk-Free</h3>
                    <p>Pay once, learn forever. Don't like a course? Full refund within 30 days — no questions asked.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Instructors -->
    <section class="section">
        <div class="container">
            <div class="section-header text-center">
                <div class="badge">The Team</div>
                <h2>Learn from the best</h2>
                <p>Our instructors are top professionals from Google, Microsoft, Meta, and leading universities.</p>
            </div>
            <div class="instructors-row">
                <div class="instructor-card" data-reveal>
                    <div class="instructor-card__avatar">SC</div>
                    <h4>Dr. Sarah Chen</h4>
                    <p>AI Engineer @ Google</p>
                    <p style="font-size:0.8rem;margin-bottom:8px;">Python · AI · ML</p>
                    <div class="instructor-card__rating">★ 4.9 · 12K students</div>
                </div>
                <div class="instructor-card" data-reveal>
                    <div class="instructor-card__avatar" style="background:linear-gradient(135deg,#f59e0b,#d97706);">MJ</div>
                    <h4>Marcus Johnson</h4>
                    <p>Senior Dev @ Meta</p>
                    <p style="font-size:0.8rem;margin-bottom:8px;">React · Node · CSS</p>
                    <div class="instructor-card__rating">★ 4.8 · 9K students</div>
                </div>
                <div class="instructor-card" data-reveal>
                    <div class="instructor-card__avatar" style="background:linear-gradient(135deg,#8b5cf6,#6d28d9);">AH</div>
                    <h4>Prof. Amir Hassan</h4>
                    <p>ML Researcher @ APU</p>
                    <p style="font-size:0.8rem;margin-bottom:8px;">Deep Learning · NLP</p>
                    <div class="instructor-card__rating">★ 4.9 · 5K students</div>
                </div>
                <div class="instructor-card" data-reveal>
                    <div class="instructor-card__avatar" style="background:linear-gradient(135deg,#14b8a6,#0d9488);">LW</div>
                    <h4>Lisa Wong</h4>
                    <p>Data Scientist @ Grab</p>
                    <p style="font-size:0.8rem;margin-bottom:8px;">Data · Statistics · Viz</p>
                    <div class="instructor-card__rating">★ 4.7 · 4K students</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonials -->
    <section class="section section--gray">
        <div class="container">
            <div class="section-header text-center">
                <div class="badge">Reviews</div>
                <h2>What our students say</h2>
                <p>Don't just take our word for it — hear from people who've transformed their careers.</p>
            </div>
            <div class="testimonials-grid">
                <div class="testimonial-card" data-reveal>
                    <div class="course-card__stars" style="font-size:1rem;margin-bottom:12px;">★★★★★</div>
                    <p class="testimonial-card__quote">"I went from zero programming knowledge to landing a junior developer role in 8 months. The Python course was incredible — practical, clear, and genuinely fun."</p>
                    <div class="testimonial-card__author">
                        <div class="testimonial-card__avatar">RA</div>
                        <div>
                            <div class="testimonial-card__name">Reza Ahmadi</div>
                            <div class="testimonial-card__role">Junior Developer @ TechCorp KL</div>
                        </div>
                    </div>
                </div>
                <div class="testimonial-card" data-reveal>
                    <div class="course-card__stars" style="font-size:1rem;margin-bottom:12px;">★★★★★</div>
                    <p class="testimonial-card__quote">"The Full-Stack Bootcamp is the best investment I've ever made. The projects are real-world, the community is amazing, and I got my first freelance client within a month."</p>
                    <div class="testimonial-card__author">
                        <div class="testimonial-card__avatar" style="background:linear-gradient(135deg,#f59e0b,#d97706);">NK</div>
                        <div>
                            <div class="testimonial-card__name">Nurul Kasim</div>
                            <div class="testimonial-card__role">Freelance Web Developer</div>
                        </div>
                    </div>
                </div>
                <div class="testimonial-card" data-reveal>
                    <div class="course-card__stars" style="font-size:1rem;margin-bottom:12px;">★★★★★</div>
                    <p class="testimonial-card__quote">"As a Computer Science student at APU, Time2Learn supplements my degree perfectly. The ML course gave me a huge advantage in my final year project and I got an A."</p>
                    <div class="testimonial-card__author">
                        <div class="testimonial-card__avatar" style="background:linear-gradient(135deg,#10b981,#059669);">ZY</div>
                        <div>
                            <div class="testimonial-card__name">Zhang Yu</div>
                            <div class="testimonial-card__role">CS Student @ APU</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Explore Category -->
    <section class="section section--gray">
        <div class="container">
            <div class="section-header text-center" data-reveal>
                <div class="badge">Browse by Topic</div>
                <h2>Explore Category</h2>
                <p>Find the right course for your goals — from coding fundamentals to advanced AI.</p>
            </div>
            <div class="explore-cats">
                <asp:Repeater ID="rptCategories" runat="server">
                    <ItemTemplate>
                        <a href="Courses.aspx?cat=<%# Eval("CategoryID") %>" class="explore-cat-card" data-reveal>
                            <div class="explore-cat-card__icon">📂</div>
                            <div class="explore-cat-card__name"><%# Eval("CategoryName") %></div>
                            <div class="explore-cat-card__count"><%# Eval("CourseCount") %> courses</div>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- Community Discussion -->
    <section class="section" id="community">
        <div class="container">
            <div class="community-row">
                <div data-reveal>
                    <div class="badge">Connect &amp; Grow</div>
                    <h2>Join the Community Discussion</h2>
                    <p style="margin-bottom:24px;">Ask questions, share projects, and connect with 50,000+ learners in our active forums — moderated by experts and instructors.</p>
                    <a href="Community.aspx" class="btn btn--primary">Join the Community →</a>
                </div>
                <div class="community-posts" data-reveal>
                    <div class="community-post">
                        <div class="community-post__tag">Python</div>
                        <div class="community-post__title">How do I handle NaN values in a Pandas DataFrame efficiently?</div>
                        <div class="community-post__meta"><span>💬 14 replies</span><span>👍 38 likes</span><span>2h ago</span></div>
                    </div>
                    <div class="community-post">
                        <div class="community-post__tag">Web Dev</div>
                        <div class="community-post__title">Best practices for React state management in 2025?</div>
                        <div class="community-post__meta"><span>💬 27 replies</span><span>👍 61 likes</span><span>5h ago</span></div>
                    </div>
                    <div class="community-post">
                        <div class="community-post__tag">AI / ML</div>
                        <div class="community-post__title">My CNN model overfits after epoch 10 — any suggestions?</div>
                        <div class="community-post__meta"><span>💬 9 replies</span><span>👍 22 likes</span><span>1d ago</span></div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- AI Chatbot Promo -->
    <section class="section section--gray" id="chatbot-promo">
        <div class="container">
            <div class="chatbot-row">
                <div class="chatbot-demo" data-reveal>
                    <div class="chatbot-demo__header">
                        <div class="chatbot-demo__dot"></div>
                        <span style="font-weight:700;">Time2Learn AI Assistant</span>
                    </div>
                    <div class="chatbot-demo__body">
                        <div class="chatbot-msg chatbot-msg--bot">
                            <div class="chatbot-msg__avatar">AI</div>
                            <div class="chatbot-msg__bubble">Hi! I'm your AI learning assistant. Ask me anything about your course or a programming concept.</div>
                        </div>
                        <div class="chatbot-msg chatbot-msg--user">
                            <div class="chatbot-msg__avatar">You</div>
                            <div class="chatbot-msg__bubble">Can you explain what a Python decorator is?</div>
                        </div>
                        <div class="chatbot-msg chatbot-msg--bot">
                            <div class="chatbot-msg__avatar">AI</div>
                            <div class="chatbot-msg__bubble">A decorator is a function that wraps another function to extend its behaviour — without modifying the original code. Think of it like adding a gift wrap around a present! 🎁</div>
                        </div>
                    </div>
                </div>
                <div data-reveal>
                    <div class="badge">Powered by AI</div>
                    <h2>Your AI ChatBot Learning Companion</h2>
                    <p style="margin-bottom:24px;">Get instant answers to course questions, code explanations, and personalised study tips — available 24/7 inside every lesson.</p>
                    <ul style="list-style:none;display:flex;flex-direction:column;gap:12px;margin-bottom:28px;">
                        <li style="display:flex;align-items:center;gap:10px;font-size:0.95rem;"><span style="color:var(--primary);font-size:1.2rem;">✓</span> Explains concepts in plain language</li>
                        <li style="display:flex;align-items:center;gap:10px;font-size:0.95rem;"><span style="color:var(--primary);font-size:1.2rem;">✓</span> Debugs your code with line-by-line hints</li>
                        <li style="display:flex;align-items:center;gap:10px;font-size:0.95rem;"><span style="color:var(--primary);font-size:1.2rem;">✓</span> Quizzes you to reinforce learning</li>
                        <li style="display:flex;align-items:center;gap:10px;font-size:0.95rem;"><span style="color:var(--primary);font-size:1.2rem;">✓</span> Available in every course, 24/7</li>
                    </ul>
                    <a href="Chatbot.aspx" class="btn btn--primary btn--lg">Try It Free →</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Sign Up Pair -->
    <section class="section" id="signup-section">
        <div class="container">
            <div class="section-header text-center" data-reveal>
                <h2>Start your journey with Time2Learn</h2>
                <p>Whether you're here to learn or to teach — we have a place for you.</p>
            </div>
            <div class="signup-pair">
                <div class="signup-card signup-card--learner" data-reveal>
                    <div class="signup-card__icon">🎓</div>
                    <h3>Sign Up As a Learner</h3>
                    <p>Access 320+ courses, earn verified certificates, and join a community of 50,000+ learners growing their tech careers.</p>
                    <a href="Register.aspx" class="btn btn--primary btn--lg" style="align-self:flex-start;">Get Started Free →</a>
                </div>
                <div class="signup-card signup-card--educator" data-reveal>
                    <div class="signup-card__icon">📚</div>
                    <h3 style="color:white;">Sign Up As an Educator</h3>
                    <p>Share your expertise, build courses, and reach thousands of eager learners across Malaysia and beyond.</p>
                    <a href="InstructorRegistration.aspx" class="btn btn--white btn--lg" style="align-self:flex-start;">Start Teaching →</a>
                </div>
            </div>
        </div>
    </section>

    <!-- FAQ -->
    <section class="section section--gray">
        <div class="container">
            <div class="section-header text-center" data-reveal>
                <div class="badge">Got Questions?</div>
                <h2>Frequently Asked Questions</h2>
                <p>Everything you need to know about Time2Learn.</p>
            </div>
            <div class="faq-list">
                <div class="faq-item open">
                    <button class="faq-item__question" onclick="toggleFaq(this)">
                        How do I get started on Time2Learn?
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="faq-item__answer">Simply create a free account, browse our course catalogue, and enrol in any course that interests you. Many courses are free to start, and all paid courses come with a 30-day money-back guarantee.</div>
                </div>
                <div class="faq-item">
                    <button class="faq-item__question" onclick="toggleFaq(this)">
                        Are the certificates recognised by employers?
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="faq-item__answer">Yes. Time2Learn certificates are verified and shareable on LinkedIn. Many of our partner companies in Malaysia actively recognise them during hiring. They serve as strong proof of skill.</div>
                </div>
                <div class="faq-item">
                    <button class="faq-item__question" onclick="toggleFaq(this)">
                        Can I learn at my own pace?
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="faq-item__answer">Absolutely. All course videos and materials are on-demand — watch them whenever and wherever you want. You have lifetime access once enrolled, so there's no pressure to finish by a deadline.</div>
                </div>
                <div class="faq-item">
                    <button class="faq-item__question" onclick="toggleFaq(this)">
                        How does the AI ChatBot help me learn?
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="faq-item__answer">Our AI assistant is embedded in every lesson. You can ask it to explain concepts, debug your code, generate practice questions, or summarise a lecture — all in real time, without leaving the course page.</div>
                </div>
                <div class="faq-item">
                    <button class="faq-item__question" onclick="toggleFaq(this)">
                        How do I become an instructor on Time2Learn?
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="faq-item__answer">Fill in the Instructor Registration form with your background, area of expertise, and teaching experience. Our team reviews applications within 3–5 business days.</div>
                </div>
            </div>
            <div style="text-align:center;margin-top:32px;">
                <a href="Support.aspx" class="btn btn--outline">View all FAQs →</a>
            </div>
        </div>
    </section>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
// toggleFaq defined in script.js — no override needed
(function () {
    var obs = new IntersectionObserver(function (entries) {
        entries.forEach(function (e) { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.1 });
    document.querySelectorAll('.feature-card, .course-card').forEach(function (el) { obs.observe(el); });
})();
</script>
</asp:Content>
