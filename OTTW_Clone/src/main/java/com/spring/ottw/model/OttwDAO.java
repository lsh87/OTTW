package com.spring.ottw.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.ottw.common.AES256;
import com.spring.ottw.common.Sha256;

// === #32. DAO 선언 === //
@Repository
public class OttwDAO implements InterOttwDAO {

	@Autowired
	private AES256 aes;
	
	@Resource
	private SqlSessionTemplate sqlsession;

	// OTT 카테고리명과 로고 이미지 파일명 가져오기(select)
	@Override
	public List<OttCategoryVO> getOttCategoryList() {

		List<OttCategoryVO> ottCategoryList = sqlsession.selectList("ottw.getOttCategoryList");
		
		return ottCategoryList;
	}

	
	// 아이디 중복검사(select)
	@Override
	public String idDuplicateCheck(String id) {

		String tbl_memberId = sqlsession.selectOne("ottw.idDuplicateCheck", id);
		
		return tbl_memberId;
	}


	// 회원가입(insert)
	@Override
	public int signup(MemberVO membervo) {

		String pwd = membervo.getPwd();
		String phone = membervo.getPhone();
		String email = membervo.getEmail();
		
		try {
			// 비밀번호 (SHA-256 암호화 대상)
			membervo.setPwd(Sha256.encrypt(pwd));
			// 휴대전화 (AES-256 암호화/복호화 대상)
			membervo.setPhone(aes.encrypt(phone));
			// 이메일 (AES-256 암호화/복호화 대상)
			membervo.setEmail(aes.encrypt(email));
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		int n = sqlsession.insert("ottw.signup", membervo);
		
		return n;
	}


	// 로그인하려는 사용자 VO 가져오기(select)
	@Override
	public MemberVO getLoginUser(Map<String, String> paraMap) {

		MemberVO loginuser = sqlsession.selectOne("ottw.getLoginUser", paraMap);
		
		if(loginuser != null) {
			// 로그인하려는 사용자의 마지막 로그인 기록이 현재 기준 얼마나 경과했는지 조회하기(select)
			List<Integer> logList = sqlsession.selectList("ottw.getLastLogin", paraMap);
			
			int lastlogin = 0;
			if(logList.size() != 0) {
				lastlogin = logList.get(0);
			}
			
			// 마지막 로그인 기록이 현재 기준 12개월이 경과한 경우라면 회원 상태를 휴면으로 전환
			if(lastlogin >= 12) {
				loginuser.setMemberstatus(0);
				sqlsession.update("ottw.updateMemberStatus", paraMap);
			}
			
			if(loginuser.getMemberstatus() != 0) {
				sqlsession.insert("ottw.insertLog", paraMap);
			}
		}
		
		return loginuser;
	}


	// 카테고리번호로 카테고리명 알아오기(select)
	@Override
	public String getCategoryName(String categorynum) {

		String categoryname = sqlsession.selectOne("ottw.getCategoryName", categorynum);
		
		return categoryname;
	}


	// 파티 진행기간 총 일수 알아오기(select)
	@Override
	public int getTotalDate(Map<String, String> paraMap) {

		int totalDate = sqlsession.selectOne("ottw.getTotalDate", paraMap);
		
		return totalDate;
	}


	// 파티번호 중복검사(select)
	@Override
	public String getPartynum(String partynum) {

		String tbl_partynum = sqlsession.selectOne("ottw.getPartynum", partynum);
		
		return tbl_partynum;
	}


	// 파티 생성하기(insert)
	@Override
	public int createParty(PartyVO pvo) {

		int n = sqlsession.insert("ottw.createParty", pvo);
		
		return n;
	}


	// 카테고리번호로 파티 목록 알아오기(select)
	@Override
	public List<PartyVO> getPartyList(String categorynum) {

		List<PartyVO> partyList = sqlsession.selectList("ottw.getPartyList", categorynum);
		
		return partyList;
	}


	// 파티번호로 파티 정보 알아오기(select)
	@Override
	public PartyVO getParty(String partynum) {

		PartyVO pvo = sqlsession.selectOne("ottw.getParty", partynum);
		
		return pvo;
	}


	// 파티원 아이디 중복검사(select)
	@Override
	public String partymemberidDuplicateCheck(Map<String, String> paraMap) {
		
		String tbl_partymemberid = sqlsession.selectOne("ottw.partymemberidDuplicateCheck", paraMap); 
		
		return tbl_partymemberid;
	}


	// 파티 모집인원 알아오기(select)
	@Override
	public int getNumberOfPerson(Map<String, String> paraMap) {

		int nop = sqlsession.selectOne("ottw.getNumberOfPerson", paraMap);
		
		return nop;
	}


	// 파티원 추가하기(insert)
	@Override
	public int addPartyMember(Map<String, String> paraMap) {

		int n = sqlsession.insert("ottw.addPartyMember", paraMap);
		
		return n;
	}


	// 모집 인원 감소하기(update)
	@Override
	public void subNumberOfPerson(Map<String, String> paraMap) {
		
		sqlsession.update("ottw.subNumberOfPerson", paraMap);
	}


	// 파티 상태 변경하기(update) : 모집중 -> 모집완료
	@Override
	public void changePartyStatus(Map<String, String> paraMap) {
		sqlsession.update("ottw.changePartyStatus", paraMap);
	}


	// 파티에 참여중인 파티원 알아오기(select)
	@Override
	public List<PartyMemberVO> getPartyMemberList(String partynum) {

		List<PartyMemberVO> partyMemberList = sqlsession.selectList("ottw.getPartyMemberList", partynum);
		
		return partyMemberList;
	}


	// 로그인 중인 사용자가 참여한 파티 목록(select)
	@Override
	public List<PartyVO> getAttendPartyList(String id) {

		List<PartyVO> attendPartyList = sqlsession.selectList("ottw.getAttendPartyList", id);
		
		return attendPartyList;
	}


	// 로그인 중인 사용자가 생성한 파티 목록(select)
	@Override
	public List<PartyVO> getCreatePartyList(String id) {

		List<PartyVO> createPartyList = sqlsession.selectList("ottw.getCreatePartyList", id);
		
		return createPartyList;
	}


	// 회원 정보 알아오기(select)
	@Override
	public MemberVO getMemberInfo(String id) {

		MemberVO mvo = sqlsession.selectOne("ottw.getMemberInfo", id);
		
		return mvo;
	}


	// 입력받은 비밀번호가 로그인 중인 사용자의 비밀번호가 맞는지 알아오기(select)
	@Override
	public String getId(Map<String, String> paraMap) {
		
		String tbl_id = sqlsession.selectOne("ottw.getId", paraMap);
		
		return tbl_id;
	}


	// 회원 정보 수정하기(update)
	@Override
	public int editMemberInfo(MemberVO mvo) {
		
		String phone = mvo.getPhone();
		String email = mvo.getEmail();
		
		try {
			// 휴대전화 (AES-256 암호화/복호화 대상)
			mvo.setPhone(aes.encrypt(phone));
			// 이메일 (AES-256 암호화/복호화 대상)
			mvo.setEmail(aes.encrypt(email));
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		int n = sqlsession.update("ottw.editMemberInfo", mvo);
		
		return n;
	}


	// 파티 기간 만료 여부 알아오기(select)
	@Override
	public int isExpiredEnddate(String enddate) {

		int n = sqlsession.selectOne("ottw.isExpiredEnddate", enddate);
		
		return n;
	}


	// 파티 수정하기(update)
	@Override
	public int editParty(PartyVO pvo) {

		int n = sqlsession.update("ottw.editParty", pvo);
		
		return n;
	}


	// 파티 삭제하기(delete)
	@Override
	public int delParty(String partynum) {

		int n = sqlsession.delete("ottw.delParty", partynum);
		
		return n;
	}
}
