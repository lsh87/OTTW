package com.spring.ottw.service;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.ottw.common.AES256;
import com.spring.ottw.common.GoogleMail;
import com.spring.ottw.model.InterOttwDAO;
import com.spring.ottw.model.MemberVO;
import com.spring.ottw.model.OttCategoryVO;
import com.spring.ottw.model.PartyMemberVO;
import com.spring.ottw.model.PartyVO;

// === #31. Service 선언 === //
// 트랜잭션 처리를 담당하는 곳, 업무를 처리하는 곳, 비지니스(Business)단
@Service
public class OttwService implements InterOttwService {

	@Autowired
	private InterOttwDAO dao;
	
	@Autowired
	private AES256 aes;
	
	@Autowired
	private GoogleMail mail;
	
	// OTT 카테고리명과 로고 이미지 파일명 가져오기(select)
	@Override
	public List<OttCategoryVO> getOttCategoryList() {

		List<OttCategoryVO> ottCategoryList = dao.getOttCategoryList();
		
		return ottCategoryList;
	}

	
	// 아이디 중복검사(select)
	@Override
	public String idDuplicateCheck(String id) {

		String tbl_memberId = dao.idDuplicateCheck(id);
		
		return tbl_memberId;
	}

	
	// 회원가입(insert)
	@Override
	public int signup(MemberVO membervo) {

		int n = dao.signup(membervo);
		
		if(n == 1) {
			String emailContents = "OTTW의 회원이 되신 것을 진심으로 감사드립니다.<br>파티 생성 및 참여를 통해 빠르고 쉽게 OTT를 이용해보시길 추천드립니다.";
			try {
				mail.sendmail_signup(aes.decrypt(membervo.getEmail()), emailContents);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return n;
	}


	// 로그인하려는 사용자 VO 가져오기(select)
	@Override
	public MemberVO getLoginUser(Map<String, String> paraMap) {

		MemberVO loginuser = dao.getLoginUser(paraMap);
		
		if(loginuser != null) {
			String phone = "";
			String email = "";
			
			try {
				phone = aes.decrypt(loginuser.getPhone());
				email = aes.decrypt(loginuser.getEmail());
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			}
			
			loginuser.setPhone(phone);
			loginuser.setEmail(email);
		}
		
		return loginuser;
	}


	// 카테고리번호로 카테고리명 알아오기(select)
	@Override
	public String getCategoryName(String categorynum) {
		
		String categoryname = dao.getCategoryName(categorynum);
		
		return categoryname;
	}


	// 파티 진행기간 총 일수 알아오기(select)
	@Override
	public int getTotalDate(Map<String, String> paraMap) {

		int totalDate = dao.getTotalDate(paraMap);
		
		return totalDate;
	}


	// 파티번호 중복검사(select)
	@Override
	public String getPartynum(String partynum) {

		String tbl_partynum = dao.getPartynum(partynum);
		
		return tbl_partynum;
	}


	// 파티 생성하기(insert)
	@Override
	public int createParty(PartyVO pvo) {

		int n = dao.createParty(pvo);
		
		return n;
	}


	// 카테고리번호로 파티 목록 알아오기(select)
	@Override
	public List<PartyVO> getPartyList(String categorynum) {

		List<PartyVO> partyList = dao.getPartyList(categorynum);
		
		return partyList;
	}


	// 파티번호로 파티 정보 알아오기(select)
	@Override
	public PartyVO getParty(String partynum) {

		PartyVO pvo = dao.getParty(partynum);
		
		return pvo;
	}


	// 파티원 아이디 중복검사(select)
	@Override
	public String partymemberidDuplicateCheck(Map<String, String> paraMap) {

		String tbl_partymemberid = dao.partymemberidDuplicateCheck(paraMap);
		
		return tbl_partymemberid;
	}


	// 파티 모집인원 알아오기(select)
	@Override
	public int getNumberOfPerson(Map<String, String> paraMap) {

		int nop = dao.getNumberOfPerson(paraMap);
		
		return nop;
	}


	// 파티원 추가하기(insert)
	@Override
	public int addPartyMember(Map<String, String> paraMap) {

		int n = dao.addPartyMember(paraMap);
		
		return n;
	}


	// 모집 인원 감소하기(update)
	@Override
	public void subNumberOfPerson(Map<String, String> paraMap) {
		
		dao.subNumberOfPerson(paraMap);
	}


	// 파티 상태 변경하기(update) : 모집중 -> 모집완료
	@Override
	public void changePartyStatus(Map<String, String> paraMap) {
		dao.changePartyStatus(paraMap);
	}


	// 파티에 참여중인 파티원 알아오기(select)
	@Override
	public List<PartyMemberVO> getPartyMemberList(String partynum) {

		List<PartyMemberVO> partyMemberList = dao.getPartyMemberList(partynum);
		
		return partyMemberList;
	}


	// 로그인 중인 사용자가 참여한 파티 목록(select)
	@Override
	public List<PartyVO> getAttendPartyList(String id) {

		List<PartyVO> attendPartyList = dao.getAttendPartyList(id);
		
		return attendPartyList;
	}


	// 로그인 중인 사용자가 생성한 파티 목록(select)
	@Override
	public List<PartyVO> getCreatePartyList(String id) {

		List<PartyVO> createPartyList = dao.getCreatePartyList(id);
		
		return createPartyList;
	}


	// 회원 정보 알아오기(select)
	@Override
	public MemberVO getMemberInfo(String id) {

		MemberVO mvo = dao.getMemberInfo(id);
		
		if(mvo != null) {
			String phone = "";
			String email = "";
			
			try {
				phone = aes.decrypt(mvo.getPhone());
				email = aes.decrypt(mvo.getEmail());
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			}
			
			mvo.setPhone(phone);
			mvo.setEmail(email);
		}
		
		return mvo;
	}


	// 입력받은 비밀번호가 로그인 중인 사용자의 비밀번호가 맞는지 알아오기(select)
	@Override
	public String getId(Map<String, String> paraMap) {

		String tbl_id = dao.getId(paraMap);
		
		return tbl_id;
	}


	// 회원 정보 수정하기(update)
	@Override
	public int editMemberInfo(MemberVO mvo) {

		int n = dao.editMemberInfo(mvo);
		
		return n;
	}


	// 파티 기간 만료 여부 알아오기(select)
	@Override
	public int isExpiredEnddate(String enddate) {

		int n = dao.isExpiredEnddate(enddate);
		
		return n;
	}


	// 파티 수정하기(update)
	@Override
	public int editParty(PartyVO pvo) {

		int n = dao.editParty(pvo);
		
		return n;
	}


	// 파티 삭제하기(delete)
	@Override
	public int delParty(String partynum) {

		int n = dao.delParty(partynum);
		
		return n;
	}

}
