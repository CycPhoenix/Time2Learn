<%@ Page Title="AI Chatbot - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Chatbot.aspx.cs" Inherits="Time2Learn.Chatbot" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .chatbot-page { max-width:800px; margin:0 auto; padding:48px 24px; }
        .chatbot-header { text-align:center; margin-bottom:36px; }
        .chatbot-header h1 { font-size:2rem; margin-bottom:10px; }
        .chatbot-header p { color:var(--text-light); }
        .chat-window { background:white; border-radius:var(--radius-lg); border:1px solid var(--border); overflow:hidden; display:flex; flex-direction:column; height:500px; }
        .chat-messages { flex:1; overflow-y:auto; padding:24px; display:flex; flex-direction:column; gap:16px; }
        .chat-msg { display:flex; gap:12px; max-width:80%; }
        .chat-msg--bot { align-self:flex-start; }
        .chat-msg--user { align-self:flex-end; flex-direction:row-reverse; }
        .chat-msg__avatar { width:36px; height:36px; border-radius:50%; background:var(--primary); color:white; display:flex; align-items:center; justify-content:center; font-size:0.9rem; flex-shrink:0; }
        .chat-msg--user .chat-msg__avatar { background:#e0e7ff; color:#3730a3; }
        .chat-msg__bubble { padding:12px 16px; border-radius:var(--radius-lg); font-size:0.9rem; line-height:1.5; }
        .chat-msg--bot .chat-msg__bubble { background:var(--bg-light); color:var(--text-dark); border-bottom-left-radius:4px; }
        .chat-msg--user .chat-msg__bubble { background:var(--primary); color:white; border-bottom-right-radius:4px; }
        .chat-input-bar { display:flex; gap:8px; padding:16px 20px; border-top:1px solid var(--border); background:white; }
        .chat-input-bar input { flex:1; padding:10px 16px; border:1px solid var(--border); border-radius:24px; font-size:0.9rem; outline:none; }
        .chat-input-bar input:focus { border-color:var(--primary); }
        .chat-send-btn { width:44px; height:44px; border-radius:50%; background:var(--primary); color:white; border:none; cursor:pointer; display:flex; align-items:center; justify-content:center; flex-shrink:0; }
        .chat-send-btn svg { width:18px; height:18px; }
        .chat-footer { text-align:center; margin-top:16px; }
        .chat-footer a { color:var(--primary); font-size:0.85rem; }
        .suggestion-chips { display:flex; gap:8px; flex-wrap:wrap; padding:0 20px 16px; }
        .suggestion-chip { background:var(--bg-light); border:1px solid var(--border); border-radius:16px; padding:6px 14px; font-size:0.82rem; cursor:pointer; transition:var(--t-fast); }
        .suggestion-chip:hover { border-color:var(--primary); color:var(--primary); }

        /* Dark mode */
        [data-theme="dark"] .chat-window { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .chat-msg--bot .chat-msg__bubble { background:#333; color:#e5e7eb; }
        [data-theme="dark"] .chat-input-bar { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .chat-input-bar input { background:#1c1d1f; border-color:#444; color:#fff; }
        [data-theme="dark"] .suggestion-chip { background:#333; border-color:#444; color:#ccc; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="chatbot-page">
        <div class="chatbot-header">
            <h1>🤖 AI Learning Assistant</h1>
            <p>Ask me anything about your courses, programming concepts, or how to use Time2Learn.</p>
        </div>

        <div class="chat-window">
            <div class="chat-messages" id="chatMessages">
                <!-- Initial bot message -->
                <div class="chat-msg chat-msg--bot">
                    <div class="chat-msg__avatar">🤖</div>
                    <div class="chat-msg__bubble">Hi there! I'm your AI learning assistant. How can I help you today?</div>
                </div>
            </div>

            <div class="suggestion-chips" id="suggestionChips">
                <div class="suggestion-chip" onclick="sendSuggestion(this)">How do I enrol in a course?</div>
                <div class="suggestion-chip" onclick="sendSuggestion(this)">What courses are available?</div>
                <div class="suggestion-chip" onclick="sendSuggestion(this)">How do I track my progress?</div>
                <div class="suggestion-chip" onclick="sendSuggestion(this)">How do I contact support?</div>
            </div>

            <div class="chat-input-bar">
                <input type="text" id="chatInput" placeholder="Type your message..." onkeypress="handleKey(event)" />
                <button class="chat-send-btn" onclick="sendMessage()">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
                </button>
            </div>
        </div>

        <div class="chat-footer">
            <a href="ChatbotFullscreen.aspx">Open fullscreen chat →</a>
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
    document.getElementById('suggestionChips').style.display = 'none';
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

function sendSuggestion(el) {
    var input = document.getElementById('chatInput');
    input.value = el.textContent;
    sendMessage();
}

function handleKey(ev) { if (ev.key === 'Enter') { ev.preventDefault(); ev.stopPropagation(); sendMessage(); } }
</script>
</asp:Content>
