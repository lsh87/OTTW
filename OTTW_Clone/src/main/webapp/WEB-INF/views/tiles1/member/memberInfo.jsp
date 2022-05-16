<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style type="text/css">

	div#tblCoverDiv {border: solid 2px skyblue; border-radius: 10px; padding: 40px;}
	table#memberInfoTbl tr {height: 60px;}
	table#memberInfoTbl tbody td {padding-left: 60px;}
	table#memberInfoTbl label {font-weight: bold;}

	button#btnEditInfo {
		border: none;
		border-radius: 5px;
		background-color: #24c0eb;
		color: white;
		font-weight: bold;
		height: 45px;
	}

</style>

<script type="text/javascript">

	$(document).ready(function() {
		
		$("input#checkPwd").keydown(function(event) {
			if(event.keyCode == 13) { // 엔터를 입력한 경우
				checkPassword();
			}
		});
		
	}); // end of $(document).ready(function() {})
	
	
	function checkPassword() {
		
		const checkPwd = $("input#checkPwd").val();
		
		if(checkPwd == "") {
			alert("비밀번호를 입력하세요.");
			return false;
		}
		
		$.ajax({
			url:"<%= request.getContextPath() %>/checkPassword.ottw",
			data:{"id":"${sessionScope.loginuser.id}",
				  "checkPwd":checkPwd},
			type:"POST",
			dataType:"JSON",
			async: true,
			success:function(json) {
				
				if(json.isExist) {
					const frm = document.memberInfoFrm;
					frm.action = "<%= request.getContextPath() %>/editMemberInfo.ottw",
					frm.method = "POST";
					frm.submit();	
				}
				else {
					alert("비밀번호가 일치하지 않습니다.");
				}
				
				$("#checkPasswordModal").modal('hide');
				$("input#checkPwd").val("");
			},
			error: function(request, status, error){
	            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        }
		}); // end of $.ajax({})
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
						<td><input type="text" name="id" class="form-control" value="${mvo.id}" readonly /></td>
					</tr>
					<tr>
						<td><label>이름</label></td>
						<td><input type="text" name="name" class="form-control" value="${mvo.name}" readonly /></td>
					</tr>
					<tr>
						<td><label>생년월일</label></td>
						<td><input type="text" name="birthday" class="form-control" value="${mvo.birthday}" readonly /></td>
					</tr>
					<tr>
						<td><label>휴대전화</label></td>
						<td><input type="text" name="phone" class="form-control" value="${mvo.phone}" readonly /></td>
					</tr>
					<tr>
						<td><label>이메일</label></td>
						<td><input type="text" name="email" class="form-control" value="${mvo.email}" readonly /></td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="2" align="center">
							<button type="button" id="btnEditInfo" data-toggle="modal" data-target="#checkPasswordModal" class="w-100 mt-3 py-1">회원정보 수정</button>
						</td>
					</tr>
				</tfoot>
			</table>
		</form>
		
		<div class="modal fade" id="checkPasswordModal">
		  	<div class="modal-dialog modal-dialog-centered">
		  	<!-- .modal-dialog-centered 클래스를 사용하여 페이지 내에서 모달을 세로 및 가로 중앙에 배치합니다. -->
		    	<div class="modal-content">
		    		<!-- Modal header -->
					<div class="modal-header" style="border: none;">
						<button type="button" class="close text-muted" data-dismiss="modal">&times;</button>
					</div>
					<!-- Modal body -->
					<div class="modal-body" align="center">
						<h5 class="modal-title mb-3 font-weight-bold">비밀번호 확인</h5>
						<input type="password" id="checkPwd" class="form-control w-75 mb-0" style="margin: auto;" />					
					</div>
					<!-- Modal footer -->
					<div class="modal-footer" style="border: none;">
						<button type="button" class="btn text-white w-75 mb-5 mt-0" onclick="checkPassword()" style="background-color: #24c0eb; margin: auto;">확인</button>
					</div>
		    	</div>
		  	</div>
		</div>
	</div>
</div>