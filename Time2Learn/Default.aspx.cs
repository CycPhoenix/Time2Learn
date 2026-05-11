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
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) LoadData();
        }

        private void LoadData()
        {
            object courseCount = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Courses WHERE CourseStatus = 'Active'");
            object studentCount = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Users u INNER JOIN Roles r ON u.RoleID = r.RoleID WHERE r.RoleName = 'Student'");
            object instructorCount = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Users u INNER JOIN Roles r ON u.RoleID = r.RoleID WHERE r.RoleName = 'Instructor' AND u.AccountStatus = 'Active'");

            litCourseCount.Text = courseCount.ToString() ?? "0";
            litStudentCount.Text = studentCount.ToString() ?? "0";
            litInstructorCount.Text = instructorCount.ToString() ?? "0";

            DataTable featured = DBHelper.ExecuteQuery(@"SELECT TOP 6 c.CourseID, c.CourseTitle, c.Price, c.DifficultyLevel, cat.CategoryName, u.FirstName + ' ' + u.LastName AS InstructorName FROM Courses c INNER JOIN Categories cat ON c.CategoryID = cat.CategoryID INNER JOIN Users u ON c.CreatedBy = u.UserID WHERE c.CourseStatus = 'Active' ORDER BY c.CourseID DESC");
            rptFeatured.DataSource = featured;
            rptFeatured.DataBind();

            DataTable cats = DBHelper.ExecuteQuery(@"SELECT cat.CategoryID, cat.CategoryName, COUNT(c.CourseID) AS CourseCount FROM Categories cat LEFT JOIN Courses c ON cat.CategoryID = c.CategoryID AND c.CourseStatus = 'Active' GROUP BY cat.CategoryID, cat.CategoryName ORDER BY CourseCount DESC");
            rptCategories.DataSource = cats;
            rptCategories.DataBind();
        }
    }
}