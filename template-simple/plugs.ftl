<div class="widget-area" id="secondary" role="complementary">
	<aside class="widget widget_recent_entries">
		<form id="searchform" action="${rurl}search" method="post">
			<label class="assistive-text" for="s">搜索</label>
			<input name="key" class="field" id="s" type="text" placeholder="请输入关键字" value="${key!''}"/>
			<input name="submit" class="submit" id="searchsubmit" type="submit"/>
		</form>
		<#if init.plugins?has_content>
			<#list init.plugins as plugin>
				<#if plugin.isSystem == false && pageLevel >= plugin.level>
					<div class="widget-title">
						<h3>${plugin.pTitle}</h3>
					</div>
					<p>${plugin.content}</p>
					<br />
				<#else>
					<#switch plugin.pluginName>
						<#case "types">
							<div class="widget-title">
								<h3>${plugin.pTitle}</h3>
							</div>
							<ul>
								<#list init.types as type>
									<li><a href="${type.url}">${type.typeName} (${type.typeamount})</a></li>
								</#list>
							</ul>
							<#break>
						<#case "archives">
							<div class="widget-title">
								<h3>${plugin.pTitle}</h3>
							</div>
							<ul>
								<#list init.archiveList as archive>
									<li><a href="${archive.url}" rel="nofollow">${archive.text} (${archive.count})</a></li>
								</#list>
							</ul>
							<#break>
						<#case "tags">
							<div class="widget-title">
								<h3>${plugin.pTitle}</h3>
							</div>
							<div class="taglist">
								<#list init.tags as tag>
									<a href="${tag.url}" title="${tag.text}上共有(${tag.count})文章">${tag.text}</a>
								</#list>
							</div>
							<#break>
						<#case "links">
							<div class="widget-title">
								<h3>${plugin.pTitle}</h3>
							</div>
							<ul>
								<#list init.links as link>
									<li><a href="${link.url}" title="${link.alt}" target="_blank">${link.linkName}</a></li>
								</#list>
							</ul>
							<#break>
						<#default>
					</#switch>
				</#if>
			</#list>
		</#if>
	</aside>
</div>