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
    public partial class CourseDetail : System.Web.UI.Page
    {
        private int _courseID;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out _courseID))
            {
                Response.Redirect("Courses.aspx");
                return;
            }
            if (!IsPostBack) LoadData();
        }

        private void LoadData()
        {
            DataTable course = DBHelper.ExecuteQuery(@"SELECT c.CourseID, c.CourseTitle, c.CourseDescription, c.Price, c.DifficultyLevel, cat.CategoryName, u.FirstName + ' ' + u.LastName AS InstructorName, COUNT(DISTINCT e.UserID) AS EnrollCount, ISNULL(AVG(CAST(rv.Rating AS FLOAT)), 0) AS AvgRating FROM Courses c INNER JOIN Categories cat ON c.CategoryID = cat.CategoryID INNER JOIN Users u On c.CreatedBy = u.UserID LEFT JOIN Enrollments e ON c.CourseID = e.CourseID LEFT JOIN Review rv ON c.CourseID = rv.CourseID WHERE c.CourseID = @CID GROUP BY c.CourseID, c.CourseTitle, c.CourseDescription, c.Price, c.DifficultyLevel, cat.CategoryName, u.FirstName, u.LastName",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@CID", _courseID)
                });

            if (course.Rows.Count == 0)
            {
                Response.Redirect("Courses.aspx");
                return;
            }

            DataRow r = course.Rows[0];
            litTitle.Text = r["CourseTitle"].ToString();
            litDesc.Text = r["CourseDescription"].ToString();
            litCatName.Text = r["CategoryName"].ToString();
            litCatName2.Text = r["CategoryName"].ToString();
            litInstructor.Text = r["InstructorName"].ToString();
            litLevel.Text = r["DifficultyLevel"].ToString();
            litEnrollCount.Text = r["EnrollCount"].ToString();
            litPrice.Text = string.Format("{0:0.00}", r["Price"]);
            double avgRating = Convert.ToDouble(r["AvgRating"]);
            litRating.Text = avgRating > 0 ? avgRating.ToString("0.0") : "No ratings";

            // Enrolled check
            bool enrolled = false;
            if (AuthHelper.IsLoggedIn())
            {
                int userID = AuthHelper.GetUserID();
                object check = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Enrollments WHERE UserID = @UID AND CourseID = @CID",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@UID", userID),
                        new System.Data.SqlClient.SqlParameter("@CID", _courseID)
                    });
                enrolled = check != null && Convert.ToInt32(check) > 0;
            }

            pnlEnrolled.Visible = enrolled;
            pnlNotEnrolled.Visible = !enrolled;
            if (enrolled)
                aContinue.HRef = "LearningMaterial.aspx?id=" + _courseID;

            // Lessons
            DataTable lessons = DBHelper.ExecuteQuery("SELECT LessonTitle FROM Lessons WHERE CourseID = @CID ORDER BY LessonOrder",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@CID", _courseID)
                });
            litLessonCount.Text = lessons.Rows.Count.ToString();
            pnlNoLessons.Visible = lessons.Rows.Count == 0;
            rptLessons.DataSource = lessons;
            rptLessons.DataBind();

            // Reviews
            DataTable reviews = DBHelper.ExecuteQuery(@"SELECT u.FirstName, u.LastName, ISNULL(u.Avatar, '?') AS Avatar, rv.Rating, rv.Comment FROM Review rv INNER JOIN Users u ON rv.UserID = u.UserID WHERE rv.CourseID = @CID ORDER BY rv.ReviewDate DESC",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@CID", _courseID)
                });
            pnlNoReviews.Visible = reviews.Rows.Count == 0;
            rptReviews.DataSource = reviews;
            rptReviews.DataBind();
        }

        protected void btnAddCart_Click(object sender, EventArgs e)
        {
            if (!AuthHelper.IsLoggedIn())
            {
                Response.Redirect("Login.aspx");
                return;
            }
            int userID = AuthHelper.GetUserID();
            object exists = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Cart WHERE UserID = @UID AND CourseID = @CID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@uID", userID),
                    new System.Data.SqlClient.SqlParameter("@CID", _courseID)
                });
            if (Convert.ToInt32(exists) == 0)
            {
                DataTable ci = DBHelper.ExecuteQuery("SELECT CourseTitle, Price FROM Courses WHERE CourseID = @CID",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@CID", _courseID)
                    });
                if (ci.Rows.Count > 0)
                {
                    DBHelper.ExecuteNonQuery("INSERT INTO Cart (UserID, CourseID, CourseTitle, PriceAtAdded, AddedDate, CartStatus) VALUES (@UID, @CID, @Title, @Price, GETDATE(), 'Active')",
                        new System.Data.SqlClient.SqlParameter[]
                        {
                            new System.Data.SqlClient.SqlParameter("@UID", userID),
                            new System.Data.SqlClient.SqlParameter("@CID", _courseID),
                            new System.Data.SqlClient.SqlParameter("@Title", ci.Rows[0]["CourseTitle"].ToString()),
                            new System.Data.SqlClient.SqlParameter("@Price", Convert.ToDecimal(ci.Rows[0]["Price"]))
                        });
                    lblMsg.Text = "Added to cart!";
                    lblMsg.ForeColor = System.Drawing.Color.Green;
                }
            }
            else
            {
                lblMsg.Text = "Already in cart.";
                lblMsg.ForeColor = System.Drawing.Color.Gray;
            }
        }

        protected void btnEnrollNow_Click(object sender, EventArgs e)
        {
            if (!AuthHelper.IsLoggedIn())
            {
                Response.Redirect("Login.aspx");
                return;
            }
            Response.Redirect("CoursePayment.aspx?id=" + _courseID);
        }
    }
}