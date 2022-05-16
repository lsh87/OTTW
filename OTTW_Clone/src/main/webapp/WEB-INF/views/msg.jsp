<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script type="text/javascript">
	// 메시지 출력
	alert("${requestScope.message}");
	
	// 지정 페이지로 이동
	location.href="${requestScope.loc}";
</script>

