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
    public partial class CustomerService : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole("Customer Service");
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
                litAvatar.Text = r["Avatar"] != DBNull.Value ? r["Avatar"].ToString() : "CS";
                litName.Text = r["FirstName"] + " " + r["LastName"];
                litEmail.Text = r["Email"].ToString();
            }

            // Stats
            object total = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Support_Tickets");
            object open = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Support_Tickets WHERE TicketStatus = 'Open'");
            object inProg = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Support_Tickets WHERE TicketStatus = 'In Progress'");
            object resolved = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Support_Tickets WHERE TicketStatus = 'Resolved'");

            litTotalCount.Text = total?.ToString() ?? "0";
            litOpenCount.Text = open?.ToString() ?? "0";
            litProgressCount.Text = inProg?.ToString() ?? "0";
            litResolvedCount.Text = resolved?.ToString() ?? "0";

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
            }

            LoadData();
        }
    }
}