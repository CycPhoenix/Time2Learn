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
    public partial class CurriculumQuiz : System.Web.UI.Page
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
            litSubtitle.Text = "Answer all questions to complete this quiz.";
            litCourseID.Text = _courseID.ToString();
            litCourseID2.Text = _courseID.ToString();
            litCourseID3.Text = _courseID.ToString();

            object done = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Lesson_Progress WHERE EnrollmentID = @EID AND LessonID = @LID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@EID", enrollmentID),
                    new System.Data.SqlClient.SqlParameter("@LID", _lessonID)
                });
            if (Convert.ToInt32(done) > 0)
            {
                pnlAlreadyPassed.Visible = true;
                pnlQuiz.Visible = false;
                return;
            }

            DataTable questions = DBHelper.ExecuteQuery("SELECT QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD FROM Quiz WHERE LessonID = @LID ORDER BY QuizID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@LID", _lessonID)
                });

            litQCount.Text = questions.Rows.Count.ToString();
            rptQuestions.DataSource = questions;
            rptQuestions.DataBind();
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int userID = AuthHelper.GetUserID();
            int enrollmentID = GetEnrollmentID(userID);
            string answersRaw = hdnAnswers.Value;

            DataTable questions = DBHelper.ExecuteQuery("SELECT QuizID, CorrectOption FROM Quiz WHERE LessonID = @LID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@LID", _lessonID)
                });

            if (questions.Rows.Count == 0)
            {
                MarkComplete(enrollmentID, 100);
                ShowResult(100);
                return;
            }

            var userAnswers = new Dictionary<int, string>();
            if (!string.IsNullOrEmpty(answersRaw))
            {
                foreach (string pair in answersRaw.Split(','))
                {
                    string[] parts = pair.Split(':');
                    if (parts.Length == 2 && int.TryParse(parts[0], out int qid))
                        userAnswers[qid] = parts[1];
                }
            }

            int correct = 0;
            foreach (DataRow r in questions.Rows)
            {
                int quizID = Convert.ToInt32(r["QuizID"]);
                string correctAns = r["CorrectOption"].ToString();
                if (userAnswers.ContainsKey(quizID) && userAnswers[quizID] == correctAns)
                    correct++;
            }

            int score = (int)Math.Round((double)correct / questions.Rows.Count * 100);

            if (score >= 60)
                MarkComplete(enrollmentID, score);

            ShowResult(score);
        }

        private void MarkComplete(int enrollmentID, int score)
        {
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

        private void ShowResult(int score)
        {
            pnlQuiz.Visible = false;
            pnlResult.Visible = true;
            litCourseID3.Text = _courseID.ToString();

            bool passed = score >= 60;
            pnlPass.Visible = passed;
            pnlFail.Visible = !passed;
            btnRetry.Visible = !passed;

            if (passed) litScore.Text = score.ToString();
            else litScoreFail.Text = score.ToString();
        }

        protected void btnRetry_Click(object sender, EventArgs e)
        {
            pnlResult.Visible = false;
            pnlQuiz.Visible = true;
            LoadData();
        }
    }
}