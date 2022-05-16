<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style type="text/css">

	div#tblCoverDiv {border: solid 2px skyblue; border-radius: 10px; padding: 40px;}
	table#memberInfoTbl tr {height: 60px;}
	table#memberInfoTbl label {font-weight: bold;}

	button#btnEditInfo {
		border: none;
		border-radius: 5px;
		background-color: #24c0eb;
		color: white;
		font-weight: bold;
		height: 45px;
	}
	
	button#btnCancel {
		border: solid 1px #24c0eb;
		border-radius: 5px;
		background-color: white;
		color: #24c0eb;
		font-weight: bold;
		height: 45px;
	}
	
	span.error {
		font-size: 10pt;
		color: red;
	}

</style>

<script type="text/javascript">

	$(document).ready(function() {
		
		$("span.error").hide();
		
		// 유효성 검사
		// 6) 휴대전화
		$("input#phone").blur(function() {
			
			const phone = $(this).val().trim();
			
			if(phone == "") { // 휴대전화를 입력하지 않은 경우
				$("form.memberInfoFrm :input").prop("disabled", true);
				$(this).prop("disabled", false);
				
				$(this).next().show();
				$(this).focus();
			}
			else {
				// 휴대전화 정규표현식 객체 생성
				const regExp = new RegExp(/^01([0|1|6|7|8|9]?)([0-9]{3,4})([0-9]{4})$/);
			    
				const bool = regExp.test(phone);
				
				if(!bool) { // 전화번호가 정규표현식에 위배된 경우
					$("form.memberInfoFrm :input").prop("disabled", true);
					$(this).prop("disabled", false);
					
					$(this).next().text("올바른 형식의 전화번호를 입력하세요.");
					$(this).next().show();
					$(this).focus();
				}
				else {
					$("form.memberInfoFrm :input").prop("disabled", false);
					
					$(this).next().hide();
				}
			}
		}); // end of $("input#phone").blur(function() {})
		
		// 7) 이메일
		$("input#email").blur(function() {
			
			const email = $(this).val().trim();
			
			if(email == "") { // 이메일을 입력하지 않은 경우
				$("form.memberInfoFrm :input").prop("disabled", true);
				$(this).prop("disabled", false);
				
				$(this).next().show();
				$(this).focus();
			}
			else {
				const regExp = new RegExp(/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i); 
				
			 	const bool = regExp.test(email);
			 	
			 	if(!bool) { // 이메일이 정규표현식에 위배된 경우
			 		$("form.memberInfoFrm :input").prop("disabled", true);
					$(this).prop("disabled", false);
					
					$(this).next().text("올바른 형식의 이메일을 입력하세요.");
					$(this).next().show();
					$(this).focus();
			 	}
			 	else {
					$("form.memberInfoFrm :input").prop("disabled", false);
					
					$(this).next().hide();
			 	}
			}
		}); // end of $("input#email").blur(function() {})
		
	}); // end of $(document).ready(function() {})
	
	
	function editMemberInfo() {
		
		const frm = document.memberInfoFrm;
		frm.action = "<%= request.getContextPath() %>/editMemberInfoEnd.ottw",
		frm.method = "POST";
		frm.submit();
	}
	
</script>

<div id="content" style="display: flex;">
	<div id="tblCoverDiv" style="margin: auto; width: 40%;">
		<form name="memberInfoFrm">
			<c:set var="mvo" value="${requestScope.mvo}" />
			<table id="memberInfoTbl" style="margin: auto; width: 500px;">
				<tbody>
					<tr>
						<td style="width: 30%;"><label>아이디</label></td>
						<td><input type="text" id="id" name="id" class="form-control" value="${mvo.id}" readonly /></td>
					</tr>
					<tr>
						<td><label>이름</label></td>
						<td><input type="text" id="name" name="name" class="form-control" value="${mvo.name}" readonly /></td>
					</tr>
					<tr>
						<td><label>생년월일</label></td>
						<td><input type="text" id="birthday" name="birthday" class="form-control" value="${mvo.birthday}" readonly /></td>
					</tr>
					<tr>
						<td><label>휴대전화</label></td>
						<td>
							<input type="text" id="phone" name="phone" class="form-control" value="${mvo.phone}" />
							<span class="error">필수 입력 정보입니다.</span>
						</td>
					</tr>
					<tr>
						<td><label>이메일</label></td>
						<td>
							<input type="text" id="email" name="email" class="form-control" value="${mvo.email}" />
							<span class="error">필수 입력 정보입니다.</span>
						</td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="2" align="center">
							<button type="button" id="btnCancel" class="w-100 mt-3 py-1" onclick="javascript:history.back()">취소</button>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center">
							<button type="button" id="btnEditInfo" class="w-100 mt-3 py-1" onclick="editMemberInfo()">회원정보 수정</button>
						</td>
					</tr>
				</tfoot>
			</table>
		</form>
	</div>
</div>