<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
    <hr>
    <footer>
            <div class="row text-center">
                <div class="col-md-12 footer-below">
                    <p>
                        ${_res.footerLink}
                    </p>
                    <p class="copyright">Copyright &copy; 2017 ${webs.title}</p>
                </div>
                <div class="col-md-12 footer-below">
                    <a href="${baseUrl}">${baseUrl}</a>
                </div>
            </div>
    </footer>
    <div style="display:none">${webs.webCm}</div>

    <script src="${url}/js/jquery.js"></script>
    <script src="${url}/js/bootstrap.min.js"></script>
    <script src="${url}/js/common.js"></script>
</body>
</html>