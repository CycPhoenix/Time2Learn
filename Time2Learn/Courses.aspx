<%@ Page Title="Courses - Time2Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="Time2Learn.Courses" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .trending-badge { position:absolute;top:10px;left:10px;background:#f59e0b;color:white;font-size:0.7rem;font-weight:700;padding:3px 9px;border-radius:4px;text-transform:uppercase; }
        .course-card { position:relative; }
        .pagination { display:flex;gap:8px;justify-content:center;margin-top:40px; }
        .page-btn { width:38px;height:38px;border-radius:8px;border:1.5px solid var(--border);background:white;font-weight:600;font-size:0.9rem;cursor:pointer;transition:var(--t-fast);display:flex;align-items:center;justify-content:center; }
        .page-btn:hover,.page-btn.active { background:var(--primary);color:white;border-color:var(--primary); }
        .search-bar-full { display:flex;gap:12px;margin-bottom:32px; }
        .search-bar-full input { flex:1;padding:12px 18px;border:1.5px solid var(--border);border-radius:8px;font-size:1rem;transition:var(--t-fast); }
        .search-bar-full input:focus { outline:none;border-color:var(--primary);box-shadow:0 0 0 3px rgba(164,53,240,0.1); }
        .active-filters { display:flex;gap:8px;flex-wrap:wrap;margin-bottom:16px;min-height:8px; }
        .filter-tag { background:var(--primary-light);color:var(--primary);padding:4px 12px;border-radius:20px;font-size:0.8rem;font-weight:600;display:flex;align-items:center;gap:6px;cursor:pointer; }

        /* Layout */
        .courses-layout { display:flex;gap:32px;padding:40px 0; }
        .filters-panel { width:260px;flex-shrink:0;background:white;border:1px solid var(--border);border-radius:var(--radius-lg);padding:24px;align-self:flex-start;position:sticky;top:88px; }
        .filters-panel h3 { font-size:1rem;font-weight:700;margin-bottom:20px;color:var(--text-dark); }
        .filter-group { margin-bottom:20px;padding-bottom:20px;border-bottom:1px solid var(--border); }
        .filter-group:last-of-type { border-bottom:none;margin-bottom:0;padding-bottom:0; }
        .filter-group h4 { font-size:0.82rem;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:var(--text-light);margin-bottom:12px; }
        .filter-option { display:flex;align-items:center;gap:8px;padding:4px 0;font-size:0.88rem;color:var(--text-mid);cursor:pointer; }
        .filter-option input { accent-color:var(--primary); }
        .filter-option label { cursor:pointer; }

        /* Main */
        .courses-main { flex:1;min-width:0; }
        .courses-toolbar { display:flex;justify-content:space-between;align-items:center;margin-bottom:24px;flex-wrap:wrap;gap:12px; }
        .courses-toolbar__count { font-size:0.88rem;color:var(--text-light); }
        .courses-toolbar__right { display:flex;align-items:center;gap:12px;font-size:0.85rem; }
        .courses-toolbar__right select { padding:6px 10px;border:1px solid var(--border);border-radius:6px;font-size:0.85rem;color:var(--text-dark); }

        /* Course cards (template style) */
        .courses-grid { display:grid;grid-template-columns:repeat(auto-fill,minmax(260px,1fr));gap:20px; }
        .course-card { background:white;border-radius:var(--radius-lg);border:1px solid var(--border);overflow:hidden;transition:var(--t-fast);text-decoration:none;color:inherit;display:block; }
        .course-card:hover { transform:translateY(-3px);box-shadow:0 8px 24px rgba(0,0,0,0.08); }
        .course-card__img-placeholder { height:150px;display:flex;align-items:center;justify-content:center;font-size:2.8rem;background:linear-gradient(135deg,#a435f0,#7c2bd1); }
        .course-card__body { padding:18px; }
        .course-card__category { font-size:0.72rem;color:var(--primary);font-weight:700;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:7px; }
        .course-card__title { font-size:0.95rem;font-weight:700;margin-bottom:7px;line-height:1.4; }
        .course-card__instructor { font-size:0.8rem;color:var(--text-light);margin-bottom:12px; }
        .course-card__rating { display:flex;align-items:center;gap:4px;margin-bottom:8px;font-size:0.82rem; }
        .course-card__stars { color:#f59e0b; }
        .course-card__rating-num { font-weight:700;color:var(--text-dark); }
        .course-card__rating-count { color:var(--text-light); }
        .course-card__meta { display:flex;gap:10px;font-size:0.78rem;color:var(--text-light);margin-bottom:10px; }
        .course-card__footer { display:flex;justify-content:space-between;align-items:center;padding-top:10px;border-top:1px solid var(--border); }
        .course-card__price { font-size:0.95rem;font-weight:800;color:var(--text-dark); }
        .course-card__level { font-size:0.72rem;border-radius:12px;padding:3px 10px;color:white; }
        .level--beginner { background:#22c55e; }
        .level--intermediate { background:#f59e0b; }
        .level--advanced { background:#ef4444; }

        .empty-state { text-align:center;padding:80px 24px;color:var(--text-light); }
        .result-count { font-size:0.85rem;color:var(--text-light); }

        /* Search box for server-side search */
        .search-box { display:flex;gap:0;border:1px solid var(--border);border-radius:var(--radius);overflow:hidden; }
        .search-box input { padding:9px 14px;border:none;outline:none;font-size:0.88rem;width:200px; }
        .search-box button { padding:9px 16px;background:var(--primary);color:white;border:none;cursor:pointer;font-size:0.88rem; }

        /* Dark mode */
        [data-theme="dark"] .filters-panel { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .filters-panel h3 { color:#fff; }
        [data-theme="dark"] .filter-group { border-color:#333; }
        [data-theme="dark"] .filter-option { color:#ccc; }
        [data-theme="dark"] .search-bar-full input { background:#2a2a2e; border-color:#444; color:#fff; }
        [data-theme="dark"] .search-box input { background:#2a2a2e; border-color:#444; color:#fff; }
        [data-theme="dark"] .courses-toolbar__right select { background:#2a2a2e; border-color:#444; color:#fff; }
        [data-theme="dark"] .course-card { background:#2a2a2e; border-color:#333; }
        [data-theme="dark"] .course-card__title { color:#fff; }
        [data-theme="dark"] .course-card__footer { border-color:#333; }
        [data-theme="dark"] .course-card__price { color:#fff; }
        [data-theme="dark"] .page-btn { background:#2a2a2e; border-color:#444; color:#ccc; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <h1>All Courses</h1>
            <p>Explore courses across programming, AI, web development, cybersecurity, and more.</p>
        </div>
    </div>

    <!-- Courses Layout -->
    <div class="container">
        <div class="courses-layout">

            <!-- Filters Sidebar -->
            <aside class="filters-panel">
                <h3>Filter Courses</h3>

                <div class="filter-group">
                    <h4>Category</h4>
                    <asp:Repeater ID="rptCatFilter" runat="server">
                        <ItemTemplate>
                            <div class="filter-option">
                                <input type="radio" name="cat" id="cat_<%# Eval("CategoryID") %>" value="<%# Eval("CategoryID") %>" onchange="applyFilter()" />
                                <label for="cat_<%# Eval("CategoryID") %>"><%# Eval("CategoryName") %></label>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <div class="filter-option">
                        <input type="radio" name="cat" id="cat_all" value="" checked onchange="applyFilter()" />
                        <label for="cat_all">All Categories</label>
                    </div>
                </div>

                <div class="filter-group">
                    <h4>Level</h4>
                    <div class="filter-option"><input type="radio" name="level" id="lvl_all" value="" checked onchange="applyFilter()" /><label for="lvl_all">All Levels</label></div>
                    <div class="filter-option"><input type="radio" name="level" id="lvl_beg" value="Beginner" onchange="applyFilter()" /><label for="lvl_beg">Beginner</label></div>
                    <div class="filter-option"><input type="radio" name="level" id="lvl_int" value="Intermediate" onchange="applyFilter()" /><label for="lvl_int">Intermediate</label></div>
                    <div class="filter-option"><input type="radio" name="level" id="lvl_adv" value="Advanced" onchange="applyFilter()" /><label for="lvl_adv">Advanced</label></div>
                </div>

                <asp:HiddenField ID="hdnCatID" runat="server" />
                <asp:HiddenField ID="hdnLevel" runat="server" />
                <div style="margin-top:20px;">
                    <asp:Button ID="btnSearch" runat="server" Text="Apply Filters" CssClass="btn btn--primary btn--full" OnClick="btnSearch_Click" />
                </div>
            </aside>

            <!-- Courses Main -->
            <div class="courses-main">

                <!-- Server-side search bar -->
                <div class="search-bar-full">
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="Search courses by title, topic, instructor…" />
                    <asp:Button ID="btnSearchBar" runat="server" Text="Search" CssClass="btn btn--primary" OnClick="btnSearch_Click" />
                </div>

                <!-- Client-side filter tags display -->
                <div class="active-filters" id="activeFilters"></div>

                <!-- Toolbar -->
                <div class="courses-toolbar">
                    <span class="courses-toolbar__count" id="courseCount">
                        <asp:Literal ID="litResultCount" runat="server" /> courses found
                    </span>
                    <div class="courses-toolbar__right">
                        <span style="font-size:0.85rem;color:var(--text-light);">Sort by:</span>
                        <select id="sortSelect">
                            <option value="popular">Most Popular</option>
                            <option value="newest">Newest</option>
                            <option value="rating">Highest Rated</option>
                            <option value="price-low">Price: Low to High</option>
                            <option value="price-high">Price: High to Low</option>
                        </select>
                    </div>
                </div>

                <!-- Grid -->
                <div class="courses-grid" id="coursesGrid">
                    <asp:Repeater ID="rptCourses" runat="server">
                        <ItemTemplate>
                            <a href="CourseDetail.aspx?id=<%# Eval("CourseID") %>" class="course-card" data-reveal>
                                <div class="course-card__img-placeholder" style="background:linear-gradient(135deg,#a435f0,#7c2bd1);">📚</div>
                                <div class="course-card__body">
                                    <div class="course-card__category"><%# Eval("CategoryName") %></div>
                                    <div class="course-card__title"><%# Eval("CourseTitle") %></div>
                                    <div class="course-card__instructor">by <%# Eval("InstructorName") %></div>
                                    <div class="course-card__footer">
                                        <span class="course-card__price">RM <%# Eval("Price", "{0:0.00}") %></span>
                                        <span class="course-card__level"><%# Eval("DifficultyLevel") %></span>
                                    </div>
                                </div>
                            </a>
                        </ItemTemplate>
                    </asp:Repeater>
                    <p id="noCoursesMsg" style="display:none;grid-column:1/-1;text-align:center;padding:48px 0;color:var(--text-light);font-size:1rem;">No courses found. Try a different search or filter.</p>
                </div>

                <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
                    <div class="empty-state">No courses found. Try a different search.</div>
                </asp:Panel>

                <!-- Pagination -->
                <div class="pagination">
                    <button class="page-btn active">1</button>
                    <button class="page-btn">2</button>
                    <button class="page-btn">3</button>
                    <button class="page-btn">→</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        // @ts-nocheck
        function applyFilter() {
            var catRadio = document.querySelector('input[name="cat"]:checked');
            var levelRadio = document.querySelector('input[name="level"]:checked');
            var catID = catRadio ? catRadio.value : '';
            var level = levelRadio ? levelRadio.value : '';
            document.getElementById('<%= hdnCatID.ClientID %>').value = catID;
            document.getElementById('<%= hdnLevel.ClientID %>').value = level;
    document.getElementById('<%= btnSearch.ClientID %>').click();
}

// Restore filter selections after postback
        window.addEventListener('DOMContentLoaded', function () {
            var catVal = document.getElementById('<%= hdnCatID.ClientID %>').value;
            var levelVal = document.getElementById('<%= hdnLevel.ClientID %>').value;

            if (catVal) {
                var catRadio = document.querySelector('input[name="cat"][value="' + catVal + '"]');
                if (catRadio) catRadio.checked = true;
            } else {
                document.getElementById('cat_all').checked = true;
            }

            if (levelVal) {
                var levelRadio = document.querySelector('input[name="level"][value="' + levelVal + '"]');
                if (levelRadio) levelRadio.checked = true;
            } else {
                document.getElementById('lvl_all').checked = true;
            }
        });

        // Pagination button highlight
document.querySelectorAll('.page-btn').forEach(function (btn) {
    btn.addEventListener('click', function () {
        document.querySelectorAll('.page-btn').forEach(function (b) { b.classList.remove('active'); });
        this.classList.add('active');
    });
});

// Client-side search (fallback for instant feedback)
function filterCoursesBySearch(query) {
    var q = query.trim().toLowerCase();
    var cards = document.querySelectorAll('.courses-grid .course-card');
    var visible = 0;
    cards.forEach(function (card) {
        var match = !q || card.textContent.toLowerCase().includes(q);
        card.style.display = match ? '' : 'none';
        if (match) visible++;
    });
    document.getElementById('noCoursesMsg').style.display = visible === 0 ? 'block' : 'none';
}
</script>
</asp:Content>
