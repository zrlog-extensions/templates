<#if log.canComment>
    <div id="comment" class="mt-10 bg-white dark:bg-gray-900 p-6 rounded shadow space-y-4">
        <#if website.changyan_status == "on">
                <plugin name="changyan" view="widget" param="articleId=${log.logId!''}"></plugin>
        <#else>
            <#if log.comments?has_content>
                <h2 class="text-2xl font-bold mb-4">${_res.comments}</h2>
            </#if>

            <#list log.comments as comment>
                <ul class="mb-4">
                    <li class="bg-white p-4 shadow rounded">
                        <p class="text-gray-800 mb-1">${comment.userComment}</p>
                        <p class="text-sm text-gray-500">
                            <a rel="nofollow"
                               class="text-primary hover:underline">${comment.userName}</a> ${_res.on} ${comment.commTime}
                        </p>
                    </li>
                </ul>
            </#list>

            <form action="/addComment" method="post">
                <input type="hidden" name="logId" value="${log.logId}">

                <h2 class="text-2xl font-bold mb-4">${_res.comment}</h2>

                <div>
                    <label for="userComment" class="block text-gray-700 font-medium mb-2">${_res.comment}</label>
                    <textarea required rows="6" cols="45" name="userComment" id="userComment"
                              class="w-full border border-gray-300 rounded p-3 focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                </div>

                <div>
                    <label for="web" class="block text-gray-700 font-medium mb-2">${_res.website}</label>
                    <input required type="text" name="web" id="web"
                           class="w-full border border-gray-300 rounded p-3 focus:outline-none focus:ring-2 focus:ring-blue-500"/>
                </div>

                <div>
                    <label for="userName" class="block text-gray-700 font-medium mb-2">${_res.userName}</label>
                    <input required type="text" name="userName" id="userName"
                           class="w-full border border-gray-300 rounded p-3 focus:outline-none focus:ring-2 focus:ring-blue-500"/>
                </div>

                <div>
                    <label for="email" class="block text-gray-700 font-medium mb-2">${_res.email}</label>
                    <input required type="text" name="email" id="email"
                           class="w-full border border-gray-300 rounded p-3 focus:outline-none focus:ring-2 focus:ring-blue-500"/>
                </div>

                <button type="submit"
                        class="mt-4 px-6 py-2 bg-primary text-white font-semibold rounded hover:bg-blue-700 transition">
                    ${_res.submit}
                </button>
            </form>
        </#if>
    </div>
</#if>