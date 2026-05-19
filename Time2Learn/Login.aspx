<%@ Page Title="Log In - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Time2Learn.Login" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .auth-split { display:grid; grid-template-columns:1fr 1fr; min-height:calc(100vh - 64px - 200px); }
        .auth-split__brand { background:var(--bg-light); display:flex; align-items:center; justify-content:center; padding:60px 40px; border-right:1px solid var(--border); }
        .auth-brand { text-align:center; }
        .auth-brand__art { width:300px; height:300px; background:white; border-radius:var(--radius-lg); display:flex; align-items:center; justify-content:center; margin:0 auto 24px; box-shadow:var(--shadow); }
        .auth-split__form { display:flex; align-items:center; justify-content:center; padding:60px 48px; background:white; }
        .auth-form-wrap { width:100%; max-width:380px; }
        .auth-heading { font-size:clamp(1.5rem,2.5vw,1.9rem); font-weight:800; line-height:1.25; margin-bottom:28px; color:var(--text-dark); }
        .auth-switch { font-size:0.875rem; color:var(--text-light); margin-bottom:20px; }
        .auth-switch a { color:var(--primary); font-weight:600; }
        .alert-error { display:flex; align-items:center; gap:8px; background:#fef2f2; border:1px solid #fca5a5; color:#991b1b; padding:10px 14px; border-radius:var(--radius-sm); font-size:0.875rem; font-weight:500; margin-bottom:16px; }
        .success-msg { display:flex; align-items:center; gap:8px; background:#dcfce7; border:1px solid #86efac; color:#166534; padding:10px 14px; border-radius:var(--radius-sm); font-size:0.875rem; font-weight:500; margin-bottom:16px; }
        .demo-box { margin-top:24px; padding:16px; background:var(--bg-light); border-radius:var(--radius); border:1px solid var(--border); }
        .demo-box__title { font-weight:700; font-size:0.82rem; color:var(--text-dark); margin-bottom:10px; }
        .demo-table { width:100%; border-collapse:collapse; font-size:0.8rem; color:var(--text-mid); }
        .demo-table tr { border-bottom:1px solid var(--border); cursor:pointer; }
        .demo-table tr:last-child { border-bottom:none; }
        .demo-table tr:hover { background:var(--primary-light); }
        .demo-table td { padding:5px 4px; }
        .demo-pass { font-family:monospace; color:var(--text-light); }
        .demo-hint { margin-top:8px; font-size:0.75rem; color:var(--text-light); }
        .role-badge { padding:2px 8px; border-radius:4px; font-weight:600; font-size:0.78rem; }
        .role--admin      { background:#f3e8ff; color:#a435f0; }
        .role--instructor { background:#dcfce7; color:#166534; }
        .role--moderator  { background:#fef3c7; color:#92400e; }
        .role--student    { background:#dbeafe; color:#1e40af; }
        .role--cs         { background:#e0f2fe; color:#0369a1; }

        /* Dark mode */
        [data-theme="dark"] .auth-split__brand { background:#1c1d1f; border-color:#333; }
        [data-theme="dark"] .auth-brand__art { background:#2a2a2e; box-shadow:none; }
        [data-theme="dark"] .auth-brand__art img { filter:brightness(0) invert(1); }
        [data-theme="dark"] .auth-split__form { background:#18191a; }
        [data-theme="dark"] .auth-heading { color:#fff; }
        [data-theme="dark"] .demo-box { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .demo-box__title { color:#ccc; }
        [data-theme="dark"] .demo-table { color:#aaa; }
        [data-theme="dark"] .demo-table tr { border-color:#333; }
        [data-theme="dark"] .alert-error { background:#450a0a; border-color:#991b1b; color:#fca5a5; }
        [data-theme="dark"] .success-msg { background:#064e3b; border-color:#065f46; color:#6ee7b7; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="auth-split">

        <!-- Left: Branding -->
        <div class="auth-split__brand">
            <div class="auth-brand">
                <div class="auth-brand__art">
                    <asp:Image runat="server" ImageUrl="~/assets/logo.png" AlternateText="Time2Learn" style="width:300px;height:300px;object-fit:contain;" />
                </div>
            </div>
        </div>

        <!-- Right: Form -->
        <div class="auth-split__form">
            <div class="auth-form-wrap">

                <h1 class="auth-heading">Log in to continue your<br />learning journey !</h1>

                <div class="form-group">
                    <label for="txtEmail">Email Address :</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="you@example.com" CssClass="form-control" autocomplete="email" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" CssClass="form-error" ErrorMessage="Email is required." Display="Dynamic" />
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail" CssClass="form-error" ValidationExpression="^[^\s@]+@[^\s@]+\.[^\s@]+$" ErrorMessage="Enter a valid email address." Display="Dynamic" />
                </div>

                <div class="form-group">
                    <label for="txtPassword">Password :</label>
                    <div class="password-wrapper">
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter your password" CssClass="form-control" autocomplete="current-password" />
                        <button type="button" class="password-toggle" onclick="togglePassword('<%=txtPassword.ClientID%>', this)">👁</button>
                    </div>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword" CssClass="form-error" ErrorMessage="Password is required." Display="Dynamic" />
                </div>

                <asp:Label ID="lblError" runat="server" CssClass="alert-error" Visible="false" />
                <asp:Label ID="lblSuccess" runat="server" CssClass="success-msg" Visible="false" />

                <p class="auth-switch">Don't have an account? &nbsp;<a href="Register.aspx">Sign up</a></p>

                <asp:Button ID="btnLogin" runat="server" Text="Continue ›" CssClass="btn btn--primary btn--full btn--lg" OnClick="btnLogin_Click" />

                <!-- Demo accounts (click to fill) -->
                <div class="demo-box">
                    <div class="demo-box__title">🔑 Demo Test Accounts</div>
                    <table class="demo-table" id="demoTable">
                        <tr>
                            <td><span class="role-badge role--admin">Admin</span></td>
                            <td>admin@time2learn.com</td>
                            <td class="demo-pass">admin123</td>
                        </tr>
                        <tr>
                            <td><span class="role-badge role--instructor">Instructor</span></td>
                            <td>instructor@time2learn.com</td>
                            <td class="demo-pass">teach123</td>
                        </tr>
                        <tr>
                            <td><span class="role-badge role--moderator">Moderator</span></td>
                            <td>moderator@time2learn.com</td>
                            <td class="demo-pass">mod123</td>
                        </tr>
                        <tr>
                            <td><span class="role-badge role--student">Student</span></td>
                            <td>student@time2learn.com</td>
                            <td class="demo-pass">learn123</td>
                        </tr>
                        <tr>
                            <td><span class="role-badge role--cs">Customer Service</span></td>
                            <td>cs@time2learn.com</td>
                            <td class="demo-pass">cs1234</td>
                        </tr>
                    </table>
                    <p class="demo-hint">Click any row to auto-fill ↓</p>
                </div>

            </div>
        </div>
    </main>
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
// @ts-nocheck
// Override garbled togglePassword from script.js
function togglePassword(id, btn) { 
    var input = document.getElementById(id);
    if (!input) return;
    input.type = input.type === 'password' ? 'text' : 'password';
    btn.textContent = '👁';
}

document.querySelectorAll('#demoTable tr').forEach(function (row) {
    row.addEventListener('click', function () {
        var cells = this.querySelectorAll('td');
        if (cells.length >= 3) {
            document.getElementById('<%=txtEmail.ClientID%>').value = cells[1].textContent.trim();
                    document.getElementById('<%=txtPassword.ClientID%>').value = cells[2].textContent.trim();
                }
            });
        });
    </script>
</asp:Content>
