using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Time2Learn.App_Code;

namespace Time2Learn
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (AuthHelper.IsLoggedIn())
            {
                string role = AuthHelper.GetUserRole();
                string dashUrl = GetDashboardUrl(role);
                NavAccountLink.NavigateUrl = dashUrl;
                NavAccountLink.ToolTip = AuthHelper.GetUserName();
            }
        }

        private string GetDashboardUrl(string role)
        {
            switch (role)
            {
                case "Administrator":
                    return "Admin.aspx";
                case "Instructor":
                    return "Instructor.aspx";
                case "Moderator":
                    return "Moderator.aspx";
                case "Customer Service":
                    return "CustomerService.aspx";
                default:
                    return "Student.aspx";
            }
        }
    }
}