<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.net.URLEncoder, java.security.SecureRandom" %>
<%@ page import="java.io.UnsupportedEncodingException" %>

<% 
	String userName = (String)session.getAttribute("user_name");
  Integer user_idx = (Integer) session.getAttribute("user_idx");
	//int user_idx = (int)session.getAttribute("user_idx");
	String user_id = (String)session.getAttribute("user_id");
	String phone = (String)session.getAttribute("phone");
%>
<!doctype html>
<%
	String state = generateRandomString();
	session.setAttribute("naver_state", state);
	
	String clientId = "idsucaZvW7szN_1HKKlX";
	String redirectURI = URLEncoder.encode("http://localhost:8090/blue_bottle/login/naver_callback.jsp", "UTF-8");
	
	String naverAuthURL = "https://nid.naver.com/oauth2.0/authorize"
	                    + "?response_type=code"
	                    + "&client_id=" + clientId
	                    + "&redirect_uri=" + redirectURI
	                    + "&state=" + state;
%>
<%!
    // 랜덤 문자열 생성 함수
    private String generateRandomString() {
        SecureRandom random = new SecureRandom();
        return Long.toString(Math.abs(random.nextLong()), 36);
    }
%>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="./bluebottlecoffee_account_login.css">
    <!-- <link rel="stylesheet" href="./main3.css">
    <link rel="stylesheet" href="./main4.css"> -->
  </head>
  <body>
    <!-- 네비게이션 바 -->
    <header class="my_header">
        <nav class="navbar navbar-expand-lg custom-navbar p-0">
            <div class="container-fluid">               
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav me-auto ms-4 mb-2 mb-lg-0">
                        <li class="nav-item me-3">
                            <a class="nav-link active" href="#">쇼핑</a>
                        </li>
                        <li class="nav-item me-3">
                            <a class="nav-link active" href="../shopping/bestseller.jsp">베스트셀러</a>
                        </li>
                        <li class="nav-item me-3">
                            <a class="nav-link active" href="../shopping/sets.jsp">세트</a>
                        </li>
                        <li class="nav-item me-3">
                            <a class="nav-link active" href="../cafe-list/cafe-list.jsp">카페</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="../Board/list2.jsp">리뷰</a>
                        </li>
                    </ul>

                    <ul class="navbar-nav navbar-center mb-2 mb-lg-0">
                        <a class="navbar-brand" href="../main/index.jsp">
                            <img src="../main/images/logo2.png" alt="" width="20%">
                        </a>
                    </ul>

                    <ul class="navbar-nav ms-auto me-4 mb-2 mb-lg-0">
                        <li class="nav-item">
                            <a class="nav-link active" href="../search/search.jsp?search=">
                                <svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" fill="currentColor" class="bi bi-search" viewBox="0 0 16 16">
                                <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0"/>
                                </svg>
                            </a>
                        </li>
                        <li class="nav-item ms-3">
                            <a class="nav-link active" onclick="openLoginPopup(); return false;">
										        	<svg xmlns="http://www.w3.org/2000/svg" width="23" height="23" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
					                                <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
					                                </svg>
										        </a>
                        </li>
                        <li class="nav-item ms-3">
	                            <a class="nav-link active" href="../cart/cart.jsp?idx=<%=user_idx%>">
	                                <svg xmlns="http://www.w3.org/2000/svg" width="19" height="19" fill="currentColor" class="bi bi-bag" viewBox="0 0 16 16">
	                                <path d="M8 1a2.5 2.5 0 0 1 2.5 2.5V4h-5v-.5A2.5 2.5 0 0 1 8 1m3.5 3v-.5a3.5 3.5 0 1 0-7 0V4H1v10a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V4zM2 5h12v9a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1z"/>
	                                </svg>
	                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

    
    <div class="customer-container" style="width: 100%;">
        <div class="customer-login">
            <h3 id="login" tabindex="-1">
               로그인<br>
            </h3>
            <span>블루보틀 온라인 스토어의 다양한 혜택을 만나보세요</span>
            
            <form action="3_LoginProcess.jsp" method="post" name="login">
                <% if (request.getAttribute("LoginErrMsg") != null) { %>

			    <div class="error-message">
			       <div class="error-icon">!</div>
			       <span><%= request.getAttribute("LoginErrMsg") %></span>
			    </div>
						<% } %>
				
                <div class="form-floating mb-3 mt-3">
                    <input type="email" class="form-control" id="floatingInput" name="user_id" placeholder="이메일 주소 *" >
                    <label for="floatingInput">이메일 주소 *</label>
                </div>
                <div class="form-floating">
                    <input type="password" class="form-control" id="floatingPassword" name="user_pw" placeholder="비밀번호 *" >
                    <label for="floatingPassword">비밀번호 *</label>
                </div>
                
                <a href="#" class="passfor" onclick="openPassPopup(); return false;">비밀번호를 잊으셨나요?</a>
                
                <div class="d-grid mt-4">
                    <input type="submit" class="btn btn-primary1 mb-3" name="login_submit" value="로그인">
                    <button class="btn btn-primary2 mb-4" type="button" onclick="location.href='../register/bluebottlecoffee_account_register.jsp'">회원 가입</button>
                </div>
            </form>
            
            <hr>
				
			<a href="<%= naverAuthURL %>">
		        <img src="./btnG_icon.png" alt="네이버 로그인" width="55" height="55">
		    </a>

            
        </div>
    </div>



    <div class="my_find_coffee">
        <div class="my_footer">
            <div class="container text-white py-5">
                <div class="row row-cols-1 row-cols-md-4 mb-4">
                <!-- 첫 번째 열 -->
                    <div>
                        <h6 class="fw-bold mb-3">블루보틀 커피</h6>
                        <a href="#" class="text-decoration-none"><p class="mb-1">카페 찾기</p></a>
                        <a href="#" class="text-decoration-none"><p class="mb-1">커리어</p></a>
                    </div>
                    <!-- 두 번째 열 -->
                    <div>
                        <h6 class="fw-bold mb-3">알아보기</h6>
                        <a href="#" class="text-decoration-none"><p class="mb-1">브랜드 소개</p></a>
                        <a href="#" class="text-decoration-none"><p class="mb-1">블루보틀 커피</p></a>
                        <a href="#" class="text-decoration-none"><p class="mb-1">지속가능성</p></a>
                        <a href="#" class="text-decoration-none"><p class="mb-1">브루잉 가이드</p></a>
                        <a href="#" class="text-decoration-none"><p class="mb-1">블로그</p></a>
                    </div>
                    <!-- 세 번째 열 -->
                    <div>
                        <h6 class="fw-bold mb-3">문의</h6>
                        <a href="#" class="text-decoration-none"><p class="mb-1">자주 묻는 질문</p></a>
                    </div>
                    <!-- 네 번째 열 -->
                    <div>
                        <h6 class="fw-bold mb-3">구독하고 최신 정보를 받아보세요.</h6>
                        <p class="mb-2">이메일 뉴스레터에 가입하여 혜택과 소식을 받아보세요.</p>

                        <div>
                            <!-- 소셜 아이콘은 여기에 -->
                            <i class="bi bi-instagram mx-1">@</i>
                            <i class="bi bi-youtube mx-1">@</i>
                            <i class="bi bi-facebook mx-1">@</i>
                            <i class="bi bi-twiter mx-1">@</i>
                            <i class="bi bi-kakaotalk mx-1">@</i>
                            <!-- ... -->
                        </div>
                    </div>                                               
                </div>
                <!-- 회사 정보 -->
                <div class="mt-4 mb-3 small">
                    상호: 블루보틀커피코리아 유한회사 | 대표자: KARL WILLIAM STROVINK | 개인정보관리책임자: 임홍주<br>
                    사업자등록번호: 155-81-01195 | 이메일: support_kr@bluebottlecoffee.com | 주소: 서울특별시 성동구 아차산로 7<br>
                    호스팅: Shopify, Inc.
                </div>
                <!-- 하단 -->
                <div class="d-flex justify-content-between align-items-center border-top pt-3 px-0">
                    <div class="d-flex gap-3 flex-wrap">
                        <a href="#" class="small text-white text-decoration-none">개인정보 처리방침</a>
                        <a href="#" class="small text-white text-decoration-none">판매이용약관</a>
                        <a href="#" class="small text-white text-decoration-none">환불 정책</a>
                    </div>
                    <div class="small">© 2023 BLUE BOTTLE COFFEE INC., ALL RIGHTS RESERVED</div>
                </div>
            </div>
        </div>
    </div>
    








			
	<form action="3_LoginProcess.jsp" method="post" name="loginPopup">
        <div class="popup-overlay" id="popupOverlaylogin" style="display: none;">
            <div class="login-popup" id="loginPopup">
                <div class="close" id="closeBtnlogin">&times;</div>

                <div class="form-all">
                    <div class="form-header">
                        <p class="p_login">로그인</p>
                        <p class="subtext">블루보틀 온라인 스토어의 다양한 혜택을 만나보세요</p>
                    </div>
                    
	                    <% if (request.getAttribute("LoginErrMsg") != null) { %>
	
				    <div class="error-message2">
				       <div class="error-icon2">!</div><span><%= request.getAttribute("LoginErrMsg") %></span>
				    </div>
							<% } %>
						
                    <div class="form-customer">
                        <div class="form-body">
                            <div class="form-floating mb-3 mt-3">
                                <input type="email" class="form-control1" name="email_type" id="floatingInput" placeholder="이메일 주소 *" >
                                <!-- <label for="floatingInput">이메일 주소 *</label> -->
                            </div>
                            <div class="form-floating">
                                <input type="password" class="form-control1" name="pwd_type" id="floatingPassword" placeholder="비밀번호 *" >
                                <!-- <label for="floatingPassword">비밀번호 *</label> -->
                            </div>
                            <a href="passPopup.html" class="passfor" onclick="openPassPopup(); return false;">비밀번호를 잊으셨나요?</a>
                            <div class="d-grid mt-4">
                                <input type="submit" class="btn btn-primary3 mb-3" name="login_btn" value="로그인">
                                <button class="btn btn-primary4 mb-4" type="button" onclick="location.href='../register/bluebottlecoffee_account_register.jsp'">회원 가입</button>
                                <hr>
                             </div>
                                <div style="text-align: center;">
								  <a href="<%= naverAuthURL %>">
								    <img class="naver-login" src="btnG_icon.png" alt="네이버 로그인" width="55" height="55">
								  </a>
								</div>
                        </div>

                    </div>

                </div>
            </div>
        </div>
    </form>

    <form action="https://httpbin.org/post" method="post" name="passPopup">
        <div class="popup-overlay" id="popupOverlaypassword" style="display: none;">
            <div class="login-popup" id="passwordPopup">
                <div class="close" id="closeBtnpassword">&times;</div>

                <div class="form-all">
                    <div class="form-header">
                        <p class="p_login">비밀번호 재설정</p>
                        <p class="subtext">비밀번호 재설정을 위해 이메일을 보내드리겠습니다.</p>
                    </div>
                    
                    <div class="form-customer">
                        <div class="form-body">
                            <div class="form-floating mb-3">
                                <input type="email" class="form-control1" name="email_type" id="form-floating" placeholder="이메일 주소 *">
                                <!-- <label for="form-floating">이메일 주소 *</label> -->
                            </div>
                            
                            <div class="d-grid mt-4">
                                <input type="submit" class="btn btn-primary3 mb-3" name="sub_btn" value="제출">
                                <button class="btn btn-primary4 mb-4" type="button" onclick="closePassPopup(); return false;">취소</button>
                                <hr>
                            </div>
                        </div>

                    </div>

                </div>
            </div>
        </div>
    </form>





    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>

    <script>
	    function openLoginPopup() {
	        document.getElementById("popupOverlaylogin").style.display = "flex";
	    }
	    function closeLoginPopup() {
	        document.getElementById("popupOverlaylogin").style.display = "none";
	    }
	
	    function openPassPopup() {
	        document.getElementById("popupOverlaypassword").style.display = "flex";
	    }
	    function closePassPopup() {
	        document.getElementById("popupOverlaypassword").style.display = "none";
	    }
	
	    // 로그인 팝업 닫기 버튼 이벤트
	    document.getElementById("closeBtnlogin").addEventListener("click", closeLoginPopup);
	    document.getElementById("popupOverlaylogin").addEventListener("click", function(e) {
	        if(e.target === this) closeLoginPopup();
	    });
	
	    // 비밀번호 팝업 닫기 버튼 이벤트
	    document.getElementById("closeBtnpassword").addEventListener("click", closePassPopup);
	    document.getElementById("popupOverlaypassword").addEventListener("click", function(e) {
	        if(e.target === this) closePassPopup();
	    });

	</script>



  </body>
</html>