<style>
    .search input.btn {
        width: 60px;
        height: 34px;
        padding: 0;
        border: 0 none;
        vertical-align: middle;
        outline: none;
        background-color: #E4E4E4;
    }
</style>
<section id="primary">
    <div id="content" role="main">
        <article class="post no-results not-found">
            <!-- .entry-header -->
            <div class="widget search">
                <p>${_res.notFound}</p>
                <form method="post" action="${rurl }search">
                    <input type="text" class="field" name="key" id="s" placeholder="${_res.searchTip}"/>
                    <input type="submit" class="btn" name="submit" value="${_res.search}"/>
                </form>
            </div>
        </article>
    </div>
</section>