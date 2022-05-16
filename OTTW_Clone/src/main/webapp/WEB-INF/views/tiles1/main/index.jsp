<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
   String ctxPath = request.getContextPath();
%>

<script type="text/javascript">

	$(document).ready(function() {
		
		
		
	}); // end of $(document).ready(function() {})

	function goCategory(categorynum) {
		
		location.href="<%= ctxPath %>/categoryList.ottw?categorynum=" + categorynum;
		
	} // function goCategorynum(category)
	
</script>

<div id="content" style="display: flex;">
	<div style="margin: auto; width: 90%;">
		<div class="row" style="width: 80%; margin: auto;">	
			<c:forEach var="ott" items="${requestScope.ottCategoryList}">
			<div class="col-lg-3 mb-2 px-1">
				<div class="col-lg-12 card py-0 px-0" style="height: 300px; width: 300px; padding: 20px;">
				    <img class="card-img-top" src="<%= ctxPath %>/resources/images/${ott.categorylogo}" style="width:60%; margin: auto;">
				    <div class="card-body" align="center">
				      	<h4 class="card-title">${ott.categoryname}</h4>
				      	<a href="javascript:goCategory(${ott.categorynum})" class="btn btn-primary">보러가기</a>
			    	</div>
			    </div>
		  	</div>
		  	</c:forEach>
	  	</div>
	</div>
</div>