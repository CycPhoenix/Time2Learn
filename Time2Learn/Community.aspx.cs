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
    public partial class Community : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) LoadData();

            bool loggedIn = AuthHelper.IsLoggedIn();
            pnlNewThread.Visible = loggedIn;
            pnlNewBtn.Visible = loggedIn;
        }

        private void LoadData()
        {
            // Threads
            DataTable threads = DBHelper.ExecuteQuery(@"SELECT t.ThreadID, t.Title, t.CreatedAt, u.FirstName + ' ' + u.LastName AS AuthorName, ISNULL(u.Avatar, '?') AS Avatar, cat.CategoryName, (SELECT COUNT(*) FROM Discussion_Posts p WHERE p.ThreadID = t.ThreadID) AS PostCount, ISNULL((SELECT TOP 1 Content FROM Discussion_Posts p WHERE p.ThreadID = t.ThreadID ORDER BY p.PostID), t.Title) AS FirstPost FROM Discussion_Threads t INNER JOIN Users u ON t.UserID = u.UserID INNER JOIN Categories cat ON t.CategoryID = cat.CategoryID ORDER BY t.CreatedAt DESC");
            pnlNoThreads.Visible = threads.Rows.Count == 0;
            rptThreads.DataSource = threads;
            rptThreads.DataBind();

            // Categories
            DataTable cats = DBHelper.ExecuteQuery("SELECT CategoryID, CategoryName FROM Categories ORDER BY CategoryName");
            rptCats.DataSource = cats;
            rptCats.DataBind();
            ddlCat.DataSource = cats;
            ddlCat.DataTextField = "CategoryName";
            ddlCat.DataValueField = "CategoryID";
            ddlCat.DataBind();

            // Announcements
            DataTable ann = DBHelper.ExecuteQuery("SELECT TOP 5 Title, CreatedAt FROM Announcements ORDER BY CreatedAt DESC");
            pnlNoAnn.Visible = ann.Rows.Count == 0;
            rptAnn.DataSource = ann;
            rptAnn.DataBind();
        }

        protected void btnPostThread_Click(object sender, EventArgs e)
        {
            int userID = AuthHelper.GetUserID();
            int catID = int.Parse(ddlCat.SelectedValue);

            object newThreadID = DBHelper.ExecuteScalar(@"INSERT INTO Discussion_Threads (UserID, CategoryID, Title, CreatedAt, Status) VALUES (@UID, @CID, @Title, GETDATE(), 'Open'); SELECT SCOPE_IDENTITY();",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID),
                    new System.Data.SqlClient.SqlParameter("@CID", catID),
                    new System.Data.SqlClient.SqlParameter("@Title", txtThreadTitle.Text.Trim())
                });

            if (newThreadID != null)
            {
                DBHelper.ExecuteNonQuery(@"INSERT INTO Discussion_Posts (ThreadID, UserID, Content, CreatedAt, IsEdited, PostStatus) VALUES (@TID, @UID, @Content, GETDATE(), 0, 'Approved')",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@TID", Convert.ToInt32(newThreadID)),
                        new System.Data.SqlClient.SqlParameter("@UID", userID),
                        new System.Data.SqlClient.SqlParameter("@Content", txtThreadBody.Text.Trim())
                    });
            }

            txtThreadTitle.Text = "";
            txtThreadBody.Text = "";
            lblMsg.Text = "Thread posted";
            lblMsg.ForeColor = System.Drawing.Color.Green;
            LoadData();
        }
    }
}