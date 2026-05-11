using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Time2Learn.App_Code;
using static System.Runtime.CompilerServices.RuntimeHelpers;

namespace Time2Learn
{
    public partial class CurriculumLab : System.Web.UI.Page
    {
        private int _lessonID;
        private int _courseID;
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireLogin();

            if (!int.TryParse(Request.QueryString["lessonId"], out _lessonID) ||
                !int.TryParse(Request.QueryString["courseId"], out _courseID))
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

            DataTable lesson = DBHelper.ExecuteQuery("SELECT LessonTitle FROM Lessons WHERE LessonID = @LID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@LID", _lessonID)
                });
            if (lesson.Rows.Count == 0)
            {
                Response.Redirect("Courses.aspx");
                return;
            }

            litTitle.Text = lesson.Rows[0]["LessonTitle"].ToString();
            litCourseID.Text = _courseID.ToString();
            litCourseID2.Text = _courseID.ToString();

            DataTable course = DBHelper.ExecuteQuery("SELECT CourseTitle FROM Courses WHERE CourseID = @CID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@CID", _courseID)
                });
            if (course.Rows.Count > 0) litCourse.Text = course.Rows[0]["CourseTitle"].ToString();

            DataTable q = DBHelper.ExecuteQuery("SELECT TOP 1 QuestionPrompt FROM Question WHERE LessonID = @LID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@LID", _lessonID)
                });
            if (q.Rows.Count > 0)
                litInstructions.Text = q.Rows[0]["QuestionPrompt"].ToString();
            else
                litInstructions.Text = "Follow this lab instructions and complete the hands-on exercise.";

            pnlIO.Visible = false;
            pnlSteps.Visible = false;

            object done = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Lesson_Progress WHERE EnrollmentID = @EID AND LessonID = @LID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@EID", enrollmentID),
                    new System.Data.SqlClient.SqlParameter("@LID", _lessonID)
                });
            pnlCompleted.Visible = Convert.ToInt32(done) > 0;
        }

        protected void btnSubmitLab_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtSubmission.Text))
            {
                lblMsg.Text = "Please provide a submission beforee completing the lab.";
                lblMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }

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
                DBHelper.ExecuteNonQuery("INSERT INTO Lesson_Progress (EnrollmentID, LessonID, CompletedDate) VALUES (@EID, @LID, GETDATE())",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@EID", enrollmentID),
                        new System.Data.SqlClient.SqlParameter("@LID", _lessonID)
                    });
                RecalcProgress(enrollmentID);
            }

            lblMsg.Text = "Lab submitted! Marked as complete.";
            lblMsg.ForeColor = System.Drawing.Color.Green;
            pnlCompleted.Visible = true;
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