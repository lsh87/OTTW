package com.spring.ottw.model;

public class PartyMemberVO {
	
	private String partynum;		// 파티번호
	private String partymemberid;	// 파티원아이디
	
	public PartyMemberVO() {}
	
	public PartyMemberVO(String partynum, String partymemberid) {
		this.partynum = partynum;
		this.partymemberid = partymemberid;
	}

	public String getPartynum() {
		return partynum;
	}

	public void setPartynum(String partynum) {
		this.partynum = partynum;
	}

	public String getPartymemberid() {
		return partymemberid;
	}

	public void setPartymemberid(String partymemberid) {
		this.partymemberid = partymemberid;
	}
	
	
}
