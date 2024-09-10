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
	
	// frm을 넘겨 받아 화면 전환하는 용도
	@RequestMapping("/board/boardDetail.do")
	public String boardDetail(@RequestParam(name="boardIdx") int boardIdx, Model model, HttpSession session) {
		HashMap<String, Object> loginInfo = null;
		loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");		
		
		if(loginInfo != null) {			
			HashMap<String, Object> boardInfo = boardService.selectBoardDetail(boardIdx);			
			model.addAttribute("boardIdx", boardIdx); // 추후 게시글에서 새로운 기능을 만들 때 확장성을 위해 idx값 따로 넘겨놓기
			model.addAttribute("boardInfo", boardInfo);
			
			// model에 login 정보 담아주기 - 다른 id가 작성한 게시글에 수정, 삭제 버튼 안보이게 하기 위해
			model.addAttribute("loginInfo", loginInfo); 
						
			return "board/boardDetail";			
		}else {			
			return "redirect:/login.do";
		}		
	}
	
	// 데이터를 조회해서 json으로 넘겨주는 용도 (ajax에서 사용)
	@RequestMapping("/board/getBoardDetail.do")
	public ModelAndView getBoardDetail(@RequestParam(name="boardIdx") int boardIdx) {
		ModelAndView mv = new ModelAndView();
		
		HashMap<String, Object> boardInfo = boardService.selectBoardDetail(boardIdx);
		
		mv.addObject("boardInfo", boardInfo);
		mv.setViewName("jsonView");
		return mv;
	}	
	
	@RequestMapping("/board/registBoard.do")
	public String registBoard(HttpSession session, Model model, @RequestParam HashMap<String, Object> paramMap) {
		HashMap<String, Object> loginInfo = null;
		loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		
		if(loginInfo != null) {
			String flag = paramMap.get("flag").toString();
			model.addAttribute("flag", flag);
			
			if("U".equals(flag)) {
				model.addAttribute("boardIdx", paramMap.get("boardIdx").toString());
			}			
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
	
	@RequestMapping("/board/deleteBoard.do")
	public ModelAndView deleteBoard(@RequestParam HashMap<String, Object> paramMap, HttpSession session) {
		ModelAndView mv = new ModelAndView();
		
		int resultChk = 0;
		
		HashMap<String, Object> sessionInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		paramMap.put("memberId", sessionInfo.get("id").toString());
		
		resultChk = boardService.deleteBoard(paramMap);
		
		mv.addObject("resultChk", resultChk);
		mv.setViewName("jsonView");
		return mv;
	}
	
	// 댓글 등록
	@RequestMapping("/board/saveBoardReply.do")
	public ModelAndView saveBoardReply(@RequestParam HashMap<String, Object> paramMap, HttpSession session) {
		ModelAndView mv = new ModelAndView();
		
		HashMap<String, Object> sessionInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		paramMap.put("memberId", sessionInfo.get("id").toString());
		
		int resultChk = 0;
		
		resultChk = boardService.insertReply(paramMap);
		
		mv.addObject("resultChk", resultChk);
		mv.setViewName("jsonView");
		return mv;
	}
	
	// 댓글 목록
	@RequestMapping("/board/getBoardReply.do")
	public ModelAndView getBoardReply(@RequestParam HashMap<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView();
		
		List<HashMap<String, Object>> replyList = boardService.selectBoardReply(paramMap);
		
		mv.addObject("replyList", replyList);
		mv.setViewName("jsonView");
		return mv;
	}

}
