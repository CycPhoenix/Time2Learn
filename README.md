# 🎓 Time2Learn — CT050-3-2-WAPP | Group 13

> Online learning platform for CS & programming built with **ASP.NET Web Forms (.NET 4.7.2)** + **SQL Server**.

---

## 👥 Team

| Name | Role |
|---|---|
| Eee Kong Siong | Project Manager |
| Brosnan Ban Cong Yin | Backend Developer |
| Ng Wan Teng | Backend Developer |
| Lai Kah Fon | Frontend Developer |
| Lee Wei Kee | Frontend Developer |

---

## 🚀 Features

- **5 Role Dashboards** — Student, Instructor, Admin, Moderator, Customer Service
- **Course Catalogue** — Browse, filter, search, enrol, pay
- **Learning Materials** — Video lessons, quizzes, coding exercises, lab submissions
- **Community Forum** — Threads, posts, announcements
- **AI Chatbot** — Gemini 2.0 Flash powered assistant (fullscreen + embedded)
- **Support Tickets** — Submit & track with CS dashboard
- **Dark Mode** — Full site dark/light toggle with localStorage persistence
- **Instructor Registration** — Application flow with admin approval

---

## 🔑 Demo Accounts

| Role | Email | Password |
|---|---|---|
| Admin | admin@time2learn.com | admin123 |
| Instructor | instructor@time2learn.com | teach123 |
| Moderator | moderator@time2learn.com | mod123 |
| Student | student@time2learn.com | learn123 |
| Customer Service | cs@time2learn.com | cs1234 |

---

## 🛠️ Tech Stack

| Layer | Tech |
|---|---|
| Frontend | ASP.NET Web Forms, HTML5, CSS3, Vanilla JS |
| Backend | C# ASP.NET (.NET Framework 4.7.2) |
| Database | Microsoft SQL Server |
| AI | Google Gemini 2.0 Flash REST API |
| Auth | Session-based, SHA-256 password hashing |

---

## 📁 Project Structure

```
time/
├── App_Code/
│   ├── DBHelper.cs        # ExecuteQuery / ExecuteNonQuery / ExecuteScalar
│   └── AuthHelper.cs      # HashPassword / Session / RequireLogin / RequireRole
├── Site.Master            # Shared nav, footer, dark mode, animations
├── Default.aspx           # Landing page
├── Courses.aspx           # Course catalogue + filters
├── CourseDetail.aspx      # Course info + enrol + reviews
├── Student.aspx           # Student dashboard
├── Admin.aspx             # Admin panel
├── Instructor.aspx        # Instructor dashboard
├── Moderator.aspx         # Moderator panel
├── CustomerService.aspx   # CS ticket management
├── Community.aspx         # Discussion forum
├── Chatbot.aspx           # AI assistant
├── LearningMaterial.aspx  # Course lesson hub
├── CurriculumVideo.aspx   # Video lesson player
├── CurriculumQuiz.aspx    # Quiz with auto-marking
├── CurriculumCoding.aspx  # Coding exercise
├── CurriculumLab.aspx     # Lab submission
└── ...
```

---

## ⚙️ Setup

1. Restore SQL Server DB (attach `.mdf` or run schema script)
2. Update connection string in `Web.config`
3. Set Gemini API key in `ChatbotHandler.ashx`
4. Run via **IIS Express** in Visual Studio 2022
5. Navigate to `Default.aspx`

---

## 📊 DB Key Tables

`Users` · `Roles` · `Courses` · `Categories` · `Lessons` · `Enrollments` · `Lesson_Progress` · `Quiz` · `Cart` · `Review` · `Discussion_Threads` · `Discussion_Posts` · `Announcements` · `Support_Tickets` · `FAQs`
