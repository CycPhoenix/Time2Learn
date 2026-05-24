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
        .tab-btn { background:none; border:none; padding:10px 20px; font-size:0.9rem; cursor:pointer; color:var(--text-light); border-bottom:2px solid transparent; margin-bottom:-2px; }
        .tab-btn.active { color:var(--primary); border-bottom-color:var(--primary); font-weight:600; }
        .tab-panel { display:none; }
        .tab-panel.active { display:block; }
        .form-field-label { font-size:0.85rem; font-weight:600; display:block; margin-bottom:4px; }
        .form-text-input { width:100%; padding:8px 10px; border:1px solid var(--border); border-radius:var(--radius-sm); font-size:0.9rem; box-sizing:border-box; }
        [data-theme="dark"] .tab-btn { color:#888; }
        [data-theme="dark"] .tab-btn.active { color:var(--primary); }
        [data-theme="dark"] .form-text-input { background:#1c1d1f; border-color:#444; color:#fff; }

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
                <div class="sidebar__nav-item active" id="nav-overview" onclick="showCSSection('overview', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
                    Overview
                </div>
                <div class="sidebar__nav-item" id="nav-tickets" onclick="showCSSection('tickets', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/></svg>
                    All Tickets
                </div>
                <div class="sidebar__nav-item" id="nav-open" onclick="showCSSection('open', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>
                    Open Tickets
                </div>
                <div class="sidebar__nav-item" id="nav-faq" onclick="showCSSection('faq', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M11 18h2v-2h-2v2zm1-16C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm0-14c-2.21 0-4 1.79-4 4h2c0-1.1.9-2 2-2s2 .9 2 2c0 2-3 1.75-3 5h2c0-2.25 3-2.5 3-5 0-2.21-1.79-4-4-4z"/></svg>
                    FAQ Management
                </div>
                <div class="sidebar__nav-item" id="nav-chatbot" onclick="showCSSection('chatbot', this)">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H5.17L4 17.17V4h16v12z"/></svg>
                    Chatbot Management
                </div>
                <div class="sidebar__section-label">Account</div>
                <a href="Logout.aspx" class="sidebar__nav-item" style="color:#ef4444;">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>
                    Log Out
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <asp:HiddenField ID="hdnActiveSection" runat="server" Value="overview" />
        <asp:HiddenField ID="hdnEditFaqID" runat="server" Value="0" />
        <asp:HiddenField ID="hdnEditKBID" runat="server" Value="0" />
        <asp:HiddenField ID="hdnChatbotTab" runat="server" Value="logs" />
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
                            <asp:Repeater ID="rptAllTickets" runat="server" OnItemDataBound="rptAllTickets_ItemDataBound">
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

            <!-- FAQ Management -->
            <div class="inst-section" id="section-faq">
                <div class="dash-page-header"><h1>FAQ Management</h1><p>Create, edit and publish frequently asked questions.</p></div>

                <asp:Panel ID="pnlFaqForm" runat="server" Visible="false" CssClass="admin-table-wrap" style="padding:20px;margin-bottom:20px;">
                    <h3 style="margin-bottom:16px;"><asp:Literal ID="litFaqFormTitle" runat="server">Add FAQ</asp:Literal></h3>
                    <div style="margin-bottom:12px;">
                        <label class="form-field-label">Question *</label>
                        <asp:TextBox ID="txtFaqQuestion" runat="server" CssClass="form-text-input" />
                    </div>
                    <div style="margin-bottom:12px;display:flex;gap:16px;">
                        <div style="flex:1;">
                            <label class="form-field-label">Category *</label>
                            <asp:DropDownList ID="ddlFaqCategory" runat="server" CssClass="status-select" style="width:100%;">
                                <asp:ListItem Text="Account" Value="Account" />
                                <asp:ListItem Text="Billing" Value="Billing" />
                                <asp:ListItem Text="Courses" Value="Courses" />
                                <asp:ListItem Text="Instructor" Value="Instructor" />
                                <asp:ListItem Text="Certificates" Value="Certificates" />
                                <asp:ListItem Text="Technical" Value="Technical" />
                                <asp:ListItem Text="General" Value="General" />
                            </asp:DropDownList>
                        </div>
                        <div>
                            <label class="form-field-label">Status</label>
                            <asp:DropDownList ID="ddlFaqPublished" runat="server" CssClass="status-select">
                                <asp:ListItem Text="Published" Value="1" />
                                <asp:ListItem Text="Draft" Value="0" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div style="margin-bottom:16px;">
                        <label class="form-field-label">Answer *</label>
                        <asp:TextBox ID="txtFaqAnswer" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-text-input" style="resize:vertical;" />
                    </div>
                    <asp:Button ID="btnSaveFaq" runat="server" Text="Save FAQ" CssClass="btn btn--primary btn--sm" OnClick="btnSaveFaq_Click" style="margin-right:8px;" />
                    <asp:Button ID="btnCancelFaq" runat="server" Text="Cancel" CssClass="btn btn--outline btn--sm" OnClick="btnCancelFaq_Click" CausesValidation="false" />
                </asp:Panel>

                <div class="admin-table-wrap">
                    <div class="admin-table-header">
                        <h3>All FAQs (<asp:Literal ID="litFaqCount" runat="server">0</asp:Literal>)</h3>
                        <asp:Button ID="btnShowAddFaq" runat="server" Text="+ Add FAQ" CssClass="btn btn--primary btn--sm" OnClick="btnShowAddFaq_Click" />
                    </div>
                    <table class="data-table">
                        <thead><tr><th>#</th><th>Question</th><th>Category</th><th>Status</th><th>Date</th><th>Actions</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptFAQs" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("FaqID") %></td>
                                        <td style="max-width:300px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><%# Eval("Question") %></td>
                                        <td><%# Eval("Category") %></td>
                                        <td><span class="badge badge--<%# Convert.ToBoolean(Eval("IsPublished")) ? "resolved" : "closed" %>"><%# Convert.ToBoolean(Eval("IsPublished")) ? "Published" : "Draft" %></span></td>
                                        <td><%# Eval("CreatedDate", "{0:dd MMM yyyy}") %></td>
                                        <td style="display:flex;gap:6px;">
                                            <asp:LinkButton runat="server" CommandName="EditFaq" CommandArgument='<%# Eval("FaqID") %>' CssClass="btn btn--sm btn--outline" OnCommand="FaqAction_Command">Edit</asp:LinkButton>
                                            <asp:LinkButton runat="server" CommandName="DeleteFaq" CommandArgument='<%# Eval("FaqID") %>' CssClass="btn btn--sm" style="background:#ef4444;color:white;border:2px solid #ef4444;" OnClientClick="return confirm('Delete this FAQ?');" OnCommand="FaqAction_Command">Delete</asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                    <asp:Panel ID="pnlNoFaqs" runat="server" Visible="false">
                        <div class="empty-state">No FAQs found.</div>
                    </asp:Panel>
                </div>
            </div>

            <!-- Chatbot Management -->
            <div class="inst-section" id="section-chatbot">
                <div class="dash-page-header"><h1>Chatbot Management</h1><p>Review chat logs and manage the knowledge base.</p></div>

                <div class="tabs" style="margin-bottom:20px;">
                    <button type="button" class="tab-btn active" data-chatbot-tab="logs" onclick="switchChatbotTab('logs',this)">Chat Logs</button>
                    <button type="button" class="tab-btn" data-chatbot-tab="kb" onclick="switchChatbotTab('kb',this)">Knowledge Base</button>
                </div>

                <!-- Chat Logs -->
                <div class="tab-panel active" id="chatbot-tab-logs">
                    <div class="admin-table-wrap">
                        <div class="admin-table-header"><h3>Chat Logs</h3></div>
                        <table class="data-table">
                            <thead><tr><th>Log ID</th><th>User</th><th>Query</th><th>Status</th><th>Date</th><th>Action</th></tr></thead>
                            <tbody>
                                <asp:Repeater ID="rptChatLogs" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("LogID") %></td>
                                            <td><%# Eval("UserName") %></td>
                                            <td style="max-width:260px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><%# Eval("UserQuery") %></td>
                                            <td><span class="badge badge--<%# Convert.ToBoolean(Eval("IsEscalated")) ? "open" : "closed" %>"><%# Convert.ToBoolean(Eval("IsEscalated")) ? "Flagged" : "Normal" %></span></td>
                                            <td><%# Eval("Timestamp", "{0:dd MMM yyyy}") %></td>
                                            <td>
                                                <asp:LinkButton runat="server" CommandName="ToggleEscalated" CommandArgument='<%# Eval("LogID") + "," + Eval("IsEscalated") %>' CssClass="btn btn--sm btn--outline" OnCommand="ChatLogAction_Command"><%# Convert.ToBoolean(Eval("IsEscalated")) ? "Remove Flag" : "Flag" %></asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                        <asp:Panel ID="pnlNoChatLogs" runat="server" Visible="false">
                            <div class="empty-state">No chat logs found.</div>
                        </asp:Panel>
                    </div>
                </div>

                <!-- Knowledge Base -->
                <div class="tab-panel" id="chatbot-tab-kb">
                    <asp:Panel ID="pnlKBForm" runat="server" Visible="false" CssClass="admin-table-wrap" style="padding:20px;margin-bottom:20px;">
                        <h3 style="margin-bottom:16px;"><asp:Literal ID="litKBFormTitle" runat="server">Add KB Entry</asp:Literal></h3>
                        <div style="margin-bottom:12px;">
                            <label class="form-field-label">Topic *</label>
                            <asp:TextBox ID="txtKBTopic" runat="server" CssClass="form-text-input" placeholder="e.g. Password Reset" />
                        </div>
                        <div style="margin-bottom:12px;">
                            <label class="form-field-label">Response Summary *</label>
                            <asp:TextBox ID="txtKBResponse" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-text-input" style="resize:vertical;" />
                        </div>
                        <div style="margin-bottom:16px;">
                            <label class="form-field-label">Status</label>
                            <asp:DropDownList ID="ddlKBStatus" runat="server" CssClass="status-select">
                                <asp:ListItem Text="Active" Value="Active" />
                                <asp:ListItem Text="Draft" Value="Draft" />
                            </asp:DropDownList>
                        </div>
                        <asp:Button ID="btnSaveKB" runat="server" Text="Save Entry" CssClass="btn btn--primary btn--sm" OnClick="btnSaveKB_Click" style="margin-right:8px;" />
                        <asp:Button ID="btnCancelKB" runat="server" Text="Cancel" CssClass="btn btn--outline btn--sm" OnClick="btnCancelKB_Click" CausesValidation="false" />
                    </asp:Panel>

                    <div class="admin-table-wrap">
                        <div class="admin-table-header">
                            <h3>Knowledge Base (<asp:Literal ID="litKBCount" runat="server">0</asp:Literal>)</h3>
                            <asp:Button ID="btnShowAddKB" runat="server" Text="+ Add Entry" CssClass="btn btn--primary btn--sm" OnClick="btnShowAddKB_Click" />
                        </div>
                        <table class="data-table">
                            <thead><tr><th>#</th><th>Topic</th><th>Response</th><th>Status</th><th>Created</th><th>Updated</th><th>Actions</th></tr></thead>
                            <tbody>
                                <asp:Repeater ID="rptKB" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("KnowledgeBaseID") %></td>
                                            <td><%# Eval("Topic") %></td>
                                            <td style="max-width:220px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><%# Eval("ResponseSummary") %></td>
                                            <td><span class="badge badge--<%# Eval("Status").ToString() == "Active" ? "resolved" : "closed" %>"><%# Eval("Status") %></span></td>
                                            <td><%# Eval("CreatedAt", "{0:dd MMM yyyy}") %></td>
                                            <td><%# Eval("UpdatedAt") != DBNull.Value ? string.Format("{0:dd MMM yyyy}", Eval("UpdatedAt")) : "-" %></td>
                                            <td style="display:flex;gap:6px;">
                                                <asp:LinkButton runat="server" CommandName="EditKB" CommandArgument='<%# Eval("KnowledgeBaseID") %>' CssClass="btn btn--sm btn--outline" OnCommand="KBAction_Command">Edit</asp:LinkButton>
                                                <asp:LinkButton runat="server" CommandName="DeleteKB" CommandArgument='<%# Eval("KnowledgeBaseID") %>' CssClass="btn btn--sm" style="background:#ef4444;color:white;border:2px solid #ef4444;" OnClientClick="return confirm('Delete this entry?');" OnCommand="KBAction_Command">Delete</asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                        <asp:Panel ID="pnlNoKB" runat="server" Visible="false">
                            <div class="empty-state">No knowledge base entries found.</div>
                        </asp:Panel>
                    </div>
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
    var hdn = document.getElementById('<%= hdnActiveSection.ClientID %>');
    if (hdn) hdn.value = name;
}

function switchChatbotTab(id, btn) {
    document.querySelectorAll('#section-chatbot .tab-btn').forEach(function (b) { b.classList.remove('active'); });
    document.querySelectorAll('#section-chatbot .tab-panel').forEach(function (p) { p.classList.remove('active'); });
    if (btn) btn.classList.add('active');
    var panel = document.getElementById('chatbot-tab-' + id);
    if (panel) panel.classList.add('active');
    var hdn = document.getElementById('<%= hdnChatbotTab.ClientID %>');
    if (hdn) hdn.value = id;
}

(function () {
    var hdn = document.getElementById('<%= hdnActiveSection.ClientID %>');
    if (!hdn) return;
    var active = hdn.value || 'overview';
    var navEl = document.getElementById('nav-' + active);
    showCSSection(active, navEl);
    if (active === 'chatbot') { 
        var tabHdn = document.getElementById('<%= hdnChatbotTab.ClientID %>');
        var tab = tabHdn ? (tabHdn.value || 'logs') : 'logs';
        var tabBtn = document.querySelector('[data-chatbot-tab="' + tab + '"]');
        switchChatbotTab(tab, tabBtn);
    }
})();
    </script>
</asp:Content>
