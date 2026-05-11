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
    public partial class Cart : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireLogin();
            if (!IsPostBack) LoadCart();
        }

        private void LoadCart()
        {
            int userID = AuthHelper.GetUserID();

            DataTable items = DBHelper.ExecuteQuery(@"SELECT c.CourseID, c.CourseTitle, c.Price, c.DifficultyLevel, cat.CategoryName FROM Cart ct INNER JOIN Courses c ON ct.CourseID = c.CourseID INNER JOIN Categories cat ON c.CategoryID = cat.CategoryID WHERE ct.UserID = @UID AND ct.CartStatus = @CS ORDER BY ct.CartID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID),
                    new System.Data.SqlClient.SqlParameter("@CS", "Active")
                });

            bool hasItems = items.Rows.Count > 0;
            pnlEmpty.Visible = !hasItems;
            pnlCart.Visible = hasItems;

            if (!hasItems) return;

            rptCart.DataSource = items;
            rptCart.DataBind();
            rptSummary.DataSource = items;
            rptSummary.DataBind();

            decimal total = 0;
            foreach (DataRow r in items.Rows)
                total += Convert.ToDecimal(r["Price"]);
            litTotal.Text = total.ToString("0.00");
        }

        protected void CartAction_Command(object sender, CommandEventArgs e)
        {
            if (e.CommandName == "Remove")
            {
                int userID = AuthHelper.GetUserID();
                int courseID = Convert.ToInt32(e.CommandArgument);
                DBHelper.ExecuteNonQuery("DELETE FROM Cart WHERE UserID = @UID AND CourseID = @CID",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@UID", userID),
                        new System.Data.SqlClient.SqlParameter("@CID", courseID)
                    });
                LoadCart();
            }
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            // Enroll user in all cart courses
            int userID = AuthHelper.GetUserID();

            DataTable items = DBHelper.ExecuteQuery("SELECT CourseID FROM Cart WHERE UserID = @UID AND CartStatus = @CS",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID),
                    new System.Data.SqlClient.SqlParameter("@CS", "Active")
                });

            foreach (DataRow r in items.Rows)
            {
                int courseID = Convert.ToInt32(r["CourseID"]);

                // Skip already enrolled
                object already = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Enrollments WHERE UserID = @UID AND CourseID = @CID",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@UID", userID),
                        new System.Data.SqlClient.SqlParameter("@CID", courseID)
                    });

                if (Convert.ToInt32(already) == 0)
                {
                    DBHelper.ExecuteNonQuery("INSERT INTO Enrollments (UserID, CourseID, EnrollDate, OverallProgressPercentage, Certificate) VALUES (@UID, @CID, GETDATE(), 0, '')",
                        new System.Data.SqlClient.SqlParameter[]
                        {
                            new System.Data.SqlClient.SqlParameter("@UID", userID),
                            new System.Data.SqlClient.SqlParameter("@CID", courseID)
                        });
                }
            }

            // Clear cart
            DBHelper.ExecuteNonQuery("DELETE FROM Cart WHERE UserID = @UID",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID)
                });
            Response.Redirect("Student.aspx");
        }
    }
}