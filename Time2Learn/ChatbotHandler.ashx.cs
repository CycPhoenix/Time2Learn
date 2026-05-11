using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;

namespace Time2Learn
{
    /// <summary>
    /// Summary description for ChatBotHandler
    /// </summary>
    public class ChatBotHandler : IHttpHandler
    {
        public bool IsReusable => false;

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            try
            {
                string body = new StreamReader(context.Request.InputStream).ReadToEnd();
                var serializer = new JavaScriptSerializer();
                var input = serializer.Deserialize<System.Collections.Generic.Dictionary<string, string>>(body);
                string userMessage = input.ContainsKey("userMessage") ? input["userMessage"] : "";

                string apiKey = ConfigurationManager.AppSettings["GeminiApiKey"];
                string url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" + apiKey;

                string prompt = "You are a helpful learning assistant for Time2Learn, an onlin learning platform for programming and computer science courses. Answer questions about courses, enrollment, progress tracking, quizzes, certificates, and general programming topics. Keep answers concise and friendly.\n\nUser: " + userMessage;

                string requestJson = serializer.Serialize(new
                {
                    contents = new[]
                    {
                        new
                        {
                            parts = new[]
                            {
                                new { text = prompt }
                            }
                        }
                    }
                });

                using (var client = new HttpClient())
                {
                    var content = new StringContent(requestJson, Encoding.UTF8, "application/json");
                    var response = client.PostAsync(url, content).Result;
                    string responseJson = response.Content.ReadAsStringAsync().Result;

                    var result = serializer.Deserialize<Dictionary<string, object>>(responseJson);
                    var candidates = (System.Collections.ArrayList)result["candidates"];
                    var candidate = (Dictionary<string, object>)candidates[0];
                    var msgContent = (Dictionary<string, object>)candidate["content"];
                    var parts = (System.Collections.ArrayList)msgContent["parts"];
                    var part = (Dictionary<string, object>)parts[0];
                    string reply = part["text"].ToString();

                    context.Response.Write(serializer.Serialize(new { reply = reply }));
                }
            }
            catch (Exception ex)
            {
                context.Response.Write("{\"reply\":\"Sorry, I'm having trouble connecting right now. Please try again later.\"}");
            }
        }
    }
}