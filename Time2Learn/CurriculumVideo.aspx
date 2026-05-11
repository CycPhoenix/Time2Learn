<%@ Page Title="Video Lesson - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CurriculumVideo.aspx.cs" Inherits="Time2Learn.CurriculumVideo" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .cv-layout { max-width:1000px; margin:0 auto; padding:40px 24px; }
        .cv-breadcrumb { font-size:0.82rem; color:var(--text-light); margin-bottom:24px; }
        .cv-breadcrumb a { color:var(--text-light); text-decoration:none; }
        .cv-breadcrumb a:hover { color:var(--primary); }
        .cv-title { font-size:1.8rem; font-weight:800; margin-bottom:8px; }
        .cv-meta { display:flex; gap:16px; font-size:0.85rem; color:var(--text-light); margin-bottom:28px; }
        .video-player { background:#000; border-radius:var(--radius-lg); aspect-ratio:16/9; display:flex; align-items:center; justify-content:center; margin-bottom:28px; overflow:hidden; }
        .video-player video { width:100%; height:100%; }
        .video-placeholder { text-align:center; color:#555; }
        .video-placeholder__icon { font-size:4rem; margin-bottom:12px; }
        .video-placeholder__text { font-size:0.9rem; }
        .cv-body { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:28px; margin-bottom:24px; }
        .cv-body h3 { font-size:1rem; font-weight:700; margin-bottom:14px; }
        .cv-body p { color:var(--text-light); font-size:0.9rem; line-height:1.7; }
        .cv-nav { display:flex; justify-content:space-between; align-items:center; gap:16px; margin-top:24px; }
        .complete-badge { background:#d1fae5; border-radius:var(--radius); padding:12px 20px; color:#065f46; font-size:0.88rem; font-weight:600; }

        /* Dark mode */
        [data-theme="dark"] .cv-title { color:#fff; }
        [data-theme="dark"] .cv-body { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .cv-body h3 { color:#fff; }
        [data-theme="dark"] .complete-badge { background:#064e3b; color:#6ee7b7; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="cv-layout">
        <div class="cv-breadcrumb">
            <a href="Default.aspx">Home</a> ›
            <a href="LearningMaterial.aspx?id=<asp:Literal ID="litCourseID" runat="server" />">
                <asp:Literal ID="litCourseName" runat="server" />
            </a> ›
            <asp:Literal ID="litLessonTitle" runat="server" />
        </div>

        <h1 class="cv-title"><asp:Literal ID="litTitle" runat="server" /></h1>
        <div class="cv-meta">
            <span>📹 Video Lesson</span>
            <span>Course: <asp:Literal ID="litCourse" runat="server" /></span>
        </div>

        <!-- Video Player -->
        <div class="video-player">
            <asp:Panel ID="pnlVideo" runat="server" Visible="false">
                <video controls style="width:100%;">
                    <asp:Literal ID="litVideoUrl" runat="server" />
                    Your browser does not support video.
                </video>
            </asp:Panel>
            <asp:Panel ID="pnlPlaceholder" runat="server">
                <div class="video-placeholder">
                    <div class="video-placeholder__icon">▶</div>
                    <div class="video-placeholder__text">Video content will appear here.</div>
                </div>
            </asp:Panel>
        </div>

        <!-- Description -->
        <div class="cv-body">
            <h3>About This Lesson</h3>
            <p><asp:Literal ID="litContent" runat="server" /></p>
        </div>

        <!-- Resources -->
        <asp:Panel ID="pnlResources" runat="server" Visible="false">
            <div class="cv-body">
                <h3>Additional Resources</h3>
                <asp:Repeater ID="rptResources" runat="server">
                    <ItemTemplate>
                        <div style="padding:8px 0;border-bottom:1px solid var(--border);font-size:0.88rem;">
                            <a href="<%# Eval("ResourceURL") %>" target="_blank" style="color:var(--primary);">📎 <%# string.IsNullOrEmpty(Eval("AdditionalContent") != null ? Eval("AdditionalContent").ToString() : "") ? Eval("ResourceURL") : Eval("AdditionalContent") %></a>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:Panel>

        <!-- Navigation -->
        <div class="cv-nav">
            <asp:HyperLink ID="lnkPrev" runat="server" CssClass="btn btn--outline">← Previous</asp:HyperLink>
            <div>
                <asp:Panel ID="pnlCompleted" runat="server" Visible="false">
                    <div class="complete-badge">✓ Lesson Completed</div>
                </asp:Panel>
                <asp:Button ID="btnComplete" runat="server" Text="Mark as Complete" CssClass="btn btn--primary" OnClick="btnComplete_Click" Visible="false" />
            </div>
            <asp:HyperLink ID="lnkNext" runat="server" CssClass="btn btn--outline">Next →</asp:HyperLink>
        </div>
    </div>
</asp:Content>
