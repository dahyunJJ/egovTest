<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="/css/egovframework/login.css" />
<title>비밀번호 찾기</title>
<script type="text/javascript">
	$(document).ready(function() {
		$("#btn_pwSetting").on('click', function() {
			fn_pwSetting();
		});
	});
	
	function fn_pwSetting() {
		console.log("${memberIdx}");
		
		var memberIdx = "${memberIdx}";
		var memberPw = $("#memberPw").val();
		var memberPwConfirm = $("#memberPwConfirm").val();
		
		if (memberPw != memberPwConfirm) {
			alert("비밀번호를 확인해주세요.");
			return;
		} else {		
			$.ajax({
			    url: "/resettingPwd.do",
			    method: 'post',
			    data : {
			    	"memberIdx" : memberIdx,
			    	"memberPw" : memberPw
			    },
			    dataType : 'json',
			    success: function (data, status, xhr) {
			    	if(data.resultChk > 0) {
			    		alert("설정되었습니다.");
			    		location.href="login.do";
			    	} else {
			    		alert("인증에 실패하였습니다.");
			    		return;
			    	}
			    },
			    error: function (data, status, err) {
			    	console.log(err);
			    }
			});
		}
	}

</script>
</head>
<body>
<form id="frm" name="frm">
	<table>
	    <tr>
	        <td><h2>비밀번호 재설정</h2></td>
	    </tr>
	    <tr>
	        <td><input type="text" placeholder="비밀번호를 입력해주세요" id="memberPw" name="memberPw"></td>
	    </tr>
	    <tr>
	        <td><input type="text" placeholder="비밀번호 재확인" id="memberPwConfirm" name="memberPwConfirm"></td>
	    </tr>
	   <tr>
	        <td><input type="button" value="비밀번호 재설정" class="btn" id="btn_pwSetting" name="btn_pwSetting"></td>
	    </tr>
	    <tr>
	        <td class="join">
	        	<a href="/login.do">로그인 화면으로 ></a>
	        </td>
	    </tr>
	</table>
</form>
</body>
</html>