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

            DataTable me = DBHelper.ExecuteQuery(@"SELECT Avatar, FirstName, LastName, Email FROM Users WHERE UserID = @UID",
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
            DataTable recent = DBHelper.ExecuteQuery(@"SELECT TOP 5 t.ThreadID, t.Title, t.CreatedAt, u.FirstName + ' ' + u.LastName AS AuthorName, cat.CategoryName, (SELECT COUNT(*) FROM Discussion_Posts p WHERE p.ThreadID = t.ThreadID) AS PostCount FROM Discussion_Threads t INNER JOIN Users u ON t.UserID = u.UserID INNER JOIN Categories cat ON t.CategoryID = cat.CategoryID ORDER BY t.CreatedAt DESC");
            rptRecentThreads.DataSource = recent;
            rptRecentThreads.DataBind();

            // All threads
            DataTable allThreads = DBHelper.ExecuteQuery(@"SELECT t.ThreadID, t.Title, t.CreatedAt, u.FirstName + ' ' + u.LastName AS AuthorName, cat.CategoryName, (SELECT COUNT(*) FROM Discussion_Posts p WHERE p.ThreadID = t.ThreadID) AS PostCount FROM Discussion_Threads t INNER JOIN Users u ON t.UserID = u.UserID INNER JOIN Categories cat ON t.CategoryID = cat.CategoryID ORDER BY t.CreatedAt DESC");
            litAllThreadCount.Text = allThreads.Rows.Count.ToString();
            pnlNoThreads.Visible = allThreads.Rows.Count == 0;
            rptThreads.DataSource = allThreads;
            rptThreads.DataBind();

            // Announcements
            DataTable anns = DBHelper.ExecuteQuery("SELECT a.AnnouncementID, a.Title, a.CreatedAt, u.FirstName + ' ' + u.LastName AS AuthorName FROM Announcements a INNER JOIN Users u ON a.AuthorID = u.UserID ORDER BY a.CreatedAt DESC");
            pnlNoAnn.Visible = anns.Rows.Count == 0;
            rptAnnouncements.DataSource = anns;
            rptAnnouncements.DataBind();

            LoadProfile();
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
            hdnActiveSection.Value = "announcements";
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
                hdnActiveSection.Value = "threads";
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
                hdnActiveSection.Value = "announcements";
                LoadData();
            }
        }
    }
}