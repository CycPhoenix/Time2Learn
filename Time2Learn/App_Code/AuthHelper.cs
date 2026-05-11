using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Web.SessionState;

namespace Time2Learn.App_Code
{
    public class AuthHelper
    {
        public static string HashPassword(string password)
        {
            using (SHA256 sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder sb = new StringBuilder();
                foreach (byte b in bytes)
                {
                    sb.Append(b.ToString("x2"));
                }
                return sb.ToString();
            }
        }

        public static bool IsLoggedIn()
        {
            return HttpContext.Current.Session["UserID"] != null;
        }

        public static int GetUserID()
        {
            if (!IsLoggedIn()) return 0;
            return (int)HttpContext.Current.Session["UserID"];
        }

        public static string GetUserRole()
        {
            if (!IsLoggedIn()) return string.Empty;
            return HttpContext.Current.Session["Role"].ToString();
        }

        public static string GetUserName()
        {
            if (!IsLoggedIn()) return string.Empty;
            return HttpContext.Current.Session["Name"].ToString();
        }

        public static void SetSession(int userID, string role, string name)
        {
            HttpContext.Current.Session["UserID"] = userID;
            HttpContext.Current.Session["Role"] = role;
            HttpContext.Current.Session["Name"] = name;
        }

        public static void ClearSession()
        {
            HttpContext.Current.Session.Clear();
        }

        public static void RequireLogin()
        {
            if (!IsLoggedIn())
            {
                HttpContext.Current.Response.Redirect("Login.aspx");
            }
        }

        public static void RequireRole(string role)
        {
            if (!IsLoggedIn() || GetUserRole() != role)
            {
                HttpContext.Current.Response.Redirect("Login.aspx");
            }
        }
    }
}