<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script id="paginateTemplate" type="x-tmpl-mustache">
<div class="col-xs-6">
    <div class="dataTables_info" id="dynamic-table_info" role="status" aria-live="polite">
        总共 {{total}} 中的 {{from}} ~ {{to}}
    </div>
</div>
    
<div class="col-xs-6">
    <div class="dataTables_paginate paging_simple_numbers" id="dynamic-table_paginate">
        <ul class="pagination">
            <li class="paginate_button previous {{^firstUrl}}disabled{{/firstUrl}}" aria-controls="dynamic-table" tabindex="0">
                <a href="#" data-target="1" data-url="{{firstUrl}}" class="page-action">首页</a>
            </li>
            <li class="paginate_button {{^beforeUrl}}disabled{{/beforeUrl}}" aria-controls="dynamic-table" tabindex="0">
                <a href="#" data-target="{{beforePageNo}}" data-url="{{beforeUrl}}" class="page-action">前一页</a>
            </li>
            <li class="paginate_button active" aria-controls="dynamic-table" tabindex="0">
                <a href="#" data-id="{{pageNo}}" >第{{pageNo}}页</a>
                <input type="hidden" class="pageNo" value="{{pageNo}}" />
            </li>
            <li class="paginate_button {{^nextUrl}}disabled{{/nextUrl}}" aria-controls="dynamic-table" tabindex="0">
                <a href="#" data-target="{{nextPageNo}}" data-url="{{nextUrl}}" class="page-action">后一页</a>
            </li>
            <li class="paginate_button next {{^lastUrl}}disabled{{/lastUrl}}" aria-controls="dynamic-table" tabindex="0">
                <a href="#" data-target="{{maxPageNo}}" data-url="{{lastUrl}}" class="page-action">尾页</a>
            </li>
        </ul>
    </div>
</div>
</script>

<script type="text/javascript">
    var paginateTemplate = $("#paginateTemplate").html();
    Mustache.parse(paginateTemplate);

    /**
     *
     * @param url 请求连接
     * @param total 当前条数
     * @param pageNo 当前页数
     * @param pageSize 每一页展示的行数
     * @param currentSize 当前页返回有多小航
     * @param idElement 放在那个元素里面
     * @param callback 回调函数
     *
     */
    function renderPage(url, total, pageNo, pageSize, currentSize, idElement, callback) {
        //向上取整（总数/页数）最大的页码数字
        var maxPageNo = Math.ceil(total / pageSize);
        //拼接参数如果已经有？了参数就继续往下接用&
        var paramStartChar = url.indexOf("?") > 0 ? "&" : "?";
        //从多小到多小（第一页-1）*0 +1（从第一条开始）/ （第二页-1）*每页展示行数+1
        var from = (pageNo - 1) * pageSize + 1;
        var view = {
            //防止越界
            from: from > total ? total : from,
            //到多小条，开始号码+当前显示条数-1
            to: (from + currentSize - 1) > total ? total : (from + currentSize - 1),
            total : total,
            pageNo : pageNo,
            maxPageNo : maxPageNo,
            nextPageNo: pageNo >= maxPageNo ? maxPageNo : (pageNo + 1),
            beforePageNo : pageNo == 1 ? 1 : (pageNo - 1),
            //第一页的url (如果是第一页，传空)
            firstUrl : (pageNo == 1) ? '' : (url + paramStartChar + "pageNo=1&pageSize=" + pageSize),
            //上一页的URL (如果是第一页，传空)
            beforeUrl: (pageNo == 1) ? '' : (url + paramStartChar + "pageNo=" + (pageNo - 1) + "&pageSize=" + pageSize),
            //下一页的url(如果是最后一页为空)
            nextUrl : (pageNo >= maxPageNo) ? '' : (url + paramStartChar + "pageNo=" + (pageNo + 1) + "&pageSize=" + pageSize),
            //最后一页url
            lastUrl : (pageNo >= maxPageNo) ? '' : (url + paramStartChar + "pageNo=" + maxPageNo + "&pageSize=" + pageSize)
        };
        //渲染指定元素
        $("#" + idElement).html(Mustache.render(paginateTemplate, view));

        //绑定点击事件
        $(".page-action").click(function(e) {
            e.preventDefault();
            $("#" + idElement + " .pageNo").val($(this).attr("data-target"));
            var targetUrl  = $(this).attr("data-url");
            if(targetUrl != '') {
                $.ajax({
                    url : targetUrl,
                    success: function (result) {
                        if (callback) {
                            callback(result, url);
                        }
                    }
                })
            }
        })
    }
</script>
