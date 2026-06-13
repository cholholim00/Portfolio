<%@page import="java.util.List"%>
<%@page import="cart.cartPayDAO"%>
<%@page import="cart.cartPayDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page contentType="text/html; charset=UTF-8"%>

<%
	int user_idx = 0;//Integer.parseInt(request.getParameter("user_idx"));
	//Integer user_idx = (Integer)session.getAttribute("user_idx");
	//System.out.println(user_idx);
	if(session.getAttribute("user_idx") == null){
		out.println("<script>alert('로그인 후 이용할 수 있습니다.'); history.back();</script>");
		//response.sendRedirect("../main/index.jsp");
	}else{
		user_idx = (int)session.getAttribute("user_idx");
		System.out.println("hello");
	}
	%>
	
<% 
	cartPayDAO dao = new cartPayDAO(application); 
	List<cartPayDTO> cartList = dao.selectList(user_idx); 
%>

    
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>cart</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="./cart.css">
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
                        <% if(session.getAttribute("user_idx") == null){ %>
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
    <!-- 이곳에 내용을 넣어주세요 -->
    <div class="row my_cart">
        <div class="col my_cart_left">
            <div style="font-size: 28px;">카트</div>
            <div class="row mt-4">
                <div class="col-7" style="font-size: 14px;">제품</div>
                <div class="col-2" style="font-size: 14px;">상세</div>
                <div class="col" style="font-size: 14px;">총계</div>
                <div class="col" style="font-size: 14px;">수량</div>
            </div>
            
            <hr style="width: 96%;">
            
            <!-- 5만원 이상 구매시 사은품 -->
            <div id="free-gift" style="display: none;">
	            <div class="row">
	                <div class="col-2" style="padding-right: 0;">
	                    <img src="./images/SeoulToteBag.webp" alt="" width="170px" height="200px">
	                </div>
	                <div class="col-5 mt-3" id="item0-name" style="font-size: 18px; padding: 0;">
	                    [사은품] 서울 토트백
	                </div>
	                <div class="col-2 mt-3" style="font-size: 12px;">::5만원 이상 구매 시 사은품</div>
	                <div class="col mt-3">₩<span>0</span></div>
	                <div class="col-auto mt-2" style="margin-right: 55px;">
	                    <div class="d-flex border rounded" style="height: 38px;">
	                        <button class="btn btn-sm px-2" style="width: 24px;"></button>
	                        <div class="px-3 d-flex align-items-center">1</div>
	                        <button class="btn btn-sm px-2" style="width: 24px;"></button>
	                    </div>
	                </div>
	                
	            </div>
	            <hr style="width: 96%;">
            </div>
            <!-- //카트에 담긴 상품 -->
						
						<%
							int index = 1;
							for(cartPayDTO item : cartList){
								String id = "item"+index;
						%>
            <!-- 카트에 담긴 상품 (item1) -->
            
            <div class="row">
                <div class="col-2" style="padding-right: 0;">
                    <img src="<%=item.getImg_src() %>" alt="" width="170px">
                    <% System.out.println(item.getImg_src()); %>
                </div>
                <div class="col-5 mt-3" id="<%=id %>-name" style="font-size: 18px; padding: 0;">
                    <%=item.getProduct_name() %>
                </div><% System.out.println(item.getProduct_name()); %>
                <div class="col-2 mt-3" style="font-size: 12px;">::5만원 이상 구매 시 사은품</div>
                <div class="col mt-3">₩<span id="<%=id %>-price" class="item-price"><%=item.getPrice() %></span></div>
                <div class="col-auto mt-2" style="margin-right: 55px;">
                    <div class="d-flex border rounded" style="height: 38px;">
                        <button class="btn btn-sm px-2" type="button" onclick="decreaseQuantity('<%=id %>')">-</button>
                        <div id="<%=id %>-quantity" class="px-3 d-flex align-items-center"><%=item.getQuantity() %></div>
                        <button class="btn btn-sm px-2" type="button" style="width: 26px;" onclick="increaseQuantity('<%=id %>')">+</button>
                    </div>
                </div>
                <div style="text-align: right; padding-right: 70px;">
                	<a href="./cartProc.jsp?product_idx=<%=item.getProduct_idx()%>">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash3" viewBox="0 0 16 16">
                        <path d="M6.5 1h3a.5.5 0 0 1 .5.5v1H6v-1a.5.5 0 0 1 .5-.5M11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3A1.5 1.5 0 0 0 5 1.5v1H1.5a.5.5 0 0 0 0 1h.538l.853 10.66A2 2 0 0 0 4.885 16h6.23a2 2 0 0 0 1.994-1.84l.853-10.66h.538a.5.5 0 0 0 0-1zm1.958 1-.846 10.58a1 1 0 0 1-.997.92h-6.23a1 1 0 0 1-.997-.92L3.042 3.5zm-7.487 1a.5.5 0 0 1 .528.47l.5 8.5a.5.5 0 0 1-.998.06L5 5.03a.5.5 0 0 1 .47-.53Zm5.058 0a.5.5 0 0 1 .47.53l-.5 8.5a.5.5 0 1 1-.998-.06l.5-8.5a.5.5 0 0 1 .528-.47M8 4.5a.5.5 0 0 1 .5.5v8.5a.5.5 0 0 1-1 0V5a.5.5 0 0 1 .5-.5"/>
                    </svg>
                  </a>
                </div>
            </div>
            <div id="<%=id %>-idx" style="display: none"><%=item.getProduct_idx() %></div>
            <hr style="width: 96%;">
            <!-- //카트에 담긴 상품 -->
            <% index++; } %>
            
            
            <!-- //카트에 담긴 상품 -->
             <!-- 카트에 담긴 상품은 DB에서 카트에 담은 정보를 가져와 반복문으로 나타낸다.
             또한 각 상품에는 item1과 같이 해당 item의 번호를 각각 부여해야 한다. -->
             

        </div>
        <div class="col-3 my_cart_right">
            <div class="">
                <!-- <h5 class="offcanvas-title fs-3" id="offcanvasRightLabel">카트</h5> -->
                <p class="mt-4">₩35,000 이상 주문 시 무료배송</p>
                <div class="progress" role="progressbar" aria-label="Danger example" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100">
                    <div class="progress-bar bg-info" style="width: 100%"></div>
                </div>
                <div class="mt-4 my_offcanvas_prom">
                    <p class="" style="font-size: 12px;">한정 기간 단독 프로모션</p>
                    <p style="font-size: 12px;">5만원 이상 구매 시 서울 트트백 증정 (5/19 - 소진시까지 | 콜드브루 제외 | 사은품 교환불가)</p>
                </div>
                
                <!-- 결제 정보 -->
                <div class="d-flex justify-content-between mt-4">
                    <span>합계</span>
                    <span>₩<span id="subtotal">30,000</span></span>
                </div>
                <div class="d-flex justify-content-between mt-3">
                    <span>배송비</span>
                    <span>₩0</span>
                </div>
                <hr>
                <div class="d-flex justify-content-between fw-bold mb-4">
                    <span>총 결제 금액</span>
                    <span>₩<span id="total">30,000</span></span>
                </div>
                <!-- 결제 버튼 -->
                <form id="cartForm" action="../checkouts/info.jsp?idx=<%=user_idx %>" method="post">
                		<% for(int i=1; i<index; i++){ %>
	                    <input type="hidden" id="name<%=i %>" name="name<%=i %>" value="">
	                    <input type="hidden" id="quantity<%=i %>" name="quantity<%=i %>" value="">
	                    <input type="hidden" id="price<%=i %>" name="price<%=i %>" value="">
	                    <input type="hidden" id="product<%=i %>" name="product<%=i %>" value="">
                    <% } %>
                    <input type="hidden" id="gift-name" name="gift-name" value="">
                    <input type="hidden" id="gift-quantity" name="gift-quantity" value="">
                    <input type="hidden" id="gift-price" name="gift-price" value="">
                    <input type="hidden" id="gift-idx" name="gift-idx" value="">
                    <input type="hidden" id="total-price" name="total-price" value="">
                    <input type="hidden" name="index" value="<%=index%>">
                    <input type="submit" onclick="return uploadCart()" class="btn btn-dark w-100" style="height: 50px;" value="결제">
                </form>
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
    
    <!-- 카트 수량 버튼 JS -->
    <script>
        //항목 정보 배열 (id, price, quantity)
        const cartItems = [
        	<%
        		int index2 = 1;
	        	for(cartPayDTO item : cartList){
	        		String id = "item"+index2;
	        		int price = item.getPrice();
	        		int quantity = item.getQuantity();
	        	%>
	        	{id:"<%=id%>", price:<%=price%>, quantity:<%=quantity%>}<%= (index2 < cartList.size()) ? "," : "" %>
	        	<%
	        		index2++;
		        	}
	        	%>
	        ];
        

        // 수량 증가 함수
        function increaseQuantity(id) {
            const item = cartItems.find(i => i.id === id); // 아이템 찾기
            item.quantity++;
            updateCart(); // 합계 및 가격 업데이트 
        }

        // 수량 감소 함수
        function decreaseQuantity(id) {
            const item = cartItems.find(i => i.id === id); // 아이템 찾기
            if (item.quantity > 1) {
                item.quantity--;
                updateCart(); // 합계 및 가격 업데이트
            }
        }

        // 가격 업데이트 함수
        function updateCart() {
        let subtotal = 0;

        // 모든 항목의 가격 합산
        cartItems.forEach(item => {
                subtotal += item.price * item.quantity;
                
                // 각 항목의 수량과 가격 갱신
                document.getElementById(item.id + '-quantity').textContent = item.quantity;
                document.getElementById(item.id + '-price').textContent = (item.price * item.quantity).toLocaleString();
            });

            // 합계 및 총 결제 금액 업데이트
            document.getElementById("subtotal").textContent = subtotal.toLocaleString();
            document.getElementById("total").textContent = subtotal.toLocaleString();
            updateFreeGiftVisibility();
        }

        // 페이지 로드 시 초기 가격 설정
        updateCart();

    </script>

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

		<script>
		    function uploadCart() {
		    	
		    	const index = <%= index %>;
		    	
		    	for (var i = 1; i < index; i++) {
		    		const name = document.getElementById('item'+i+'-name').textContent.trim();
		    		const quantity = document.getElementById('item'+i+'-quantity').textContent.trim();
		    		const price = document.getElementById('item'+i+'-price').textContent.trim();
		    		const product = document.getElementById('item'+i+'-idx').textContent.trim();
		    		
		    		document.getElementById('name'+i).value = name;
		    		document.getElementById('quantity'+i).value = quantity;
		    		document.getElementById('price'+i).value = price;
		    		document.getElementById('product'+i).value = product;
		    	}
		    	var total_price = document.getElementById('total').textContent.trim();
		    	total_price = total_price.replace(',','');
		    	document.getElementById('total-price').value = total_price;
		    	if(total_price == 0){
		    		alert('상품을 먼저 담아주세요');
		    		return false;
		    	}
		    	
		    	
		    	if(total_price >= 50000){
		    		document.getElementById('gift-name').value = "[사은품] 서울 토트백";
		    		document.getElementById('gift-quantity').value = 1;
		    		document.getElementById('gift-price').value = 0;
		    		document.getElementById('gift-idx').value = "5-001";
		    	}
		    	//document.getElementById('cartForm').submit();
		    	return true;
		    }
		</script>

		<script>
	    function updateFreeGiftVisibility() {
	        // 총합 가져오기 (예: ₩50,000 → 숫자만 추출)
	        const totalText = document.getElementById('total').innerText.replace(/[^\d]/g, '');
	        const total = parseInt(totalText, 10);
	
	        const freeGiftDiv = document.getElementById('free-gift');
	
	        if (total >= 50000) {
	            freeGiftDiv.style.display = 'block';
	        } else {
	            freeGiftDiv.style.display = 'none';
	        }
	    }
	
	    // 예: 장바구니 수량, 금액 변경 시 호출되도록
	    updateFreeGiftVisibility(); // 최초 1회 실행
	
	    // 필요하다면 합계가 바뀔 때마다 이 함수 다시 호출
		</script>
		










    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
  </body>
</html>