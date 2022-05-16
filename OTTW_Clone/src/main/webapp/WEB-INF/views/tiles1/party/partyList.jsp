<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% String ctxPath = request.getContextPath(); %>

<style type="text/css">

	ul#tabs {border: none;}
	ul#tabs li {
		border-bottom: none;
		padding: 10px;
		margin-right: 5px;
	}
	ul#tabs a {text-decoration: none; color: black; font-weight: bold;}
	ul#tabs li.active {border-bottom: solid 3px #24c0eb;}

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

</style>

<script type="text/javascript">

	$(document).ready(function() {
		
		$("ul#tabs li").click(function() {
			$("ul#tabs li").removeClass("active");
			$(this).addClass("active");
			
			$(".tab-pane").hide();
			 
			var activeTab = $(this).find("a").attr("href");
			$(activeTab).show();
		});
		
	}); // end of $(document).ready(function() {})

</script>

<div id="content" style="display: flex;">
	<div style="margin: auto; width: 60%;">
		
		<ul id="tabs" class="nav nav-tabs">
			<li class="active"><a href="#tab1" data-toggle="tab">참여 파티</a></li>
			<li><a href="#tab2" data-toggle="tab">생성 파티</a></li>
		</ul>
		
		<div class="tab-content mt-3">
			<!-- 참여한 파티 목록 -->
			<div class="tab-pane active" id="tab1">
				<div>
					<span class="text-muted" style="font-size: 10pt;">*만료된 파티는 보이지 않습니다.</span>
				</div>
				
				<c:forEach var="pvo" items="${requestScope.attendPartyList}">
				<div class="col-lg-3 mb-2 px-1">
					<div class="col-lg-12 card" style="min-height: 200px; padding: 20px;">
						<ul style="list-style: none; padding-left: 0;">
							<li><a href="<%= ctxPath %>/showParty.ottw?partynum=${pvo.partynum}" style="font-weight: bold; font-size: 14pt;">${pvo.partyname}</a></li>
							<li>종료일자 : ${pvo.enddate}</li>
						</ul>
						<c:choose>
							<c:when test="${pvo.partystatus == 0}">
								<div id="attendParty">모집중</div>
							</c:when>
							<c:when test="${pvo.partystatus == 1}">
								<div id="complete">모집 완료</div>
							</c:when>
							<c:when test="${pvo.partystatus == 2}">
								<div id="expiration">모집 기간 만료</div>
							</c:when>
						</c:choose>	    
					</div>
				</div>
				</c:forEach>
			</div>
			<!-- 생성한 파티 목록 -->
			<div class="tab-pane" id="tab2">
				<div class="row">
					<c:forEach var="pvo" items="${requestScope.createPartyList}">
					<div class="col-lg-3 mb-2 px-1">
						<div class="col-lg-12 card" style="min-height: 200px; padding: 20px;">
							<ul style="list-style: none; padding-left: 0;">
								<li><a href="<%= ctxPath %>/showParty.ottw?partynum=${pvo.partynum}" style="font-weight: bold; font-size: 14pt;">${pvo.partyname}</a></li>
								<li>종료일자 : ${pvo.enddate}</li>
							</ul>
							<c:choose>
								<c:when test="${pvo.partystatus == 0}">
									<div id="attendParty">모집중</div>
								</c:when>
								<c:when test="${pvo.partystatus == 1}">
									<div id="complete">모집 완료</div>
								</c:when>
								<c:when test="${pvo.partystatus == 2}">
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
</div> 