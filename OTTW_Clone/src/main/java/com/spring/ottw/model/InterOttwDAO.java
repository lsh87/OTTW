package com.spring.ottw.model;

import java.util.List;
import java.util.Map;

public interface InterOttwDAO {

	// OTT 카테고리명과 로고 이미지 파일명 가져오기(select)
	List<OttCategoryVO> getOttCategoryList();

	// 아이디 중복검사(select)
	String idDuplicateCheck(String id);

	// 회원가입(insert)
	int signup(MemberVO membervo);

	// 로그인하려는 사용자 VO 가져오기(select)
	MemberVO getLoginUser(Map<String, String> paraMap);

	// 카테고리번호로 카테고리명 알아오기(select)
	String getCategoryName(String categorynum);

	// 파티 진행기간 총 일수 알아오기(select)
	int getTotalDate(Map<String, String> paraMap);

	// 파티번호 중복검사(select)
	String getPartynum(String partynum);

	// 파티 생성하기(insert)
	int createParty(PartyVO pvo);

	// 카테고리번호로 파티 목록 알아오기(select)
	List<PartyVO> getPartyList(String categorynum);

	// 파티번호로 파티 정보 알아오기(select)
	PartyVO getParty(String partynum);

	// 파티원 아이디 중복검사(select)
	String partymemberidDuplicateCheck(Map<String, String> paraMap);

	// 파티 모집인원 알아오기(select)
	int getNumberOfPerson(Map<String, String> paraMap);

	// 파티원 추가하기(insert)
	int addPartyMember(Map<String, String> paraMap);

	// 모집 인원 감소하기(update)
	void subNumberOfPerson(Map<String, String> paraMap);

	// 파티 상태 변경하기(update) : 모집중 -> 모집완료
	void changePartyStatus(Map<String, String> paraMap);

	// 파티에 참여중인 파티원 알아오기(select)
	List<PartyMemberVO> getPartyMemberList(String partynum);

	// 로그인 중인 사용자가 참여한 파티 목록(select)
	List<PartyVO> getAttendPartyList(String id);

	// 로그인 중인 사용자가 생성한 파티 목록(select)
	List<PartyVO> getCreatePartyList(String id);

	// 회원 정보 알아오기(select)
	MemberVO getMemberInfo(String id);

	// 입력받은 비밀번호가 로그인 중인 사용자의 비밀번호가 맞는지 알아오기(select)
	String getId(Map<String, String> paraMap);

	// 회원 정보 수정하기(update)
	int editMemberInfo(MemberVO mvo);

	// 파티 기간 만료 여부 알아오기(select)
	int isExpiredEnddate(String enddate);

	// 파티 수정하기(update)
	int editParty(PartyVO pvo);

	// 파티 삭제하기(delete)
	int delParty(String partynum);

}
