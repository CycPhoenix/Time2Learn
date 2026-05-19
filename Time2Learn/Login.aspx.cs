using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Time2Learn.App_Code;

namespace Time2Learn
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && AuthHelper.IsLoggedIn())
                Response.Redirect(GetDashboardUrl(AuthHelper.GetUserRole()));
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                string email = txtEmail.Text.Trim().ToLower();
                string passwordHash = AuthHelper.HashPassword(txtPassword.Text);

                string sql = @"SELECT u.UserID, u.FirstName, u.LastName, r.RoleName, u.AccountStatus FROM Users u INNER JOIN Roles r ON u.RoleID = r.RoleID WHERE LOWER(u.Email) = @Email AND u.PasswordHash = @PasswordHash";

                SqlParameter[] parameters =
                {
                    new SqlParameter("@Email", email),
                    new SqlParameter("@PasswordHash", passwordHash)
                };

                DataTable dt = DBHelper.ExecuteQuery(sql, parameters);

                if (dt.Rows.Count == 0)
                {
                    lblError.Text = "Invalid email or password. Please try again.";
                    lblError.Visible = true;
                    return;
                }

                DataRow row = dt.Rows[0];

                if (row["AccountStatus"].ToString() != "Active")
                {
                    lblError.Text = "Your account has been suspended. Please contact support.";
                    lblError.Visible = true;
                    return;
                }

                int userID = (int)row["UserID"];
                string role = row["RoleName"].ToString();
                string name = row["FirstName"].ToString() + " " + row["LastName"].ToString();

                AuthHelper.SetSession(userID, role, name);

                lblSuccess.Text = "Login successful! Redirecting...";
                lblSuccess.Visible = true;
                lblError.Visible = false;

                Response.Redirect(GetDashboardUrl(role));
            }
            catch (Exception)
            {
                lblError.Text = "Unable to connect. Please try again later.";
                lblError.Visible = true;
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
