<%@ Page Title="Community - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Community.aspx.cs" Inherits="Time2Learn.Community" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .community-layout { max-width:1100px; margin:0 auto; padding:40px 24px; display:grid; grid-template-columns:1fr 300px; gap:32px; }
        .community-main {}
        .community-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:28px; flex-wrap:wrap; gap:12px; }
        .community-header h1 { font-size:1.8rem; }
        .thread-card { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:20px 24px; margin-bottom:16px; display:flex; gap:16px; transition:var(--t-fast); }
        .thread-card:hover { box-shadow:0 4px 16px rgba(0,0,0,0.06); }
        .thread-card__avatar { width:44px; height:44px; border-radius:50%; background:var(--primary); color:white; display:flex; align-items:center; justify-content:center; font-size:0.9rem; font-weight:700; flex-shrink:0; }
        .thread-card__body { flex:1; min-width:0; }
        .thread-card__title { font-weight:700; font-size:0.95rem; margin-bottom:6px; }
        .thread-card__excerpt { font-size:0.85rem; color:var(--text-light); margin-bottom:10px; line-height:1.5; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .thread-card__meta { display:flex; gap:16px; font-size:0.78rem; color:var(--text-light); }
        .thread-card__meta span { display:flex; align-items:center; gap:4px; }
        .sidebar-widget { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:20px; margin-bottom:20px; }
        .sidebar-widget h4 { font-size:0.88rem; font-weight:700; margin-bottom:14px; }
        .cat-tag { display:inline-block; background:var(--bg-light); border-radius:12px; padding:5px 12px; font-size:0.78rem; font-weight:600; color:var(--text-light); margin:3px; text-decoration:none; }
        .cat-tag:hover { background:rgba(164,53,240,0.1); color:var(--primary); }
        .empty-state { text-align:center; padding:60px 0; color:var(--text-light); }

        /* New Thread Form */
        .new-thread-form { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:24px; margin-bottom:28px; }
        .new-thread-form h3 { font-size:1rem; margin-bottom:16px; }
        .form-group { margin-bottom:14px; }
        .form-group label { display:block; font-size:0.82rem; font-weight:600; margin-bottom:6px; }
        .form-group input, .form-group select, .form-group textarea { width:100%; padding:9px 12px; border:1px solid var(--border); border-radius:var(--radius); font-size:0.88rem; font-family:inherit; box-sizing:border-box; }
        .form-group textarea { min-height:80px; resize:vertical; }

        /* Dark mode */
        [data-theme="dark"] .thread-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .thread-card__title { color:#fff; }
        [data-theme="dark"] .thread-card:hover { box-shadow:0 4px 16px rgba(0,0,0,0.3); }
        [data-theme="dark"] .new-thread-form { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .new-thread-form h3 { color:#fff; }
        [data-theme="dark"] .form-group label { color:#ccc; }
        [data-theme="dark"] .form-group input,
        [data-theme="dark"] .form-group select,
        [data-theme="dark"] .form-group textarea { background:#1c1d1f; border-color:#444; color:#fff; }
        [data-theme="dark"] .sidebar-widget { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .sidebar-widget h4 { color:#fff; }
        [data-theme="dark"] .sidebar-widget div { border-color:#333; }
        [data-theme="dark"] .cat-tag { background:#333; color:#ccc; }
        [data-theme="dark"] .cat-tag:hover { background:rgba(164,53,240,0.2); color:var(--primary); }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <div class="container">
            <h1>Community Forum</h1>
            <p>Ask questions, share knowledge, and connect with 50,000+ learners.</p>
        </div>
    </div>

    <div class="container">
    <div class="community-layout">

        <div class="community-main">
            <div class="community-header">
                <h2>Latest Discussions</h2>
                <asp:Panel ID="pnlNewBtn" runat="server">
                    <button onclick="document.getElementById('newThreadForm').style.display=document.getElementById('newThreadForm').style.display=='none'?'block':'none'" class="btn btn--primary btn--sm">+ New Thread</button>
                </asp:Panel>
            </div>

            <!-- New Thread Form (logged-in only) -->
            <asp:Panel ID="pnlNewThread" runat="server" Visible="false">
                <div class="new-thread-form" id="newThreadForm" style="display:none;">
                    <h3>Start a New Discussion</h3>
                    <div class="form-group">
                        <label>Title</label>
                        <asp:TextBox ID="txtThreadTitle" runat="server" placeholder="Discussion title..." />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtThreadTitle" ErrorMessage="Title required." Display="Dynamic" ForeColor="Red" ValidationGroup="ThreadGroup" />
                    </div>
                    <div class="form-group">
                        <label>Category</label>
                        <asp:DropDownList ID="ddlCat" runat="server" />
                    </div>
                    <div class="form-group">
                        <label>Message</label>
                        <asp:TextBox ID="txtThreadBody" runat="server" TextMode="MultiLine" placeholder="Share your thoughts..." />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtThreadBody" ErrorMessage="Message required." Display="Dynamic" ForeColor="Red" ValidationGroup="ThreadGroup" />
                    </div>
                    <asp:Button ID="btnPostThread" runat="server" Text="Post Thread" CssClass="btn btn--primary" OnClick="btnPostThread_Click" ValidationGroup="ThreadGroup" />
                    <asp:Label ID="lblMsg" runat="server" style="margin-left:10px;font-size:0.85rem;" />
                </div>
            </asp:Panel>

            <!-- Thread List -->
            <asp:Repeater ID="rptThreads" runat="server">
                <ItemTemplate>
                    <div class="thread-card">
                        <div class="thread-card__avatar"><%# Eval("Avatar") %></div>
                        <div class="thread-card__body">
                            <div class="thread-card__title"><%# Eval("Title") %></div>
                            <div class="thread-card__excerpt"><%# Eval("FirstPost") %></div>
                            <div class="thread-card__meta">
                                <span>👤 <%# Eval("AuthorName") %></span>
                                <span>🏷 <%# Eval("CategoryName") %></span>
                                <span>💬 <%# Eval("PostCount") %> replies</span>
                                <span>🕐 <%# Eval("CreatedAt", "{0:dd MMM yyyy}") %></span>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoThreads" runat="server" Visible="false">
                <div class="empty-state">No threads yet. Start a discussion!</div>
            </asp:Panel>
        </div>

        <!-- Sidebar -->
        <aside>
            <div class="sidebar-widget">
                <h4>Categories</h4>
                <asp:Repeater ID="rptCats" runat="server">
                    <ItemTemplate>
                        <a href="Community.aspx?cat=<%# Eval("CategoryID") %>" class="cat-tag"><%# Eval("CategoryName") %></a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="sidebar-widget">
                <h4>Announcements</h4>
                <asp:Repeater ID="rptAnn" runat="server">
                    <ItemTemplate>
                        <div style="padding:8px 0;border-bottom:1px solid var(--border);font-size:0.85rem;">
                            <div style="font-weight:600;margin-bottom:3px;"><%# Eval("Title") %></div>
                            <div style="color:var(--text-light);font-size:0.78rem;"><%# Eval("CreatedAt", "{0:dd MMM yyyy}") %></div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlNoAnn" runat="server" Visible="false">
                    <div style="color:var(--text-light);font-size:0.85rem;padding:8px 0;">No announcements.</div>
                </asp:Panel>
            </div>
        </aside>
    </div><!-- /.community-layout -->
    </div><!-- /.container -->
</asp:Content>
