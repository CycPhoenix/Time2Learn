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
    public partial class Support : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFAQs();

                // Pre-fill if logged in
                if (AuthHelper.IsLoggedIn())
                {
                    int userID = AuthHelper.GetUserID();
                    DataTable me = DBHelper.ExecuteQuery("SELECT FirstName + ' ' + LastName AS FullName, Email FROM Users WHERE UserID = @UID",
                        new System.Data.SqlClient.SqlParameter[]
                        {
                        new System.Data.SqlClient.SqlParameter("@UID", userID)
                        });
                    if (me.Rows.Count > 0)
                    {
                        txtName.Text = me.Rows[0]["FullName"].ToString();
                        txtEmail.Text = me.Rows[0]["Email"].ToString();
                        txtName.ReadOnly = true;
                        txtEmail.ReadOnly = false;
                    }
                }
            }
        }

        private void LoadFAQs()
        {
            DataTable faqs = DBHelper.ExecuteQuery("SELECT Question, Answer FROM FAQs ORDER BY FAQID");
            rptFAQs.DataSource = faqs;
            rptFAQs.DataBind();
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int? userID = null;
            if (AuthHelper.IsLoggedIn()) userID = AuthHelper.GetUserID();

            if (userID == null)
            {
                // Guest: look up user by email or skip userID
                object found = DBHelper.ExecuteScalar("SELECT UserID FROM Users WHERE LOWER(Email) = @Email",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@Email", txtEmail.Text.Trim().ToLower())
                    });
                if (found != null) userID = Convert.ToInt32(found);
            }

            if (userID == null)
            {
                lblError.Text = "Please log in or use the email address registered with your account.";
                return;
            }

            DBHelper.ExecuteNonQuery("INSERT INTO Support_Tickets (UserID, Subject, Message, TicketStatus, CreatedDate) VALUES (@UID, @Subject, @Msg, 'Open', GETDATE())",
                new System.Data.SqlClient.SqlParameter[]
                {
                    new System.Data.SqlClient.SqlParameter("@UID", userID),
                    new System.Data.SqlClient.SqlParameter("@Subject", txtSubject.Text.Trim()),
                    new System.Data.SqlClient.SqlParameter("@Msg", txtMessage.Text.Trim())
                });

            txtSubject.Text = "";
            txtMessage.Text = "";
            pnlSuccess.Visible = true;
            lblError.Text = "";
        }
    }
}