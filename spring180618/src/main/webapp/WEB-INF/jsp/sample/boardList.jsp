<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script>
//var loadingImg ="<img id='loading' src='${pageContext.request.contextPath}/resources/images/loading.gif' style='display: none;'/>";
$(function(){
	//ajax로 화면에서 페이징하여 뿌려주기위한 데이터 조회
	fn_selectBoardList(1); // 최초의 화면에 보여줄 게시판의 1페이지.
	
	$("#write").on("click", function(e){ //글쓰기 버튼
        e.preventDefault();
        fn_openBoardWrite();
    });
     
    $("a[name='title']").on("click", function(e){ //제목
        e.preventDefault();
        fn_openBoardDetail($(this));
    });
});//jquery

function fn_openBoardWrite(){
	var comSubmit = new ComSubmit();
	comSubmit.setUrl("<c:url value='/sample/openBoardWrite' />");
	comSubmit.submit();
}//end fn_openBoardWrite

function fn_openBoardDetail(obj){
	var comSubmit = new ComSubmit();
	comSubmit.setUrl("<c:url value='/sample/openBoardDetail' />");
	comSubmit.addParam("IDX", obj.parent().find("#IDX").val());
	comSubmit.submit();
}//end fn_openBoardDetail

function fn_selectBoardList(pageNo){
	$('table > tbody').html("<tr id='loadingImgArea'><td><img id='loading' src='${pageContext.request.contextPath}/resources/images/loading.gif'/></td></tr");
    
    var comAjax = new ComAjax();
    
    comAjax.setUrl("<c:url value='/sample/selectBoardList' />");
    comAjax.setCallback("fn_selectBoardListCallback");
    comAjax.addParam("PAGE_INDEX",pageNo); //페이지 번호. 해당 페이지 번호에 맞는 게시판 글들 조회하기 위함
    comAjax.addParam("PAGE_ROW", 15); //페이지에 보여줄 글 개수.
    
    setTimeout(function(){//로딩 이미지 표시시간
    	$("#loadingImgArea").remove();
    	comAjax.ajax(); //실 데이터 로딩
    }, 300);
}//fn_selectBoardList
 
//ajax로 데이터를 불러오고 나서, success 시 페이징 태그들을 수정하기 위한 메서드
//화면을 다시 그리는 함수. 실질적으로 다시 그리는 것은 else문 안의 gfn_renderPaging() 함수.
function fn_selectBoardListCallback(data){
    var total = data.TOTAL;
    var body = $("table>tbody");
    body.empty();
    if(total == 0){ //가져온 글 개수가 없을 때.
        var str = "<tr>" +
                        "<td colspan='4'>조회된 결과가 없습니다.</td>" +
                    "</tr>";
        body.append(str);
    }else{
        var params = { //프로퍼티 설정 값이 있는지 확인할땐, if("프로퍼티속성명" in 프로퍼티변수){}
            divId : "PAGE_NAVI",
            pageIndex : "PAGE_INDEX",
            totalCount : total,
            eventName : "fn_selectBoardList"
        };
        gfn_renderPaging(params);
         
        /*
        	jstl의 c:forEach 태그를 이용하여 테이블의 목록을 만든것과 같은 역할을 수행한다.
        */
        var str = "";
        $.each(data.list, function(key, value){ // key : 1~15까지 글 순서 인덱스, value : 순서마다 글들이 가지고있는 값들 객체.
            str += "<tr>" +
                        "<td>" + value.IDX + "</td>" +
                        "<td class='title'>" +
                            "<a href='#this' name='title'>" + value.TITLE + "</a>" +
                            "<input type='hidden' id='IDX' name='IDX' value=" + value.IDX + ">" +
                        "</td>" +
                        "<td>" + value.HIT_CNT + "</td>" +
                        "<td>" + value.CREA_DTM + "</td>" +
                    "</tr>";
        });//end $.each()
        
        body.append(str);
         
        //각 게시글들마다 새로 이벤트를 연결해준다.
        $("a[name='title']").on("click", function(e){ //제목
            e.preventDefault();
            fn_openBoardDetail($(this));
        });
    }//end if-else
}//fn_selectBoardListCallback


//게시판 페이징을 위한 ajax
//common.js에 위치해있다가 안되서 디버그해보니 메소드를 못찾는다고 해서
//여기로 옮겼더니 잘 됨.
var gfv_ajaxCallback = "";
function ComAjax(opt_formId){
    this.url = "";     
    this.formId = gfn_isNull(opt_formId) == true ? "commonForm" : opt_formId;
    this.param = "";
     
    if(this.formId == "commonForm"){
        var frm = $("#commonForm");
        if(frm.length > 0){
            frm.remove();
        }
        var str = "<form id='commonForm' name='commonForm'></form>";
        $('body').append(str);
    }
     
    this.setUrl = function setUrl(url){
        this.url = url;
    };
     
    //setCallback : ajax를 이용하여 데이터를 전송한 후 호출될 콜백함수의 이름을 지정하는 함수
    //setCallback은 Ajax 요청이 완료된 후 호출될 함수의 이름을 지정하는 함수
    this.setCallback = function setCallback(callBack){
        fv_ajaxCallback = callBack;
    };
 
    this.addParam = function addParam(key,value){
        this.param = this.param + "&" + key + "=" + value;
    };
     
    this.ajax = function ajax(){
        if(this.formId != "commonForm"){
            this.param += "&" + $("#" + this.formId).serialize();
        }
        $.ajax({
            url : this.url,   
            type : "POST",  
            data : this.param,
            async : false, //비동기식으로 설정
            success : function(data, status) {
                if(typeof(fv_ajaxCallback) == "function"){ //fv_ajaxCallback이 가진 값이 함수면 함수 그대로 인자만 전달해서 호출.
                    fv_ajaxCallback(data);
                }
                else {// 아니면 eval로 자바스크립트 구문으로 실행
                    eval(fv_ajaxCallback + "(data);");
                }
            }
        });//end $.ajax()
    };//end funtion ajax(){}
}//end ComAjax



//common.js에 위치해있다가 안되서 디버그해보니 메소드를 못찾는다고 해서
//여기로 옮겼더니 잘 됨.
/* 게시판 페이징 태그. 게시판 페이징 인덱스 개체들을 생성/추가하는 로직이다.
divId : 페이징 태그가 그려질 div
pageIndx : 현재 페이지 위치가 저장될 input 태그 id
recordCount : 페이지당 레코드 수
totalCount : 전체 조회 건수
eventName : 페이징 하단의 숫자 등의 버튼이 클릭되었을 때 호출될 함수 이름
*/
var gfv_pageIndex = null;
var gfv_eventName = null;
function gfn_renderPaging(params){
	
	/* 
		divId : "PAGE_NAVI",
        pageIndex : "PAGE_INDEX",
        totalCount : total,
        eventName : "fn_selectBoardList"
    */
	
    var divId = params.divId; //페이징이 그려질 div id
    gfv_pageIndex = params.pageIndex; //현재 위치가 저장될 input 태그
    var totalCount = params.totalCount; //전체 조회 건수
    var currentIndex = $("#"+params.pageIndex).val(); //현재 위치. 최초에 페이지를 열땐 PAGE_INDEX에 value 속성값이 없고 속성 자체가 설정되있지 않다.
    
    //최초에 페이지를 열면, PAGE_INDEX객체에 value값이 없다. 따라서 여기서 if문으로 판별해서 최초에는 1을 수동으로 넣어준다.
    if($("#"+params.pageIndex).length == 0 || gfn_isNull(currentIndex) == true){
        currentIndex = 1;
    }
     
    //params에 recordCount가 없으므로 undefined이다.
    var recordCount = params.recordCount; //페이지당 레코드 수
    if(gfn_isNull(recordCount) == true){
    	//아래 수치는 comAjax.addParam("PAGE_ROW", 15); 와 동일하게 해야 전체페이징인덱스 수가 딱 맞아 떨어진다.
        recordCount = 15; // 원래 20이었는데 전체페이징인덱스 수가 적어서 가져온 게시물을 처음부터 끝까지 보여주지 못하고 짤려서 15로 고침.
    }
    //전체 페이징 인덱스 수를 잘못 계산하여 설정하면, 가져온 리스트들이 다 안보일수 있다.
    var totalIndexCount = Math.ceil(totalCount / recordCount); // 전체 페이징 인덱스 수.
    gfv_eventName = params.eventName;
     
    $("#"+divId).empty(); //PAGE_NAVI의 페이징인덱스들을 비운다.
    var preStr = ""; //맨앞으로 이동태그
    var postStr = ""; //맨뒤로 이동태그
    var str = ""; //1~10까지범위의 인덱스들이 담긴다.
    
    var first = (parseInt((currentIndex-1) / 10) * 10) + 1;  //맨앞으로 이동태그 설정값
    var last = (parseInt(totalIndexCount/10) == parseInt(currentIndex/10)) ? totalIndexCount%10 : 10;  //맨뒤로 이동태그 설정값
    var prev = (parseInt((currentIndex-1)/10)*10) - 9 > 0 ? (parseInt((currentIndex-1)/10)*10) - 9 : 1;  //이전으로 이동태그 설정값
    var next = (parseInt((currentIndex-1)/10)+1) * 10 + 1 < totalIndexCount ? (parseInt((currentIndex-1)/10)+1) * 10 + 1 : totalIndexCount; //다음 10단위페이지 이동태그 설정값
     
    if(totalIndexCount > 10){ //전체 인덱스가 10이 넘을 경우, 맨앞, 앞 태그 작성
        preStr += "<a href='#this' class='pad_5' onclick='_movePage(1)'>[<<]</a>" +
                "<a href='#this' class='pad_5' onclick='_movePage("+prev+")'>[<]</a>";
    }
    else if(totalIndexCount <=10 && totalIndexCount > 1){ //전체 인덱스가 10보다 작을경우, 맨앞 태그 작성
        preStr += "<a href='#this' class='pad_5' onclick='_movePage(1)'>[<<]</a>";
    }
     
    if(totalIndexCount > 10){ //전체 인덱스가 10이 넘을 경우, 맨뒤, 뒤 태그 작성
        postStr += "<a href='#this' class='pad_5' onclick='_movePage("+next+")'>[>]</a>" +
                    "<a href='#this' class='pad_5' onclick='_movePage("+totalIndexCount+")'>[>>]</a>";
    }
    else if(totalIndexCount <=10 && totalIndexCount > 1){ //전체 인덱스가 10보다 작을경우, 맨뒤 태그 작성
        postStr += "<a href='#this' class='pad_5' onclick='_movePage("+totalIndexCount+")'>[>>]</a>";
    }
     
    //인덱스 생성
    for(var i=first; i<(first+last); i++){
        if(i != currentIndex){
            str += "<a href='#this' class='pad_5' onclick='_movePage("+i+")'>"+i+"</a>";
        }
        else{
            str += "<b><a href='#this' class='pad_5' onclick='_movePage("+i+")'>"+i+"</a></b>";
        }
    }
    $("#"+divId).append(preStr + str + postStr);
}

//페이징 태그 클릭 시, 해당 페이지로 이동하는 역할.
function _movePage(value){
    $("#"+gfv_pageIndex).val(value); //현재페이지를 알릴 PAGE_INDX 객체에 클릭한 페이징인덱스 태그의 val값을 넣는다.
    if(typeof(gfv_eventName) == "function"){
        gfv_eventName(value);
    }
    else {
        eval(gfv_eventName + "(value);");
    }
}
</script>
</head>
<body>
<h2>게시판 목록</h2>
<table style="border:1px solid #ccc">
    <colgroup>
        <col width="10%"/>
        <col width="*"/>
        <col width="15%"/>
        <col width="20%"/>
    </colgroup>
    <thead>
        <tr>
            <th scope="col">글번호</th>
            <th scope="col">제목</th>
            <th scope="col">조회수</th>
            <th scope="col">작성일</th>
        </tr>
    </thead>
    <tbody>
		<%-- ajax 게시판 페이징 기능을 추가하면서 필요없어진 부분.
		<c:choose>
			<c:when test="${fn:length(list) > 0}">
				<c:forEach items="${list }" var="row">
					<tr>
						<td>${row.IDX }</td>
						<td class="title">
							<a href="#this" name="title">${row.TITLE }</a>
							<input type="hidden" id="IDX" value="${row.IDX }">
						</td>
						<td>${row.HIT_CNT }</td>
						<td>${row.CREA_DTM }</td>
					</tr>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr>
					<td colspan="4">조회된 결과가 없습니다.</td>
				</tr>
			</c:otherwise>
		</c:choose> --%>
	</tbody>
</table>

<!-- 페이징 태그 영역 -->
<div id="PAGE_NAVI"></div>
<input type="hidden" id="PAGE_INDEX" name="PAGE_INDEX"/>

<br/>
<a href="#this" class="btn" id="write">글쓰기</a>
<%@ include file="/WEB-INF/include/include-body.jsp" %>
</body>
</html>