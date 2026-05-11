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
    public partial class Moderator : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole("Moderator");
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
                litAvatar.Text = r["Avatar"] != DBNull.Value ? r["Avatar"].ToString() : "M";
                litName.Text = r["FirstName"] + " " + r["LastName"];
                litEmail.Text = r["Email"].ToString();
            }

            // Stats
            object threadCount = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Discussion_Threads");
            object postCount = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Discussion_Posts");
            object annCount = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Announcements");
            litThreadCount.Text = threadCount?.ToString() ?? "0";
            litPostCount.Text = postCount?.ToString() ?? "0";
            litAnnCount.Text = annCount?.ToString() ?? "0";

            // Recent threads
            DataTable recent = DBHelper.ExecuteQuery("SELECT TOP 5 t.ThreadID, t.Title, t.CreatedAt, u.FirstName + ' ' + u.LastName AS AuthorName, cat.CategoryName, (SELECT COUNT(*) FROM Discussion_Posts p WHERE p.ThreadID = t.ThreadID) AS PostCount FROM Discussion_Threads t INNER JOIN Users u ON t.UserID = u.UserID INNER JOIN Categories cat ON t.CategoryID = cat.CategoryID ORDER BY t.CreatedAt DESC");
            rptRecentThreads.DataSource = recent;
            rptRecentThreads.DataBind();

            // All threads
            DataTable allThreads = DBHelper.ExecuteQuery("SELECT t.ThreadID, t.Title, t.CreatedAt, u.FirstName + ' ' + u.LastName AS AuthorName, cat.CategoryName, (SELECT COUNT(*) FROM Discussion_Posts p WHERE p.ThreadID = t.ThreadID) AS PostCount FROM Discussion_Threads t INNER JOIN Users u ON t.UserID = u.UserID INNER JOIN Categories cat ON t.CategoryID = cat.CategoryID ORDER BY t.CreatedAt DESC");
            litAllThreadCount.Text = allThreads.Rows.Count.ToString();
            pnlNoThreads.Visible = allThreads.Rows.Count == 0;
            rptThreads.DataSource = allThreads;
            rptThreads.DataBind();

            // Announcements
            DataTable anns = DBHelper.ExecuteQuery("SELECT a.AnnouncementID, a.Title, a.CreatedAt, u.FirstName + ' ' + u.LastName AS AuthorName FROM Announcements a INNER JOIN Users u ON a.AuthorID = u.UserID ORDER BY a.CreatedAt DESC");
            pnlNoAnn.Visible = anns.Rows.Count == 0;
            rptAnnouncements.DataSource = anns;
            rptAnnouncements.DataBind();
        }

        protected void btnPostAnn_Click(object sender, EventArgs e)
        {
            int userID = AuthHelper.GetUserID();
            DBHelper.ExecuteNonQuery("INSERT INTO Announcements (Title, Content, AuthorID, CreatedAt) VALUES (@Title, @Content, @AuthorID, GETDATE())",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@Title", txtAnnTitle.Text.Trim()),
                    new System.Data.SqlClient.SqlParameter("@Content", txtAnnContent.Text.Trim()),
                    new System.Data.SqlClient.SqlParameter("@AuthorID", userID)
                });
            txtAnnTitle.Text = "";
            txtAnnContent.Text = "";
            lblAnnMsg.Text = "Announcement posted.";
            lblAnnMsg.ForeColor = System.Drawing.Color.Green;
            LoadData();
        }

        protected void ThreadAction_Command(object sender, CommandEventArgs e)
        {
            if (e.CommandName == "DeleteThread")
            {
                int threadID = Convert.ToInt32(e.CommandArgument);
                DBHelper.ExecuteNonQuery("DELETE FROM Discussion_Posts WHERE ThreadID = @TID",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@TID", threadID)
                    });
                DBHelper.ExecuteNonQuery("DELETE FROM Discussion_Threads WHERE ThreadID = @TID",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@TID", threadID)
                    });
                LoadData();
            }
        }

        protected void AnnAction_Command(object sender, CommandEventArgs e)
        {
            if (e.CommandName == "DeleteAnn")
            {
                int annID = Convert.ToInt32(e.CommandArgument);
                DBHelper.ExecuteNonQuery("DELETE FROM Announcements WHERE AnnouncementID = @AID",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@AID", annID)
                    });
                LoadData();
            }
        }
    }
}