package com.spring.ottw.model;

public class MemberVO {
	
	private String id;			// 아이디
	private String pwd;			// 비밀번호
	private String name;		// 이름
	private String birthday;	// 생년월일
	private String phone;		// 휴대전화
	private String email;		// 이메일
	private int memberstatus;	// 회원상태(0: 휴면, 1: 정상)
	
	public MemberVO() {}

	public MemberVO(String id, String pwd, String name, String birthday, String phone, String email, int memberstatus) {
		super();
		this.id = id;
		this.pwd = pwd;
		this.name = name;
		this.birthday = birthday;
		this.phone = phone;
		this.email = email;
		this.memberstatus = memberstatus;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPwd() {
		return pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getBirthday() {
		return birthday;
	}

	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public int getMemberstatus() {
		return memberstatus;
	}

	public void setMemberstatus(int memberstatus) {
		this.memberstatus = memberstatus;
	}
	
}
