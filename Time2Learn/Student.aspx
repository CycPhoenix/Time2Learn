<%@ Page Title="My Dashboard - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Student.aspx.cs" Inherits="Time2Learn.Student" %>

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
        .stats-grid { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:28px; }
        .dash-stat-card { background:white; border-radius:var(--radius); border:1px solid var(--border); padding:20px 24px; }
        .dash-stat-card__label { font-size:0.82rem; color:var(--text-light); margin-bottom:8px; font-weight:600; }
        .dash-stat-card__value { font-size:2rem; font-weight:800; color:var(--text-dark); margin-bottom:4px; }
        .dash-stat-card__change { font-size:0.78rem; color:var(--primary); font-weight:600; }
        .enrolled-courses { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); overflow:hidden; margin-top:24px; }
        .enrolled-courses__header { display:flex; justify-content:space-between; align-items:center; padding:18px 24px; border-bottom:1px solid var(--border); }
        .enrolled-courses__header h3 { font-size:1rem; }
        .progress-card { display:flex; align-items:center; gap:16px; padding:16px 24px; border-bottom:1px solid var(--border); }
        .progress-card:last-child { border-bottom:none; }
        .progress-card__thumb { width:48px; height:48px; border-radius:var(--radius); display:flex; align-items:center; justify-content:center; font-size:1.5rem; flex-shrink:0; }
        .progress-card__info { flex:1; min-width:0; }
        .progress-card__title { font-weight:600; font-size:0.92rem; margin-bottom:4px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .progress-card__meta { font-size:0.78rem; color:var(--text-light); margin-bottom:6px; }
        .progress-bar { height:6px; background:var(--bg-light); border-radius:4px; overflow:hidden; }
        .progress-bar__fill { height:100%; background:var(--primary); border-radius:4px; }
        .progress-card__pct { font-size:0.82rem; font-weight:700; color:var(--primary); width:36px; text-align:right; flex-shrink:0; }
        .ticket-table { width:100%; border-collapse:collapse; }
        .ticket-table th { background:var(--bg-light); padding:12px 16px; text-align:left; font-size:0.82rem; color:var(--text-light); font-weight:600; text-transform:uppercase; letter-spacing:0.04em; }
        .ticket-table td { padding:14px 16px; border-bottom:1px solid var(--border); font-size:0.9rem; }
        .badge { padding:3px 10px; border-radius:20px; font-size:0.78rem; font-weight:600; }
        .badge--open     { background:#fef3c7; color:#92400e; }
        .badge--resolved { background:#d1fae5; color:#065f46; }
        .badge--closed   { background:#f1f5f9; color:#475569; }
        .badge--in-progress { background:#e0e7ff; color:#3730a3; }
        .empty-state { padding:60px 24px; text-align:center; color:var(--text-light); }

        /* Dark mode */
        [data-theme="dark"] .dashboard-layout { background:#18191a; }
        [data-theme="dark"] .dashboard-content { background:#18191a; }
        [data-theme="dark"] .dash-stat-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .dash-stat-card__value { color:#fff; }
        [data-theme="dark"] .enrolled-courses { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .enrolled-courses__header { border-color:#333; }
        [data-theme="dark"] .enrolled-courses__header h3 { color:#fff; }
        [data-theme="dark"] .progress-card { border-color:#333; }
        [data-theme="dark"] .progress-card__title { color:#fff; }
        [data-theme="dark"] .progress-bar { background:#333; }
        [data-theme="dark"] .ticket-table th { background:#333; color:#aaa; }
        [data-theme="dark"] .ticket-table td { border-color:#333; color:#ccc; }
        [data-theme="dark"] .dash-page-header h1 { color:#fff; }
        [data-theme="dark"] div[style*="background:white"] { background:#2a2a2e !important; }
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
                <div class="sidebar__section-label">Student</div>
                <div class="sidebar__nav-item active" onclick="showDashSection('overview', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
                    Overview
                </div>
                <div class="sidebar__nav-item" onclick="showDashSection('my-courses', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M21 5c-1.11-.35-2.33-.5-3.5-.5-1.95 0-4.05.4-5.5 1.5-1.45-1.1-3.55-1.5-5.5-1.5S2.45 4.9 1 6v14.65c0 .25.25.5.5.5.1 0 .15-.05.25-.05C3.1 20.45 5.05 20 6.5 20c1.95 0 4.05.4 5.5 1.5 1.35-.85 3.8-1.5 5.5-1.5 1.65 0 3.35.3 4.75 1.05.1.05.15.05.25.05.25 0 .5-.25.5-.5V6c-.6-.45-1.25-.75-2-1zm0 13.5c-1.1-.35-2.3-.5-3.5-.5-1.7 0-4.15.65-5.5 1.5V8c1.35-.85 3.8-1.5 5.5-1.5 1.2 0 2.4.15 3.5.5v11.5z"/></svg>
                    My Courses
                </div>
                <div class="sidebar__nav-item" onclick="showDashSection('support-history', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/></svg>
                    Support History
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
                    <h1>Welcome back, <asp:Literal ID="litWelcomeName" runat="server" />! 👋</h1>
                    <p>Track your learning progress and continue where you left off.</p>
                </div>
                <div class="stats-grid">
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">Courses Enrolled</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litEnrollCount" runat="server">0</asp:Literal></div>
                    </div>
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">Certificates Earned</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litCertCount" runat="server">0</asp:Literal></div>
                    </div>
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">Avg. Progress</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litAvgProgress" runat="server">0</asp:Literal>%</div>
                    </div>
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">Open Tickets</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litTicketCount" runat="server">0</asp:Literal></div>
                    </div>
                </div>

                <div class="enrolled-courses">
                    <div class="enrolled-courses__header">
                        <h3>Continue Learning</h3>
                        <a href="Courses.aspx" class="btn btn--outline btn--sm">Browse More</a>
                    </div>
                    <asp:Repeater ID="rptContinueLearning" runat="server">
                        <ItemTemplate>
                            <div class="progress-card">
                                <div class="progress-card__thumb" style="background:linear-gradient(135deg,#a435f0,#7c2bd1);">📚</div>
                                <div class="progress-card__info">
                                    <div class="progress-card__title"><%# Eval("CourseTitle") %></div>
                                    <div class="progress-card__meta">Enrolled <%# Eval("EnrollDate", "{0:dd MMM yyyy}") %></div>
                                    <div class="progress-bar"><div class="progress-bar__fill" style="width:<%# Eval("OverallProgressPercentage") %>%;"></div></div>
                                </div>
                                <div class="progress-card__pct"><%# Eval("OverallProgressPercentage", "{0:0}") %>%</div>
                                <a href="LearningMaterial.aspx?id=<%# Eval("CourseID") %>" class="btn btn--primary btn--sm" style="margin-left:12px;white-space:nowrap;">Continue</a>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:Panel runat="server" Visible='<%# rptContinueLearning.Items.Count == 0 %>'>
                                <div class="empty-state">No courses enrolled yet. <a href="Courses.aspx">Browse courses →</a></div>
                            </asp:Panel>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <!-- My Courses -->
            <div class="inst-section" id="section-my-courses">
                <div class="dash-page-header"><h1>My Courses</h1><p>All your enrolled courses.</p></div>
                <div class="enrolled-courses">
                    <asp:Repeater ID="rptMyCourses" runat="server">
                        <ItemTemplate>
                            <div class="progress-card">
                                <div class="progress-card__thumb" style="background:linear-gradient(135deg,#a435f0,#7c2bd1);">📚</div>
                                <div class="progress-card__info">
                                    <div class="progress-card__title"><%# Eval("CourseTitle") %></div>
                                    <div class="progress-card__meta"><%# Eval("CategoryName") %> · Enrolled <%# Eval("EnrollDate", "{0:dd MMM yyyy}") %></div>
                                    <div class="progress-bar"><div class="progress-bar__fill" style="width:<%# Eval("OverallProgressPercentage") %>%;"></div></div>
                                </div>
                                <div class="progress-card__pct"><%# Eval("OverallProgressPercentage", "{0:0}") %>%</div>
                                <a href="LearningMaterial.aspx?id=<%# Eval("CourseID") %>" class="btn btn--primary btn--sm" style="margin-left:12px;">Continue</a>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <!-- Support History -->
            <div class="inst-section" id="section-support-history">
                <div class="dash-page-header">
                    <div style="display:flex;justify-content:space-between;align-items:center;">
                        <div><h1>Support History</h1><p>Your submitted support tickets.</p></div>
                        <a href="Support.aspx" class="btn btn--primary btn--sm">New Ticket</a>
                    </div>
                </div>
                <div style="background:white;border-radius:var(--radius-lg);border:1px solid var(--border);overflow:hidden;">
                    <table class="ticket-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Subject</th>
                                <th>Status</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptTickets" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("TicketID") %></td>
                                        <td><%# Eval("Subject") %></td>
                                        <td><span class="badge badge--<%# Eval("TicketStatus").ToString().ToLower().Replace(" ","-") %>"><%# Eval("TicketStatus") %></span></td>
                                        <td><%# Eval("CreatedDate", "{0:dd MMM yyyy}") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                    <asp:Panel ID="pnlNoTickets" runat="server" Visible="false">
                        <div class="empty-state">No tickets submitted yet.</div>
                    </asp:Panel>
                </div>
            </div>

        </main>
    </div>
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
// @ts-nocheck
function showDashSection(name, el) {
    document.querySelectorAll('.inst-section').forEach(function (s) { s.classList.remove('active'); });
    var sec = document.getElementById('section-' + name);
    if (sec) sec.classList.add('active');
    document.querySelectorAll('.sidebar__nav-item').forEach(function (i) { i.classList.remove('active'); });
    if (el) el.classList.add('active');
}
</script>
</asp:Content>
