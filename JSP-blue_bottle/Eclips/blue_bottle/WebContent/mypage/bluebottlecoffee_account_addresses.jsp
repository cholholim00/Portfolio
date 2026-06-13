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
		boolean rsRes = false;		 

    if (user_idx == null) {
        response.sendRedirect("./login/bluebottlecoffee_account_login.jsp");
        return;
    }

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
				String url = "jdbc:oracle:thin:@localhost:1521:xe";
				String id = "musthave";
				String pwd = "1234";
				Class.forName("oracle.jdbc.OracleDriver");
				conn = DriverManager.getConnection(url, id, pwd);
				
				String sql = "select last_name,first_name,post_num,addr,detail_addr,phone,user_addr_idx from user_addr where idx=?";
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
    <title>주문 내역 - Blue Bottle Coffee</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="./bluebottlecoffee_account_addresses.css">
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

    <!-- 주소록 있을 때 -->
    <div class="customer-container">
        <aside>
            <div class="small_hide">
                <div class="content_list">
                    <div class="title_hide">
                        <h4>내 계정</h4>
                    </div>
                    <ul class="side_text mt-3">
                        <li>
                            <a href="bluebottlecoffee_account.jsp" class="information">개인 정보</a>
                        </li>
                        <li>
                            <a href="bluebottlecoffee_pages_order-list.jsp" class="orderlist">주문 내역</a>
                        </li>
                        <li>
                            <a href="bluebottlecoffee_account_addresses.jsp" class="addresslist">주소록</a>
                        </li>
                    </ul>
                </div>
                <div class="logout_class mt-3">
                    <a href="../login/3_Logout.jsp" class="logout">로그 아웃</a>
                </div>
            </div>
        </aside>

        <div class="account-card" style="height: 100%">
            <div class="card-detail">
                <h2>주소록</h2>
                <hr>
                <div class="card-form">
								<% while(rs.next()){ %>
										<% rsRes = true; %>
                    <div class="address-item">
                        <div class="address-header">
                            <div class="address-name"><%=rs.getString("last_name") %><%=rs.getString("first_name") %></div>
                            <div class="d-flex align-items-center gap-2">
                                <div class="address-actions">
                                		<% int user_addr_idx = rs.getInt("user_addr_idx"); %>
                                    <button class="btn-delete" onclick="location.href='./delete_addr.jsp?user_addr_idx=<%=user_addr_idx%>'">삭제</button>
                                </div>
                            </div>
                        </div>
                        <div class="address-details">
                            <div class="detail-row">
                                <span class="detail-label">주소:</span>
                                <span class="detail-value address-full"><%=rs.getString("addr") %>, <%=rs.getString("detail_addr") %></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">연락처:</span>
                                <span class="detail-value"><%=rs.getString("phone") %></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">우편번호:</span>
                                <span class="detail-value"><%=rs.getInt("post_num") %></span>
                            </div>
                        </div>
                    </div>
								<% } %>
										
										<% if(rsRes == false){ %>
                    	<button class="a_plus" onclick="openPopup()">주소 추가하기</button>
										<% } %>
                    <div class="overlay" id="overlay">
				        <div class="popup">
				            <span class="close-btn" onclick="closePopup()">닫기 ✕</span>
				
				            <form action="./proc.jsp" method="post" name="address">
				                <div class="popup-header">
				                    <strong>주소 추가하기</strong>
				                    <p class="p-h-p mt-3">고객님의 개인 정보 업데이트를 원하시면, 아래 내용을 작성해 주세요. (*는 필수 입력 항목입니다.)</p>
				                </div>
				
				                <div class="popup-body">
				                    <div class="popup-body-top">
				                        <label class="top-label">수령인 *</label>
				                        <div class="body-input">
				                            <input class="b-input1" type="text" name="last_name" placeholder="성 (Last name) *" required />
				                            <input class="b-input2" type="text" name="first_name" placeholder="이름 (First name) *" required />
				                            <input class="b-input3" type="text" name="phone" placeholder="전화번호" />
				                        </div>
				                    </div>
				
				                    <div class="popup-body-bottom">
				                        <label class="bottom-label">배송지 *</label>
				
				                        <div class="latter">
				                            <input class="b-input6" type="text" name="zipcode" placeholder="우편번호" required />
				                            <button class="latter-btn" type="button" onclick="findZipcode()">우편번호 찾기</button>
				                        </div>
				
				                        <div class="body-input">
				                            <input class="b-input4" type="text" name="address" placeholder="주소 (시,구,동) *" required />
				                            <input class="b-input5" type="text" name="detail_address" placeholder="상세주소 (아파트 동/호수, 일반주택 등)" />
				                        </div>
				                    </div>
				                </div>
				
				                <button class="btn-save" type="submit">저장</button>
				            </form>
				        </div>
				    </div>
                    
                </div>
            </div>
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

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
    
    <script>
        function loadMoreOrders() {
            alert('여기다가 제품 추가 등 수정');
            // 실제 구현에서는 AJAX 요청으로 추가 데이터 로드
        }
        
        // 주문 아이템 클릭 시 상세 정보 표시
        document.querySelectorAll('.order-item').forEach(item => {
            item.addEventListener('click', function() {
                const orderNumber = this.querySelector('.order-number').textContent;
                console.log(`주문 ${orderNumber} 상세 정보 보기`);
            });
        });
        
        // 이미지 로딩 에러 처리
        document.querySelectorAll('.product-image img').forEach(img => {
            img.onerror = function() {
                this.style.display = 'none';
                this.parentElement.style.backgroundColor = '#e9ecef';
                this.parentElement.innerHTML = '<div style="display:flex;align-items:center;justify-content:center;height:100%;color:#6c757d;font-size:12px;">이미지 없음</div>';
            };
        });



        function openPopup() {
            document.getElementById("overlay").style.display = "flex";
        }

        function closePopup() {
            document.getElementById("overlay").style.display = "none";
        }

    </script>
  </body>
</html>