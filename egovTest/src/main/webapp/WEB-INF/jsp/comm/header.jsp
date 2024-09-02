<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.js"
	integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
	crossorigin="anonymous"></script>
<title>header</title>
<script type="text/javascript">
	$(document).ready(function() {
		$("#btn_logout").on('click', function() {
			fn_logout();
		})
	});
	
	function fn_logout() {
		var frm = $("#logoutFrm");
		frm.attr("method", "POST");
		frm.attr("action", "/logout.do");
		frm.submit();
	}
</script>
</head>
<body>
	<header>
		<form id="logoutFrm" name="logoutFrm">		
		</form>
		<label style="color:blue; font-weight:bold;">${loginInfo.name}</label>님 환영합니다.
		<input type="button" id="btn_logout" name="btn_logout" value="로그아웃" />
	</header>
</body>
</html>