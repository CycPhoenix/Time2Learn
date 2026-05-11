# Instructions: Write DBHelper.cs and AuthHelper.cs

## Project Context
- ASP.NET Web Application (.NET Framework 4.7.2)
- Project namespace: `Time2Learn.App_Code` — but these files are in `App_Code/` so they should use **no namespace** (App_Code classes are globally accessible in ASP.NET Web Forms without a namespace)
- Database: SQL Server LocalDB, connection string name is `Time2LearnDB` (already set in Web.config)

---

## File 1: `App_Code/DBHelper.cs`

Write a static class `DBHelper` with **no namespace**. It handles all database operations for the project.

Use these usings:
```
using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
```

The connection string is read from Web.config like this:
```csharp
ConfigurationManager.ConnectionStrings["Time2LearnDB"].ConnectionString
```

### Methods to implement:

**1. `ExecuteQuery(string sql, SqlParameter[] parameters = null)`**
- Returns a `DataTable`
- Opens connection, creates SqlCommand, adds parameters if any, uses SqlDataAdapter to fill and return a DataTable
- Always close connection in a finally block

**2. `ExecuteNonQuery(string sql, SqlParameter[] parameters = null)`**
- Returns `int` (rows affected)
- Opens connection, creates SqlCommand, adds parameters if any, calls ExecuteNonQuery()
- Always close connection in a finally block

**3. `ExecuteScalar(string sql, SqlParameter[] parameters = null)`**
- Returns `object`
- Opens connection, creates SqlCommand, adds parameters if any, calls ExecuteScalar()
- Always close connection in a finally block

### Important:
- Always use parameterized queries (never string concatenation) to prevent SQL injection
- Use `using` blocks or try/finally to ensure connections are always closed

---

## File 2: `App_Code/AuthHelper.cs`

Write a static class `AuthHelper` with **no namespace**.

Use these usings:
```
using System;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.SessionState;
```

### Methods to implement:

**1. `HashPassword(string password)`**
- Returns `string`
- Uses SHA-256 to hash the password
- Returns the hash as a lowercase hex string

**2. `IsLoggedIn()`**
- Returns `bool`
- Checks if `HttpContext.Current.Session["UserID"]` is not null

**3. `GetUserID()`**
- Returns `int`
- Returns `(int)HttpContext.Current.Session["UserID"]`
- Returns 0 if not logged in

**4. `GetUserRole()`**
- Returns `string`
- Returns `HttpContext.Current.Session["Role"].ToString()`
- Returns empty string if not logged in

**5. `GetUserName()`**
- Returns `string`
- Returns `HttpContext.Current.Session["Name"].ToString()`
- Returns empty string if not logged in

**6. `SetSession(int userID, string role, string name)`**
- Returns `void`
- Sets `Session["UserID"]`, `Session["Role"]`, `Session["Name"]`

**7. `ClearSession()`**
- Returns `void`
- Calls `HttpContext.Current.Session.Clear()`

**8. `RequireLogin()`**
- Returns `void`
- If not logged in, redirects to `Login.aspx`

**9. `RequireRole(string role)`**
- Returns `void`
- If not logged in OR role doesn't match, redirects to `Login.aspx`

---

## Database Schema Notes (important for column names)

The actual DB uses these column names — use them exactly in any SQL examples or comments:

| Use This | Not This |
|---|---|
| `PasswordHash` | `Password` |
| `RoleID` + JOIN `Roles` table | `Role` as string |
| `AccountStatus` | `Status` (in Users) |
| `CourseTitle` | `Title` |
| `CourseDescription` | `Description` |
| `DifficultyLevel` | `Level` |
| `CourseStatus` | `Status` (in Courses) |
| `CreatedBy` | `InstructorID` |
| `OverallProgressPercentage` | `Progress` |
| `EnrollDate` | `EnrolledAt` |
| `Support_Tickets` | `SupportTickets` |
| `TicketStatus` | `Status` (in tickets) |
| `Discussion_Threads` | `CommunityPosts` |

Role names in the Roles table: `Student`, `Instructor`, `Moderator`, `Administrator`, `Customer Service`

---

## What NOT to do
- Do not add a namespace wrapper — App_Code classes must be globally accessible
- Do not use Entity Framework
- Do not use async/await — this is classic ASP.NET Web Forms (.NET Framework), keep it synchronous
- Do not change Web.config
- Do not create any new files beyond the two listed above
