<%@ Page Title="Learning Material - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LearningMaterial.aspx.cs" Inherits="Time2Learn.LearningMaterial" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .lm-layout { display:grid; grid-template-columns:300px 1fr; min-height:calc(100vh - 68px); }
        .lm-sidebar { background:#1c1d1f; overflow-y:auto; position:sticky; top:68px; height:calc(100vh - 68px); }
        .lm-sidebar__header { padding:20px 20px 16px; border-bottom:1px solid #2a2a2a; }
        .lm-sidebar__course { font-size:0.82rem; color:#888; margin-bottom:6px; }
        .lm-sidebar__title { font-weight:700; color:white; font-size:0.95rem; line-height:1.4; }
        .lm-sidebar__progress { margin-top:12px; }
        .lm-sidebar__pct { display:flex; justify-content:space-between; font-size:0.78rem; color:#888; margin-bottom:6px; }
        .progress-bar { height:4px; background:#333; border-radius:2px; }
        .progress-bar__fill { height:100%; background:var(--primary); border-radius:2px; }
        .lm-lesson-list { padding:12px 0; }
        .lm-lesson-item { display:flex; align-items:center; gap:12px; padding:12px 20px; cursor:pointer; transition:var(--t-fast); text-decoration:none; }
        .lm-lesson-item:hover { background:rgba(255,255,255,0.05); }
        .lm-lesson-item.active { background:rgba(164,53,240,0.15); border-left:3px solid var(--primary); padding-left:17px; }
        .lm-lesson-item.completed .lm-lesson-check { background:#059669; border-color:#059669; color:white; }
        .lm-lesson-check { width:22px; height:22px; border-radius:50%; border:2px solid #444; display:flex; align-items:center; justify-content:center; font-size:0.65rem; flex-shrink:0; color:#444; }
        .lm-lesson-info { flex:1; min-width:0; }
        .lm-lesson-title { font-size:0.85rem; color:#ccc; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .lm-lesson-item.active .lm-lesson-title { color:white; font-weight:600; }
        .lm-lesson-type { font-size:0.72rem; color:#666; margin-top:2px; }
        .lm-main { padding:40px; overflow-y:auto; }
        .lm-course-header { margin-bottom:36px; }
        .lm-course-header h1 { font-size:1.8rem; margin-bottom:8px; }
        .lm-course-header p { color:var(--text-light); }
        .lm-stats { display:grid; grid-template-columns:repeat(3,1fr); gap:16px; margin-bottom:32px; }
        .lm-stat { background:white; border-radius:var(--radius); border:1px solid var(--border); padding:16px 20px; }
        .lm-stat__label { font-size:0.78rem; color:var(--text-light); margin-bottom:6px; font-weight:600; }
        .lm-stat__value { font-size:1.6rem; font-weight:800; color:var(--text-dark); }
        .lm-section h2 { font-size:1.1rem; font-weight:700; margin-bottom:16px; padding-bottom:8px; border-bottom:2px solid var(--border); }
        .lesson-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(240px,1fr)); gap:16px; }
        .lesson-card { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:20px; transition:var(--t-fast); }
        .lesson-card:hover { box-shadow:0 4px 16px rgba(0,0,0,0.06); transform:translateY(-2px); }
        .lesson-card.completed { border-left:4px solid #059669; }
        .lesson-card__type-badge { font-size:0.72rem; font-weight:700; text-transform:uppercase; padding:3px 8px; border-radius:10px; margin-bottom:10px; display:inline-block; }
        .type-video   { background:#dbeafe; color:#1d4ed8; }
        .type-quiz    { background:#fef3c7; color:#92400e; }
        .type-coding  { background:#ede9fe; color:#5b21b6; }
        .type-lab     { background:#d1fae5; color:#065f46; }
        .lesson-card__title { font-weight:700; font-size:0.9rem; margin-bottom:8px; }
        .lesson-card__status { font-size:0.78rem; color:var(--text-light); display:flex; align-items:center; gap:6px; }
        .lesson-card__status.done { color:#059669; }

        /* Dark mode */
        [data-theme="dark"] .lm-main { background:#18191a; }
        [data-theme="dark"] .lm-course-header h1 { color:#fff; }
        [data-theme="dark"] .lm-stat { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .lm-stat__value { color:#fff; }
        [data-theme="dark"] .lm-section h2 { color:#fff; border-color:#333; }
        [data-theme="dark"] .lesson-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .lesson-card__title { color:#fff; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="lm-layout">

        <!-- Sidebar -->
        <aside class="lm-sidebar">
            <div class="lm-sidebar__header">
                <div class="lm-sidebar__course">Course</div>
                <div class="lm-sidebar__title"><asp:Literal ID="litSidebarTitle" runat="server" /></div>
                <div class="lm-sidebar__progress">
                    <div class="lm-sidebar__pct">
                        <span>Progress</span>
                        <span><asp:Literal ID="litSidebarPct" runat="server" />%</span>
                    </div>
                    <div class="progress-bar"><div class="progress-bar__fill" style="width:<asp:Literal ID="litSidebarPctStyle" runat="server" />%;"></div></div>
                </div>
            </div>
            <div class="lm-lesson-list">
                <asp:Repeater ID="rptSidebarLessons" runat="server">
                    <ItemTemplate>
                        <a href="<%# GetLessonUrl(Eval("LessonID"), Eval("LessonType")) %>" class="lm-lesson-item <%# Convert.ToBoolean(Eval("IsCompleted")) ? "completed" : "" %>">
                            <div class="lm-lesson-check"><%# Convert.ToBoolean(Eval("IsCompleted")) ? "✓" : "" %></div>
                            <div class="lm-lesson-info">
                                <div class="lm-lesson-title"><%# Eval("LessonTitle") %></div>
                                <div class="lm-lesson-type"><%# Eval("LessonType") %></div>
                            </div>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </aside>

        <!-- Main -->
        <main class="lm-main">
            <div class="lm-course-header">
                <h1><asp:Literal ID="litCourseTitle" runat="server" /></h1>
                <p><asp:Literal ID="litCourseMeta" runat="server" /></p>
            </div>

            <div class="lm-stats">
                <div class="lm-stat">
                    <div class="lm-stat__label">Total Lessons</div>
                    <div class="lm-stat__value"><asp:Literal ID="litLessonTotal" runat="server" /></div>
                </div>
                <div class="lm-stat">
                    <div class="lm-stat__label">Completed</div>
                    <div class="lm-stat__value"><asp:Literal ID="litLessonDone" runat="server" /></div>
                </div>
                <div class="lm-stat">
                    <div class="lm-stat__label">Progress</div>
                    <div class="lm-stat__value"><asp:Literal ID="litProgressPct" runat="server" />%</div>
                </div>
            </div>

            <div class="lm-section">
                <h2>Course Lessons</h2>
                <div class="lesson-grid">
                    <asp:Repeater ID="rptLessons" runat="server">
                        <ItemTemplate>
                            <a href="<%# GetLessonUrl(Eval("LessonID"), Eval("LessonType")) %>" class="lesson-card <%# Convert.ToBoolean(Eval("IsCompleted")) ? "completed" : "" %>" style="text-decoration:none;color:inherit;">
                                <div class="lesson-card__type-badge type-<%# Eval("LessonType").ToString().ToLower() %>"><%# Eval("LessonType") %></div>
                                <div class="lesson-card__title"><%# Eval("LessonTitle") %></div>
                                <div class="lesson-card__status <%# Convert.ToBoolean(Eval("IsCompleted")) ? "done" : "" %>">
                                    <%# Convert.ToBoolean(Eval("IsCompleted")) ? "✓ Completed" : "▶ Start" %>
                                </div>
                            </a>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </main>
    </div>
</asp:Content>
