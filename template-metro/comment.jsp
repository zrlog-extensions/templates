<c:forEach items="${log.comments}" var="comment">
<div class="media">
			<a class="pull-left" href="#">
			<img class="media-object" src="media/image/7.jpg" alt="">
			</a>
			<div class="media-body">
				<h4 class="media-heading">Media heading <span>2 days ago / <a href="#">Reply</a></span></h4>
				<p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. </p>
			</div>
		</div>
	</div>
</div>
</c:forEach>
  <ul class="comments">
  <div class="media-body">
  	<h4 class="media-heading">Media heading <span>July 5,2013 / <a href="#">Reply</a></span></h4>
  	<p>${comment.userComment}</p>
  </div>
	<li>	<p>${comment.userComment}</p>
<p class="small"><a rel="nofollow" href="${comment.userHome }">${comment.userName }</a> 在 ${comment.commTime }</p>
	</li></ul>

<div class="post-comment">
	<h3>Leave a Comment</h3>
	<form>
		<label>Name</label>
		<input type="text" class="span7 m-wrap">
		<label>Email <span class="color-red">*</span></label>
		<input type="text" class="span7 m-wrap">
		<label>Message</label>
		<textarea rows="8" class="span10 m-wrap"></textarea>
		<p><button type="submit" class="btn blue">Post a Comment</button></p>
	</form>
</div>