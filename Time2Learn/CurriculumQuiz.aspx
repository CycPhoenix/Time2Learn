<%@ Page Title="Quiz - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CurriculumQuiz.aspx.cs" Inherits="Time2Learn.CurriculumQuiz" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .quiz-layout { max-width:800px; margin:0 auto; padding:40px 24px; }
        .quiz-header { margin-bottom:32px; }
        .quiz-header h1 { font-size:1.8rem; margin-bottom:8px; }
        .quiz-header p { color:var(--text-light); }
        .quiz-card { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); padding:28px; margin-bottom:20px; }
        .quiz-card__num { font-size:0.78rem; font-weight:700; color:var(--primary); text-transform:uppercase; letter-spacing:0.06em; margin-bottom:12px; }
        .quiz-card__q { font-size:1rem; font-weight:700; margin-bottom:18px; line-height:1.5; }
        .quiz-option { display:flex; align-items:center; gap:12px; padding:12px 16px; border:2px solid var(--border); border-radius:var(--radius); margin-bottom:10px; cursor:pointer; transition:var(--t-fast); }
        .quiz-option:hover { border-color:var(--primary); background:rgba(164,53,240,0.04); }
        .quiz-option input[type=radio] { accent-color:var(--primary); width:16px; height:16px; flex-shrink:0; }
        .quiz-option label { cursor:pointer; font-size:0.9rem; flex:1; }
        .quiz-option.correct { border-color:#059669; background:#d1fae5; }
        .quiz-option.wrong { border-color:#ef4444; background:#fee2e2; }
        .quiz-actions { display:flex; justify-content:space-between; align-items:center; margin-top:24px; }
        .result-banner { border-radius:var(--radius-lg); padding:24px; text-align:center; margin-bottom:28px; }
        .result-banner--pass { background:#d1fae5; border:1px solid #a7f3d0; color:#065f46; }
        .result-banner--fail { background:#fee2e2; border:1px solid #fca5a5; color:#991b1b; }
        .result-banner h2 { font-size:1.4rem; margin-bottom:6px; }
        .result-banner p { font-size:0.95rem; }
        .completed-note { background:#d1fae5; border-radius:var(--radius); padding:12px 16px; color:#065f46; font-size:0.88rem; font-weight:600; }

        /* Dark mode */
        [data-theme="dark"] .quiz-header h1 { color:#fff; }
        [data-theme="dark"] .quiz-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .quiz-card__q { color:#fff; }
        [data-theme="dark"] .quiz-option { border-color:#444; }
        [data-theme="dark"] .quiz-option label { color:#ccc; }
        [data-theme="dark"] .result-banner--pass { background:#064e3b; border-color:#065f46; color:#6ee7b7; }
        [data-theme="dark"] .result-banner--fail { background:#450a0a; border-color:#991b1b; color:#fca5a5; }
        [data-theme="dark"] .completed-note { background:#064e3b; color:#6ee7b7; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="quiz-layout">
        <div class="quiz-header">
            <div style="font-size:0.82rem;color:var(--text-light);margin-bottom:12px;">
                <a href="LearningMaterial.aspx?id=<asp:Literal ID="litCourseID" runat="server" />" style="color:var(--text-light);text-decoration:none;">← Back to Course</a>
            </div>
            <h1><asp:Literal ID="litTitle" runat="server" /></h1>
            <p><asp:Literal ID="litSubtitle" runat="server" /></p>
        </div>

        <asp:Panel ID="pnlAlreadyPassed" runat="server" Visible="false">
            <div class="completed-note">✓ You have already completed this quiz.</div>
            <div style="margin-top:20px;">
                <a href="LearningMaterial.aspx?id=<asp:Literal ID="litCourseID2" runat="server" />" class="btn btn--primary">Continue Course</a>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlResult" runat="server" Visible="false">
            <asp:Panel ID="pnlPass" runat="server" Visible="false">
                <div class="result-banner result-banner--pass">
                    <h2>🎉 Quiz Passed!</h2>
                    <p>Score: <asp:Literal ID="litScore" runat="server" />% — Great work!</p>
                </div>
            </asp:Panel>
            <asp:Panel ID="pnlFail" runat="server" Visible="false">
                <div class="result-banner result-banner--fail">
                    <h2>❌ Not Quite!</h2>
                    <p>Score: <asp:Literal ID="litScoreFail" runat="server" />% — You need 60% to pass. Try again.</p>
                </div>
            </asp:Panel>
            <asp:Button ID="btnRetry" runat="server" Text="Retry Quiz" CssClass="btn btn--outline" OnClick="btnRetry_Click" />
            <a href="LearningMaterial.aspx?id=<asp:Literal ID="litCourseID3" runat="server" />" class="btn btn--primary" style="margin-left:12px;">Back to Course</a>
        </asp:Panel>

        <asp:Panel ID="pnlQuiz" runat="server">
            <asp:Repeater ID="rptQuestions" runat="server">
                <ItemTemplate>
                    <div class="quiz-card">
                        <div class="quiz-card__num">Question <%# Container.ItemIndex + 1 %></div>
                        <div class="quiz-card__q"><%# Eval("QuestionText") %></div>
                        <asp:HiddenField runat="server" ID="hdnQID" Value='<%# Eval("QuizID") %>' />
                        <div class="quiz-option"><input type="radio" name="q_<%# Eval("QuizID") %>" value="A" id="a_<%# Eval("QuizID") %>" /><label for="a_<%# Eval("QuizID") %>"><%# Eval("OptionA") %></label></div>
                        <div class="quiz-option"><input type="radio" name="q_<%# Eval("QuizID") %>" value="B" id="b_<%# Eval("QuizID") %>" /><label for="b_<%# Eval("QuizID") %>"><%# Eval("OptionB") %></label></div>
                        <div class="quiz-option"><input type="radio" name="q_<%# Eval("QuizID") %>" value="C" id="c_<%# Eval("QuizID") %>" /><label for="c_<%# Eval("QuizID") %>"><%# Eval("OptionC") %></label></div>
                        <div class="quiz-option"><input type="radio" name="q_<%# Eval("QuizID") %>" value="D" id="d_<%# Eval("QuizID") %>" /><label for="d_<%# Eval("QuizID") %>"><%# Eval("OptionD") %></label></div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <div class="quiz-actions">
                <asp:HiddenField ID="hdnAnswers" runat="server" />
                <span style="color:var(--text-light);font-size:0.85rem;"><asp:Literal ID="litQCount" runat="server" /> questions</span>
                <asp:Button ID="btnSubmit" runat="server" Text="Submit Quiz" CssClass="btn btn--primary" OnClick="btnSubmit_Click" />
            </div>
        </asp:Panel>
    </div>
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        // @ts-nocheck
        document.addEventListener('DOMContentLoaded', function () {
            var btn = document.getElementById('<%= btnSubmit.ClientID %>');
            if (!btn) return;
            btn.addEventListener('click', function () {
                var radios = document.querySelectorAll('input[type="radio"]:checked');
                var ans = [];
                radios.forEach(function (r) { ans.push(r.name.replace('q_', '') + ':' + r.value); });
                document.getElementById('<%= hdnAnswers.ClientID %>').value = ans.join(',');
            });
        });
</script>
</asp:Content>
