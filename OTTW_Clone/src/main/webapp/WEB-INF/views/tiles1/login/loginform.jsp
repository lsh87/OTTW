<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	String ctxPath = request.getContextPath();
%>

<style type="text/css">

	input.form-control {
		padding: 0 10px;
	}
	
	button#btnLogin {
		border: none;
		border-radius: 5px;
		background-color: #24c0eb; 
		color: white;
		font-weight: bold;
		height: 45px;
	}
	
	a.signUp:hover, a.findIdPwd:hover {cursor: pointer; font-weight: bold;}
	
	ul#tabs {border: none;}
	ul#tabs li {
		border-bottom: none;
		padding: 10px;
		margin-right: 5px;
	}
	ul#tabs a {text-decoration: none; color: black; font-weight: bold;}
	ul#tabs li.active {border-bottom: solid 3px #24c0eb;}
	

</style>

<script type="text/javascript">

	$(document).ready(function() {
		
		$("button#btnLogin").click(function() {
			goLogin();
		});
		
		$("input#pwd").keydown(function(event) {
			if(event.keyCode == 13) { // 엔터를 입력한 경우
				goLogin();
			}
		});
		
		$("ul#tabs li").click(function() {
			$("ul#tabs li").removeClass("active");
			$(this).addClass("active");
			
			$(".tab-pane").hide();
			 
			var activeTab = $(this).find("a").attr("href");
			$(activeTab).show();
		});
		
		$("input#code").hide();i
		$("button#btnCertificationPhone").click(function() {
			
			if($("input#phone").val().trim() == "") {
				alert("번호를 입력하세요.");
				return false;
			}
			
			$.ajax({
				url:"<%= ctxPath %>/btnCertificationPhone.ottw",
				data:{"phone":$("input#phone").val()},
				type:"POST",
				dataType:"JSON",
				success:function(json) {
					
				},
				error: function(request, status, error){
		            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		        }
			});
			
		});
		
	}); // end of $(document).ready(function() {})

	
	// Function Declaration
	function goLogin() {
		
		const id = $("input#id").val().trim();
		const pwd = $("input#pwd").val().trim();
		
		if(id == "") {
			alert("아이디를 입력하세요.");
			$("input#id").val("");
			$("input#id").focus();
			return;	// 종료
		}
		
		if(pwd == "") {
			alert("비밀번호를 입력하세요.");
			$("input#pwd").val("");
			$("input#pwd").focus();
			return;	// 종료
		}
		
		const frm = document.loginFrm;
		frm.action = "<%= ctxPath %>/loginEnd.ottw";
		frm.method = "POST";
		frm.submit();
		
		$("input#id").val("");
		$("input#pwd").val("");
	}

</script>

<div id="content" style="display: flex; margin-top: 100px;">
	<div style="margin: auto; width: 90%;">
		<form name="loginFrm" align="center">
			<table id="loginTbl" class="w-25" style="margin: auto;">
				<thead>
					<tr>
						<td>
							<img class="mb-4" src="<%= ctxPath %>/resources/images/logo.png" style="width: 300px;" />
						</td>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							<input type="text" class="form-control my-1" id="id" name="id" placeholder="아이디" style="height: 45px;">
						</td>		
					</tr>
					<tr>
						<td>
							<input type="password" class="form-control my-1" id="pwd" name="pwd" placeholder="비밀번호" style="height: 45px;">
						</td>
					</tr>
					<tr >
						<td align="right" class="py-1">
							<a class="signUp text-muted" style="font-size: 10pt;" href="<%= ctxPath %>/signup.ottw">회원가입</a>
							<a class="findIdPwd text-muted ml-1" style="font-size: 10pt;" data-toggle="modal" data-target="#findIdPwdModal">아이디/비밀번호찾기</a>
						</td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td>
							<button type="button" id="btnLogin" class="w-100 my-1 py-1">로그인</button>
						</td>
					</tr>
				</tfoot>
	 		</table>
		</form>
		
		<div class="modal fade" id="findIdPwdModal">
		  	<div class="modal-dialog modal-dialog-centered">
		  	<!-- .modal-dialog-centered 클래스를 사용하여 페이지 내에서 모달을 세로 및 가로 중앙에 배치합니다. -->
		    	<div class="modal-content">
		    		<!-- Modal header -->
					<div class="modal-header" style="border: none;">
						<ul id="tabs" class="nav nav-tabs">
							<li class="active"><a href="#tab1" data-toggle="tab">아이디 찾기</a></li>
							<li><a href="#tab2" data-toggle="tab">비밀번호 찾기</a></li>
						</ul>
						<button type="button" class="close text-muted" data-dismiss="modal">&times;</button>
					</div>
					<!-- Modal body -->
					<div class="modal-body" align="center">
						<div class="tab-content mt-3">
							<!-- 아이디 찾기 -->
							<div class="tab-pane active" id="tab1">
								<div>
									<span>휴대폰 인증</span>
									<input type="text" id="phone" name="phone"/>
									<button type="button" id="btnCertificationPhone">인증</button>
									<input type="text" id="code" />
								</div>
								<div>
									<span>이메일 인증</span>
									<input type="text" id="email" name="email"/>
									<button type="button" id="btnCertificationEmail">인증</button>
								</div>
							</div>
							<!-- 비밀번호 찾기 -->
							<div class="tab-pane" id="tab2">
								비밀번호 찾기
							</div>
						</div>					
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