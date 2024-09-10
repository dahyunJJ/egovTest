<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.js"
	integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
	crossorigin="anonymous"></script>
<title>게시물 등록</title>
<style>
	table{
		margin:auto;
	}
	tr {
		height:30px;
	}

	.text {
	 width:100%;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		// 로그인 아이디와 게시글 작성 아이디가 다를때, 수정과 삭제 버튼 처리 방법 2
		/* var loginId = "${loginInfo.id}";
		var createId = "${boardInfo.createId}";
		if(loginId != createId) {
			$("#btn_update").hide();
			$("#btn_delete").hide();
		} else {
			$("#btn_update").show();
			$("#btn_delete").show();
		} */
		
		fn_getReply("${boardInfo.boardIdx}");
		
		$("#btn_update").on('click', function(){
			fn_update();
		});
		
		$("#btn_delete").on('click', function(){
			fn_delete();
		});
		
		$("#btn_list").on('click', function(){
			location.href = "/board/boardList.do"
		});
		
		$("#btn_reply_save").on('click', function(){
			fn_comment();
		});
	});	
	
	function fn_update() {
		$("#flag").val("U");
		var frm = $("#saveFrm");		
		frm.attr("method", "POST");
		frm.attr("action", "/board/registBoard.do");
		frm.submit();
	}
	
	function fn_delete() {
		if(confirm("삭제하시겠습니까?")) {
			
			// boardIdx를 넘기는 4가지 방법
			var frm = $("#saveFrm").serialize();
			// var boardIdx = "${boardIdx}" 
			// var boardIdx = "${boardInfo.boardIdx}"
			// var boardIdx = $("#boardIdx").val();
			
			$.ajax({
			    url: '/board/deleteBoard.do',
			    method: 'post',
			    data : frm, // frm 전부 넘기지 않을거면 {'boardIdx' : boardIdx},
			    dataType : 'json',
			    success: function (data, status, xhr) {
			    	if(data.resultChk > 0){
			    		alert("삭제되었습니다.");
			    		location.href="/board/boardList.do";
			    	}else{
			    		alert("삭제에 실패하였습니다.");
			    	}
			    },
			    error: function (data, status, err) {
			    	console.log(err);
			    }
			});
		}
	}
	
	// 댓글 영역 
	// 댓글 목록 보여주기
	function fn_getReply(boardIdx){
		$.ajax({
		    url: '/board/getBoardReply.do',
		    method: 'post',
		    data : { "boardIdx" : boardIdx},
		    dataType : 'json',
		    success: function (data, status, xhr) {
		    	var replyHtml = '';
		    	if(data.replyList.length > 0){
		    		for(var i=0; i<data.replyList.length; i++){
		    			// replyIdx 값을 div에 넣어준 이유 : 특정 댓글 div만 삭제 될 수 있게 하려고
		    			replyHtml += '<div id="reply_'+data.replyList[i].replyIdx+'" style="width:90%;">';
			    		replyHtml += '<span>';
			    		if(data.replyList[i].replyLevel > 0){
			    			for(var j=0; j<data.replyList[i].replyLevel; j++){
				    			replyHtml += '=';
				    		}
			    			replyHtml+='=>';
			    		}
			    		replyHtml += data.replyList[i].createId;
			    		replyHtml += '</span></br>';
			    		replyHtml += '<span>';
			    		replyHtml += data.replyList[i].replyContent;
			    		replyHtml += '</span></br>';
			    		replyHtml += '<span>';
			    		replyHtml += data.replyList[i].createDate;
			    		replyHtml += '<a href="javascript:fn_replyInsert(\''+data.replyList[i].replyIdx+'\');" style="float:right;">';
			    		replyHtml += '답글달기';
			    		replyHtml += '</a><br>';
			    		replyHtml += '<a href="javascript:fn_replyDelete(\''+data.replyList[i].replyIdx+'\');" style="float:right;">';
			    		replyHtml += '삭제';
			    		replyHtml += '</a>';
			    		replyHtml += '</span></br>';
			    		replyHtml += '</div>';	
		    		}
		    	}else{
		    		
		    		replyHtml += '댓글이 존재하지 않습니다.';
		    	}
		    	$("#replyDiv").html(replyHtml);
		    },
		    error: function (data, status, err) {
		    	console.log(err);
		    }
		});
	}
	
	function fn_replyInsert(replyIdx){
		
	}
	
	function fn_replyInsertSave(replyIdx){
		var boardIdx = $("#boardIdx").val();
		var replyContent = $("#replyContent_"+replyIdx).val();
		$.ajax({
		    url: '/board/saveBoardReply.do',
		    method: 'post',
		    data : { 
		    	"boardIdx" : boardIdx,
		    	"replyIdx" : replyIdx,
		    	"replyContent" : replyContent
		    },
		    dataType : 'json',
		    success: function (data, status, xhr) {
		    	if(data.resultChk > 0){
		    		alert("등록되었습니다.");
		    		fn_getReply(boardIdx);
		    	}else{
		    		alert("등록에 실패하였습니다.");
		    	}
		    },
		    error: function (data, status, err) {
		    	console.log(status);
		    }
		});
	}
	
	// 댓글 등록
	function fn_comment(){
		var boardIdx = $("#boardIdx").val();
		var replyContent = $("#replyContent").val();
		$.ajax({
		    url: '/board/saveBoardReply.do',
		    method: 'post',
		    data : { 
		    	"boardIdx" : boardIdx,
		    	"replyContent" : replyContent
		    },
		    dataType : 'json',
		    success: function (data, status, xhr) {
		    	if(data.resultChk > 0){
		    		alert("등록되었습니다.");
		    		// fn_getReply(boardIdx);
		    	}else{
		    		alert("등록에 실패하였습니다.");
		    	}
		    },
		    error: function (data, status, err) {
		    	console.log(status);
		    }
		});
	}
	
	function fn_replyDelete(replyIdx){
		$.ajax({
		    url: '/board/deleteBoardReply.do',
		    method: 'post',
		    data : { 
		    	"replyIdx" : replyIdx
		    },
		    dataType : 'json',
		    success: function (data, status, xhr) {
		    	if(data.resultChk > 0){
		    		alert("삭제되었습니다.");
		    		fn_getReply(boardIdx);
		    	}else{
		    		alert("삭제에 실패하였습니다.");
		    	}
		    },
		    error: function (data, status, err) {
		    	console.log(status);
		    }
		});		
	}
	
</script>
</head>
<body>
	<div>
		<form id="saveFrm" name="saveFrm">
			<input type="hidden" id="flag" name="flag" value="${flag}"/>
			<input type="hidden" id="boardIdx" name="boardIdx" value="${boardIdx }"/>
			<table style="height:auto; width:100%;" >
				<colgroup>
					<col width="20%" />
					<col width="30%" />
					<col width="20%" />
					<col width="30%" />
				</colgroup>
				<tbody>
					<tr>
						<th>제목</th>
						<td colspan="3">
							<input type="text" class="text" id="boardTitle" name="boardTitle" value="${boardInfo.boardTitle }" readonly/>
						</td>
					</tr>
					<tr>
						<th>내용</th>
						<td colspan="3">
							<textarea rows="20" cols="100" id="boardContent" name="boardContent" style="width:100%;" readonly>${boardInfo.boardContent }</textarea>
						</td>
					</tr>
					<tr>
						<th>작성자</th>
						<td>
							<input type="text" class="text" id="createId" name="createId" value="${boardInfo.createId }" readonly />
						</td>
						<th>작성일</th>
						<td>
							<input type="text" class="text" id="createDate" name="createDate" value="${boardInfo.createDate }" readonly />
						</td>
					</tr>
					<tr>
						<th>수정자</th>
						<td>
							<input type="text"  class="text" id="updateId" name="updateId" value="${boardInfo.updateId }" readonly />
						</td>
						<th>수정일</th>
						<td>
							<input type="text" class="text" id="updateDate" name="updateDate" value="${boardInfo.updateDate }" readonly />
						</td>
					</tr>
				</tbody>
				
			</table>
		</form>
	</div>
	<div style="float:right; width:100%;">
		<!-- 로그인 아이디와 게시글 작성 아이디가 다를때, 수정과 삭제 버튼 처리 방법 1 --> 
		<c:if test = "${loginInfo.id == boardInfo.createId }" >
			<input type="button" id="btn_delete" name="btn_delete" value="삭제" style="float:right;"/>
			<input type="button" id="btn_update" name="btn_update" value="수정" style="float:right;"/>
		</c:if>
		<input type="button" id="btn_list" name="btn_list" value="목록" style="float:right;"/>
	</div>
	
	<!-- 댓글 영역 -->
	<div style="width:100%; margin:0px 0px 0px 9%;">
		<h4>댓글</h4>
		<input type="text" id="replyContent" name="replyContent" style="width:87%; margin:0 0px 10px 0px;" placeholder="댓글을 입력해주세요."/>
		<input type="button" id="btn_reply_save" name="btn_reply_save" value="등록"/>
	</div>
	<div style="width:100%; margin:0px 0px 0px 9%;" id="replyDiv" name="replyDiv">
	</div>
</body>
</html>