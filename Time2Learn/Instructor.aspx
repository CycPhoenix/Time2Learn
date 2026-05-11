<%@ Page Title="Instructor Panel - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Instructor.aspx.cs" Inherits="Time2Learn.Instructor" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .dashboard-layout { display:flex; min-height:calc(100vh - 64px); background:var(--bg-light); }
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
        .dashboard-content { flex:1; padding:32px; overflow-y:auto; }
        .inst-section { display:none; }
        .inst-section.active { display:block; }
        .dash-page-header { margin-bottom:24px; }
        .dash-page-header h1 { font-size:1.7rem; margin-bottom:6px; }
        .stats-grid { display:grid; grid-template-columns:repeat(3,1fr); gap:16px; margin-bottom:28px; }
        .dash-stat-card { background:white; border-radius:var(--radius); border:1px solid var(--border); padding:20px 24px; }
        .dash-stat-card__label { font-size:0.82rem; color:var(--text-light); margin-bottom:8px; font-weight:600; }
        .dash-stat-card__value { font-size:2rem; font-weight:800; color:var(--text-dark); }
        .admin-table-wrap { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); overflow:hidden; margin-top:0; }
        .admin-table-header { display:flex; justify-content:space-between; align-items:center; padding:16px 20px; border-bottom:1px solid var(--border); }
        .admin-table-header h3 { font-size:1rem; margin:0; }
        .data-table { width:100%; border-collapse:collapse; }
        .data-table th { background:var(--bg-light); padding:11px 16px; text-align:left; font-size:0.8rem; color:var(--text-light); font-weight:600; text-transform:uppercase; letter-spacing:0.04em; }
        .data-table td { padding:13px 16px; border-bottom:1px solid var(--border); font-size:0.88rem; vertical-align:middle; }
        .data-table tr:last-child td { border-bottom:none; }
        .badge { padding:3px 10px; border-radius:20px; font-size:0.78rem; font-weight:600; }
        .badge--active { background:#d1fae5; color:#065f46; }
        .badge--draft    { background:#f1f5f9; color:#475569; }
        .badge--pending  { background:#fef3c7; color:#92400e; }
        .star-rating { color:#f59e0b; font-weight:700; }
        .empty-state { padding:60px 24px; text-align:center; color:var(--text-light); }
        .progress-bar { height:6px; background:var(--bg-light); border-radius:4px; overflow:hidden; width:100px; display:inline-block; vertical-align:middle; margin-right:6px; }
        .progress-bar__fill { height:100%; background:var(--primary); border-radius:4px; }

        /* Dark mode */
        [data-theme="dark"] .dashboard-layout { background:#18191a; }
        [data-theme="dark"] .dashboard-content { background:#18191a; }
        [data-theme="dark"] .dash-stat-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .dash-stat-card__value { color:#fff; }
        [data-theme="dark"] .dash-page-header h1 { color:#fff; }
        [data-theme="dark"] .admin-table-wrap { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .admin-table-header { border-color:#333; }
        [data-theme="dark"] .admin-table-header h3 { color:#fff; }
        [data-theme="dark"] .data-table th { background:#333; color:#aaa; }
        [data-theme="dark"] .data-table td { border-color:#333; color:#ccc; }
        [data-theme="dark"] .progress-bar { background:#333; }
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
                <div class="sidebar__nav-item active" onclick="showInstSection('overview', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
                    Overview
                </div>
                <div class="sidebar__nav-item" onclick="showInstSection('my-courses', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M21 5c-1.11-.35-2.33-.5-3.5-.5-1.95 0-4.05.4-5.5 1.5-1.45-1.1-3.55-1.5-5.5-1.5S2.45 4.9 1 6v14.65c0 .25.25.5.5.5.1 0 .15-.05.25-.05C3.1 20.45 5.05 20 6.5 20c1.95 0 4.05.4 5.5 1.5 1.35-.85 3.8-1.5 5.5-1.5 1.65 0 3.35.3 4.75 1.05.1.05.15.05.25.05.25 0 .5-.25.5-.5V6c-.6-.45-1.25-.75-2-1zm0 13.5c-1.1-.35-2.3-.5-3.5-.5-1.7 0-4.15.65-5.5 1.5V8c1.35-.85 3.8-1.5 5.5-1.5 1.2 0 2.4.15 3.5.5v11.5z"/></svg>
                    My Courses
                </div>
                <div class="sidebar__nav-item" onclick="showInstSection('students', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
                    My Students
                </div>
                <div class="sidebar__nav-item" onclick="showInstSection('reviews', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
                    Reviews
                </div>
                <div class="sidebar__section-label">Account</div>
                <a href="Logout.aspx" class="sidebar__nav-item" style="color:#ef4444;">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>
                    Log Out
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="dashboard-content">

            <!-- Overview -->
            <div class="inst-section active" id="section-overview">
                <div class="dash-page-header">
                    <h1>Welcome, <asp:Literal ID="litWelcomeName" runat="server" />!</h1>
                    <p>Manage your courses and track student progress.</p>
                </div>
                <div class="stats-grid">
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
                </div>
                <div class="admin-table-wrap">
                    <div class="admin-table-header"><h3>My Courses</h3></div>
                    <table class="data-table">
                        <thead><tr><th>Title</th><th>Status</th><th>Students</th><th>Rating</th><th>Price</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptOverviewCourses" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("CourseTitle") %></td>
                                        <td><span class="badge badge--<%# Eval("CourseStatus").ToString().ToLower() %>"><%# Eval("CourseStatus") %></span></td>
                                        <td><%# Eval("StudentCount") %></td>
                                        <td><span class="star-rating">★</span> <%# Eval("AvgRating", "{0:0.0}") %></td>
                                        <td>RM <%# Eval("Price", "{0:0.00}") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- My Courses -->
            <div class="inst-section" id="section-my-courses">
                <div class="dash-page-header"><h1>My Courses</h1><p>All courses you've created.</p></div>
                <div class="admin-table-wrap">
                    <table class="data-table">
                        <thead><tr><th>#</th><th>Title</th><th>Category</th><th>Level</th><th>Status</th><th>Students</th><th>Price</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptMyCourses" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("CourseID") %></td>
                                        <td><%# Eval("CourseTitle") %></td>
                                        <td><%# Eval("CategoryName") %></td>
                                        <td><%# Eval("DifficultyLevel") %></td>
                                        <td><span class="badge badge--<%# Eval("CourseStatus").ToString().ToLower() %>"><%# Eval("CourseStatus") %></span></td>
                                        <td><%# Eval("StudentCount") %></td>
                                        <td>RM <%# Eval("Price", "{0:0.00}") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Students -->
            <div class="inst-section" id="section-students">
                <div class="dash-page-header"><h1>My Students</h1><p>Students enrolled in your courses.</p></div>
                <div class="admin-table-wrap">
                    <table class="data-table">
                        <thead><tr><th>Name</th><th>Email</th><th>Course</th><th>Progress</th><th>Enrolled</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptStudents" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("FirstName") %> <%# Eval("LastName") %></td>
                                        <td><%# Eval("Email") %></td>
                                        <td><%# Eval("CourseTitle") %></td>
                                        <td>
                                            <div class="progress-bar"><div class="progress-bar__fill" style="width:<%# Eval("OverallProgressPercentage") %>%;"></div></div>
                                            <%# Eval("OverallProgressPercentage", "{0:0}") %>%
                                        </td>
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

            <!-- Reviews -->
            <div class="inst-section" id="section-reviews">
                <div class="dash-page-header"><h1>Reviews</h1><p>Student reviews for your courses.</p></div>
                <div class="admin-table-wrap">
                    <table class="data-table">
                        <thead><tr><th>Student</th><th>Course</th><th>Rating</th><th>Comment</th><th>Date</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptReviews" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("FirstName") %> <%# Eval("LastName") %></td>
                                        <td><%# Eval("CourseTitle") %></td>
                                        <td><span class="star-rating">★</span> <%# Eval("Rating") %></td>
                                        <td><%# Eval("Comment") %></td>
                                        <td><%# Eval("ReviewDate", "{0:dd MMM yyyy}") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                    <asp:Panel ID="pnlNoReviews" runat="server" Visible="false">
                        <div class="empty-state">No reviews yet.</div>
                    </asp:Panel>
                </div>
            </div>

        </main>
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
}
</script>
</asp:Content>
