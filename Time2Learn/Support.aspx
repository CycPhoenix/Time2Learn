<%@ Page Title="Support - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Support.aspx.cs" Inherits="Time2Learn.Support" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .support-layout { max-width:1000px; margin:0 auto; padding:48px 24px; }
        .support-header { text-align:center; margin-bottom:48px; }
        .support-header h1 { font-size:2rem; margin-bottom:10px; }
        .support-header p { color:var(--text-light); }
        .support-grid { display:flex; flex-direction:column; gap:32px; }
        .ticket-form { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:28px; max-width:560px; margin:0 auto; width: 100%; }
        .ticket-form h3 { font-size:1.1rem; margin-bottom:20px; }
        .form-group { margin-bottom:16px; }
        .form-group label { display:block; font-size:0.85rem; font-weight:600; margin-bottom:7px; color:var(--text-dark); }
        .form-group input, .form-group select, .form-group textarea { width:100%; padding:10px 14px; border:1px solid var(--border); border-radius:var(--radius); font-size:0.9rem; font-family:inherit; box-sizing:border-box; }
        .form-group textarea { min-height:120px; resize:vertical; }
        .faq-section { max-width:560px; margin:0 auto; width:100% }
        .faq-section h3 { font-size:1.1rem; margin-bottom:20px; }
        .faq-item { background:white; border-radius:var(--radius); border:1px solid var(--border); margin-bottom:10px; overflow:hidden; }
        .faq-item__q { padding:16px 20px; font-weight:600; font-size:0.9rem; cursor:pointer; display:flex; justify-content:space-between; align-items:center; }
        .faq-item__q:after { content:'▼'; font-size:0.75rem; color:var(--text-light); transition:transform 0.2s; }
        .faq-item__q.open:after { transform:rotate(180deg); }
        .faq-item__a { padding:0 20px; max-height:0; overflow:hidden; transition:max-height 0.3s ease; font-size:0.88rem; color:var(--text-light); line-height:1.6; }
        .faq-item__a.open { max-height:200px; padding-bottom:16px; }
        .success-msg { background:#d1fae5; border:1px solid #a7f3d0; border-radius:var(--radius); padding:16px 20px; color:#065f46; font-size:0.9rem; margin-bottom:20px; }
        .quick-links { display:grid; grid-template-columns:repeat(3,1fr); gap:16px; margin-bottom:40px; }
        .quick-link-card { background:white; border:1px solid var(--border); border-radius:var(--radius-lg); padding:20px; text-align:center; transition:var(--t-fast); }
        .quick-link-card:hover { border-color:var(--primary); transform:translateY(-2px); box-shadow:0 4px 12px rgba(0,0,0,0.07); }
        .quick-link-card__icon { font-size:1.8rem; margin-bottom:10px; }
        .quick-link-card__title { font-weight:700; font-size:0.9rem; margin-bottom:4px; }
        .quick-link-card__desc { font-size:0.78rem; color:var(--text-light); }

        /* Dark mode */
        [data-theme="dark"] .ticket-form { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .ticket-form h3 { color:#fff; }
        [data-theme="dark"] .form-group label { color:#ccc; }
        [data-theme="dark"] .form-group input,
        [data-theme="dark"] .form-group select,
        [data-theme="dark"] .form-group textarea { background:#1c1d1f; border-color:#444; color:#fff; }
        [data-theme="dark"] .faq-item { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .faq-item__q { color:#fff; }
        [data-theme="dark"] .faq-item__a { color:#aaa; }
        [data-theme="dark"] .success-msg { background:#064e3b; border-color:#065f46; color:#a7f3d0; }
        [data-theme="dark"] .quick-link-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .quick-link-card__title { color:#fff; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <div class="container">
            <h1>Help &amp; Support</h1>
            <p>We're here to help. Submit a ticket or browse our FAQ.</p>
        </div>
    </div>

    <div class="support-layout">

        <!-- Quick links -->
        <div class="quick-links">
            <div class="quick-link-card">
                <div class="quick-link-card__icon">📚</div>
                <div class="quick-link-card__title">Knowledge Base</div>
                <div class="quick-link-card__desc">Browse articles and tutorials</div>
            </div>
            <div class="quick-link-card">
                <div class="quick-link-card__icon">💬</div>
                <div class="quick-link-card__title">Community Forum</div>
                <div class="quick-link-card__desc"><a href="Community.aspx" style="color:var(--primary);">Ask the community</a></div>
            </div>
            <div class="quick-link-card">
                <div class="quick-link-card__icon">🤖</div>
                <div class="quick-link-card__title">AI Assistant</div>
                <div class="quick-link-card__desc"><a href="Chatbot.aspx" style="color:var(--primary);">Get instant help</a></div>
            </div>
        </div>

        <div class="support-grid" id="ticket-form">

            <!-- Ticket Form -->
            <div class="ticket-form">
                <h3>Submit a Ticket</h3>
                <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
                    <div class="success-msg">✓ Your ticket has been submitted! We'll get back to you soon.</div>
                </asp:Panel>
                <div class="form-group">
                    <label>Your Name</label>
                    <asp:TextBox ID="txtName" runat="server" placeholder="Full name" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName" ErrorMessage="Name required." Display="Dynamic" ForeColor="Red" ValidationGroup="SupportGroup" />
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="your@email.com" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" ErrorMessage="Email required." Display="Dynamic" ForeColor="Red" ValidationGroup="SupportGroup" />
                </div>
                <div class="form-group">
                    <label>Subject</label>
                    <asp:TextBox ID="txtSubject" runat="server" placeholder="Briefly describe your issue" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtSubject" ErrorMessage="Subject required." Display="Dynamic" ForeColor="Red" ValidationGroup="SupportGroup" />
                </div>
                <div class="form-group">
                    <label>Message</label>
                    <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" placeholder="Describe your issue in detail..." />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtMessage" ErrorMessage="Message required." Display="Dynamic" ForeColor="Red" ValidationGroup="SupportGroup" />
                </div>
                <asp:Button ID="btnSubmit" runat="server" Text="Submit Ticket" CssClass="btn btn--primary" OnClick="btnSubmit_Click" ValidationGroup="SupportGroup" />
                <asp:Label ID="lblError" runat="server" ForeColor="Red" style="display:block;margin-top:10px;font-size:0.85rem;" />
            </div>

            <!-- FAQ -->
            <div class="faq-section">
                <h3>Frequently Asked Questions</h3>
                <asp:Repeater ID="rptFAQs" runat="server">
                    <ItemTemplate>
                        <div class="faq-item">
                            <div class="faq-item__q" onclick="toggleFAQ(this)"><%# Eval("Question") %></div>
                            <div class="faq-item__a"><%# Eval("Answer") %></div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

        </div><!-- /.support-grid -->
    </div><!-- /.support-layout -->
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
// @ts-nocheck
function toggleFAQ(el) {
    el.classList.toggle('open');
    var ans = el.nextElementSibling;
    if (ans) ans.classList.toggle('open');
}
</script>
</asp:Content>
