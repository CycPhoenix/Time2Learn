<%@ Page Title="Lab Exercise - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CurriculumLab.aspx.cs" Inherits="Time2Learn.CurriculumLab" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .lab-layout { max-width:1000px; margin:0 auto; padding:40px 24px; }
        .lab-header { margin-bottom:28px; }
        .lab-header h1 { font-size:1.6rem; margin-bottom:8px; }
        .lab-panel { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:28px; margin-bottom:20px; }
        .lab-panel h3 { font-size:0.95rem; font-weight:700; margin-bottom:14px; }
        .lab-panel p, .lab-panel li { font-size:0.9rem; color:var(--text-light); line-height:1.7; }
        .lab-panel ul { padding-left:20px; }
        .lab-step { display:flex; gap:16px; padding:14px 0; border-bottom:1px solid var(--border); }
        .lab-step:last-child { border-bottom:none; }
        .lab-step__num { width:28px; height:28px; border-radius:50%; background:var(--primary); color:white; display:flex; align-items:center; justify-content:center; font-size:0.82rem; font-weight:700; flex-shrink:0; }
        .lab-step__text { flex:1; font-size:0.9rem; line-height:1.5; }
        .submission-area { background:var(--bg-light); border-radius:var(--radius); padding:20px; }
        .submission-area textarea { width:100%; min-height:120px; padding:12px; border:1px solid var(--border); border-radius:var(--radius); font-size:0.88rem; font-family:inherit; box-sizing:border-box; resize:vertical; margin-bottom:14px; }
        .completed-note { background:#d1fae5; border-radius:var(--radius); padding:12px 16px; color:#065f46; font-size:0.88rem; font-weight:600; margin-bottom:20px; }

        /* Dark mode */
        [data-theme="dark"] .lab-header h1 { color:#fff; }
        [data-theme="dark"] .lab-panel { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .lab-panel h3 { color:#fff; }
        [data-theme="dark"] .lab-step { border-color:#333; }
        [data-theme="dark"] .lab-step__text { color:#ccc; }
        [data-theme="dark"] .submission-area { background:#1c1d1f; }
        [data-theme="dark"] .submission-area textarea { background:#2a2a2e; border-color:#444; color:#fff; }
        [data-theme="dark"] .completed-note { background:#064e3b; color:#6ee7b7; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="lab-layout">
        <div class="lab-header">
            <div style="font-size:0.82rem;color:var(--text-light);margin-bottom:12px;">
                <a href="LearningMaterial.aspx?id=<asp:Literal ID="litCourseID" runat="server" />" style="color:var(--text-light);text-decoration:none;">← Back to Course</a>
            </div>
            <h1><asp:Literal ID="litTitle" runat="server" /></h1>
            <p style="color:var(--text-light);">🧪 Lab Exercise · <asp:Literal ID="litCourse" runat="server" /></p>
        </div>

        <asp:Panel ID="pnlCompleted" runat="server" Visible="false">
            <div class="completed-note">✓ You have already completed this lab.</div>
        </asp:Panel>

        <!-- Instructions -->
        <div class="lab-panel">
            <h3>Lab Instructions</h3>
            <p><asp:Literal ID="litInstructions" runat="server" /></p>
        </div>

        <!-- Steps -->
        <asp:Panel ID="pnlSteps" runat="server" Visible="false">
            <div class="lab-panel">
                <h3>Steps</h3>
                <asp:Repeater ID="rptSteps" runat="server">
                    <ItemTemplate>
                        <div class="lab-step">
                            <div class="lab-step__num"><%# Container.ItemIndex + 1 %></div>
                            <div class="lab-step__text"><%# Eval("StepText") %></div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:Panel>

        <!-- Sample input/output if any -->
        <asp:Panel ID="pnlIO" runat="server" Visible="false">
            <div class="lab-panel">
                <h3>Reference</h3>
                <div style="background:var(--bg-light);border-radius:var(--radius);padding:12px 16px;font-family:monospace;font-size:0.85rem;white-space:pre-wrap;">
                    <asp:Literal ID="litReference" runat="server" />
                </div>
            </div>
        </asp:Panel>

        <!-- Submission -->
        <div class="lab-panel">
            <h3>Submit Your Work</h3>
            <div class="submission-area">
                <p style="margin-bottom:12px;font-size:0.88rem;color:var(--text-light);">Describe what you did or paste your results below:</p>
                <asp:TextBox ID="txtSubmission" runat="server" TextMode="MultiLine" placeholder="Describe your findings, paste your output, or upload notes..." />
                <div style="display:flex;gap:10px;">
                    <asp:Button ID="btnSubmitLab" runat="server" Text="Submit Lab" CssClass="btn btn--primary" OnClick="btnSubmitLab_Click" />
                    <a href="LearningMaterial.aspx?id=<asp:Literal ID="litCourseID2" runat="server" />" class="btn btn--outline">Skip</a>
                </div>
                <asp:Label ID="lblMsg" runat="server" style="display:block;margin-top:10px;font-size:0.85rem;" />
            </div>
        </div>
    </div>
</asp:Content>
