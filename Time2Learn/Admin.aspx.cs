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
    public partial class Admin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole("Administrator");
            if (!IsPostBack) LoadData();
        }

        private void LoadData()
        {
            int userID = AuthHelper.GetUserID();

            DataTable me = DBHelper.ExecuteQuery("SELECT Avatar, FirstName, LastName, Email FROM Users WHERE UserID = @UID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID)
                });
            if (me.Rows.Count > 0)
            {
                DataRow r = me.Rows[0];
                litAvatar.Text = r["Avatar"] != DBNull.Value ? r["Avatar"].ToString() : "A";
                litName.Text = r["FirstName"] + " " + r["LastName"];
                litEmail.Text = r["Email"].ToString();
            }

            object uc = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Users");
            object cc = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Courses");
            object ec = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Enrollments");
            object tc = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Support_Tickets WHERE TicketStatus != @S1 AND TicketStatus != @S2",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@S1", "Resolved"),
                    new System.Data.SqlClient.SqlParameter("@S2", "Closed")
                });

            litUserCount.Text = uc?.ToString() ?? "0";
            litCourseCount.Text = cc?.ToString() ?? "0";
            litEnrollCount.Text = ec?.ToString() ?? "0";
            litTicketCount.Text = tc?.ToString() ?? "0";

            DataTable recentUsers = DBHelper.ExecuteQuery(@"SELECT TOP 10 u.UserID, u.FirstName, u.LastName, u.Email, r.RoleName, u.AccountStatus, u.RegistrationDate FROM Users u INNER JOIN Roles r ON u.RoleID = r.RoleID ORDER BY u.RegistrationDate DESC");
            rptRecentUsers.DataSource = recentUsers;
            rptRecentUsers.DataBind();

            DataTable allUsers = DBHelper.ExecuteQuery(@"SELECT u.UserID, u.FirstName, u.LastName, u.Email, r.RoleName, u.AccountStatus, u.RegistrationDate FROM Users u INNER JOIN Roles r ON u.RoleID = r.RoleID ORDER BY u.RegistrationDate DESC");
            litAllUserCount.Text = allUsers.Rows.Count.ToString();
            rptUsers.DataSource = allUsers;
            rptUsers.DataBind();

            DataTable allCourses = DBHelper.ExecuteQuery(@"SELECT c.CourseID, c.CourseTitle, c.CourseStatus, c.Price, cat.CategoryName, u.FirstName + ' ' + u.LastName AS InstructorName FROM Courses c INNER JOIN Categories cat ON c.CategoryID = cat.CategoryID INNER JOIN Users u ON c.CreatedBy = u.UserID ORDER BY c.CourseID DESC");
            litAllCourseCount.Text = allCourses.Rows.Count.ToString();
            rptCourses.DataSource = allCourses;
            rptCourses.DataBind();

            // Pending instructor applications
            DataTable apps = DBHelper.ExecuteQuery(@"SELECT u.UserID, u.FirstName, u.LastName, u.Email, u.RegistrationDate, i.TeachingPlan FROM Users u INNER JOIN Roles r ON u.RoleID = r.RoleID INNER JOIN Instructor i ON u.UserID = i.UserID WHERE r.RoleName = 'Instructor' AND i.Status = 'pending' ORDER BY u.RegistrationDate DESC");
            pnlNoApps.Visible = apps.Rows.Count == 0;
            rptInstructorApps.DataSource = apps;
            rptInstructorApps.DataBind();

            LoadProfile();
        }

        private void LoadProfile()
        {
            int userID = AuthHelper.GetUserID();
            DataTable p = DBHelper.ExecuteQuery(
                "SELECT FirstName, LastName, Email, Avatar FROM Users WHERE UserID = @UID",
                new SqlParameter[] { new SqlParameter("@UID", userID) });
            if (p.Rows.Count > 0)
            {
                DataRow r = p.Rows[0];
                string fn = r["FirstName"].ToString();
                string ln = r["LastName"].ToString();
                string av = r["Avatar"] != DBNull.Value ? r["Avatar"].ToString() : fn.Length > 0 ? fn[0].ToString().ToUpper() : "?";
                string email = r["Email"].ToString();
                txtProfileFirstName.Text = fn;
                txtProfileLastName.Text = ln;
                txtProfileAvatar.Text = av;
                litProfileAvatar.Text = av;
                litProfileName.Text = fn + " " + ln;
                litProfileEmailDisp.Text = email;
                litProfileEmailRO.Text = email;
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            int userID = AuthHelper.GetUserID();
            string firstName = txtProfileFirstName.Text.Trim();
            string lastName = txtProfileLastName.Text.Trim();
            string avatar = txtProfileAvatar.Text.Trim();
            if (string.IsNullOrEmpty(avatar))
                avatar = firstName.Length > 0 ? firstName[0].ToString().ToUpper() : "?";

            DBHelper.ExecuteNonQuery(
                "UPDATE Users SET FirstName = @FN, LastName = @LN, Avatar = @AV WHERE UserID = @UID",
                new SqlParameter[] {
                    new SqlParameter("@FN", firstName),
                    new SqlParameter("@LN", lastName),
                    new SqlParameter("@AV", avatar),
                    new SqlParameter("@UID", userID)
                });

            AuthHelper.SetSession(userID, AuthHelper.GetUserRole(), firstName + " " + lastName);
            hdnActiveSection.Value = "profile";
            lblProfileMsg.Text = "✓ Profile updated.";
            lblProfileMsg.ForeColor = System.Drawing.Color.Green;
            LoadData();
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            int userID = AuthHelper.GetUserID();
            string currentPwd = txtCurrentPwd.Text;
            string newPwd = txtNewPwd.Text;
            string confirmPwd = txtConfirmPwd.Text;

            hdnActiveSection.Value = "settings";

            if (string.IsNullOrEmpty(currentPwd) || string.IsNullOrEmpty(newPwd) || string.IsNullOrEmpty(confirmPwd))
            {
                lblPwdMsg.Text = "All fields are required.";
                lblPwdMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }
            if (newPwd != confirmPwd)
            {
                lblPwdMsg.Text = "New passwords do not match.";
                lblPwdMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }
            if (newPwd.Length < 6)
            {
                lblPwdMsg.Text = "New password must be at least 6 characters.";
                lblPwdMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }

            string currentHash = AuthHelper.HashPassword(currentPwd);
            object stored = DBHelper.ExecuteScalar(
                "SELECT PasswordHash FROM Users WHERE UserID = @UID AND PasswordHash = @Hash",
                new SqlParameter[] {
                    new SqlParameter("@UID", userID),
                    new SqlParameter("@Hash", currentHash)
                });

            if (stored == null)
            {
                lblPwdMsg.Text = "Current password is incorrect.";
                lblPwdMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }

            DBHelper.ExecuteNonQuery(
                "UPDATE Users SET PasswordHash = @Hash WHERE UserID = @UID",
                new SqlParameter[] {
                    new SqlParameter("@Hash", AuthHelper.HashPassword(newPwd)),
                    new SqlParameter("@UID", userID)
                });

            txtCurrentPwd.Text = "";
            txtNewPwd.Text = "";
            txtConfirmPwd.Text = "";
            lblPwdMsg.Text = "✓ Password updated successfully.";
            lblPwdMsg.ForeColor = System.Drawing.Color.Green;
        }

        protected void UserAction_Command(object sender, CommandEventArgs e)
        {
            if (e.CommandName == "ToggleStatus")
            {
                int targetID = Convert.ToInt32(e.CommandArgument);
                object currentStatus = DBHelper.ExecuteScalar("SELECT AccountStatus FROM Users WHERE UserID = @UID",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@UID", targetID)
                    });
                string newStatus = currentStatus?.ToString() == "Active" ? "Inactive" : "Active";
                DBHelper.ExecuteNonQuery("UPDATE Users SET AccountStatus = @Status WHERE UserID = @UID",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@Status", newStatus),
                        new System.Data.SqlClient.SqlParameter("@UID", targetID)
                    });
                LoadData();
            }
        }

        protected void CourseAction_Command(object sender, CommandEventArgs e)
        {
            if (e.CommandName == "ToggleCourse")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                int courseID = Convert.ToInt32(args[0]);
                string currentStatus = args[1];
                // Active <-> Draft (Archived is a separate action)
                string newStatus = currentStatus == "Active" ? "Draft" : "Active";
                DBHelper.ExecuteNonQuery("UPDATE Courses SET CourseStatus = @Status WHERE CourseID = @CID",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@Status", newStatus),
                        new System.Data.SqlClient.SqlParameter("@CID", courseID)
                    });
                LoadData();
            }
        }

        protected void InstructorAction_Command(object sender, CommandEventArgs e)
        {
            int targetID = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "ApproveInstructor")
            {
                DBHelper.ExecuteNonQuery("UPDATE Users SET AccountStatus = 'Active' WHERE UserID = @UID",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@UID", targetID)
                    });
                DBHelper.ExecuteNonQuery("UPDATE Instructor SET Status = 'approved' WHERE UserID = @UID",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@UID", targetID)
                    });
            }
            else if (e.CommandName == "RejectInstructor")
            {
                DBHelper.ExecuteNonQuery("UPDATE Instructor SET Status = 'rejected' WHERE UserID = @UID",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@UID", targetID)
                    });
                // Revert to Student role
                object studentRoleID = DBHelper.ExecuteScalar("SELECT RoleID FROM Roles WHERE RoleName = 'Student'");
                if (studentRoleID != null)
                {
                    DBHelper.ExecuteNonQuery("UPDATE Users SET RoleID = @RID, AccountStatus = 'Active' WHERE UserID = @UID",
                        new System.Data.SqlClient.SqlParameter[]
                        {
                            new System.Data.SqlClient.SqlParameter("@RID", Convert.ToInt32(studentRoleID)),
                            new System.Data.SqlClient.SqlParameter("@UID", targetID)
                        });
                }
            }
            LoadData();
        }
    }
}