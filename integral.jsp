<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head lang="zh">
    <meta charset="utf-8">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="format-detection" content="telephone=no,email=no"/>
    <!-- <link rel="shortcut icon" href="${pageContext.request.contextPath}/{HOME_THEME_PATH}images/base/title.png"> -->
    <meta name="applicable-device" content="pc,mobile"/>
    <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/fastclick.js"></script>
    <script src="${pageContext.request.contextPath}/js/iscroll.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/integral.css">
    <script src="${pageContext.request.contextPath}/js/base.js"></script>
    <script>
      var chestCount = 38;//宝箱一共有38个
      var chainCount = 6;//链子
      var chestImageArray = new Array();
          // console.log(chestImageArray);

      var chainImageArray = new Array();
      var chestLeftArr = [10,35,20,-35,-10,-20,10,35,20,
        -35,-10,-20,10,35,20,-35,-10,-20,10,35,20,-35,-10,
        -20,10,35,20,-35,-10,-20,10,35,20,-35,-10,-20,10,
        35,20,-35,-10,-20,10,35,20,-35,-10];//坐标
      var userChestList = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]//锁是否打开
      var chestImageLoadTimer = null;//定时器
      var integralContentiScroll = '';
      var gok = 'http://gok.tc2stgs.com';
      var ticket_login = $_user.ticket;//用户的兑换张数
      var coin;
      var ticket;
      var chestId;
      var index;

      function gotoScroll(){//scroll插件
        integralContentiScroll = new IScroll('.page_body',{
            mouseWheel:true,
            scrollbars:false,
            bounce:false,
            click:iScrollClick()
        });
        var lastLockChest = $('.lock')[$('.lock').length-1];//灯源
        // console.log(k=lastLockChest);
        var clientHeight = parseInt($('.page_body').css('height'));
        // console.log(clientHeight);  //682
        var pageHeight = parseInt($('.page_content').css('height'));//总页面的高度
        //滚动到该元素的位置，第二个参数为时间，第三个第四个参数为偏移量（如果设置这两个参数为true，该元素将会显示在容器的中间）
        integralContentiScroll.scrollToElement(lastLockChest,0,0,pageHeight);
        integralContentiScroll.scrollToElement(lastLockChest,0,0,-clientHeight/2,IScroll.utils.ease.linear);

        bindLockBtn();
      }
      function page_onload(){
        loadChestImg();
        loadChainImg();
        getAllImgStatus();
      }
      //宝箱判断页面
      function bindLockBtn(){
        ticket_login = $_user.ticket;
        $(".integral_span").html(ticket_login)
            $('.lock').on('click',function(){
              var $that = $(this)
              coin = $(this).data("coin");
              ticket = $(this).data("ticket");
              chestId = $(this).data("id");
              index = chestCount - $('.lock').index(this);  //获取你点击时候的箱子
              // console.log(chestId);
              // console.log(ticket);
              // console.log(coin);
              $.ajax({
                url:'/integral/chestExchange?',
                type:'post',
                data:{'chestId':chestId},
                success:function(data){
                    console.log(data);
                    if(data.status == 1){
                        if( (parseInt(chestCount-chestId) == $('.lock').length-1) && (ticket_login >= ticket)){
                          $that.removeClass('lock');
                          $that.unbind('click');
                          alert("恭喜你,成功开启第"+chestId+"个宝箱");
                          }else{
                            alert('请开启前置宝箱')
                          }
                        }else{
                          alert(data.message)
                        }
                      }
                    })
                  });
                }

      function chainInit(){
        var chestList = $('.chest_box>div');
        for(var i = 0 ; i < chestList.length ; i++ ){
          if(chestList[i+1]){
            var chainWidth = chestLeftArr[i] - chestLeftArr[i+1];

            //chainType
            var chainType = 0 , chainLeft = 0;
            if(chestLeftArr[i] - chestLeftArr[i+1] < 0){
              chainLeft = 50 + chestLeftArr[i];//60 1
              chainType = Math.abs(chestLeftArr[i] - chestLeftArr[i+1]) < 20 ? 3 : 1;
              chainType = Math.abs(chestLeftArr[i] - chestLeftArr[i+1]) > 60 ? 5 : chainType;
            }else{
              // left
              chainLeft = 50 + chestLeftArr[i+1];
              chainType = Math.abs(chestLeftArr[i] - chestLeftArr[i+1]) < 20 ? 4 : 2;
              chainType = Math.abs(chestLeftArr[i] - chestLeftArr[i+1]) > 60 ? 6 : chainType;
            }
            //chainCSS
            ////margin-top
            var chainMarginTop = i == 0 ? parseInt($(chestList[i]).css('height'))/2 : 0;
            // margin-left
            var chainMarginLeft = 0//chestList[i].width/2;
            var chainHeight = (
                  parseInt($(chestList[i]).css('height')) + parseInt($(chestList[i+1]).css('height'))
                )/2;
            var chainWidth = Math.abs(chestLeftArr[i] - chestLeftArr[i+1]);
            //chainHtml
            var imghtml = "";
            imghtml += "<img ";
            imghtml += "style='left:"+chainLeft+"%;margin-top:"+chainMarginTop+"px;";
            imghtml += "margin-left:"+chainMarginLeft+"px;height:"+chainHeight+"px;width:"+chainWidth+"%;'";
            imghtml += " src='${pageContext.request.contextPath}/images/score_chestimg_ironChain_"+chainType+".png'/>"
            $('.chain_box').append(imghtml);
          }
        }
        gotoScroll();
      }
      function getAllImgStatus(){
        chestImageLoadTimer = setInterval(function(){
          if(chestImageArray.length >= chestCount + 1){//所有图片加载完毕
            clearInterval(chestImageLoadTimer);
            chestImageLoadTimer = null;
            chestInit();//宝箱位置初始化
           // chainInit();//链条位置初始化
          }
        },100);
      }
//宝箱函数
      function loadChestImg(){
        var callback = function(id,img){
          if(img.width){
            chestImageArray[id] = img;
          }
        }
        for(var i = 1 ; i <= chestCount ; i++){
          var chestimgurl = '${pageContext.request.contextPath}/images/score_chest_box'+i+'.png';
          preLoadImg(i,chestimgurl,callback);
        }
      }
// 链条函数
      function loadChainImg(){
        var callback = function(id,img){
          if(img.width){
            chainImageArray[id] = img;
          }
        }
        for(var i = 1 ; i <= chainCount ; i++){
          var chainimgurl = '${pageContext.request.contextPath}/images/score_chestimg_ironChain_'+i+'.png';
          preLoadImg(i,chainimgurl,callback);
        }
      }
      function preLoadImg(id,url,callback) {
        var img = new Image();
        img.src = url;
        if(img.complete) {
          callback(id,img);
          return;
        }
        img.onload = function(){
          callback(id,img);
        };
      }
// 渲染宝箱页面
      function chestInit() {
        $.ajax({
          url: '/integral/chestList',
          type: 'get',
          success: function (data) {
            console.log(data);
            for (var i = data.message.length - 1; i >= 0; i--) {
              var chestLeft = parseInt(chestLeftArr[data.message.length - 1 - i]);//遍历数组的每个值和坐标
              var imghtml = "";
              imghtml += "<div data-coin='"+data.message[i].coin+"' data-ticket='"+data.message[i].ticket+"' data-id='"+data.message[i].id;
              imghtml += "' style='left:" + chestLeft + "%'";
              if (data.message[i].enable == 1)
                imghtml += "class='lock'>";
              else
                imghtml += ">";
              imghtml += "<img src='" + data.message[i].img + "'/>";
              imghtml += "<span><img src='${pageContext.request.contextPath}/images/lock.png'/></span></div>";

              $('.chest_box').append(imghtml);
            }


            chainInit();//链条位置初始化
          }
        });

      }


    </script>
</head>
<body>
<div class="page_box">
  <div class='page_body'>

    <div class='page_content'>
    <p class="integral">积分:<span class="integral_span"></span></p>
      <div class='chest_box'>
        <!-- 宝箱 -->
      </div>
      <div class='chain_box'>
        <!-- 链条 -->
      </div>
    </div>
  </div>
</div>
</body>
</html>