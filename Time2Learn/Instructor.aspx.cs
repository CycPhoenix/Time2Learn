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
    public partial class Instructor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole("Instructor");
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
                litAvatar.Text = r["Avatar"] != DBNull.Value ? r["Avatar"].ToString() : "I";
                litName.Text = r["FirstName"] + " " + r["LastName"];
                litWelcomeName.Text = r["FirstName"].ToString();
                litEmail.Text = r["Email"].ToString();
            }

            // Stats
            object courseCount = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Courses WHERE CreatedBy = @UID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID)
                });
            litCourseCount.Text = courseCount?.ToString() ?? "0";

            object studentCount = DBHelper.ExecuteScalar(@"SELECT COUNT(DISTINCT e.UserID) FROM Enrollments e INNER JOIN Courses c ON e.CourseID = c.CourseID WHERE c.CreatedBy = @UID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID)
                });
            litStudentCount.Text = studentCount?.ToString() ?? "0";

            object avgRating = DBHelper.ExecuteScalar(@"SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Review r INNER JOIN Courses c ON r.CourseID = c.CourseID WHERE c.CreatedBy = @UID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID)
                });
            litAvgRating.Text = avgRating != null && avgRating != DBNull.Value ? Math.Round(Convert.ToDouble(avgRating), 1).ToString("0.0") : "-";

            // Overview courses (with student count and avg rating)
            DataTable overviewCourses = DBHelper.ExecuteQuery(@"SELECT c.CourseID, c.CourseTitle, c.CourseStatus, c.Price, COUNT(DISTINCT e.UserID) AS StudentCount, ISNULL(AVG(CAST(rv.Rating AS FLOAT)), 0) AS AvgRating FROM Courses c LEFT JOIN Enrollments e ON c.CourseID = e.CourseID LEFT JOIN Review rv ON c.CourseID = rv.CourseID WHERE c.CreatedBy = @UID GROUP BY c.CourseID, c.CourseTitle, c.CourseStatus, c.Price ORDER BY c.CourseID DESC",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID)
                });
            rptOverviewCourses.DataSource = overviewCourses;
            rptOverviewCourses.DataBind();

            // My Courses full list
            DataTable myCourses = DBHelper.ExecuteQuery(@"SELECT c.CourseID, c.CourseTitle, c.CourseStatus, c.Price, c.DifficultyLevel, cat.CategoryName, COUNT(DISTINCT e.UserID) AS StudentCount FROM Courses c INNER JOIN Categories cat ON c.CategoryID = cat.CategoryID LEFT JOIN Enrollments e ON c.CourseID = e.CourseID WHERE c.CreatedBy = @UID GROUP BY c.CourseID, c.CourseTitle, c.CourseStatus, c.Price, c.DifficultyLevel, cat.CategoryName ORDER BY c.CourseID DESC",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID)
                });
            rptMyCourses.DataSource = myCourses;
            rptMyCourses.DataBind();

            // Students
            DataTable students = DBHelper.ExecuteQuery(@"SELECT u.FirstName, u.LastName, u.Email, c.CourseTitle, e.OverallProgressPercentage, e.EnrollDate FROM Enrollments e INNER JOIN Users u ON e.UserID = u.UserID INNER JOIN Courses c ON e.CourseID = c.CourseID WHERE c.CreatedBy = @UID ORDER BY e.EnrollDate DESC",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID)
                });
            pnlNoStudents.Visible = students.Rows.Count == 0;
            rptStudents.DataSource = students;
            rptStudents.DataBind();

            // Reviews
            DataTable reviews = DBHelper.ExecuteQuery(@"SELECT u.FirstName, u.LastName, c.CourseTitle, rv.Rating, rv.Comment, rv.ReviewDate FROM Review rv INNER JOIN Users u ON rv.UserID = u.UserID INNER JOIN Courses c ON rv.CourseID = c.CourseID WHERE c.CreatedBy = @UID ORDER BY rv.ReviewDate DESC",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID)
                });
            pnlNoReviews.Visible = reviews.Rows.Count == 0;
            rptReviews.DataSource = reviews;
            rptReviews.DataBind();
        }
    }
}