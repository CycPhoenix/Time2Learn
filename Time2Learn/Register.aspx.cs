using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Time2Learn.App_Code;
using System.Data;
using System.Data.SqlClient;

namespace Time2Learn
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && AuthHelper.IsLoggedIn())
                Response.Redirect("Student.aspx");
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim().ToLower();
            string password = txtPassword.Text;

            // Split full name into first and last name
            string firstName, lastName;
            int spaceIdx = fullName.IndexOf(' ');
            if (spaceIdx > 0)
            {
                firstName = fullName.Substring(0, spaceIdx).Trim();
                lastName = fullName.Substring(spaceIdx + 1).Trim();
            }
            else
            {
                firstName = fullName;
                lastName = "";
            }

            // Avatar = first letter of first + first letter of last (or first 2 of first)
            string avatar = (firstName.Length > 0 ? firstName[0].ToString() : "") + (lastName.Length > 0 ? lastName[0].ToString() : (firstName.Length > 1 ? firstName[1].ToString() : ""));
            avatar = avatar.ToUpper();

            // Duplicate email check
            string checkSql = "SELECT COUNT(*) FROM Users WHERE LOWER(Email) = @Email";
            SqlParameter[] checkParams = { new SqlParameter("@Email", email) };
            int existing = Convert.ToInt32(DBHelper.ExecuteScalar(checkSql, checkParams));

            if (existing > 0)
            {
                lblError.Text = "An account with this email already exists. <a href=\"Login.aspx\">Log in instead?</a>";
                lblError.Visible = true;
                return;
            }

            // Get Student RoleID
            string roleSql = "SELECT RoleID FROM Roles WHERE RoleName = 'Student'";
            object roleObj = DBHelper.ExecuteScalar(roleSql);
            if (roleObj == null)
            {
                lblError.Text = "Registration is temporarily unavailable. Please try again later.";
                lblError.Visible = true;
                return;
            }
            int studentRoleID = Convert.ToInt32(roleObj);

            string passwordHash = AuthHelper.HashPassword(password);

            string insertSql = @"INSERT INTO Users (FirstName, LastName, Email, PasswordHash, RoleID, Avatar, AccountStatus, CreatedAt) VALUES (@FirstName, @LastName, @Email, @PasswordHash, @RoleID, @Avatar, 'Active', GETDATE()); SELECT SCOPE_IDENTITY();";

            SqlParameter[] insertParams =
            {
                new SqlParameter("@FirstName", firstName),
                new SqlParameter("@LastName", lastName),
                new SqlParameter("@Email", email),
                new SqlParameter("@PasswordHash", passwordHash),
                new SqlParameter("@RoleID", studentRoleID),
                new SqlParameter("@Avater", avatar)
            };

            object newIDObj = DBHelper.ExecuteScalar(insertSql, insertParams);
            if (newIDObj == null)
            {
                lblError.Text = "Registration failed. Please try again.";
                lblError.Visible = true;
                return;
            }

            int newUserID = Convert.ToInt32(newIDObj);
            AuthHelper.SetSession(newUserID, "Student", fullName);

            lblSuccess.Text = "Account Created! Redirecting to your dashboard...";
            lblSuccess.Visible = true;
            lblError.Visible = false;

            Response.Redirect("Student.aspx");
        }
    }
}