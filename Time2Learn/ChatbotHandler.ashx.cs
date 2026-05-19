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
    public class ChatbotHandler : IHttpHandler
    {
        public bool IsReusable => false;

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            try
            {
                string body = new StreamReader(context.Request.InputStream).ReadToEnd();
                var serializer = new JavaScriptSerializer();
                var input = serializer.Deserialize<Dictionary<string, string>>(body);
                string userMessage = input.ContainsKey("userMessage") ? input["userMessage"] : "";

                string apiKey = ConfigurationManager.AppSettings["GroqApiKey"];

                string requestJson = serializer.Serialize(new
                {
                    model = "llama-3.1-8b-instant",
                    messages = new[]
                    {
                        new
                        {
                            role = "system",
                            content = "You are a helpful learning assistant for Time2Learn, an online learning platform for programming and computer science courses. Answer questions about courses, enrollment, progress tracking, quizzes, certificates, and general programming topics. Keep answers concise and friendly."
                        },
                        new
                        {
                            role = "user",
                            content = userMessage
                        }
                    }
                });

                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Add("Authorization", "Bearer " + apiKey);

                    var content = new StringContent(requestJson, Encoding.UTF8, "application/json");
                    var response = client.PostAsync("https://api.groq.com/openai/v1/chat/completions", content).Result;
                    string responseJson = response.Content.ReadAsStringAsync().Result;

                    var result = serializer.Deserialize<Dictionary<string, object>>(responseJson);

                    if (!result.ContainsKey("choices"))
                    {
                        string errorDetail = result.ContainsKey("error")
                            ? serializer.Serialize(result["error"])
                            : responseJson;
                        context.Response.Write("{\"reply\":\"DEBUG API: " + errorDetail.Replace("\"", "'") + "\"}");
                        return;
                    }

                    var choices = (System.Collections.ArrayList)result["choices"];
                    var choice = (Dictionary<string, object>)choices[0];
                    var message = (Dictionary<string, object>)choice["message"];
                    string reply = message["content"].ToString();

                    context.Response.Write(serializer.Serialize(new { reply = reply }));
                }
            }
            catch (Exception ex)
            {
                context.Response.Write("{\"reply\":\"DEBUG: " + ex.Message.Replace("\"", "'") + "\"}");
            }
        }
    }
}
