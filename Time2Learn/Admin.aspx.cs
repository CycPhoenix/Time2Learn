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