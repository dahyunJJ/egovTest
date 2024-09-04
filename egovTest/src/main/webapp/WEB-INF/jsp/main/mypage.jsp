<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.js"
	integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
	crossorigin="anonymous"></script>
<link rel="stylesheet" href="/css/egovframework/join.css" />
<title>MyPage</title>
<script type="text/javascript">
	$(document).ready(function() {
		// $("#emailAddr").val("${loginInfo.emailAddr}").prop("selected", true);
		// console.log("${loginInfo}");
		fn_getMemberInfo();
	});
	
	function fn_getMemberInfo() {
		var memberIdx = "${loginInfo.memberIdx}";
		$.ajax({
			type : 'POST',
			url : '/member/getMemberInfo.do',
			data : {
				"memberIdx" : memberIdx
			},
			dataType : 'json',
			beforeSend: function(jqXHR, settings){
				console.log("beforeSend");
			},
			success : function(data, textStatus, jqXHR){
				// console.log(data);
				
				$("#memberIdx").val(data.memberInfo.memberIdx);				
				$("#accountId").val(data.memberInfo.id);				
				$("#accountName").val(data.memberInfo.name);				
				$("#accountBirth").val(data.memberInfo.birth);				
				$("#email").val(data.memberInfo.emailId);				
				$("#emailAddr").val(data.memberInfo.emailAddr).prop("selected", true);				
			},  				
			error: function(jqXHR, textStatus, errorThrown){
				console.log("error");
			},
			complete : function(jqXHR, textStatus){
				console.log("complete");
			}
		});
	}
	
	function fn_save() {
		var frm = $("#frm").serialize();
		console.log(frm);
		
		var pwd = $("#accountPwd").val();
		var pwdConfirm = $("#accountPwdConfirm").val();
		var accountName = $("#accountName").val();
		var accountBirth = $("#accountBirth").val();
		var email = $("#email").val();
		var emailAddr = $("#emailAddr").val();
		
		if (pwd != pwdConfirm) {
			alert("비밀번호를 확인해주세요.");
			return;
		} else if (accountName === "") {
			alert("이름을 입력해주세요.");
			return;
		} else if (accountBirth === "") {
			alert("생년월일을 입력해주세요.");
			return;
		} else if (email === "" || emailAddr === "") {
			alert("이메일을 입력해주세요.");
			return;
		} else {		
			$.ajax({
				type : 'POST',
				url : '/member/updateMember.do',
				data : frm,
				dataType : 'json',
				beforeSend: function(jqXHR, settings){
					console.log("beforeSend");
				},
				success : function(data, textStatus, jqXHR){
					if(data.resultChk > 0){
						alert("수정되었습니다.");
						/* location.reload(); */
						fn_getMemberInfo();
						
						} else {
						alert("수정에 실패하였습니다.");
						return;
					}
					
				},  				
				error: function(jqXHR, textStatus, errorThrown){
					console.log("error");
				},
				complete : function(jqXHR, textStatus){
					console.log("complete");
				}
			});
		}
	}
	
	function fn_delete() {
		// confirm() : 확인 버튼 - true, 취소 버튼 - false
		if(confirm("탈퇴하시겠습니까?")) {
			var memberIdx = "${loginInfo.memberIdx}";
			$.ajax({
				type : 'POST',
				url : '/member/deleteMember.do',
				data : {
					"memberIdx" : memberIdx
				},
				dataType : 'json',
				beforeSend: function(jqXHR, settings){
					console.log("beforeSend");
				},
				success : function(data, textStatus, jqXHR){
					if(data.resultChk > 0) {
						alert("탈퇴되었습니다.");
						var frm = $("#frm");
						frm.attr("method", "POST");
						frm.attr("action", "/logout.do");
						frm.submit();
					}
				},  				
				error: function(jqXHR, textStatus, errorThrown){
					console.log("error");
				},
				complete : function(jqXHR, textStatus){
					console.log("complete");
				}
			});
		} else {
		}
	}
	
</script>
</head>
<body>
	<form id="frm" name="frm">
		<!-- <input type="hidden" id="memberIdx" name="memberIdx" value="${loginInfo.memberIdx}" /> -->
		<input type="hidden" id="memberIdx" name="memberIdx" value="" />
		<table>
			<tr>
				<td><h2>MyPage</h2></td>
			</tr>
			<tr>
				<td>아이디</td>
			</tr>
			<tr>
				<td>
					<!-- <input type="text" class="text" id="accountId" name="accountId" value="${loginInfo.id}" style="width: 180px;" readonly /> --> 
					<input type="text" class="text" id="accountId" name="accountId" value="" readonly /> 
				</td>
			</tr>
			<tr>
				<td>비밀번호</td>
			</tr>
			<tr>
				<td><input type="password" class="text" id="accountPwd" name="accountPwd"/></td>
			</tr>
			<tr>
				<td>비밀번호 확인</td>
			</tr>
			<tr>
				<td><input type="password" class="text" id="accountPwdConfirm" name="accountPwdConfirm" /></td>
			</tr>
			<tr>
				<td>이름</td>
			</tr>
			<tr>
				<!-- <td><input type="text" class="text" id="accountName" name="accountName" value="${loginInfo.name}" /></td> -->
				<td><input type="text" class="text" id="accountName" name="accountName" value="" /></td>
			</tr>
			<tr>
				<td>생년월일</td>
			</tr>
			<tr>
				<!-- <td><input type="date" class="text" id="accountBirth" name="accountBirth" value="${loginInfo.birth}" ></td> -->
				<td><input type="date" class="text" id="accountBirth" name="accountBirth" value="" ></td>
			</tr>
			<tr>
				<td>이메일</td>
			</tr>
			<tr>
				<!-- <td><input type="text" class="email" id="email" name="email" value="${loginInfo.emailId}"> -->
				<td><input type="text" class="email" id="email" name="email" value="">
					@ <select id="emailAddr" name="emailAddr">
						<option value="#">--메일주소를 선택하세요--</option>
						<option value="naver.com">naver.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="daum.net">daum.net</option>
						<option value="nate.com">nate.com</option>
				</select></td>
			</tr>
			<tr>
				<td>
					<input type="button" value="수정" class="btn" onclick="fn_save();">
				</td>
			</tr>
			<tr>
				<td>
					<input type="button" value="회원탈퇴" class="btn" style="background:black; color:white;" onclick="fn_delete();">
				</td>
			</tr>
		</table>
	</form>
</body>
</html>