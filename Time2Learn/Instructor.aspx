<%@ Page Title="Instructor Panel - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Instructor.aspx.cs" Inherits="Time2Learn.Instructor" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* ── Layout ── */
        .dashboard-layout { display:flex; min-height:calc(100vh - 64px); background:var(--bg-light); }
        .inst-main { flex:1; padding:32px; overflow-y:auto; }
        .inst-section { display:none; }
        .inst-section.active { display:block; }

        /* ── Sidebar ── */
        .dash-sidebar { width:260px; background:#1c1d1f; padding:28px 0; flex-shrink:0; position:sticky; top:68px; height:calc(100vh - 68px); overflow-y:auto; }
        .sidebar__user { padding:0 24px 24px; border-bottom:1px solid #2a2a2a; margin-bottom:8px; }
        .sidebar__avatar { width:52px; height:52px; border-radius:50%; background:var(--primary); color:white; display:flex; align-items:center; justify-content:center; font-size:1.1rem; font-weight:700; margin-bottom:10px; }
        .sidebar__name { font-weight:700; color:white; font-size:0.95rem; margin-bottom:4px; }
        .sidebar__email { font-size:0.78rem; color:#888; word-break:break-all; }
        .sidebar__nav { padding:8px 0; }
        .sidebar__section-label { padding:0 24px 8px; font-size:0.7rem; text-transform:uppercase; letter-spacing:0.1em; color:#888; font-weight:600; margin-top:8px; }
        .sidebar__nav-item { display:flex; align-items:center; gap:12px; padding:12px 24px; color:#bbb; font-size:0.9rem; border-left:3px solid transparent; cursor:pointer; transition:var(--t-fast); text-decoration:none; }
        .sidebar__nav-item svg { width:18px; height:18px; flex-shrink:0; }
        .sidebar__nav-item:hover { background:rgba(164,53,240,0.08); color:white; }
        .sidebar__nav-item.active { background:rgba(164,53,240,0.15); color:var(--primary); border-left-color:var(--primary); }

        /* ── Stats grid ── */
        .inst-stats { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:28px; }
        .dash-stat-card { background:white; border-radius:var(--radius); border:1px solid var(--border); padding:20px 24px; }
        .dash-stat-card__label { font-size:0.82rem; color:var(--text-light); margin-bottom:8px; font-weight:600; }
        .dash-stat-card__value { font-size:2rem; font-weight:800; color:var(--text-dark); }
        .dash-stat-card__change { font-size:0.8rem; color:#22c55e; margin-top:4px; font-weight:600; }
        .dash-page-header { margin-bottom:24px; }
        .dash-page-header h1 { font-size:1.7rem; margin-bottom:6px; }

        /* ── Table card ── */
        .inst-table-card { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); overflow:hidden; }
        .inst-table-header { display:flex; justify-content:space-between; align-items:center; padding:16px 20px; border-bottom:1px solid var(--border); flex-wrap:wrap; gap:12px; }
        .inst-table-header h3 { font-size:1rem; margin:0; }
        .inst-table { width:100%; border-collapse:collapse; }
        .inst-table th { background:var(--bg-light); padding:11px 16px; text-align:left; font-size:0.8rem; color:var(--text-light); font-weight:600; text-transform:uppercase; letter-spacing:0.04em; }
        .inst-table td { padding:13px 16px; border-bottom:1px solid var(--border); font-size:0.88rem; vertical-align:middle; }
        .inst-table tr:last-child td { border-bottom:none; }
        .inst-table tr:hover td { background:#faf8ff; }

        /* ── Chips / Badges ── */
        .chip { padding:3px 10px; border-radius:20px; font-size:0.75rem; font-weight:600; }
        .chip--published,.chip--active { background:#d1fae5; color:#065f46; }
        .chip--draft    { background:#fef3c7; color:#92400e; }
        .chip--archived { background:#e5e7eb; color:#374151; }
        .chip--beginner { background:#dbeafe; color:#1e40af; }
        .chip--inter    { background:#fef3c7; color:#92400e; }
        .chip--advanced { background:#fee2e2; color:#991b1b; }
        .badge { padding:3px 10px; border-radius:20px; font-size:0.78rem; font-weight:600; }
        .badge--open       { background:#fef3c7; color:#92400e; }
        .badge--in-progress{ background:#e0e7ff; color:#3730a3; }
        .badge--resolved   { background:#d1fae5; color:#065f46; }
        .badge--closed     { background:#e5e7eb; color:#374151; }
        .badge--pending    { background:#e0e7ff; color:#3730a3; }

        /* ── Filter / Search ── */
        .filter-row { display:flex; gap:10px; align-items:center; flex-wrap:wrap; }
        .inst-search { display:flex; align-items:center; background:var(--bg-light); border:1.5px solid var(--border); border-radius:var(--radius); padding:0 12px; gap:8px; }
        .inst-search input { border:none; background:none; padding:9px 0; outline:none; font-size:0.88rem; width:180px; }
        .inst-filter-select { padding:9px 12px; border:1.5px solid var(--border); border-radius:var(--radius); font-size:0.85rem; outline:none; background:white; cursor:pointer; }

        /* ── Table action buttons ── */
        .tbl-actions { display:flex; gap:6px; }
        .tbl-btn { padding:4px 12px; border-radius:6px; font-size:0.8rem; font-weight:600; cursor:pointer; border:none; transition:var(--t-fast); }
        .tbl-btn--edit   { background:#e0e7ff; color:#3730a3; }
        .tbl-btn--edit:hover   { background:#c7d2fe; }
        .tbl-btn--view   { background:#f0fdf4; color:#166534; }
        .tbl-btn--view:hover   { background:#dcfce7; }
        .tbl-btn--delete { background:#fee2e2; color:#991b1b; }
        .tbl-btn--delete:hover { background:#fecaca; }

        /* ── Progress bars ── */
        .prog-bar-wrap { height:6px; background:var(--bg-light); border-radius:4px; overflow:hidden; min-width:80px; }
        .prog-bar { height:100%; border-radius:4px; background:var(--primary); }

        /* ── Review cards ── */
        .review-card { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:20px; margin-bottom:14px; }
        .review-card__meta { display:flex; gap:8px; align-items:center; margin-bottom:8px; flex-wrap:wrap; }
        .review-card__stars { color:#f59e0b; font-size:0.95rem; }
        .review-card__date { font-size:0.78rem; color:var(--text-light); margin-left:auto; }

        /* ── Support history ── */
        .ticket-table { width:100%; border-collapse:collapse; }
        .ticket-table th { background:var(--bg-light); padding:12px 16px; text-align:left; font-size:0.85rem; color:var(--text-light); font-weight:600; text-transform:uppercase; letter-spacing:0.04em; }
        .ticket-table td { padding:14px 16px; border-bottom:1px solid var(--border); font-size:0.9rem; }
        .ticket-table tr:last-child td { border-bottom:none; }
        .support-empty { padding:60px 24px; text-align:center; color:var(--text-light); }
        .support-empty__icon { font-size:2.5rem; margin-bottom:16px; }
        .support-empty__title { font-weight:600; font-size:1rem; color:var(--text-mid); margin-bottom:8px; }

        /* ── Form groups ── */
        .form-group { margin-bottom:16px; }
        .form-group label { display:block; font-weight:600; font-size:0.85rem; margin-bottom:6px; color:var(--text-dark); }
        .form-group input, .form-group select, .form-group textarea { width:100%; padding:10px 14px; border:1.5px solid var(--border); border-radius:var(--radius); font-size:0.9rem; outline:none; transition:border-color 0.2s; font-family:inherit; background:white; box-sizing:border-box; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { border-color:var(--primary); }
        .form-group textarea { resize:vertical; min-height:80px; }
        .form-row-2 { display:grid; grid-template-columns:1fr 1fr; gap:14px; }

        /* ── Toggle switches ── */
        .settings-row { display:flex; justify-content:space-between; align-items:center; padding:16px 0; border-bottom:1px solid var(--border); }
        .settings-row:last-child { border-bottom:none; }
        .toggle-wrap { position:relative; width:44px; height:24px; cursor:pointer; flex-shrink:0; }
        .toggle-wrap input { opacity:0; width:0; height:0; position:absolute; }
        .toggle-track { position:absolute; inset:0; background:#ccc; border-radius:12px; transition:0.3s; }
        .toggle-track.on { background:var(--primary); }
        .toggle-thumb { position:absolute; top:2px; left:2px; width:20px; height:20px; border-radius:50%; background:white; transition:0.3s; }
        .toggle-track.on + .toggle-thumb, .toggle-wrap input:checked ~ .toggle-track + .toggle-thumb { left:22px; }

        /* ── Empty state ── */
        .empty-state { padding:60px 24px; text-align:center; color:var(--text-light); }

        /* ── Modal ── */
        .modal-overlay { position:fixed; inset:0; background:rgba(0,0,0,0.55); z-index:2000; display:none; align-items:center; justify-content:center; padding:20px; }
        .modal-overlay.open { display:flex; animation:fadeIn 0.2s ease; }
        .modal-box { background:white; border-radius:var(--radius-xl); width:100%; max-width:640px; max-height:90vh; overflow-y:auto; box-shadow:0 25px 60px rgba(0,0,0,0.3); }
        .modal-header { display:flex; justify-content:space-between; align-items:center; padding:22px 28px; border-bottom:1px solid var(--border); }
        .modal-header h3 { font-size:1.1rem; margin:0; }
        .modal-close { width:32px; height:32px; border-radius:50%; background:var(--bg-light); border:none; cursor:pointer; font-size:1rem; display:flex; align-items:center; justify-content:center; transition:var(--t-fast); line-height:1; }
        .modal-close:hover { background:#fee2e2; color:#991b1b; }
        .modal-body { padding:24px 28px; }
        .modal-footer { padding:16px 28px; border-top:1px solid var(--border); display:flex; gap:10px; justify-content:flex-end; align-items:center; flex-wrap:wrap; }
        .form-msg-error { background:#fee2e2; color:#991b1b; padding:10px 14px; border-radius:var(--radius); font-size:0.85rem; margin-bottom:12px; }
        [data-theme="dark"] .modal-box { background:#2a2a2e; }
        [data-theme="dark"] .modal-header { border-color:#444; }
        [data-theme="dark"] .modal-header h3 { color:#fff; }
        [data-theme="dark"] .modal-footer { border-color:#444; }
        [data-theme="dark"] .modal-close { background:#333; color:#ccc; }

        /* ── Dark mode ── */
        [data-theme="dark"] .dashboard-layout { background:#18191a; }
        [data-theme="dark"] .inst-main { background:#18191a; }
        [data-theme="dark"] .dash-stat-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .dash-stat-card__value { color:#fff; }
        [data-theme="dark"] .dash-page-header h1 { color:#fff; }
        [data-theme="dark"] .inst-table-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .inst-table-header { border-color:#333; }
        [data-theme="dark"] .inst-table-header h3 { color:#fff; }
        [data-theme="dark"] .inst-table th { background:#333; color:#aaa; }
        [data-theme="dark"] .inst-table td { border-color:#333; color:#ccc; }
        [data-theme="dark"] .inst-table tr:hover td { background:rgba(164,53,240,0.05); }
        [data-theme="dark"] .review-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .inst-search { background:#333; border-color:#444; }
        [data-theme="dark"] .inst-search input { color:#ccc; }
        [data-theme="dark"] .inst-filter-select { background:#333; border-color:#444; color:#ccc; }
        [data-theme="dark"] .prog-bar-wrap { background:#333; }
        [data-theme="dark"] .form-group input, [data-theme="dark"] .form-group select, [data-theme="dark"] .form-group textarea { background:#333; border-color:#444; color:#ccc; }
        [data-theme="dark"] .form-group label { color:#ccc; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dashboard-layout">

        <!-- Sidebar -->
        <aside class="dash-sidebar">
            <div class="sidebar__user">
                <div class="sidebar__avatar"><asp:Literal ID="litAvatar" runat="server" /></div>
                <div class="sidebar__name"><asp:Literal ID="litName" runat="server" /></div>
                <div class="sidebar__email"><asp:Literal ID="litEmail" runat="server" /></div>
            </div>
            <nav class="sidebar__nav">
                <div class="sidebar__section-label">Instructor</div>
                <div class="sidebar__nav-item active" id="nav-overview" onclick="showInstSection('overview', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
                    Overview
                </div>
                <div class="sidebar__nav-item" id="nav-my-courses" onclick="showInstSection('my-courses', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M21 5c-1.11-.35-2.33-.5-3.5-.5-1.95 0-4.05.4-5.5 1.5-1.45-1.1-3.55-1.5-5.5-1.5S2.45 4.9 1 6v14.65c0 .25.25.5.5.5.1 0 .15-.05.25-.05C3.1 20.45 5.05 20 6.5 20c1.95 0 4.05.4 5.5 1.5 1.35-.85 3.8-1.5 5.5-1.5 1.65 0 3.35.3 4.75 1.05.1.05.15.05.25.05.25 0 .5-.25.5-.5V6c-.6-.45-1.25-.75-2-1zm0 13.5c-1.1-.35-2.3-.5-3.5-.5-1.7 0-4.15.65-5.5 1.5V8c1.35-.85 3.8-1.5 5.5-1.5 1.2 0 2.4.15 3.5.5v11.5z"/></svg>
                    My Courses
                </div>
                <div class="sidebar__nav-item" id="nav-upload-material" onclick="showInstSection('upload-material', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M19.35 10.04C18.67 6.59 15.64 4 12 4 9.11 4 6.6 5.64 5.35 8.04 2.34 8.36 0 10.91 0 14c0 3.31 2.69 6 6 6h13c2.76 0 5-2.24 5-5 0-2.64-2.05-4.78-4.65-4.96zM14 13v4h-4v-4H7l5-5 5 5h-3z"/></svg>
                    Upload Material
                </div>
                <div class="sidebar__nav-item" id="nav-students" onclick="showInstSection('students', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
                    My Students
                </div>
                <div class="sidebar__nav-item" id="nav-reviews" onclick="showInstSection('reviews', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
                    Reviews
                </div>
                <div class="sidebar__nav-item" id="nav-support-history" onclick="showInstSection('support-history', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-2 12H6v-2h12v2zm0-3H6V9h12v2zm0-3H6V6h12v2z"/></svg>
                    Support History
                </div>
                <div class="sidebar__section-label">Account</div>
                <div class="sidebar__nav-item" id="nav-profile" onclick="showInstSection('profile', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                    My Profile
                </div>
                <div class="sidebar__nav-item" id="nav-settings" onclick="showInstSection('settings', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58C4.84 11.36 4.8 11.69 4.8 12s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"/></svg>
                    Settings
                </div>
                <a href="Logout.aspx" class="sidebar__nav-item" style="color:#ef4444;">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>
                    Log Out
                </a>
            </nav>
        </aside>

        <asp:HiddenField ID="hdnActiveSection" runat="server" Value="overview" />

        <!-- Main Content -->
        <main class="inst-main">

            <!-- ── Overview ── -->
            <div class="inst-section active" id="section-overview">
                <div class="dash-page-header">
                    <h1>Welcome back, <asp:Literal ID="litWelcomeName" runat="server" />!</h1>
                    <p style="color:var(--text-light);font-size:0.9rem;">Here's your instructor dashboard summary.</p>
                </div>

                <div class="inst-stats">
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">My Courses</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litCourseCount" runat="server">0</asp:Literal></div>
                    </div>
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">Total Students</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litStudentCount" runat="server">0</asp:Literal></div>
                    </div>
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">Avg. Rating</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litAvgRating" runat="server">—</asp:Literal></div>
                    </div>
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">Total Reviews</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litReviewCount" runat="server">0</asp:Literal></div>
                    </div>
                </div>

                <div class="inst-table-card">
                    <div class="inst-table-header">
                        <h3>Course List Preview</h3>
                        <button class="btn btn--primary btn--sm" onclick="showInstSection('my-courses', document.getElementById('nav-my-courses'))">Manage All →</button>
                    </div>
                    <table class="inst-table">
                        <thead>
                            <tr><th>ID</th><th>Course Title</th><th>Category</th><th>Level</th><th>Students</th><th>Rating</th><th>Status</th></tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptOverviewCourses" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><strong><%# Eval("CourseID") %></strong></td>
                                        <td><strong><%# Eval("CourseTitle") %></strong></td>
                                        <td><%# Eval("CategoryName") %></td>
                                        <td>
                                            <span class="chip chip--<%# Eval("DifficultyLevel").ToString().ToLower() == "beginner" ? "beginner" : Eval("DifficultyLevel").ToString().ToLower() == "intermediate" ? "inter" : "advanced" %>">
                                                <%# Eval("DifficultyLevel") %>
                                            </span>
                                        </td>
                                        <td><%# Eval("StudentCount") %></td>
                                        <td><%# Convert.ToDouble(Eval("AvgRating")) > 0 ? "⭐ " + string.Format("{0:0.0}", Eval("AvgRating")) : "—" %></td>
                                        <td><span class="chip chip--<%# Eval("CourseStatus").ToString().ToLower() %>"><%# Eval("CourseStatus") %></span></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- ── My Courses ── -->
            <asp:HiddenField ID="hdnEditCourseID" runat="server" Value="0" />
            <asp:HiddenField ID="hdnShowCourseModal" runat="server" Value="false" />

            <div class="inst-section" id="section-my-courses">
                <div class="dash-page-header">
                    <h1>My Courses</h1>
                    <p style="color:var(--text-light);font-size:0.9rem;">Manage, edit, publish, or delete your courses.</p>
                </div>
                <div class="inst-table-card">
                    <div class="inst-table-header">
                        <h3>Course List</h3>
                        <div class="filter-row">
                            <div class="inst-search">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                <input type="text" placeholder="Search courses…" oninput="instSearchCourses(this.value)" />
                            </div>
                            <select class="inst-filter-select" onchange="instFilterCourses(this.value)">
                                <option value="">All Status</option>
                                <option value="published">Published</option>
                                <option value="draft">Draft</option>
                                <option value="archived">Archived</option>
                            </select>
                            <asp:Button ID="btnShowAddCourse" runat="server" Text="+ Add Course" CssClass="btn btn--primary btn--sm" OnClick="btnShowAddCourse_Click" CausesValidation="false" />
                        </div>
                    </div>
                    <table class="inst-table" id="tblMyCourses">
                        <thead>
                            <tr><th>#</th><th>Title</th><th>Category</th><th>Level</th><th>Status</th><th>Students</th><th>Price</th><th>Actions</th></tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptMyCourses" runat="server" OnItemCommand="CourseAction_Command">
                                <ItemTemplate>
                                    <tr data-status="<%# Eval("CourseStatus").ToString().ToLower() %>" data-title="<%# Eval("CourseTitle").ToString().ToLower() %>">
                                        <td><strong><%# Eval("CourseID") %></strong></td>
                                        <td><%# Eval("CourseTitle") %></td>
                                        <td><%# Eval("CategoryName") %></td>
                                        <td>
                                            <span class="chip chip--<%# Eval("DifficultyLevel").ToString().ToLower() == "intermediate" ? "inter" : Eval("DifficultyLevel").ToString().ToLower() %>"><%# Eval("DifficultyLevel") %></span>
                                        </td>
                                        <td><span class="chip chip--<%# Eval("CourseStatus").ToString().ToLower() %>"><%# Eval("CourseStatus") %></span></td>
                                        <td><%# Eval("StudentCount") %></td>
                                        <td>RM <%# Eval("Price", "{0:0.00}") %></td>
                                        <td class="tbl-actions">
                                            <asp:Button runat="server" Text="Edit" CssClass="tbl-btn tbl-btn--edit"
                                                CommandName="EditCourse" CommandArgument='<%# Eval("CourseID") %>' CausesValidation="false" />
                                            <a href='CourseDetail.aspx?id=<%# Eval("CourseID") %>' class="tbl-btn tbl-btn--view" target="_blank">View</a>
                                            <asp:Button runat="server" Text="Delete" CssClass="tbl-btn tbl-btn--delete"
                                                CommandName="DeleteCourse" CommandArgument='<%# Eval("CourseID") %>' CausesValidation="false"
                                                OnClientClick="return confirm('Delete this course and all its lessons? This cannot be undone.');" />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- ── Upload Material ── -->
            <div class="inst-section" id="section-upload-material">
                <div class="dash-page-header">
                    <h1>Upload Material</h1>
                    <p style="color:var(--text-light);font-size:0.9rem;">Manage lessons and quiz questions for your courses.</p>
                </div>
                <asp:HiddenField ID="hdnUploadCourseID" runat="server" Value="0" />
                <asp:HiddenField ID="hdnEditLessonID" runat="server" Value="0" />
                <asp:HiddenField ID="hdnEditQuizLessonID" runat="server" Value="0" />

                <!-- Course selector -->
                <div class="inst-table-card" style="padding:20px;margin-bottom:20px;">
                    <div class="form-group" style="margin:0;max-width:440px;">
                        <label>Select Course</label>
                        <asp:DropDownList ID="ddlUploadCourse" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlUploadCourse_SelectedIndexChanged" style="width:100%;padding:10px 14px;border:1.5px solid var(--border);border-radius:var(--radius);font-size:0.9rem;outline:none;" />
                    </div>
                </div>

                <!-- Lesson form panel -->
                <asp:Panel ID="pnlLessonForm" runat="server" Visible="false" CssClass="inst-table-card" style="padding:24px;margin-bottom:20px;">
                    <h3 style="margin:0 0 20px;font-size:1rem;"><asp:Literal ID="litLessonFormTitle" runat="server">Add Lesson</asp:Literal></h3>
                    <div class="form-row-2" style="margin-bottom:14px;">
                        <div class="form-group" style="margin:0;">
                            <label>Lesson Title *</label>
                            <asp:TextBox ID="txtLessonTitle" runat="server" />
                        </div>
                        <div style="display:grid;grid-template-columns:1fr 80px;gap:14px;">
                            <div class="form-group" style="margin:0;">
                                <label>Type</label>
                                <asp:DropDownList ID="ddlLessonType" runat="server" onchange="toggleVideoField(this.value)" style="width:100%;padding:10px 14px;border:1.5px solid var(--border);border-radius:var(--radius);font-size:0.9rem;outline:none;">
                                    <asp:ListItem Text="Video" Value="Video" />
                                    <asp:ListItem Text="Quiz" Value="Quiz" />
                                    <asp:ListItem Text="Coding" Value="Coding" />
                                </asp:DropDownList>
                            </div>
                            <div class="form-group" style="margin:0;">
                                <label>Order</label>
                                <asp:TextBox ID="txtLessonOrder" runat="server" placeholder="1" />
                            </div>
                        </div>
                    </div>
                    <div id="videoUrlField" class="form-group">
                        <label>Video URL (.mp4)</label>
                        <asp:TextBox ID="txtVideoURL" runat="server" placeholder="https://…" />
                        <div style="font-size:0.78rem;color:var(--text-light);margin-top:4px;">Direct link to .mp4 file. Leave blank for Quiz / Coding lessons.</div>
                    </div>
                    <div style="display:flex;align-items:center;gap:12px;">
                        <asp:Button ID="btnSaveLesson" runat="server" Text="Save Lesson" CssClass="btn btn--primary btn--sm" OnClick="btnSaveLesson_Click" CausesValidation="false" />
                        <asp:Button ID="btnCancelLesson" runat="server" Text="Cancel" CssClass="btn btn--outline btn--sm" OnClick="btnCancelLesson_Click" CausesValidation="false" />
                        <asp:Label ID="lblLessonMsg" runat="server" style="font-size:0.85rem;" />
                    </div>
                </asp:Panel>

                <!-- Quiz manager panel -->
                <asp:Panel ID="pnlQuizManager" runat="server" Visible="false" CssClass="inst-table-card" style="padding:24px;margin-bottom:20px;">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;">
                        <h3 style="margin:0;font-size:1rem;">Quiz: <asp:Literal ID="litQuizLessonTitle" runat="server" /></h3>
                        <asp:Button ID="btnCloseQuiz" runat="server" Text="Close" CssClass="btn btn--outline btn--sm" OnClick="btnCloseQuiz_Click" CausesValidation="false" />
                    </div>
                    <div style="background:var(--bg-light);border-radius:var(--radius);padding:20px;margin-bottom:20px;">
                        <div class="form-group">
                            <label>Question *</label>
                            <asp:TextBox ID="txtQuizQuestion" runat="server" />
                        </div>
                        <div class="form-row-2" style="margin-bottom:14px;">
                            <div class="form-group" style="margin:0;"><label>Option A</label><asp:TextBox ID="txtOptA" runat="server" /></div>
                            <div class="form-group" style="margin:0;"><label>Option B</label><asp:TextBox ID="txtOptB" runat="server" /></div>
                            <div class="form-group" style="margin:0;"><label>Option C</label><asp:TextBox ID="txtOptC" runat="server" /></div>
                            <div class="form-group" style="margin:0;"><label>Option D</label><asp:TextBox ID="txtOptD" runat="server" /></div>
                        </div>
                        <div class="form-group">
                            <label>Correct Answer</label>
                            <asp:DropDownList ID="ddlCorrectOpt" runat="server" style="width:auto;padding:10px 14px;border:1.5px solid var(--border);border-radius:var(--radius);font-size:0.9rem;outline:none;">
                                <asp:ListItem Text="A" Value="A" /><asp:ListItem Text="B" Value="B" /><asp:ListItem Text="C" Value="C" /><asp:ListItem Text="D" Value="D" />
                            </asp:DropDownList>
                        </div>
                        <div style="display:flex;align-items:center;gap:10px;">
                            <asp:Button ID="btnAddQuestion" runat="server" Text="+ Add Question" CssClass="btn btn--primary btn--sm" OnClick="btnAddQuestion_Click" CausesValidation="false" />
                            <asp:Label ID="lblQuizMsg" runat="server" style="font-size:0.85rem;" />
                        </div>
                    </div>
                    <table class="inst-table">
                        <thead><tr><th>#</th><th>Question</th><th>Correct Answer</th><th>Action</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptQuizQuestions" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Container.ItemIndex + 1 %></td>
                                        <td style="max-width:280px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><%# Eval("QuestionText") %></td>
                                        <td><strong><%# Eval("CorrectOption") %></strong>: <%# GetCorrectOptionText(Eval("CorrectOption"), Eval("OptionA"), Eval("OptionB"), Eval("OptionC"), Eval("OptionD")) %></td>
                                        <td>
                                            <asp:LinkButton runat="server" CommandName="DeleteQ" CommandArgument='<%# Eval("QuizID") %>' CssClass="tbl-btn tbl-btn--delete" OnClientClick="return confirm('Delete question?');" OnCommand="QuizAction_Command">Delete</asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                    <asp:Panel ID="pnlNoQuestions" runat="server" Visible="false">
                        <div class="empty-state">No questions yet. Add one above.</div>
                    </asp:Panel>
                </asp:Panel>

                <!-- Lessons list -->
                <div class="inst-table-card">
                    <div class="inst-table-header">
                        <h3>Lessons (<asp:Literal ID="litLessonCount" runat="server">0</asp:Literal>)</h3>
                        <asp:Button ID="btnShowAddLesson" runat="server" Text="+ Add Lesson" CssClass="btn btn--primary btn--sm" OnClick="btnShowAddLesson_Click" CausesValidation="false" />
                    </div>
                    <table class="inst-table">
                        <thead><tr><th>Order</th><th>Title</th><th>Type</th><th>Video URL</th><th>Actions</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptLessons" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("LessonOrder") %></td>
                                        <td><%# Eval("LessonTitle") %></td>
                                        <td>
                                            <span class="chip chip--<%# Eval("LessonType").ToString() == "Video" ? "published" : Eval("LessonType").ToString() == "Quiz" ? "beginner" : "draft" %>">
                                                <%# Eval("LessonType") %>
                                            </span>
                                        </td>
                                        <td style="font-size:0.82rem;color:var(--text-light);max-width:140px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                                            <%# Eval("ResourceURL") != DBNull.Value && Eval("ResourceURL").ToString() != "" ? Eval("ResourceURL").ToString() : "—" %>
                                        </td>
                                        <td>
                                            <div class="tbl-actions">
                                                <asp:LinkButton runat="server" CommandName="EditLesson" CommandArgument='<%# Eval("LessonID") %>' CssClass="tbl-btn tbl-btn--edit" OnCommand="LessonAction_Command">Edit</asp:LinkButton>
                                                <asp:LinkButton runat="server" CommandName="ManageQuiz" CommandArgument='<%# Eval("LessonID") + "|" + Eval("LessonTitle") %>' CssClass="tbl-btn tbl-btn--view" Visible='<%# Eval("LessonType").ToString() == "Quiz" %>' OnCommand="LessonAction_Command">Questions</asp:LinkButton>
                                                <asp:LinkButton runat="server" CommandName="DeleteLesson" CommandArgument='<%# Eval("LessonID") %>' CssClass="tbl-btn tbl-btn--delete" OnClientClick="return confirm('Delete lesson and all its data?');" OnCommand="LessonAction_Command">Delete</asp:LinkButton>
                                            </div>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                    <asp:Panel ID="pnlNoLessons" runat="server" Visible="false">
                        <div class="empty-state">No lessons. Select a course and add a lesson above.</div>
                    </asp:Panel>
                </div>
            </div>

            <!-- ── My Students ── -->
            <div class="inst-section" id="section-students">
                <div class="dash-page-header">
                    <h1>My Students</h1>
                    <p style="color:var(--text-light);font-size:0.9rem;">Students enrolled in your courses and their progress.</p>
                </div>
                <div class="inst-table-card">
                    <div class="inst-table-header">
                        <h3>Enrolled Students</h3>
                        <div class="filter-row">
                            <div class="inst-search">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                <input type="text" id="studentSearch" placeholder="Search students…" oninput="instFilterStudents()" />
                            </div>
                            <select class="inst-filter-select" id="studentProgressFilter" onchange="instFilterStudents()">
                                <option value="">All Progress</option>
                                <option value="completed">Completed (100%)</option>
                                <option value="inprogress">In Progress</option>
                            </select>
                        </div>
                    </div>
                    <table class="inst-table" id="tblStudents">
                        <thead>
                            <tr><th>Name</th><th>Email</th><th>Course</th><th>Progress</th><th>Certificate</th><th>Enrolled</th></tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptStudents" runat="server">
                                <ItemTemplate>
                                    <tr data-name="<%# (Eval("FirstName").ToString() + " " + Eval("LastName").ToString()).ToLower() %>" data-progress="<%# Eval("OverallProgressPercentage") %>">
                                        <td><strong><%# Eval("FirstName") %> <%# Eval("LastName") %></strong></td>
                                        <td><%# Eval("Email") %></td>
                                        <td><%# Eval("CourseTitle") %></td>
                                        <td>
                                            <div style="display:flex;align-items:center;gap:8px;">
                                                <div class="prog-bar-wrap"><div class="prog-bar" style="width:<%# Eval("OverallProgressPercentage") %>%;<%# Convert.ToDouble(Eval("OverallProgressPercentage")) >= 100 ? "background:#22c55e;" : "" %>"></div></div>
                                                <span style="font-size:0.82rem;"><%# Eval("OverallProgressPercentage", "{0:0}") %>%</span>
                                            </div>
                                        </td>
                                        <td><%# Convert.ToDouble(Eval("OverallProgressPercentage")) >= 100 ? "✅ Issued" : "—" %></td>
                                        <td><%# Eval("EnrollDate", "{0:dd MMM yyyy}") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                    <asp:Panel ID="pnlNoStudents" runat="server" Visible="false">
                        <div class="empty-state">No students enrolled yet.</div>
                    </asp:Panel>
                </div>
            </div>

            <!-- ── Reviews ── -->
            <div class="inst-section" id="section-reviews">
                <div class="dash-page-header">
                    <h1>Course Reviews</h1>
                    <p style="color:var(--text-light);font-size:0.9rem;">What your students are saying about your courses.</p>
                </div>
                <asp:Repeater ID="rptReviews" runat="server">
                    <ItemTemplate>
                        <div class="review-card">
                            <div style="display:flex;justify-content:space-between;align-items:flex-start;">
                                <div>
                                    <div class="review-card__meta">
                                        <strong><%# Eval("FirstName") %> <%# Eval("LastName") %></strong>
                                        <span class="review-card__stars"><%# new string('★', Convert.ToInt32(Eval("Rating"))) %><%# new string('☆', 5 - Convert.ToInt32(Eval("Rating"))) %></span>
                                        <span style="font-size:0.78rem;color:var(--text-light);"><%# Eval("CourseTitle") %></span>
                                    </div>
                                    <p style="font-size:0.88rem;margin:0;color:var(--text-mid);">"<%# Eval("Comment") %>"</p>
                                </div>
                                <span style="font-size:0.78rem;color:var(--text-light);white-space:nowrap;margin-left:16px;"><%# Eval("ReviewDate", "{0:dd MMM yyyy}") %></span>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlNoReviews" runat="server" Visible="false">
                    <div class="empty-state">No reviews yet.</div>
                </asp:Panel>
            </div>

            <!-- ── Support History ── -->
            <div class="inst-section" id="section-support-history">
                <div class="dash-page-header">
                    <h1>My Support History</h1>
                    <p style="color:var(--text-light);font-size:0.9rem;">Track the status of your submitted tickets.</p>
                </div>
                <div style="background:white;border-radius:var(--radius-lg);border:1px solid var(--border);overflow:hidden;">
                    <div style="padding:18px 24px;border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;">
                        <h3 style="font-size:1rem;margin:0;">Submitted Tickets</h3>
                        <a href="Support.aspx" class="btn btn--primary btn--sm">Submit New Ticket</a>
                    </div>
                    <asp:Panel ID="pnlNoInstTickets" runat="server" Visible="false">
                        <div class="support-empty">
                            <div class="support-empty__icon">🎫</div>
                            <p class="support-empty__title">No support tickets submitted yet</p>
                            <p style="font-size:0.88rem;">When you submit a ticket, it will appear here for tracking.</p>
                        </div>
                    </asp:Panel>
                    <table class="ticket-table" id="tblTickets">
                        <thead>
                            <tr><th>Ticket #</th><th>Subject</th><th>Status</th><th>Date</th></tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptInstTickets" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><strong>#T-<%# Eval("TicketID") %></strong></td>
                                        <td><%# Eval("Subject") %></td>
                                        <td><span class="badge badge--<%# Eval("TicketStatus").ToString().ToLower().Replace(" ","-") %>"><%# Eval("TicketStatus") %></span></td>
                                        <td><%# Eval("CreatedDate", "{0:dd MMM yyyy}") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- ── My Profile ── -->
            <div class="inst-section" id="section-profile">
                <div class="dash-page-header">
                    <h1>My Profile</h1>
                    <p style="color:var(--text-light);font-size:0.9rem;">Update your personal information.</p>
                </div>
                <div style="background:white;border-radius:var(--radius-lg);border:1px solid var(--border);padding:32px;max-width:560px;">
                    <div style="display:flex;align-items:center;gap:16px;margin-bottom:28px;">
                        <div class="sidebar__avatar" style="width:72px;height:72px;font-size:1.4rem;flex-shrink:0;"><asp:Literal ID="litProfileAvatar" runat="server" /></div>
                        <div>
                            <div style="font-weight:700;font-size:1.1rem;"><asp:Literal ID="litProfileName" runat="server" /></div>
                            <div style="font-size:0.85rem;color:var(--text-light);"><asp:Literal ID="litProfileEmailDisp" runat="server" /></div>
                        </div>
                    </div>
                    <div class="form-row-2">
                        <div class="form-group">
                            <label>First Name</label>
                            <asp:TextBox ID="txtProfileFirstName" runat="server" />
                        </div>
                        <div class="form-group">
                            <label>Last Name</label>
                            <asp:TextBox ID="txtProfileLastName" runat="server" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Avatar Initials</label>
                        <asp:TextBox ID="txtProfileAvatar" runat="server" MaxLength="3" placeholder="e.g. JS" />
                        <div style="font-size:0.78rem;color:var(--text-light);margin-top:4px;">2–3 characters shown in your avatar circle.</div>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <div style="padding:10px 14px;border:1.5px solid var(--border);border-radius:var(--radius);background:var(--bg-light);font-size:0.9rem;color:var(--text-light);"><asp:Literal ID="litProfileEmailRO" runat="server" /></div>
                        <div style="font-size:0.78rem;color:var(--text-light);margin-top:4px;">Email cannot be changed.</div>
                    </div>
                    <asp:Button ID="btnSaveProfile" runat="server" Text="Save Changes" CssClass="btn btn--primary btn--sm" OnClick="btnSaveProfile_Click" CausesValidation="false" />
                    <asp:Label ID="lblProfileMsg" runat="server" style="margin-left:12px;font-size:0.85rem;" />
                </div>
            </div>

            <!-- ── Settings ── -->
            <div class="inst-section" id="section-settings">
                <div class="dash-page-header">
                    <h1>Settings</h1>
                    <p style="color:var(--text-light);font-size:0.9rem;">Manage your account security and preferences.</p>
                </div>

                <!-- Password change -->
                <div style="background:white;border-radius:var(--radius-lg);border:1px solid var(--border);padding:32px;max-width:480px;margin-bottom:20px;">
                    <h3 style="margin:0 0 20px;font-size:1rem;">Change Password</h3>
                    <div class="form-group">
                        <label>Current Password</label>
                        <asp:TextBox ID="txtCurrentPwd" runat="server" TextMode="Password" />
                    </div>
                    <div class="form-group">
                        <label>New Password</label>
                        <asp:TextBox ID="txtNewPwd" runat="server" TextMode="Password" />
                    </div>
                    <div class="form-group">
                        <label>Confirm New Password</label>
                        <asp:TextBox ID="txtConfirmPwd" runat="server" TextMode="Password" />
                    </div>
                    <asp:Button ID="btnChangePassword" runat="server" Text="Update Password" CssClass="btn btn--primary btn--sm" OnClick="btnChangePassword_Click" CausesValidation="false" />
                    <asp:Label ID="lblPwdMsg" runat="server" style="display:block;margin-top:10px;font-size:0.85rem;" />
                </div>

                <!-- Preferences (cosmetic) -->
                <div style="background:white;border-radius:var(--radius-lg);border:1px solid var(--border);padding:24px 32px;max-width:480px;">
                    <h3 style="margin:0 0 4px;font-size:1rem;">Preferences</h3>
                    <div class="settings-row">
                        <div>
                            <strong>Email Notifications</strong>
                            <p style="font-size:0.85rem;margin:0;color:var(--text-light);">Receive enrolment and review alerts</p>
                        </div>
                        <div class="toggle-wrap" onclick="instToggle(this)">
                            <div class="toggle-track on"></div>
                            <div class="toggle-thumb"></div>
                        </div>
                    </div>
                    <div class="settings-row">
                        <div>
                            <strong>Two-Factor Authentication</strong>
                            <p style="font-size:0.85rem;margin:0;color:var(--text-light);">Add extra security to your account</p>
                        </div>
                        <button class="btn btn--outline btn--sm" onclick="return false;">Enable</button>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <!-- ── Add / Edit Course Modal ── -->
    <div class="modal-overlay" id="courseModal">
        <div class="modal-box">
            <div class="modal-header">
                <h3 id="courseModalTitle">Add New Course</h3>
                <asp:Button ID="btnCancelCourse" runat="server" Text="✕" CssClass="modal-close" OnClick="btnCancelCourse_Click" CausesValidation="false" />
            </div>
            <div class="modal-body">
                <asp:Label ID="lblCourseMsg" runat="server" Visible="false" CssClass="form-msg-error" />
                <div class="form-group">
                    <label>Course Title *</label>
                    <asp:TextBox ID="txtCourseTitle" runat="server" placeholder="e.g. Advanced Python Programming" />
                </div>
                <div class="form-row-2">
                    <div class="form-group">
                        <label>Category *</label>
                        <asp:DropDownList ID="ddlCourseCategory" runat="server" />
                    </div>
                    <div class="form-group">
                        <label>Level *</label>
                        <asp:DropDownList ID="ddlCourseLevel" runat="server">
                            <asp:ListItem Text="Beginner" Value="Beginner" />
                            <asp:ListItem Text="Intermediate" Value="Intermediate" />
                            <asp:ListItem Text="Advanced" Value="Advanced" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="form-group">
                    <label>Price (RM)</label>
                    <asp:TextBox ID="txtCoursePrice" runat="server" placeholder="0" />
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <asp:TextBox ID="txtCourseDesc" runat="server" TextMode="MultiLine" placeholder="Brief description of the course…" />
                </div>
                <div class="form-group">
                    <label>Status</label>
                    <asp:DropDownList ID="ddlCourseStatus" runat="server">
                        <asp:ListItem Text="Draft" Value="Draft" />
                        <asp:ListItem Text="Published" Value="Published" />
                        <asp:ListItem Text="Archived" Value="Archived" />
                    </asp:DropDownList>
                </div>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnCancelCourse2" runat="server" Text="Cancel" CssClass="btn btn--outline" OnClick="btnCancelCourse_Click" CausesValidation="false" />
                <asp:Button ID="btnSaveCourse" runat="server" Text="Save Course" CssClass="btn btn--primary" OnClick="btnSaveCourse_Click" CausesValidation="false" />
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        // @ts-nocheck
        function showInstSection(name, el) {
            document.querySelectorAll('.inst-section').forEach(function (s) { s.classList.remove('active'); });
            var sec = document.getElementById('section-' + name);
            if (sec) sec.classList.add('active');
            document.querySelectorAll('.sidebar__nav-item').forEach(function (i) { i.classList.remove('active'); });
            if (el) el.classList.add('active');
            var hdn = document.getElementById('<%= hdnActiveSection.ClientID %>');
            if (hdn) hdn.value = name;
        }

        // Restore active section after postback
        (function () {
    var hdn = document.getElementById('<%= hdnActiveSection.ClientID %>');
    if (!hdn) return;
    var active = hdn.value || 'overview';
    var navEl = document.getElementById('nav-' + active);
    showInstSection(active, navEl);
})();

// Course modal
function openCourseModal(isEdit) {
    document.getElementById('courseModal').classList.add('open');
    var t = document.getElementById('courseModalTitle');
    if (t) t.textContent = isEdit ? 'Edit Course' : 'Add New Course';
}
function closeCourseModal() {
    document.getElementById('courseModal').classList.remove('open');
}
// Restore modal open state after postback
(function () {
    var hdn = document.getElementById('<%= hdnShowCourseModal.ClientID %>');
    if (hdn && hdn.value === 'true') {
        var isEdit = document.getElementById('<%= hdnEditCourseID.ClientID %>').value !== '0';
        openCourseModal(isEdit);
    }
})();
// Close modal when clicking overlay background
document.getElementById('courseModal').addEventListener('click', function (e) {
    if (e.target === this) closeCourseModal();
});

function toggleVideoField(type) {
    var f = document.getElementById('videoUrlField');
    if (f) f.style.display = (type === 'Video') ? 'block' : 'none';
}

// My Courses search/filter
function instSearchCourses(q) {
    var ql = q.toLowerCase();
    document.querySelectorAll('#tblMyCourses tbody tr').forEach(function(tr) {
        tr.style.display = tr.dataset.title.includes(ql) ? '' : 'none';
    });
}
function instFilterCourses(val) {
    document.querySelectorAll('#tblMyCourses tbody tr').forEach(function(tr) {
        tr.style.display = (!val || tr.dataset.status === val) ? '' : 'none';
    });
}

// Students filter
function instFilterStudents() {
    var q = (document.getElementById('studentSearch').value || '').toLowerCase();
    var prog = document.getElementById('studentProgressFilter').value;
    document.querySelectorAll('#tblStudents tbody tr').forEach(function (tr) {
        var matchQ = !q || (tr.dataset.name || '').includes(q);
        var pct = parseInt(tr.dataset.progress || '0', 10);
        var matchP = !prog || (prog === 'completed' ? pct >= 100 : pct < 100);
        tr.style.display = (matchQ && matchP) ? '' : 'none';
    });
}

// Settings toggle
function instToggle(wrap) {
    var track = wrap.querySelector('.toggle-track');
    track.classList.toggle('on');
}

// Support history: hide table when no rows
(function() {
    var tbl = document.getElementById('tblTickets');
    if (!tbl) return;
    var rows = tbl.querySelectorAll('tbody tr');
    if (rows.length === 0) tbl.style.display = 'none';
})();
    </script>
</asp:Content>
