<%@ Page Title="Moderator Panel - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Moderator.aspx.cs" Inherits="Time2Learn.Moderator" %>

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
        .admin-table-wrap { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); overflow:hidden; margin-bottom:24px; }
        .admin-table-header { display:flex; justify-content:space-between; align-items:center; padding:16px 20px; border-bottom:1px solid var(--border); }
        .admin-table-header h3 { font-size:1rem; margin:0; }
        .data-table { width:100%; border-collapse:collapse; }
        .data-table th { background:var(--bg-light); padding:11px 16px; text-align:left; font-size:0.8rem; color:var(--text-light); font-weight:600; text-transform:uppercase; letter-spacing:0.04em; }
        .data-table td { padding:13px 16px; border-bottom:1px solid var(--border); font-size:0.88rem; vertical-align:middle; }
        .data-table tr:last-child td { border-bottom:none; }
        .btn-icon { background:none; border:none; cursor:pointer; padding:4px 8px; border-radius:4px; font-size:0.82rem; font-weight:600; }
        .btn-icon--danger { color:#ef4444; }
        .btn-icon--danger:hover { background:#fee2e2; }
        .empty-state { padding:60px 24px; text-align:center; color:var(--text-light); }
        .announcement-form { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:24px; margin-bottom:24px; }
        .announcement-form h3 { margin-bottom:16px; font-size:1rem; }
        .form-group { margin-bottom:16px; }
        .form-group label { display:block; font-size:0.85rem; font-weight:600; margin-bottom:6px; color:var(--text-dark); }
        .form-group input, .form-group select, .form-group textarea { width:100%; padding:10px 14px; border:1.5px solid var(--border); border-radius:var(--radius); font-size:0.9rem; outline:none; transition:border-color 0.2s; font-family:inherit; background:white; box-sizing:border-box; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { border-color:var(--primary); }
        .form-group textarea { min-height:100px; resize:vertical; }
        .form-row-2 { display:grid; grid-template-columns:1fr 1fr; gap:14px; }
        /* ── Toggle switches ── */
        .settings-row { display:flex; justify-content:space-between; align-items:center; padding:16px 0; border-bottom:1px solid var(--border); }
        .settings-row:last-child { border-bottom:none; }
        .toggle-wrap { position:relative; width:44px; height:24px; cursor:pointer; flex-shrink:0; }
        .toggle-track { position:absolute; inset:0; background:#ccc; border-radius:12px; transition:0.3s; }
        .toggle-track.on { background:var(--primary); }
        .toggle-thumb { position:absolute; top:2px; left:2px; width:20px; height:20px; border-radius:50%; background:white; transition:0.3s; }
        .toggle-track.on + .toggle-thumb { left:22px; }

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
        [data-theme="dark"] .announcement-form { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .announcement-form h3 { color:#fff; }
        [data-theme="dark"] .form-group label { color:#ccc; }
        [data-theme="dark"] .form-group input,
        [data-theme="dark"] .form-group textarea { background:#1c1d1f; border-color:#444; color:#fff; }
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
                <div class="sidebar__section-label">Moderator</div>
                <div class="sidebar__nav-item active" id="nav-overview" onclick="showModSection('overview', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
                    Overview
                </div>
                <div class="sidebar__nav-item" id="nav-threads" onclick="showModSection('threads', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/></svg>
                    Discussion Threads
                </div>
                <div class="sidebar__nav-item" id="nav-announcements" onclick="showModSection('announcements', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M20 2H4c-1.1 0-1.99.9-1.99 2L2 22l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-7 9h-2V5h2v6zm0 4h-2v-2h2v2z"/></svg>
                    Announcements
                </div>
                <div class="sidebar__section-label">Account</div>
                <div class="sidebar__nav-item" id="nav-profile" onclick="showModSection('profile', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                    My Profile
                </div>
                <div class="sidebar__nav-item" id="nav-settings" onclick="showModSection('settings', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"/></svg>
                    Settings
                </div>
                <a href="#" onclick="openLogoutModal(); return false;" class="sidebar__nav-item" style="color:#ef4444;">
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
                    <h1>Moderator Panel</h1>
                    <p>Manage community discussions and platform announcements.</p>
                </div>
                <div class="stats-grid">
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">Total Threads</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litThreadCount" runat="server">0</asp:Literal></div>
                    </div>
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">Total Posts</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litPostCount" runat="server">0</asp:Literal></div>
                    </div>
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">Announcements</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litAnnCount" runat="server">0</asp:Literal></div>
                    </div>
                </div>
                <div class="admin-table-wrap">
                    <div class="admin-table-header"><h3>Recent Threads</h3></div>
                    <table class="data-table">
                        <thead><tr><th>Title</th><th>Author</th><th>Category</th><th>Posts</th><th>Created</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptRecentThreads" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("Title") %></td>
                                        <td><%# Eval("AuthorName") %></td>
                                        <td><%# Eval("CategoryName") %></td>
                                        <td><%# Eval("PostCount") %></td>
                                        <td><%# Eval("CreatedAt", "{0:dd MMM yyyy}") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Discussion Threads -->
            <div class="inst-section" id="section-threads">
                <div class="dash-page-header"><h1>Discussion Threads</h1><p>Manage all community discussion threads.</p></div>
                <div class="admin-table-wrap">
                    <div class="admin-table-header">
                        <h3>All Threads</h3>
                        <span style="font-size:0.82rem;color:var(--text-light);"><asp:Literal ID="litAllThreadCount" runat="server" /> threads</span>
                    </div>
                    <table class="data-table">
                        <thead><tr><th>#</th><th>Title</th><th>Author</th><th>Category</th><th>Posts</th><th>Created</th><th>Action</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptThreads" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("ThreadID") %></td>
                                        <td><%# Eval("Title") %></td>
                                        <td><%# Eval("AuthorName") %></td>
                                        <td><%# Eval("CategoryName") %></td>
                                        <td><%# Eval("PostCount") %></td>
                                        <td><%# Eval("CreatedAt", "{0:dd MMM yyyy}") %></td>
                                        <td>
                                            <asp:LinkButton runat="server" CommandName="DeleteThread" CommandArgument='<%# Eval("ThreadID") %>' CssClass="btn-icon btn-icon--danger" OnCommand="ThreadAction_Command"
                                                OnClientClick="return confirm('Delete this thread and all its posts?');">Delete</asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                    <asp:Panel ID="pnlNoThreads" runat="server" Visible="false">
                        <div class="empty-state">No threads found.</div>
                    </asp:Panel>
                </div>
            </div>

            <!-- Announcements -->
            <div class="inst-section" id="section-announcements">
                <div class="dash-page-header"><h1>Announcements</h1><p>Post and manage platform announcements.</p></div>

                <div class="announcement-form">
                    <h3>New Announcement</h3>
                    <div class="form-group">
                        <label>Title</label>
                        <asp:TextBox ID="txtAnnTitle" runat="server" CssClass="form-control" placeholder="Announcement title" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAnnTitle" ErrorMessage="Title required." Display="Dynamic" ForeColor="Red" ValidationGroup="AnnGroup" />
                    </div>
                    <div class="form-group">
                        <label>Content</label>
                        <asp:TextBox ID="txtAnnContent" runat="server" TextMode="MultiLine" CssClass="form-control" placeholder="Announcement content..." />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAnnContent" ErrorMessage="Content required." Display="Dynamic" ForeColor="Red" ValidationGroup="AnnGroup" />
                    </div>
                    <asp:Button ID="btnPostAnn" runat="server" Text="Post Announcement" CssClass="btn btn--primary" OnClick="btnPostAnn_Click" ValidationGroup="AnnGroup" />
                    <asp:Label ID="lblAnnMsg" runat="server" style="margin-left:12px;font-size:0.88rem;" />
                </div>

                <div class="admin-table-wrap">
                    <div class="admin-table-header"><h3>All Announcements</h3></div>
                    <table class="data-table">
                        <thead><tr><th>#</th><th>Title</th><th>Posted By</th><th>Date</th><th>Action</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptAnnouncements" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("AnnouncementID") %></td>
                                        <td><%# Eval("Title") %></td>
                                        <td><%# Eval("AuthorName") %></td>
                                        <td><%# Eval("CreatedAt", "{0:dd MMM yyyy}") %></td>
                                        <td>
                                            <asp:LinkButton runat="server" CommandName="DeleteAnn" CommandArgument='<%# Eval("AnnouncementID") %>' CssClass="btn-icon btn-icon--danger" OnCommand="AnnAction_Command"
                                                OnClientClick="return confirm('Delete this announcement?');">Delete</asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                    <asp:Panel ID="pnlNoAnn" runat="server" Visible="false">
                        <div class="empty-state">No announcements yet.</div>
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
                        <asp:TextBox ID="txtProfileAvatar" runat="server" MaxLength="3" placeholder="e.g. MO" />
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
function showModSection(name, el) {
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
    showModSection(active, navEl);
})();

function dashToggle(wrap) {
    var track = wrap.querySelector('.toggle-track');
    if (track) track.classList.toggle('on');
}
    </script>
</asp:Content>
