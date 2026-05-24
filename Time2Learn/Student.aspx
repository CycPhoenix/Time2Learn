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

        /* ── Form / Profile ── */
        .form-group { margin-bottom:16px; }
        .form-group label { display:block; font-weight:600; font-size:0.85rem; margin-bottom:6px; color:var(--text-dark); }
        .form-group input, .form-group select, .form-group textarea { width:100%; padding:10px 14px; border:1.5px solid var(--border); border-radius:var(--radius); font-size:0.9rem; outline:none; transition:border-color 0.2s; font-family:inherit; background:white; box-sizing:border-box; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { border-color:var(--primary); }
        .form-row-2 { display:grid; grid-template-columns:1fr 1fr; gap:14px; }
        /* ── Toggle switches ── */
        .settings-row { display:flex; justify-content:space-between; align-items:center; padding:16px 0; border-bottom:1px solid var(--border); }
        .settings-row:last-child { border-bottom:none; }
        .toggle-wrap { position:relative; width:44px; height:24px; cursor:pointer; flex-shrink:0; }
        .toggle-track { position:absolute; inset:0; background:#ccc; border-radius:12px; transition:0.3s; }
        .toggle-track.on { background:var(--primary); }
        .toggle-thumb { position:absolute; top:2px; left:2px; width:20px; height:20px; border-radius:50%; background:white; transition:0.3s; }
        .toggle-track.on + .toggle-thumb { left:22px; }
        
        /* ── Certificates ── */
        .cert-grid { display:grid; grid-template-columns:repeat(2,1fr); gap:20px; }
        .cert-card { background:linear-gradient(135deg,var(--primary),#7c3aed); color:white; border-radius:var(--radius-lg); padding:32px; text-align:center; }

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
                <div class="sidebar__nav-item active" id="nav-overview" onclick="showDashSection('overview', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
                    Overview
                </div>
                <div class="sidebar__nav-item" id="nav-my-courses" onclick="showDashSection('my-courses', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M21 5c-1.11-.35-2.33-.5-3.5-.5-1.95 0-4.05.4-5.5 1.5-1.45-1.1-3.55-1.5-5.5-1.5S2.45 4.9 1 6v14.65c0 .25.25.5.5.5.1 0 .15-.05.25-.05C3.1 20.45 5.05 20 6.5 20c1.95 0 4.05.4 5.5 1.5 1.35-.85 3.8-1.5 5.5-1.5 1.65 0 3.35.3 4.75 1.05.1.05.15.05.25.05.25 0 .5-.25.5-.5V6c-.6-.45-1.25-.75-2-1zm0 13.5c-1.1-.35-2.3-.5-3.5-.5-1.7 0-4.15.65-5.5 1.5V8c1.35-.85 3.8-1.5 5.5-1.5 1.2 0 2.4.15 3.5.5v11.5z"/></svg>
                    My Courses
                </div>
                <div class="sidebar__nav-item" id="nav-certificates" onclick="showDashSection('certificates', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M17 12h-5v5h5v-5zM16 1v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2h-1V1h-2zm3 18H5V8h14v11z"/></svg>
                    Certificates
                </div>
                <div class="sidebar__nav-item" id="nav-support-history" onclick="showDashSection('support-history', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/></svg>
                    Support History
                </div>
                <div class="sidebar__section-label">Account</div>
                <div class="sidebar__nav-item" id="nav-profile" onclick="showDashSection('profile', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                    My Profile
                </div>
                <div class="sidebar__nav-item" id="nav-settings" onclick="showDashSection('settings', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"/></svg>
                    Settings
                </div>
                <a href="Logout.aspx" class="sidebar__nav-item" style="color:#ef4444;">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>
                    Log Out
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <asp:HiddenField ID="hdnActiveSection" runat="server" Value="overview" />
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

            <!-- Certificates -->
            <div class="inst-section" id="section-certificates">
                <div class="dash-page-header"><h1>My Certificates</h1><p>Download and share your achievements.</p></div>
                <div class="cert-grid">
                    <asp:Repeater ID="rptCertificates" runat="server">
                        <ItemTemplate>
                            <div class="cert-card">
                                <div style="font-size:2rem;margin-bottom:12px;">🏆</div>
                                <h3 style="color:white;margin-bottom:8px;">Certificate of Completion</h3>
                                <p style="color:rgba(255,255,255,0.8);margin-bottom:8px;"><%# Eval("CourseTitle") %></p>
                                <p style="color:rgba(255,255,255,0.65);font-size:0.82rem;margin-bottom:16px;">Completed <%# Eval("EnrollDate", "{0:dd MMM yyyy}") %></p>
                                <button type="button" class="btn btn--white btn--sm">Download PDF</button>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <asp:Panel ID="pnlNoCerts" runat="server" Visible="false">
                    <div class="empty-state" style="background:white;border-radius:var(--radius-lg);border:1px solid var(--border);">
                        <div style="font-size:2.5rem;margin-bottom:16px;">🏆</div>
                        <p style="font-weight:600;color:var(--text-dark);margin-bottom:8px;">No certificates yet</p>
                        <p style="font-size:0.88rem;">Complete a course to earn your first certificate.</p>
                        <a href="Courses.aspx" class="btn btn--primary btn--sm" style="display:inline-block;margin-top:16px;">Browse Courses</a>
                    </div>
                </asp:Panel>
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

            <!-- My Profile -->
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

            <!-- Settings -->
            <div class="inst-section" id="section-settings">
                <div class="dash-page-header">
                    <h1>Settings</h1>
                    <p style="color:var(--text-light);font-size:0.9rem;">Manage your account security and preferences.</p>
                </div>
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
                <div style="background:white;border-radius:var(--radius-lg);border:1px solid var(--border);padding:24px 32px;max-width:480px;">
                    <h3 style="margin:0 0 4px;font-size:1rem;">Preferences</h3>
                    <div class="settings-row">
                        <div>
                            <strong>Email Notifications</strong>
                            <p style="font-size:0.85rem;margin:0;color:var(--text-light);">Receive updates and alerts via email</p>
                        </div>
                        <div class="toggle-wrap" onclick="dashToggle(this)">
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
    var hdn = document.getElementById('<%= hdnActiveSection.ClientID %>');
    if (hdn) hdn.value = name;
}

(function () {
    var hdn = document.getElementById('<%= hdnActiveSection.ClientID %>');
    if (!hdn) return;
    var active = hdn.value || 'overview';
    var navEl = document.getElementById('nav-' + active);
    showDashSection(active, navEl);
})();

function dashToggle(wrap) {
    var track = wrap.querySelector('.toggle-track');
    if (track) track.classList.toggle('on');
}
    </script>
</asp:Content>
