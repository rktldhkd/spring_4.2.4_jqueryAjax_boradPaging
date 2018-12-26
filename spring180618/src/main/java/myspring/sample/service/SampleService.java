package myspring.sample.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface SampleService {
/*
 자바에서는 에러처리를 위하여 try, catch 문을 이용하여 적절한 에러처리를 해야한다. 그렇지만 모든곳에서 동일한 에러처리를 하는것은 현실적으로 힘들고, 예상하지 못한 에러도 발생할 수 있다. 
그래서 모든 메서드에서는 에러가 발생하면 Exception을 날리고, 공통으로 이 Exception을 처리하는 로직을 추후 추가하려고 한다. 이는 나중에 에러처리 포스팅을 하면서 설명하겠다. 
 */
	List<Map<String, Object>> selectBoardList(Map<String, Object> map) throws Exception;

	void insertBoard(Map<String, Object> map, HttpServletRequest request) throws Exception;

	Map<String, Object> selectBoardDetail(Map<String, Object> map) throws Exception;

	void updateBoard(Map<String, Object> map, HttpServletRequest request) throws Exception;

	void deleteBoard(Map<String, Object> map) throws Exception;

}//end interface
