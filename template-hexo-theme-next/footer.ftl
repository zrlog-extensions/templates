</div>
</main>
<footer id="footer" class="footer">
    <div class="footer-inner">
        <div class="copyright">
            &copy;  2011 - <span>2017</span><span class="with-love"><i class="fa fa-heart"></i></span>
            <span class="author">IIssNan</span>
        </div>
        <div class="powered-by">
            由 <a class="theme-link" href="https://zrlog.com">ZrLog</a> 强力驱动
        </div>
        <div class="theme-info">
            主题 - <a class="theme-link" href="https://github.com/iissnan/hexo-theme-next">NexT.Pisces</a>
        </div>
    </div>
    <#if webs.icp?has_content>
    <div class="footer-inner">
        ${webs.icp}
    </div>
</#if>
<div style="display:none">
    ${webs.webCm}
</div>
</footer>
</div>
<script type="text/javascript">
    var NexT = window.NexT || {};
    if (Object.prototype.toString.call(window.Promise) !== '[object Function]') {
        window.Promise = null;
    }
</script>
<script type="text/javascript" src="${templateUrl}/js/jquery-1.10.2.min.js"></script>
<script>
    $('.site-nav-toggle button').on('click', function () {
        var $siteNav = $('.site-nav');
        var ON_CLASS_NAME = 'site-nav-on';
        var isSiteNavOn = $siteNav.hasClass(ON_CLASS_NAME);
        var animateAction = isSiteNavOn ? 'slideUp' : 'slideDown';
        var animateCallback = isSiteNavOn ? 'removeClass' : 'addClass';

        $siteNav.stop()[animateAction]('fast', function () {
            $siteNav[animateCallback](ON_CLASS_NAME);
        });
    });
</script>
<script type="text/javascript" src="${templateUrl}/js/utils.js?v=5.1.0"></script>
<script type="text/javascript" src="${templateUrl}/js/pisces.js?v=5.1.0"></script>
</body>
</html>
