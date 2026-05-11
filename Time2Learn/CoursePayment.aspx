<%@ Page Title="Enroll - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CoursePayment.aspx.cs" Inherits="Time2Learn.CoursePayment" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .payment-layout { max-width:900px; margin:0 auto; padding:48px 24px; display:grid; grid-template-columns:1fr 320px; gap:32px; align-items:start; }
        .payment-form { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:28px; }
        .payment-form h2 { font-size:1.3rem; margin-bottom:24px; }
        .form-group { margin-bottom:16px; }
        .form-group label { display:block; font-size:0.85rem; font-weight:600; margin-bottom:7px; color:var(--text-dark); }
        .form-group input, .form-group select { width:100%; padding:10px 14px; border:1px solid var(--border); border-radius:var(--radius); font-size:0.9rem; font-family:inherit; box-sizing:border-box; }
        .form-row { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
        .card-icons { display:flex; gap:8px; margin-bottom:16px; font-size:1.6rem; }
        .payment-divider { text-align:center; color:var(--text-light); font-size:0.82rem; margin:20px 0; position:relative; }
        .payment-divider::before { content:''; position:absolute; top:50%; left:0; right:0; height:1px; background:var(--border); z-index:0; }
        .payment-divider span { background:white; padding:0 12px; position:relative; z-index:1; }
        .order-card { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:24px; position:sticky; top:80px; }
        .order-card h3 { font-size:0.95rem; font-weight:700; margin-bottom:16px; }
        .order-card__thumb { height:120px; background:linear-gradient(135deg,#a435f0,#7c2bd1); border-radius:var(--radius); display:flex; align-items:center; justify-content:center; font-size:3rem; margin-bottom:16px; }
        .order-card__title { font-weight:700; margin-bottom:4px; font-size:0.95rem; }
        .order-card__meta { font-size:0.82rem; color:var(--text-light); margin-bottom:16px; }
        .order-price-row { display:flex; justify-content:space-between; padding:10px 0; border-top:1px solid var(--border); font-size:0.9rem; }
        .order-total { display:flex; justify-content:space-between; font-weight:800; font-size:1.05rem; padding-top:10px; border-top:2px solid var(--border); margin-top:4px; }
        .secure-note { font-size:0.78rem; color:var(--text-light); text-align:center; margin-top:12px; }
        .free-badge { background:#d1fae5; color:#065f46; border-radius:var(--radius); padding:12px 16px; font-size:0.88rem; font-weight:600; text-align:center; margin-bottom:16px; }

        /* Dark mode */
        [data-theme="dark"] .payment-form { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .payment-form h2 { color:#fff; }
        [data-theme="dark"] .form-group label { color:#ccc; }
        [data-theme="dark"] .form-group input,
        [data-theme="dark"] .form-group select { background:#1c1d1f; border-color:#444; color:#fff; }
        [data-theme="dark"] .payment-divider span { background:#2a2a2e; }
        [data-theme="dark"] .payment-divider::before { background:#444; }
        [data-theme="dark"] .order-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .order-card h3 { color:#fff; }
        [data-theme="dark"] .order-card__title { color:#fff; }
        [data-theme="dark"] .order-price-row { border-color:#333; color:#ccc; }
        [data-theme="dark"] .order-total { border-color:#444; color:#fff; }
        [data-theme="dark"] .free-badge { background:#064e3b; color:#a7f3d0; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <div class="container">
            <h1>Complete Enrolment</h1>
            <p><a href="Courses.aspx" style="color:inherit;opacity:0.7;">Courses</a> / <a href="CourseDetail.aspx" style="color:inherit;opacity:0.7;">Course Detail</a> / Checkout</p>
        </div>
    </div>

    <div class="container" style="padding-top:0;">
    <div class="payment-layout">

        <!-- Payment Form -->
        <div class="payment-form">
            <h2>Complete Your Enrolment</h2>

            <asp:Panel ID="pnlAlreadyEnrolled" runat="server" Visible="false">
                <div style="background:#d1fae5;border-radius:var(--radius);padding:16px;color:#065f46;font-weight:600;margin-bottom:16px;">
                    ✓ You are already enrolled in this course.
                </div>
                <a href="Student.aspx" class="btn btn--primary">Go to Dashboard</a>
            </asp:Panel>

            <asp:Panel ID="pnlPayForm" runat="server">
                <asp:Panel ID="pnlFree" runat="server" Visible="false">
                    <div class="free-badge">🎉 This course is FREE — click enrol to get instant access!</div>
                </asp:Panel>

                <asp:Panel ID="pnlPaidFields" runat="server">
                    <div class="card-icons">💳 🏦 💰</div>
                    <div class="form-group">
                        <label>Cardholder Name</label>
                        <asp:TextBox ID="txtCardName" runat="server" placeholder="As printed on card" ValidationGroup="PayGroup" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCardName" ErrorMessage="Required." Display="Dynamic" ForeColor="Red" ValidationGroup="PayGroup" />
                    </div>
                    <div class="form-group">
                        <label>Card Number</label>
                        <asp:TextBox ID="txtCardNumber" runat="server" placeholder="1234 5678 9012 3456" MaxLength="19" ValidationGroup="PayGroup" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCardNumber" ErrorMessage="Required." Display="Dynamic" ForeColor="Red" ValidationGroup="PayGroup" />
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Expiry Date</label>
                            <asp:TextBox ID="txtExpiry" runat="server" placeholder="MM/YY" MaxLength="5" ValidationGroup="PayGroup" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtExpiry" ErrorMessage="Required." Display="Dynamic" ForeColor="Red" ValidationGroup="PayGroup" />
                        </div>
                        <div class="form-group">
                            <label>CVV</label>
                            <asp:TextBox ID="txtCVV" runat="server" TextMode="Password" placeholder="123" MaxLength="4" ValidationGroup="PayGroup" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCVV" ErrorMessage="Required." Display="Dynamic" ForeColor="Red" ValidationGroup="PayGroup" />
                        </div>
                    </div>
                </asp:Panel>

                <asp:Button ID="btnEnrol" runat="server" Text="Enrol Now" CssClass="btn btn--primary" style="width:100%;padding:14px;" OnClick="btnEnrol_Click" ValidationGroup="PayGroup" />
                <asp:Label ID="lblMsg" runat="server" style="display:block;margin-top:10px;font-size:0.85rem;" />
                <div class="secure-note">🔒 Secure checkout. Your card details are not stored.</div>
            </asp:Panel>
        </div>

        <!-- Order Summary -->
        <div class="order-card">
            <h3>Order Summary</h3>
            <div class="order-card__thumb">📚</div>
            <div class="order-card__title"><asp:Literal ID="litTitle" runat="server" /></div>
            <div class="order-card__meta"><asp:Literal ID="litMeta" runat="server" /></div>
            <div class="order-price-row">
                <span>Course Price</span>
                <span>RM <asp:Literal ID="litPrice" runat="server" /></span>
            </div>
            <div class="order-total">
                <span>Total</span>
                <span>RM <asp:Literal ID="litTotal" runat="server" /></span>
            </div>
        </div>

    </div>
    </div>
</asp:Content>
