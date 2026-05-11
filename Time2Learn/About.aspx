<%@ Page Title="About - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="Time2Learn.About" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* ─── HERO ─── */
        .about-hero { background:var(--bg-dark); padding:100px 24px 90px; text-align:center; position:relative; overflow:hidden; }
        .about-hero::before { content:''; position:absolute; top:50%; left:50%; transform:translate(-50%,-50%); width:700px; height:700px; border-radius:50%; background:radial-gradient(circle,rgba(164,53,240,0.18) 0%,transparent 65%); pointer-events:none; animation:float 8s ease-in-out infinite; }
        .about-hero::after { content:''; position:absolute; top:-100px; right:-100px; width:400px; height:400px; border-radius:50%; background:radial-gradient(circle,rgba(124,43,209,0.12) 0%,transparent 70%); pointer-events:none; animation:float 10s ease-in-out infinite reverse; }
        .about-hero__inner { position:relative; z-index:1; max-width:760px; margin:0 auto; }
        .about-hero__badge { display:inline-flex; align-items:center; gap:8px; background:rgba(164,53,240,0.18); border:1px solid rgba(164,53,240,0.35); color:#d580ff; font-size:0.82rem; font-weight:700; padding:6px 16px; border-radius:24px; letter-spacing:0.07em; text-transform:uppercase; margin-bottom:24px; animation:fadeUp 0.5s ease 0.1s both; }
        .about-hero__title { color:white; margin-bottom:22px; font-size:clamp(2rem,4vw,3.2rem); font-weight:800; animation:fadeUp 0.6s ease 0.2s both; }
        .about-hero__title em { font-style:normal; background:linear-gradient(135deg,#c084fc,#a435f0); -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text; }
        .about-hero__subtitle { font-size:1.12rem; color:#aaa; margin-bottom:36px; max-width:580px; margin-left:auto; margin-right:auto; animation:fadeUp 0.6s ease 0.3s both; }
        .about-hero__action { animation:fadeUp 0.6s ease 0.4s both; }

        /* ─── MISSION & VISION ─── */
        .mission-vision { background:var(--bg-white); padding:80px 0; }
        .mission-vision__grid { display:grid; grid-template-columns:1fr 1fr; gap:40px; }
        .mv-card { background:var(--bg-light); border:1.5px solid var(--border); border-radius:var(--radius-lg); padding:44px 40px; transition:var(--t-base); position:relative; overflow:hidden; }
        .mv-card::before { content:''; position:absolute; top:0; left:0; right:0; height:4px; background:linear-gradient(90deg,var(--primary),var(--primary-dark)); border-radius:var(--radius-lg) var(--radius-lg) 0 0; opacity:0; transition:var(--t-base); }
        .mv-card:hover { transform:translateY(-5px); box-shadow:var(--shadow); border-color:rgba(164,53,240,0.2); }
        .mv-card:hover::before { opacity:1; }
        .mv-card__icon { width:56px; height:56px; background:var(--primary-light); border-radius:var(--radius); display:flex; align-items:center; justify-content:center; margin-bottom:20px; transition:var(--t-base); }
        .mv-card:hover .mv-card__icon { background:var(--primary); }
        .mv-card:hover .mv-card__icon svg { stroke:white; }
        .mv-card__icon svg { width:28px; height:28px; stroke:var(--primary); fill:none; stroke-width:2; }
        .mv-card__label { font-size:0.78rem; font-weight:700; color:var(--primary); text-transform:uppercase; letter-spacing:0.1em; margin-bottom:10px; }
        .mv-card__title { margin-bottom:14px; color:var(--text-dark); font-size:1.2rem; font-weight:700; }
        .mv-card p { color:var(--text-mid); font-size:0.97rem; }

        /* ─── STATS BAR ─── */
        .about-stats { background:var(--bg-dark); padding:40px 0; }
        .about-stats__grid { display:grid; grid-template-columns:repeat(4,1fr); }
        .about-stats__item { text-align:center; padding:20px 24px; border-right:1px solid #2a2a2a; transition:var(--t-base); }
        .about-stats__item:last-child { border-right:none; }
        .about-stats__item:hover { transform:translateY(-3px); }
        .about-stats__number { font-size:2.4rem; font-weight:800; background:linear-gradient(135deg,white,#c084fc); -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text; margin-bottom:6px; line-height:1; }
        .about-stats__label { font-size:0.875rem; color:#888; }

        /* ─── OUR STORY ─── */
        .our-story { background:var(--bg-light); padding:80px 0; }
        .our-story__section { display:grid; grid-template-columns:1fr 1fr; gap:60px; align-items:center; margin-bottom:80px; }
        .our-story__section:last-child { margin-bottom:0; }
        .our-story__section--reverse .our-story__text { order:2; }
        .our-story__section--reverse .our-story__visual { order:1; }
        .our-story__eyebrow { font-size:0.78rem; font-weight:700; color:var(--primary); text-transform:uppercase; letter-spacing:0.1em; margin-bottom:12px; }
        .our-story__title { color:var(--text-dark); margin-bottom:18px; font-size:clamp(1.4rem,2.5vw,1.9rem); font-weight:700; }
        .our-story__body { color:var(--text-mid); font-size:0.97rem; margin-bottom:14px; }
        .story-illustration { width:100%; aspect-ratio:4/3; border-radius:var(--radius-lg); display:flex; align-items:center; justify-content:center; position:relative; overflow:hidden; box-shadow:var(--shadow-lg); transition:var(--t-slow); }
        .story-illustration:hover { transform:scale(1.02) rotate(-0.5deg); }
        .story-illustration--1 { background:linear-gradient(135deg,#1c1d1f 0%,#2d1b4e 100%); }
        .story-illustration--2 { background:linear-gradient(135deg,#0f172a 0%,#1e1b4b 100%); }

        /* ─── CORE VALUES ─── */
        .core-values { background:var(--bg-white); padding:80px 0; }
        .section-header { text-align:center; margin-bottom:56px; }
        .section-header h2 { color:var(--text-dark); margin-bottom:14px; }
        .section-header p { color:var(--text-mid); max-width:520px; margin:0 auto; }
        .section-header__eyebrow { display:block; font-size:0.78rem; font-weight:700; color:var(--primary); text-transform:uppercase; letter-spacing:0.1em; margin-bottom:12px; }
        .values-grid { display:grid; grid-template-columns:repeat(3,1fr); gap:28px; }
        .value-card { background:var(--bg-light); border:1.5px solid var(--border); border-radius:var(--radius-lg); padding:44px 36px; text-align:center; transition:var(--t-base); position:relative; overflow:hidden; }
        .value-card::after { content:''; position:absolute; inset:0; border-radius:var(--radius-lg); border:2px solid var(--primary); opacity:0; transition:var(--t-base); }
        .value-card:hover { transform:translateY(-6px); box-shadow:var(--shadow); background:white; }
        .value-card:hover::after { opacity:1; }
        .value-card__emoji { font-size:3rem; margin-bottom:20px; display:block; transition:transform 0.3s ease; }
        .value-card:hover .value-card__emoji { transform:scale(1.15) rotate(-4deg); }
        .value-card h3 { color:var(--text-dark); margin-bottom:12px; }
        .value-card p { font-size:0.95rem; color:var(--text-mid); }

        /* ─── TEAM ─── */
        .team-section { background:var(--bg-light); padding:80px 0; }
        .team-grid { display:flex; flex-wrap:wrap; justify-content:center; gap:24px; }
        .team-card { flex:0 0 calc(33.333% - 16px); background:var(--bg-white); border:1.5px solid var(--border); border-radius:var(--radius-lg); padding:32px 24px; text-align:center; transition:var(--t-base); }
        .team-card:hover { transform:translateY(-6px); box-shadow:var(--shadow); border-color:rgba(164,53,240,0.2); }
        .team-card__avatar { width:72px; height:72px; border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:1.4rem; font-weight:800; color:white; margin:0 auto 18px; transition:var(--t-base); }
        .team-card:hover .team-card__avatar { transform:scale(1.08); box-shadow:var(--shadow-purple); }
        .team-card__avatar--1 { background:linear-gradient(135deg,#a435f0,#7c2bd1); }
        .team-card__avatar--2 { background:linear-gradient(135deg,#3b82f6,#1d4ed8); }
        .team-card__avatar--3 { background:linear-gradient(135deg,#10b981,#059669); }
        .team-card__avatar--4 { background:linear-gradient(135deg,#f59e0b,#d97706); }
        .team-card__name  { font-size:1rem; font-weight:700; color:var(--text-dark); margin-bottom:4px; }
        .team-card__title { font-size:0.82rem; font-weight:600; color:var(--primary); text-transform:uppercase; letter-spacing:0.06em; margin-bottom:12px; }
        .team-card__bio   { font-size:0.875rem; color:var(--text-light); line-height:1.65; }

        /* Dark mode */
        [data-theme="dark"] .mission-vision { background:#18191a; }
        [data-theme="dark"] .mv-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .mv-card__title { color:#fff; }
        [data-theme="dark"] .mv-card p { color:#aaa; }
        [data-theme="dark"] .our-story { background:#18191a; }
        [data-theme="dark"] .our-story__title { color:#fff; }
        [data-theme="dark"] .our-story__body { color:#aaa; }
        [data-theme="dark"] .core-values { background:#18191a; }
        [data-theme="dark"] .section-header h2 { color:#fff; }
        [data-theme="dark"] .section-header p { color:#aaa; }
        [data-theme="dark"] .value-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .value-card:hover { background:#333; }
        [data-theme="dark"] .value-card h3 { color:#fff; }
        [data-theme="dark"] .value-card p { color:#aaa; }
        [data-theme="dark"] .team-section { background:#18191a; }
        [data-theme="dark"] .team-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .team-card__name { color:#fff; }
        [data-theme="dark"] .team-card__bio { color:#aaa; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- 1. HERO -->
    <section class="about-hero">
        <div class="about-hero__inner">
            <div class="about-hero__badge">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 3L1 9l11 6 9-4.91V17h2V9L12 3zM5 13.18v4L12 21l7-3.82v-4L12 17l-7-3.82z"/></svg>
                Our Story
            </div>
            <h1 class="about-hero__title">
                Empowering Every Learner in<br /><em>Malaysia and Beyond</em>
            </h1>
            <p class="about-hero__subtitle">
                We believe great tech education should never be out of reach. Time2Learn was built to give every curious mind — regardless of background or budget — the skills to thrive in a digital world.
            </p>
            <div class="about-hero__action">
                <a href="Courses.aspx" class="btn btn--primary btn--lg">Explore Courses →</a>
            </div>
        </div>
    </section>

    <!-- 2. MISSION & VISION -->
    <section class="mission-vision">
        <div class="container">
            <div class="mission-vision__grid">

                <div class="mv-card" data-reveal>
                    <div class="mv-card__icon">
                        <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/></svg>
                    </div>
                    <div class="mv-card__label">Our Mission</div>
                    <h3 class="mv-card__title">Democratising Tech Education</h3>
                    <p>We are on a mission to tear down the barriers that keep quality technology education out of reach. By partnering with industry-expert instructors and keeping our prices accessible, we ensure that every learner — whether in Kuala Lumpur or rural Kelantan — can gain the skills that matter.</p>
                    <p style="margin-top:12px;">From beginner-friendly fundamentals to advanced professional courses, Time2Learn delivers structured, job-ready learning pathways that fit around your life.</p>
                </div>

                <div class="mv-card" data-reveal>
                    <div class="mv-card__icon">
                        <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                    </div>
                    <div class="mv-card__label">Our Vision</div>
                    <h3 class="mv-card__title">Southeast Asia's Leading Learning Platform</h3>
                    <p>We envision a Southeast Asia where no one is left behind in the digital economy. Our goal is to become the region's most trusted and impactful online learning destination — a platform where learners, instructors, and industry come together to shape the future of work.</p>
                    <p style="margin-top:12px;">By 2030, we aim to upskill one million learners across SEA and become the preferred pathway from learning to career placement in the technology sector.</p>
                </div>

            </div>
        </div>
    </section>

    <!-- 3. STATS BAR -->
    <div class="about-stats">
        <div class="container">
            <div class="about-stats__grid">
                <div class="about-stats__item" data-reveal>
                    <div class="about-stats__number">50,000+</div>
                    <div class="about-stats__label">Learners</div>
                </div>
                <div class="about-stats__item" data-reveal>
                    <div class="about-stats__number">320+</div>
                    <div class="about-stats__label">Courses</div>
                </div>
                <div class="about-stats__item" data-reveal>
                    <div class="about-stats__number">85+</div>
                    <div class="about-stats__label">Instructors</div>
                </div>
                <div class="about-stats__item" data-reveal>
                    <div class="about-stats__number">4.8★</div>
                    <div class="about-stats__label">Avg Rating</div>
                </div>
            </div>
        </div>
    </div>

    <!-- 4. OUR STORY -->
    <section class="our-story">
        <div class="container">

            <div class="our-story__section">
                <div class="our-story__text" data-reveal>
                    <div class="our-story__eyebrow">Chapter One</div>
                    <h2 class="our-story__title">How It Started</h2>
                    <p class="our-story__body">In 2022, a group of fresh APU graduates noticed something troubling: talented peers were giving up on computer science dreams simply because quality courses were too expensive or too far away. They had the skills. They just needed access.</p>
                    <p class="our-story__body">So they built Time2Learn — a lean, purpose-driven platform created from a rented co-working space in Petaling Jaya with three laptops and a shared conviction that affordable CS education could change lives. The first five courses launched with hand-recorded videos and passionate community feedback.</p>
                    <p class="our-story__body">Within six months, over 1,000 learners had enrolled. The signal was clear: the demand was real, and the need was urgent.</p>
                </div>
                <div class="our-story__visual" data-reveal>
                    <div class="story-illustration story-illustration--1">
                        <svg width="100%" height="100%" viewBox="0 0 480 360" xmlns="http://www.w3.org/2000/svg">
                            <circle cx="240" cy="180" r="140" fill="rgba(164,53,240,0.08)"/>
                            <circle cx="240" cy="180" r="90" fill="rgba(164,53,240,0.12)"/>
                            <rect x="160" y="120" width="160" height="100" rx="8" fill="none" stroke="rgba(164,53,240,0.7)" stroke-width="2"/>
                            <rect x="140" y="220" width="200" height="12" rx="4" fill="rgba(164,53,240,0.5)"/>
                            <rect x="172" y="134" width="80" height="6" rx="3" fill="rgba(192,132,252,0.6)"/>
                            <rect x="172" y="148" width="120" height="4" rx="2" fill="rgba(164,53,240,0.4)"/>
                            <rect x="172" y="160" width="100" height="4" rx="2" fill="rgba(164,53,240,0.3)"/>
                            <rect x="172" y="172" width="112" height="4" rx="2" fill="rgba(164,53,240,0.25)"/>
                            <rect x="172" y="184" width="90" height="4" rx="2" fill="rgba(164,53,240,0.2)"/>
                            <circle cx="340" cy="100" r="22" fill="rgba(164,53,240,0.15)" stroke="rgba(164,53,240,0.4)" stroke-width="1.5"/>
                            <circle cx="140" cy="260" r="16" fill="rgba(164,53,240,0.1)" stroke="rgba(164,53,240,0.3)" stroke-width="1.5"/>
                            <circle cx="360" cy="270" r="12" fill="rgba(124,43,209,0.2)"/>
                            <text x="322" y="106" font-size="16" fill="rgba(192,132,252,0.9)" text-anchor="middle">✦</text>
                            <text x="148" y="90" font-size="10" fill="rgba(192,132,252,0.6)" text-anchor="middle">✦</text>
                            <text x="390" y="200" font-size="12" fill="rgba(192,132,252,0.5)" text-anchor="middle">✦</text>
                            <text x="240" y="300" font-family="'Segoe UI',sans-serif" font-size="13" font-weight="700" fill="rgba(164,53,240,0.8)" text-anchor="middle" letter-spacing="3">FOUNDED 2022</text>
                        </svg>
                    </div>
                </div>
            </div>

            <div class="our-story__section our-story__section--reverse">
                <div class="our-story__text" data-reveal>
                    <div class="our-story__eyebrow">Chapter Two</div>
                    <h2 class="our-story__title">Where We Are Today</h2>
                    <p class="our-story__body">Fast-forward to 2026: Time2Learn has grown into a thriving community of over 50,000 active learners, 85 verified industry instructors, and 320 courses spanning web development, data science, cybersecurity, mobile apps, and cloud computing.</p>
                    <p class="our-story__body">We have forged partnerships with leading Malaysian tech companies to bring real-world projects into the classroom, and our learners are landing roles at companies across the country and across Southeast Asia.</p>
                    <p class="our-story__body">The scrappy startup spirit remains. We are still the same team that believes education is a right, not a privilege — just bigger, better, and more committed than ever.</p>
                </div>
                <div class="our-story__visual" data-reveal>
                    <div class="story-illustration story-illustration--2">
                        <svg width="100%" height="100%" viewBox="0 0 480 360" xmlns="http://www.w3.org/2000/svg">
                            <circle cx="240" cy="180" r="150" fill="none" stroke="rgba(164,53,240,0.1)" stroke-width="1.5" stroke-dasharray="6 4"/>
                            <circle cx="240" cy="180" r="100" fill="none" stroke="rgba(164,53,240,0.14)" stroke-width="1.5"/>
                            <circle cx="240" cy="180" r="50" fill="rgba(164,53,240,0.12)"/>
                            <text x="240" y="195" font-size="36" text-anchor="middle" fill="rgba(192,132,252,0.9)">🌐</text>
                            <circle cx="240" cy="80" r="10" fill="rgba(164,53,240,0.8)"/>
                            <circle cx="330" cy="135" r="8" fill="rgba(124,43,209,0.7)"/>
                            <circle cx="330" cy="225" r="10" fill="rgba(164,53,240,0.6)"/>
                            <circle cx="240" cy="280" r="8" fill="rgba(192,132,252,0.8)"/>
                            <circle cx="150" cy="225" r="10" fill="rgba(164,53,240,0.7)"/>
                            <circle cx="150" cy="135" r="8" fill="rgba(124,43,209,0.6)"/>
                            <line x1="240" y1="90" x2="240" y2="130" stroke="rgba(164,53,240,0.3)" stroke-width="1.5"/>
                            <line x1="323" y1="142" x2="285" y2="162" stroke="rgba(164,53,240,0.3)" stroke-width="1.5"/>
                            <line x1="323" y1="218" x2="285" y2="198" stroke="rgba(164,53,240,0.3)" stroke-width="1.5"/>
                            <line x1="240" y1="270" x2="240" y2="230" stroke="rgba(164,53,240,0.3)" stroke-width="1.5"/>
                            <line x1="157" y1="218" x2="195" y2="198" stroke="rgba(164,53,240,0.3)" stroke-width="1.5"/>
                            <line x1="157" y1="142" x2="195" y2="162" stroke="rgba(164,53,240,0.3)" stroke-width="1.5"/>
                            <text x="240" y="68" font-family="'Segoe UI',sans-serif" font-size="9" fill="rgba(192,132,252,0.8)" text-anchor="middle">50K Learners</text>
                            <text x="352" y="133" font-family="'Segoe UI',sans-serif" font-size="9" fill="rgba(192,132,252,0.8)" text-anchor="start">320 Courses</text>
                            <text x="352" y="228" font-family="'Segoe UI',sans-serif" font-size="9" fill="rgba(192,132,252,0.8)" text-anchor="start">85 Instructors</text>
                            <text x="240" y="298" font-family="'Segoe UI',sans-serif" font-size="9" fill="rgba(192,132,252,0.8)" text-anchor="middle">Industry Partners</text>
                            <text x="126" y="228" font-family="'Segoe UI',sans-serif" font-size="9" fill="rgba(192,132,252,0.8)" text-anchor="end">Careers</text>
                            <text x="126" y="133" font-family="'Segoe UI',sans-serif" font-size="9" fill="rgba(192,132,252,0.8)" text-anchor="end">Community</text>
                        </svg>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <!-- 5. CORE VALUES -->
    <section class="core-values">
        <div class="container">
            <div class="section-header" data-reveal>
                <span class="section-header__eyebrow">What Drives Us</span>
                <h2>Our Core Values</h2>
                <p>Everything we build, every course we publish, and every decision we make flows from three foundational beliefs.</p>
            </div>
            <div class="values-grid">
                <div class="value-card" data-reveal>
                    <span class="value-card__emoji">🌍</span>
                    <h3>Accessibility</h3>
                    <p>Everyone deserves quality education, regardless of income, location, or background. We price fairly, offer financial assistance, and design for every device so no one is left behind.</p>
                </div>
                <div class="value-card" data-reveal>
                    <span class="value-card__emoji">🏆</span>
                    <h3>Excellence</h3>
                    <p>We work only with industry-expert instructors who bring real-world experience into every lesson. Our rigorous quality review ensures every course meets a high bar before it reaches learners.</p>
                </div>
                <div class="value-card" data-reveal>
                    <span class="value-card__emoji">🤝</span>
                    <h3>Community</h3>
                    <p>Learning is better together. We foster a vibrant community of peers, mentors, and industry professionals so learners can collaborate, share knowledge, and grow alongside each other.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- 6. TEAM -->
    <section class="team-section">
        <div class="container">
            <div class="section-header" data-reveal>
                <span class="section-header__eyebrow">The People Behind Time2Learn</span>
                <h2>Meet Our Team</h2>
                <p>A small but mighty group of educators, engineers, and community builders passionate about changing the future of learning in Malaysia.</p>
            </div>
            <div class="team-grid">

                <div class="team-card" data-reveal>
                    <div class="team-card__avatar team-card__avatar--1">KS</div>
                    <div class="team-card__name">Eee Kong Siong</div>
                    <div class="team-card__title">Project Manager</div>
                    <p class="team-card__bio">Jordan is the glue that holds the team together. With a talent for clear communication, agile workflows, and deadline delivery, he keeps every project on track — from kickoff to launch.</p>
                </div>

                <div class="team-card" data-reveal>
                    <div class="team-card__avatar team-card__avatar--2">CY</div>
                    <div class="team-card__name">Brosnan Ban Cong Yin</div>
                    <div class="team-card__title">Backend Developer</div>
                    <p class="team-card__bio">Brosnan designs the infrastructure that never sleeps. With deep expertise in ASP.NET, cloud services, and CI/CD pipelines, he ensures every deployment is smooth and every system stays resilient.</p>
                </div>

                <div class="team-card" data-reveal>
                    <div class="team-card__avatar team-card__avatar--3">WT</div>
                    <div class="team-card__name">Ng Wan Teng</div>
                    <div class="team-card__title">Backend Developer</div>
                    <p class="team-card__bio">Wan Teng builds the engines that power seamless digital experiences. From scalable APIs to robust database architecture, he keeps systems running fast, secure, and reliable.</p>
                </div>

                <div class="team-card" data-reveal>
                    <div class="team-card__avatar team-card__avatar--4">KF</div>
                    <div class="team-card__name">Lai Kah Fon</div>
                    <div class="team-card__title">Frontend Developer</div>
                    <p class="team-card__bio">Kah Fon bridges the gap between design and functionality. With a keen eye for detail and expertise in UI/UX, she ensures every interaction feels intuitive and delightful.</p>
                </div>

                <div class="team-card" data-reveal>
                    <div class="team-card__avatar team-card__avatar--4">WK</div>
                    <div class="team-card__name">Lee Wei Kee</div>
                    <div class="team-card__title">Frontend Developer</div>
                    <p class="team-card__bio">Wei Kee crafts pixel-perfect interfaces with a passion for clean code and smooth user experiences. Specializing in modern CSS and JavaScript, he turns complex designs into fast, accessible web applications.</p>
                </div>

            </div>
        </div>
    </section>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
