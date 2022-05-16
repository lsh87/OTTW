package com.spring.ottw.controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.ottw.common.GoogleMail;
import com.spring.ottw.common.MyUtil;
import com.spring.ottw.common.Sha256;
import com.spring.ottw.model.MemberVO;
import com.spring.ottw.model.OttCategoryVO;
import com.spring.ottw.model.PartyMemberVO;
import com.spring.ottw.model.PartyVO;
import com.spring.ottw.service.InterOttwService;
import com.spring.ottw.service.OttwService;

@Component
@Controller
public class OttwController {
	
	@Autowired	// Type에 따라 알아서 Bean을 주입해준다.
	private InterOttwService service;
	
	@Autowired
	private GoogleMail mail;
	
	//=== 로그인 또는 로그아웃을 했을때 현재 보이던 그 페이지로 그대로 돌아가기 위한 메소드 생성
	public void getCurrentURL(HttpServletRequest request) {
		HttpSession session= request.getSession();
		session.setAttribute("goBackURL", MyUtil.getCurrentURL(request));	
	}//end of public void getCurrentURL(HttpServletRequest request)
	
	////////////////////////////////////////////////////////////////////////
	
	// === 메인 페이지 요청 === //
	@RequestMapping(value="/index.ottw")
	public ModelAndView index(ModelAndView mav, HttpServletRequest request) {
		
		getCurrentURL(request);
		
		List<OttCategoryVO> ottCategoryList = service.getOttCategoryList();
		
		mav.addObject("ottCategoryList", ottCategoryList);
		mav.setViewName("main/index.tiles1");
		
		return mav;
	}
	
	
	// === 로그인 페이지 요청 === //
	@RequestMapping(value="/login.ottw")
 	public ModelAndView login(ModelAndView mav) {
 		
 		mav.setViewName("login/loginform.tiles1");
 		// /WEB-INF/views/tiles1/login/loginform.jsp 파일을 생성한다.
 		
 		return mav;
 	}
	
	
	// === 로그인 처리 === //
	@RequestMapping(value="/loginEnd.ottw", method={RequestMethod.POST})
	public ModelAndView loginEnd(ModelAndView mav, HttpServletRequest request) {
		
		String id = request.getParameter("id");
		String pwd = request.getParameter("pwd");
		String clientip = request.getRemoteAddr();	// 0:0:0:0:0:0:0:1
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("id", id);
		paraMap.put("pwd", Sha256.encrypt(pwd));
		paraMap.put("clientip", clientip);
		
		MemberVO loginuser = service.getLoginUser(paraMap);
		
		if(loginuser == null) { // 로그인 실패
			mav.addObject("message", "아이디 또는 비밀번호가 올바르지 않습니다.");
			mav.addObject("loc", "javascript:history.back()");
			
			mav.setViewName("msg");
		}
		else {
			if(loginuser.getMemberstatus() == 0) { // 휴면 상태의 회원인 경우
				mav.addObject("message", "해당 계정은 휴면 상태로 전환되었습니다.\\n관리자에게 문의바랍니다.");
				mav.addObject("loc", request.getContextPath() + "/index.ottw");
				// 휴면 상태 해제 페이지로 이동해야함.
				
				mav.setViewName("msg");
			}
			else {
				
				HttpSession session = request.getSession();
				
				session.setAttribute("loginuser", loginuser);
				
				String goBackURL = (String)session.getAttribute("goBackURL");
					
				if(goBackURL != null) {
					mav.setViewName("redirect:" + goBackURL);
					session.removeAttribute("goBackURL"); // 세션에서 반드시 제거해주어야 한다.
				}
				else {
					mav.setViewName("redirect:/index.ottw"); // 시작페이지로 이동
				}
			}
		}
		return mav;
	}
	
	
	// === 로그아웃 처리 === //
	@RequestMapping(value="/logout.ottw")
	public ModelAndView logout(ModelAndView mav, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		
		String goBackURL = (String)session.getAttribute("goBackURL");
		System.out.println("확인용 goBackURL => " + goBackURL);
		
		session.invalidate();
		
		if(goBackURL != null) {
			mav.setViewName("redirect:" + goBackURL);
		}
		else {
			mav.setViewName("redirect:/index.ottw");
		}
		
		return mav;
	}
	
	
	// === 회원가입 페이지 요청 === //
	@RequestMapping(value="/signup.ottw")
	public ModelAndView signup(ModelAndView mav) {
		
		mav.setViewName("member/signupform.tiles1");
		
		return mav;
	}
	
	// === 아이디 중복검사 === //
	@ResponseBody
	@RequestMapping(value="/idDuplicateCheck.ottw", method={RequestMethod.GET}, produces="text/plain;charset=UTF-8")
	public String idDuplicateCheck(HttpServletRequest request) {
		
		String id = request.getParameter("id");

		String tbl_memberId = service.idDuplicateCheck(id);
		
		boolean isDuplicateId = false;
		if(tbl_memberId != null) { // 아이디가 중복인 경우
			isDuplicateId = true;
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("isDuplicateId", isDuplicateId);
		
		return jsonObj.toString();
	}
	
	
	// === 회원가입 처리 === //
	@RequestMapping(value="/signupEnd.ottw", method={RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public ModelAndView signupEnd(ModelAndView mav, MemberVO membervo, HttpServletRequest request) {
		
		int n = service.signup(membervo);
		
		if(n == 1) {
			mav.addObject("message", "회원 가입이 완료되었습니다.");
			mav.addObject("loc", request.getContextPath()+"/index.ottw");
			
			mav.setViewName("msg");
		}
		else {
			mav.addObject("message", "회원 가입에 실패했습니다.");
			mav.addObject("loc", "javascript:history.back()");
			
			mav.setViewName("msg");
		}
		return mav;
	}
	
	
	// === 카테고리별 파티 리스트 페이지 요청 === //
	@RequestMapping(value="/categoryList.ottw", method={RequestMethod.GET})
	public ModelAndView categoryList(ModelAndView mav, HttpServletRequest request) {
		
		getCurrentURL(request);
		
		String categorynum = request.getParameter("categorynum");
		
		// 입력 값으로 장난치는 경우 방지(문자 입력, 카테고리번호 범위에 없는 번호 입력)
		
		// 카테고리번호로 카테고리명 알아오기(select)
		String categoryname = service.getCategoryName(categorynum);
		mav.addObject("categoryname", categoryname);
		
		// 카테고리번호로 파티 목록 알아오기(select)
		List<PartyVO> partyList = service.getPartyList(categorynum);
		mav.addObject("partyList", partyList);
		
		// 해당 페이지를 조회할 때마다 모집 중인 파티 중 종료 일자가 지난 경우 자동 파티 상태 2로 전환
		for(PartyVO pvo : partyList) {
			Map<String, String> paraMap = new HashMap<>();
			int n = service.isExpiredEnddate(pvo.getEnddate());
			
			if(n < 0 && pvo.getPartystatus() == 0) {
				pvo.setPartystatus(2);
				
				paraMap.put("partystatus", "2");
				paraMap.put("partynum", pvo.getPartynum());
				
				service.changePartyStatus(paraMap);
			}
		}
		
		mav.setViewName("main/categoryList.tiles1");
		
		return mav;
	}
	
	
	// === 파티 생성하기 페이지 요청 === //
	@RequestMapping(value="/createParty.ottw")
	public ModelAndView requiredLogin_createParty(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		List<OttCategoryVO> ottCategoryList = service.getOttCategoryList();
		mav.addObject("ottCategoryList", ottCategoryList);
		
		mav.setViewName("party/createParty.tiles1");
		
		return mav;
	}
	
	
	// === 파티 진행기간 총 일수 알아오기(Ajax) === //
	@ResponseBody
	@RequestMapping(value="/checkDate.ottw", method={RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public String checkDate(HttpServletRequest request) {
		
		String startdate = request.getParameter("startdate");
		String enddate = request.getParameter("enddate");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("startdate", startdate);
		paraMap.put("enddate", enddate);
		
		int totalDate = service.getTotalDate(paraMap);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("totalDate", totalDate);
		
		return jsonObj.toString();
	}
	
	
	// === 파티 생성하기 === //
	@RequestMapping(value="/createPartyEnd.ottw")
	public ModelAndView createPartyEnd(ModelAndView mav, PartyVO pvo, HttpServletRequest request) {

		String partynum = "";
		boolean isDuplicatePartynum = false;
		do {
			// 파티번호 랜덤생성(8자리) 및 중복검사
			Random rnd = new Random();
			
			for(int i = 0; i < 8; i++) {
				partynum += rnd.nextInt(9 - 0 + 1) + 0;
			}
			
			// 파티번호 중복검사(혹시나)
			String tbl_partynum = service.getPartynum(partynum);
			if(tbl_partynum != null) {
				isDuplicatePartynum = true;
			}

		} while(isDuplicatePartynum);
		
		// 파티 생성(insert)
		pvo.setPartynum(partynum);
		
		int n = service.createParty(pvo);
				
		if(n == 1) {
			mav.addObject("message", "파티가 생성되었습니다.");
			mav.addObject("loc", request.getContextPath() + "/categoryList.ottw?categorynum=" + pvo.getFk_categorynum());
			
			mav.setViewName("msg");
		}
		else {
			mav.addObject("message", "파티 생성에 실패했습니다.");
			mav.addObject("loc", "javascript:history.back()");
			
			mav.setViewName("msg");
		}
		
		return mav;
	}
	
	
	// === 파티 상세 내용 페이지 요청하기 === //
	@RequestMapping(value="/showParty.ottw")
	public ModelAndView showParty(ModelAndView mav, HttpServletRequest request) {
		
		getCurrentURL(request);
		
		String partynum = request.getParameter("partynum");
		
		PartyVO pvo = service.getParty(partynum);
		List<PartyMemberVO> partyMemberList = service.getPartyMemberList(partynum);
		
		mav.addObject("pvo", pvo);
		mav.addObject("partyMemberList", partyMemberList);
		
		HttpSession session = request.getSession();
  		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
  		
  		// 로그인 중인 회원의 아이디와 파티장의 아이디 or 파티 참여 중인 회원의 아이디인 경우
  		// ott 계정의 아이디와 비밀번호를 확인할 수 있다.
  		boolean showAttendPartyBtn = true;
  		boolean showOttIdPwd = false;
  		boolean isPartyleader = false;
  		
  		if(loginuser != null) {
	  		if(loginuser.getId().equals(pvo.getPartyleaderid())) {
	  			showAttendPartyBtn = false;
	  			showOttIdPwd = true;
	  			isPartyleader = true;
	  		}
	  		
	  		for(PartyMemberVO pmvo : partyMemberList) {
	  			if(loginuser.getId().equals(pmvo.getPartymemberid())) {
	  				showAttendPartyBtn = false;
	  				showOttIdPwd = true;
	  			}
	  		}
  		}
  	
  		mav.addObject("showAttendPartyBtn", showAttendPartyBtn);
  		mav.addObject("showOttIdPwd", showOttIdPwd);
  		mav.addObject("isPartyleader", isPartyleader);
  		
  		
  		// 현재 기준으로 종료 일자까지 남은 일 수 알아오기
  		LocalDate today = LocalDate.now();
  		String startdate = String.valueOf(today);
  		String enddate = pvo.getEnddate();
  		
  		Map<String, String> paraMap	= new HashMap<>();
  		paraMap.put("startdate", startdate);
  		paraMap.put("enddate", enddate);
  		
  		int totalDate = service.getTotalDate(paraMap);
  		
  		mav.addObject("totalDate", totalDate);
  		
		mav.setViewName("party/showParty.tiles1");
		
		return mav;
	}
	
	
	// === 파티 참여하기 페이지 요청하기(포인트 결제) === //
	@RequestMapping(value="/attendParty.ottw")
	public ModelAndView attendParty(ModelAndView mav) {
		
		
		
		return mav;
	}
	
	
	// === 파티 참여하기(임시_참여하고자하는 회원 아이디, 파티번호를 받아와야함) === //
	@RequestMapping(value="/attendPartyEnd.ottw")
	public ModelAndView requiredLogin_attendPartyEnd(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		String partynum = request.getParameter("partynum");
		
		HttpSession session = request.getSession();
  		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		String partymemberid = loginuser.getId();
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("partynum", partynum);
		paraMap.put("partymemberid", partymemberid);
		
		// 파티원 아이디 중복검사(select)
		String tbl_partymemberid = service.partymemberidDuplicateCheck(paraMap);
	
		boolean isDuplicatePartymemberid = false;
		if(tbl_partymemberid != null) { // 아이디가 중복인 경우
			isDuplicatePartymemberid = true;
		}
		
		// 중복이 아니라면 파티 참여 처리 후 파티 상세 페이지로 이동
		if(isDuplicatePartymemberid) {
			mav.addObject("message", "이미 참여중인 파티입니다.");
			mav.addObject("loc", "javascript:history.back()");
			
			mav.setViewName("msg");
		}
		else {
			// 파티원 추가하기(insert)
			int n = service.addPartyMember(paraMap);
			
			if(n == 1) {
				// 모집 인원 감소하기(update)
			//	service.subNumberOfPerson(paraMap);
				
				// 파티 모집인원 알아오기(select)
				int nop = service.getNumberOfPerson(paraMap);
				
				if(nop == 0) {
					// 파티 상태 변경하기(update) : 모집중 -> 모집완료
					paraMap.put("partystatus", "1");
					
					service.changePartyStatus(paraMap);
				}
				
				mav.addObject("message", "파티에 참여되었습니다.");
				mav.addObject("loc", request.getContextPath() + "/showParty.ottw?partynum=" + partynum);
			
				mav.setViewName("msg");
			}
			else {
				mav.addObject("message", "파티에 참여할 수 없습니다.");
				mav.addObject("loc", "javascript:history.back()");
			
				mav.setViewName("msg");
			}
		}
		
		return mav;
	}
	
	
	// === 파티 참여 목록, 파티 생성 목록 페이지 요청하기 === //
	@RequestMapping(value="/partyList.ottw")
	public ModelAndView requiredLogin_partyList(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		HttpSession session = request.getSession();
  		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
  		String id = loginuser.getId();
		
  		// 로그인 중인 사용자가 참여한 파티 목록
		List<PartyVO> attendPartyList = service.getAttendPartyList(id);
		
		// 로그인 중인 사용자가 생성한 파티 목록
		List<PartyVO> createPartyList = service.getCreatePartyList(id);
		
		mav.addObject("attendPartyList", attendPartyList);
		mav.addObject("createPartyList", createPartyList);
		
		mav.setViewName("party/partyList.tiles1");
		
		return mav;
	}
	
	
	// === 회원 정보 페이지 요청하기 === //
	@RequestMapping(value="/memberInfo.ottw")
	public ModelAndView requiredLogin_memberInfo(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		HttpSession session = request.getSession();
  		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
  		String id = loginuser.getId();
		
		MemberVO mvo = service.getMemberInfo(id);
		
		mav.addObject("mvo", mvo);
		
		mav.setViewName("member/memberInfo.tiles1");
		
		return mav;
	}
	
	
	// === 회원 정보 수정 전 비밀번호 확인 페이지 요청하기 === //
	@ResponseBody
	@RequestMapping(value="/checkPassword.ottw", method={RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public String checkPassword(HttpServletRequest request) {
		
		String id = request.getParameter("id");
		String checkPwd = request.getParameter("checkPwd");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("id", id);
		paraMap.put("checkPwd", Sha256.encrypt(checkPwd));
		
		String tbl_id = service.getId(paraMap);
		
		boolean isExist = false;
		if(tbl_id != null) {
			isExist = true;
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("isExist", isExist);
		
		return jsonObj.toString();
	}
	
	
	// === 회원 정보 수정 페이지 요청하기 === //
	@RequestMapping(value="/editMemberInfo.ottw")
	public ModelAndView editMemberInfo(ModelAndView mav, MemberVO mvo) {
		
		mav.addObject("mvo", mvo);
		
		mav.setViewName("member/editMemberInfo.tiles1");
		
		return mav;
	}
	
	
	// === 회원 정보 수정하기(update) === //
	@RequestMapping(value="/editMemberInfoEnd.ottw")
	public ModelAndView editMemberInfoEnd(ModelAndView mav, MemberVO mvo, HttpServletRequest request) {
		
		int n = service.editMemberInfo(mvo);
		
		if(n == 1) {
			mav.addObject("message", "회원 정보가 수정되었습니다.");
			mav.addObject("loc", request.getContextPath()+"/memberInfo.ottw");
			
			mav.setViewName("msg");
		}
		else {
			mav.addObject("message", "회원 정보 수정에 실패했습니다.");
			mav.addObject("loc", "javascript:history.back()");
			
			mav.setViewName("msg");
		}
		
		return mav;
	}
	
	
	// === 파티 수정 페이지 요청하기 === //
	@RequestMapping(value="/editParty.ottw")
	public ModelAndView editParty(ModelAndView mav, PartyVO pvo, HttpServletRequest request) {
		
		List<OttCategoryVO> ottCategoryList = service.getOttCategoryList();
		mav.addObject("ottCategoryList", ottCategoryList);
		
		String enddate = pvo.getEnddate().replaceAll("\\.", "\\-");
		pvo.setEnddate(enddate);
		
		mav.addObject("pvo", pvo);
		
		mav.setViewName("party/editParty.tiles1");
		
		return mav;
	}
	
	
	// === 파티 수정하기(update) === //
	@RequestMapping(value="/editPartyEnd.ottw")
	public ModelAndView editPartyEnd(ModelAndView mav, PartyVO pvo, HttpServletRequest request) {
		
		int n = service.editParty(pvo);
		
		if(n == 1) {
			mav.addObject("message", "파티 정보가 수정되었습니다.");
			mav.addObject("loc", request.getContextPath()+"/showParty.ottw?partynum="+pvo.getPartynum());
			
			mav.setViewName("msg");
		}
		else {
			mav.addObject("message", "파티 정보 수정에 실패했습니다.");
			mav.addObject("loc", "javascript:history.back()");
			
			mav.setViewName("msg");
		}
		
		return mav;
	}
	
	
	// === 파티 삭제하기(delete) === //
	@RequestMapping(value="/delParty.ottw")
	public ModelAndView delPartyEnd(ModelAndView mav, PartyVO pvo, HttpServletRequest request) {
		
		int n = service.delParty(pvo.getPartynum());
		
		if(n == 1) {
			mav.addObject("message", "파티가 삭제되었습니다.");
			mav.addObject("loc", request.getContextPath()+"/index.ottw");
			
			mav.setViewName("msg");
		}
		else {
			mav.addObject("message", "파티 삭제에 실패했습니다.");
			mav.addObject("loc", "javascript:history.back()");
			
			mav.setViewName("msg");
		}
		
		return mav;
	}
}
