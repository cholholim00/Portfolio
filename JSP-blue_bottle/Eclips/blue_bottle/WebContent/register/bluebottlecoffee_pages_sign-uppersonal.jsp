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
    <link rel="stylesheet" href="css/bluebottlecoffee_pages_sign-uppersonal.css">
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
                <h1>개인정보 처리 위탁에<br>대한 동의</h1>
            </div>
            <div class="body-content mt-4">
                <div class="rte scroll-trigger animate--slide-in">
                    <p>1. 개인정보 처리의 위탁<br data-mce-fragment="1"><br data-mce-fragment="1">블루보틀은 다음과 같이 서비스 제공을 위하여 필요한 개인정보 처리 위탁을 하고 있습니다. 블루보틀은 관계 법령에 따라 위탁 계약 시 개인정보가 안전하게 처리될 수 있도록 필요한 사항을 규정하고 있습니다.<br data-mce-fragment="1"><br data-mce-fragment="1">회사는 신상품 소개, 이벤트 정보 등의 유용한 정보를 제공하기 위하여 개인정보 처리 위탁을 할 수 있으며 그러한 경우 별도의 동의절차를 밟고 있습니다. 블루보틀이 수탁업체에 위탁하는 업무와 관련된 서비스를 이용하지 않는 경우, 이용자의 개인정보가 수탁업체에 제공되지 않습니다. 개인정보 처리 위탁에 동의 않을 수 있으나, 동의하지 않는 경우 본인 확인 인증, 고객정보 분석, 상품 배송 서비스 등 개인정보 처리 위탁을 하는 업무의 제공이 불가능합니다.<br data-mce-fragment="1"><br data-mce-fragment="1">[위탑 업체 정보]<br data-mce-fragment="1">(위탁받은 업체 (수탁사) : 위탁 업무 / 공유하는 개인정보 항목 / 개인정보 보유 및 이용기간)</p>
                    <p>&nbsp;</p>
                    <p>- KG 이니시스: 결제대행서비스/&nbsp;상호<span data-mce-fragment="1">, </span>대표자명<span data-mce-fragment="1">, </span>주민등록번호<span data-mce-fragment="1">(</span>외국인등록번호<span data-mce-fragment="1">), </span>이메일주소<span data-mce-fragment="1">, </span>입금계좌정보<span data-mce-fragment="1">, </span>대표전화번호<span data-mce-fragment="1">, </span>팩스번호<span data-mce-fragment="1">, </span>휴대폰번호<span data-mce-fragment="1">, </span>고객이름<span data-mce-fragment="1">, </span>고객 전화번호<span data-mce-fragment="1">, </span>고객 휴대폰번호<span data-mce-fragment="1">, </span>고객 이메일주소<span data-mce-fragment="1"> / 5</span>년</p>
                    <p>- 네이버파이낸셜주식회사: 네이버페이 간편결제서비스/&nbsp;신용카드번호<span data-mce-fragment="1">, </span>카드유효기간<span data-mce-fragment="1">, CVC</span>번호<span data-mce-fragment="1">, </span>카드비밀번호앞<span data-mce-fragment="1">2</span>자리<span data-mce-fragment="1"> /5</span>년</p>
                    <p>- 구글 (Google): 디지털 광고 매체사 (1st party data 활용) / 이메일 주소 / 계정 내 정보 삭제시까지</p>
                    <p>- 메타 (Meta Platforms Inc. (Facebook)): 디지털 광고 매체사 (1st party data 활용) / 이메일 주소 / 계정 내 정보 삭제시까지</p>
                    <p>- 주식회사 카카오 (Kakao Corp.): 고객 일치 타겟팅 및 광고 노출 / 이름, 전화번호, 이메일, 주소, 구매이력 / 2개월</p>
                    <p>- Shopify: 블루보틀 온라인 스토어 플랫폼/ 이름, 전화번호, 이메일, 주소/ 계정 내 정보 삭제시까지</p>
                    <p>- CJ 대한통운: 주문배송처리 대행/&nbsp;성명<span data-mce-fragment="1">/</span>주소<span data-mce-fragment="1">/</span>전화번호<span data-mce-fragment="1"> / </span>서비스 계약 기간 종료까지</p>
                    <p>- 일양로지스:&nbsp;<span data-mce-fragment="1">주문배송처리 대행/&nbsp;</span><span data-mce-fragment="1">성명</span><span data-mce-fragment="1">/</span><span data-mce-fragment="1">주소</span><span data-mce-fragment="1">/</span><span data-mce-fragment="1">전화번호</span><span data-mce-fragment="1">&nbsp;/&nbsp;</span><span data-mce-fragment="1">서비스 계약 기간 종료까지</span></p>
                    <p>- 주식회사 한국기업콜센터: 고객응대, 상품 및 서비스 홍보와 마케팅 목적의 정보 제공 서비스 / 고객명, 전화번호, 주소, 주문내역, 상담이력, 상담내용녹취 / 3개월</p>
                    <p>- 삼백씨비티㈜: 플랫폼 개발 및 서비스 운영/ 회원정보/ 계정 내 정보 삭제시까지</p>
                    <p>- 주식회사 채널코퍼레이션:&nbsp;고객응대 및 서비스 홍보와 마케팅 목적의 정보 서비스 제공/&nbsp;고객명<span data-mce-fragment="1">, </span>전화번호<span data-mce-fragment="1">, </span>주소<span data-mce-fragment="1">, </span>주문내역<span data-mce-fragment="1">, </span>상담이력<span data-mce-fragment="1">/ </span>계정 내 정보 삭제시까지<br data-mce-fragment="1"><br data-mce-fragment="1"><br data-mce-fragment="1">제3자를 통한 맞춤형 광고 전송<br data-mce-fragment="1">(행태정보를 제공받는 자 : 제공하는 행태정보의 항목(결합이 예정된 개인식별정보) /제공하는 행태정보의 항목(맞춤형 광고에 이용될 행태정보 등의 정보) / 행태정보를 제공받는 자의 이용 목적 / 보유 및 이용기간)<br data-mce-fragment="1">- Google Ads: 쿠키 또는 광고 ID, 이메일 주소, 클라이언트 식별자, 인터넷 프로토콜 주소를 포함한 온라인 식별자, 파트너 제공 식별자 / 쿠키 또는 광고 ID 이메일 주소, 클라이언트 식별자, 인터넷 프로토콜 주소를 포함한 온라인 식별자, 파트너 제공 식별자 / 제3자 및 리타겟팅 광고전송 및 잠재고객 관리, Google 사용자가 삭제할 때 까지 / Google 계정에 없는 정보는 8개월~18개월 후 익명 처리, 개인화된 맞춤형 광고를 제공하지 못함<br data-mce-fragment="1">- Meta: 쿠키, 콘텐츠 종류, 콘텐츠 ID 및 콘텐츠 / _fbp / 제3자 및 리타겟팅 광고 운영 / 90일<br data-mce-fragment="1">동의거부 시 불이익 : 개인화된 맞춤형 광고를 제공받지 못함<br data-mce-fragment="1"><br data-mce-fragment="1">2. 개인정보의 제3자 제공<br data-mce-fragment="1">블루보틀은 이용자의 개인정보를 원칙적으로 외부에 공개하지 않습니다. 다만, 아래의 경우에는 예외로 합니다.<br data-mce-fragment="1">- 이용자들이 사전에 공개에 동의한 경우<br data-mce-fragment="1">- 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우.</p>
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