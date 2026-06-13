<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 세션에서 userId 꺼내기
    String userId = (String) session.getAttribute("UserId");
%>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>브랜드 소개 페이지</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="bluebottlecoffee_pages_our-coffee.css">
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
                            <a class="nav-link active" href="#">베스트셀러</a>
                        </li>
                        <li class="nav-item me-3">
                            <a class="nav-link active" href="#">세트</a>
                        </li>
                        <li class="nav-item me-3">
                            <a class="nav-link active" href="#">카페</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="#">블로그</a>
                        </li>
                    </ul>

                    <ul class="navbar-nav navbar-center mb-2 mb-lg-0">
                        <a class="navbar-brand" href="../main/index.jsp">
                            <img src="../main/images/logo2.png" alt="" width="20%">
                        </a>
                    </ul>

                    <ul class="navbar-nav ms-auto me-4 mb-2 mb-lg-0">
                        <li class="nav-item">
                            <a class="nav-link active" href="#">
                                <svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" fill="currentColor" class="bi bi-search" viewBox="0 0 16 16">
                                <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0"></path>
                                </svg>
                            </a>
                        </li>
                        
                        <li class="nav-item ms-3">
						    <% if(userId == null) { %>
						        <a class="nav-link active" href="../login/bluebottlecoffee_account_login.jsp">
						        	<svg xmlns="http://www.w3.org/2000/svg" width="23" height="23" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
	                                <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
	                                </svg>
						        </a>
						    <% } else { %>
						    <% } %>
						<!-- </li>
                        
                        <li class="nav-item ms-3"> -->
						    <% if(userId != null) { %>
						        <a class="nav-link active" href="../mypage/bluebottlecoffee_account.jsp">
						        	<svg xmlns="http://www.w3.org/2000/svg" width="23" height="23" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
	                                <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
	                                </svg>
						        </a>
						    <% } else { %>
						    <% } %>
						</li>
						
                        <li class="nav-item ms-3">
                            <a class="nav-link active" href="#">
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

    <div class="b-body-all">
	    <div class="main-banner">
		    <img src="./images/18739e5fb95355579ca2a91b8fb18e05.webp" class="img-fluid" alt="메인 이미지">
		    <div class="banner-text">Our Coffee</div>
		</div>
		<br><br>
		
		<div class="text-box-out mt-5">
			<div class="text-box">
				<div class="textbox-header">
					<h3>"커피가 캔에 든 검은 가루라는 생각을 가지고 자라 온 사람은 <br>
					커피가 사실은 나무에서 자란 과일에서 만들어진다는 것을 쉽게 잊어버립니다." </h3>
				</div>
				
				<div class="textbox-body">
					<p>JAMES FREEMAN FOUNDER, BLUE BOTTLE COFFEE</p>
				</div>
			</div>
		</div>
		
		<div class="text-box-out2">
			<div class="text-box2">
				<div class="textbox-body2">
					<p>블루보틀은 스페셜티 커피 회사로서 게스트가 좋아하는 맛에 진심을 가지고 대합니다. 게스트가 선호하는 맛이 볼드한 블렌드 커피이든 라이트 로스팅된 브라이트한 싱글 오리진 커피이든, 블루보틀은 모든 커피 취향에 적합한 커피를 찾는 데 도움을 드리고 싶습니다. 어떤 커피를 좋아하는지 모르신다면, 블루보틀이 도와드리겠습니다.</p>
				</div>
			</div>
		</div>
		
		<div class="text-box-out3 mt-5">
			<div class="text-box3">
				<div class="textbox-header3">
					<h3>변함없는 블루보틀 커피</h3>
				</div>
				
				<div class="textbox-body3">
					<p>블루보틀의 모든 커피는 스페셜티 등급 기준을 넘깁니다.<br>
					<br>
					100점 기준 80점 이상이 되어야 스페셜티 커피로 등록할 수 있으며, 블루보틀은 84점 이상으로 등록된 커피만 구매합니다. <br>
					<br>
					블루보틀 대부분의 커피는 유기농 인증을 받았습니다. 아직 유기농 인증에 적합하지 않은 지역의 싱글 오리진 커피처럼 예외를 적용해야 하는 경우에는 환경 관리 의무를 지속해 온 공급자와 거래합니다.<br>
					<br>
					블루보틀은 평균 5년 이상 함께 일해 온 엄선된 생산 그룹에서 원두를 소싱해오기에 추적에 용이합니다. <br>
					<br>
					블루보틀은 커피의 품질에 맞는 대가를 지급합니다. 블루보틀은 적어도 공정 무역 가격에 부합하게, 혹은 대부분은 그보다 더 높은 가격으로 원두를 구매합니다. <br>
					<br>
					블루보틀 커피 소싱팀의 모든 구성원은 인증받은 Q등급으로서, 해당 등급은 전문 커피 테이스터가 받을 수 있는 가장 높은 인증 등급입니다. 모든 구성원은 산지뿐만 아니라 블루보틀 랩에서도 스페셜티 커피 평가를 위한 훈련을 받습니다.<br>
					<br>
					커피의 품질과 신선도를 보장하기 위해 블루보틀은 주문이 들어오면 소량을 로스팅하여 여러분께 배송해 드립니다.<br>
					<br>
					블루보틀의 로스팅과 배송 과정은 블루보틀의 모든 커피가 온라인은 물론 블루보틀 카페까지 가능한 한 신선하게 배송될 수 있도록 최적화되어 있습니다.<br>
					<br>
					블렌드 커피나 싱글 오리진에 상관없이, 블루보틀은 모든 커피를 동등하게 취급합니다. 블루보틀은 모든 커피의 풍미 프로필을 가장 잘 표현할 수 있도록 로스팅 디자인을 만들었습니다. 또한 도달하고자 하는 정확한 풍미에 매번 다다를 수 있도록 점수 제도를 만들어 운영하고 있습니다.<br>
					<br>
					블루보틀은 전 세계에 위치한 자체 로스터리에서 주문에 따라 로스팅을 진행하며, 매번 로스팅 후 품질 체크를 위해 커핑을 진행합니다.</p>
				</div>
			</div>
		</div>
		
		<div class="img-box-out">
			<div class="img-box">
				<img src="./images/green-beans_k6jvi5_1efecde7-0109-4787-bb28-33c6dc1c4b76.webp" class="" width="1232px" height="616px">
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
                        <a href="../footer/bluebottlecoffee_location-Korea.jsp" class="text-decoration-none"><p class="mb-1">커리어</p></a>
                    </div>
                    <!-- 두 번째 열 -->
                    <div>
                        <h6 class="fw-bold mb-3">알아보기</h6>
                        <a href="bluebottlecoffee_pages_about-us.jsp" class="text-decoration-none"><p class="mb-1">브랜드 소개</p></a>
                        <a href="bluebottlecoffee_pages_our-coffee.jsp" class="text-decoration-none"><p class="mb-1">블루보틀 커피</p></a>
                        <a href="bluebottlecoffee_pages-blue-bottle-sustainability.jsp" class="text-decoration-none"><p class="mb-1">지속가능성</p></a>
                        <a href="bluebottleccoffee_pages-brew-guides.jsp" class="text-decoration-none"><p class="mb-1">브루잉 가이드</p></a>
                        <a href="#" class="text-decoration-none"><p class="mb-1">블로그</p></a>
                    </div>
                    <!-- 세 번째 열 -->
                    <div>
                        <h6 class="fw-bold mb-3">문의</h6>
                        <a href="bluebottlecoffee_pages-faq.jsp" class="text-decoration-none"><p class="mb-1">자주 묻는 질문</p></a>
                    </div>
                    <!-- 네 번째 열 -->
                    <div>
                        <h6 class="fw-bold mb-3">구독하고 최신 정보를 받아보세요.</h6>
                        <p class="mb-2">이메일 뉴스레터에 가입하여 혜택과 소식을 받아보세요.</p>

                        <div>
                        	<i class="bi bi-facebook mx-1">
	                        	<a href="https://www.facebook.com/bluebottlecoffee" 
								   class="link list-social__link d-inline-block mx-1" 
								   target="_blank" 
								   aria-label="Facebook">
								    <svg width="18px" height="18px" aria-hidden="true" focusable="false" 
								         class="icon icon-facebook" viewBox="0 0 20 20" 
								         fill="currentColor" color="rgb(218, 218, 218)">
								        <path d="M18 10.049C18 5.603 14.419 2 10 2c-4.419 0-8 3.603-8 8.049C2 14.067 4.925 17.396 8.75 18v-5.624H6.719v-2.328h2.03V8.275c0-2.017 1.195-3.132 3.023-3.132.874 0 1.79.158 1.79.158v1.98h-1.009c-.994 0-1.303.621-1.303 1.258v1.51h2.219l-.355 2.326H11.25V18c3.825-.604 6.75-3.933 6.75-7.951Z"/>
								    </svg>
								</a>
							</i>
							
							<i class="bi bi-twiter mx-1">
								<a href="https://x.com/bluebottleroast" 
								   class="link list-social__link d-inline-block mx-1" 
								   target="_blank" 
								   aria-label="Twitter">
								    <svg width="18px" height="18px" aria-hidden="true" focusable="false" 
								         class="icon icon-facebook" viewBox="0 0 20 20" 
								         fill="currentColor" color="rgb(218, 218, 218)">
								        <path d="M7.27274 2.8L10.8009 7.82176L15.2183 2.8H16.986L11.5861 8.93887L17.3849 17.1928H12.7272L8.99645 11.8828L4.32555 17.1928H2.55769L8.21157 10.7657L2.61506 2.8H7.27274ZM13.5151 15.9248L5.06895 4.10931H6.4743L14.9204 15.9248H13.5151Z"/>
								    </svg>
								</a>
							</i>
							
							<i class="bi bi-instagram mx-1">
								<a href="https://www.instagram.com/bluebottlekorea/" 
								   class="link list-social__link d-inline-block mx-1" 
								   target="_blank" 
								   aria-label="Twitter">
								    <svg width="18px" height="18px" aria-hidden="true" focusable="false" 
								         class="icon icon-facebook" viewBox="0 0 20 20" 
								         fill="currentColor" color="rgb(218, 218, 218)">
								         <path fill="currentColor" fill-rule="evenodd" d="M13.23 3.492c-.84-.037-1.096-.046-3.23-.046-2.144 0-2.39.01-3.238.055-.776.027-1.195.164-1.487.273a2.43 2.43 0 0 0-.912.593 2.486 2.486 0 0 0-.602.922c-.11.282-.238.702-.274 1.486-.046.84-.046 1.095-.046 3.23 0 2.134.01 2.39.046 3.229.004.51.097 1.016.274 1.495.145.365.319.639.602.913.282.282.538.456.92.602.474.176.974.268 1.479.273.848.046 1.103.046 3.238.046 2.134 0 2.39-.01 3.23-.046.784-.036 1.203-.164 1.486-.273.374-.146.648-.329.921-.602.283-.283.447-.548.602-.922.177-.476.27-.979.274-1.486.037-.84.046-1.095.046-3.23 0-2.134-.01-2.39-.055-3.229-.027-.784-.164-1.204-.274-1.495a2.43 2.43 0 0 0-.593-.913 2.604 2.604 0 0 0-.92-.602c-.284-.11-.703-.237-1.488-.273ZM6.697 2.05c.857-.036 1.131-.045 3.302-.045 1.1-.014 2.202.001 3.302.045.664.014 1.321.14 1.943.374a3.968 3.968 0 0 1 1.414.922c.41.397.728.88.93 1.414.23.622.354 1.279.365 1.942C18 7.56 18 7.824 18 10.005c0 2.17-.01 2.444-.046 3.292-.036.858-.173 1.442-.374 1.943-.2.53-.474.976-.92 1.423a3.896 3.896 0 0 1-1.415.922c-.51.191-1.095.337-1.943.374-.857.036-1.122.045-3.302.045-2.171 0-2.445-.009-3.302-.055-.849-.027-1.432-.164-1.943-.364a4.152 4.152 0 0 1-1.414-.922 4.128 4.128 0 0 1-.93-1.423c-.183-.51-.329-1.085-.365-1.943C2.009 12.45 2 12.167 2 10.004c0-2.161 0-2.435.055-3.302.027-.848.164-1.432.365-1.942a4.44 4.44 0 0 1 .92-1.414 4.18 4.18 0 0 1 1.415-.93c.51-.183 1.094-.33 1.943-.366Zm.427 4.806a4.105 4.105 0 1 1 5.805 5.805 4.105 4.105 0 0 1-5.805-5.805Zm1.882 5.371a2.668 2.668 0 1 0 2.042-4.93 2.668 2.668 0 0 0-2.042 4.93Zm5.922-5.942a.958.958 0 1 1-1.355-1.355.958.958 0 0 1 1.355 1.355Z" clip-rule="evenodd"/>
								   </svg>
								 </a>
							 </i>
							 
							 <i class="bi bi-youtube mx-1">
								 <a href="https://www.youtube.com/channel/UCyki4e6RG84BT_xzi4oYkRw" 
								   class="link list-social__link d-inline-block mx-1" 
								   target="_blank" 
								   aria-label="Twitter">
								    <svg width="18px" height="18px" aria-hidden="true" focusable="false" 
								         class="icon icon-facebook" viewBox="0 0 20 20" 
								         fill="currentColor" color="rgb(218, 218, 218)">
								         <path fill="currentColor" d="M18.16 5.87c.34 1.309.34 4.08.34 4.08s0 2.771-.34 4.08a2.125 2.125 0 0 1-1.53 1.53c-1.309.34-6.63.34-6.63.34s-5.321 0-6.63-.34a2.125 2.125 0 0 1-1.53-1.53c-.34-1.309-.34-4.08-.34-4.08s0-2.771.34-4.08a2.173 2.173 0 0 1 1.53-1.53C4.679 4 10 4 10 4s5.321 0 6.63.34a2.173 2.173 0 0 1 1.53 1.53ZM8.3 12.5l4.42-2.55L8.3 7.4v5.1Z"/>
							        </svg>
								 </a>
							 </i>
							
							 <i class="bi bi-kakaotalk mx-1">
								 <a href="http://pf.kakao.com/_yShcxj" 
								    class="link list-social__link d-inline-block mx-1" 
								    target="_blank" 
								    aria-label="Twitter">
								    <svg width="18px" height="18px" aria-hidden="true" focusable="false" 
								         class="icon icon-facebook" viewBox="0 0 20 20" 
								         fill="currentColor" color="rgb(218, 218, 218)">
								         <path id="Vector" d="M9.00091 0C4.02898 0 0 3.10133 0 6.92915C0 9.41946 1.70716 11.6042 4.26973 12.8245C4.08187 13.5084 3.5876 15.3042 3.48911 15.6878C3.36691 16.1639 3.66785 16.1586 3.86483 16.0307C4.01986 15.9294 6.33073 14.3983 7.3284 13.7393C7.8701 13.8175 8.42821 13.8583 8.99909 13.8583C13.9692 13.8583 18 10.757 18 6.92915C18 3.10133 13.971 0 9.00091 0Z" fill="#DADADA"/>
								         </svg>
								 </a>
							 </i>
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