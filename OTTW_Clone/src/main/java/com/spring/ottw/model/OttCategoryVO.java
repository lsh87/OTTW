package com.spring.ottw.model;

public class OttCategoryVO {
	
	private int categorynum;		// 카테고리번호
	private String categoryname;	// 카테고리명
	private String categorylogo;	// 카테고리로고 이미지파일명
	
	public OttCategoryVO() {}

	public OttCategoryVO(int categorynum, String categoryname, String categorylogo) {
		super();
		this.categorynum = categorynum;
		this.categoryname = categoryname;
		this.categorylogo = categorylogo;
	}

	public int getCategorynum() {
		return categorynum;
	}

	public void setCategorynum(int categorynum) {
		this.categorynum = categorynum;
	}

	public String getCategoryname() {
		return categoryname;
	}

	public void setCategoryname(String categoryname) {
		this.categoryname = categoryname;
	}

	public String getCategorylogo() {
		return categorylogo;
	}

	public void setCategorylogo(String categorylogo) {
		this.categorylogo = categorylogo;
	}
	
}
