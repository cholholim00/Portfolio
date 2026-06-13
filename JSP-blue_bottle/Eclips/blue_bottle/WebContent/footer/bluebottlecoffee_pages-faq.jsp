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
    <title>Bootstrap demo</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="bluebottlecoffee_pages-faq.css">
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

<h1 class="page-title">자주 묻는 질문</h1>
<div class="container-body">
        
        <div class="faq-section">
            <h2 class="section-title">배송 관련</h2>
            
            <div class="faq-item">
                <div class="faq-question">
                    <span>오늘 주문했는데 언제 받을 수 있을까요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        주문 이후 송장번호가 발행되어 출고된 후 약 1~3일 이내 배송 됩니다. (주말/공휴일 제외) 단, 특수지역 및 황금연휴가 포함되거나 프로모션으로 인한 주문 폭주, 택배사 사정으로 인해 일부 더 소요될 수 있습니다.
                    </div>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question">
                    <span>어떤 택배사를 이용해 배송되나요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                       CJ 대한통운을 통해 안전하게 배송됩니다.
                    </div>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question">
                    <span>제품출고(택배발송)는 언제 하나요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        전일 12시 이후부터 당일 12시 이전까지 결제완료 건은 당일 오후 출고 및 택배 발송됩니다. (*단, 주문량에 따라 변동 될 수 있습니다.) <br>
						금요일 12시 이후 및 법정공휴일 결제완료 건은 돌아오는 평일 오후 순차적 출고 및 택배 발송됩니다.
                    </div>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question">
                    <span>주문한 상품을 변경할 수 있나요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        주문이 완료된 후에는 주문자 정보를 변경할 수 없으므로, 주문을 전체 취소한 후 다시 주문하시거나 고객센터로 문의 주셔야 합니다.


						[내 계정] > [주문내역 조회]에서 확인 및 취소가 가능하며, 주문이 이미 [배송중]으로 넘어간 경우에는 취소가 불가능합니다.
                    </div>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question">
                    <span>주문자 정보나 배송지를 변경할 수 있나요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        주문이 완료된 후에는 주문자 정보를 변경할 수 없으므로, 주문을 전체 취소한 후 다시 주문하시거나 고객센터로 문의 주셔야 합니다.


						[마이페이지] > [주문내역 조회]에서 확인 및 취소가 가능하며, 주문이 이미 [배송중]으로 넘어간 경우에는 취소가 불가능합니다.
                    </div>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question">
                    <span>해외배송이 가능한가요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        국내 배송만 가능하며 (도서산간/제주지역 추가 비용) 국외(해외) 배송은 지원하지 않습니다. 양해 부탁 드립니다.
                    </div>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question">
                    <span>배송비는 어떻게 되나요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        최종 결제금액이 35,000원 이상일 경우 배송비 무료이며, (35,000원 미만일 경우 3,000원) 도서산간/제주지역으로의 배송 요청이 추가로 발생될 수 있습니다. 추가 금액은 결제 시 자동으로 계산됩니다.
                    </div>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question">
                    <span>조건에 맞게 구매하였는데 증정품이 발송되지 않았을 때는 어떻게 해야 하나요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        증정품은 한정수량으로 진행되므로 조기소진 시 배송되지 않거나 다른 제품으로 임의 대체되어 발송될 수 있습니다.


						관련 정보는 이벤트 페이지 내 유의사항에 설명되어 있으니 참여 시 확인 부탁 드립니다.
                    </div>
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question">
                    <span>선물 포장이 가능할까요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        선물 포장 서비스는 별도로 제공하고 있지 않습니다. 쇼핑백은 제품 구매 시 S와 M 사이즈 중 선택하여 구매 가능합니다. (각 100원)
                    </div>
                </div>
            </div>
        </div>
        
        <div class="faq-section">
            <h2 class="section-title">교환/환불/취소 관련</h2>
            
            <div class="faq-item">
                <div class="faq-question">
                    <span>교환 및 환불 규정은 어떻게 될까요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        배송완료일 (제품을 수령하신 날) 로부터 7일 이내 신청 가능합니다.

                        배송완료일로부터 7일 이후에는 구매가 확정되어 신청이 불가합니다.

                        단, 아래와 같은 사유로 인할 시에는 예외로 처리됩니다.

                        - 수령 받은 제품이 표시/광고의 내용과 다르거나, 계약내용과 다르게 이행된 경우

                        - 제품 수령일로부터 3개월 이내 또는 그 사실을 알 수 있었던 날로부터 30일 이내
                    </div>
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <span>반품 배송비 및 환불 과정은 어떻게 되나요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        단순 변심으로 인한 반품의 경우, 배송비를 이미 지불하신 경우 반품 배송비 (일반 3,000원/ 제주도 및 산간지역 별도) 만을 추가로 청구합니다 .

                        무료 배송으로 제품을 받으신 경우에는 왕복 배송비가 차감됩니다. 상품에 대한 하자 등으로 반품이 진행되는 경우에는 블루보틀이 배송비를 부담합니다.
                    </div>
                </div>
            </div>


            <div class="faq-item">
                <div class="faq-question">
                    <span>교환 배송비 및 교환 과정은 어떻게 되나요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        단순 변심으로 인한 반품의 경우, 배송비를 이미 지불하신 경우 반품 배송비 (일반 3,000원/ 제주도 및 산간지역 별도) 만을 추가로 청구합니다 .

                        무료 배송으로 제품을 받으신 경우에는 왕복 배송비가 차감됩니다. 상품에 대한 하자 등으로 반품이 진행되는 경우에는 블루보틀이 배송비를 부담합니다.
                    </div>
                </div>
            </div>


            <div class="faq-item">
                <div class="faq-question">
                    <span>반품이 불가한 경우는 어떻게 되나요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        반품이 불가한 경우는 다음과 같습니다.

                        1. 반품/교환기간을 초과한 경우
                        2. 온라인 주문이력 확인이 불가능한 경우
                        3. 택 또는 패키지가 훼손된 경우
                        4. 상품을 사용한 경우 또는 상품이 변화되었거나 오염되었을 경우
                        5. 고객님의 책임으로 인한 제품 등의 가치가 심하게 파손되거나 훼손된 경우
                        6. 기타 '전자상거래 등에서의 소비자보호에 관한 법률'이 정하는 청약철회 제한 사유에 해당하는 경우
                    </div>
                </div>
            </div>


            <div class="faq-item">
                <div class="faq-question">
                    <span>결제한 주문을 취소할 수 있나요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        결제한 주문은 게스트가 직접 결제 2시간 이내로 취소 가능합니다. [마이페이지] > [주문내역] 에서 취소하고 싶은 주문의 [주문 취소]를 선택해서 진행해주시기 바랍니다.

                        이후에는 출고 작업이 진행되어 취소가 불가능합니다.
                    </div>
                </div>
            </div>


            <div class="faq-item">
                <div class="faq-question">
                    <span>주문취소 시 결제한 수단이 아닌 다른 방법으로 환불 가능한가요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        결제 시 사용하신 수단으로만 환불 처리 됩니다. 양해 부탁 드립니다.
                    </div>
                </div>
            </div>


            <div class="faq-item">
                <div class="faq-question">
                    <span>원두/인스턴트/콜드블루 캔 환불이 가능한가요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        식품에 해당하는 원두, 인스턴트 커피, 콜드브루 캔의 경우에는 제품 상의 이슈를 제외한 단순변심 환불이 불가합니다.
                    </div>
                </div>
            </div>

          </div>
            
        
        <div class="faq-section">
            <h2 class="section-title">사이트 이용문의</h2>
            
            <div class="faq-item">
                <div class="faq-question">
                    <span>고객센터 상담 시간은 어떻게 되나요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        주중 오전 10시부터 오후 5시까지이며, 주말 및 공휴일은 휴무입니다.
                    </div>
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <span>아이디 또는 비밀번호가 기억나지 않습니다</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        로그인 창에서 아이디 찾기 또는 비밀번호 찾기를 통해 확인 가능합니다.


                        - 아이디 찾기 : 본인인증 후 아이디 안내
                        - 비밀번호 찾기 : 본인인증 후 비밀번호 재설정 안내
                    </div>
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <span>회원 아이디 변경이 가능한가요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        본인인증을 통해 식별 되므로, 탈퇴 후 재가입 해주셔야 합니다.
                    </div>
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <span>탈퇴했던 아이디로 재가입 가능한가요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        탈퇴 후 동일한 아이디로 재가입 불가합니다. 탈퇴 시에는 이후 구매이력 등의 정보를 확인하기 어려울 수 있습니다.


                        탈퇴 관련 문의는 고객문의 또는 support_kr@bluebottlecoffee.com 로 문의해주시기 바랍니다.
                    </div>
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <span>쿠폰은 어떻게 사용하나요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        쿠폰 사용은 결제 페이지에서 '프로모션/쿠폰 코드' 항목에 입력하면 적용됩니다.
                    </div>
                </div>
            </div>

        </div>
            
            
        <div class="faq-section">
            <h2 class="section-title">결제 관련</h2>
            
            <div class="faq-item">
                <div class="faq-question">
                    <span>비회원도 주문이 가능한가요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        비회원과 회원 주문이 모두 가능합니다.
                    </div>
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <span>현금영수증 신청이 가능한가요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        결제 진행 타입에 따라 상이하며 '고객 문의' 또는 'support_kr@bluebottlecoffee.com'로 문의를 남겨주시기 바랍니다.
                    </div>
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <span>사용가능한 결제수단은 어떤 것이 있나요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        1) 신용/체크카드
                        2) 간편결제 (네이버페이/ 카카오페이/ 토스페이/ 삼성페이/ 애플페이)
                        위 2가지 중 편하신 결제수단으로 선택하여 진행해주시기 바랍니다.
                    </div>
                </div>
            </div>

         </div>
            
           
        
        <div class="faq-section">
            <h2 class="section-title">원두 관련</h2>
            
            <div class="faq-item">
                <div class="faq-question">
                    <span>원두(커피)는 어떻게 보관하면 되나요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        원두는 밀폐된 용기 또는 제공되는 포장 그대로 보관하는 것이 좋습니다. 열과 빛을 피해 서늘하고 건조한 곳에 보관하시는 것을 추천드립니다.
                    </div>
                </div>
           </div>

           <div class="faq-item">
            <div class="faq-question">
                <span>원두 분쇄 서비스를 제공하나요?</span>
                <span class="faq-arrow">▼</span>
            </div>
            <div class="faq-answer">
                <div class="answer-content">
                    원두 분쇄 서비스는 제공하고 있지 않습니다. 이 점 양해 부탁 드립니다.
                </div>
            </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <span>원두 샘플을 받아볼 수 있나요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        별도의 원두 샘플은 제공되지 않습니다. 이 점 양해 부탁 드립니다.
                    </div>
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <span>로스팅 날짜가 궁금합니다.</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        발송일로부터 2주 이내에 볶은 신선한 커피를 순차적으로 발송해드리고 있습니다.
                    </div>
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <span>커피 원두의 로스팅(강도)가 궁금합니다.</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        스페셜티 커피가 지닌 다채로운 향미를 풍부하게 표현하기 위해, 각각의 특성에 맞는 배전도를 찾아내어
                        생두에 따라 최적의 로스팅 프로파일을 적용하여 로스팅하고 있습니다
                    </div>
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <span>디카페인 커피가 있나요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        디카페인으로는 나이트 라이트 디카페인(NIGHT LIGHT DECAF) 원두가 준비되어 있습니다.

                        [제품 보기]
                    </div>
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <span>블루보틀 에센셜 홀빈은 무엇이 다른가요?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        블루보틀은 전 세계 어디에서나 동일한 고품질의 스페셜티 커피 생두를 사용하고 있습니다. 판매처는 다르지만, 모두 블루보틀의 상품입니다.


                        에센셜 상품군은 다양한 판매처를 통해 더 많은 손님들이 블루보틀의 커피를 더 쉽고, 합리적인 가격으로 즐길 수 있는 접점을 확대 하는데 목적이 있습니다.


                        블루보틀 카페에서 판매되는 원두는 프리미엄 가격대로 정교한 맛과 풍미의 다양성에 중점을 두며,


                        에센셜 원두는 보다 대중적이며 더 직관적이고 심플한 맛으로 접근성을 높이고자 하는 차이가 있습니다.


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
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const faqItems = document.querySelectorAll('.faq-item');
            
            faqItems.forEach(item => {
                const question = item.querySelector('.faq-question');
                const answer = item.querySelector('.faq-answer');
                
                question.addEventListener('click', function() {
                    const isActive = item.classList.contains('active');

                    faqItems.forEach(otherItem => {
                        if (otherItem !== item) {
                            otherItem.classList.remove('active');
                            otherItem.querySelector('.faq-answer').classList.remove('active');
                        }
                    });
                    
                    if (isActive) {
                        item.classList.remove('active');
                        answer.classList.remove('active');
                    } else {
                        item.classList.add('active');
                        answer.classList.add('active');
                    }
                });
            });
        });
    </script>
  </body>
</html>