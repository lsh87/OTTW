<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- ======= #27. tile1 중 header 페이지 만들기 (#26.번은 없다 샘이 장난침.) ======= --%>
<%
   String ctxPath = request.getContextPath();
%>

<style type="text/css">
	
	/* #24c0eb */
	
	button#btn_login {
		border: solid 1px #24c0eb;
		/* background-color: skyblue; */
		background-color: white;
		border-radius: 50px;
		padding: 5px 20px;
		color: #24c0eb;
		font-weight: bold;
	}
	
	button#btn_login:hover {background-color: #24c0eb; color: white;}
	
</style>

<!-- 상단 네비게이션 시작 -->
<nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top py-3" style="display: flex; border-bottom: solid 1px skyblue; padding: 0 15%; max-height: 90px;">
	<!-- Brand/logo -->
	<a class="navbar-brand" href="<%= ctxPath %>/index.ottw">
		<img src="<%= ctxPath %>/resources/images/logo.png" style="width: 180px;" />	
	</a>
	
	<div style="margin-left: auto;">
		<c:if test="${empty sessionScope.loginuser}">
			<div>
				<button type="button" id="btn_login" onclick="location.href='<%= ctxPath %>/login.ottw'">로그인</button>
			</div>
		</c:if>
		<c:if test="${not empty sessionScope.loginuser}">
			<div>
				<a class="dropdown-toggle" data-toggle="dropdown">${sessionScope.loginuser.id}님 로그인 중...</a>
				<div class="dropdown-menu" style="width: 80px;">
					<a class="dropdown-item" href="<%= ctxPath %>/partyList.ottw">파티참여목록</a>
					<a class="dropdown-item" href="<%= ctxPath %>/memberInfo.ottw">회원정보확인</a>
					<a class="dropdown-item" href="<%= ctxPath %>/logout.ottw">로그아웃</a>
				</div>
			</div>
		</c:if>
	</div>
</nav>
<!-- 상단 네비게이션 끝 -->