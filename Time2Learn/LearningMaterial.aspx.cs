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
    public partial class LearningMaterial : System.Web.UI.Page
    {
        private int _courseID;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireLogin();

            if (!int.TryParse(Request.QueryString["id"], out _courseID))
            {
                Response.Redirect("Courses.aspx");
                return;
            }

            int userID = AuthHelper.GetUserID();
            object enrolled = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Enrollments WHERE UserID = @UID AND CourseID = @CID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID),
                    new System.Data.SqlClient.SqlParameter("@CID", _courseID)
                });
            if (Convert.ToInt32(enrolled) == 0)
            {
                Response.Redirect("CourseDetail.aspx?id=" + _courseID);
                return;
            }

            if (!IsPostBack) LoadData();
        }

        private void LoadData()
        {
            int userID = AuthHelper.GetUserID();

            // Get EnrollmentID from Lesson_Progress queries
            object eidObj = DBHelper.ExecuteScalar("SELECT EnrollmentID FROM Enrollments WHERE UserID = @UID AND CourseID = @CID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID),
                    new System.Data.SqlClient.SqlParameter("@CID", _courseID)
                });
            int enrollmentID = eidObj != null ? Convert.ToInt32(eidObj) : 0;

            DataTable course = DBHelper.ExecuteQuery(@"SELECT c.CourseTitle, c.DifficultyLevel, cat.CategoryName, e.OverallProgressPercentage FROM Courses c INNER JOIN Categories cat ON c.CategoryID = cat.CategoryID INNER JOIN Enrollments e ON c.CourseID = e.CourseID AND e.UserID = @UID WHERE c.CourseID = @CID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID),
                    new System.Data.SqlClient.SqlParameter("@CID", _courseID)
                });

            if (course.Rows.Count == 0)
            {
                Response.Redirect("Courses.aspx");
                return;
            }

            DataRow r = course.Rows[0];
            string title = r["CourseTitle"].ToString();
            int pct = Convert.ToInt32(r["OverallProgressPercentage"]);

            litCourseTitle.Text = title;
            litSidebarTitle.Text = title;
            litCourseMeta.Text = r["CategoryName"] + " · " + r["DifficultyLevel"];
            litSidebarPct.Text = pct.ToString();
            litSidebarPctStyle.Text = pct.ToString();
            litProgressPct.Text = pct.ToString();

            DataTable lessons = DBHelper.ExecuteQuery(@"SELECT l.LessonID, l.LessonTitle, l.LessonOrder, l.LessonType, ISNULL((SELECT TOP 1 1 FROM Lesson_Progress lp WHERE lp.LessonID = l.LessonID AND lp.EnrollmentID = @EID), 0) AS IsCompleted FROM Lessons l WHERE l.CourseID = @CID ORDER BY l.LessonOrder",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@EID", enrollmentID),
                    new System.Data.SqlClient.SqlParameter("@CID", _courseID)
                });

            int total = lessons.Rows.Count;
            int done = 0;
            foreach (DataRow lr in lessons.Rows)
                if (Convert.ToInt32(lr["IsCompleted"]) == 1) done++;

            litLessonTotal.Text = total.ToString();
            litLessonDone.Text = done.ToString();

            rptLessons.DataSource = lessons;
            rptLessons.DataBind();
            rptSidebarLessons.DataSource = lessons;
            rptSidebarLessons.DataBind();

            if (total > 0)
            {
                int newPct = (int)Math.Round((double)done / total * 100);
                DBHelper.ExecuteNonQuery("UPDATE Enrollments SET OverallProgressPercentage = @Pct WHERE EnrollmentID = @EID",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@Pct", newPct),
                        new System.Data.SqlClient.SqlParameter("@EID", enrollmentID)
                    });
                litProgressPct.Text = newPct.ToString();
                litSidebarPct.Text = newPct.ToString();
                litSidebarPctStyle.Text = newPct.ToString();
            }
        }

        protected string GetLessonUrl(object lessonID, object lessonType)
        {
            string type = lessonType != null ? lessonType.ToString() : "Video";
            string page;
            switch (type)
            {
                case "Quiz":
                    page = "CurriculumQuiz.aspx";
                    break;
                case "Coding":
                    page = "CurriculumCoding.aspx";
                    break;
                case "Lab":
                    page = "CurriculumLab.aspx";
                    break;
                default:
                    page = "CurriculumVideo.aspx";
                    break;
            }
            return page + "?lessonId=" + lessonID + "&courseID=" + _courseID;
        }
    }
}