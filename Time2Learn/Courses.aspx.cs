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
    public partial class Courses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadCategories();
            string catParam = Request.QueryString["cat"];
            if (!string.IsNullOrEmpty(catParam)) hdnCatID.Value = catParam;
            LoadCourses();
        }

        private void LoadCategories()
        {
            DataTable cats = DBHelper.ExecuteQuery("SELECT CategoryID, CategoryName FROM Categories ORDER BY CategoryName");
            rptCatFilter.DataSource = cats;
            rptCatFilter.DataBind();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadCourses();
        }

        private void LoadCourses()
        {
            string search = txtSearch.Text.Trim();
            string catID = hdnCatID.Value;
            string level = hdnLevel.Value;

            string sql = @"SELECT c.CourseId, c.CourseTitle, c.Price, c.DifficultyLevel, cat.CategoryName, u.FirstName + ' ' + u.LastName AS InstructorName FROM Courses c INNER JOIN Categories cat ON c.CategoryID = cat.CategoryID INNER JOIN Users u ON c.CreatedBy = u.UserID WHERE c.CourseStatus = 'Active'";

            var parms = new List<SqlParameter>();

            if (!string.IsNullOrEmpty(search))
            {
                sql += " AND (c.CourseTitle LIKE @Search OR c.CourseDescription LIKE @Search)";
                parms.Add(new SqlParameter("@Search", "%" + search + "%"));
            }
            if (!string.IsNullOrEmpty(catID))
            {
                sql += " AND c.CategoryID = @CatID";
                parms.Add(new SqlParameter("@CatID", int.Parse(catID)));
            }
            if (!string.IsNullOrEmpty(level))
            {
                sql += " AND c.DifficultyLevel = @Level";
                parms.Add(new SqlParameter("@Level", level));
            }

            sql += " ORDER BY c.CourseID DESC";

            DataTable dt = DBHelper.ExecuteQuery(sql, parms.Count > 0 ? parms.ToArray() : null);
            litResultCount.Text = dt.Rows.Count.ToString();
            pnlEmpty.Visible = dt.Rows.Count == 0;
            rptCourses.DataSource = dt;
            rptCourses.DataBind();
        }
    }
}