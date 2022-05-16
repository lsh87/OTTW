<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% String ctxPath = request.getContextPath(); %>

<style type="text/css">

	ul#partyInfo {list-style: none; padding-left: 0;}
	
	div#attendParty {
		background-color: white;
		border: solid 1px skyblue;
		border-radius: 5px; 
		padding: 5px;
		margin-top: 15px;
		font-weight: bold;
		color: skyblue;
		text-align: center;
	}
	div#attendParty:hover {cursor: pointer; background-color: skyblue; color: white;}
	
	div#complete {
		background-color: skyblue;
		border: none;
		border-radius: 5px; 
		padding: 5px;
		margin-top: 15px;
		font-weight: bold;
		color: white;
		text-align: center;
	}
	
	div#expiration {
		background-color: #c1c1c1;
		border-radius: 5px; 
		padding: 5px;
		margin-top: 15px;
		font-weight: bold;
		color: white;
		text-align: center;
	}
	
	button#btnCreateParty {
		border: solid 1px skyblue;
		border-radius: 15px;
		padding: 5px 25px;
		background-color: white;
		color: #24c0eb;
		font-weight: bold;
	}

</style>

<script type="text/javascript">

	$(document).ready(function() {
		
	}); // end of $(document).ready(function() {})

</script>

<div id="content" style="display: flex;">
	<div style="margin: auto; width: 90%;">
		<div style="width: 80%; margin: auto;">
			<div style="display:flex;">
				<h5>${requestScope.categoryname}</h5>
				<div style="margin-left: auto;">
					<button type="button" id="btnCreateParty" onclick="location.href='<%= ctxPath %>/createParty.ottw'">파티 만들기</button>
				</div>
			</div>
			
			<div class="row justify-content-around mt-5">
				<c:forEach var="party" items="${requestScope.partyList}">
				<div class="col-lg-3 mb-2 px-1">
					<div class="col-lg-12 card" style="min-height: 200px; padding: 20px;">
						<ul id="partyInfo">
							<li><a href="<%= ctxPath %>/showParty.ottw?partynum=${party.partynum}">${party.partyname}</a></li>
							<li>파티 종료일자 : ${party.enddate}</li>
							<li>파티 모집인원 : ${party.nop}</li>
							<li>파티 일일요금 : ${party.charge}</li>
						</ul>
						<c:choose>
							<c:when test="${party.partystatus == 0}">
								<div id="attendParty" onclick="location.href='<%= ctxPath %>/showParty.ottw?partynum=${party.partynum}'">파티 참여하기</div>
							</c:when>
							<c:when test="${party.partystatus == 1}">
								<div id="complete">모집 완료</div>
							</c:when>
							<c:when test="${party.partystatus == 2}">
								<div id="expiration">모집 기간 만료</div>
							</c:when>
						</c:choose>
					</div>
				</div>
			  	</c:forEach>
		  	</div>
		</div>
	</div>
</div>