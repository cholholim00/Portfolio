<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% 
	String userName = (String)session.getAttribute("user_name");
  Integer user_idx = (Integer) session.getAttribute("user_idx");
	//int user_idx = (int)session.getAttribute("user_idx");
	String user_id = (String)session.getAttribute("user_id");
	String phone = (String)session.getAttribute("phone");
%>

<%
	request.setCharacterEncoding("UTF-8");
	
	
	String name = request.getParameter("user_name");
	String post_num = request.getParameter("post_num");
	String addr = request.getParameter("addr");
	System.out.println("\n\n[info3.jsp]\nname:"+name+"\npost_num:"+post_num+"\naddr:"+addr+"\nphone:"+phone+"\n");
	/////////////////////////////////////////////////////////////
	int index = Integer.parseInt(request.getParameter("index"));
  int total_price = Integer.parseInt(request.getParameter("total-price"));
  int vat = (int)(total_price * 0.1);
  
  String gift_name = request.getParameter("gift-name");
  String gift_quantity = request.getParameter("gift-quantity");
  String gift_price = request.getParameter("gift-price");
  String gift_idx = request.getParameter("gift-idx");
  
  String[] names = new String[index];
  String[] quantities = new String[index];
  String[] prices = new String[index];
  String[] products = new String[index];

  // hidden input 값 받기
	 for (int i = 1; i < index; i++) {
	     names[i] = request.getParameter("name" + i);
	     quantities[i] = request.getParameter("quantity" + i);
	     prices[i] = request.getParameter("price" + i);
	     products[i] = request.getParameter("product" + i);
	 }

  // 확인을 위한 출력
  for (int i = 1; i < index; i++) {
      System.out.println("name: " + names[i] + ", quantity: " + quantities[i] + ", price: " + prices[i] + ", product_idx: " + products[i]);
  }
  if(!gift_name.isEmpty()){
	  	System.out.println("gift_name: "+gift_name+", gift_quantity: "+gift_quantity+", gift_price: "+gift_price + ", gift_idx: " + gift_idx);
	  }
	System.out.println("total_price: "+total_price+", index: "+index+"\n\n");
%>
    
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>info3</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="./checkouts.css">
</head>
<body>
    <div class="row">
        <div class="col my_right">
            <img src="./images/b_bottle.png" alt="" width="200px">
            <div class="mt-3" style="font-size: 12px;">
                <span>카트</span> > <span>정보</span> > <span>배송</span> > <span class="fw-bold">지급</span>
            </div>

            <!-- 사용자 정보 -->
            <div class="mt-5">
                
            </div>

            <!-- 메인 입력창 -->
            <div class="mt-5">
                <div class="card" style="width: 100%; padding: 20px; font-size: 14px;">
                    <div class="row">
                        <div class="col-2" style="color: rgb(102, 102, 102);">이름</div>
                        <div class="col">
                            <%=name %>
                        </div>
                    </div>
                    <hr>
                    <div class="row">
                        <div class="col-2" style="color: rgb(102, 102, 102);">배송 도착지</div>
                        <div class="col">
                            <%=addr %>
                        </div>
                    </div>
                    <hr>
                    <div class="row">
                        <div class="col-2" style="color: rgb(102, 102, 102);">연락처</div>
                        <div class="col">
                            <%=phone %>
                        </div>
                    </div>
                    <hr>
                    <div class="row">
                        <div class="col-2" style="color: rgb(102, 102, 102);">배송방법</div>
                        <div class="col">
                            CJ대한통운 · ₩<span>0</span>
                        </div>
                    </div>
                </div>
                <div class="mt-5">
                    <p class="fw-bold" style="font-size: 18px;">지급</p>
                    <p>모든 거래는 안전하게 암호화되어 있습니다.</p>
                    <div class="card" style="width: 100%;">
                        <div class="card-header my_card_header d-flex justify-content-between align-items-center">
                            <span>KG Inicis (New)</span>
                            <div>
                                <button class="btn btn-primary btn-sm" type="button" data-bs-toggle="collapse"
                                data-bs-target="#collapseWidthExample" aria-expanded="false"
                                aria-controls="collapseWidthExample" style="width: 80px; height: 35px;">
                                    Payment
                                </button>
                                <div style="min-height: 0;">
                                    <div class="collapse collapse-horizontal mt-2" id="collapseWidthExample">
                                        <div class="card card-body" style="width: 300px;">
                                            <div class="d-flex flex-wrap gap-3">
                                                <img src="./images/samsung_card.svg" width="40px">
                                                <img src="./images/bc_card.svg" width="40px">
                                                <img src="./images/hana_card.svg" width="40px">
                                                <img src="./images/hyundai_card.svg" width="40px">
                                                <img src="./images/kakao_pay.svg" width="40px">
                                                <img src="./images/kb_card.svg" width="40px">
                                                <img src="./images/lotte_card.svg" width="40px">
                                                <img src="./images/naver_pay.svg" width="40px">
                                                <img src="./images/nh_card.svg" width="40px">
                                                <img src="./images/payco.svg" width="40px">
                                                <img src="./images/samsung_card.svg" width="40px">
                                                <img src="./images/samsung_pay.svg" width="40px">
                                                <img src="./images/shinhan.svg" width="40px">
                                                <img src="./images/toss.svg" width="40px">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item text-center" style="padding: 20px; background-color: rgb(245, 245, 245);">
                                <img src="./images/card.png" alt="" width="150px">
                                <p class="mt-3 fw-bold" style="font-size: 14px;">
                                    "지금 결제"를 클릭한 후, 주문을 안전하게 완료하기 위해 KG<br>
                                    Inicis (New)로 다시 연결됩니다.
                                </p>
                            </li>
                        </ul>
                    </div>
                </div>

                    <!-- 버튼 -->
                    <div class="d-flex mt-4 mb-4">
                        <span class="mt-4"><a href="#" style="text-decoration: none;">< 배송으로 돌아가기</a></span>
                        <!-- <button type="submit" class="btn btn-primary ms-auto" style="height: 70px; width: 150px;">지금 결제</button> -->
                        <a href="#" class="btn btn-primary d-flex justify-content-center align-items-center ms-auto" data-bs-toggle="modal" data-bs-target="#pay" style="height: 60px; width: 150px;">지금 결제</a>
                        <!-- Modal 1 -->
                        <form action="infoProc.jsp?idx=<%=user_idx %>" method="post">
                        
                        <div class="modal fade" id="pay" tabindex="-1" aria-labelledby="payLabel" aria-hidden="true">
                            <div class="modal-dialog modal-xl">
                                <div class="modal-content">
                                    <!-- <div class="modal-header">
                                        <h1 class="modal-title fs-5 fw-bold" id="payLabel">신용카드 결제</h1>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div> -->
                                    <div class="modal-body my_modal_boby">
                                        <div class="row">
                                            <div class="col-2 fw-bold" style="background-color: rgb(248, 248, 248); padding-top: 40px; text-align: center;">신용카드</div>
                                            
                                            <div class="col" style="padding: 40px;">
                                                <p>KG 이니시스</p>
                                                <hr>
                                                <!-- form 태그 -->
                                              
		                                                <div class="row">
		                                                    <div class="col">이용약관</div>
		                                                    <div class="col-3">
		                                                        <div class="form-check">
		                                                            <input class="form-check-input" type="checkbox" value="" id="checkAll">
		                                                            <label class="form-check-label" for="checkDefault1">
		                                                                	전체동의
		                                                            </label>
		                                                        </div>
		                                                    </div>
		                                                </div>
		                                                <hr>
		                                                <div class="row">
		                                                    <div class="col">전자금용거래 이용약관</div>
		                                                    <div class="col-3">
		                                                        <div class="form-check">
		                                                            <input class="form-check-input" type="checkbox" value="" id="checkDefault2">
		                                                            <label class="form-check-label" for="checkDefault2">
		                                                                	동의
		                                                            </label>
		                                                        </div>
		                                                    </div>
		                                                </div>
		                                                <div class="row">
		                                                    <div class="col">개인정보의 수집 및 이용안내</div>
		                                                    <div class="col-3">
		                                                        <div class="form-check">
		                                                            <input class="form-check-input" type="checkbox" value="" id="checkDefault3">
		                                                            <label class="form-check-label" for="checkDefault3">
		                                                                	동의
		                                                            </label>
		                                                        </div>
		                                                    </div>
		                                                </div>
		                                                <div class="row">
		                                                    <div class="col">개인정보 제공 및 위탁안내</div>
		                                                    <div class="col-3">
		                                                        <div class="form-check">
		                                                            <input class="form-check-input" type="checkbox" value="" id="checkDefault4">
		                                                            <label class="form-check-label" for="checkDefault4">
		                                                                	동의
		                                                            </label>
		                                                        </div>
		                                                    </div>
		                                                </div>
		                                                <hr>
		                                                
                                                    <div class="row mb-1">
                                                        <div class="col-2 d-flex align-items-center" style="height: 38px;">카드사</div>
                                                        <div class="col">
                                                            <div class="d-flex gap-2 align-items-center">
                                                                <select class="form-select mb-3" aria-label="Default select example" name="card" style="width: 228px;">
                                                                    <option value="bc_card">BC카드</option>
                                                                    <option value="hana_card">하나카드</option>
                                                                    <option value="hyundai_card">현대카드</option>
                                                                    <option value="kb_card">국민카드</option>
                                                                    <option value="lotte_card">롯데카드</option>
                                                                    <option value="payco">페이코</option>
                                                                    <option value="samsung_card">삼성카드</option>
                                                                    <option value="shinhan_card">신한카드</option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row mb-3">
                                                        <div class="col-2 d-flex align-items-center" style="height: 38px;">카드번호</div>
                                                        <div class="col">
                                                            <div class="d-flex gap-2 align-items-center">
                                                                <input type="text" id="cardNum1" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'); checklength();" maxlength="4" class="form-control" name="cardNum1" style="width: 100px;">-
                                                                <input type="text" id="cardNum2" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'); checklength();" maxlength="4" class="form-control" name="cardNum2" style="width: 100px;">-
                                                                <input type="text" id="cardNum3" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'); checklength();" maxlength="4" class="form-control" name="cardNum3" style="width: 100px;">-
                                                                <input type="text" id="cardNum4" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'); checklength();" maxlength="4" class="form-control" name="cardNum4" style="width: 100px;">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-2 d-flex align-items-center" style="height: 38px;">유효기간</div>
                                                        <div class="col d-flex gap-2">
                                                            <select class="form-select mb-3" aria-label="Default select example" name="expirationMonth" style="width: 228px;">
                                                                <option value="1">01월</option>
                                                                <option value="2">02월</option>
                                                                <option value="3">03월</option>
                                                                <option value="4">04월</option>
                                                                <option value="5">05월</option>
                                                                <option value="6">06월</option>
                                                                <option value="7">07월</option>
                                                                <option value="8">08월</option>
                                                                <option value="9">09월</option>
                                                                <option value="10">10월</option>
                                                                <option value="11">11월</option>
                                                                <option value="12">12월</option>
                                                            </select>
                                                            <select class="form-select mb-3" aria-label="Default select example" name="expirationYear" style="width: 228px;">
                                                                <option value="2025">2025년</option>
                                                                <option value="2026">2026년</option>
                                                                <option value="2027">2027년</option>
                                                                <option value="2028">2028년</option>
                                                                <option value="2029">2029년</option>
                                                                <option value="2030">2030년</option>
                                                                <option value="2031">2031년</option>
                                                                <option value="2032">2032년</option>
                                                                <option value="2033">2033년</option>
                                                                <option value="2034">2034년</option>
                                                                <option value="2035">2035년</option>
                                                                <option value="2036">2036년</option>
                                                                <option value="2037">2037년</option>
                                                                <option value="2038">2038년</option>
                                                                <option value="2039">2039년</option>
                                                                <option value="2040">2040년</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="row mb-3">
                                                        <div class="col-2 d-flex align-items-center" style="height: 38px;">본인확인</div>
                                                        <div class="col d-flex gap-2">
                                                            <input type="text" id="birthInput" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'); checklength();" maxlength="6" class="form-control" name="birth" style="width: 230px;">
                                                            <span class="d-flex align-items-center" style="height: 38px; font-size: 12px;">* 개인카드:생년월일 6자리</span>
                                                        </div>
                                                    </div>
                                                    <div class="row mb-3">
                                                        <div class="col-2 d-flex align-items-center" style="height: 38px;">비밀번호</div>
                                                        <div class="col">
                                                            <div class="col d-flex gap-2">
                                                                <input type="password" id="pwInput" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'); checklength();" maxlength="2" class="form-control" name="cardPass" style="width: 230px;">
                                                                <span class="d-flex align-items-center" style="height: 38px; font-size: 12px;">* 비밀번호 앞자리 2자리</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-2 d-flex align-items-center" style="height: 38px;">할부개월</div>
	                                                        <div class="col">
	                                                            <div class="col d-flex gap-2">
	                                                                <select class="form-select mb-3" aria-label="Default select example" name="installment" style="width: 230px;">
	                                                                    <option value="일시불">일시불</option>
	                                                                    <option value="2개월">2개월</option>
	                                                                    <option value="3개월">3개월</option>
	                                                                    <option value="4개월">4개월</option>
	                                                                    <option value="5개월">5개월</option>
	                                                                    <option value="6개월">6개월</option>
	                                                                    <option value="7개월">7개월</option>
	                                                                    <option value="8개월">8개월</option>
	                                                                    <option value="9개월">9개월</option>
	                                                                    <option value="10개월">10개월</option>
	                                                                    <option value="11개월">11개월</option>
	                                                                    <option value="12개월">12개월</option>
	                                                                </select>
	                                                                <span class="d-flex align-items-center" style="height: 38px; font-size: 12px;">* 5만원 이상 가능</span>
	                                                            </div>
	                                                        </div>
                                                    		</div>
                                                    </div>
                                                    <div class="col-3 d-flex flex-column" style="background-color: rgb(248, 248, 248); padding-top: 40px;">
                                                        <p style="font-size: 20px; margin: 0;">KG 이니시스</p>
                                                        <hr>
                                                        <div class="row">
                                                            <div class="col-8">상품가격</div>
                                                            <div class="col"><span><%=total_price+vat %></span>원</div>
                                                        </div>
                                                        <hr>
                                                        <div class="row" style="font-weight: bold;">
                                                            <div class="col-8">결제금액</div>
                                                            <div class="col"><span><%=total_price+vat %></span>원</div>
                                                        </div>
                                                        <hr>
                                                        <div class="mt-auto">
                                                            <input type="reset" value="초기화" class="btn btn-primary d-flex justify-content-center align-items-center mb-2" data-bs-toggle="modal" data-bs-target="#pay" style="height: 50px; width: 100%;">
                                                            
                                                            <% for(int i=1; i<index; i++){ %>
																					                    <input type="hidden" id="name<%=i %>" name="name<%=i %>" value="<%=names[i]%>">
																					                    <input type="hidden" id="quantity<%=i %>" name="quantity<%=i %>" value="<%=quantities[i]%>">
																					                    <input type="hidden" id="price<%=i %>" name="price<%=i %>" value="<%=prices[i]%>">
																					                    <input type="hidden" id="product<%=i %>" name="product<%=i %>" value="<%=products[i]%>">
																				                    <% } %>
																						                <input type="hidden" id="gift-name" name="gift-name" value="<%=gift_name%>">
																				                    <input type="hidden" id="gift-quantity" name="gift-quantity" value="<%=gift_quantity%>">
																				                    <input type="hidden" id="gift-price" name="gift-price" value="<%=gift_price%>">
																				                    <input type="hidden" id="gift-idx" name="gift-idx" value="<%=gift_idx%>">
																				                    <input type="hidden" id="total-price" name="total-price" value="<%=total_price+vat%>">
																				                    <input type="hidden" name="index" value="<%=index%>">
																				                    
																				                    <input type="hidden" name="user_name" value="<%=name%>">
																				                    <input type="hidden" name="post_num" value="<%=post_num%>">
																				                    <input type="hidden" name="addr" value="<%=addr%>">
																				                    <input type="hidden" name="phone" value="<%=phone%>">
                                                            
                                                            <input type="submit" value="결제" disabled id="submitBtn" class="btn btn-primary d-flex justify-content-center align-items-center mb-3" data-bs-toggle="modal" data-bs-target="#pay" style="height: 50px; width: 100%;">
                                                        </div>
                                                    </div>
                                               		
                                        </div>
                                        
                                    </div>
                                    
                                </div>
                                
                            </div>
                            
                        </div>
                        
                        </form>
                        <!-- /Modal 1 -->
                    </div>

                <!-- footer -->
                <hr style="margin-top: 44%;">
                <div class="mb-4">
                    <a href="#" class="me-3" data-bs-toggle="modal" data-bs-target="#modal1" style="font-size: 14px;">환불정책</a>
                    <a href="#" class="me-3" data-bs-toggle="modal" data-bs-target="#modal2" style="font-size: 14px;">개인정보 처리방침</a>
                    <a href="#" data-bs-toggle="modal" data-bs-target="#modal3" style="font-size: 14px;">판매이용약관</a>

                    <!-- Modal 1 -->
                    <div class="modal fade" id="modal1" tabindex="-1" aria-labelledby="modal1Label" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h1 class="modal-title fs-5 fw-bold" id="modal1Label">환불정책</h1>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body" style="font-size: 14px;">
                                    <p>
                                        교환 및 환불은 배송완료일 (제품을 수령하신 날) 로부터 7일 이내 신청 가능합니다. 배송완료일로부터 7일 이후에는 구매가 확정되어 신청이 불가합니다.
                                    </p>
                                    <p>
                                        단, 아래와 같은 사유로 인할 시에는 예외로 처리됩니다.
                                    </p>

                                    <ul>
                                        <li>
                                            수령 받은 제품이 표시/광고의 내용과 다르거나, 계약내용과 다르게 이행된 경우
                                        </li>
                                        <li>
                                            제품 수령일로부터 3개월 이내 또는 그 사실을 알 수 있었던 날로부터 30일 이내
                                        </li>
                                        <li>
                                            원두의 경우 재판매가 불가한 상품의 특성으로 단순 변심 및 주문 착오 등으로 인한 교환 환불 불가
                                        </li>
                                    </ul>
                                    
                                    <h6 class="fw-bold">반품 관련</h6>
                                    <p>
                                        단순 변심으로 인한 반품의 경우, 배송비를 이미 지불하신 경우 반품 배송비 (일반 3,000원/ 제주도 및 산간지역 별도) 만을 추가로 청구합니다 .
                                    </p>
                                    <p>
                                        무료 배송으로 제품을 받으신 경우에는 왕복 배송비가 차감됩니다. 상품에 대한 하자 등으로 반품이 진행되는 경우에는 블루보틀이 배송비를 부담합니다.
                                    </p>

                                    <h6 class="fw-bold">교환 관련</h6>
                                    <p>
                                        단순 변심으로 인한 교환의 경우, 배송비를 이미 지불하신 경우 교환 반송 배송비 (일반 3,000원/ 제주도 및 산간지역 별도) 만을 추가로 청구합니다. 무료 배송으로 제품을 받으신 경우에는 왕복 배송비가 차감됩니다.
                                    </p>
                                    <p>
                                        상품에 대한 하자 등으로 교환이 진행되는 경우에는 블루보틀이 배송비를 부담합니다.
                                    </p>

                                    <p>
                                        반품이 불가한 경우는 다음과 같습니다.
                                    </p>
                                    <ol>
                                        <li>반품/교환기간을 초과한 경우</li>
                                        <li>온라인 주문이력 확인이 불가능한 경우</li>
                                        <li>택 또는 패키지가 훼손된 경우</li>
                                        <li>상품을 사용한 경우 또는 상품이 변화되었거나 오염되었을 경우</li>
                                        <li>고객님의 책임으로 인한 제품 등의 가치가 심하게 파손되거나 훼손된 경우</li>
                                        <li>기타 '전자상거래 등에서의 소비자보호에 관한 법률'이 정하는 청약철회 제한 사유에 해당하는 경우</li>
                                    </ol>
                                    <p>
                                        반품 및 환불 정책에 대한 추가적인 문의 사항은 <a href="#" style="text-decoration: none;">자주 묻는 질문 (FAQ)</a>을 확인해주시기 바랍니다.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Modal 2 -->
                    <div class="modal fade" id="modal2" tabindex="-1" aria-labelledby="modal2Label" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h1 class="modal-title fs-5" id="modal2Label">개인정보 처리방침</h1>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body" style="font-size: 14px;">
                                    <p>
                                        블루보틀커피코리아 유한회사(이하 “블루보틀”)는 귀하가 블루보틀 브랜드 홈페이지를 운용함에 있어 이용자가 제공한 개인정보가 보호받을 수 있도록 최선을 다하고 있습니다. 블루보틀은 개인정보 보호법, 통신비밀보호법, 전기통신사업법, 정보통신망 이용촉진 등에 관한 법률 등 정보통신서비스제공자가 준수하여야 할 관련 법규상의 개인정보보호 규정 및 방송통신위원회, 과학기술정보통신부 및 행정안전부 등 대한민국 정부가 제정한 개인정보보호지침들을 준수하며, 개인정보처리방침을 통하여 이용자들이 제공하는 개인정보가 어떠한 용도와 방식으로 이용되고 있으며 개인정보보호를 위해 어떠한 조치가 취해지고 있는지 알려드립니다. 블루보틀의 개인정보 처리방침은 홈페이지 첫 화면에 공개되며 이용자들은 언제나 용이하게 보실 수 있습니다.
                                    </p>
                                    <p>
                                        블루보틀의 개인정보 처리방침은 법률 및 지침 변경이나 블루보틀 내부 방침 변경 등으로 인하여 변경될 수 있으며, 개인정보 취급방침이 변경되는 경우 그 변경사항에 대하여 즉시 브랜드 홈페이지를 통하여 게시하고 개정일자를 부여하여 개정된 사항을 이용자들이 쉽게 알아볼 수 있도록 하고 있습니다.
                                    </p>
                                    <p>
                                        블루보틀의 개인정보처리방침은 다음과 같은 내용을 담고 있습니다.
                                    </p>

                                    <ol>
                                        <li>수집하는 개인정보 항목 및 수집방법</li>
                                        <li>개인정보의 수집 및 이용목적</li>
                                        <li>수집한 개인정보의 보유 및 이용기간</li>
                                        <li>개인정보의 파기절차</li>
                                        <li>개인정보 처리 위탁</li>
                                        <li>이용자 및 법정대리인의 권리와 그 행사방법</li>
                                        <li>개인정보 보호 대책</li>
                                        <li>개인정보 자동 수집 장치 운영 및 거부에 관한 사항</li>
                                        <li>행태정보의 수집이〮용 및 거부 등에 관한 사항</li>
                                        <li>개인정보의 제3자 제공</li>
                                        <li>개인정보의 국외 이전</li>
                                        <li>개인정보 관리책임자 및 관련 부서</li>
                                        <li>정책변경에 따른 공지의무</li>
                                    </ol>
                                    <ol>
                                        <li>수집하는 개인정보 항목 및 수집방법</li>
                                        <p>
                                            블루보틀은 이용자들의 회원가입, 상담, 그리고 각종 서비스의 제공을 위해 아래와 같은 개인정보를 수집하고 있습니다.
                                        </p>
                                        <p>
                                            1.1 수집항목<br>
                                            1)필수 수집 항목<br>
                                            (1) 계정 등록 시 <br>
                                            - 성명<br>
                                            - 전자우편 주소<br>
                                            - 전화번호 (휴대전화 번호)<br>
                                            (2) 제품 주문 시<br>
                                            - 수취인의 이름, 전화번호, 우편주소(배송지/청구지), 전자우편 주소<br>
                                            - 대금 지불 방법, 신용/직불카드 결제 시 카드명, 카드번호, 카드소지자명, 유효기간, 비밀번호 앞 2자리, 생년월일 8자리 또는 사업자 등록번호, 계좌이체 시 은행명, 계좌 번호<br>
                                            2) 선택 수집 항목<br>
                                            (1) 상품 관련 정보, 프로모션 등 각종 마케팅 관련 정보 의 안내 및 광고 수신 전화번호, 이메일, 우편번호, 주소<br>
                                            (2) 고객 서비스 이용 – 소비자 문의 처리, 주문취소, 반품, AS 관련 문의, 이름, 전화번호, 우편번호, 주소<br>
                                            (3) 디지털 광고 – 개인화된 맞춤형 광고
                                            쿠키 또는 광고 ID, 이메일 주소, 클라이언트 식별자, 인터넷 프로토콜 주소를 포함한 온라인 식별자, 파트너 제공 식별자, 콘텐츠 종류, 콘텐츠 ID 및 콘텐츠, 상품 브라우징 정보, 구매 이력, 브라우저 이용 내역 (고객 액션 정보) 수집하며, 광고플랫폼에 따라 수집하는 항목이 다를 수 있습니다.<br>
                                            <br>
                                            3) 자동 수집 항목<br>
                                            특정 데이터는 귀하의 기기 또는 웹 브라우저 및 통신에서 자동으로 수집됩니다. 이 데이터에는 IP 주소와 같은 기기 정보, 고유 식별자, 고유 기기 식별자 및 기기 유형, 도메인, 브라우저 유형, 버전 및 언어, 운영 체제 및 시스템 설정, 일반적인 위치 정보 및 시간대, 및 유사한 기기 및 사용 정보, 쿠키 및 클릭한 링크, 페이지 보기, 구매, 검색, 사용된 기능, 조회한 항목, 플랫폼 내에서 소요된 시간, 업로드 된 정보, 귀하가 장바구니에 추가한 항목 및 플랫폼 내 다른 사람과의 상호작용과 같은 유사 기술을 사용하여 수집된 온라인 활동 및 브라우징 정보가 포함됩니다. 자세한 내용은 아래의 8. 개인정보 자동 수집 장치 운영 및 거부에 관한 사항을 참조하십시오.<br>
                                            <br>
                                            1.2 수집방법<br>
                                            개인정보는 아래와 같이 방법으로 수집됩니다.<br>
                                            (1) 온라인 가입시 데스크탑피씨, 모바일웹을 통해서 가입<br>
                                            (2) 라이브챗 - 채팅창을 통해서 내용 안내 동의 후 가입<br>
                                            (3) 이메일 – 이메일 문의하기, 상담하기를 통해서 동의 후 문의내용 작성<br>
                                            <br>
                                        <li>개인정보의 수집 및 이용목적</li>
                                            대부분의 브랜드 홈페이지 서비스는 별도의 이용자 등록이 없이 사용할 수 있습니다. 그러나 브랜드 회원서비스, 상품구매, 각종 이벤트 참여(오픈 기념 혜택, 무료 커피샘플 증정, 할인 바우처 제공, 커피 클래스 초청, 신제품 및 한정판 제품 소식 안내 등), 소비자 조사 등을 통하여 이용자들에게 맞춤 서비스를 비롯한 보다 더 향상된 양질의 서비스를 제공하기 위하여 필요한 이용자 개인 정보를 수집하고 있으며, 수집한 개인정보는 다음의 목적으로 활용됩니다.<br>

                                            2.1. 서비스 제공에 관한 계약이행 및 서비스 제공에 따른 요금정산<br>
                                            콘텐츠 제공, 특정 맞춤 서비스 제공, 물품배송 또는 청구서 등 발송, 본인인증, 구매 및 요금 결제, 요금추심<br>
                                            <br>
                                            2.2. 회원관리
                                            회원제 서비스 이용 및 제한적 본인 확인 제에 따른 본인확인, 개인식별, 불량회원의 부정 이용 방지와 비인가 사용방지, 가입의사 확인, 가입 및 가입횟수 제한, 만14세 미만 아동 개인정보 수집 시 법정 대리인 동의여부 확인, 추후 법정 대리인 본인확인, 분쟁 조정을 위한 기록보존, 불만처리 등 민원처리, 고지사항 전달
                                            <br>
                                            2.3. 마케팅 광고에 활용
                                            신규 서비스 개발 및 맞춤 서비스 제공, 통계학적 특성에 따른 서비스 제공 및 광고 게재, 서비스의 유효성 확인, 이벤트 및 광고성 정보 제공 및 참여기회 제공, 접속빈도 파악, 회원의 서비스이용에 대한 통계
                                            <br><br>
                                        <li>수집한 개인정보의 보유 및 이용기간</li>
                                            이용자가 블루보틀 브랜드 홈페이지 회원으로서 블루보틀에서 제공하는 브랜드 홈페이지의 회원서비스를 이용하는 동안 블루보틀 이용자들의 개인정보를 보유하며 규정에 따라 개인정보를 활용합니다. 회원이 가입 해지를 요청하거나 개인정보 수집 및 이용 목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 단, 다음의 정보에 대해서는 아래의 이유로 명시한 기간 동안 보존합니다.
                                            <br><br>
                                            <관련법령에 의한 정보보유>
                                            상법, 전자상거래 등에서의 소비자보호에 관한 법률 등 관계법령의 규정에 의하여 보존할 필요가 있는 경우 관계법령에서 정한 일정한 기간 동안 회원정보 보관.
                                            <br><br>
                                            1) 보존 항목: 계약 또는 청약철회 등에 관한 기록<br>
                                            근거 법령 및 방침: 전자상거래 등에서의 소비자 보호에 관한 법률<br>
                                            보존 기간: 5년<br>
                                            2) 보존 항목: 대금결제 및 재화 등의 공급에 관한 기록<br>
                                            근거 법령 및 방침: 전자상거래 등에서의 소비자 보호에 관한 법률<br>
                                            보존 기간: 5년<br>
                                            3) 보존 항목: 소비자의 불만 또는 분쟁처리에 관한 기록<br>
                                            근거 법령 및 방침: 전자상거래 등에서의 소비자 보호에 관한 법률<br>
                                            보존 기간: 3년<br>
                                            4) 보존 항목: 표시/광고에 관한 기록<br>
                                            근거 법령 및 방침: 전자상거래 등에서의 소비자 보호에 관한 법률<br>
                                            보존 기간: 6개월<br>
                                            5) 보존 항목: 세법이 규정하는 모든 거래에 관한 장부 및 증빙서류<br>
                                            근거 법령 및 방침: 국세기본법<br>
                                            보존 기간: 5년<br>
                                            6) 보존 항목: 전자금융거래에 관한 기록<br>
                                            근거 법령 및 방침: 전자금융거래법<br>
                                            보존 기간: 5년<br>
                                            7) 보존 항목: 서비스 방문 기록<br>
                                            근거 법령 및 방침: 통신비밀보호법, 정보통신망법<br>
                                            보존 기간: 1년<br>
                                            8) 보존 항목: 부정이용기록<br>
                                            근거 법령 및 방침: 회사 내부 방침<br>
                                            보존 기간: 1년<br>
                                            <br><br>
                                        <li>개인정보의 파기절차</li>
                                            1) 블루보틀은 회원이 가입 해지를 요청하거나, 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 해당 개인 정보를 영업일 5일 이내 파기합니다.
                                            <br><br>
                                            2) 이용자로부터 동의 받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는, 해당 개인정보를 별도의 데이터베이스(DB)로 옮기거나 보관장소를 달리하여 보존합니다. 별도 보존되는 개인정보는 법률에 의한 경우가 아니고서는 보존목적 이외의 다른 목적으로 이용되지 않습니다.
                                            <br><br>
                                            3) 개인정보 파기의 절차 및 방법은 다음과 같습니다.<br>
                                            (1) 파기절차<br>
                                            회사는 파기 사유가 발생한 개인정보를 선정하고, 회사의 개인정보 처리방침에서 정한 바에 따라 개인정보를 파기합니다.<br><br>
                                            (2) 파기방법<br>
                                            회사는 전자적 파일 형태로 기록∙저장된 개인정보는 기록을 재생할 수 없도록 기술적인 방법을 이용하여 비식별화 등의 방식으로 안전하게 개인정보를 파기하며, 종이 문서에 기록∙저장된 개인정보는 분쇄기로 분쇄하거나 소각하여 파기합니다.
                                            <br><br>
                                        <li>개인정보 처리 위탁</li>
                                            블루보틀은 다음과 같이 서비스 제공을 위하여 필요한 개인정보 처리 위탁을 하고 있습니다. 블루보틀은 관계 법령에 따라 위탁 계약 시 개인정보가 안전하게 처리될 수 있도록 필요한 사항을 규정하고 있습니다.
                                            <br><br>
                                            회사는 신상품 소개, 이벤트 정보 등의 유용한 정보를 제공하기 위하여 개인정보 처리 위탁을 할 수 있으며 그러한 경우 별도의 동의절차를 밟고 있습니다. 블루보틀이 수탁업체에 위탁하는 업무와 관련된 서비스를 이용하지 않는 경우, 이용자의 개인정보가 수탁업체에 제공되지 않습니다. 개인정보 처리 위탁에 동의 않을 수 있으나, 동의하지 않는 경우 본인 확인 인증, 고객정보 분석, 상품 배송 서비스 등 개인정보 처리 위탁을 하는 업무의 제공이 불가능합니다.
                                            <br><br>
                                        <li>이용자 및 법정대리인의 권리와 그 행사방법</li>
                                            이용자 및 법정 대리인은 브랜드 홈페이지를 이용하여 언제든지 등록되어 있는 자신 혹은 당해 만 14세 미만 아동의 개인정보를 조회하거나 수정할 수 있으며 가입 해지를 요청할 수도 있습니다.
                                            <br><br>
                                            이용자 혹은 만 14세 미만 아동의 개인정보 조회, 수정을 위해서는 '개인정보변경'(또는 '회원정보수정' 등)을, 가입 해지(동의철회) 및 삭제를 위해서는 블루보틀 고객센터 (1533-6906)을 통해 요청 하실 수 있으며 본인 확인 절차를 거치신 후 직접 열람, 정정 또는 탈퇴가 가능합니다. 혹은 개인정보관리책임자에게 서면, 전화 또는 이 메일로 연락하시면 지체 없이 조치하겠습니다.
                                            <br><br>
                                            [블루보틀커피코리아 유한회사 개인정보 보호책임자]<br>
                                            성명: 임홍주<br>
                                            이메일 주소: Jason.lim@bluebottlecoffee.com<br>
                                            [블루보틀 사업부 개인정보 민원처리 담당부서]<br>
                                            블루보틀 고객센터<br>
                                            전화번호 : 1533-6906<br>
                                            <br>
                                            기타 개인정보침해에 대한 신고나 상담이 필요하신 경우에는 아래 기관에 문의하시기 바랍니다.<br>
                                            <br>
                                            •    개인정보침해신고센터(한국인터넷진흥원) (privacy.kisa.or.kr / (국번없이) 118)<br>
                                            •    경찰청 사이버수사국 (police.go.kr / (국번없이) 182)<br>
                                            •    대검찰청 사이버수사과 (www.spo.go.kr / (국번없이) 1301)<br>
                                            •    개인정보분쟁조정위원회 (www.kopico.go.kr / : (국번없이) 1833-6972 )<br>
                                            <br>
                                            13. 정책변경에 따른 공지 의무<br>
                                            블루보틀 개인정보 처리방침은 2024년 7월 31일에 제정되었으며 법령, 정책 또는 보유기술의 변경에 따라 내용의 추가, 삭제 및 수정이 있을 시에는 변경되는 개인정보 처리방침을 브랜드 홈페이지를 통해 내용을 공지하도록 하겠습니다.<br>
                                            <br>
                                            •    개인정보 처리방침 최종 변경 일자: 2024년 8월 1일<br>
                                            •    개인정보 처리방침 시행 일자: 2014년 8월 1일<br>
                                        </p>
                                    </ol>
                                    
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Modal 3 -->
                    <div class="modal fade" id="modal3" tabindex="-1" aria-labelledby="modal3Label" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h1 class="modal-title fs-5" id="modal3Label">판매이용약관</h1>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body" style="font-size: 14px;">
                                    <p>
                                        판매이용약관<br>
                                        <br>
                                        제1조(목적)<br>
                                        <br>
                                        이 약관은 블루보틀커피코리아 유한회사(이하”회사”)가 운영하는 사이버 몰(이하 “몰”이라 한다)에서 제공하는 서비스(이하 “서비스”라 한다)를 이용함에 있어 사이버 몰과 이용자의 권리·의무 및 책임사항을 규정함을 목적으로 합니다.<br>
                                        <br>
                                        제2조(정의)<br>
                                        <br>
                                        ① “몰”이란 회사가 재화 또는 용역(이하 “재화 등”이라 함)을 이용자에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 재화 등을 거래할 수 있도록 설정한 가상의 영업장을 말하며, 아울러 사이버몰을 운영하는 사업자의 의미로도 사용합니다.<br><br>

                                        ② “이용자”란 “몰”에 접속하여 이 약관에 따라 “몰”이 제공하는 서비스를 받는 회원 및 비회원을 말합니다.<br><br>

                                        ③ ‘회원’이라 함은 “몰”에 회원등록을 한 자로서, 계속적으로 “몰”이 제공하는 서비스를 이용할 수 있는 자를 말합니다.<br><br>

                                        ④ ‘비회원’이라 함은 회원에 가입하지 않고 “몰”이 제공하는 서비스를 이용하는 자를 말합니다.<br><br>

                                        

                                        제3조 (약관 등의 명시와 설명 및 개정)<br>
                                        <br>
                                        ① “몰”은 이 약관의 내용과 상호 및 대표자 성명, 영업소 소재지 주소(소비자의 불만을 처리할 수 있는 곳의 주소를 포함), 전화번호, 모사전송번호, 전자우편주소, 사업자등록번호, 통신판매업신고번호, 개인정보관리책임자 등을 이용자가 쉽게 알 수 있도록 몰의 초기 서비스화면(전면)에 게시합니다. 다만, 약관의 내용은 이용자가 연결화면을 통하여 볼 수 있도록 할 수 있습니다.<br><br>

                                        ② “몰은 이용자가 약관에 동의하기에 앞서 약관에 정하여져 있는 내용 중 청약철회, 배송 책임, 환불 조건 등과 같은 중요한 내용을 이용자가 이해할 수 있도록 별도의 연결 화면 또는 팝업 화면 등을 제공하여 이용자의 확인을 구할 수 있습니다.<br><br>

                                        ③ “몰”은 「전자상거래 등에서의 소비자보호에 관한 법률」, 「약관의 규제에 관한 법률」, 「전자문서 및 전자거래기본법」, 「전자금융거래법」, 「전자서명법」, 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」, 「방문판매 등에 관한 법률」, 「소비자기본법」 등 관련 법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.<br><br>

                                        ④ “몰”이 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현행 약관과 함께 몰의 초기화면에 그 적용일자 7일 이전부터 적용일자 전일까지 공지합니다. 다만, 이용자에게 불리하게 약관 내용을 변경하는 경우에는 최소한 30일 이상의 사전 유예기간을 두고 공지합니다. 이 경우 "몰“은 개정 전 내용과 개정 후 내용을 명확하게 비교하여 이용자가 알기 쉽도록 표시합니다.<br><br>

                                        ⑤ “몰”이 약관을 개정할 경우에는 그 개정약관은 그 적용일자 이후에 체결되는 계약에만 적용되고 그 이전에 이미 체결된 계약에 대해서는 개정 전의 약관조항이 그대로 적용됩니다. 다만 이미 계약을 체결한 이용자가 개정약관 조항의 적용을 받기를 원하는 뜻을 제3항에 의한 개정약관의 공지기간 내에 “몰”에 송신하여 “몰”의 동의를 받은 경우에는 개정약관 조항이 적용됩니다.<br><br>

                                        ⑥ 이 약관에서 정하지 아니한 사항과 이 약관의 해석에 관하여는 전자상거래 등에서의 소비자보호에 관한 법률, 약관의 규제 등에 관한 법률, 공정거래위원회가 정하는 전자상거래 등에서의 소비자 보호지침 및 관계법령 또는 상관례에 따릅니다<br><br>

                                        

                                        제4조(서비스의 제공 및 변경)<br>
                                        <br>
                                        ① “몰”은 다음과 같은 업무를 수행합니다.<br><br>

                                        1) 재화 또는 용역에 대한 정보 제공 및 구매계약의 체결<br>

                                        2) 구매계약이 체결된 재화 또는 용역의 배송<br>

                                        3) 기타 “몰”이 정하는 업무<br>
                                        <br>
                                        ② “몰”은 재화 또는 용역의 품절 또는 기술적 사양의 변경 등의 경우에는 장차 체결되는 계약에 의해 제공할 재화 또는 용역의 내용을 변경할 수 있습니다. 이 경우에는 변경된 재화 또는 용역의 내용 및 제공일자를 명시하여 현재의 재화 또는 용역의 내용을 게시한 곳에 즉시 공지합니다.<br><br>

                                        ③ “몰”이 제공하기로 이용자와 계약을 체결한 서비스의 내용을 재화 등의 품절 또는 기술적 사양의 변경 등의 사유로 변경할 경우에는 그 사유를 이용자에게 통지 가능한 주소로 즉시 통지합니다.<br><br>



                                        제5조(서비스의 중단)<br>
                                        <br>
                                        ① “몰”은 컴퓨터 등 정보통신설비의 보수점검·교체 및 고장, 통신의 두절 등의 사유가 발생한 경우에는 서비스의 제공을 일시적으로 중단할 수 있습니다.<br><br>

                                        ② “몰”은 제1항의 사유로 서비스의 제공이 일시적으로 중단됨으로 인하여 이용자 또는 제3자가 입은 손해에 대하여 배상합니다. 단, “몰”이 고의 또는 과실이 없음을 입증하는 경우에는 그러하지 아니합니다.<br><br>

                                        제6조(회원가입)<br>
                                        <br>
                                        ① 이용자는 “몰”이 정한 가입 양식에 따라 회원정보를 기입한 후 이 약관에 동의한다는 의사표시를 함으로서 회원가입을 신청합니다.<br><br>

                                        ② “몰”은 제1항과 같이 회원으로 가입할 것을 신청한 이용자 중 다음 각 호에 해당하지 않는 한 회원으로 등록합니다.<br><br>

                                        1) 등록 내용에 허위, 기재 누락, 오기가 있는 경우<br><br>

                                        2) 기타 회원으로 등록하는 것이 “몰”의 기술상 현저히 지장이 있다고 판단되는 경우<br><br>

                                        ③ 회원은 회원가입 시 등록한 사항에 변경이 있는 경우, 지체 없이 “몰”에 대하여 회원정보 수정 등의 방법으로 그 변경사항을 알려야 합니다.<br><br>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        
        <div class="col my_left">
            <div class="row mt-4" style="font-size: 14px;">
            		<% for(int i=1; i<index; i++){ %>
	                <div class="col-4"><%=names[i] %></div>
	                <div class="col-2"><%=quantities[i] %>개</div>
	                <div class="col">₩<span><%=prices[i] %></span></div>
	                <hr />
                <% } %>
            </div>
            <div class="row mt-5" style="font-size: 14px;">
                <div class="col">소계</div>
                <div class="col">₩<span><%=total_price %></span></div>
            </div>
            <div class="row mt-3" style="font-size: 14px;">
                <div class="col">배송</div>
                <div class="col">₩<span>0</span></div>
            </div>
            <div class="row mt-3 fw-bold" style="font-size: 18px;">
                <div class="col">총계</div>
                <div class="col">₩<span><%=total_price+vat %></span></div>
            </div>
            <div class="mt-2" style="font-size: 14px; color: rgb(102, 102, 102);">
                <span>세금 포함</span>
                <span>₩<span><%=vat %></span></span>
            </div>
        </div>
    </div>

		<script>
		    document.addEventListener('DOMContentLoaded', () => {
		        const checkAll = document.getElementById('checkAll');
		        const checkboxes = document.querySelectorAll('.form-check-input');
		        const submitBtn = document.getElementById('submitBtn');
		
		        const cardNum1 = document.getElementById('cardNum1');
		        const cardNum2 = document.getElementById('cardNum2');
		        const cardNum3 = document.getElementById('cardNum3');
		        const cardNum4 = document.getElementById('cardNum4');
		        const birthInput = document.getElementById('birthInput');
		        const pwInput = document.getElementById('pwInput');
		
		        // 전체 상태 점검 함수
		        function validateForm() {
		            const otherBoxes = Array.from(checkboxes).filter(cb => cb.id !== 'checkAll');
		            const allChecked = otherBoxes.every(cb => cb.checked);
		
		            const validCard = cardNum1.value.length === 4 &&
		                              cardNum2.value.length === 4 &&
		                              cardNum3.value.length === 4 &&
		                              cardNum4.value.length === 4;
		            const validBirth = birthInput.value.length === 6;
		            const validPW = pwInput.value.length === 2;
		
		            submitBtn.disabled = !(allChecked && validCard && validBirth && validPW);
		        }
		
		        // 전체동의 → 모든 체크박스 상태 설정
		        checkAll.addEventListener('change', () => {
		            checkboxes.forEach(cb => {
		                cb.checked = checkAll.checked;
		            });
		            validateForm();
		        });
		
		        // 개별 체크박스 상태 변경 → 전체동의 체크 여부 갱신
		        checkboxes.forEach(cb => {
		            cb.addEventListener('change', () => {
		                const otherBoxes = Array.from(checkboxes).filter(cb => cb.id !== 'checkAll');
		                checkAll.checked = otherBoxes.every(cb => cb.checked);
		                validateForm();
		            });
		        });
		
		        // 카드번호, 생년월일, 비밀번호 입력 값 변경 시마다 확인
		        [cardNum1, cardNum2, cardNum3, cardNum4, birthInput, pwInput].forEach(input => {
		            input.addEventListener('input', validateForm);
		        });
		
		        // 초기 상태
		        validateForm();
		    });
		</script>
		

		












    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
</body>
</html>