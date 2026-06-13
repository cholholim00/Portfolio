<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% 
	String userName = (String)session.getAttribute("user_name");
  Integer user_idx = (Integer) session.getAttribute("user_idx");
	//int user_idx = (int)session.getAttribute("user_idx");
	String user_id = (String)session.getAttribute("user_id");
	String phone = (String)session.getAttribute("phone");
%>

<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="css/bluebottlecoffee_pages_sign-up-transfer.css">
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

    
    
    <div class="main-content">
        <div class="form-content">
            <div class="header-content">
                <h1>개인정보 국외 이전에<br>대한 동의</h1>
            </div>
            <div class="body-content mt-4">
                <div class="rte scroll-trigger animate--slide-in">
                    <p data-mce-fragment="1">블루보틀은 다국적 브랜드로서 다양한 사법관할구역 내에서 데이터 베이스를 보유합니다<span data-mce-fragment="1">.</span></p>
                    <p data-mce-fragment="1">블루보틀은 귀하의 거주 국가 외부에 위치한 목적지<span data-mce-fragment="1">, </span>즉 이러한 데이터베이스 중 한 곳<span data-mce-fragment="1">, </span>블루보틀 그룹 소속사<span data-mce-fragment="1">, </span>또는 귀하의 데이터에 대한 기밀과 보안 유지에 동의한 파트너사로 귀하의 데이터를 전송할 수 있습니다<span data-mce-fragment="1">.</span></p>
                    <p data-mce-fragment="1">블루보틀은 해당 국가 내의 데이터베이스로 전송되는 데이터가 동일한 수준으로 보호되도록 보장할 것이며<span data-mce-fragment="1">, </span>이러한 국가 내에서 제<span data-mce-fragment="1">3</span>자에게 데이터가 전송되는 일이 없도록 노력할 것입니다<span data-mce-fragment="1">.</span></p>
                    <p data-mce-fragment="1">귀하는 귀하의 데이터를 제공함으로써 블루보틀 그룹의 계열사<span data-mce-fragment="1">/</span>파트너사로의 데이터 전송이 발생할 수 있습니다<span data-mce-fragment="1">. </span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">&nbsp;</span></p>
                    <p data-mce-fragment="1">그 구체적 내용은 다음과 같습니다<span data-mce-fragment="1">.</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">&nbsp;</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">1) </span>국외이전의 법적 근거<span data-mce-fragment="1">: </span>개인정보 보호법 제<span data-mce-fragment="1">28</span>조의<span data-mce-fragment="1">8 </span>제<span data-mce-fragment="1">1</span>항 제<span data-mce-fragment="1">1</span>호</p>
                    <p data-mce-fragment="1">이전되는 개인정보 항목<span data-mce-fragment="1">: </span>이름<span data-mce-fragment="1">, </span>이메일<span data-mce-fragment="1">, </span>전화번호<span data-mce-fragment="1">, </span>주소</p>
                    <p data-mce-fragment="1">이전되는 국가<span data-mce-fragment="1">: </span>캐나다</p>
                    <p data-mce-fragment="1">이전 일시<span data-mce-fragment="1">: </span>회원 가입 즉시</p>
                    <p data-mce-fragment="1">이전 방법<span data-mce-fragment="1">: </span>전자적 방법을 통한 국외 이전</p>
                    <p data-mce-fragment="1">이전받는 법인<span data-mce-fragment="1">: Shopify Inc.</span></p>
                    <p data-mce-fragment="1">이전받는 법인의 정보보호 책임자<span data-mce-fragment="1">: Head of Privacy (support@shopify.com)</span></p>
                    <p data-mce-fragment="1">이전받는 법인의 이용목적<span data-mce-fragment="1">: </span>블루보틀 회원 서비스 제공에 관한 계약이행 및 서비스 제공에 따른 요금 정산<span data-mce-fragment="1">, </span>회원관리 및 고객 클레임 처리</p>
                    <p data-mce-fragment="1">이전되는 개인정보 보유 이용 기간<span data-mce-fragment="1">: </span>회원 탈퇴 시까지</p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">&nbsp;</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">2) </span>국외이전의 법적 근거<span data-mce-fragment="1">: </span>개인정보 보호법 제<span data-mce-fragment="1">28</span>조의<span data-mce-fragment="1">8 </span>제<span data-mce-fragment="1">1</span>항 제<span data-mce-fragment="1">1</span>호</p>
                    <p data-mce-fragment="1">이전되는 개인정보 항목<span data-mce-fragment="1">: </span>이름<span data-mce-fragment="1">, </span>이메일<span data-mce-fragment="1">, </span>전화번호<span data-mce-fragment="1">, </span>주소</p>
                    <p data-mce-fragment="1">이전되는 국가<span data-mce-fragment="1">: </span>미국</p>
                    <p data-mce-fragment="1">이전 일시<span data-mce-fragment="1">: </span>회원 가입 즉시</p>
                    <p data-mce-fragment="1">이전 방법<span data-mce-fragment="1">: </span>전자적 방법을 통한 국외 이전</p>
                    <p data-mce-fragment="1">이전받는 법인<span data-mce-fragment="1">: Snowflake Inc. </span></p>
                    <p data-mce-fragment="1">이전받는 법인의 정보보호 책임자<span data-mce-fragment="1">: Head of Privacy (privacy@snowflake.com)</span></p>
                    <p data-mce-fragment="1">이전받는 법인의 이용목적<span data-mce-fragment="1">: </span>블루보틀 회원 서비스 제공에 관한 계약이행 및 서비스 제공에 따른 요금 정산<span data-mce-fragment="1">, </span>회원관리 및 고객 클레임 처리</p>
                    <p data-mce-fragment="1">이전되는 개인정보 보유 이용 기간<span data-mce-fragment="1">: </span>회원 탈퇴 시까지</p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">&nbsp;</span></p>
                    <p data-mce-fragment="1">개인정보 국외이전 동의를 선택하지 않음으로써 국외이전 동의를 거부할 수 있습니다<span data-mce-fragment="1">. </span>다만<span data-mce-fragment="1">, </span>국외이전 동의를 거부할 경우 블루보틀 서비스 제공이 불가합니다<span data-mce-fragment="1">.</span></p>
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
  </body>
</html>