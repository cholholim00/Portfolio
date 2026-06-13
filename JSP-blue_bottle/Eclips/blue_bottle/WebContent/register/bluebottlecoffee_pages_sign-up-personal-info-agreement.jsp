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
    <link rel="stylesheet" href="css/bluebottlecoffee_pages_sign-up-personal-info-agreement.css">
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
                <h1>블루보틀 회원가입 시 <br>
                    개인정보 수집/이용 동의</h1>
            </div>
            <div class="body-content mt-4">
                <div class="rte scroll-trigger animate--slide-in">
                    <ol data-mce-fragment="1">
                        <li data-mce-fragment="1">
                    <span data-mce-fragment="1"> </span>수집하는 개인정보 항목 및 수집방법</li>
                    </ol>
                    <p data-mce-fragment="1">블루보틀은 이용자들의 회원가입<span data-mce-fragment="1">, </span>상담<span data-mce-fragment="1">, </span>그리고 각종 서비스의 제공을 위해 아래와 같은 개인정보를 수집하고 있습니다<span data-mce-fragment="1">.</span></p>
                    <p data-mce-fragment="1">성명<span data-mce-fragment="1">, </span>전자우편 주소<span data-mce-fragment="1">, </span>전화번호<span data-mce-fragment="1"> (</span>휴대전화 번호<span data-mce-fragment="1">), </span>우편주소<span data-mce-fragment="1">(</span>배송지<span data-mce-fragment="1">/</span>청구지<span data-mce-fragment="1">),</span></p>
                    <p data-mce-fragment="1">또한 서비스 이용과정이나 사업 처리 과정에서 사용자 이름 및 패스워드<span data-mce-fragment="1">, </span>웹 브라우저<span data-mce-fragment="1">, </span>및<span data-mce-fragment="1"> OS </span>유형<span data-mce-fragment="1">, </span>접속 로그<span data-mce-fragment="1">, IP </span>주소<span data-mce-fragment="1">, </span>광고<span data-mce-fragment="1"> ID, </span>쿠키<span data-mce-fragment="1">, </span>방문 날짜<span data-mce-fragment="1">, </span>서비스 이용 기록<span data-mce-fragment="1">, </span>사업자가 마케팅 등에 이용할 목적으로 가공한 회원정보 등이 생성되어 수집될 수 있습니다<span data-mce-fragment="1">.</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">&nbsp;</span></p>
                    <ol start="2" data-mce-fragment="1">
                        <li data-mce-fragment="1">
                    <span data-mce-fragment="1"> </span>개인정보의 수집 및 이용목적</li>
                    </ol>
                    <p data-mce-fragment="1">대부분의 브랜드 홈페이지 서비스는 별도의 이용자 등록이 없이 사용할 수 있습니다<span data-mce-fragment="1">. </span>그러나 브랜드 회원서비스<span data-mce-fragment="1">, </span>상품구매<span data-mce-fragment="1">, </span>각종 이벤트 참여<span data-mce-fragment="1">(1</span>주년 기념 혜택<span data-mce-fragment="1">, </span>무료 커피샘플 증정<span data-mce-fragment="1">, </span>할인 바우처 제공<span data-mce-fragment="1">, </span>커피 클래스 초청<span data-mce-fragment="1">, </span>신제품 및 한정판 제품 소식 안내 등<span data-mce-fragment="1">), </span>소비자 조사 등을 통하여 이용자들에게 맞춤 서비스를 비롯한 보다 더 향상된 양질의 서비스를 제공하기 위하여 필요한 이용자 개인 정보를 수집하고 있으며<span data-mce-fragment="1">, </span>수집한 개인정보는 다음의 목적으로 활용됩니다<span data-mce-fragment="1">.</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">&nbsp;</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">2.1. </span>서비스 제공에 관한 계약이행 및 서비스 제공</p>
                    <p data-mce-fragment="1">콘텐츠 제공<span data-mce-fragment="1">, </span>특정 맞춤 서비스 제공<span data-mce-fragment="1">, </span>본인인증</p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">&nbsp;</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">2.2. </span>회원관리</p>
                    <p data-mce-fragment="1">회원제 서비스 이용 및 제한적 본인 확인 제에 따른 본인확인<span data-mce-fragment="1">, </span>개인식별<span data-mce-fragment="1">, </span>불량회원의 부정 이용 방지와 비인가 사용방지<span data-mce-fragment="1">, </span>가입의사 확인<span data-mce-fragment="1">, </span>가입 및 가입횟수 제한<span data-mce-fragment="1">, </span>만<span data-mce-fragment="1">14</span>세 미만 아동 개인정보 수집 시 법정 대리인 동의여부 확인<span data-mce-fragment="1">, </span>추후 법정 대리인 본인확인<span data-mce-fragment="1">, </span>분쟁 조정을 위한 기록보존<span data-mce-fragment="1">, </span>불만처리 등 민원처리<span data-mce-fragment="1">, </span>고지사항 전달</p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">&nbsp;</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">2.3. </span>마케팅 광고에 활용</p>
                    <p data-mce-fragment="1">신규 서비스 개발 및 맞춤 서비스 제공<span data-mce-fragment="1">, </span>통계학적 특성에 따른 서비스 제공 및 광고 게재<span data-mce-fragment="1">, </span>서비스의 유효성 확인<span data-mce-fragment="1">, </span>이벤트 및 광고성 정보 제공 및 참여기회 제공<span data-mce-fragment="1">, </span>접속빈도 파악<span data-mce-fragment="1">, </span>회원의 서비스이용에 대한 통계</p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">&nbsp;</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">2.4. </span>블루보틀 맞춤 혜택 제공 및 제공한 혜택 관리</p>
                    <p data-mce-fragment="1">특정 맞춤 혜택 제공<span data-mce-fragment="1">, </span>맞춤 서비스 제공<span data-mce-fragment="1">, </span>본인인증</p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">&nbsp;</span></p>
                    <ol start="3" data-mce-fragment="1">
                        <li data-mce-fragment="1">
                    <span data-mce-fragment="1"> </span>수집한 개인정보의 보유 및 이용기간</li>
                    </ol>
                    <p data-mce-fragment="1">이용자가 블루보틀의 브랜드 홈페이지 회원으로서 블루보틀에서 제공하는 브랜드 홈페이지의 회원서비스를 이용하는 동안 블루보틀은 이용자들의 개인정보를 보유하며 규정에 따라 개인정보를 활용합니다<span data-mce-fragment="1">. </span>회원이 가입 해지를 요청하거나 개인정보 수집 및 이용 목적이 달성된 후에는 해당 개인 정보를 영업일<span data-mce-fragment="1"> 5</span>일 이내 파기합니다<span data-mce-fragment="1">. </span>단<span data-mce-fragment="1">, </span>다음의 정보에 대해서는 아래의 이유로 명시한 기간 동안 보존합니다<span data-mce-fragment="1">.</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">&nbsp;</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">&lt;</span>관련법령에 의한 정보보유<span data-mce-fragment="1">&gt;</span></p>
                    <p data-mce-fragment="1">상법<span data-mce-fragment="1">, </span>전자상거래 등에서의 소비자보호에 관한 법률 등 관계법령의 규정에 의하여 보존할 필요가 있는 경우 관계법령에서 정한 일정한 기간 동안 회원정보 보관<span data-mce-fragment="1">.</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">&nbsp;</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">1) </span>보존 항목<span data-mce-fragment="1">: </span>계약 또는 청약철회 등에 관한 기록</p>
                    <p data-mce-fragment="1">근거 법령 및 방침<span data-mce-fragment="1">: </span>전자상거래 등에서의 소비자 보호에 관한 법률</p>
                    <p data-mce-fragment="1">보존 기간<span data-mce-fragment="1">: ★5</span>년<span data-mce-fragment="1">★</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">2) </span>보존 항목<span data-mce-fragment="1">: </span>대금결제 및 재화 등의 공급에 관한 기록</p>
                    <p data-mce-fragment="1">근거 법령 및 방침<span data-mce-fragment="1">: </span>전자상거래 등에서의 소비자 보호에 관한 법률</p>
                    <p data-mce-fragment="1">보존 기간<span data-mce-fragment="1">: ★5</span>년<span data-mce-fragment="1">★</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">3) </span>보존 항목<span data-mce-fragment="1">: </span>소비자의 불만 또는 분쟁처리에 관한 기록</p>
                    <p data-mce-fragment="1">근거 법령 및 방침<span data-mce-fragment="1">: </span>전자상거래 등에서의 소비자 보호에 관한 법률</p>
                    <p data-mce-fragment="1">보존 기간<span data-mce-fragment="1">: ★3</span>년<span data-mce-fragment="1">★</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">4) </span>보존 항목<span data-mce-fragment="1">: </span>표시<span data-mce-fragment="1">/</span>광고에 관한 기록</p>
                    <p data-mce-fragment="1">근거 법령 및 방침<span data-mce-fragment="1">: </span>전자상거래 등에서의 소비자 보호에 관한 법률</p>
                    <p data-mce-fragment="1">보존 기간<span data-mce-fragment="1">: ★6</span>개월<span data-mce-fragment="1">★</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">5) </span>보존 항목<span data-mce-fragment="1">: </span>세법이 규정하는 모든 거래에 관한 장부 및 증빙서류</p>
                    <p data-mce-fragment="1">근거 법령 및 방침<span data-mce-fragment="1">: </span>국세기본법</p>
                    <p data-mce-fragment="1">보존 기간<span data-mce-fragment="1">: ★5</span>년<span data-mce-fragment="1">★</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">6) </span>보존 항목<span data-mce-fragment="1">: </span>전자금융거래에 관한 기록</p>
                    <p data-mce-fragment="1">근거 법령 및 방침<span data-mce-fragment="1">: </span>전자금융거래법</p>
                    <p data-mce-fragment="1">보존 기간<span data-mce-fragment="1">: ★5</span>년<span data-mce-fragment="1">★</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">7) </span>보존 항목<span data-mce-fragment="1">: </span>서비스 방문 기록</p>
                    <p data-mce-fragment="1">근거 법령 및 방침<span data-mce-fragment="1">: </span>통신비밀보호법<span data-mce-fragment="1">, </span>정보통신망법</p>
                    <p data-mce-fragment="1">보존 기간<span data-mce-fragment="1">: ★1</span>년<span data-mce-fragment="1">★</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">8) </span>보존 항목<span data-mce-fragment="1">: </span>부정이용기록</p>
                    <p data-mce-fragment="1">근거 법령 및 방침<span data-mce-fragment="1">: </span>회사 내부 방침</p>
                    <p data-mce-fragment="1">보존 기간<span data-mce-fragment="1">: ★1</span>년<span data-mce-fragment="1">★</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">&nbsp;</span></p>
                    <ol start="4" data-mce-fragment="1">
                        <li data-mce-fragment="1">
                    <span data-mce-fragment="1"> </span>개인정보의 파기절차</li>
                    </ol>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">1) </span>블루보틀은 회원이 가입 해지를 요청하거나<span data-mce-fragment="1">, </span>개인정보 보유기간의 경과<span data-mce-fragment="1">, </span>처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 해당 개인 정보를 영업일<span data-mce-fragment="1"> 5</span>일 이내 파기합니다<span data-mce-fragment="1">.</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">2) </span>이용자로부터 동의 받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는<span data-mce-fragment="1">, </span>해당 개인정보를 별도의 데이터베이스<span data-mce-fragment="1">(DB)</span>로 옮기거나 보관장소를 달리하여 보존합니다<span data-mce-fragment="1">. </span>별도 보존되는 개인정보는 법률에 의한 경우가 아니고서는 보존목적 이외의 다른 목적으로 이용되지 않습니다<span data-mce-fragment="1">.</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">3) </span>개인정보 파기의 절차 및 방법은 다음과 같습니다<span data-mce-fragment="1">.</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">(1) </span>파기절차</p>
                    <p data-mce-fragment="1">회사는 파기 사유가 발생한 개인정보를 선정하고<span data-mce-fragment="1">, </span>회사의 개인정보처리방침에서 정한 바에 따라 개인정보를 파기합니다<span data-mce-fragment="1">.</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">(2) </span>파기방법</p>
                    <p data-mce-fragment="1">회사는 전자적 파일 형태로 기록<span data-mce-fragment="1">∙</span>저장된 개인정보는 기록을 재생할 수 없도록 기술적인 방법을 이용하여 비식별화 등의 방식으로 안전하게 개인정보를 파기하며<span data-mce-fragment="1">, </span>종이 문서에 기록<span data-mce-fragment="1">∙</span>저장된 개인정보는 분쇄기로 분쇄하거나 소각하여 파기합니다<span data-mce-fragment="1">.</span></p>
                    <p data-mce-fragment="1"><span data-mce-fragment="1">&nbsp;</span></p>
                    <ol start="5" data-mce-fragment="1">
                        <li data-mce-fragment="1">
                    <span data-mce-fragment="1"> </span>개인정보 수집 거부 권리</li>
                    </ol>
                    <p data-mce-fragment="1">귀하는 블루보틀의 서비스 이용에 필요한 최소한의 개인정보 수집<span data-mce-fragment="1">·</span>이용에 동의하지 않을 권리가 있으며<span data-mce-fragment="1">, </span>동의 거부 시 거부한 내용에 대해 서비스가 제한될 수 있습니다<span data-mce-fragment="1">.</span></p>
                    <p data-mce-fragment="1">&nbsp;</p>
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