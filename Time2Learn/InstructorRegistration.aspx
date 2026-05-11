<%@ Title="Become an Instructor - Time2Learn" Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="InstructorRegistration.aspx.cs" Inherits="Time2Learn.InstructorRegistration" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .ir-layout { max-width:900px; margin:0 auto; padding:48px 24px; }
        .ir-hero { text-align:center; margin-bottom:48px; }
        .ir-hero h1 { font-size:2.2rem; margin-bottom:12px; }
        .ir-hero h1 span { color:var(--primary); }
        .ir-hero p { color:var(--text-light); max-width:540px; margin:0 auto; line-height:1.7; }
        .ir-benefits { display:grid; grid-template-columns:repeat(3,1fr); gap:20px; margin-bottom:48px; }
        .ir-benefit { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:24px; text-align:center; }
        .ir-benefit__icon { font-size:2rem; margin-bottom:10px; }
        .ir-benefit h3 { font-size:0.95rem; font-weight:700; margin-bottom:6px; }
        .ir-benefit p { font-size:0.82rem; color:var(--text-light); line-height:1.5; }
        .ir-form { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:36px; }
        .ir-form h2 { font-size:1.3rem; margin-bottom:28px; }
        .form-grid { display:grid; grid-template-columns:1fr 1fr; gap:20px; }
        .form-group { margin-bottom:18px; }
        .form-group.full { grid-column:1/-1; }
        .form-group label { display:block; font-size:0.85rem; font-weight:600; margin-bottom:7px; color:var(--text-dark); }
        .form-group input, .form-group select, .form-group textarea { width:100%; padding:10px 14px; border:1px solid var(--border); border-radius:var(--radius); font-size:0.9rem; font-family:inherit; box-sizing:border-box; }
        .form-group textarea { min-height:100px; resize:vertical; }
        .form-group input:focus, .form-group textarea:focus, .form-group select:focus { border-color:var(--primary); outline:none; }
        .ir-submit { margin-top:8px; }
        .success-panel { background:#d1fae5; border:1px solid #a7f3d0; border-radius:var(--radius-lg); padding:32px; text-align:center; }
        .success-panel h2 { color:#065f46; margin-bottom:10px; }
        .success-panel p { color:#047857; margin-bottom:20px; }

        /* Dark mode */
        [data-theme="dark"] .ir-benefit { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .ir-benefit h3 { color:#fff; }
        [data-theme="dark"] .ir-form { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .ir-form h2 { color:#fff; }
        [data-theme="dark"] .form-group label { color:#ccc; }
        [data-theme="dark"] .form-group input,
        [data-theme="dark"] .form-group select,
        [data-theme="dark"] .form-group textarea { background:#1c1d1f; border-color:#444; color:#fff; }
        [data-theme="dark"] .success-panel { background:#064e3b; border-color:#065f46; }
        [data-theme="dark"] .success-panel h2 { color:#6ee7b7; }
        [data-theme="dark"] .success-panel p { color:#a7f3d0; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="ir-layout">

        <!-- Hero -->
        <div class="ir-hero">
            <h1>Become an <span>Instructor</span></h1>
            <p>Share your knowledge with thousands of learners. Apply to teach on Time2Learn and earn while you impact lives.</p>
        </div>

        <!-- Benefits -->
        <div class="ir-benefits">
            <div class="ir-benefit">
                <div class="ir-benefit__icon">💰</div>
                <h3>Earn Revenue</h3>
                <p>Get paid for every student who enrols in your course.</p>
            </div>
            <div class="ir-benefit">
                <div class="ir-benefit__icon">🌍</div>
                <h3>Global Reach</h3>
                <p>Teach students from around the world on one platform.</p>
            </div>
            <div class="ir-benefit">
                <div class="ir-benefit__icon">🛠</div>
                <h3>Full Tools</h3>
                <p>Use our course builder, quizzes, labs, and analytics.</p>
            </div>
        </div>

        <!-- Success -->
        <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
            <div class="success-panel">
                <h2>🎉 Application Submitted!</h2>
                <p>Thank you for applying. Our team will review your application and activate your instructor account within 2-3 business days.</p>
                <a href="Default.aspx" class="btn btn--primary">Back to Home</a>
            </div>
        </asp:Panel>

        <!-- Form -->
        <asp:Panel ID="pnlForm" runat="server">
            <div class="ir-form">
                <h2>Instructor Application</h2>
                <div class="form-grid">
                    <div class="form-group">
                        <label>First Name</label>
                        <asp:TextBox ID="txtFirstName" runat="server" placeholder="First name" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFirstName" ErrorMessage="Required." Display="Dynamic" ForeColor="Red" ValidationGroup="IRGroup" />
                    </div>
                    <div class="form-group">
                        <label>Last Name</label>
                        <asp:TextBox ID="txtLastName" runat="server" placeholder="Last name" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtLastName" ErrorMessage="Required." Display="Dynamic" ForeColor="Red" ValidationGroup="IRGroup" />
                    </div>
                    <div class="form-group">
                        <label>Email Address</label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="your@email.com" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" ErrorMessage="Required." Display="Dynamic" ForeColor="Red" ValidationGroup="IRGroup" />
                    </div>
                    <div class="form-group">
                        <label>Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Create a password" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword" ErrorMessage="Required." Display="Dynamic" ForeColor="Red" ValidationGroup="IRGroup" />
                    </div>
                    <div class="form-group full">
                        <label>Teaching Category</label>
                        <asp:DropDownList ID="ddlCategory" runat="server" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlCategory" InitialValue="0" ErrorMessage="Please select a category." Display="Dynamic" ForeColor="Red" ValidationGroup="IRGroup" />
                    </div>
                    <div class="form-group full">
                        <label>Teaching Plan</label>
                        <asp:TextBox ID="txtTeachingPlan" runat="server" TextMode="MultiLine" placeholder="Describe the courses you plan to create and your teaching approach..." />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTeachingPlan" ErrorMessage="Required." Display="Dynamic" ForeColor="Red" ValidationGroup="IRGroup" />
                    </div>
                    <div class="form-group full">
                        <label>Why do you want to teach on Time2Learn?</label>
                        <asp:TextBox ID="txtMotivation" runat="server" TextMode="MultiLine" placeholder="Tell us about yourself and your teaching goals..." />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtMotivation" ErrorMessage="Required." Display="Dynamic" ForeColor="Red" ValidationGroup="IRGroup" />
                    </div>
                </div>
                <div class="ir-submit">
                    <asp:Button ID="btnApply" runat="server" Text="Submit Application" CssClass="btn btn--primary btn--lg" OnClick="btnApply_Click" ValidationGroup="IRGroup" />
                    <asp:Label ID="lblError" runat="server" ForeColor="Red" style="display:block;margin-top:10px;font-size:0.85rem;" />
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
