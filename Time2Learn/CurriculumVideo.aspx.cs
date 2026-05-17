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
    public partial class CurriculumVideo : System.Web.UI.Page
    {
        private int _lessonID;
        private int _courseID;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireLogin();

            if (!int.TryParse(Request.QueryString["lessonId"], out _lessonID) || !int.TryParse(Request.QueryString["courseId"], out _courseID))
            {
                Response.Redirect("Courses.aspx");
                return;
            }

            if (!IsPostBack) LoadData();
        }

        private int GetEnrollmentID(int userID)
        {
            object eid = DBHelper.ExecuteScalar("SELECT EnrollmentID FROM Enrollments WHERE UserID = @UID AND CourseID = @CID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID),
                    new System.Data.SqlClient.SqlParameter("@CID", _courseID)
                });
            return eid != null ? Convert.ToInt32(eid) : 0;
        }

        private void LoadData()
        {
            int userID = AuthHelper.GetUserID();
            int enrollmentID = GetEnrollmentID(userID);

            DataTable lesson = DBHelper.ExecuteQuery(@"SELECT l.LessonID, l.LessonTitle, l.LessonOrder, c.CourseID, c.CourseTitle FROM Lessons l INNER JOIN Courses c ON l.CourseID = c.CourseID WHERE l.LessonID = @LID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@LID", _lessonID)
                });

            if (lesson.Rows.Count == 0)
            {
                Response.Redirect("Courses.aspx");
                return;
            }

            DataRow r = lesson.Rows[0];
            litTitle.Text = r["LessonTitle"].ToString();
            litLessonTitle.Text = r["LessonTitle"].ToString();
            litCourse.Text = r["CourseTitle"].ToString();
            litCourseName.Text = r["CourseTitle"].ToString();
            litCourseID.Text = _courseID.ToString();
            litContent.Text = "Watch the video above to learn this topic.";

            // Video URL from resources
            DataTable video = DBHelper.ExecuteQuery(@"SELECT TOP 1 ResourceURL FROM Lesson_Resources WHERE LessonID =  @LID AND ResourceType = 'Video'",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@LID", _lessonID)
                });
            if (video.Rows.Count > 0)
            {
                string videoSrc = video.Rows[0]["ResourceURL"].ToString();
                litVideoUrl.Text = "<source src=\"" + videoSrc + "\" type=\"video/mp4\" />";
                pnlVideo.Visible = true;
                pnlPlaceholder.Visible = false;
            }

            // Additional resources (links)
            DataTable resources = DBHelper.ExecuteQuery(@"SELECT ResourceURL, AdditionalContent FROM Lesson_Resources WHERE LessonID = @LID AND ResourceType = 'Link'",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@LID", _lessonID)
                });
            pnlResources.Visible = resources.Rows.Count > 0;
            rptResources.DataSource = resources;
            rptResources.DataBind();

            // Completion status
            object completed = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Lesson_Progress WHERE EnrollmentID = @EID AND LessonID = @LID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@EID", enrollmentID),
                    new System.Data.SqlClient.SqlParameter("@LID", _lessonID)
                });
            bool isCompleted = Convert.ToInt32(completed) > 0;
            pnlCompleted.Visible = isCompleted;
            btnComplete.Visible = !isCompleted;

            int order = Convert.ToInt32(r["LessonOrder"]);

            DataTable prev = DBHelper.ExecuteQuery(@"SELECT TOP 1 LessonID, LessonType FROM Lessons WHERE CourseID = @CID AND LessonOrder < @Order ORDER BY LessonOrder DESC",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@CID", _courseID),
                    new System.Data.SqlClient.SqlParameter("@Order", order)
                });
            lnkPrev.NavigateUrl = prev.Rows.Count > 0 ? GetLessonPage(prev.Rows[0]["LessonType"].ToString()) + "?lessonId=" + prev.Rows[0]["LessonID"] + "&courseId=" + _courseID : "LearningMaterial.aspx?id=" + _courseID;

            DataTable next = DBHelper.ExecuteQuery(@"SELECT TOP 1 LessonID, LessonType FROM Lessons WHERE CourseID = @CID AND LessonOrder > @Order ORDER BY LessonOrder ASC",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@CID", _courseID),
                    new System.Data.SqlClient.SqlParameter("@Order", order)
                });
            lnkNext.NavigateUrl = next.Rows.Count > 0 ? GetLessonPage(next.Rows[0]["LessonType"].ToString()) + "?lessonId=" + next.Rows[0]["LessonID"] + "&courseId=" + _courseID : "LearningMaterial.aspx?id=" + _courseID;
        }

        protected void btnComplete_Click(object sender, EventArgs e)
        {
            int userID = AuthHelper.GetUserID();
            int enrollmentID = GetEnrollmentID(userID);

            object exists = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Lesson_Progress WHERE EnrollmentID = @EID AND LessonID = @LID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@EID", enrollmentID),
                    new System.Data.SqlClient.SqlParameter("@LID", _lessonID)
                });

            if (Convert.ToInt32(exists) == 0)
            {
                DBHelper.ExecuteNonQuery("INSERT INTO Lesson_Progress (EnrollmentID, LessonID, CompletedDate, IsCompleted) VALUES (@EID, @LID, GETDATE(), 1)",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@EID", enrollmentID),
                        new System.Data.SqlClient.SqlParameter("@LID", _lessonID)
                    });

                RecalcProgress(enrollmentID);
            }

            LoadData();
        }

        private string GetLessonPage(string lessonType)
        {
            switch (lessonType)
            {
                case "Quiz":
                    return "CurriculumQuiz.aspx";
                case "Coding":
                    return "CurriculumCoding.aspx";
                case "Lab":
                    return "CurriculumLab.aspx";
                default:
                    return "CurriculumVideo.aspx";
            }
        }

        private void RecalcProgress(int enrollmentID)
        {
            object total = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Lessons WHERE CourseID = @CID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@CID", _courseID)
                });
            object done = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Lesson_Progress WHERE EnrollmentID = @EID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@EID", enrollmentID)
                });

            int t = Convert.ToInt32(total);
            if (t == 0) return;
            int pct = (int)Math.Round((double)Convert.ToInt32(done) / t * 100);
            DBHelper.ExecuteNonQuery("UPDATE Enrollments SET OverallProgressPercentage = @Pct WHERE EnrollmentID = @EID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@Pct", pct),
                    new System.Data.SqlClient.SqlParameter("@EID", enrollmentID)
                });
        }
    }
}
