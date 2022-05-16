<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<% String ctxPath = request.getContextPath(); %>

<style type="text/css">

	button#btnAttendParty {
		border: none;
		border-radius: 10px;
		background-color: #24c0eb; 
		color: white;
		width: 200px;
		height: 40px;
		
		font-weight: bold;
	}
	
	button#btnReturn {
		border: solid 1px #24c0eb;
		border-radius: 10px;
		background-color: white;
		color: #24c0eb;
		width: 200px;
		height: 40px;
		font-weight: bold;
	}
	
	button#editParty {
		border: none;
		border-radius: 10px;
		background-color: #24c0eb;
		color: white;
		width: 200px;
		height: 40px;
		font-weight: bold;
	}
	
	button#delParty {
		border: solid 1px red;
		border-radius: 10px;
		background-color: white;
		color: red;
		width: 200px;
		height: 40px;
		font-weight: bold;
	}
	
	/* #24c0eb */
	table#partyInfoTbl tbody tr, table#ottAccountInfoTbl tr {height: 60px;}
	table#partyInfoTbl tbody td, table#ottAccountInfoTbl td {padding-left: 10px; vertical-align: middle;}
	table#partyInfoTbl tbody th, table#ottAccountInfoTbl th {
		width: 160px; 
		vertical-align: middle; 
		background-color: skyblue; 
		color: white;
	}
	
	a#ShowOttIdPwd {text-decoration: underline; color: #24c0eb; font-weight: bold;}
	a#ShowOttIdPwd:hover {cursor: pointer;}

</style>

<script type="text/javascript">

	function editParty() {
		
		if(${requestScope.partyMemberList.size()} != 0) {
			alert("해당 파티에 참여자가 존재하므로 파티를 수정할 수 없습니다.");
			return false;
		}
		
		const frm = document.sendEditPartyFrm;
		frm.action = "<%= ctxPath %>/editParty.ottw";
		frm.method = "POST";
		frm.submit();
	}
	
	function delParty() {
		
		if(${requestScope.partyMemberList.size()} != 0) {
			alert("해당 파티에 참여자가 존재하므로 파티를 삭제할 수 없습니다.");
			return false;
		}
		
		const frm = document.sendEditPartyFrm;
		frm.action = "<%= ctxPath %>/delParty.ottw";
		frm.method = "POST";
		frm.submit();
	}

</script>

<div id="content" style="display: flex;">
	<div style="margin: auto; width: 90%;">
		<c:set var="pvo" value="${requestScope.pvo}"></c:set>
		<table id="partyInfoTbl" class="table table-bordered mb-5" style="width: 680px; margin: auto;">
			<tbody>
				<tr>
					<th>파티 번호</th>
					<td>${pvo.partynum}				
				</tr>
				<tr>
					<th>파티 제목</th>
					<td><span class="font-weight-bold">[${pvo.categoryname}]</span>&nbsp;${pvo.partyname}</td>
				</tr>
				<tr>
					<th>파티장 아이디</th>
					<td>${pvo.partyleaderid}</td>
				</tr>
				<tr>
					<th>종료 일자</th>
					<td>${pvo.enddate}&nbsp;<span class="text-muted">(${requestScope.totalDate}일)</span></td>
				</tr>
				<tr>
					<th>총 이용 금액</th>
					<td>
						<fmt:formatNumber value="${requestScope.totalDate * pvo.charge}" pattern="#,###" />원
						<span class="text-muted">(1일 ${pvo.charge}원)</span>
					</td>
				</tr>
				<c:if test="${requestScope.showOttIdPwd == true}">
					<tr>
						<th>OTT ID/PW</th>
						<td>
							<a id="ShowOttIdPwd" data-toggle="modal" data-target="#showOttIdPwdModal">확인하기</a>
						</td>
					</tr>
				</c:if>
				<tr>
					<th>참여자</th>
					<td>
						<ul>
							<c:forEach var="partymember" items="${requestScope.partyMemberList}">
								<li>${partymember.partymemberid}</li>
							</c:forEach>
						</ul>
					</td>
				</tr>
			</tbody>
		</table>
		
		<div align="center">
			<!-- javascript:history.back() -->
			<button type="button" id="btnReturn" onclick="location.href='<%= ctxPath %>/categoryList.ottw?categorynum=${pvo.fk_categorynum}'">목록</button>
			<c:if test="${pvo.partystatus == 0 && requestScope.showAttendPartyBtn == true}">
				<button type="button" id="btnAttendParty" class="ml-3" onclick="location.href='<%= ctxPath %>/attendPartyEnd.ottw?partynum=${requestScope.pvo.partynum}'">파티 참여하기</button>
			</c:if>
			<c:if test="${requestScope.isPartyleader == true && pvo.partystatus == 0}">
				<button type="button" id="editParty" class="ml-3" onclick="editParty()">파티 수정</button>
				<button type="button" id="delParty" class="ml-3" onclick="delParty()">파티 삭제</button>
			</c:if>
		</div>
		
		<div class="modal fade" id="showOttIdPwdModal">
		  	<div class="modal-dialog modal-dialog-centered">
		  	<!-- .modal-dialog-centered 클래스를 사용하여 페이지 내에서 모달을 세로 및 가로 중앙에 배치합니다. -->
		    	<div class="modal-content">
		    		<!-- Modal header -->
					<div class="modal-header" style="border: none;">
						<button type="button" class="close text-muted" data-dismiss="modal">&times;</button>
					</div>
					<!-- Modal body -->
					<div class="modal-body" align="center">
						<table id="ottAccountInfoTbl" class="table table-bordered mb-5" style="width: 70%; margin: auto;">
							<tr>
								<th style="width: 30%; text-align: center;">ID</th>
								<td>${pvo.ottid}</td>
							</tr>
							<tr>
								<th style="text-align: center;">PW</th>
								<td>${pvo.ottpwd}</td>
							</tr>
						</table>
					</div>
		    	</div>
		  	</div>
		</div>
		
		<form name="sendEditPartyFrm">
			<input type="hidden" name="fk_categorynum" value="${pvo.fk_categorynum}" />
			<input type="hidden" name="partynum" value="${pvo.partynum}" />
			<input type="hidden" name="partyname" value="${pvo.partyname}" />
			<input type="hidden" name="partyleaderid" value="${pvo.partyleaderid}" />
			<input type="hidden" name="enddate" value="${pvo.enddate}" />
			<input type="hidden" name="nop" value="${pvo.nop}" />
			<input type="hidden" name="charge" value="${pvo.charge}" />
			<input type="hidden" name="ottid" value="${pvo.ottid}" />
			<input type="hidden" name="ottpwd" value="${pvo.ottpwd}" />
		</form>
	</div>
</div>