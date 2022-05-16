<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
%>

<style type="text/css">

	input.form-control {
		padding: 0 10px;
	}
	
	span.error {
		font-size: 10pt;
		color: red;
	}
	
	button#btnSignup {
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
		
		$("span.error").hide();
		$("input#id").focus();
		
		// === 유효성 검사 === //
		// 1) 아이디(+중복검사)
		$("input#id").blur(function() {
			
			const id = $(this).val().trim();
			
			if(id == "") { // 아이디를 입력하지 않거나 공백만 입력한 경우
				$("form.signupFrm :input").prop("disabled", true);
				$(this).prop("disabled", false);
				
				$(this).val("");
				$(this).next().show();
				$(this).focus();
			}
			else {
				// 아이디 중복검사
				$.ajax({
					url:"<%= ctxPath %>/idDuplicateCheck.ottw",
					data:{"id":id},
					success:function(text) {
						// JSON 형식으로 되어진 문자열을 자바스크립트 객체로 변환
						const json = JSON.parse(text);
						
						if(json.isDuplicateId) { // 중복된 아이디인 경우
							$("form.signupFrm :input").prop("disabled", true);
							$("input#id").prop("disabled", false);
							
							$("input#id").next().text("이미 사용중인 아이디입니다.");
							$("input#id").next().show();
						}
						else {
							$("form.signupFrm :input").prop("disabled", false);
							$("input#id").next().hide();
						}
					},
					error:function(request, status, error){
	        	    	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        	    }
				}); // end of $.ajax({})
			}
		}); // end of $("input#userid").blur(function() {})
	
		// 2) 비밀번호
		$("input#pwd").blur(function() {
			
			const pwd = $(this).val();
			
			if(pwd == "") { // 비밀번호를 입력하지 않은 경우
				$("form.signupFrm :input").prop("disabled", true);
				$(this).prop("disabled", false);
				
				$(this).next().show();
				$(this).focus();
			}
			else {
				// 숫자/문자/특수문자/ 포함 형태의 8~15자리 이내의 비밀번호 정규표현식 객체 생성
				const regExp = new RegExp(/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g);
			    
				const bool = regExp.test(pwd);
				
				if(!bool) { // 비밀번호가 정규표현식에 위배된 경우
					$("form.signupFrm :input").prop("disabled", true);
					$(this).prop("disabled", false);
					
					$(this).next().text("비밀번호는 영문자, 숫자, 특수기호가 혼합된 8~15글자로 입력하세요.");
					$(this).next().show();
					$(this).focus();
				}
				else {
					$("form.signupFrm :input").prop("disabled", false);
					
					$(this).next().hide();
				}
			}
			
		}); // end of $("input#pwd").blur(function() {})
		
		// 3) 비밀번호 확인
		$("input#checkpwd").blur(function() {
			
			const pwd = $("input#pwd").val();
			const checkpwd = $(this).val();
			
			if(checkpwd == "") { // 비밀번호 확인을 입력하지 않은 경우
				$("form.signupFrm :input").prop("disabled", true);
				$(this).prop("disabled", false);
				
				$(this).next().show();
				$(this).focus();
			}
			else {
				if(pwd != checkpwd) { // 비밀번호와 비밀번호 확인 값이 일치하지 않는 경우
					$("form.signupFrm :input").prop("disabled", true);
					$(this).prop("disabled", false);
					
					$(this).next().text("비밀번호가 일치하지 않습니다.")
					$(this).next().show();
					$(this).focus();
				}
				else {
					$("form.signupFrm :input").prop("disabled", false);
					
					$(this).next().hide();
				}
			}
		}); // end of $("input#checkpwd").blur(function() {})
		
		// 4) 이름
		$("input#name").blur(function() {
			
			const name = $(this).val().trim();
			
			if(name == "") { // 이름을 입력하지 않거나 공백만 입력한 경우
				$("form.signupFrm :input").prop("disabled", true);
				$(this).prop("disabled", false);
				
				$(this).val("");
				$(this).next().show();
				$(this).focus();
			}
			else {
				$("form.signupFrm :input").prop("disabled", false);
				
				$(this).next().hide();
			}
		}); // end of $("input#name").blur(function() {})
		
		// 5) 생년월일
		$("input#birthday").blur(function() {
			
			const birthday = $(this).val();
			
			if(birthday == "") { // 생년월일을 입력하지 않은 경우
				$("form.signupFrm :input").prop("disabled", true);
				$(this).prop("disabled", false);
				
				$(this).next().show();
				$(this).focus();
			}
			else {
				$("form.signupFrm :input").prop("disabled", false);
				
				$(this).next().hide();
			}
		}); // end of $("input#birthday").blur(function() {})
		
		// 6) 휴대전화
		$("input#phone").blur(function() {
			
			const phone = $(this).val().trim();
			
			if(phone == "") { // 휴대전화를 입력하지 않은 경우
				$("form.signupFrm :input").prop("disabled", true);
				$(this).prop("disabled", false);
				
				$(this).next().show();
				$(this).focus();
			}
			else {
				// 휴대전화 정규표현식 객체 생성
				const regExp = new RegExp(/^01([0|1|6|7|8|9]?)([0-9]{3,4})([0-9]{4})$/);
			    
				const bool = regExp.test(phone);
				
				if(!bool) { // 전화번호가 정규표현식에 위배된 경우
					$("form.signupFrm :input").prop("disabled", true);
					$(this).prop("disabled", false);
					
					$(this).next().text("올바른 형식의 전화번호를 입력하세요.");
					$(this).next().show();
					$(this).focus();
				}
				else {
					$("form.signupFrm :input").prop("disabled", false);
					
					$(this).next().hide();
				}
			}
		}); // end of $("input#phone").blur(function() {})
		
		// 7) 이메일
		$("input#email").blur(function() {
			
			const email = $(this).val().trim();
			
			if(email == "") { // 이메일을 입력하지 않은 경우
				$("form.signupFrm :input").prop("disabled", true);
				$(this).prop("disabled", false);
				
				$(this).next().show();
				$(this).focus();
			}
			else {
				const regExp = new RegExp(/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i); 
				
			 	const bool = regExp.test(email);
			 	
			 	if(!bool) { // 이메일이 정규표현식에 위배된 경우
			 		$("form.signupFrm :input").prop("disabled", true);
					$(this).prop("disabled", false);
					
					$(this).next().text("올바른 형식의 이메일을 입력하세요.");
					$(this).next().show();
					$(this).focus();
			 	}
			 	else {
					$("form.signupFrm :input").prop("disabled", false);
					
					$(this).next().hide();
			 	}
			}
			
		}); // end of $("input#email").blur(function() {})
		
		
		// 회원 가입하기
		$("button#btnSignup").click(function() {
			
			const flag = true;
			
			$("input").each(function(index, item) {
			
				const data = $(item).val().trim();
				
				if(data == "") {
					alert($(item).prev().text() + "이(가) 입력되지 않았습니다.");
					$(item).focus();
					flag = false;
					return false;
				}
			}); // end of $("form.signupFrm :input").each(function(index, item) {})
			
			if(flag) {
				const frm = document.signupFrm;
				frm.action = "<%= ctxPath %>/signupEnd.ottw";
				frm.method = "POST";
				frm.submit();
			}
			
		}); // $("button#btnSignup").click(function() {})
		
	}); // end of $(document).ready(function() {})

</script>

<div id="content" style="display: flex;">
	<div style="margin: auto; width: 90%;">
		<form name="signupFrm" style="margin-bottom: 100px;">
			<!-- 아이디, 비밀번호, 비밀번호 재확인, 이름, 생년월일, 성별, 휴대전화(본인인증) -->
			<table id="signupTbl" style="margin:auto; width: 40%;">
				<tr>
					<td>
						<label class="mt-3 font-weight-bold">아이디</label>
						<input type="text" class="form-control" id="id" name="id" style="height: 45px;">
						<span class="error">필수 입력 정보입니다.</span>
					</td>
				</tr>
				<tr>
					<td>
						<label class="mt-3 font-weight-bold">비밀번호</label>
						<input type="password" class="form-control" id="pwd" name="pwd" style="height: 45px;">
						<span class="error">필수 입력 정보입니다.</span>
					</td>
				</tr>
				<tr>
					<td>
						<label class="mt-3 font-weight-bold">비밀번호 확인</label>
						<input type="password" class="form-control" id="checkpwd" name="checkpwd" style="height: 45px;">
						<span class="error">필수 입력 정보입니다.</span>
					</td>
				</tr>
				<tr>
					<td>
						<label class="mt-3 font-weight-bold">이름</label>
						<input type="text" class="form-control" id="name" name="name" style="height: 45px;">
						<span class="error">필수 입력 정보입니다.</span>
					</td>
				</tr>
				<tr>
					<td>
						<label class="mt-3 font-weight-bold">생년월일</label>
						<input type="date" class="form-control" id="birthday" name="birthday" style="height: 45px;">
						<span class="error">필수 입력 정보입니다.</span>
					</td>
				</tr>
				<tr>
					<td>
						<label class="mt-3 font-weight-bold">휴대전화</label>
						<input type="text" class="form-control" id="phone" name="phone" style="height: 45px;" placeholder="전화번호 입력 (' - ' 제외)">
						<span class="error">필수 입력 정보입니다.</span>
					</td>
				</tr>
				<tr>
					<td>
						<label class="mt-3 font-weight-bold">이메일</label>
						<input type="text" class="form-control" id="email" name="email" style="height: 45px;">
						<span class="error">필수 입력 정보입니다.</span>
					</td>
				</tr>
				<tr>
					<td>
						<button type="button" id="btnSignup" class="w-100 mt-3 py-1">가입하기</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>