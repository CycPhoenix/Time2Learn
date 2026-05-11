<%@ Page Title="Coding Exercise - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CurriculumCoding.aspx.cs" Inherits="Time2Learn.CurriculumCoding" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .coding-layout { max-width:1100px; margin:0 auto; padding:40px 24px; }
        .coding-header { margin-bottom:28px; }
        .coding-header h1 { font-size:1.6rem; margin-bottom:8px; }
        .coding-header p { color:var(--text-light); font-size:0.9rem; }
        .coding-grid { display:grid; grid-template-columns:1fr 1fr; gap:24px; }
        .problem-panel { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:24px; }
        .problem-panel h3 { font-size:0.95rem; font-weight:700; margin-bottom:14px; }
        .problem-panel p { font-size:0.88rem; color:var(--text-light); line-height:1.7; }
        .io-block { background:var(--bg-light); border-radius:var(--radius); padding:12px 16px; font-family:monospace; font-size:0.85rem; margin-top:10px; white-space:pre-wrap; }
        .io-block h4 { font-size:0.78rem; font-weight:700; color:var(--text-light); text-transform:uppercase; letter-spacing:0.06em; margin-bottom:6px; }
        .editor-panel { display:flex; flex-direction:column; gap:16px; }
        .editor-header { display:flex; justify-content:space-between; align-items:center; }
        .editor-header h3 { font-size:0.95rem; font-weight:700; }
        .lang-select { padding:6px 12px; border:1px solid var(--border); border-radius:var(--radius); font-size:0.85rem; }
        .code-editor { width:100%; min-height:300px; padding:16px; background:#1e1e1e; color:#d4d4d4; border-radius:var(--radius-lg); border:none; font-family:'Courier New',monospace; font-size:0.88rem; line-height:1.6; resize:vertical; box-sizing:border-box; }
        .output-panel { background:#1e1e1e; border-radius:var(--radius); padding:16px; font-family:monospace; font-size:0.85rem; color:#d4d4d4; min-height:80px; white-space:pre-wrap; }
        .output-panel.success { border:1px solid #059669; }
        .output-panel.error { border:1px solid #ef4444; }
        .run-actions { display:flex; gap:10px; }
        .completed-note { background:#d1fae5; border-radius:var(--radius); padding:12px 16px; color:#065f46; font-size:0.88rem; font-weight:600; margin-bottom:20px; }

        /* Dark mode */
        [data-theme="dark"] .coding-header h1 { color:#fff; }
        [data-theme="dark"] .problem-panel { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .problem-panel h3 { color:#fff; }
        [data-theme="dark"] .io-block { background:#1c1d1f; color:#ccc; }
        [data-theme="dark"] .editor-header h3 { color:#fff; }
        [data-theme="dark"] .lang-select { background:#1c1d1f; border-color:#444; color:#fff; }
        [data-theme="dark"] .completed-note { background:#064e3b; color:#6ee7b7; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="coding-layout">
        <div class="coding-header">
            <div style="font-size:0.82rem;color:var(--text-light);margin-bottom:12px;">
                <a href="LearningMaterial.aspx?id=<asp:Literal ID="litCourseID" runat="server" />" style="color:var(--text-light);text-decoration:none;">← Back to Course</a>
            </div>
            <h1><asp:Literal ID="litTitle" runat="server" /></h1>
            <p>Coding Exercise · <asp:Literal ID="litCourse" runat="server" /></p>
        </div>

        <asp:Panel ID="pnlCompleted" runat="server" Visible="false">
            <div class="completed-note">✓ You have already completed this exercise.</div>
        </asp:Panel>

        <div class="coding-grid">
            <!-- Problem -->
            <div class="problem-panel">
                <h3>Problem</h3>
                <p><asp:Literal ID="litProblem" runat="server" /></p>

                <asp:Panel ID="pnlSampleInput" runat="server" Visible="false">
                    <div class="io-block" style="margin-top:16px;">
                        <h4>Sample Input</h4>
                        <asp:Literal ID="litSampleInput" runat="server" />
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlSampleOutput" runat="server" Visible="false">
                    <div class="io-block">
                        <h4>Expected Output</h4>
                        <asp:Literal ID="litSampleOutput" runat="server" />
                    </div>
                </asp:Panel>
            </div>

            <!-- Editor -->
            <div class="editor-panel">
                <div class="editor-header">
                    <h3>Your Solution</h3>
                    <select class="lang-select" id="langSelect">
                        <option>Python</option>
                        <option>JavaScript</option>
                        <option>Java</option>
                        <option>C#</option>
                    </select>
                </div>
                <asp:TextBox ID="txtCode" runat="server" TextMode="MultiLine" CssClass="code-editor" placeholder="# Write your solution here..." />
                <div class="run-actions">
                    <asp:Button ID="btnSubmitCode" runat="server" Text="Submit Solution" CssClass="btn btn--primary" OnClick="btnSubmitCode_Click" />
                    <a href="LearningMaterial.aspx?id=<asp:Literal ID="litCourseID2" runat="server" />" class="btn btn--outline">Skip</a>
                </div>
                <div id="outputPanel" class="output-panel" style="display:none;"></div>
                <asp:Label ID="lblMsg" runat="server" style="font-size:0.85rem;" />
            </div>
        </div>
    </div>
</asp:Content>
