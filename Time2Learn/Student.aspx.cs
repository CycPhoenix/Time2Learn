using System;
using System.Collections.Generic;
using System.Data;
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
                litAvgProgress.Text = Math.Round((double)stats.Rows[0]["AvgProgress"]).ToString();
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
        }
    }
}