<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
		width:100%;
		height:auto;
	}
	tr {
		height:30px;
	}
	.text {
	 width:100%;
	}
</style>
<script type="text/javascript">
/* 파일 업로드 관련 변수 */
var fileCnt = 0;
var totalCnt = 20;
var fileNum = 0; // 현재 등록되어 있는 파일 갯수
var content_files = new Array();
var deleteFiles = new Array(); // 삭제 할 파일을 가지고 있는 배열
/* 파일 업로드 관련 변수 */

	$(document).ready(function(){
		var flag = "${flag}";
		if (flag === "U") {
			fn_detail("${boardIdx}");			
		}
		
		$("#btn_save").on('click', function(){
			fn_save();
		});
		
		$("#btn_list").on('click', function(){
			location.href="/board/boardList.do";
		});
		
		$("#uploadFile").on("change", function(e){
			var files = e.target.files;
			// 파일 배열 담기
			var filesArr = Array.prototype.slice.call(files);
			//파일 개수 확인 및 제한
			if(fileCnt + filesArr.length > totalCnt){
				alert("파일은 최대 "+totalCnt+"개까지 업로드 할 수 있습니다.");
				return;
			}else{
				fileCnt = fileCnt+ filesArr.length;
			}
			
			// 각각의 파일 배열 담기 및 기타
			filesArr.forEach(function (f){
				var reader = new FileReader();
				reader.onload = function (e){
					content_files.push(f);
					$("#boardFileList").append(
								'<div id="file'+fileNum+'"style="float:left; width:100%;">'
								+'<font style="font-size:12px">' + f.name + '</font>'
								+'<a href="javascript:fileDelete(\'file'+fileNum+'\',\'\');">X</a>'
								+'</div>'
					);
					fileNum++;
				};
				reader.readAsDataURL(f);
			});
			//초기화한다.
			$("#uploadFile").val("");
		});
	});
	
	function fileDelete(fileNum, fileIdx){
		var no = fileNum.replace(/[^0-9]/g, "");
		
		// 등록 완료 된 파일을 삭제하기 위해 fileIdx를 가져와서 삭제할 배열에 push 
		if(fileIdx != "") {
			deleteFiles.push(fileIdx);
		} else {
			content_files[no].is_delete = true;
		}
		
		$("#"+fileNum).remove();
		fileCnt--;
	}
	
	// 수정 버튼 눌렀을 때, 데이터가 보이도록 처리하기 위해 필요
	function fn_detail(boardIdx) {
		$.ajax({
		    url: '/board/getBoardDetail.do',
		    method: 'post',
		    data : {
		    //  '파라미터 명칭' : 실제 데이터
		    	'boardIdx' : boardIdx
		    },
		    dataType : 'json',
		    success: function (data, status, xhr) {
		    	console.log("boardInfo", data.boardInfo);
		    	
		    	$("#boardTitle").val(data.boardInfo.boardTitle);
		    	$("#boardContent").val(data.boardInfo.boardContent);
		    	
		    	// 업로드한 파일 목록 불러오기
		    	fn_filelist(data.boardInfo.fileGroupIdx);
		    	
		    },
		    error: function (data, status, err) {
		    	console.log(err);
		    }
		});
	}
	
	function fn_filelist(fileGroupIdx) {
		$.ajax({
		    url: '/board/getFileList.do',
		    method: 'post',
		    data : {
		    	'fileGroupIdx' : fileGroupIdx
		    },
		    dataType : 'json',
		    success: function (data, status, xhr) {
				if(data.fileList.length > 0){
					for(var i=0; i<data.fileList.length; i++){
						$("#boardFileList").append(
								'<div id="file'+i+'" style="float:left; width: 100%;">'
								+'<font style="font-size:12px">' + data.fileList[i].fileOriginalName + '</font>'
								+'<a href="javascript:fileDelete(\'file'+i+'\',\''+data.fileList[i].fileIdx+'\');">X</a>'
								+'</div>'
						);
					}
					fileNum = data.fileList.length;
		    	}
		    },
		    error: function (data, status, err) {
		    	console.log(err);
		    }
		});
	}
	
	function fn_save(){
		// var frm = $("#saveFrm").serialize();
		// savaForm과 함께 file 데이터를 보내려면 FormData 객체를 사용해야함
		var formData = new FormData($("#saveFrm")[0]);
		
		for(var x = 0; x < content_files.length; x++){
			//삭제 안한 것만 담아준다.
			if(!content_files[x].is_delete){
				formData.append("fileList", content_files[x]); 
			}
		}
		
		// formData에 등록된 파일 중 삭제를 할 파일을 추가
		if(deleteFiles.length > 0) {
			formData.append("deleteFiles", deleteFiles);			
		}
		
		$.ajax({
		    url: '/board/saveBoard.do',
		    method: 'post',
		    data : formData,
		    enctype : "multipart/form-data",
		    processData : false,
		    contentType : false, // 비동기식 <-> true : 동기식
		    dataType : 'json',
		    success: function (data, status, xhr) {
		    	if(data.resultChk > 0){
		    		alert("저장되었습니다.");
		    		location.href="/board/boardList.do";
		    	}else{
		    		alert("저장에 실패하였습니다.");
		    	}
		    },
		    error: function (data, status, err) {
		    	console.log(err);
		    }
		});
	}
</script>
</head>
<body>
	<div>
		<form id="saveFrm" name="saveFrm">
			<input type="hidden" id="statusFlag" name="statusFlag" value="${flag}"/>
			<input type="hidden" id="boardIdx" name="boardIdx" value="${boardIdx }"/>
			<table>
				<tr>
					<th>제목</th>
					<td>
						<input type="text" class="text" id="boardTitle" name="boardTitle"/>
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<td>
						<textarea rows="20" cols="60" id="boardContent" name="boardContent" class="text"></textarea>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td>
						<!-- multiple : 여러개의 파일 업로드를 위해 -->
						<input type="file" class="text" id="uploadFile" name="uploadFile" multiple/>
						<div id="boardFileList"></div>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<div style="float:right;">
		<input type="button" id="btn_save" name="btn_save" value="저장"/>
		<input type="button" id="btn_list" name="btn_list" value="목록"/>
	</div>
</body>
</html>