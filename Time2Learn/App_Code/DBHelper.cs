using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Time2Learn.App_Code
{
    public class DBHelper
    {
        private static string ConnStr
        {
            get { return ConfigurationManager.ConnectionStrings["Time2LearnDB"].ConnectionString; }
        }

        public static DataTable ExecuteQuery(string sql, SqlParameter[] parameters = null)
        {
            DataTable dt = new DataTable();
            SqlConnection conn = new SqlConnection(ConnStr);
            try
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(sql, conn);
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }
            finally
            {
                conn.Close();
            }
            return dt;
        }

        public static int ExecuteNonQuery(string sql, SqlParameter[] parameters = null)
        {
            int rows = 0;
            SqlConnection conn = new SqlConnection(ConnStr);
            try
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(sql, conn);
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);
                rows = cmd.ExecuteNonQuery();
            }
            finally
            {
                conn.Close();
            }
            return rows;
        }

        public static object ExecuteScalar(string sql, SqlParameter[] parameters = null)
        {
            object result = null;
            SqlConnection conn = new SqlConnection(ConnStr);
            try
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(sql, conn);
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);
                result = cmd.ExecuteScalar();
            }
            finally
            {
                conn.Close();
            }
            return result;
        }
    }
}