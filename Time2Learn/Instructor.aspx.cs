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
            litAvgRating.Text = avgRating != null && avgRating != DBNull.Value ? Math.Round(Convert.ToDouble(avgRating), 1).ToString("0.0") : "—";

            object reviewCount = DBHelper.ExecuteScalar(@"SELECT COUNT(*) FROM Review rv INNER JOIN Courses c ON rv.CourseID = c.CourseID WHERE c.CreatedBy = @UID", new System.Data.SqlClient.SqlParameter[] {
                    new System.Data.SqlClient.SqlParameter("@UID", userID)
                });
            litReviewCount.Text = reviewCount?.ToString() ?? "0";

            // Overview courses (with student count and avg rating)
            DataTable overviewCourses = DBHelper.ExecuteQuery(@"SELECT c.CourseID, c.CourseTitle, c.CourseStatus, c.Price, c.DifficultyLevel, cat.CategoryName, COUNT(DISTINCT e.UserID) AS StudentCount, ISNULL(AVG(CAST(rv.Rating AS FLOAT)), 0) AS AvgRating FROM Courses c INNER JOIN Categories cat ON c.CategoryID = cat.CategoryID LEFT JOIN Enrollments e ON c.CourseID = e.CourseID LEFT JOIN Review rv ON c.CourseID = rv.CourseID WHERE c.CreatedBy = @UID GROUP BY c.CourseID, c.CourseTitle, c.CourseStatus, c.Price, c.DifficultyLevel, cat.CategoryName ORDER BY c.CourseID DESC",
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

            LoadCategories();
            LoadInstructorCourses();
            LoadSupportHistory();
            LoadProfile();
        }

        private void LoadInstructorCourses()
        {
            int userID = AuthHelper.GetUserID();
            DataTable courses = DBHelper.ExecuteQuery(
                "SELECT CourseID, CourseTitle FROM Courses WHERE CreatedBy = @UID ORDER BY CourseID DESC",
                new SqlParameter[] { new SqlParameter("@UID", userID) });

            string selectedVal = hdnUploadCourseID.Value;
            ddlUploadCourse.Items.Clear();
            ddlUploadCourse.Items.Add(new System.Web.UI.WebControls.ListItem("— Select a course —", "0"));
            foreach (DataRow r in courses.Rows)
                ddlUploadCourse.Items.Add(new System.Web.UI.WebControls.ListItem(r["CourseTitle"].ToString(), r["CourseID"].ToString()));

            if (!string.IsNullOrEmpty(selectedVal) && selectedVal != "0")
            {
                var item = ddlUploadCourse.Items.FindByValue(selectedVal);
                if (item != null) item.Selected = true;
            }

            int courseID = 0;
            int.TryParse(ddlUploadCourse.SelectedValue, out courseID);
            LoadLessons(courseID);
        }

        private void LoadLessons(int courseID)
        {
            if (courseID <= 0)
            {
                pnlNoLessons.Visible = true;
                litLessonCount.Text = "0";
                rptLessons.DataSource = null;
                rptLessons.DataBind();
                return;
            }

            DataTable lessons = DBHelper.ExecuteQuery(@"
                SELECT l.LessonID, l.LessonTitle, l.LessonOrder, l.LessonType,
                       lr.ResourceURL
                FROM Lessons l
                LEFT JOIN Lesson_Resources lr ON l.LessonID = lr.LessonID AND lr.ResourceType = 'Video'
                WHERE l.CourseID = @CID
                ORDER BY l.LessonOrder",
                new SqlParameter[] { new SqlParameter("@CID", courseID) });

            litLessonCount.Text = lessons.Rows.Count.ToString();
            pnlNoLessons.Visible = lessons.Rows.Count == 0;
            rptLessons.DataSource = lessons;
            rptLessons.DataBind();
        }

        private void LoadQuizQuestions(int lessonID)
        {
            DataTable questions = DBHelper.ExecuteQuery(
                "SELECT QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption FROM Quiz WHERE LessonID = @LID ORDER BY QuizID",
                new SqlParameter[] { new SqlParameter("@LID", lessonID) });
            pnlNoQuestions.Visible = questions.Rows.Count == 0;
            rptQuizQuestions.DataSource = questions;
            rptQuizQuestions.DataBind();
        }

        private void LoadSupportHistory()
        {
            int userID = AuthHelper.GetUserID();
            DataTable tickets = DBHelper.ExecuteQuery(
                "SELECT TicketID, Subject, TicketStatus, CreatedDate FROM Support_Tickets WHERE UserID = @UID ORDER BY CreatedDate DESC",
                new SqlParameter[] { new SqlParameter("@UID", userID) });
            pnlNoInstTickets.Visible = tickets.Rows.Count == 0;
            rptInstTickets.DataSource = tickets;
            rptInstTickets.DataBind();
        }

        protected string GetCorrectOptionText(object correct, object a, object b, object c, object d)
        {
            string key = correct?.ToString() ?? "";
            if (key == "A") return a?.ToString() ?? "";
            if (key == "B") return b?.ToString() ?? "";
            if (key == "C") return c?.ToString() ?? "";
            if (key == "D") return d?.ToString() ?? "";
            return "";
        }

        protected void ddlUploadCourse_SelectedIndexChanged(object sender, EventArgs e)
        {
            hdnUploadCourseID.Value = ddlUploadCourse.SelectedValue;
            pnlLessonForm.Visible = false;
            pnlQuizManager.Visible = false;
            hdnActiveSection.Value = "upload-material";
            LoadData();
        }

        protected void btnShowAddLesson_Click(object sender, EventArgs e)
        {
            hdnEditLessonID.Value = "0";
            litLessonFormTitle.Text = "Add Lesson";
            txtLessonTitle.Text = "";
            txtLessonOrder.Text = "";
            txtVideoURL.Text = "";
            ddlLessonType.SelectedIndex = 0;
            lblLessonMsg.Text = "";
            pnlLessonForm.Visible = true;
            pnlQuizManager.Visible = false;
            hdnActiveSection.Value = "upload-material";
        }

        protected void btnSaveLesson_Click(object sender, EventArgs e)
        {
            hdnActiveSection.Value = "upload-material";

            int courseID = 0;
            int.TryParse(hdnUploadCourseID.Value, out courseID);
            if (courseID <= 0)
            {
                lblLessonMsg.Text = "Select a course first.";
                lblLessonMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }

            string title = txtLessonTitle.Text.Trim();
            if (string.IsNullOrEmpty(title))
            {
                lblLessonMsg.Text = "Lesson title is required.";
                lblLessonMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }

            string lessonType = ddlLessonType.SelectedValue;
            int order = 1;
            int.TryParse(txtLessonOrder.Text.Trim(), out order);
            if (order <= 0) order = 1;
            string videoURL = txtVideoURL.Text.Trim();

            int editID = 0;
            int.TryParse(hdnEditLessonID.Value, out editID);

            if (editID <= 0)
            {
                // INSERT
                DBHelper.ExecuteNonQuery(
                    "INSERT INTO Lessons (CourseID, LessonTitle, LessonOrder, LessonType) VALUES (@CID, @Title, @Ord, @Type)",
                    new SqlParameter[] {
                        new SqlParameter("@CID", courseID),
                        new SqlParameter("@Title", title),
                        new SqlParameter("@Ord", order),
                        new SqlParameter("@Type", lessonType)
                    });

                object newID = DBHelper.ExecuteScalar("SELECT SCOPE_IDENTITY()");
                int lessonID = Convert.ToInt32(newID);

                if (lessonType == "Video" && !string.IsNullOrEmpty(videoURL))
                {
                    DBHelper.ExecuteNonQuery(
                        "INSERT INTO Lesson_Resources (LessonID, ResourceURL, ResourceType) VALUES (@LID, @URL, 'Video')",
                        new SqlParameter[] {
                            new SqlParameter("@LID", lessonID),
                            new SqlParameter("@URL", videoURL)
                        });
                }
            }
            else
            {
                // UPDATE
                DBHelper.ExecuteNonQuery(
                    "UPDATE Lessons SET LessonTitle = @Title, LessonOrder = @Ord, LessonType = @Type WHERE LessonID = @LID",
                    new SqlParameter[] {
                        new SqlParameter("@Title", title),
                        new SqlParameter("@Ord", order),
                        new SqlParameter("@Type", lessonType),
                        new SqlParameter("@LID", editID)
                    });

                if (lessonType == "Video")
                {
                    object existing = DBHelper.ExecuteScalar(
                        "SELECT COUNT(*) FROM Lesson_Resources WHERE LessonID = @LID AND ResourceType = 'Video'",
                        new SqlParameter[] { new SqlParameter("@LID", editID) });

                    if (Convert.ToInt32(existing) > 0)
                    {
                        DBHelper.ExecuteNonQuery(
                            "UPDATE Lesson_Resources SET ResourceURL = @URL WHERE LessonID = @LID AND ResourceType = 'Video'",
                            new SqlParameter[] {
                                new SqlParameter("@URL", videoURL),
                                new SqlParameter("@LID", editID)
                            });
                    }
                    else if (!string.IsNullOrEmpty(videoURL))
                    {
                        DBHelper.ExecuteNonQuery(
                            "INSERT INTO Lesson_Resources (LessonID, ResourceURL, ResourceType) VALUES (@LID, @URL, 'Video')",
                            new SqlParameter[] {
                                new SqlParameter("@LID", editID),
                                new SqlParameter("@URL", videoURL)
                            });
                    }
                }
                else
                {
                    // Not video — remove any existing video resource
                    DBHelper.ExecuteNonQuery(
                        "DELETE FROM Lesson_Resources WHERE LessonID = @LID AND ResourceType = 'Video'",
                        new SqlParameter[] { new SqlParameter("@LID", editID) });
                }
            }

            pnlLessonForm.Visible = false;
            lblLessonMsg.Text = "";
            LoadData();
        }

        protected void btnCancelLesson_Click(object sender, EventArgs e)
        {
            pnlLessonForm.Visible = false;
            hdnActiveSection.Value = "upload-material";
            LoadData();
        }

        protected void LessonAction_Command(object sender, CommandEventArgs e)
        {
            hdnActiveSection.Value = "upload-material";

            if (e.CommandName == "EditLesson")
            {
                int lessonID = Convert.ToInt32(e.CommandArgument);
                DataTable lesson = DBHelper.ExecuteQuery(
                    "SELECT LessonTitle, LessonOrder, LessonType FROM Lessons WHERE LessonID = @LID",
                    new SqlParameter[] { new SqlParameter("@LID", lessonID) });

                if (lesson.Rows.Count > 0)
                {
                    DataRow r = lesson.Rows[0];
                    hdnEditLessonID.Value = lessonID.ToString();
                    litLessonFormTitle.Text = "Edit Lesson";
                    txtLessonTitle.Text = r["LessonTitle"].ToString();
                    txtLessonOrder.Text = r["LessonOrder"].ToString();
                    ddlLessonType.SelectedValue = r["LessonType"].ToString();

                    object url = DBHelper.ExecuteScalar(
                        "SELECT ResourceURL FROM Lesson_Resources WHERE LessonID = @LID AND ResourceType = 'Video'",
                        new SqlParameter[] { new SqlParameter("@LID", lessonID) });
                    txtVideoURL.Text = url != null && url != DBNull.Value ? url.ToString() : "";

                    lblLessonMsg.Text = "";
                    pnlLessonForm.Visible = true;
                    pnlQuizManager.Visible = false;
                }
            }
            else if (e.CommandName == "DeleteLesson")
            {
                int lessonID = Convert.ToInt32(e.CommandArgument);
                DBHelper.ExecuteNonQuery(
                    "DELETE FROM Quiz WHERE LessonID = @LID",
                    new SqlParameter[] { new SqlParameter("@LID", lessonID) });
                DBHelper.ExecuteNonQuery(
                    "DELETE FROM Lesson_Resources WHERE LessonID = @LID",
                    new SqlParameter[] { new SqlParameter("@LID", lessonID) });
                DBHelper.ExecuteNonQuery(
                    "DELETE FROM Lessons WHERE LessonID = @LID",
                    new SqlParameter[] { new SqlParameter("@LID", lessonID) });
                pnlLessonForm.Visible = false;
                pnlQuizManager.Visible = false;
                LoadData();
            }
            else if (e.CommandName == "ManageQuiz")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                int lessonID = Convert.ToInt32(args[0]);
                string lessonTitle = args.Length > 1 ? args[1] : "";
                hdnEditQuizLessonID.Value = lessonID.ToString();
                litQuizLessonTitle.Text = lessonTitle;
                txtQuizQuestion.Text = "";
                txtOptA.Text = "";
                txtOptB.Text = "";
                txtOptC.Text = "";
                txtOptD.Text = "";
                ddlCorrectOpt.SelectedIndex = 0;
                lblQuizMsg.Text = "";
                pnlQuizManager.Visible = true;
                pnlLessonForm.Visible = false;
                LoadQuizQuestions(lessonID);
            }
        }

        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            hdnActiveSection.Value = "upload-material";

            int lessonID = 0;
            int.TryParse(hdnEditQuizLessonID.Value, out lessonID);
            if (lessonID <= 0) return;

            string question = txtQuizQuestion.Text.Trim();
            string optA = txtOptA.Text.Trim();
            string optB = txtOptB.Text.Trim();
            string optC = txtOptC.Text.Trim();
            string optD = txtOptD.Text.Trim();
            string correct = ddlCorrectOpt.SelectedValue;

            if (string.IsNullOrEmpty(question) || string.IsNullOrEmpty(optA) ||
                string.IsNullOrEmpty(optB) || string.IsNullOrEmpty(optC) || string.IsNullOrEmpty(optD))
            {
                lblQuizMsg.Text = "Fill in all fields.";
                lblQuizMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }

            DBHelper.ExecuteNonQuery(
                "INSERT INTO Quiz (LessonID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption) VALUES (@LID, @Q, @A, @B, @C, @D, @Cor)",
                new SqlParameter[] {
                    new SqlParameter("@LID", lessonID),
                    new SqlParameter("@Q", question),
                    new SqlParameter("@A", optA),
                    new SqlParameter("@B", optB),
                    new SqlParameter("@C", optC),
                    new SqlParameter("@D", optD),
                    new SqlParameter("@Cor", correct)
                });

            txtQuizQuestion.Text = "";
            txtOptA.Text = "";
            txtOptB.Text = "";
            txtOptC.Text = "";
            txtOptD.Text = "";
            ddlCorrectOpt.SelectedIndex = 0;
            lblQuizMsg.Text = "✓ Question added.";
            lblQuizMsg.ForeColor = System.Drawing.Color.Green;

            LoadQuizQuestions(lessonID);
            // Keep quiz manager open and re-bind lessons
            int courseID = 0;
            int.TryParse(hdnUploadCourseID.Value, out courseID);
            LoadLessons(courseID);
        }

        protected void QuizAction_Command(object sender, CommandEventArgs e)
        {
            hdnActiveSection.Value = "upload-material";

            if (e.CommandName == "DeleteQ")
            {
                int quizID = Convert.ToInt32(e.CommandArgument);
                DBHelper.ExecuteNonQuery(
                    "DELETE FROM Quiz WHERE QuizID = @QID",
                    new SqlParameter[] { new SqlParameter("@QID", quizID) });

                int lessonID = 0;
                int.TryParse(hdnEditQuizLessonID.Value, out lessonID);
                LoadQuizQuestions(lessonID);
                int courseID = 0;
                int.TryParse(hdnUploadCourseID.Value, out courseID);
                LoadLessons(courseID);
            }
        }

        protected void btnCloseQuiz_Click(object sender, EventArgs e)
        {
            pnlQuizManager.Visible = false;
            hdnActiveSection.Value = "upload-material";
            LoadData();
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

        private void LoadCategories()
        {
            DataTable cats = DBHelper.ExecuteQuery(
                "SELECT CategoryID, CategoryName FROM Categories ORDER BY CategoryName", null);
            string selected = ddlCourseCategory.SelectedValue;
            ddlCourseCategory.Items.Clear();
            ddlCourseCategory.Items.Add(new System.Web.UI.WebControls.ListItem("— Select —", ""));
            foreach (DataRow r in cats.Rows)
                ddlCourseCategory.Items.Add(new System.Web.UI.WebControls.ListItem(r["CategoryName"].ToString(), r["CategoryID"].ToString()));
            if (!string.IsNullOrEmpty(selected) && ddlCourseCategory.Items.FindByValue(selected) != null)
                ddlCourseCategory.SelectedValue = selected;
        }

        private void OpenCourseModal(int courseID = 0)
        {
            LoadCategories();
            hdnEditCourseID.Value = courseID.ToString();
            hdnShowCourseModal.Value = "true";
            hdnActiveSection.Value = "my-courses";

            if (courseID > 0)
            {
                DataTable c = DBHelper.ExecuteQuery(
                    "SELECT CourseTitle, CategoryID, DifficultyLevel, Price, CourseDescription, CourseStatus FROM Courses WHERE CourseID = @CID",
                    new SqlParameter[] { new SqlParameter("@CID", courseID) });
                if (c.Rows.Count > 0)
                {
                    DataRow r = c.Rows[0];
                    txtCourseTitle.Text = r["CourseTitle"].ToString();
                    txtCoursePrice.Text = r["Price"].ToString();
                    txtCourseDesc.Text = r["CourseDescription"].ToString();

                    string catVal = r["CategoryID"].ToString();
                    if (ddlCourseCategory.Items.FindByValue(catVal) != null)
                        ddlCourseCategory.SelectedValue = catVal;

                    string lvlVal = r["DifficultyLevel"].ToString();
                    if (ddlCourseLevel.Items.FindByValue(lvlVal) != null)
                        ddlCourseLevel.SelectedValue = lvlVal;

                    string stVal = r["CourseStatus"].ToString();
                    if (ddlCourseStatus.Items.FindByValue(stVal) != null)
                        ddlCourseStatus.SelectedValue = stVal;
                }
            }
            else
            {
                txtCourseTitle.Text = "";
                txtCoursePrice.Text = "0";
                txtCourseDesc.Text = "";
                ddlCourseStatus.SelectedIndex = 0; // Draft
            }
        }

        protected void btnShowAddCourse_Click(object sender, EventArgs e)
        {
            lblCourseMsg.Visible = false;
            OpenCourseModal(0);
            LoadData();
        }

        protected void CourseAction_Command(object sender, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            int courseID = 0;
            int.TryParse(e.CommandArgument.ToString(), out courseID);

            if (e.CommandName == "EditCourse")
            {
                lblCourseMsg.Visible = false;
                OpenCourseModal(courseID);
                LoadData();
            }
            else if (e.CommandName == "DeleteCourse")
            {
                int userID = AuthHelper.GetUserID();
                // Verify ownership before delete
                object own = DBHelper.ExecuteScalar(
                    "SELECT CourseID FROM Courses WHERE CourseID = @CID AND CreatedBy = @UID",
                    new SqlParameter[] {
                        new SqlParameter("@CID", courseID),
                        new SqlParameter("@UID", userID)
                    });
                if (own != null)
                {
                    // Cascade: Quiz → Lesson_Resources → Lessons → Courses
                    DBHelper.ExecuteNonQuery(
                        "DELETE q FROM Quiz q INNER JOIN Lessons l ON q.LessonID = l.LessonID WHERE l.CourseID = @CID",
                        new SqlParameter[] { new SqlParameter("@CID", courseID) });
                    DBHelper.ExecuteNonQuery(
                        "DELETE lr FROM Lesson_Resources lr INNER JOIN Lessons l ON lr.LessonID = l.LessonID WHERE l.CourseID = @CID",
                        new SqlParameter[] { new SqlParameter("@CID", courseID) });
                    DBHelper.ExecuteNonQuery(
                        "DELETE FROM Lessons WHERE CourseID = @CID",
                        new SqlParameter[] { new SqlParameter("@CID", courseID) });
                    DBHelper.ExecuteNonQuery(
                        "DELETE FROM Enrollments WHERE CourseID = @CID",
                        new SqlParameter[] { new SqlParameter("@CID", courseID) });
                    DBHelper.ExecuteNonQuery(
                        "DELETE FROM Review WHERE CourseID = @CID",
                        new SqlParameter[] { new SqlParameter("@CID", courseID) });
                    DBHelper.ExecuteNonQuery(
                        "DELETE FROM Courses WHERE CourseID = @CID AND CreatedBy = @UID",
                        new SqlParameter[] {
                            new SqlParameter("@CID", courseID),
                            new SqlParameter("@UID", userID)
                        });
                }
                hdnActiveSection.Value = "my-courses";
                LoadData();
            }
        }

        protected void btnSaveCourse_Click(object sender, EventArgs e)
        {
            string title = txtCourseTitle.Text.Trim();
            string catID = ddlCourseCategory.SelectedValue;
            string level = ddlCourseLevel.SelectedValue;
            string priceStr = txtCoursePrice.Text.Trim();
            string desc = txtCourseDesc.Text.Trim();
            string status = ddlCourseStatus.SelectedValue;

            hdnShowCourseModal.Value = "true";
            hdnActiveSection.Value = "my-courses";

            if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(catID))
            {
                lblCourseMsg.Text = "Course Title and Category are required.";
                lblCourseMsg.Visible = true;
                LoadCategories();
                LoadData();
                return;
            }

            decimal price = 0;
            decimal.TryParse(priceStr, out price);

            int courseID = 0;
            int.TryParse(hdnEditCourseID.Value, out courseID);
            int userID = AuthHelper.GetUserID();

            if (courseID == 0)
            {
                // INSERT
                DBHelper.ExecuteNonQuery(@"
                    INSERT INTO Courses (CourseTitle, CategoryID, DifficultyLevel, Price, CourseDescription, CourseStatus, CreatedBy)
                    VALUES (@Title, @CatID, @Level, @Price, @Desc, @Status, @UID)",
                    new SqlParameter[] {
                        new SqlParameter("@Title",  title),
                        new SqlParameter("@CatID",  int.Parse(catID)),
                        new SqlParameter("@Level",  level),
                        new SqlParameter("@Price",  price),
                        new SqlParameter("@Desc",   desc),
                        new SqlParameter("@Status", status),
                        new SqlParameter("@UID",    userID)
                    });
            }
            else
            {
                // UPDATE — verify ownership
                object own = DBHelper.ExecuteScalar(
                    "SELECT CourseID FROM Courses WHERE CourseID = @CID AND CreatedBy = @UID",
                    new SqlParameter[] {
                        new SqlParameter("@CID", courseID),
                        new SqlParameter("@UID", userID)
                    });
                if (own == null)
                {
                    lblCourseMsg.Text = "You do not own this course.";
                    lblCourseMsg.Visible = true;
                    LoadData();
                    return;
                }
                DBHelper.ExecuteNonQuery(@"
                    UPDATE Courses SET CourseTitle = @Title, CategoryID = @CatID, DifficultyLevel = @Level,
                        Price = @Price, CourseDescription = @Desc, CourseStatus = @Status
                    WHERE CourseID = @CID AND CreatedBy = @UID",
                    new SqlParameter[] {
                        new SqlParameter("@Title",  title),
                        new SqlParameter("@CatID",  int.Parse(catID)),
                        new SqlParameter("@Level",  level),
                        new SqlParameter("@Price",  price),
                        new SqlParameter("@Desc",   desc),
                        new SqlParameter("@Status", status),
                        new SqlParameter("@CID",    courseID),
                        new SqlParameter("@UID",    userID)
                    });
            }

            // Close modal after success
            hdnShowCourseModal.Value = "false";
            hdnEditCourseID.Value = "0";
            lblCourseMsg.Visible = false;
            LoadData();
        }

        protected void btnCancelCourse_Click(object sender, EventArgs e)
        {
            hdnShowCourseModal.Value = "false";
            hdnEditCourseID.Value = "0";
            lblCourseMsg.Visible = false;
            hdnActiveSection.Value = "my-courses";
            LoadData();
        }
    }
}
