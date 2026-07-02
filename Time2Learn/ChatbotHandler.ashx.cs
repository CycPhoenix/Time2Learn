using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Script.Serialization;
using Time2Learn.App_Code;

namespace Time2Learn
{
    public class ChatbotHandler : HttpTaskAsyncHandler
    {
        private static readonly HttpClient httpClient = new HttpClient();

        public override bool IsReusable => false;

        public override async Task ProcessRequestAsync(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var serializer = new JavaScriptSerializer();

            try
            {
                string body = new StreamReader(context.Request.InputStream).ReadToEnd();
                var input = serializer.Deserialize<Dictionary<string, string>>(body);
                string userMessage = (input != null && input.ContainsKey("userMessage")) ? input["userMessage"] : "";

                if (string.IsNullOrWhiteSpace(userMessage))
                {
                    context.Response.Write(serializer.Serialize(new { reply = "Please type a question." }));
                    return;
                }

                // Check the Knowledge Base first; only call the AI if nothing matches
                string kbReply = FindKnowledgeBaseMatch(userMessage);
                if (kbReply != null)
                {
                    context.Response.Write(serializer.Serialize(new { reply = kbReply }));
                    return;
                }

                string apiKey = ConfigurationManager.AppSettings["GroqApiKey"];
                if (string.IsNullOrEmpty(apiKey))
                {
                    context.Response.Write(serializer.Serialize(new { reply = "Sorry, the assistant is temporarily unavailable." }));
                    return;
                }

                string requestJson = serializer.Serialize(new
                {
                    model = "llama-3.1-8b-instant",
                    messages = new[]
                    {
                        new
                        {
                            role = "system",
                            content = "You are a friendly, approachable learning assistant for Time2Learn, an online learning platform for programming and computer science courses. Chat naturally and warmly, like a helpful friend, not a corporate FAQ page. Keep replies short, 1 to 3 sentences, unless the user is genuinely asking for step-by-step instructions. Avoid rigid numbered lists for casual questions. You can help with courses, enrollment, progress tracking, quizzes, certificates, and general programming topics."
                        },
                        new
                        {
                            role = "user",
                            content = userMessage
                        }
                    }
                });

                var requestMessage = new HttpRequestMessage(HttpMethod.Post, "https://api.groq.com/openai/v1/chat/completions")
                {
                    Content = new StringContent(requestJson, Encoding.UTF8, "application/json")
                };
                requestMessage.Headers.Add("Authorization", "Bearer " + apiKey);

                var response = await httpClient.SendAsync(requestMessage);
                string responseJson = await response.Content.ReadAsStringAsync();

                var result = serializer.Deserialize<Dictionary<string, object>>(responseJson);

                if (result == null || !result.ContainsKey("choices"))
                {
                    context.Response.Write(serializer.Serialize(new { reply = "Sorry, I could not get a response right now. Please try again shortly." }));
                    return;
                }

                var choices = (System.Collections.ArrayList)result["choices"];
                var choice = (Dictionary<string, object>)choices[0];
                var message = (Dictionary<string, object>)choice["message"];
                string reply = message["content"].ToString();

                context.Response.Write(serializer.Serialize(new { reply = reply }));
            }
            catch (Exception)
            {
                context.Response.Write(serializer.Serialize(new { reply = "Sorry, something went wrong. Please try again." }));
            }
        }

        /// <summary>
        /// Looks for an active Knowledge Base entry whose Topic appears in the user's
        /// message. Returns the longest matching Topic's ResponseSummary, or null if
        /// nothing matches closely enough to trust over the AI.
        /// </summary>
        private string FindKnowledgeBaseMatch(string userMessage)
        {
            DataTable kb = DBHelper.ExecuteQuery(
                "SELECT Topic, ResponseSummary FROM Knowledge_Base WHERE Status = 'Active'");

            if (kb == null || kb.Rows.Count == 0) return null;

            string normalizedMsg = userMessage.ToLowerInvariant();
            DataRow bestMatch = null;
            int bestLength = 0;

            foreach (DataRow row in kb.Rows)
            {
                string topic = row["Topic"].ToString().ToLowerInvariant().Trim();
                if (topic.Length < 3) continue; // skip topics too short to match reliably

                if (normalizedMsg.Contains(topic) && topic.Length > bestLength)
                {
                    bestMatch = row;
                    bestLength = topic.Length;
                }
            }

            return bestMatch != null ? bestMatch["ResponseSummary"].ToString() : null;
        }
    }
}
