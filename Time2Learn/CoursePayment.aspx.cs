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
    public partial class CoursePayment : System.Web.UI.Page
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

            if (!IsPostBack) LoadData();
        }

        private void LoadData()
        {
            int userID = AuthHelper.GetUserID();

            DataTable course = DBHelper.ExecuteQuery(@"SELECT c.CourseTitle, c.Price, c.DifficultyLevel, cat.CategoryName FROM Courses c INNER JOIN Categories cat ON c.CategoryID = cat.CategoryID WHERE c.CourseID = @CID",
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
            decimal price = Convert.ToDecimal(r["Price"]);
            litTitle.Text = r["CourseTitle"].ToString();
            litMeta.Text = r["CategoryName"] + " · " + r["DifficultyLevel"];
            litPrice.Text = price.ToString("0.00");
            litTotal.Text = price.ToString("0.00");

            // Free course - hide card fields
            pnlFree.Visible = price == 0;
            pnlPaidFields.Visible = price > 0;

            // Already enrolled?
            object already = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Enrollments WHERE UserID = @UID AND CourseID = @CID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID),
                    new System.Data.SqlClient.SqlParameter("@CID", _courseID)
                });

            bool enrolled = Convert.ToInt32(already) > 0;
            pnlAlreadyEnrolled.Visible = enrolled;
            pnlPayForm.Visible = !enrolled;
        }

        protected void btnEnrol_Click(object sender, EventArgs e)
        {
            int userID = AuthHelper.GetUserID();

            // Guard double enroll
            object already = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Enrollments WHERE UserID = @UID AND CourseID = @CID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID),
                    new System.Data.SqlClient.SqlParameter("@CID", _courseID)
                });

            if (Convert.ToInt32(already) > 0)
            {
                lblMsg.Text = "Already enrolled.";
                lblMsg.ForeColor = System.Drawing.Color.Gray;
                return;
            }

            DBHelper.ExecuteNonQuery("INSERT INTO Enrollments (UserID, CourseID, EnrollDate, OverallProgressPercentage, Certificate) VALUES (@UID, @CID, GETDATE(), 0, ''",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID),
                    new System.Data.SqlClient.SqlParameter("@CID", _courseID)
                });

            // Remove from cart if present
            DBHelper.ExecuteNonQuery("DELETE FROM Cart WHERE UserID = @UID AND CourseID = @CID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID),
                    new System.Data.SqlClient.SqlParameter("@CID", _courseID)
                });

            Response.Redirect("LearningMaterial.aspx?id=" + _courseID);
        }
    }
}