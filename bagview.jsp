<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head lang="zh">
    <meta charset="utf-8">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="format-detection" content="telephone=no,email=no"/>
    <!-- <link rel="shortcut icon" href="{HOME_THEME_PATH}images/base/title.png"> -->
    <meta name="applicable-device" content="pc,mobile"/>
    <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/iscroll.js"></script>
    <script src="${pageContext.request.contextPath}/js/swiper.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/fastclick.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bag.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/swiper.min.css"><!--
    <link rel="stylesheet" href="css/imageflow.css"> -->
    <script src='${pageContext.request.contextPath}/js/numberAnimate.js'></script><!--
    <script src='js/imageflow.js'></script> -->
    <script src="${pageContext.request.contextPath}/js/base.js"></script>
    <script type="text/javascript">
        var bagContentiScroll = '';
        function page_onload(){
            //initPage();
            AjaxBag();
            bagContentiScroll = new IScroll('.page_body',{
                mouseWheel:true,
                scrollbars:false,
                bounce:false,
                click:iScrollClick()
            });
        $('.pop_conform').on('click',function(){
            $('.shop_popups').hide();
            window.location.href = "game.jsp"
        })
        }

    function AjaxBag(){//获取结果接口
        var bodyview = $('.bag_body .person>ul');
        bodyview.html('');
        $.ajax({
            url:"/trade/knapsackdisplay",
            type:'GET',
            success: function(data){
                var isGetAll = data.indexOf(0) < 0;
                var minNum = eval("Math.min(" + data.split(',').toString() + ")");
                var html_ul = '';
                //alert(isGetAll);
                //isGetAll = 1;
                if(isGetAll){
                    for(var i = 0; i < minNum ; i++){
                        html_ul += "<li class='selected'>";
                        html_ul += "<img src='/images/mine-person-bg1.png' class='four-angle'>";
                        html_ul += "<div class='person-top'>";
                        html_ul += "<img src='/images/mine-person_12.png'>";
                        html_ul += "</div>";
                        html_ul += "<div class='person-top1'>";
                        html_ul += "<img src='/images/mine-person-bg2.png'>";
                        html_ul += "<div class='line'></div>";
                        html_ul += "<div class='collect-all'>已集齐</div>";
                        html_ul += "<div class='hero'>";
                        html_ul += "<div class='hero-main'>";
                        html_ul += "<img src='/images/mine-person-hero.png'>";
                        html_ul += "</div>";
                        html_ul += "</div>";
                        html_ul += "<a href='javascript:;' class='click-all'>";
                        html_ul += "<div class='click' style='line-height:22px;'>点击兑换</div>";
                        html_ul += "</a>";
                        html_ul += "</div>";
                        html_ul += "</li>";
                    }

                }
                data = data.split(',');
                for(var i = 0;i<data.length;i++){
                    if( data[i] - minNum == 0 ){
                        html_ul += '<li>';
                    }else{
                        html_ul += '<li class="on">';
                    }
                    html_ul += '<img src="/images/mine-person-bg1.png" class="four-angle">';
                    html_ul += '<div class="person-top">';
                    html_ul += '<img src="/images/mine-person_0'+(i+1)+'.png">';
                    if(data[i] - minNum <=1){
                        html_ul += '<div class="name-bg">'+heroOptionArray[i][1]+'</div>';
                    }else{
                        html_ul += '<div class="name-bg">'+heroOptionArray[i][1]+'<a style="color:white;">x'+( data[i] - minNum )+'</a></div>';
                    }
                    html_ul += '<div class="line"></div>';
                    html_ul += '</div>';
                    html_ul += '<div class="person-top1">';
                    html_ul += '<img src="/images/mine-person-bg2.png">';
                    html_ul += '</div>';
                    html_ul += '<div class="shade">';
                    html_ul += '<div class="shade-title">';
                    html_ul += '<div class="lock-main">';
                    html_ul += '<img src="/images/mine-person-lock.png">';
                    html_ul += '</div>';
                    html_ul += '<p>'+heroOptionArray[i][1]+'</p>';
                    html_ul += '</div>';
                    html_ul += '</div>';
                    html_ul += '</li>';
                }
                bodyview.html(html_ul);
                setTimeout(function(){
                    bagContentiScroll.refresh();
                },200)
            },
            error: function(e){
                errorMsg('网络错误,请稍后再试');
            }
        });
        $('.person').on('click','.click',function(){
               $.ajax({
                    url:'/integral/KnapsackHeroOpen',
                    type:'get',
                    success:function(data){
                        console.log(data);
                        if(data.status == 1){
                            $('.shop_popups').show();
                            $(".selected").remove();

                        }else{
                            errorMsg(data.message)
                            }
                        },
                    error: function(e){
                        errorMsg('网络错误,请稍后再试');
                    }
                })

            })

    }
    </script>
</head>
    <body onselectstart="return false;" oncontextmenu="self.event.returnValue=false;">
    <!--<div class='loadingbox' id='loadingbox'>
        <img src="images/game_logo.png"/>
        <span>LOADING</span>
    </div>-->
    <div class='page_box'>
      <div class="shop_popups">
                <div class="shop_popups_once">
                        <p>英雄卡兑换</p>

                        <p>恭喜兑换成功！获得<span style="color:#f1de84">1880</span>!</p>
                     <div>
                            <a class="pop_conform">确定</a>
                    </div>
                </div>
      </div>
        <div class='page_bg'>
            <img src="${pageContext.request.contextPath}/images/vip_bg.jpg"/>
        </div>
        <div class='page_body'>
            <div class='page_content'>
                <div class='bag_body'>
                    <!----------BAG START------------>
                    <div class="person">
                            <ul>
                            </ul>
                    </div>
                    <!----------BAG END------------>
                </div>
            </div>
        </div>
    </div>
    </body>
</html>