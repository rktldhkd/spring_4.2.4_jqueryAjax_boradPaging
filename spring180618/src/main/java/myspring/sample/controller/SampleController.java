package myspring.sample.controller;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import myspring.common.common.CommandMap;
import myspring.sample.service.SampleService;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class SampleController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "sampleService")
	private SampleService sampleService;

	/*ajax 페이징 기능을 추가하면서 필요없어짐.
	 * @RequestMapping(value = "/sample/openBoardList")
	public ModelAndView openSampleBoardList(Map<String, Object> commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/sample/boardList");

		List<Map<String,Object>> list = sampleService.selectBoardList(commandMap);
		mv.addObject("list", list);
		
		return mv;
	}// end openSampleBoardList
	 */	
	
	@RequestMapping(value="/sample/openBoardList")
	public ModelAndView openBoardList(CommandMap commandMap) throws Exception{
		//게시판의 데이터를 불러오는 기능은 jsp단의 ajax로 처리해서 불러오기 때문에
		//여기서는 단순히 페이지만 호출해서 페이지 안의 ajax로 데이터를 불러서 화면에 데이터를 채움.
	    ModelAndView mv = new ModelAndView("/sample/boardList");
	     
	    return mv;
	}
	 
	/*
	기존에는 ModelAndView에서 호출할 JSP 파일명이나 redirect를 수행했는데, 이번에는 jsonView라는 값이 들어가있는 것을 볼 수 있다. 
	이는 앞에서 action-servlet.xml에 ' bean id="jsonView" class="org.springframework.web.servlet.view.json.MappingJackson2JsonView" '  를 선언했었던것을 기억해야 한다. 여기서 bean id가 jsonView였는데, 여기서 선언된 bean을 사용하는 것이다. 
	이 jsonView는 데이터를 json 형식으로 변환해주는 역할을 수행한다. 
	*/
	@RequestMapping(value="/sample/selectBoardList")
	public ModelAndView selectBoardList(CommandMap commandMap) throws Exception{
	    ModelAndView mv = new ModelAndView("jsonView"); //데이터를 json 형식으로 변환
	     
	    Iterator<Entry<String,Object>> it = commandMap.getMap().entrySet().iterator();
        Entry<String,Object> entry = null;
        while(it.hasNext())
        {
               entry = it.next();
               log.debug("key : "+entry.getKey()+", value : "+entry.getValue());
        }//while
   
	    List<Map<String,Object>> list = sampleService.selectBoardList(commandMap.getMap());
	    mv.addObject("list", list);
	    if(list.size() > 0){ //글 개수 판단
	        mv.addObject("TOTAL", list.get(0).get("TOTAL_COUNT"));
	    }
	    else{
	        mv.addObject("TOTAL", 0);
	    }
	     
	    return mv;
	}

	
	@RequestMapping(value="/sample/openBoardWrite")
	public ModelAndView openBoardWrite(CommandMap commandMap) throws Exception{
	    ModelAndView mv = new ModelAndView("/sample/boardWrite");
	     
	    return mv;
	}

	@RequestMapping(value="/sample/insertBoard")
	public ModelAndView insertBoard(CommandMap commandMap,HttpServletRequest request) throws Exception{
	    ModelAndView mv = new ModelAndView("redirect:/sample/openBoardList");
	     
	    sampleService.insertBoard(commandMap.getMap(), request);
	     
	    return mv;
	}
	
	@RequestMapping(value="/sample/openBoardDetail")
	public ModelAndView openBoardDetail(CommandMap commandMap) throws Exception{
	    ModelAndView mv = new ModelAndView("/sample/boardDetail");
	    
	    Iterator<Entry<String,Object>> it = commandMap.getMap().entrySet().iterator();
        Entry<String,Object> entry = null;
        while(it.hasNext())
        {
               entry = it.next();
               log.debug("key : "+entry.getKey()+", value : "+entry.getValue());
        }//while
	     
	    Map<String,Object> map = sampleService.selectBoardDetail(commandMap.getMap());
	    mv.addObject("map", map.get("map"));
	    mv.addObject("list", map.get("list"));
	     
	    return mv;
	}
	
	@RequestMapping(value="/sample/openBoardUpdate")
	public ModelAndView openBoardUpdate(CommandMap commandMap) throws Exception{
	    ModelAndView mv = new ModelAndView("/sample/boardUpdate");//jsp 경로
	    
	     
	    Map<String,Object> map = sampleService.selectBoardDetail(commandMap.getMap());
	    mv.addObject("map", map.get("map"));
	    mv.addObject("list", map.get("list"));

	    return mv;
	}
	 
	@RequestMapping(value="/sample/updateBoard")
	public ModelAndView updateBoard(CommandMap commandMap, HttpServletRequest request) throws Exception{
	    ModelAndView mv = new ModelAndView("redirect:/sample/openBoardDetail");
	     
	    sampleService.updateBoard(commandMap.getMap(), request);
	     
	    mv.addObject("IDX", commandMap.get("IDX"));
	    return mv;
	}
	
	@RequestMapping(value="/sample/deleteBoard")
	public ModelAndView deleteBoard(CommandMap commandMap) throws Exception{
	    ModelAndView mv = new ModelAndView("redirect:/sample/openBoardList");
	     
	    sampleService.deleteBoard(commandMap.getMap());
	     
	    return mv;
	}
}// end class
