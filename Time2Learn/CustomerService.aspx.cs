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
    public partial class CustomerService : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole("Customer Service");
            if (!IsPostBack)
            {
                pnlFaqForm.Visible = false;
                pnlKBForm.Visible = false;
                LoadData();
            }
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
                litAvatar.Text = r["Avatar"] != DBNull.Value ? r["Avatar"].ToString() : "CS";
                litName.Text = r["FirstName"] + " " + r["LastName"];
                litEmail.Text = r["Email"].ToString();
            }

            litTotalCount.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Support_Tickets")?.ToString() ?? "0";
            litOpenCount.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Support_Tickets WHERE TicketStatus = 'Open'")?.ToString() ?? "0";
            litProgressCount.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Support_Tickets WHERE TicketStatus = 'In Progress'")?.ToString() ?? "0";
            litResolvedCount.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Support_Tickets WHERE TicketStatus = 'Resolved'")?.ToString() ?? "0";

            string ticketQuery = @"SELECT t.TicketID, t.Subject, t.Message, t.TicketStatus, t.CreatedDate, u.FirstName + ' ' + u.LastName AS UserName FROM Support_Tickets t INNER JOIN Users u ON t.UserID = u.UserID";

            // Recent
            DataTable recent = DBHelper.ExecuteQuery(ticketQuery + " ORDER BY t.CreatedDate DESC OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY");
            rptRecentTickets.DataSource = recent;
            rptRecentTickets.DataBind();

            // All
            DataTable all = DBHelper.ExecuteQuery(ticketQuery + " ORDER BY t.CreatedDate DESC");
            litAllCount.Text = all.Rows.Count.ToString();
            pnlNoTickets.Visible = all.Rows.Count == 0;
            rptAllTickets.DataSource = all;
            rptAllTickets.DataBind();

            // Open only
            DataTable openTickets = DBHelper.ExecuteQuery(ticketQuery + " WHERE t.TicketStatus IN ('Open', 'In Progress') ORDER BY t.CreatedDate ASC");
            pnlNoOpen.Visible = openTickets.Rows.Count == 0;
            rptOpenTickets.DataSource = openTickets;
            rptOpenTickets.DataBind();

            LoadFAQs();
            LoadChatLogs();
            LoadKB();
        }

        private void LoadFAQs()
        {
            DataTable faqs = DBHelper.ExecuteQuery(
                "SELECT FaqID, Category, Question, Answer, IsPublished, CreatedDate FROM FAQs ORDER BY CreatedDate DESC");
            litFaqCount.Text = faqs.Rows.Count.ToString();
            pnlNoFaqs.Visible = faqs.Rows.Count == 0;
            rptFAQs.DataSource = faqs;
            rptFAQs.DataBind();
        }

        private void LoadChatLogs()
        {
            DataTable logs = DBHelper.ExecuteQuery(@"
                SELECT c.LogID, c.UserQuery, c.BotResponse, c.IsEscalated, c.Timestamp,
                       u.FirstName + ' ' + u.LastName AS UserName
                FROM Chatbot c
                INNER JOIN Users u ON c.UserID = u.UserID
                ORDER BY c.Timestamp DESC");
            pnlNoChatLogs.Visible = logs.Rows.Count == 0;
            rptChatLogs.DataSource = logs;
            rptChatLogs.DataBind();
        }

        private void LoadKB()
        {
            DataTable kb = DBHelper.ExecuteQuery(
                "SELECT KnowledgeBaseID, Topic, ResponseSummary, Status, CreatedAt, UpdatedAt FROM Knowledge_Base ORDER BY CreatedAt DESC");
            litKBCount.Text = kb.Rows.Count.ToString();
            pnlNoKB.Visible = kb.Rows.Count == 0;
            rptKB.DataSource = kb;
            rptKB.DataBind();
        }

        protected void rptAllTickets_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;
            DataRowView row = (DataRowView)e.Item.DataItem;
            DropDownList ddl = (DropDownList)e.Item.FindControl("ddlStatus");
            if (ddl != null)
            {
                ListItem match = ddl.Items.FindByValue(row["TicketStatus"].ToString());
                if (match != null) match.Selected = true;
            }
        }

        protected void TicketAction_Command(object sender, CommandEventArgs e)
        {
            int ticketID = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Resolve")
            {
                DBHelper.ExecuteNonQuery("UPDATE Support_Tickets SET TicketStatus = 'Resolved' WHERE TicketID = @TID",
                    new System.Data.SqlClient.SqlParameter[]
                    {
                        new System.Data.SqlClient.SqlParameter("@TID", ticketID)
                    });
                hdnActiveSection.Value = "open";
            }
            else if (e.CommandName == "UpdateStatus")
            {
                // Find the DropDownList in the same row
                LinkButton btn = (LinkButton)sender;
                RepeaterItem item = (RepeaterItem)btn.NamingContainer;
                DropDownList ddl = (DropDownList)item.FindControl("ddlStatus");
                if (ddl != null)
                {
                    DBHelper.ExecuteNonQuery("UPDATE Support_Tickets SET TicketStatus = @Status WHERE TicketID = @TID",
                        new System.Data.SqlClient.SqlParameter[]
                        {
                            new System.Data.SqlClient.SqlParameter("@Status", ddl.SelectedValue),
                            new System.Data.SqlClient.SqlParameter("@TID", ticketID)
                        });
                }
                hdnActiveSection.Value = "tickets";
            }

            LoadData();
        }

        protected void btnShowAddFaq_Click(object sender, EventArgs e)
        {
            hdnEditFaqID.Value = "0";
            litFaqFormTitle.Text = "Add New FAQ";
            txtFaqQuestion.Text = "";
            txtFaqAnswer.Text = "";
            ddlFaqCategory.SelectedIndex = 0;
            ddlFaqPublished.SelectedIndex = 0;
            pnlFaqForm.Visible = true;
            hdnActiveSection.Value = "faq";
            LoadData();
        }

        protected void btnSaveFaq_Click(object sender, EventArgs e)
        {
            string question = txtFaqQuestion.Text.Trim();
            string answer = txtFaqAnswer.Text.Trim();
            string category = ddlFaqCategory.SelectedValue;
            bool isPublished = ddlFaqPublished.SelectedValue == "1";
            int editID = Convert.ToInt32(hdnEditFaqID.Value);

            if (!string.IsNullOrEmpty(question) && !string.IsNullOrEmpty(answer))
            {
                if (editID == 0)
                {
                    DBHelper.ExecuteNonQuery(
                        "INSERT INTO FAQs (Category, Question, Answer, IsPublished, CreatedDate) VALUES (@Cat, @Q, @A, @Pub, GETDATE())",
                        new SqlParameter[] {
                            new SqlParameter("@Cat", category),
                            new SqlParameter("@Q", question),
                            new SqlParameter("@A", answer),
                            new SqlParameter("@Pub", isPublished)
                        });
                }
                else
                {
                    DBHelper.ExecuteNonQuery(
                        "UPDATE FAQs SET Category = @Cat, Question = @Q, Answer = @A, IsPublished = @Pub WHERE FaqID = @ID",
                        new SqlParameter[] {
                            new SqlParameter("@Cat", category),
                            new SqlParameter("@Q", question),
                            new SqlParameter("@A", answer),
                            new SqlParameter("@Pub", isPublished),
                            new SqlParameter("@ID", editID)
                        });
                }
                pnlFaqForm.Visible = false;
                hdnEditFaqID.Value = "0";
            }
            hdnActiveSection.Value = "faq";
            LoadData();
        }

        protected void btnCancelFaq_Click(object sender, EventArgs e)
        {
            pnlFaqForm.Visible = false;
            hdnEditFaqID.Value = "0";
            hdnActiveSection.Value = "faq";
            LoadData();
        }

        protected void FaqAction_Command(object sender, CommandEventArgs e)
        {
            int faqID = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "EditFaq")
            {
                DataTable faq = DBHelper.ExecuteQuery(
                    "SELECT FaqID, Category, Question, Answer, IsPublished FROM FAQs WHERE FaqID = @ID",
                    new SqlParameter[] { new SqlParameter("@ID", faqID) });
                if (faq.Rows.Count > 0)
                {
                    DataRow r = faq.Rows[0];
                    hdnEditFaqID.Value = faqID.ToString();
                    litFaqFormTitle.Text = "Edit FAQ";
                    txtFaqQuestion.Text = r["Question"].ToString();
                    txtFaqAnswer.Text = r["Answer"].ToString();
                    ListItem catItem = ddlFaqCategory.Items.FindByValue(r["Category"].ToString());
                    if (catItem != null) ddlFaqCategory.SelectedValue = catItem.Value;
                    ddlFaqPublished.SelectedValue = Convert.ToBoolean(r["IsPublished"]) ? "1" : "0";
                    pnlFaqForm.Visible = true;
                }
            }
            else if (e.CommandName == "DeleteFaq")
            {
                DBHelper.ExecuteNonQuery(
                    "DELETE FROM FAQs WHERE FaqID = @ID",
                    new SqlParameter[] { new SqlParameter("@ID", faqID) });
                pnlFaqForm.Visible = false;
            }
            hdnActiveSection.Value = "faq";
            LoadData();
        }

        protected void btnShowAddKB_Click(object sender, EventArgs e)
        {
            hdnEditKBID.Value = "0";
            litKBFormTitle.Text = "Add KB Entry";
            txtKBTopic.Text = "";
            txtKBResponse.Text = "";
            ddlKBStatus.SelectedIndex = 0;
            pnlKBForm.Visible = true;
            hdnActiveSection.Value = "chatbot";
            hdnChatbotTab.Value = "kb";
            LoadData();
        }

        protected void btnSaveKB_Click(object sender, EventArgs e)
        {
            string topic = txtKBTopic.Text.Trim();
            string response = txtKBResponse.Text.Trim();
            string status = ddlKBStatus.SelectedValue;
            int editID = Convert.ToInt32(hdnEditKBID.Value);

            if (!string.IsNullOrEmpty(topic) && !string.IsNullOrEmpty(response))
            {
                if (editID == 0)
                {
                    DBHelper.ExecuteNonQuery(
                        "INSERT INTO Knowledge_Base (Topic, ResponseSummary, Status, CreatedAt) VALUES (@T, @R, @S, GETDATE())",
                        new SqlParameter[] {
                            new SqlParameter("@T", topic),
                            new SqlParameter("@R", response),
                            new SqlParameter("@S", status)
                        });
                }
                else
                {
                    DBHelper.ExecuteNonQuery(
                        "UPDATE Knowledge_Base SET Topic = @T, ResponseSummary = @R, Status = @S, UpdatedAt = GETDATE() WHERE KnowledgeBaseID = @ID",
                        new SqlParameter[] {
                            new SqlParameter("@T", topic),
                            new SqlParameter("@R", response),
                            new SqlParameter("@S", status),
                            new SqlParameter("@ID", editID)
                        });
                }
                pnlKBForm.Visible = false;
                hdnEditKBID.Value = "0";
            }
            hdnActiveSection.Value = "chatbot";
            hdnChatbotTab.Value = "kb";
            LoadData();
        }

        protected void btnCancelKB_Click(object sender, EventArgs e)
        {
            pnlKBForm.Visible = false;
            hdnEditKBID.Value = "0";
            hdnActiveSection.Value = "chatbot";
            hdnChatbotTab.Value = "kb";
            LoadData();
        }

        protected void KBAction_Command(object sender, CommandEventArgs e)
        {
            int kbID = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "EditKB")
            {
                DataTable kb = DBHelper.ExecuteQuery(
                    "SELECT KnowledgeBaseID, Topic, ResponseSummary, Status FROM Knowledge_Base WHERE KnowledgeBaseID = @ID",
                    new SqlParameter[] { new SqlParameter("@ID", kbID) });
                if (kb.Rows.Count > 0)
                {
                    DataRow r = kb.Rows[0];
                    hdnEditKBID.Value = kbID.ToString();
                    litKBFormTitle.Text = "Edit KB Entry";
                    txtKBTopic.Text = r["Topic"].ToString();
                    txtKBResponse.Text = r["ResponseSummary"].ToString();
                    ddlKBStatus.SelectedValue = r["Status"].ToString();
                    pnlKBForm.Visible = true;
                }
            }
            else if (e.CommandName == "DeleteKB")
            {
                DBHelper.ExecuteNonQuery(
                    "DELETE FROM Knowledge_Base WHERE KnowledgeBaseID = @ID",
                    new SqlParameter[] { new SqlParameter("@ID", kbID) });
                pnlKBForm.Visible = false;
            }
            hdnActiveSection.Value = "chatbot";
            hdnChatbotTab.Value = "kb";
            LoadData();
        }

        protected void ChatLogAction_Command(object sender, CommandEventArgs e)
        {
            if (e.CommandName == "ToggleEscalated")
            {
                string[] parts = e.CommandArgument.ToString().Split(',');
                int logID = Convert.ToInt32(parts[0]);
                bool current = Convert.ToBoolean(parts[1]);
                DBHelper.ExecuteNonQuery(
                    "UPDATE Chatbot SET IsEscalated = @Val WHERE LogID = @ID",
                    new SqlParameter[] {
                        new SqlParameter("@Val", !current),
                        new SqlParameter("@ID", logID)
                    });
            }
            hdnActiveSection.Value = "chatbot";
            hdnChatbotTab.Value = "logs";
            LoadData();
        }
    }
}
