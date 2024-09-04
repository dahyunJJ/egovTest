package egovframework.com.main.serviceImpl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.main.service.MainService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MainService")
public class MainServiceImpl extends EgovAbstractServiceImpl implements MainService{	
	@Resource(name="MainDAO")
	private MainDAO mainDAO;

	@Override
	public int selectIdChk(HashMap<String, Object> paramMap) {
		return mainDAO.selectIdChk(paramMap);
	}

	@Override
	public int insertMember(HashMap<String, Object> paramMap) {
		return mainDAO.insertMember(paramMap);
	}

	@Override
	public HashMap<String, Object> selectLoginInfo(HashMap<String, Object> paramMap) {
		return mainDAO.selectLoginInfo(paramMap);
	}

	@Override
	public int updateMember(HashMap<String, Object> paramMap) {		
		return mainDAO.updateMember(paramMap);
	}

	@Override
	public HashMap<String, Object> selectMemberInfo(HashMap<String, Object> paramMap) {
		return mainDAO.selectMemberInfo(paramMap);
	}

	@Override
	public int deleteMemberInfo(int memberIdx) {
		return mainDAO.deleteMemberInfo(memberIdx);
	}

	@Override
	public List<String> selectFindId(HashMap<String, Object> paramMap) {
		return mainDAO.selectFindId(paramMap);
	}

	@Override
	public int selectMemberCertification(HashMap<String, Object> paramMap) {
		// null값일 경우 int 형 변환에서 에러가 나기 때문에, 먼저 memberIdx가 있는지 체크한 후 있을 경우 값 반환
		// memberIdx가 없다면 0을 반환
		
		int chk = 0;
		int memberIdx = 0;
		chk =  mainDAO.selectMemberCertificationChk(paramMap);
		
		if(chk > 0) {
			memberIdx = mainDAO.selectMemberCertification(paramMap);
		} 
		
		return memberIdx; 
	}

	@Override
	public int updatePwd(HashMap<String, Object> paramMap) {
		return mainDAO.updatePwd(paramMap);
	}
}
