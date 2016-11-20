<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<script src="assets/js/jquery.liteuploader.min.js"></script>
<script>
	$(document).ready(function() {
		$('.fileUpload').liteUploader({
			script : 'api/admin/upload?dir=image'
		}).on('lu:success', function(e, response) {
			$('.file-name').attr("data-title", response.url)
			$("#logo").val(response.url);
			$("a .remove").remove();
		});
		$("#template").click(function(e){
		  $.post('api/admin/template/setting',$("#template-form").serialize(),function(data){
              if(data.error == 0){
                  var message;
                  if(data.message!=null && data.message!=''){
                      message = data.message;
                  }else{
                      message = "操作成功...";
                  }
                  new PNotify({
                        title: message,
                        type: 'success',
                        delay:3000,
                        hide: true,
                        styling: 'bootstrap3'
                  });
              }else{
                  var message;
                  if(data.message!=null && data.message!=''){
                      message = data.message;
                  }else{
                      message = "发生了一些异常...";
                  }
                  new PNotify({
                        title: message,
                        delay:3000,
                        type: 'error',
                        hide: true,
                        styling: 'bootstrap3'
                   });
              }
          });
		});
	});
</script>

<form id="template-form" class="form-horizontal">
    <input type="hidden" name="template" value="${template}">
    <div class="form-group row">
        <label
            class="col-sm-3 control-label no-padding-right"> Slogan </label>

        <div class="col-sm-9">
            <input type="text" name="slogan" value="${_res.slogan}"
                class="form-control col-xs-10 col-sm-5" placeholder=""
               >
        </div>
    </div>

    <div class="form-group row">
        <label
            class="col-sm-3 control-label no-padding-right"> 网名 </label>

        <div class="col-sm-9">
            <input type="text" name="internetName" value="${_res.internetName}"
                class="form-control col-xs-10 col-sm-5" placeholder=""
               >
        </div>
    </div>

    <div class="form-group row">
        <label
            class="col-sm-3 control-label no-padding-right"> GitHub链接 </label>

        <div class="col-sm-9">
            <input type="text" name="githubLink" value="${_res.githubLink}"
                class="form-control col-xs-10 col-sm-5" placeholder=""
               >
        </div>
    </div>
    <div class="form-group row">
        <label
            class="col-sm-3 control-label no-padding-right"> zhihu链接 </label>

        <div class="col-sm-9">
            <input type="text" name="zhihuLink" value="${_res.zhihuLink}"
                class="form-control col-xs-10 col-sm-5" placeholder=""
               >
        </div>
    </div>



    <div class="form-group row">
        <label
            class="col-sm-3 control-label no-padding-right">
            网站&nbsp;Logo </label>
        <div class="col-sm-7">
            <input id="logo" class="form-control col-sm-10" name="avatar" value="${_res.avatar}">
            <label for="logo" class="custom-file-upload">
                ${_res['upload']}
            </label>
            <input type="file" class="fileUpload icon-upload-alt" name="imgFile" value="" />
        </div>
    </div>
    <div class="ln_solid"></div>
    <div class="form-group row">
        <div class="col-md-offset-3 col-md-9">
            <button id="template" type="button" class="btn btn-info">
                <i class="icon-check bigger-110"></i> 提交
            </button>
        </div>
    </div>
</form>
${pageEndTag}