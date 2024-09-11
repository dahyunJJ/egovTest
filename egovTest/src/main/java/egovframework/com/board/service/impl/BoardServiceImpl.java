package egovframework.com.board.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.io.FilenameUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import egovframework.com.board.service.BoardService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("BoardService")
public class BoardServiceImpl extends EgovAbstractServiceImpl implements BoardService{

	@Resource(name="BoardDAO")
	private BoardDAO boardDAO;

	@Override
	public List<HashMap<String, Object>> selectBoardList(HashMap<String, Object> paramMap) {
		return boardDAO.selectBoardList(paramMap);
	}

	@Override
	public int selectBoardListCnt(HashMap<String, Object> paramMap) {
		return boardDAO.selectBoardListCnt(paramMap);
	}

	@Override
	public int saveBoard(HashMap<String, Object> paramMap, List<MultipartFile> multipartFile) {
		int resultChk = 0;
		
		String flag = paramMap.get("statusFlag").toString();
		
		if ("I".equals(flag)) {
			resultChk = boardDAO.insertBoard(paramMap);
			
		} else if ("U".equals(flag)) {
			resultChk = boardDAO.updateBoard(paramMap);
		}
		
		// file을 저장할 위치 지정하기
		String filePath = "/ictsaeil/egovTest";
		
		// get(0)을 한 이유 : 첫번째 파일이 없으면 두번째 파일도 없기 때문에 (0)으로 설정
		if(multipartFile.size() > 0 && !multipartFile.get(0).getOriginalFilename().equals("")) {
			for (MultipartFile file : multipartFile) {
				SimpleDateFormat date = new SimpleDateFormat("yyyyMMddHms");
				Calendar cal = Calendar.getInstance(); // Calendar에서 현재 시간을 가져옴
				String today = date.format(cal.getTime()); // cal 변수로 가져온 현재 시간을 "yyyyMMddHms" 형태로 변환
				
				try {
					File fileFolder = new File(filePath);
					
					if(!fileFolder.exists()) {
						if(fileFolder.mkdirs()) {
							// mkdirs() : 폴더를 생성해주는 메소드, 상위 폴더가 없으면 상위 폴더까지 생성 <-> mkdir() : 상위 폴더 없으면 하위 폴더 생성 안됨
							System.out.println("[file.mkdirs] : Success");
						}						
					}
					
					// fileExt : 파일의 확장자만 뽑아내기
					String fileExt = FilenameUtils.getExtension(file.getOriginalFilename());
					File saveFile = new File(filePath, "file_"+today+"."+fileExt);
					file.transferTo(saveFile); // multipartFile로 받아온 file을 saveFile로 바꿔주기
					
				} catch(Exception e) {
					e.printStackTrace();
				}
			}
		}
		
		return resultChk;
	}

	@Override
	public HashMap<String, Object> selectBoardDetail(int boardIdx) {
		return boardDAO.selectBoardDetail(boardIdx);
	}

	@Override
	public int deleteBoard(HashMap<String, Object> paramMap) {
		return boardDAO.deleteBoard(paramMap);
	}

	@Override
	public int insertReply(HashMap<String, Object> paramMap) {
		return boardDAO.insertReply(paramMap);
	}

	@Override
	public List<HashMap<String, Object>> selectBoardReply(HashMap<String, Object> paramMap) {
		return boardDAO.selectBoardReply(paramMap);
	}

	
	
}
