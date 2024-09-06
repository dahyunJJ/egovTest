package egovframework.com.board.web;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.board.service.BoardService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class BoardController {
	
	@Resource(name="BoardService")
	private BoardService boardService;
	
	@RequestMapping("/board/boardList.do")
	public String boardList(HttpSession session, Model model) {
		HashMap<String, Object> loginInfo = null;
		loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		if(loginInfo != null) {
			model.addAttribute("loginInfo", loginInfo);
			return "board/boardList";
		}else {
			return "redirect:/login.do";
		}
	}
	
	@RequestMapping("/board/selectBoardList.do")
	public ModelAndView selectBoardList(@RequestParam HashMap<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView();
		
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(Integer.parseInt(paramMap.get("pageIndex").toString()));
		paginationInfo.setRecordCountPerPage(10); // recordCountPerPage : 한 페이지당 게시되는 게시물 건 수
		paginationInfo.setPageSize(10); // pageSize : 페이지 리스트에 게시되는 페이지 건수
		
		paramMap.put("firstIndex", paginationInfo.getFirstRecordIndex());
		paramMap.put("lastIndex", paginationInfo.getLastRecordIndex());
		paramMap.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		
		List<HashMap<String, Object>> list = boardService.selectBoardList(paramMap);
		int totCnt = boardService.selectBoardListCnt(paramMap);
		paginationInfo.setTotalRecordCount(totCnt);
		
		mv.addObject("list", list);
		mv.addObject("totCnt", totCnt);
		mv.addObject("paginationInfo", paginationInfo);
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/board/boardDetail.do")
	public String boardDetail(@RequestParam(name="boardIdx") int boardIdx, Model model, HttpSession session) {
		HashMap<String, Object> loginInfo = null;
		loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		if(loginInfo != null) {
			
			HashMap<String, Object> boardInfo = boardService.selectBoardDetail(boardIdx);			
			model.addAttribute("boardIdx", boardIdx); // 추후 게시글에서 새로운 기능을 만들 때 확장성을 위해 idx값 따로 넘겨놓기
			model.addAttribute("boardInfo", boardInfo);
						
			return "board/boardDetail";
			
		}else {
			return "redirect:/login.do";
		}
		
		
	}
	
	@RequestMapping("/board/registBoard.do")
	public String registBoard(HttpSession session, Model model, @RequestParam(name="flag") String flag) {
		HashMap<String, Object> loginInfo = null;
		loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		if(loginInfo != null) {
			model.addAttribute("flag", flag);
			return "board/registBoard";
		}else {
			return "redirect:/login.do";
		}
		
	}
	
	@RequestMapping("/board/saveBoard.do")
	public ModelAndView saveBoard(@RequestParam HashMap<String, Object> paramMap, HttpSession session) {
		ModelAndView mv = new ModelAndView();
		int resultChk = 0;
		
		HashMap<String, Object> sessionInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		paramMap.put("memberId", sessionInfo.get("id").toString());
		
		resultChk = boardService.saveBoard(paramMap);
		
		mv.addObject("resultChk", resultChk);
		mv.setViewName("jsonView");
		return mv;
	}

}
