using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.EnterpriseServices;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Time2Learn.App_Code;

namespace Time2Learn
{
    public partial class Student : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole("Student");
            if (!IsPostBack) LoadData();
        }

        private void LoadData()
        {
            int userID = AuthHelper.GetUserID();

            // User profile
            DataTable user = DBHelper.ExecuteQuery("SELECT Avatar, FirstName, LastName, Email FROM Users WHERE UserID = @UID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID)
                });
            if (user.Rows.Count > 0)
            {
                DataRow r = user.Rows[0];
                litAvatar.Text = r["Avatar"] != DBNull.Value ? r["Avatar"].ToString() : "?";
                litName.Text = r["FirstName"] + " " + r["LastName"];
                litWelcomeName.Text = r["FirstName"].ToString();
                litEmail.Text = r["Email"].ToString();
            }

            // Stats
            DataTable stats = DBHelper.ExecuteQuery("SELECT COUNT(*) AS EnrollCount, ISNULL(AVG(CAST(OverallProgressPercentage AS FLOAT)), 0) AS AvgProgress FROM Enrollments WHERE UserID = @UID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID)
                });

            if (stats.Rows.Count > 0)
            {
                litEnrollCount.Text = stats.Rows[0]["EnrollCount"].ToString();
                litAvgProgress.Text = Math.Round(Convert.ToDouble(stats.Rows[0]["AvgProgress"])).ToString();
            }

            // Certificates = completed courses (100%)
            object certCount = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Enrollments WHERE UserID = @UID AND OverallProgressPercentage = 100",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID)
                });
            litCertCount.Text = certCount != null ? certCount.ToString() : "0";

            // Open tickets count
            object ticketCount = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Support_Tickets WHERE UserID = @UID AND TicketStatus != @S1 AND TicketStatus != @S2",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID),
                    new System.Data.SqlClient.SqlParameter("@S1", "Resolved"),
                    new System.Data.SqlClient.SqlParameter("@S2", "Closed")
                });
            litTicketCount.Text = ticketCount != null ? ticketCount.ToString() : "0";

            // Continue learning (top 5 incomplete)
            DataTable cl = DBHelper.ExecuteQuery(@"SELECT TOP 5 e.CourseID, c.CourseTitle, e.EnrollDate, e.OverallProgressPercentage FROM Enrollments e INNER JOIN Courses c ON e.CourseID = c.CourseID WHERE e.UserID = @UID AND e.OverallProgressPercentage < 100 ORDER BY e.EnrollDate DESC",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID)
                });
            rptContinueLearning.DataSource = cl;
            rptContinueLearning.DataBind();

            // My Courses (all)
            DataTable mc = DBHelper.ExecuteQuery(@"SELECT e.CourseID, c.CourseTitle, cat.CategoryName, e.EnrollDate, e.OverallProgressPercentage FROM Enrollments e INNER JOIN Courses c ON e.CourseID = c.CourseID INNER JOIN Categories cat ON c.CategoryID = cat.CategoryID WHERE e.UserID = @UID ORDER BY e.EnrollDate DESC",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID)
                });
            rptMyCourses.DataSource = mc;
            rptMyCourses.DataBind();

            // Tickets
            DataTable tickets = DBHelper.ExecuteQuery(@"SELECT TicketID, Subject, TicketStatus, CreatedDate FROM Support_Tickets WHERE UserID = @UID ORDER BY CreatedDate DESC",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID)
                });
            rptTickets.DataSource = tickets;
            rptTickets.DataBind();
            pnlNoTickets.Visible = tickets.Rows.Count == 0;

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
    }
}