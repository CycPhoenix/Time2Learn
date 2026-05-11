<%@ Page Title="Customer Service - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CustomerService.aspx.cs" Inherits="Time2Learn.CustomerService" %>

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
        .dash-stat-card__value { font-size:2rem; font-weight:800; color:var(--text-dark); }
        .admin-table-wrap { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); overflow:hidden; margin-bottom:24px; }
        .admin-table-header { display:flex; justify-content:space-between; align-items:center; padding:16px 20px; border-bottom:1px solid var(--border); }
        .admin-table-header h3 { font-size:1rem; margin:0; }
        .data-table { width:100%; border-collapse:collapse; }
        .data-table th { background:var(--bg-light); padding:11px 16px; text-align:left; font-size:0.8rem; color:var(--text-light); font-weight:600; text-transform:uppercase; letter-spacing:0.04em; }
        .data-table td { padding:13px 16px; border-bottom:1px solid var(--border); font-size:0.88rem; vertical-align:middle; }
        .data-table tr:last-child td { border-bottom:none; }
        .badge { padding:3px 10px; border-radius:20px; font-size:0.78rem; font-weight:600; }
        .badge--open       { background:#fef3c7; color:#92400e; }
        .badge--resolved   { background:#d1fae5; color:#065f46; }
        .badge--closed     { background:#f1f5f9; color:#475569; }
        .badge--in-progress { background:#e0e7ff; color:#3730a3; }
        .empty-state { padding:60px 24px; text-align:center; color:var(--text-light); }
        .status-select { padding:5px 10px; border:1px solid var(--border); border-radius:var(--radius); font-size:0.85rem; }
        .ticket-detail { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:24px; margin-bottom:24px; }
        .ticket-detail h4 { margin-bottom:8px; }
        .ticket-detail p { color:var(--text-light); font-size:0.9rem; margin:0; }

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
        [data-theme="dark"] .ticket-detail { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .ticket-detail h4 { color:#fff; }
        [data-theme="dark"] .status-select { background:#1c1d1f; border-color:#444; color:#fff; }
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
                <div class="sidebar__section-label">Customer Service</div>
                <div class="sidebar__nav-item active" onclick="showCSSection('overview', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
                    Overview
                </div>
                <div class="sidebar__nav-item" onclick="showCSSection('tickets', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/></svg>
                    All Tickets
                </div>
                <div class="sidebar__nav-item" onclick="showCSSection('open', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>
                    Open Tickets
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
                    <h1>Customer Service</h1>
                    <p>Manage and resolve customer support tickets.</p>
                </div>
                <div class="stats-grid">
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">Total Tickets</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litTotalCount" runat="server">0</asp:Literal></div>
                    </div>
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">Open</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litOpenCount" runat="server">0</asp:Literal></div>
                    </div>
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">In Progress</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litProgressCount" runat="server">0</asp:Literal></div>
                    </div>
                    <div class="dash-stat-card">
                        <div class="dash-stat-card__label">Resolved</div>
                        <div class="dash-stat-card__value"><asp:Literal ID="litResolvedCount" runat="server">0</asp:Literal></div>
                    </div>
                </div>
                <div class="admin-table-wrap">
                    <div class="admin-table-header"><h3>Recent Tickets</h3></div>
                    <table class="data-table">
                        <thead><tr><th>#</th><th>Subject</th><th>User</th><th>Status</th><th>Date</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptRecentTickets" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("TicketID") %></td>
                                        <td><%# Eval("Subject") %></td>
                                        <td><%# Eval("UserName") %></td>
                                        <td><span class="badge badge--<%# Eval("TicketStatus").ToString().ToLower().Replace(" ","-") %>"><%# Eval("TicketStatus") %></span></td>
                                        <td><%# Eval("CreatedDate", "{0:dd MMM yyyy}") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- All Tickets -->
            <div class="inst-section" id="section-tickets">
                <div class="dash-page-header"><h1>All Tickets</h1><p>Full ticket history.</p></div>
                <div class="admin-table-wrap">
                    <div class="admin-table-header">
                        <h3>Tickets</h3>
                        <span style="font-size:0.82rem;color:var(--text-light);"><asp:Literal ID="litAllCount" runat="server" /> tickets</span>
                    </div>
                    <table class="data-table">
                        <thead><tr><th>#</th><th>Subject</th><th>User</th><th>Status</th><th>Date</th><th>Update Status</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptAllTickets" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("TicketID") %></td>
                                        <td><%# Eval("Subject") %></td>
                                        <td><%# Eval("UserName") %></td>
                                        <td><span class="badge badge--<%# Eval("TicketStatus").ToString().ToLower().Replace(" ","-") %>"><%# Eval("TicketStatus") %></span></td>
                                        <td><%# Eval("CreatedDate", "{0:dd MMM yyyy}") %></td>
                                        <td>
                                            <asp:DropDownList runat="server" ID="ddlStatus" CssClass="status-select">
                                                <asp:ListItem Text="Open" Value="Open" />
                                                <asp:ListItem Text="In Progress" Value="In Progress" />
                                                <asp:ListItem Text="Resolved" Value="Resolved" />
                                                <asp:ListItem Text="Closed" Value="Closed" />
                                            </asp:DropDownList>
                                            <asp:LinkButton runat="server" CommandName="UpdateStatus" CommandArgument='<%# Eval("TicketID") %>' CssClass="btn btn--sm btn--outline" style="margin-left:4px;" OnCommand="TicketAction_Command">Update</asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                    <asp:Panel ID="pnlNoTickets" runat="server" Visible="false">
                        <div class="empty-state">No tickets found.</div>
                    </asp:Panel>
                </div>
            </div>

            <!-- Open Tickets -->
            <div class="inst-section" id="section-open">
                <div class="dash-page-header"><h1>Open Tickets</h1><p>Tickets requiring attention.</p></div>
                <div class="admin-table-wrap">
                    <table class="data-table">
                        <thead><tr><th>#</th><th>Subject</th><th>Message</th><th>User</th><th>Date</th><th>Action</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptOpenTickets" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("TicketID") %></td>
                                        <td><%# Eval("Subject") %></td>
                                        <td style="max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><%# Eval("Message") %></td>
                                        <td><%# Eval("UserName") %></td>
                                        <td><%# Eval("CreatedDate", "{0:dd MMM yyyy}") %></td>
                                        <td>
                                            <asp:LinkButton runat="server" CommandName="Resolve" CommandArgument='<%# Eval("TicketID") %>' CssClass="btn btn--sm btn--primary" OnCommand="TicketAction_Command">Resolve</asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                    <asp:Panel ID="pnlNoOpen" runat="server" Visible="false">
                        <div class="empty-state">No open tickets. All clear!</div>
                    </asp:Panel>
                </div>
            </div>

        </main>
    </div>
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
// @ts-nocheck
function showCSSection(name, el) {
    document.querySelectorAll('.inst-section').forEach(function (s) { s.classList.remove('active'); });
    var sec = document.getElementById('section-' + name);
    if (sec) sec.classList.add('active');
    document.querySelectorAll('.sidebar__nav-item').forEach(function (i) { i.classList.remove('active'); });
    if (el) el.classList.add('active');
}
</script>
</asp:Content>
