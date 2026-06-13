<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import="java.sql.*"%>

<% 
	String userName = (String)session.getAttribute("user_name");
  Integer user_idx = (Integer) session.getAttribute("user_idx");
	//int user_idx = (int)session.getAttribute("user_idx");
	String user_id = (String)session.getAttribute("user_id");
	String phone = (String)session.getAttribute("phone");
%>

<%
		request.setCharacterEncoding("UTF-8");
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
				String url = "jdbc:oracle:thin:@localhost:1521:xe";
				String id = "musthave";
				String pwd = "1234";
				Class.forName("oracle.jdbc.OracleDriver");
				conn = DriverManager.getConnection(url, id, pwd);
				
				String sql = "SELECT last_name, first_name, phone, user_id FROM users WHERE idx=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, user_idx);
				rs = pstmt.executeQuery();
				
		}catch(Exception e){
				System.out.println(e.getMessage());
		}
%>


<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="./bluebottlecoffee_account.css">
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
                            <img src="./images/logo2.png" alt="" width="20%">
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
                        <% if(user_idx == null){ %>
	                            <a class="nav-link active" href="../login/bluebottlecoffee_account_login.jsp">
	                                <svg xmlns="http://www.w3.org/2000/svg" width="23" height="23" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
	                                <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
	                                </svg>
	                            </a>
                            <% }else{ %>
	                            <a class="nav-link active" href="../mypage/bluebottlecoffee_account.jsp">
	                                <svg xmlns="http://www.w3.org/2000/svg" width="23" height="23" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
	                                <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
	                                </svg>
	                            </a>
                            <% } %>
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

    
    
    
    <form action="updateProfile.jsp" method="post">
        <div class="customer-container">
            <aside>
                <div class="small_hide">
                    <div class="content_list">
                        <div class="title_hide">
                            <h4 >내 계정</h4>
                        </div>
                        <ul class="side_text mt-3">
                            <li>
                                <a href="bluebottlecoffee_account.jsp" class="information">개인 정보</a>
                            </li>
                            <li>
                                <a href="./bluebottlecoffee_pages_order-list.jsp" class="orderlist">주문 내역</a>
                            </li>
                            <li>
                                <a href="./bluebottlecoffee_account_addresses.jsp" class="addresslist">주소록</a>
                            </li>
                        </ul>
                    </div>
                    <div class="logut_class mt-3">
                        <a class="nav-link active" href="../login/3_Logout.jsp">로그아웃</a>
                    </div>
                </div>
            </aside>

            <div class="account-card">
                <div>
                    <h2>계정 정보</h2>
                    <h5>개인 정보</h5>
                    <hr>
                    <% while(rs.next()){ %>
                    <strong class="customer-email">이메일 주소: <%=rs.getString("user_id") %></strong>

                    	<div class="form-floating mb-3 mt-3">
		                    <div class="d-flex gap-3">
		                        <div class="form-floating flex-fill">
		                        <input type="text" class="form-control" id="lastName" name="last_name" placeholder="성 (Last name) *" required value="<%=rs.getString("last_name") %>">
		                        <label for="lastName">성 (Last name) *</label>
		                        </div>
		                        <div class="form-floating flex-fill">
		                        <input type="text" class="form-control" id="firstName" name="first_name" placeholder="이름 (First name) *" required value="<%=rs.getString("first_name") %>">
		                        <label for="firstName">이름 (First name) *</label>
		                        </div>
		                    </div>
		                    <div class="form-floating mt-3">
		                        <input type="tel" class="form-control" id="telnumber" name="phone" placeholder="전화번호 *" required value="<%=rs.getString("phone") %>">
		                        <label for="telnumber">전화번호 *</label>
		                    </div>
	                    </div>
	                    <% } %>
	                    <div class="card-detail">
	                        <div class="card-header">
	                            <h5>마케팅 수신 동의</h5>
	                            <hr>
	                        </div>
	
	                        <div class="card-check mt-4">
	                            <input type="checkbox" id="emailCheck" class="custom-checkbox" name="check_one">
	                            <label for="emailCheck">마케팅 활용 동의 / 쿠폰 수신 (이메일) (선택)</label>
	
	                            <br>
	
	                            <input type="checkbox" id="smsCheck" class="custom-checkbox" name="check_two">
	                            <label for="smsCheck">마케팅 활용 동의 / 쿠폰 수신 (SMS) (선택)</label>
	                        </div>
	
	
	                        <div class="card-button d-flex gap-2 mt-3">
	                            <div class="card-buttontype flex-fill">
	                            		<input type="hidden" name="user_idx" value="<%=user_idx %>" />
	                                <input type="submit" class="btn btn-primary" value="저장" name="save">
	                            </div>
	                            <div class="card-buttontype flex-fill">
	                                <input type="button" class="btn btn-primary" value="비밀번호 변경" name="change" onclick="openPassPopup(); return false;">
	                            </div>
	                        </div>
                    </div>
                </div>
            </div>

        </div>
    </form>

<!-- my_find_coffe의 padding을 삭제해놓은 상태 -->




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
    
    	<form action="" method="post" name="passPopup">
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
    




	<script>
        function validateForm() {
            const lastName = document.getElementById('lastName').value.trim();
            const firstName = document.getElementById('firstName').value.trim();
            const phone = document.getElementById('telnumber').value.trim();
            
            if (!lastName || !firstName || !phone) {
                alert('모든 필수 항목을 입력해주세요.');
                return false;
            }
            
            // 전화번호 형식 검증
            const phonePattern = /^[0-9]{10,11}$/;
            if (!phonePattern.test(phone)) {
                alert('전화번호는 10-11자리 숫자만 입력하세요.');
                return false;
            }
            
            return confirm('정보를 업데이트하시겠습니까?');
        }
    </script>

	<script>
		function openPassPopup() {
	        document.getElementById("popupOverlaypassword").style.display = "flex";
	    }
	    function closePassPopup() {
	        document.getElementById("popupOverlaypassword").style.display = "none";
	    }
	    
	 	// 비밀번호 팝업 닫기 버튼 이벤트
	    document.getElementById("closeBtnpassword").addEventListener("click", closePassPopup);
	    document.getElementById("popupOverlaypassword").addEventListener("click", function(e) {
	        if(e.target === this) closePassPopup();
	    });
	</script>










    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
  </body>
</html>