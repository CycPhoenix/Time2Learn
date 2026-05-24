<%@ Page Title="Admin Panel - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="Time2Learn.Admin" %>

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
        .admin-table-wrap { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); overflow:hidden; }
        .admin-table-header { display:flex; justify-content:space-between; align-items:center; padding:16px 20px; border-bottom:1px solid var(--border); }
        .admin-table-header h3 { font-size:1rem; margin:0; }
        .data-table { width:100%; border-collapse:collapse; }
        .data-table th { background:var(--bg-light); padding:11px 16px; text-align:left; font-size:0.8rem; color:var(--text-light); font-weight:600; text-transform:uppercase; letter-spacing:0.04em; }
        .data-table td { padding:13px 16px; border-bottom:1px solid var(--border); font-size:0.88rem; vertical-align:middle; }
        .data-table tr:last-child td { border-bottom:none; }
        .badge { padding:3px 10px; border-radius:20px; font-size:0.78rem; font-weight:600; }
        .badge--active   { background:#d1fae5; color:#065f46; }
        .badge--inactive { background:#fef3c7; color:#92400e; }
        .badge--banned   { background:#fee2e2; color:#991b1b; }
        .badge--active   { background:#d1fae5; color:#065f46; }
        .badge--draft    { background:#f1f5f9; color:#475569; }
        .badge--archived { background:#fee2e2; color:#991b1b; }
        .badge--pending  { background:#fef3c7; color:#92400e; }
        .btn-icon { background:none; border:none; cursor:pointer; padding:4px 8px; border-radius:4px; font-size:0.82rem; font-weight:600; }
        .btn-icon--danger { color:#ef4444; }
        .btn-icon--danger:hover { background:#fee2e2; }
        .empty-state { padding:60px 24px; text-align:center; color:var(--text-light); }
        .search-bar { display:flex; gap:8px; }
        .search-bar input { flex:1; padding:8px 12px; border:1px solid var(--border); border-radius:var(--radius); font-size:0.88rem; }

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
        [data-theme="dark"] .search-bar input { background:#1c1d1f; border-color:#444; color:#fff; }
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
                <div class="sidebar__section-label">Admin</div>
                <div class="sidebar__nav-item active" id="nav-overview" onclick="showAdminSection('overview', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
                    Overview
                </div>
                <div class="sidebar__nav-item" id="nav-users" onclick="showAdminSection('users', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
                    Manage Users
                </div>
                <div class="sidebar__nav-item" id="nav-courses" onclick="showAdminSection('courses', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M21 5c-1.11-.35-2.33-.5-3.5-.5-1.95 0-4.05.4-5.5 1.5-1.45-1.1-3.55-1.5-5.5-1.5S2.45 4.9 1 6v14.65c0 .25.25.5.5.5.1 0 .15-.05.25-.05C3.1 20.45 5.05 20 6.5 20c1.95 0 4.05.4 5.5 1.5 1.35-.85 3.8-1.5 5.5-1.5 1.65 0 3.35.3 4.75 1.05.1.05.15.05.25.05.25 0 .5-.25.5-.5V6c-.6-.45-1.25-.75-2-1zm0 13.5c-1.1-.35-2.3-.5-3.5-.5-1.7 0-4.15.65-5.5 1.5V8c1.35-.85 3.8-1.5 5.5-1.5 1.2 0 2.4.15 3.5.5v11.5z"/></svg>
                    Manage Courses
                </div>
                <div class="sidebar__nav-item" id="nav-instructors" onclick="showAdminSection('instructors', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>
                    Instructor Approvals
                </div>
                <div class="sidebar__section-label">Account</div>
                <div class="sidebar__nav-item" id="nav-profile" onclick="showAdminSection('profile', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                    My Profile
                </div>
                <div class="sidebar__nav-item" id="nav-settings" onclick="showAdminSection('settings', this)">
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
                    <h1>Admin Dashboard</h1>
                    <p>Platform overview and management.</p>
                </div>
                <div class="stats-grid">
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">Total Users</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litUserCount" runat="server">0</asp:Literal></div>
                    </div>
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">Total Courses</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litCourseCount" runat="server">0</asp:Literal></div>
                    </div>
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">Total Enrollments</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litEnrollCount" runat="server">0</asp:Literal></div>
                    </div>
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">Open Tickets</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litTicketCount" runat="server">0</asp:Literal></div>
                    </div>
                </div>

                <!-- Recent Users -->
                <div class="admin-table-wrap">
                    <div class="admin-table-header">
                        <h3>Recent Users</h3>
                        <div onclick="showAdminSection('users', document.querySelectorAll('.sidebar__nav-item')[2])" class="btn btn--outline btn--sm" style="cursor:pointer;">View All</div>
                    </div>
                    <table class="data-table">
                        <thead><tr><th>Name</th><th>Email</th><th>Role</th><th>Status</th><th>Joined</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptRecentUsers" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("FirstName") %> <%# Eval("LastName") %></td>
                                        <td><%# Eval("Email") %></td>
                                        <td><%# Eval("RoleName") %></td>
                                        <td><span class="badge badge--<%# Eval("AccountStatus").ToString().ToLower() %>"><%# Eval("AccountStatus") %></span></td>
                                        <td><%# Eval("RegistrationDate", "{0:dd MMM yyyy}") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Manage Users -->
            <div class="inst-section" id="section-users">
                <div class="dash-page-header"><h1>Manage Users</h1><p>View and manage all platform users.</p></div>
                <div class="admin-table-wrap">
                    <div class="admin-table-header">
                        <h3>All Users</h3>
                        <span style="font-size:0.82rem;color:var(--text-light);"><asp:Literal ID="litAllUserCount" runat="server" /> users</span>
                    </div>
                    <table class="data-table">
                        <thead><tr><th>#</th><th>Name</th><th>Email</th><th>Role</th><th>Status</th><th>Joined</th><th>Action</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptUsers" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("UserID") %></td>
                                        <td><%# Eval("FirstName") %> <%# Eval("LastName") %></td>
                                        <td><%# Eval("Email") %></td>
                                        <td><%# Eval("RoleName") %></td>
                                        <td><span class="badge badge--<%# Eval("AccountStatus").ToString().ToLower() %>"><%# Eval("AccountStatus") %></span></td>
                                        <td><%# Eval("RegistrationDate", "{0:dd MMM yyyy}") %></td>
                                        <td>
                                            <asp:LinkButton runat="server" CommandName="ToggleStatus" CommandArgument='<%# Eval("UserID") %>' CssClass="btn-icon" OnCommand="UserAction_Command">
                                                <%# Eval("AccountStatus").ToString() == "Active" ? "Deactivate" : "Activate" %>
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Manage Courses -->
            <div class="inst-section" id="section-courses">
                <div class="dash-page-header"><h1>Manage Courses</h1><p>View and moderate all courses.</p></div>
                <div class="admin-table-wrap">
                    <div class="admin-table-header">
                        <h3>All Courses</h3>
                        <span style="font-size:0.82rem;color:var(--text-light);"><asp:Literal ID="litAllCourseCount" runat="server" /> courses</span>
                    </div>
                    <table class="data-table">
                        <thead><tr><th>#</th><th>Title</th><th>Instructor</th><th>Category</th><th>Status</th><th>Price</th><th>Action</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptCourses" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("CourseID") %></td>
                                        <td><%# Eval("CourseTitle") %></td>
                                        <td><%# Eval("InstructorName") %></td>
                                        <td><%# Eval("CategoryName") %></td>
                                        <td><span class="badge badge--<%# Eval("CourseStatus").ToString().ToLower() %>"><%# Eval("CourseStatus") %></span></td>
                                        <td>RM <%# Eval("Price", "{0:0.00}") %></td>
                                        <td>
                                            <asp:LinkButton runat="server" CommandName="ToggleCourse" CommandArgument='<%# Eval("CourseID") + "|" + Eval("CourseStatus") %>' CssClass="btn-icon btn-icon--danger" OnCommand="CourseAction_Command">
                                                <%# Eval("CourseStatus").ToString() == "Active" ? "Deactivate" : "Activate" %>
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Instructor Approvals -->
            <div class="inst-section" id="section-instructors">
                <div class="dash-page-header"><h1>Instructor Approvals</h1><p>Review pending instructor applications.</p></div>
                <div class="admin-table-wrap">
                    <asp:Repeater ID="rptInstructorApps" runat="server">
                        <HeaderTemplate>
                            <table class="data-table">
                                <thead><tr><th>#</th><th>Name</th><th>Email</th><th>Teaching Plan</th><th>Applied</th><th>Action</th></tr></thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><%# Eval("UserID") %></td>
                                <td><%# Eval("FirstName") %> <%# Eval("LastName") %></td>
                                <td><%# Eval("Email") %></td>
                                <td><%# Eval("TeachingPlan") %></td>
                                <td><%# Eval("RegistrationDate", "{0:dd MMM yyyy}") %></td>
                                <td>
                                    <asp:LinkButton runat="server" CommandName="ApproveInstructor" CommandArgument='<%# Eval("UserID") %>' CssClass="btn-icon" style="color:#059669;" OnCommand="InstructorAction_Command">Approve</asp:LinkButton>
                                    &nbsp;
                                    <asp:LinkButton runat="server" CommandName="RejectInstructor" CommandArgument='<%# Eval("UserID") %>' CssClass="btn-icon btn-icon--danger" OnCommand="InstructorAction_Command">Reject</asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoApps" runat="server" Visible="false">
                        <div class="empty-state">No pending instructor applications.</div>
                    </asp:Panel>
                </div>
            </div>

            <!-- My Profile -->
            <div class="inst-section" id="section-profile">
                <div class="dash-page-header"><h1>My Profile</h1><p>Update your personal information.</p></div>
                <div style="background:white;border-radius:var(--radius-lg);border:1px solid var(--border);padding:32px;max-width:560px;">
                    <div style="display:flex;align-items:center;gap:16px;margin-bottom:28px;">
                        <div class="sidebar__avatar" style="width:72px;height:72px;font-size:1.4rem;flex-shrink:0;"><asp:Literal ID="litProfileAvatar" runat="server" /></div>
                        <div>
                            <div style="font-weight:700;font-size:1.1rem;"><asp:Literal ID="litProfileName" runat="server" /></div>
                            <div style="font-size:0.85rem;color:var(--text-light);"><asp:Literal ID="litProfileEmailDisp" runat="server" /></div>
                        </div>
                    </div>
                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:16px;">
                        <div>
                            <label style="font-size:0.85rem;font-weight:600;display:block;margin-bottom:4px;">First Name</label>
                            <asp:TextBox ID="txtProfileFirstName" runat="server" style="width:100%;padding:8px 10px;border:1px solid var(--border);border-radius:6px;font-size:0.9rem;box-sizing:border-box;" />
                        </div>
                        <div>
                            <label style="font-size:0.85rem;font-weight:600;display:block;margin-bottom:4px;">Last Name</label>
                            <asp:TextBox ID="txtProfileLastName" runat="server" style="width:100%;padding:8px 10px;border:1px solid var(--border);border-radius:6px;font-size:0.9rem;box-sizing:border-box;" />
                        </div>
                    </div>
                    <div style="margin-bottom:16px;">
                        <label style="font-size:0.85rem;font-weight:600;display:block;margin-bottom:4px;">Avatar Initials</label>
                        <asp:TextBox ID="txtProfileAvatar" runat="server" MaxLength="3" style="width:100%;padding:8px 10px;border:1px solid var(--border);border-radius:6px;font-size:0.9rem;box-sizing:border-box;" placeholder="e.g. AD" />
                        <div style="font-size:0.78rem;color:var(--text-light);margin-top:4px;">2–3 characters or emoji shown in your avatar circle.</div>
                    </div>
                    <div style="margin-bottom:24px;">
                        <label style="font-size:0.85rem;font-weight:600;display:block;margin-bottom:4px;">Email</label>
                        <div style="padding:9px 12px;border:1px solid var(--border);border-radius:6px;background:var(--bg-light);font-size:0.9rem;color:var(--text-light);"><asp:Literal ID="litProfileEmailRO" runat="server" /></div>
                        <div style="font-size:0.78rem;color:var(--text-light);margin-top:4px;">Email cannot be changed.</div>
                    </div>
                    <asp:Button ID="btnSaveProfile" runat="server" Text="Save Changes" CssClass="btn btn--primary btn--sm" OnClick="btnSaveProfile_Click" CausesValidation="false" />
                    <asp:Label ID="lblProfileMsg" runat="server" style="margin-left:12px;font-size:0.85rem;" />
                </div>
            </div>

            <!-- Settings -->
            <div class="inst-section" id="section-settings">
                <div class="dash-page-header"><h1>Settings</h1><p>Manage your account security.</p></div>
                <div style="background:white;border-radius:var(--radius-lg);border:1px solid var(--border);padding:32px;max-width:480px;">
                    <h3 style="margin:0 0 20px;font-size:1rem;">Change Password</h3>
                    <div style="margin-bottom:14px;">
                        <label style="font-size:0.85rem;font-weight:600;display:block;margin-bottom:4px;">Current Password</label>
                        <asp:TextBox ID="txtCurrentPwd" runat="server" TextMode="Password" style="width:100%;padding:8px 10px;border:1px solid var(--border);border-radius:6px;font-size:0.9rem;box-sizing:border-box;" />
                    </div>
                    <div style="margin-bottom:14px;">
                        <label style="font-size:0.85rem;font-weight:600;display:block;margin-bottom:4px;">New Password</label>
                        <asp:TextBox ID="txtNewPwd" runat="server" TextMode="Password" style="width:100%;padding:8px 10px;border:1px solid var(--border);border-radius:6px;font-size:0.9rem;box-sizing:border-box;" />
                    </div>
                    <div style="margin-bottom:20px;">
                        <label style="font-size:0.85rem;font-weight:600;display:block;margin-bottom:4px;">Confirm New Password</label>
                        <asp:TextBox ID="txtConfirmPwd" runat="server" TextMode="Password" style="width:100%;padding:8px 10px;border:1px solid var(--border);border-radius:6px;font-size:0.9rem;box-sizing:border-box;" />
                    </div>
                    <asp:Button ID="btnChangePassword" runat="server" Text="Update Password" CssClass="btn btn--primary btn--sm" OnClick="btnChangePassword_Click" CausesValidation="false" />
                    <asp:Label ID="lblPwdMsg" runat="server" style="display:block;margin-top:10px;font-size:0.85rem;" />
                </div>
            </div>

        </main>
    </div>
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
// @ts-nocheck
function showAdminSection(name, el) {
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
    showAdminSection(active, navEl);
})();
    </script>
</asp:Content>
