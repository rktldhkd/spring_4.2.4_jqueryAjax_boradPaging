<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시글 작성</title>
<script>
var gfv_count = 1;

$(function(){
	$("#list").on("click", function(e){
		e.preventDefault();
        fn_openBoardList();
	});//list.on
	
	$("#write").on("click", function(e){
		e.preventDefault();
		fn_insertBoard();
	})//write.on
	
	$("#addFile").on("click", function(e){ //파일 추가 버튼
        e.preventDefault();
        fn_addFile();
    });
     
    $("a[name='delete']").on("click", function(e){ //삭제 버튼
        e.preventDefault();
        fn_deleteFile($(this));
    });

});//jquery

function fn_openBoardList(){
	var comSubmit = new ComSubmit();
	//JSTL 사용 안하고 할 땐 comSubmit.setUrl("/myspring/sample/openBoardList"); 라고 하면 된다.
	 comSubmit.setUrl("<c:url value='/sample/openBoardList' />");
     comSubmit.submit();
}//fn_openBoardList

function fn_insertBoard(){
	var comSubmit = new ComSubmit("frm");
	comSubmit.setUrl("<c:url value='/sample/insertBoard' />");
	comSubmit.submit();
}//fn_insertBoard

function fn_addFile(){
    var str = "<p><input type='file' name='file_"+(gfv_count++)+"'><a href='#this' class='btn' name='delete'>삭제</a></p>";
    $("#fileDiv").append(str);
    $("a[name='delete']").on("click", function(e){ //삭제 버튼
        e.preventDefault();
        fn_deleteFile($(this));
    });
}
 
function fn_deleteFile(obj){
    obj.parent().remove();
}
</script>
</head>
<body>
	<div><!-- 폼을 Multipart 형식임을 알려주는데, 사진, 동영상 등 글자가 아닌 파일은 모두 Multipart 형식의 데이터  -->
		<form id="frm" name="frm" enctype="multipart/form-data">
			<table class="board_view">
				<colgroup>
					<col width="15%"/>
					<col width="*"/>
				</colgroup>
				<caption>게시글 작성</caption>
				<tbody>
					<tr>
						<th scope="row">제목</th>
						<td><input type="text" id="TITLE" name="TITLE" class="wdp_90"/></td>
					</tr>
					<tr>
						<td colspan="2" class="view_text">
							<textarea rows="20" cols="100" title="내용" id="CONTENTS" name="CONTENTS"></textarea>
						</td>
					</tr>
				</tbody>
			</table>
			<div id="fileDiv">
	            <p>
	                <input type="file" id="file" name="file_0">
	                <a href="#this" class="btn" id="delete" name="delete">삭제</a>
	            </p>
      	  	</div>
        	<br/><br/>
			
			<a href="#this" class="btn" id="addFile">파일 추가</a>
			<a href="#this" class="btn" id="write">작성하기</a>
			<a href="#this" class="btn" id="list">목록으로</a>
		</form>
		<%@include file="/WEB-INF/include/include-body.jsp" %>
	</div>
</body>
</html>