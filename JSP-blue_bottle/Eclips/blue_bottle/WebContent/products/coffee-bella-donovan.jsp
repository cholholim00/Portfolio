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
    <title>벨라 도노반 - BLUE BOTTLE COFFEE KOREA</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="./products.css">
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

    <!-- 제품 수량 및 카트 추가 -->
    <div class="row mt-0 my_product">
        <div class="col" style="margin-left: 6%; margin-right: 5%; margin-bottom: 15%;">
            <img src="./images/D1_bella_1600.webp" alt="" class="" style="width: 720px; height: 700px;">
        </div>
        <div class="col" style="padding-top: 9%;">
            <p class="fs-3 fw-medium mb-4">벨라 도노반</p>
            <p class="mb-3" style="font-size: 13px; line-height: 25px;">
            	벨라 도노반은 마치 캐시미어 스웨터를 입는 것 같은<br>
            	블렌드로 편안하고 포근하게 입안을 감싸줍니다.<br>
            	에티오피아 내추럴 커피가 가진 농밀하고 잼같은 베리의<br>
            	향은 진한 초콜릿 베이스 위에 과일 향을 더해줍니다.
            </p>
            <p class="mb-3" style="font-size: 13px; line-height: 25px;">
            	섬세한 맛을 끌어내기 위해 세 가지 원두를 네 가지<br>
            	방식으로 로스팅합니다. 그 결과 복합적이면서 편안함을<br>
            	아우르며 흔치 않은 평온함을 선사하는 블루보틀만의<br>
            	블렌드가 탄생했습니다.
            </p>
            <p class="mb-5" style="font-size: 13px;">상품은 평균 1~3 영업일 내에 출고 됩니다.</p>

            <!-- form 태그 -->
            <!-- user_idx (GET method) -->
            <form action="./insertCart.jsp?idx=<%=user_idx %>" method="post" onsubmit="checkLoginAndSubmit(); updatePrices();">
                <!-- option -->
                <select class="form-select mb-3" aria-label="Default select example" style="width: 57%; height: 48px;" name="option">
                    <option value="250g">250g</option>
                    <option value="100g">100g</option>
                </select>

                <div class="d-flex align-items-center gap-2 mb-3">
                    <!-- <div class="quantity-control d-flex align-items-center border p-2 my_quantity" style="width: 20%; justify-content: space-between;">
                        <button class="btn btn-sm" onclick="decrease()">-</button>
                        <span id="quantity" class="px-3">1</span>
                        <button class="btn btn-sm" onclick="increase()">+</button>
                    </div> -->
                    <!-- 카트에 추가 버튼 -->
                    <button class="btn btn-dark" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRight" aria-controls="offcanvasRight" style="width: 57%; height: 48px;">카트에 추가 | \22,500</button>
                    <!-- 버튼 클릭 시 offcanvas -->
                    <div class="offcanvas offcanvas-end my_offcanvas" tabindex="-1" id="offcanvasRight" style="width: 620px;">
                        <div class="offcanvas-header" style="padding-left: 10%;">
                            
                            <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
                        </div>
                        <div class="offcanvas-body">
                            <h5 class="offcanvas-title fs-3" id="offcanvasRightLabel">카트</h5>
                            <p class="mt-4">무료배송입니다.</p>
                            <div class="progress" role="progressbar" aria-label="Danger example" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100">
                                <div class="progress-bar bg-info" style="width: 100%"></div>
                            </div>
                            <div class="mt-4 my_offcanvas_prom">
                                <p class="" style="font-size: 12px;">한정 기간 단독 프로모션</p>
                                <p style="font-size: 12px;">5만원 이상 구매 시 서울 트트백 증정 (5/19 - 소진시까지 | 콜드브루 제외 | 사은품 교환불가)</p>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between align-items-center mb-3" style="background-color: #faf6ee;">
                                <div>
                                    <span class="mb-1 me-5 fw-bold">벨라 도노반</span>
                                    <span class="text-muted mt-1 ms-4">₩<span id="unit-price">22,500</span></span>
                                </div>
                                <div class="d-flex border rounded" style="height: 38px;">
                                    <button class="btn btn-sm px-2" type="button" onclick="decrease_acc()">-</button>
                                        <div id="quantity_acc" class="px-3 d-flex align-items-center">1</div>
                                        <!-- quantity -->
                                        <input type="hidden" id="total-quantity" name="quantity" value="">
                                    <button class="btn btn-sm px-2" type="button" onclick="increase_acc()">+</button>
                                </div>
                            </div>
                            <hr>
                            <!-- 결제 정보 -->
                            <div class="d-flex justify-content-between mt-4">
                                <span>예상 총액</span>
                                <span>₩<span id="subtotal">22,500</span></span>
                            </div>
                            <div class="d-flex justify-content-between">
                                <span>배송비</span>
                                <span>₩0</span>
                            </div>
                            <div class="d-flex justify-content-between fw-bold mb-4">
                                <span>총 결제 금액</span>
                                <span>₩<span id="total">22,500</span></span>
                                <!-- price -->
                                <input type="hidden" id="total-input" name="price" value="">
                            </div>
                            <!-- 결제 버튼 -->
                            <!-- name -->
                            <input type="hidden" name="name" value="벨라 도노반" />	
                            <!-- product_idx -->
                            <input type="hidden" name="product_idx" value="1-002">
                            <input type="hidden" name="img_src" value="../products/images/D1_bella_1600.webp" />
                            <input type="submit" class="btn btn-dark w-100" style="height: 50px;" value="담기">
                        </div>
                    </div>

                </div>
            </form>
        </div>
    </div>

    <!-- 블렌드 스토리 -->
    <div class="row" style="margin-top: 12%; margin-bottom: 11%;">
        <div class="col" style="margin-left: 8%; margin-right: 5%; margin-top: 2%;">
            <p class="fw-medium" style="text-align: center;">풍미 프로필</p>
            <p class="fs-3 fw-medium mb-4" style="text-align: center;">라즈베리, 초콜릿, 당밀</p>
            <br><br>
            <p class="mb-5" style="line-height: 30px; text-align: center; font-weight: 700;">
               	 풍미
            </p>
            <div class="row d-flex justify-content-center align-items-center" style="text-align: center;">
						    <div class="col-auto" style="font-size: 12px; font-weight: bold;">플로럴/프루티</div>
						    <div class="col-6">
						        <div class="progress" role="progressbar" aria-label="Example with label" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100">
						            <div class="progress-bar" style="width: 30%">30%</div>
						        </div>
						    </div>
						    <div class="col-auto" style="font-size: 12px; font-weight: bold;">다크 초콜릿</div>
						</div>
						<br><br><br>
            <p class="mb-5" style="line-height: 30px; text-align: center; font-weight: 700;">
               	 로스팅
            </p>
            
            <div class="row d-flex justify-content-center align-items-center" style="text-align: center;">
						    <div class="col-auto" style="font-size: 12px; font-weight: bold;">라이트</div>
						    <div class="col-6">
						        <div class="progress" role="progressbar" aria-label="Example with label" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100">
						            <div class="progress-bar" style="width: 70%">70%</div>
						        </div>
						    </div>
						    <div class="col-auto" style="font-size: 12px; font-weight: bold;">다크</div>
						</div>
        </div>
        <div class="col" style="margin-left: 0; margin-right: 8%; margin-top: 7%">
            <img src="./images/1522625544-258de2fe067a76e60cc93f1c4a00d5a67bdecfdd1c64d810946c5999c54dc6ec-d.avif" alt="" class="" style="width: 580px; height: 300px;">
        </div>
    </div>

    <!-- 로스팅 프로필 -->
    <div class="row">
        <div class="col" style="margin-left: 8%; margin-right: 5%; margin-bottom: 0;">
            <img src="./images/D2_PC_ALL_1200x1200_1d5d366a-e55d-4b0e-bc52-0a3b2b839a4f.webp" alt="" class="" style="width: 580px; height: 550px;">
        </div>
        <div class="col" style="padding-top: 4%;">
            <p class="fw-medium">블랜드 스토리</p>
            <p class="fs-3 fw-medium mb-4">벨라 도노반</p>
            <p class="mb-5" style="line-height: 30px;">
                	이 명작은 최초의 블렌드인 모카 자바 조합에서 영감을<br>
                	얻었습니다. 본래 모카자바는 모카 항구를 통해 와인의 향미를<br>
                	가진 예멘산 내추럴 커피와 대지의 풍미를 담은 자바에서 온<br>
                	워시드 커피를 블렌딩하여 탄생했습니다.
            </p>
            <p class="mb-5" style="line-height: 30px;">
                	이 블렌드는 에티오피아 내추럴 커피를 사용하여 과일 향을<br>
                	강조합니다. 단맛과 바디감을 끌어올리기 위해 비교적 다크<br>
                	로스트에 가깝게 로스팅된 벨라 도노반은 커피메이커와 같은<br>
                	비교적 정교하지 않은 추출에도 향미를 잘 표현하며, 우유나<br>
                	크림과 곁들여 마시면 더욱 풍성한 맛을 선사합니다.
            </p>
        </div>
    </div>
    
    <!-- 블렌드 스토리 -->
    <div class="row" style="margin-top: 12%; margin-bottom: 11%;">
        <div class="col" style="margin-left: 8%; margin-right: 5%; margin-top: 3%;">
            <p class="fw-medium">테이스팅 노트</p>
            <p class="fs-3 fw-medium mb-4">당신의 커피 취향을 찾아보세요</p>
            <p class="mb-5" style="line-height: 30px;">
               	 블루보틀은 커피 플레이버를 설명할 때, 단순한 맛 이상의<br>
               	 감각적 경험을 전달하고자 노력합니다. 테이스팅 노트는<br>
               	 커피의 당도, 산도, 바디감, 여운, 향미 등 다섯 가지 요소를<br>
               	 중심으로 구성되며, 이를 통해 각 커피의 독특한 특성을<br>
               	 표현하고 이해하는데 사용됩니다.
            </p>
            <p class="mb-5" style="line-height: 30px;">
                	블루보틀의 다섯 가지 시그니처 블렌드를 로스팅 레벨과<br>
                	플레이버로 나누어 한눈에 정리했습니다. 차트를 참고해<br>
                	나만의 취향을 찾아보세요.
            </p>
        </div>
        <div class="col" style="margin-left: 0; margin-right: 8%;">
            <img src="./images/WB_tasting_infographic_051325_PC.png" alt="" class="" style="width: 580px; height: 550px;">
        </div>
    </div>



    <!-- footer 영역 -->
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
    
    <!-- 네비게이션 바 사라지는 JS -->
    <script>
        let prevScrollpos = window.pageYOffset; // 이전 스크롤 위치 저장

        window.onscroll = function() {
            let currentScrollPos = window.pageYOffset; // 현재 스크롤 위치

            // 스크롤이 위로 올라가면 네비게이션 바 보이게
            if (prevScrollpos > currentScrollPos) {
            document.querySelector('.custom-navbar').classList.remove('hidden');
            document.querySelector('.custom-navbar').classList.add('scrolled');
            } 
            // 스크롤이 아래로 내려가면 네비게이션 바 숨기기
            else {
            document.querySelector('.custom-navbar').classList.add('hidden');
            document.querySelector('.custom-navbar').classList.remove('scrolled');
            }

            prevScrollpos = currentScrollPos; // 이전 스크롤 위치 갱신
        }
    </script>
    
    <!-- 세션 체크 -->
    <script>
			const user_id = "<%= user_id == null ? "" : user_id %>";
    
	    // 폼 제출 시 세션 상태 체크
	    function checkLoginAndSubmit() {
	        if (!user_id) {
	            alert("로그인 후 이용 가능합니다.");
	            event.preventDefault(); // 폼 제출 방지
	        }
	    }
    </script>

    <!-- 카트 수량 버튼 JS -->
    <script>
        let quantity_acc = 1;
        const unitPrice = 22500;

        function updatePrices() {
            document.getElementById("quantity_acc").innerText = quantity_acc;
            const quantity = quantity_acc;
            const subtotal = unitPrice * quantity_acc;
            document.getElementById("subtotal").innerText = subtotal.toLocaleString();
            document.getElementById("total").innerText = subtotal.toLocaleString();
            document.getElementById("unit-price").innerText = subtotal.toLocaleString();

            updateTotal(subtotal, quantity);
        }

        function increase_acc() {
            quantity_acc++;
            updatePrices();
        }

        function decrease_acc() {
            if (quantity_acc > 1) {
            quantity_acc--;
            updatePrices();
            }
        }

        // 초기화
        updatePrices();
    </script>

    <script>
        // 페이지 로드 시 또는 결제 정보가 업데이트될 때
        function updateTotal(subtotal, quantity) {
            //const totalAmount = document.getElementById('total').textContent.replace('₩', '').replace(',', ''); // 금액에서 ₩과 콤마 제거
            //const totalInput = document.getElementById('total-input');
            document.getElementById('total-input').value = subtotal;
            document.getElementById('total-quantity').value = quantity;
            
            //totalInput.value = totalAmount; // total 금액을 hidden input의 value에 설정
        }

        // 예시: 수량이나 합계가 업데이트될 때마다 호출
        updateTotal();
    </script>



    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
  </body>
</html>