<%@ Page Title="Cart - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="Time2Learn.Cart" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .cart-layout { max-width:1000px; margin:0 auto; padding:48px 24px; display:grid; grid-template-columns:1fr 300px; gap:32px; align-items:start; }
        .cart-header { font-size:1.8rem; font-weight:800; margin-bottom:24px; }
        .cart-item { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:20px 24px; margin-bottom:14px; display:flex; gap:16px; align-items:center; }
        .cart-item__thumb { width:72px; height:72px; border-radius:var(--radius); background:linear-gradient(135deg,#a435f0,#7c2bd1); display:flex; align-items:center; justify-content:center; font-size:1.8rem; flex-shrink:0; }
        .cart-item__info { flex:1; }
        .cart-item__title { font-weight:700; font-size:0.95rem; margin-bottom:4px; }
        .cart-item__meta { font-size:0.82rem; color:var(--text-light); }
        .cart-item__price { font-size:1.1rem; font-weight:800; color:var(--text-dark); margin-right:16px; }
        .cart-item__remove { background:none; border:none; color:#ef4444; cursor:pointer; font-size:0.82rem; font-weight:600; padding:4px 8px; border-radius:4px; }
        .cart-item__remove:hover { background:#fee2e2; }
        .order-summary { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:24px; position:sticky; top:80px; }
        .order-summary h3 { font-size:1rem; font-weight:700; margin-bottom:20px; }
        .summary-row { display:flex; justify-content:space-between; font-size:0.9rem; padding:8px 0; border-bottom:1px solid var(--border); }
        .summary-row:last-of-type { border-bottom:none; }
        .summary-total { display:flex; justify-content:space-between; font-size:1.05rem; font-weight:800; padding:16px 0 0; border-top:2px solid var(--border); margin-top:8px; }
        .empty-cart { text-align:center; padding:80px 24px; color:var(--text-light); grid-column:1/-1; }
        .empty-cart h2 { margin-bottom:12px; font-size:1.4rem; }
        .empty-cart__icon { font-size:3.5rem; margin-bottom:16px; }

        /* Dark mode */
        [data-theme="dark"] .cart-item { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .cart-item__title { color:#fff; }
        [data-theme="dark"] .cart-item__price { color:#fff; }
        [data-theme="dark"] .cart-item__remove:hover { background:#3d1515; }
        [data-theme="dark"] .order-summary { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .order-summary h3 { color:#fff; }
        [data-theme="dark"] .summary-row { border-color:#333; color:#ccc; }
        [data-theme="dark"] .summary-total { border-color:#444; color:#fff; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <div class="container">
            <h1>Your Cart</h1>
            <p>Review your selected courses before checkout.</p>
        </div>
    </div>

    <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
        <div style="max-width:1000px;margin:0 auto;padding:0 24px;">
            <div class="empty-cart">
                <div class="empty-cart__icon">🛒</div>
                <h2>Your cart is empty</h2>
                <p>Browse our courses and add something you'd like to learn.</p>
                <a href="Courses.aspx" class="btn btn--primary" style="margin-top:20px;">Browse Courses →</a>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlCart" runat="server">
        <div class="cart-layout">
            <div>
                <asp:Repeater ID="rptCart" runat="server">
                    <ItemTemplate>
                        <div class="cart-item">
                            <div class="cart-item__thumb">📚</div>
                            <div class="cart-item__info">
                                <div class="cart-item__title"><%# Eval("CourseTitle") %></div>
                                <div class="cart-item__meta"><%# Eval("CategoryName") %> · <%# Eval("DifficultyLevel") %></div>
                            </div>
                            <span class="cart-item__price">RM <%# Eval("Price", "{0:0.00}") %></span>
                            <asp:LinkButton runat="server" CommandName="Remove" CommandArgument='<%# Eval("CourseID") %>' CssClass="cart-item__remove" OnCommand="CartAction_Command">Remove</asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <div class="order-summary">
                <h3>Order Summary</h3>
                <asp:Repeater ID="rptSummary" runat="server">
                    <ItemTemplate>
                        <div class="summary-row">
                            <span style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;max-width:160px;"><%# Eval("CourseTitle") %></span>
                            <span>RM <%# Eval("Price", "{0:0.00}") %></span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <div class="summary-total">
                    <span>Total</span>
                    <span>RM <asp:Literal ID="litTotal" runat="server" /></span>
                </div>
                <asp:Button ID="btnCheckout" runat="server" Text="Checkout" CssClass="btn btn--primary" style="width:100%;margin-top:16px;" OnClick="btnCheckout_Click" />
                <asp:Label ID="lblMsg" runat="server" style="display:block;font-size:0.82rem;margin-top:8px;text-align:center;" />
            </div>
        </div>
    </asp:Panel>
</asp:Content>
