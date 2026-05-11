<%@ Page Title="AI Chatbot" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ChatbotFullscreen.aspx.cs" Inherits="Time2Learn.ChatbotFullscreen" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .chatfs-wrap { display:flex; flex-direction:column; height:calc(100vh - 68px); background:white; }
        .chatfs-header { display:flex; align-items:center; justify-content:space-between; padding:16px 24px; border-bottom:1px solid var(--border); background:white; flex-shrink:0; }
        .chatfs-header__left { display:flex; align-items:center; gap:14px; }
        .chatfs-bot-avatar { width:44px; height:44px; border-radius:50%; background:var(--primary); color:white; display:flex; align-items:center; justify-content:center; font-size:1.4rem; }
        .chatfs-bot-name { font-weight:700; font-size:1rem; }
        .chatfs-bot-status { font-size:0.78rem; color:#059669; }
        .chatfs-messages { flex:1; overflow-y:auto; padding:32px 24px; display:flex; flex-direction:column; gap:20px; background:var(--bg-light); }
        .chat-msg { display:flex; gap:12px; max-width:70%; }
        .chat-msg--bot { align-self:flex-start; }
        .chat-msg--user { align-self:flex-end; flex-direction:row-reverse; }
        .chat-msg__avatar { width:36px; height:36px; border-radius:50%; background:var(--primary); color:white; display:flex; align-items:center; justify-content:center; font-size:0.9rem; flex-shrink:0; }
        .chat-msg--user .chat-msg__avatar { background:#e0e7ff; color:#3730a3; }
        .chat-msg__bubble { padding:14px 18px; border-radius:var(--radius-lg); font-size:0.9rem; line-height:1.6; }
        .chat-msg--bot .chat-msg__bubble { background:white; color:var(--text-dark); border-bottom-left-radius:4px; box-shadow:0 1px 4px rgba(0,0,0,0.06); }
        .chat-msg--user .chat-msg__bubble { background:var(--primary); color:white; border-bottom-right-radius:4px; }
        .chatfs-input { padding:20px 24px; border-top:1px solid var(--border); background:white; display:flex; gap:12px; flex-shrink:0; }
        .chatfs-input input { flex:1; padding:12px 20px; border:1px solid var(--border); border-radius:28px; font-size:0.92rem; outline:none; }
        .chatfs-input input:focus { border-color:var(--primary); }
        .chatfs-send { padding:12px 28px; background:var(--primary); color:white; border:none; border-radius:28px; font-size:0.9rem; font-weight:600; cursor:pointer; }
        .chatfs-send:hover { background:#8b2fc9; }

        /* Dark mode */
        [data-theme="dark"] .chatfs-wrap { background:#18191a; }
        [data-theme="dark"] .chatfs-header { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .chatfs-bot-name { color:#fff; }
        [data-theme="dark"] .chatfs-messages { background:#18191a; }
        [data-theme="dark"] .chat-msg--bot .chat-msg__bubble { background:#2a2a2e; color:#e5e7eb; box-shadow:none; }
        [data-theme="dark"] .chatfs-input { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .chatfs-input input { background:#1c1d1f; border-color:#444; color:#fff; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="chatfs-wrap">
        <div class="chatfs-header">
            <div class="chatfs-header__left">
                <div class="chatfs-bot-avatar">🤖</div>
                <div>
                    <div class="chatfs-bot-name">Time2Learn AI Assistant</div>
                    <div class="chatfs-bot-status">● Online</div>
                </div>
            </div>
            <a href="Chatbot.aspx" class="btn btn--outline btn--sm">Exit Fullscreen</a>
        </div>

        <div class="chatfs-messages" id="chatMessages">
            <div class="chat-msg chat-msg--bot">
                <div class="chat-msg__avatar">🤖</div>
                <div class="chat-msg__bubble">Hello! I'm your AI learning assistant. I can help you with questions about courses, your progress, enrolment, and more. What would you like to know?</div>
            </div>
        </div>

        <div class="chatfs-input">
            <input type="text" id="chatInput" placeholder="Ask me anything about Time2Learn..." onkeypress="handleKey(event)" />
            <button class="chatfs-send" onclick="sendMessage()">Send</button>
        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
// @ts-nocheck
function addMessage(text, isUser) {
    var msgs = document.getElementById('chatMessages');
    var div = document.createElement('div');
    div.className = 'chat-msg ' + (isUser ? 'chat-msg--user' : 'chat-msg--bot');
    div.innerHTML = '<div class="chat-msg__avatar">' + (isUser ? '👤' : '🤖') + '</div><div class="chat-msg__bubble">' + text + '</div>';
    msgs.appendChild(div);
    msgs.scrollTop = msgs.scrollHeight;
}

function addTypingIndicator() {
    var msgs = document.getElementById('chatMessages');
    var div = document.createElement('div');
    div.className = 'chat-msg chat-msg--bot';
    div.id = 'typingIndicator';
    div.innerHTML = '<div class="chat-msg__avatar">🤖</div><div class="chat-msg__bubble">Typing...</div>';
    msgs.appendChild(div);
    msgs.scrollTop = msgs.scrollHeight;
}

function removeTypingIndicator() {
    var el = document.getElementById('typingIndicator');
    if (el) el.parentNode.removeChild(el);
}

function sendMessage() {
    var input = document.getElementById('chatInput');
    var msg = input.value.trim();
    if (!msg) return;
    addMessage(msg, true);
    input.value = '';
    addTypingIndicator();

    fetch('ChatbotHandler.ashx', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ userMessage: msg })
    })
        .then(function (res) { return res.json(); })
        .then(function (data) {
            removeTypingIndicator();
            addMessage(data.reply || 'Sorry, I could not get a response.', false);
        })
        .catch(function () {
            removeTypingIndicator();
            addMessage('Sorry, I am having trouble connecting right now. Please try again.', false);
        });
}

function handleKey(ev) { if (ev.key === 'Enter') { ev.preventDefault(); ev.stopPropagation(); sendMessage(); } }
</script>
</asp:Content>
