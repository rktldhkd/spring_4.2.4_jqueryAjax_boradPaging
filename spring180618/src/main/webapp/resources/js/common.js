/*
 * 아래의 ComSubmit 메소드에서 사용됨.
 */
function gfn_isNull(str) {
    if (str == null) return true;
    if (str == "NaN") return true;
    if (new String(str).valueOf() == "undefined") return true;   
    var chkStr = new String(str);
    if( chkStr.valueOf() == "undefined" ) return true;
    if (chkStr == null) return true;   
    if (chkStr.toString().length == 0 ) return true;  
    return false;
}//end gfn_isNull
 
function ComSubmit(opt_formId) {
	//ComSubmit 객체는 객체가 생성될 때, 폼의 아이디가 인자값으로 들어오면 그 폼을 전송하고,
	//파라미터가 없으면 숨겨둔 폼을 이용하여 데이터를 전송하도록 구현하였다. 
	//그냥 페이지 이동시, commonForm 써서 그냥 submit 하고, 아니면 
	// 화면단에서 form명 넘겨받아서 파라미터랑 여러가지 속성값 설정 후, submit 한다.
    this.formId = gfn_isNull(opt_formId) == true ? "commonForm" : opt_formId;
    this.url = "";
     
    if(this.formId == "commonForm"){
        $("#commonForm")[0].reset();
    }
     
    this.setUrl = function setUrl(url){
        this.url = url;
    };
     
    this.addParam = function addParam(key, value){
        $("#"+this.formId).append($("<input type='hidden' name='"+key+"' id='"+key+"' value='"+value+"' >"));
    };
     
    this.submit = function submit(){
        var frm = $("#"+this.formId)[0];
        frm.action = this.url;
        frm.method = "post";
        frm.submit();  
    };
}//end comsubmit

