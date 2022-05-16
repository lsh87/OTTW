<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% String ctxPath = request.getContextPath(); %>

<style type="text/css">

	span.error {font-size: 10pt; color: red;}
	.check {font-size: 10pt; color: green;}

	button#checkDate, button#checkCharge {
		border: solid 1px #24c0eb;
		/* background-color: skyblue; */
		background-color: white;
		border-radius: 50px;
		padding: 5px 20px;
		color: #24c0eb;
		font-weight: bold;
	}
	
	button#btnCreateParty {
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
	
	table#createPartyTbl tr {height: 60px;}

</style>

<script type="text/javascript">

	$(document).ready(function() {
		
		var isCheckDate = false;
		var isCheckCharge = false;
		var totalDate = 0;
		var totalCharge = 0;
		
		$("span.error").hide();
		$("button#checkDate").trigger("click");
		$("button#checkCharge").trigger("click");
		
		// select 기본값 지정하기
		$("select#fk_categorynum").val(${requestScope.pvo.fk_categorynum}).prop("selected", true);
		
		// input#startdate의 기본값 지정하기
		document.getElementById('startdate').valueAsDate = new Date();

		// input#enddate의 min값 지정하기
		var today = new Date();
		var dd = today.getDate() + 1;
		var mm = today.getMonth() + 1; //January is 0!
		var yyyy = today.getFullYear();
		
		if (dd < 10) {dd = '0' + dd;}
		if (mm < 10) {mm = '0' + mm;} 
		    
		today = yyyy + '-' + mm + '-' + dd;
		document.getElementById("enddate").setAttribute("min", today);
		
		// 진행기간 일수 확인하기
		$("button#checkDate").click(function() {

			const $target = $(event.target);
			const startdate = $("input#startdate").val();
			const enddate = $("input#enddate").val();
			
			if(enddate != "") {
				$.ajax({
					url:"<%= ctxPath %>/checkDate.ottw",
					data:{"startdate":startdate,
						  "enddate":enddate},
					type:"POST",
					dataType:"JSON",
					success:function(json) {
						$target.next().html("총 일수 : " + json.totalDate + "일");
						$target.next().addClass('check');
						$target.next().removeClass('error');
						$target.next().show();
						
						isCheckDate = true;
						totalDate = json.totalDate;
					},
					error: function(request, status, error){
			            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			        }
				});
			}
			else {
				alert("종료일자를 입력하세요.");
			}
		});
		
		// 예상 수금액 확인하기
		$("button#checkCharge").click(function() {
			
			const $target = $(event.target);
			const nop = $("input#nop").val();
			const charge = $("input#charge").val();
			
			if(isCheckDate) {
				if(charge != "") {
					totalCharge = Number(nop) * Number(charge) * Number(totalDate);
					
					$target.next().html("총 요금 : " + totalCharge + "원");
					$target.next().addClass('check');
					$target.next().removeClass('error');
					$target.next().show();
					
					isCheckCharge = true;
				}
				else {
					alert("요금을 입력하세요.");
				}
			}
			else {
				alert("진행 기간을 확인하세요.");
			}
			
		});
		
		// === 유효성 검사 === //
		// 1) OTT계정 아이디/비밀번호
		$("input#ottid").blur(function() {
			
			const ottid = $(this).val().trim();
			
			if(ottid == "") { // OTT계정 아이디를 입력하지 않거나 공백만 입력한 경우
				$("form.createPartyFrm :input").prop("disabled", true);
				$(this).prop("disabled", false);
				
				$(this).val("");
				$(this).parent().find('span.error').show();
				$(this).focus();
			}
			else {
				$("form.createPartyFrm :input").prop("disabled", false);
				
				$(this).parent().find('span.error').hide();
			}
		}); // end of $("input#ottid").blur(function() {})
		
		$("input#ottpwd").blur(function() {
			
			const ottpwd = $(this).val().trim();
			
			if(ottpwd == "") { // OTT계정 비밀번호를 입력하지 않거나 공백만 입력한 경우
				$("form.createPartyFrm :input").prop("disabled", true);
				$(this).prop("disabled", false);
				
				$(this).val("");
				$(this).parent().find('span.error').show();
				$(this).focus();
			}
			else {
				$("form.createPartyFrm :input").prop("disabled", false);
				
				$(this).parent().find('span.error').hide();
			}
			
		}); // end of $("input#ottpwd").blur(function() {})
		
		// 2) 파티제목
		$("input#partyname").blur(function() {
			
			const partyname = $(this).val().trim();
			
			if(partyname == "") { // 파티제목을 입력하지 않거나 공백만 입력한 경우
				$("form.createPartyFrm :input").prop("disabled", true);
				$(this).prop("disabled", false);
				
				$(this).val("");
				$(this).next().show();
				$(this).focus();
			}
			else {
				$("form.createPartyFrm :input").prop("disabled", false);
				
				$(this).next().hide();
			}
			
		}); // end of $("input#partyname").blur(function() {})
		
		// 3) 종료일자
		$("input#enddate").blur(function() {
			
			const enddate = $(this).val();
			
			if(enddate == "") { // 종료일자를 입력하지 않은 경우
				$("form.createPartyFrm :input").prop("disabled", true);
				$(this).prop("disabled", false);
				
				$(this).val("");
				$(this).parent().find('span.error').show();
				$(this).focus();
			}
			else {
				$("form.createPartyFrm :input").prop("disabled", false);
				
				$(this).parent().find('span.error').hide();
			}
			
		}); // end of $("input#enddate").blur(function() {}
		
		// 4) 요금
		$("input#charge").blur(function() {
			
			const charge = $(this).val().trim();
			
			if(charge == "") { // 요금을 입력하지 않은 경우
				$("form.createPartyFrm :input").prop("disabled", true);
				$(this).prop("disabled", false);
				
				$(this).val("");
				$(this).parent().find('span.error').show();
				$(this).focus();
			}
			else {
				$("form.createPartyFrm :input").prop("disabled", false);
				
				$(this).parent().find('span.error').hide();
			}
			
		}); // end of $("input#charge").blur(function() {}
		
		
		// === 파티 만들기 === //
		$("button#btnCreateParty").click(function() {
			
			const flag = true;
			
			$("input").each(function(index, item) {
				
				const data = $(item).val().trim();
				
				if(data == "") {
					alert($(item).parent().prev().find('label').text() + "이(가) 입력되지 않았습니다.");
					$(item).focus();
					flag = false;
					return false;
				}
			}); // end of $("input").each(function(index, item) {})
			
			if(!isCheckDate) {
				alert("진행 기간을 확인하세요.");
				flag = false;
				return false;
			}
			
			if(!isCheckCharge) {
				alert("예상 금액을 확인하세요.");
				flag = false;
				return false;
			}
			
			if(flag) {
				const frm = document.createPartyFrm;
				frm.action = "<%= ctxPath %>/editPartyEnd.ottw";
				frm.method = "POST";
				frm.submit();
			}
			
		}); // end of $("button#btnCreateParty").click(function() {})
		
		
	}); // end of $(document).ready(function() {})

</script>

<div id="content" style="display: flex;">
	<div style="margin: auto; width: 90%;">
		<c:set var="pvo" value="${requestScope.pvo}"></c:set>
		<form name="createPartyFrm" style="margin-bottom: 100px;">
			<!-- OTT 유형(request로 받아와서 기본으로 설정해주고, 변경도 가능하도록 만들어준다), 계정 아이디, 계정 비밀번호
				 파티명, 시작일자(오늘), 종료일자, 모집인원(본인제외), 요금, 공지사항입력 -->
			<table id="createPartyTbl" style="margin: auto; width: 680px;">
				<tr>
					<td>
						<label class="mt-3 font-weight-bold" for="fk_categorynum">OTT</label>
					</td>
					<td>
		    			<select class="form-control" id="fk_categorynum" name="fk_categorynum" style="height: 45px;">
		      				<c:forEach var="ott" items="${requestScope.ottCategoryList}">
		      				<option value="${ott.categorynum}">${ott.categoryname}</option>
		      				</c:forEach>
		    			</select>
					</td>
				</tr>
				<tr>
					<td>
						<label class="mt-3 font-weight-bold" for="partyname">OTT계정 ID/PW</label>
					</td>
					<td>
						<input type="text" class="form-control" id="ottid" name="ottid" style="height: 45px; width: 48%; display: inline-block;" placeholder="계정 아이디" value="${pvo.ottid}">
						<span>/</span>
						<input type="text" class="form-control" id="ottpwd" name="ottpwd" style="height: 45px; width: 49%; display: inline-block;" placeholder="계정 비밀번호" value="${pvo.ottpwd}">
						<span class="error">필수 입력 정보입니다.</span>
					</td>
				</tr>
				<tr>
					<td>
						<label class="mt-3 font-weight-bold" for="partyname">파티제목</label>
					</td>
					<td>
						<input type="text" class="form-control" id="partyname" name="partyname" style="height: 45px;" placeholder="제목을 입력하세요" value="${pvo.partyname}">
						<span class="error">필수 입력 정보입니다.</span>
					</td>
				</tr>
				<tr>
					<td>
						<label class="mt-3 font-weight-bold">진행기간</label>
					</td>
					<td>
						<input type="date" class="form-control" id="startdate" name="startdate" style="height: 45px; width: 36%; display: inline-block;" readonly />
						<span>~</span>
						<input type="date" class="form-control" id="enddate" name="enddate" style="height: 45px; width: 36%; display: inline-block;" value="${pvo.enddate}">
						<button type="button" id="checkDate" class="ml-1">기간 확인</button>
						<span class="error">필수 입력 정보입니다.</span>
					</td>
				</tr>
				<tr>
					<td>
						<label class="mt-3 font-weight-bold">모집인원(본인제외)</label>
					</td>
					<td>
						<input type="number" class="form-control" id="nop" name="nop" style="height: 45px;" min="1" max="10" value="${pvo.nop}"/>
					</td>
				</tr>
				<tr>
					<td>
						<label class="mt-3 font-weight-bold">요금</label>
					</td>
					<td>
						<input type="text" class="form-control" id="charge" name="charge" style="height: 45px; width: 76%; display: inline-block;" placeholder="1인당 일일요금 * 진행일수 * 모집인원" value="${pvo.charge}">
						<button type="button" id="checkCharge" class="ml-1">예상 금액</button>
						<span class="error">필수 입력 정보입니다.</span>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<button type="button" id="btnCancel" class="w-100 mt-3 py-1" onclick="location.href='<%= ctxPath %>/showParty.ottw?partynum=${pvo.partynum}'">취소</button>
						<button type="button" id="btnCreateParty" class="w-100 mt-3 py-1">파티 수정하기</button>
					</td>
				</tr>
			</table>
			<input type="hidden" name="partynum" value="${pvo.partynum}" />
			<input type="hidden" id="partyleaderid" name="partyleaderid" value="${sessionScope.loginuser.id}">
		</form>
	</div>
</div>