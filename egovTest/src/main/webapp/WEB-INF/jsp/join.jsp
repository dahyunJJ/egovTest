<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.js"
	integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
	crossorigin="anonymous"></script>
<link rel="stylesheet" href="/css/egovframework/join.css" />
<title>회원가입</title>
<script type="text/javascript">
	$(document).ready(function() {
		$("#btn_idChk").on('click', function() {
			fn_idChk();
		});
	});

	function fn_join() {
		var accountId = $("#accountId").val();
		var pwd = $("#accountPwd").val();
		var pwdConfirm = $("#accountPwdConfirm").val();
		var accountName = $("#accountName").val();
		var accountBirth = $("#accountBirth").val();
		var email = $("#email").val();
		var emailAddr = $("#emailAddr").val();

		if (accountId === "") {
			alert("ID를 입력해주세요.");
			return;
		} else if (idChkYn == 'N') {
			alert("아이디 중복 검사를 해주세요.");
			return;
		} else if (pwd != pwdConfirm) {
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
			// 회원가입이 되는 부분
			var frm = $("#frm").serialize();
			$.ajax({
			    url: "/member/insertMember.do",
			    method: 'post',
			    data : frm,
			    dataType : 'json',
			    success: function (data, status, xhr) {
			    	console.log(data);
			    	
			        if(data.resultChk > 0) {
			        	alert("회원 가입이 완료되었습니다!");
			        	location.href = "/login.do";
			        } else {
			        	alert("회원 가입에 실패하였습니다.");
			        	return;
			        }
			    },
			    error: function (data, status, err) {
			    	console.log(err);
			    }
			});
			
		}
	};
	
	function fn_idChk() {
		var accountId = $("#accountId").val();
		if(accountId === "") {
			alert("중복 검사할 아이디를 입력해주세요.");
		} else {
			$.ajax({
			    url: '/member/idChk.do',
			    method: 'post',
			    data : {
			    	'accountId' : accountId
			    },
			    dataType : 'json',
			    success: function (data, status, xhr) {
			        console.log(data);
			        if(data.idChk > 0) {
			        	alert("이미 등록된 아이디입니다.");
			        	return;
			        } else {
			        	$("#idChkYn").val('Y');
			        	alert("사용 가능한 아이디입니다.");
			        }
			    },
			    error: function (data, status, err) {
			    }
			});
		}
	};
</script>
</head>
<body>
	<form id="frm" name="frm">
		<input type="hidden" id="idChkYn" name="idChkYn" value="N" />
		<table>
			<tr>
				<td><h2>회원가입</h2></td>
			</tr>
			<tr>
				<td>아이디</td>
			</tr>
			<tr>
				<td>
					<input type="text" class="text" id="accountId" name="accountId" style="width: 180px;" /> 
					<input type="button" id="btn_idChk" name="btn_idChk" value="중복검사" />
				</td>
			</tr>
			<tr>
				<td>비밀번호</td>
			</tr>
			<tr>
				<td><input type="password" class="text" id="accountPwd" name="accountPwd" /></td>
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
				<td><input type="text" class="text" id="accountName" name="accountName" /></td>
			</tr>
			<tr>
				<td>생년월일</td>
			</tr>
			<tr>
				<td><input type="date" class="text" id="accountBirth" name="accountBirth"></td>
			</tr>
			<tr>
				<td>이메일</td>
			</tr>
			<tr>
				<td><input type="text" class="email" id="email" name="email">
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
					<input type="button" value="가입하기" class="btn" onclick="fn_join();">
				</td>
			</tr>
		</table>
	</form>
</body>
</html>