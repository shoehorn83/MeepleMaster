<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!-- 以上自行取用 -->
<!--通常給別人include，自己不需要這個，不然會有兩次  <趴小老鼠include file="../common_link.jsp"趴>  -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link href="${root}/css/friend/friendList.css" rel="stylesheet">
<jsp:include page="friendButtonControll.jsp"></jsp:include>
</head>
<body>
	<button onclick="showFriendList()">朋友列表</button>
	<div id="friendList" class="friendList">
		<div class="onlineFriend">
			
		</div>
		<div class="offlineFriend">
			
		</div>
		<div class="showNumberOfFriendInvite" onclick="showFriendInviteList()"><span>顯示好友邀請數量出問題啦</span></div>
		<div class="unComfirmedInvite">
			
		</div>
		
	</div>
	
	
	
	
	<div class="dialogBox">
		<div class="chat_container">
    <div id="myChatList" class="chat_list">
		<!-- 放tag的 -->
    </div>
    <div class="chat_box">
      <div id="chatRoom" class="chat_message">
			<!-- 放聊天內容的 -->
      </div>
      <div class="chat_input">
        <div class="myIcon2 iconTag">
          <i class="fa fa-smile-o ipt_icon"></i>
          <div class="icon_block">
            <div class="emoji_icon" onclick="useSticker(1)">
              <img src="${root}/img/michael/chatRoom/emoji/cry.png" alt="">
            </div>
            <div class="emoji_icon" onclick="useSticker(2)">
              <img src="${root}/img/michael/chatRoom/emoji/cry2.png" alt="">
            </div>
            <div class="emoji_icon" onclick="useSticker(3)">
              <img src="${root}/img/michael/chatRoom/emoji/I_dont_know.jpg" alt="">
            </div>
            <div class="emoji_icon" onclick="useSticker(4)">
              <img src="${root}/img/michael/chatRoom/emoji/like.png" alt="">
            </div>
            <div class="emoji_icon" onclick="useSticker(5)">
              <img src="${root}/img/michael/chatRoom/emoji/like2.png" alt="">
            </div>
            <div class="emoji_icon" onclick="useSticker(6)">
              <img src="${root}/img/michael/chatRoom/emoji/omg.png" alt="">
            </div>
            <div class="emoji_icon" onclick="useSticker(7)">
              <img src="${root}/img/michael/chatRoom/emoji/robot-face.png" alt="">
            </div>
            <div class="emoji_icon" onclick="useSticker(8)">
              <img src="${root}/img/michael/chatRoom/emoji/smile.png" alt="">
            </div>
            <div class="emoji_icon" onclick="useSticker(9)">
              <img src="${root}/img/michael/chatRoom/emoji/strange.png" alt="">
            </div>
            <div class="emoji_icon" onclick="useSticker(10)">
              <img src="${root}/img/michael/chatRoom/emoji/what.jpg" alt="">
            </div>
            <div class="emoji_icon" onclick="useSticker(11)">
              <img src="${root}/img/michael/chatRoom/emoji/wow.png" alt="">
            </div>
          </div>
        </div>
        <input class="sendMsg" type="text" placeholder="請輸入訊息">
        <div class="myIcon2" onclick="sendMessage()">
          <i class="fa fa-share send_icon"></i>
        </div>
      </div>
    </div>
  </div>
 	</div>
	<div class="controllerDialogBox closedChatRoom" onclick="openCloseChatRoom()">
		<span>聊天室</span>
	</div>
	
	<div class="getNewMessage">
		<span >new message!</span>
	</div>
	
	
	<script>
		//直接執行的
		
		//製作聊天室tag
		chatTagWhenLogin();
		$(".getNewMessage").hide();
		//製作未確認好友邀請
		findFriendInvite();
		var isSelectedPage;

		
		var ws = new WebSocket("ws://localhost:8080${root}/michael/websocket/${member.memberEmail}");
		
		ws.onopen = function(){
			console.log("friend的${member.memberEmail}");
			localStorage.setItem("key","value");
			console.log(localStorage.getItem("key"));
			
		}
		
		
		ws.onclose = function(){
			console.log("onclose發動");
		}
//		//接收訊息時
		ws.onmessage = function(message){
			console.log("有收到訊息:",message);
			var json = JSON.parse(message.data)
			var action = json.action;
//			if(新增刪除好友){
//				refleshFriendContent();
//		}
			if("onOfflineFriend"==action){
				refleshFriendContent(json);
			}
			if("someoneLogin"==action){
				let email = json.loginer;
				email = email.replace('@','').replace('.','');
				let name = $("#"+email).text();
				$("#"+email).closest(".container").remove();
				$(".onlineFriend").append(`
							<div class="container text-center">
								<div class="row">
									<div class="col-3 circleFather"><div class="onlineCircle"></div></div>
									<div class="col-3"><img class="memberImg" src="http://localhost:8080/meeple-masters/member/emailFindMemberImg/`+json.loginer+`" alt=""></div>
									<div class="col-3">
										<span id="`+ email +`">`+ name +`</span>
									</div>
									<div class="col-3">
										<button id="`+ name +`button" name="`+ email +`" onclick="pressChatButton(this.id,this.name)">傳送訊息</button>
									</div>
								</div>
							</div>
							`);
			}
			if("someoneLogout"==action){
				let email = json.logouter;
				email = email.replace('@','').replace('.','');
				let name = $("#"+email).text();
				$("#"+email).closest(".container").remove();
				$(".offlineFriend").append(`
						<div class="container text-center">
						<div class="row">
							<div class="col-3 circleFather"><div class="offlineCircle"></div></div>
							<div class="col-3"><img class="memberImg" src="http://localhost:8080/meeple-masters/member/emailFindMemberImg/`+json.logouter+`" alt=""></div>
							<div class="col-3">
								<span id="`+ email +`">`+ name +`</span>
							</div>
							<div class="col-3">
								<button id="`+ name +`button" name="`+ email +`" onclick="pressChatButton(this.id,this.name)">傳送訊息</button>
							</div>
						</div>
					</div>
					`);
			}
			if("getMessage" == action){
				//如果聊天室視窗不是打開狀態，就顯示有新訊息
				if($(".controllerDialogBox").hasClass("closedChatRoom")){
					$(".getNewMessage").show();
				}
				//重新製作tag
				//如果本來就在，把本來的刪掉
				let idTag = changeToIdType(json.sender)+"tag";
				//傳訊息來的人本來就是active
				if($("#"+idTag).length != 0 && $("#"+idTag).hasClass("active")){
					$("#"+idTag).remove();
					makeChatTag(json.sender,json.senderName,0);
					changeToActive($(".active")[0].id);
				//傳訊息來的人本來存在列表內，但是不是active
				}else if($("#"+idTag).length != 0){
					$("#"+idTag).remove();
					makeChatTag(json.sender,json.senderName,json.notRead);
					$(".chatListTag")[0].classList.remove("active");
				//傳訊息來的人本來不在列表內
				}else{
					//如果原本有active存在，要拿掉自己的active
					if($(".active").length != 0){
						makeChatTag(json.sender,json.senderName,json.notRead);
						$(".chatListTag")[0].classList.remove("active");
					}
					//我就是active，並且要更新已讀，秀出右邊頁面
					makeChatTag(json.sender,json.senderName,0);
					changeToActive($(".active")[0].id);
				}
				//把active的show畫面
				showChatContent(changeToOriginEmail($(".active")[0].id.replace("tag","")));
				//呼叫資料庫更新順序
				updateChatRoomOrder();
			}
			//收到有人刪除與我的好友關係
			if("someoneDeleteFriendWithYou" == action){
				let theOtherEmail = changeToIdType(json.theOther);
				let idTypeTag = theOtherEmail+"tag";
				$("#"+theOtherEmail).closest(".container").remove();
				if($("#"+idTypeTag).length != 0){
					$("#"+idTypeTag).remove();
				}
				updateChatRoomOrder();
				//如果他剛好是active，就重新給active並更新右邊畫面
				if($(".active").id == idTypeTag){
					theIsActive = true;
				}
				//重給active並更新畫面
				if($(".chatListTag").length != 0){
					$(".chatListTag")[0].classList.add("active");
					showChatContent(changeToOriginEmail($(".chatListTag")[0].id.replace("tag","")));
				}else{
					$("#chatRoom").empty();							
				}
				//如果剛好在看對方的頁面，就變更按鈕
				if(isSelectedPage==true){
					$(".friendButtonDiv").empty();
					$(".friendButtonDiv").append(`
							<button onclick="sendFriendInvite('${member.memberEmail}','`+json.theOther+`')">加好友</button>
							`);
				}
			}
			//收到有人取消邀請
			if("someoneDeleteFriendInviteWithYou" == action){
				//如果剛好在看對方的頁面，就變更按鈕
				if(isSelectedPage==true){
					$(".friendButtonDiv").empty();
					$(".friendButtonDiv").append(`
							<button onclick="sendFriendInvite('${member.memberEmail}','`+json.theOther+`')">加好友</button>
							`);
				}
				//更新好友邀請欄
				findFriendInvite();
			}
			//我確認別人的邀請後，回傳對方資料，以製作好友欄
			if("addFriend" == action){
				if(json.isOnline == true){
					let email = json.newFriendEmail;
					email = email.replace('@','').replace('.','');
					let name = json.newFriendName;
					$(".onlineFriend").append(`
								<div class="container text-center">
									<div class="row">
										<div class="col-3 circleFather"><div class="onlineCircle"></div></div>
										<div class="col-3"><img class="memberImg" src="http://localhost:8080/meeple-masters/member/emailFindMemberImg/`+json.newFriendEmail+`" alt=""></div>
										<div class="col-3">
											<span id="`+ email +`">`+ name +`</span>
										</div>
										<div class="col-3">
											<button id="`+ name +`button" name="`+ email +`" onclick="pressChatButton(this.id,this.name)">傳送訊息</button>
										</div>
									</div>
								</div>
								`);
				}
				if(json.isOnline != true){
					let email = json.newFriendEmail;
					email = email.replace('@','').replace('.','');
					let name = json.newFriendName;
					$(".offlineFriend").append(`
							<div class="container text-center">
							<div class="row">
								<div class="col-3 circleFather"><div class="offlineCircle"></div></div>
								<div class="col-3"><img class="memberImg" src="http://localhost:8080/meeple-masters/member/emailFindMemberImg/`+json.newFriendEmail+`" alt=""></div>
								<div class="col-3">
									<span id="`+ email +`">`+ name +`</span>
								</div>
								<div class="col-3">
									<button id="`+ name +`button" name="`+ email +`" onclick="pressChatButton(this.id,this.name)">傳送訊息</button>
								</div>
							</div>
						</div>
						`);
				}
			}
			//對方確認了我的邀請，更新好友欄、邀請欄，及按鈕
			if("someoneConcirmFriendInvite" == action){
				let email = json.theOther;
				email = email.replace('@','').replace('.','');
				let name = json.theOtherName;
				$(".onlineFriend").append(`
							<div class="container text-center">
								<div class="row">
									<div class="col-3 circleFather"><div class="onlineCircle"></div></div>
									<div class="col-3"><img class="memberImg" src="http://localhost:8080/meeple-masters/member/emailFindMemberImg/`+json.theOther+`" alt=""></div>
									<div class="col-3">
										<span id="`+ email +`">`+ name +`</span>
									</div>
									<div class="col-3">
										<button id="`+ name +`button" name="`+ email +`" onclick="pressChatButton(this.id,this.name)">傳送訊息</button>
									</div>
								</div>
							</div>
							`);
				$(".friendButtonDiv").empty();
				$(".friendButtonDiv").append(`
						<button onclick="pressChatButton('`+buttonTypeName+`','`+idTypeEmail+`')">傳送訊息</button>
						<button onclick="deleteFriend('${member.memberEmail}','`+json.theOther+`')">刪除好友</button>
						`)
				//更新好友邀請欄
				findFriendInvite();
			}
			//有人送好友邀請給我
			if("someoneAddFriendInviteToYou" == action){
				//如果剛好在看對方的頁面，就變更按鈕
				if(isSelectedPage==true){
					$(".friendButtonDiv").empty();
					$(".friendButtonDiv").append(`
							<button onclick="acceptFriendInvite('${member.memberEmail}','`+json.theOther+`')">接受邀請</button>
							<button onclick="rejectFriendInvite('${member.memberEmail}','`+json.theOther+`')">拒絕邀請</button>
							`);
				}
				//更新好友邀請欄
				findFriendInvite();
			}
			
			
			
			
			
			
		}

		
		
//		//控制聊天室開關
		$(".dialogBox").hide();
		function openCloseChatRoom(){
			//關閉有新訊息視窗
			$(".getNewMessage").hide();
			$(".controllerDialogBox").toggleClass("closedChatRoom").toggleClass("openChatRoom");
			if($(".controllerDialogBox").hasClass("closedChatRoom")){
				$(".dialogBox").hide();
			}
			if($(".controllerDialogBox").hasClass("openChatRoom")){
				$(".dialogBox").show();
			}
			//把滾輪調到最下面
			let height = $("#chatRoom")[0].scrollHeight;
			$("#chatRoom").scrollTop(height);
		}
		
		
//		//控制好友列表開關
		var isFriendListShow = false;
		$("#friendList").hide();
		function showFriendList(){
			if(isFriendListShow==false){
				$("#friendList").show();
				isFriendListShow = true;
			}else{
				$("#friendList").hide();
				isFriendListShow = false;
			}
		}
		
		
//		//顯示好友邀請的開關
		$(".unComfirmedInvite").hide();
		var isFriendInviteListShow = false;
		function showFriendInviteList(){
			if(isFriendInviteListShow==false){
				$(".unComfirmedInvite").show();
				isFriendInviteListShow = true;
			}else{
				$(".unComfirmedInvite").hide();
				isFriendInviteListShow = false;
			}
		}
		
		
		
		
		
//		//重新製作線上離線好友清單
		function refleshFriendContent(json){
			var onlineKeyArray = Object.keys(json.onlineFriend);
			var offlineKeyArray = Object.keys(json.offlineFriend);
			var onlineValueArray = Object.values(json.onlineFriend); //取key的方法是keys()
			var offlineValueArray = Object.values(json.offlineFriend);
			$(".onlineFriend").empty();
			$(".offlineFriend").empty();
			$(".onlineFriend").append('<h3>線上</h3>');
			for(let i = 0;i<onlineValueArray.length;i++){
				$(".onlineFriend").append(`
						<div class="container text-center">
							<div class="row">
								<div class="col-3 circleFather"><div class="onlineCircle"></div></div>
								<div class="col-3"><img class="memberImg" src="http://localhost:8080/meeple-masters/member/emailFindMemberImg/`+onlineKeyArray[i]+`" alt=""></div>
								<div class="col-3">
									<span id="`+ onlineKeyArray[i].replace('@','').replace('.','') +`">`+ onlineValueArray[i] +`</span>
								</div>
								<div class="col-3">
									<button id="`+ onlineValueArray[i].replace('@','').replace('.','') +`button" name="`+ onlineKeyArray[i].replace('@','').replace('.','') +`" onclick="pressChatButton(this.id,this.name)">傳送訊息</button>
								</div>
							</div>
						</div>
						`);
				
			}
			$(".offlineFriend").append('<h3>離線</h3>');
			for(let i = 0;i<offlineValueArray.length;i++){
				$(".offlineFriend").append(`
						<div class="container text-center">
						<div class="row">
							<div class="col-3 circleFather"><div class="offlineCircle"></div></div>
							<div class="col-3"><img class="memberImg" src="http://localhost:8080/meeple-masters/member/emailFindMemberImg/`+offlineKeyArray[i]+`" alt=""></div>
							<div class="col-3">
								<span id="`+ offlineKeyArray[i].replace('@','').replace('.','') +`">`+ offlineValueArray[i] +`</span>
							</div>
							<div class="col-3">
								<button id="`+ offlineValueArray[i].replace('@','').replace('.','') +`button" name="`+ offlineKeyArray[i].replace('@','').replace('.','') +`" onclick="pressChatButton(this.id,this.name)">傳送訊息</button>
							</div>
						</div>
					</div>
					`);
				
			}
		}
		
		
		
//		//按下好友列聊天按鈕，更新聊天室樣子
		var receiver;
		function pressChatButton(buttonId,userEmailStr){
			//如果聊天室是關閉狀態，就打開他
			$(".controllerDialogBox").removeClass("closedChatRoom").addClass("openChatRoom");
			if($(".controllerDialogBox").hasClass("openChatRoom")){
				$(".dialogBox").show();
			}
			//先將傳來的參數變回可閱讀的名字跟原本的email樣子
			let userName = buttonId.replace("button","");
			receiver = userEmailStr.replace("com",".com").replace("gmail","@gmail");
			
			//呼叫資料庫更新已讀
			haveRead(receiver);
			
			//判斷此聊天對象是否已存在
			if($("#"+userEmailStr+"tag").length>0){
				//若存在就先刪掉，重新新增到第一位
				$("#"+userEmailStr+"tag").remove();
			}
			//先將目前active關掉
			$(".active").removeClass("active");
			
			let notReadNum = 0;
			//執行製作tag
			makeChatTag(receiver,userName,notReadNum);
			//執行傳聊天順序給資料庫
			updateChatRoomOrder();
			//顯示右邊聊天內容
			showChatContent(receiver);
			
		}


		var fork = false;
//		//按下關閉按鈕後關閉聊天室窗
		function removeTag(obj){
			//用來判斷被關掉的視窗是不是有active，目前正在用的視窗
			let controll = false;
			//我按下的叉叉就是目前的active
			if( $("#"+obj.closest(".chatListTag").id).hasClass("active") ){
				controll = true;
			}
			$("#"+obj.closest(".chatListTag").id).remove();
			//如果沒有任何chatListTag元素了下面就不用執行
			if($(".chatListTag").length==0){
				controll = false;
				$("#chatRoom >div").remove();
			}
			//接上面，是的話就把新的第一個變成使用中
			if(controll){
				$(".chatListTag:eq(0)").addClass("active");
				let userEmail = $(".chatListTag:eq(0)")[0].id.replace("com",".com").replace("gmail","@gmail").replace("tag","");
				//呼叫後端顯示右邊的聊天內容
				showChatContent(userEmail);
			}
			if($(".personalMessage").length == 0){
				$("#chatRoom >div").remove();
			}
			updateChatRoomOrder();
			//控制按下叉叉後就不要執行按div的方法
			fork = true;
			
			
		}
		
//		//呼叫後端紀錄目前聊天室排序情形
		function updateChatRoomOrder(){
			let chatListTagArray =  $(".chatListTag");
			let chatToWhomArray = [];
			let chatOrderArray = [];
			for(let i = 0;i<chatListTagArray.length;i++){
				if("" != $(".chatListTag")[i].id){
					chatToWhomArray.push($(".chatListTag")[i].id.replace("tag","").replace("com",".com").replace("gmail","@gmail"));
					chatOrderArray.push(i+1);
				}
			}
			let onclose = {
					"owner":"${member.memberEmail}",
					"chatToWhom":chatToWhomArray,
					"chatOrder":chatOrderArray
			}
			//用了反而傳出去怪怪的let requsetBody = JSON.stringify(onclose);
			
			
			axios.post("http://localhost:8080/meeple-masters/chatRoomOrder/reflesh",onclose).then(function(response){
				
			}).catch(function(error){
				
			}).finally(function(){
				
			});
		}
		
		
//		//切換active
		function changeToActive(userEmailInId){
			//更新資料庫是否已讀
			let theOther = changeToOriginEmail(userEmailInId.replace("tag",""));
			haveRead(theOther);
			//將畫面未讀顯示成已讀
			$("#"+userEmailInId).append(`
					<div class="close_tag" onclick="removeTag(this)"><img class="close_tag" src="${root}/img/michael/x.png" alt=""></div>
					`)
			$("#"+userEmailInId+">.msg_num").remove();
			//好像刪錯什麼東西，之後檢查一下
			if(fork == true){
				fork = false;
				return;
			}
			let userEmail = userEmailInId.replace("com",".com").replace("gmail","@gmail").replace("tag","");
			//判斷是否還有chatListTag元素存在，若沒有下面就不用做了(先刪除才做這個方法，所以不用判斷刪除的問題)
			let controll = true;
			if($(".chatListTag").length==0){
				controll = false;
			}
			if($(".chatListTag").hasClass("active") && controll){
				$(".active").removeClass("active");
				$("#"+userEmailInId).addClass("active");
			}
			//呼叫後端顯示右邊的聊天內容
			showChatContent(userEmail);
			//清空輸入欄位
			$(".sendMsg").val("");
		}
		
//		//上線時按照順序製作tag清單
		function chatTagWhenLogin(){
			axios.get("http://localhost:8080/meeple-masters/chatRoomOrder/findByFkOwner?owner=${member.memberEmail}").then(function(response){
				console.log("上線時的",response);
				let responseArray = response.data;
				if(responseArray.length == 0){
					return;
				}
				let notReadNum = 0;
				for(let i = 0;i<responseArray.length;i++){
					let memberEmail = responseArray[responseArray.length-1-i].chatToWhom;
					let userName = responseArray[responseArray.length-1-i].chatToWhomName;
					let notReadNum = responseArray[responseArray.length-1-i].notRead;
					makeChatTag(memberEmail,userName,notReadNum);
					//除了第一位其他都移除active
					if(i != responseArray.length-1){
						$(".chatListTag")[0].classList.remove("active");
					}
					//顯示右邊聊天畫面
					if(i == responseArray.length-1){
						let memberEmail = changeToOriginEmail($(".chatListTag")[0].id.replace("tag",""))
						showChatContent(memberEmail);
					}
				}
				//active的人要秀畫面
				changeToActive($(".active")[0].id);
				//排序完後傳到資料庫
				updateChatRoomOrder();
			}).catch(function(error){
				console.log("上線時製作tag出錯啦",error);
			}).finally(function(){
				
			});
		}
		
		
//		//傳送貼圖
		function useSticker(stickerId){
			let idType = ""+$(".active")[0].id.replace("tag","");
			let responseJson = {
					"sender":"${member.memberEmail}",
					"receiver":changeToOriginEmail(idType),
					"messageType":2,
					"messageText":null,
					"messageSticker": stickerId
			}
			axios.post("http://localhost:8080/meeple-masters/friendMessage/insertFriendMessage",responseJson).then(function(response){
				console.log("按下傳送貼圖時",stickerId);
				//重新製作右邊聊天室內容
				showChatContent(changeToOriginEmail(idType));
				//清空input
				$(".sendMsg").val("");
				//變成最上面的tag
				let userName = $(".active>.mytext>.name").text();
				$(".active").remove();			
				makeChatTag(changeToOriginEmail(idType),userName,0);
				//傳訊息給後端告訴後端我有傳訊息給朋友
				let info = {
					"action":"sendMessage",
					"receiver":changeToOriginEmail(idType)
				}
				ws.send(JSON.stringify(info));
			}).catch(function(error){
				console.log("按下傳送按鈕時",error);
			}).finally(function(){
				
			});
		}
		
//		//按下傳送按鈕後
		function sendMessage(){
			//內容為空就不發動
			if("" == $(".sendMsg").val()){
				return;
			}
			let idType = ""+$(".active")[0].id.replace("tag","");
			let responseJson = {
					"sender":"${member.memberEmail}",
					"receiver":changeToOriginEmail(idType),
					"messageType":1,
					"messageText":$(".sendMsg").val(),
					"messageSticker": null
			}
			axios.post("http://localhost:8080/meeple-masters/friendMessage/insertFriendMessage",responseJson).then(function(response){
				console.log("按下傳送按鈕時",response);
				//重新製作右邊聊天室內容
				showChatContent(changeToOriginEmail(idType));
				//清空input
				$(".sendMsg").val("");
				//變成最上面的tag
				let userName = $(".active>.mytext>.name").text();
				$(".active").remove();			
				makeChatTag(changeToOriginEmail(idType),userName,0);
				//傳訊息給後端告訴後端我有傳訊息給朋友
				let info = {
					"action":"sendMessage",
					"receiver":changeToOriginEmail(idType)
				}
				ws.send(JSON.stringify(info));
			}).catch(function(error){
				console.log("按下傳送按鈕時",error);
			}).finally(function(){
				
			});
		}
		
//		//在輸入框按下enter就送出
		$('.sendMsg').keypress(function(e) {
	        var key = window.event ? e.keyCode : e.which;
	        if (key == 13){
	        	if("" != $(".sendMsg").val()){
	        		sendMessage();
	        	}	        	
	        }
	    });
		
		
//		//呼叫後端顯示右邊的聊天內容
		function showChatContent(userEmail){ //參數為轉換成有@的Email
			if($(".personalMessage").length==0){
				return;
			}
			axios.get("http://localhost:8080/meeple-masters/friendMessage/findPersonalMessage?sender="+userEmail+"&receiver=${member.memberEmail}",).then(function(response){
				console.log("顯示右邊畫面",response);
				let responseArray = response.data;
				$("#chatRoom >div").remove();
				for(let i = 0;i<responseArray.length;i++){
					let date = responseArray[i].createdDate.substring(0,19);
					
					//判斷是誰傳的
					if("${member.memberEmail}" == responseArray[i].sender){ //我發的訊息
						//判斷是貼圖還是文字
						if(responseArray[i].stickerId == null){ //是文字
							$("#chatRoom").append(`
									<div class="message_row you-message">
					         			 <div class="message-content">
					           				<div class="message-text">`+ responseArray[i].text  +`</div>
					            			<div class="message-time">`+ date.substring(5,16).replace("-","/")  +`</div>
					          			</div>
					        		</div>
									`)
						}else{ //是貼圖
							$("#chatRoom").append(`
					        	<div class="message_row you-message">
					          		<div class="message-content">
					            		<img class="ejIcon" src="http://localhost:8080/meeple-masters/sticker/getSticker/`+ responseArray[i].stickerId +`" alt="">
					            		<div class="message-time">`+ date.substring(5,16).replace("-","/")  +`</div>
					          		</div>
					        	</div>
					        `)
						}
					}else{ //是對方發的
						//判斷是貼圖還是文字
						if(responseArray[i].stickerId == null){ //是文字
							$("#chatRoom").append(`
									<div class="message_row other-message">
					         			 <div class="message-content">
					         				<img class="head" src="http://localhost:8080/meeple-masters/member/emailFindMemberImg/`+userEmail+`" alt="">
					           				<div class="message-text">`+ responseArray[i].text  +`</div>
					            			<div class="message-time">`+ date.substring(5,16).replace("-","/")  +`</div>
					          			</div>
					        		</div>
									`)
						}else{ //是貼圖
							$("#chatRoom").append(`
					        	<div class="message_row other-message">
					          		<div class="message-content">
					          			<img class="head" src="http://localhost:8080/meeple-masters/member/emailFindMemberImg/`+userEmail+`" alt="">
					            		<img class="ejIcon" src="http://localhost:8080/meeple-masters/sticker/getSticker/`+ responseArray[i].stickerId +`" alt="">
					            		<div class="message-time">`+ date.substring(5,16).replace("-","/")  +`</div>
					          		</div>
					        	</div>
					        `)
						}
					}
				}
				//把滾輪調到最下面
				let height = $("#chatRoom")[0].scrollHeight;
				$("#chatRoom").scrollTop(height);
			}).catch(function(error){
				console.log("呼叫聊天紀錄出錯啦");
				console.log(error);
			}).finally(function(){
				
			});
		}
		
//		//製作聊天tag的方法
		function makeChatTag(memberEmail,userName,notReadNum){
			console.log("進來製作tag方法");
			let tagId = changeToIdType(memberEmail)+"tag";
			//判斷是否有未讀訊息，如果有就顯示
			if(notReadNum!=0){
				$("#myChatList").prepend(`
						<div class="chatListTag active personalMessage" id="`+tagId+`" onclick="changeToActive(this.id)">
				        	<div class="head"><img src="http://localhost:8080/meeple-masters/member/emailFindMemberImg/`+memberEmail+`" alt=""></div>
				        		<div class="mytext">
				          			<div class="name">`+userName+`</div>
				        		</div>
				        	<div class="msg_num">`+notReadNum+`</div>
				      	</div>
						`);
			}
			//沒有未讀訊息就顯示關閉按鈕，可以讓使用者關閉對話框
			if(notReadNum == 0){
				$("#myChatList").prepend(`
						<div class="chatListTag active personalMessage" id="`+tagId+`" onclick="changeToActive(this.id)">
				        	<div class="head"><img src="http://localhost:8080/meeple-masters/member/emailFindMemberImg/`+memberEmail+`" alt=""></div>
				        		<div class="mytext">
				          			<div class="name">`+userName+`</div>
				        		</div>
				        	<div class="close_tag" onclick="removeTag(this)"><img class="close_tag" src="${root}/img/michael/x.png" alt=""></div>
				      	</div>
						`);
			}
		}
		
		//呼叫資料庫更新已讀
		function haveRead(theOther){ //傳入已讀誰的正確Email
			let json = {
					"sender": theOther,
					"receiver" : "${member.memberEmail}"
				};
			//呼叫後端更新是否已讀的程式
			axios.post("http://localhost:8080/meeple-masters/friendMessage/updateHaveRead",json).then(function(response){
				
			}).catch(function(error){
				console.log("更新已讀出事啦");
			}).finally(function(){
				
			});
		}
		

		
		
		
		
//		//查看並製作未確認的好又邀請
		function findFriendInvite(){
			axios.get("http://localhost:8080/meeple-masters/friendInvite/findByAccepterId/${member.memberEmail}").then(function(response){
				console.log("查看好友邀請的response",response);
				let inviterArray = response.data.InviterList;
				$(".showNumberOfFriendInvite>span").text("未確認好友邀請"+inviterArray.length+"個");
				$(".unComfirmedInvite").empty();
				for(let i = 0;i<inviterArray.length;i++){
					let idType = changeToIdType(inviterArray[i].memberEmail)+"Invite";
					$(".unComfirmedInvite").append(`
						<div class="container text-center">
							<div class="row">
								<div class="col-6">
									<div>
										<img class="memberImg" src="http://localhost:8080/meeple-masters/member/emailFindMemberImg/`+inviterArray[i].memberEmail+`" alt="">
										<span>`+inviterArray[i].memberName+`</span>
									</div>
								</div>
								<div class="col-3"><button name="`+idType+`" onclick="responseInvite(this.name,'accept')">確認邀請</button></div>
								<div class="col-3"><button name="`+idType+`" onclick="responseInvite(this.name,'reject')">拒絕邀請</button></div>
							</div>
						</div>
							`)
				}
			}).catch(function(error){
				console.log("查看好友邀請出事啦",error);
			}).finally(function(){
				
			});
		}
		
//		//按下接受或拒絕好友按鈕時
		function responseInvite(idType,acceptOrReject){
			let theOther = changeToOriginEmail(idType.replace("Invite",""));
			//接受時
			if('accept' == acceptOrReject){
				acceptFriendInvite("${member.memberEmail}",theOther);
			}
			//拒絕時
			if('reject' == acceptOrReject){
				rejectFriendInvite("${member.memberEmail}",theOther);
			}
		}
		
		//將正確的Email轉成Id格式的
		function changeToIdType(originEmail){
			return originEmail.replace(".com","com").replace("@gmail","gmail");
		}
		//將Id格式的Email轉成正確的
		function changeToOriginEmail(IdType){
			return IdType.replace("com",".com").replace("gmail","@gmail");
		}
		


	</script>
	 
</body>
</html>