package com.spring.ottw.model;

public class PartyVO {

	private String partynum;		// 파티번호
	private String partyname;		// 파티명
	private String startdate;		// 파티시작일자
	private String enddate;			// 파티종료일자
	private int nop;				// 파티모집인원
	private int charge;				// 파티이용요금
	private int fk_categorynum;		// 카테고리번호
	private String partyleaderid;	// 파티장아이디
	private int partystatus;		// 파티상태(0: 모집중, 1: 모집완료, 2: 만료)
	private String ottid;			// OTT 계정 아이디
	private String ottpwd;			// OTT 계정 비밀번호
	
	private String categoryname;	// OTT 카테고리명
	
	public PartyVO() {}

	public PartyVO(String partynum, String partyname, String startdate, String enddate, int nop, int charge,
			int fk_categorynum, String partyleaderid, String partymemberid, int partystatus, String ottid, 
			String ottpwd) {
		this.partynum = partynum;
		this.partyname = partyname;
		this.startdate = startdate;
		this.enddate = enddate;
		this.nop = nop;
		this.charge = charge;
		this.fk_categorynum = fk_categorynum;
		this.partyleaderid = partyleaderid;
		this.partystatus = partystatus;
		this.ottid = ottid;
		this.ottpwd = ottpwd;
	}

	public String getPartynum() {
		return partynum;
	}

	public void setPartynum(String partynum) {
		this.partynum = partynum;
	}

	public String getPartyname() {
		return partyname;
	}

	public void setPartyname(String partyname) {
		this.partyname = partyname;
	}

	public String getStartdate() {
		return startdate;
	}

	public void setStartdate(String startdate) {
		this.startdate = startdate;
	}

	public String getEnddate() {
		return enddate;
	}

	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}

	public int getNop() {
		return nop;
	}

	public void setNop(int nop) {
		this.nop = nop;
	}

	public int getCharge() {
		return charge;
	}

	public void setCharge(int charge) {
		this.charge = charge;
	}

	public int getFk_categorynum() {
		return fk_categorynum;
	}

	public void setFk_categorynum(int fk_categorynum) {
		this.fk_categorynum = fk_categorynum;
	}

	public String getPartyleaderid() {
		return partyleaderid;
	}

	public void setPartyleaderid(String partyleaderid) {
		this.partyleaderid = partyleaderid;
	}

	public int getPartystatus() {
		return partystatus;
	}

	public void setPartystatus(int partystatus) {
		this.partystatus = partystatus;
	}

	public String getOttid() {
		return ottid;
	}

	public void setOttid(String ottid) {
		this.ottid = ottid;
	}

	public String getOttpwd() {
		return ottpwd;
	}

	public void setOttpwd(String ottpwd) {
		this.ottpwd = ottpwd;
	}

	public String getCategoryname() {
		return categoryname;
	}

	public void setCategoryname(String categoryname) {
		this.categoryname = categoryname;
	}
	
}
