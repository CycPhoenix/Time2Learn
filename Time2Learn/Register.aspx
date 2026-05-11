<%@ Page Title="Create Account - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Time2Learn.Register" %>

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
        .alert-error { background:#fef2f2; border:1px solid #fca5a5; color:#991b1b; padding:12px 16px; border-radius:var(--radius-sm); font-size:0.9rem; font-weight:500; margin-bottom:20px; }
        .success-msg { background:#dcfce7; border:1px solid #86efac; color:#166534; padding:12px 16px; border-radius:var(--radius-sm); font-size:0.9rem; font-weight:500; margin-bottom:20px; }

        /* Dark mode */
        [data-theme="dark"] .auth-split__brand { background:#1c1d1f; border-color:#333; }
        [data-theme="dark"] .auth-brand__art { background:#2a2a2e; box-shadow:none; }
        [data-theme="dark"] .auth-brand__art img { filter:brightness(0) invert(1) }
        [data-theme="dark"] .auth-split__form { background:#18191a; }
        [data-theme="dark"] .auth-heading { color:#fff; }
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
                    <img src="~/assets/logo.png" alt="Time2Learn" style="width:300px;height:300px;object-fit:contain;" />
                </div>
            </div>
        </div>

        <!-- Right: Form -->
        <div class="auth-split__form">
            <div class="auth-form-wrap">

                <h1 class="auth-heading">Sign up to start your<br />learning journey !</h1>

                <asp:Label ID="lblError" runat="server" CssClass="alert-error" Visible="false" />
                <asp:Label ID="lblSuccess" runat="server" CssClass="success-msg" Visible="false" />

                <div class="form-group">
                    <label for="txtFullName">Full Name :</label>
                    <asp:TextBox ID="txtFullName" runat="server" placeholder="Your full name" CssClass="form-control" autocomplete="name" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFullName" CssClass="form-error" ErrorMessage="Full name is required." Display="Dynamic" />
                </div>

                <div class="form-group">
                    <label for="txtEmail">Email Address :</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="you@example.com" CssClass="form-control" autocomplete="email" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" CssClass="form-error" ErrorMessage="Email is required." Display="Dynamic" />
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail" CssClass="form-error" ValidationExpression="^[^\s@]+@[^\s@]+\.[^\s@]+$" ErrorMessage="Enter a valid email address." Display="Dynamic" />
                </div>

                <div class="form-group">
                    <label for="txtPassword">Password :</label>
                    <div class="password-wrapper">
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Create a password" CssClass="form-control" autocomplete="new-password" />
                        <button type="button" class="password-toggle" onclick="togglePassword('<%=txtPassword.ClientID%>', this)">👁</button>
                    </div>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword" CssClass="form-error" ErrorMessage="Password is required." Display="Dynamic" />
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPassword" CssClass="form-error" ValidationExpression=".{6,}" ErrorMessage="Password must be at least 6 characters." Display="Dynamic" />
                </div>

                <p class="auth-switch">Already have an account? &nbsp;<a href="Login.aspx">Log in</a></p>

                <asp:Button ID="btnRegister" runat="server" Text="Continue ›" CssClass="btn btn--primary btn--full btn--lg" OnClick="btnRegister_Click" />

            </div>
        </div>
    </main>
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
