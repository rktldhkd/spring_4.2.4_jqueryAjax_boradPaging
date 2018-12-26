package myspring.sample.dao;

import java.util.List;
import java.util.Map;

import myspring.common.dao.AbstractDAO;

import org.springframework.stereotype.Repository;

@Repository("sampleDAO")
public class SampleDAO extends AbstractDAO{

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectBoardList(Map<String, Object> map) throws Exception{
		return (List<Map<String,Object>>)selectPagingList("sample.selectBoardList", map);
	}//end selectBoardList

	public void insertBoard(Map<String, Object> map) throws Exception{
		insert("sample.insertBoard", map);
	}//end insertBoard

	public void updateHitCnt(Map<String, Object> map) throws Exception{
		update("sample.updateHitCnt", map);

	}//end updateHitCnt

	@SuppressWarnings("unchecked")
	public Map<String, Object> selectBoardDetail(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("sample.selectBoardDetail", map);
	}//end selectBoardDetail

	public void updateBoard(Map<String, Object> map) {
		update("sample.updateBoard", map);
	}//end updateBoard

	public void deleteBoard(Map<String, Object> map) {
		update("sample.deleteBoard", map);
	}//end deleteBoard

	public void insertFile(Map<String, Object> map) {
		insert("sample.insertFile", map);
	}//end insertFile

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectFileList(Map<String, Object> map) throws Exception{
	    return (List<Map<String, Object>>)selectList("sample.selectFileList", map);
	}//end selectFileList
	
	public void deleteFileList(Map<String, Object> map) throws Exception{
	    update("sample.deleteFileList", map);
	}
	 
	public void updateFile(Map<String, Object> map) throws Exception{
	    update("sample.updateFile", map);
	}
}//end class
