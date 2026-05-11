using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Time2Learn.App_Code;

namespace Time2Learn
{
    public partial class InstructorRegistration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DataTable cats = DBHelper.ExecuteQuery("SELECT CategoryID, CategoryName FROM Categories ORDER BY CategoryName");
                ddlCategory.DataSource = cats;
                ddlCategory.DataTextField = "CategoryName";
                ddlCategory.DataValueField = "CategoryID";
                ddlCategory.DataBind();
                ddlCategory.Items.Insert(0, new ListItem("-- Select Category --", "0"));
            }
        }

        protected void btnApply_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim().ToLower();
            string firstName = txtFirstName.Text.Trim();
            string lastName = txtLastName.Text.Trim();
            string password = txtPassword.Text;

            object existing = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Users WHERE LOWER(Email) = @Email",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@Email", email)
                });
            if (Convert.ToInt32(existing) > 0)
            {
                lblError.Text = "An account with this email already exists. Please log in.";
                return;
            }

            object instructorRoleID = DBHelper.ExecuteScalar("SELECT RoleID FROM Roles WHERE RoleName = 'Instructor'");
            if (instructorRoleID == null)
            {
                lblError.Text = "System error. Please try again.";
                return;
            }

            if (!int.TryParse(ddlCategory.SelectedValue, out int categoryID) || categoryID == 0)
            {
                lblError.Text = "Please select a teaching category.";
                return;
            }

            string passwordHash = AuthHelper.HashPassword(password);
            string avatar = (firstName.Length > 0 ? firstName[0].ToString() : "I") + (lastName.Length > 0 ? lastName[0].ToString() : "");
            avatar = avatar.ToUpper();

            object newUserID = DBHelper.ExecuteScalar(@"INSERT INTO Users (FirstName, LastName, Email, PasswordHash, RoleID, Avatar, AccountStatus, RegistrationDate) VALUES (@FN, @LN, @Email, @PwHash, @RoleID, @Avatar, 'Inactive', GETDATE()); SELECT SCOPE_IDENTITY();",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@FN", firstName),
                    new System.Data.SqlClient.SqlParameter("@LN", lastName),
                    new System.Data.SqlClient.SqlParameter("@Email", email),
                    new System.Data.SqlClient.SqlParameter("@PwHash", passwordHash),
                    new System.Data.SqlClient.SqlParameter("@RoleID", Convert.ToInt32(instructorRoleID)),
                    new System.Data.SqlClient.SqlParameter("@Avatar", avatar)
                });
            if (newUserID == null)
            {
                lblError.Text = "Registration failed. Please try again.";
                return;
            }

            int userID = Convert.ToInt32(newUserID);

            DBHelper.ExecuteNonQuery(@"INSERT INTO Instructor (UserID, CategoryID, TeachingPlan, Motivation, Status) VALUES (@UID, @CatID, @Plan, @Motivation, 'pending')",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID),
                    new System.Data.SqlClient.SqlParameter("@CatID", categoryID),
                    new System.Data.SqlClient.SqlParameter("@Plan", txtTeachingPlan.Text.Trim()),
                    new System.Data.SqlClient.SqlParameter("@Motivation", txtMotivation.Text.Trim()),
                });
            
            pnlForm.Visible = false;
            pnlSuccess.Visible = true;
        }
    }
}