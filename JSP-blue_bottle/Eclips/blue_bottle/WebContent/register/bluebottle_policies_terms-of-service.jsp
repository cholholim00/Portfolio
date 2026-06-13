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
    <link rel="stylesheet" href="css/bluebottlecoffee_policies_terms-of-service.css">
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
                <h1>판매이용약관</h1>
            </div>
            <div class="body-content mt-4">
                <div class="rte">
        
                    <p>제1조(목적)</p><p>이 약관은 블루보틀커피코리아 유한회사(이하”회사”)가 운영하는 사이버 몰(이하 “몰”이라 한다)에서 제공하는 서비스(이하 “서비스”라 한다)를 이용함에 있어 사이버 몰과 이용자의 권리·의무 및 책임사항을 규정함을 목적으로 합니다.</p>
                    <p>&nbsp;</p>
                    <p>제2조(정의)</p>
                    <p>① “몰”이란 회사가 재화 또는 용역(이하 “재화 등”이라 함)을 이용자에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 재화 등을 거래할 수 있도록 설정한 가상의 영업장을 말하며, 아울러 사이버몰을 운영하는 사업자의 의미로도 사용합니다.</p>
                    <p>② “이용자”란 “몰”에 접속하여 이 약관에 따라 “몰”이 제공하는 서비스를 받는 회원 및 비회원을 말합니다.</p>
                    <p>③ ‘회원’이라 함은 “몰”에 회원등록을 한 자로서, 계속적으로 “몰”이 제공하는 서비스를 이용할 수 있는 자를 말합니다.</p>
                    <p>④ ‘비회원’이라 함은 회원에 가입하지 않고 “몰”이 제공하는 서비스를 이용하는 자를 말합니다.</p>
                    <p>&nbsp;</p>
                    <p>제3조 (약관 등의 명시와 설명 및 개정)</p>
                    <p>① “몰”은 이 약관의 내용과 상호 및 대표자 성명, 영업소 소재지 주소(소비자의 불만을 처리할 수 있는 곳의 주소를 포함), 전화번호, 모사전송번호, 전자우편주소, 사업자등록번호, 통신판매업신고번호, 개인정보관리책임자 등을 이용자가 쉽게 알 수 있도록 몰의 초기 서비스화면(전면)에 게시합니다. 다만, 약관의 내용은 이용자가 연결화면을 통하여 볼 수 있도록 할 수 있습니다.</p>
                    <p>② “몰은 이용자가 약관에 동의하기에 앞서 약관에 정하여져 있는 내용 중 청약철회, 배송 책임, 환불 조건 등과 같은 중요한 내용을 이용자가 이해할 수 있도록 별도의 연결 화면 또는 팝업 화면 등을 제공하여 이용자의 확인을 구할 수 있습니다.</p>
                    <p>③ “몰”은 「전자상거래 등에서의 소비자보호에 관한 법률」, 「약관의 규제에 관한 법률」, 「전자문서 및 전자거래기본법」, 「전자금융거래법」, 「전자서명법」, 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」, 「방문판매 등에 관한 법률」, 「소비자기본법」 등 관련 법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.</p>
                    <p>④ “몰”이 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현행 약관과 함께 몰의 초기화면에 그 적용일자 7일 이전부터 적용일자 전일까지 공지합니다. 다만, 이용자에게 불리하게 약관 내용을 변경하는 경우에는 최소한 30일 이상의 사전 유예기간을 두고 공지합니다. 이 경우 "몰“은 개정 전 내용과 개정 후 내용을 명확하게 비교하여 이용자가 알기 쉽도록 표시합니다.</p>
                    <p>⑤ “몰”이 약관을 개정할 경우에는 그 개정약관은 그 적용일자 이후에 체결되는 계약에만 적용되고 그 이전에 이미 체결된 계약에 대해서는 개정 전의 약관조항이 그대로 적용됩니다. 다만 이미 계약을 체결한 이용자가 개정약관 조항의 적용을 받기를 원하는 뜻을 제3항에 의한 개정약관의 공지기간 내에 “몰”에 송신하여 “몰”의 동의를 받은 경우에는 개정약관 조항이 적용됩니다.</p>
                    <p>⑥ 이 약관에서 정하지 아니한 사항과 이 약관의 해석에 관하여는 전자상거래 등에서의 소비자보호에 관한 법률, 약관의 규제 등에 관한 법률, 공정거래위원회가 정하는 전자상거래 등에서의 소비자 보호지침 및 관계법령 또는 상관례에 따릅니다</p>
                    <p>&nbsp;</p>
                    <p>제4조(서비스의 제공 및 변경)</p>
                    <p>① “몰”은 다음과 같은 업무를 수행합니다.</p>
                    <p>1) 재화 또는 용역에 대한 정보 제공 및 구매계약의 체결</p>
                    <p>2) 구매계약이 체결된 재화 또는 용역의 배송</p>
                    <p>3) 기타 “몰”이 정하는 업무</p>
                    <p>② “몰”은 재화 또는 용역의 품절 또는 기술적 사양의 변경 등의 경우에는 장차 체결되는 계약에 의해 제공할 재화 또는 용역의 내용을 변경할 수 있습니다. 이 경우에는 변경된 재화 또는 용역의 내용 및 제공일자를 명시하여 현재의 재화 또는 용역의 내용을 게시한 곳에 즉시 공지합니다.</p>
                    <p>③ “몰”이 제공하기로 이용자와 계약을 체결한 서비스의 내용을 재화 등의 품절 또는 기술적 사양의 변경 등의 사유로 변경할 경우에는 그 사유를 이용자에게 통지 가능한 주소로 즉시 통지합니다.</p>
                    <p><br></p>
                    <p>제5조(서비스의 중단)</p>
                    <p>① “몰”은 컴퓨터 등 정보통신설비의 보수점검·교체 및 고장, 통신의 두절 등의 사유가 발생한 경우에는 서비스의 제공을 일시적으로 중단할 수 있습니다.</p>
                    <p>② “몰”은 제1항의 사유로 서비스의 제공이 일시적으로 중단됨으로 인하여 이용자 또는 제3자가 입은 손해에 대하여 배상합니다. 단, “몰”이 고의 또는 과실이 없음을 입증하는 경우에는 그러하지 아니합니다.</p>
                    <p><br></p>
                    <p>제6조(회원가입)</p>
                    <p>① 이용자는 “몰”이 정한 가입 양식에 따라 회원정보를 기입한 후 이 약관에 동의한다는 의사표시를 함으로서 회원가입을 신청합니다.</p>
                    <p>② “몰”은 제1항과 같이 회원으로 가입할 것을 신청한 이용자 중 다음 각 호에 해당하지 않는 한 회원으로 등록합니다.</p>
                    <p>1) 등록 내용에 허위, 기재 누락, 오기가 있는 경우</p>
                    <p>2) 기타 회원으로 등록하는 것이 “몰”의 기술상 현저히 지장이 있다고 판단되는 경우</p>
                    <p>③ 회원은 회원가입 시 등록한 사항에 변경이 있는 경우, 지체 없이 “몰”에 대하여 회원정보 수정 등의 방법으로 그 변경사항을 알려야 합니다.</p>
                    <p><br></p>
                    <p>제7조(회원 탈퇴 및 자격 상실 등)</p>
                    <p>① 회원은 “몰”에 언제든지 탈퇴를 요청할 수 있으며 “몰”은 즉시 회원탈퇴를 처리합니다.</p>
                    <p>② 회원이 다음 각 호의 사유에 해당하는 경우, “몰”은 회원자격을 제한 및 정지시킬 수 있습니다.</p>
                    <p>1) 가입 신청 시에 허위 내용을 등록한 경우</p>
                    <p>2) “몰”을 이용하여 구입한 재화 등의 대금, 기타 “몰”이용에 관련하여 회원이 부담하는 채무를 기일에 지급하지 않는 경우</p>
                    <p>3) 다른 사람의 “몰” 이용을 방해하거나, “몰”의 회원 가입 시 타인의 정보를 도용한 것으로 확인 또는 의심되는 등 전자상거래 질서를 위협하는 경우</p>
                    <p>4) “몰”의 이용 과정에서 직원에게 폭언, 협박 또는 음란한 언행 및 기타 이에 준하는 행동으로 “몰”의 운영을 방해하는 경우</p>
                    <p>5) “몰”을 통하여 재화 등을 구매한 후 정당한 이유 없이 상습 또는 반복적으로 취소·반품하여 “몰”의 업무를 방해하는 경우</p>
                    <p>6) 부정한 용도 또는 재판매를 통해 영리를 추구할 목적으로 “몰”을 통해 재화 등을 중복 구매하는 등 “몰”의 거래 질서를 방해하는 경우</p>
                    <p>7) 무단으로 “몰”의 재화, 서비스, 기타 정보를 수집하거나 외부에 제출, 게시, 이용하여 “몰”의 저작권, 상표권 등 지식재산권을 침해하는 경우</p>
                    <p>8) “몰”을 이용하여 법령 또는 이 약관이 금지하는 행위를 하는 경우</p>
                    <p>③ “몰”이 회원 자격을 제한 및 정지시킨 후, 동일한 행위가 2회 이상 반복되거나 30일 이내에 그 사유가 시정되지 아니하는 경우 “몰”은 회원자격을 상실시킬 수 있습니다.</p>
                    <p>④ “몰”이 회원자격을 상실시키는 경우에는 회원등록을 말소합니다. 이 경우 회원에게 이를 통지하고, 회원등록 말소 전에 최소한 30일 이상의 기간을 정하여 소명할 기회를 부여합니다.</p>
                    <p><br></p>
                    <p>제8조(회원에 대한 통지)</p>
                    <p>① “몰”이 회원에 대한 통지를 하는 경우, 회원이 “몰”과 미리 약정하여 지정한 전자우편 주소로 할 수 있습니다.</p>
                    <p>② “몰”은 불특정다수 회원에 대한 통지의 경우 1주일이상 “몰” 게시판에 게시함으로써 개별 통지에 갈음할 수 있습니다. 다만, 회원 본인의 거래와 관련하여 중대한 영향을 미치는 사항에 대하여는 개별통지를 합니다.</p>
                    <p><br></p>
                    <p>제9조(주문 및 가격)</p>
                    <p>① “몰”에서 주문을 신청함으로써 이용자는 매매의 청약을 합니다.</p>
                    <p>② 주문 시의 가격은 주문 당일 “몰”에 명시되어 있는 가격으로 장바구니 상세 페이지에 제품에 대한 부가가치세가 포함되어있으나 배송비는 포함되지 않습니다. 주문 진행 시 결제 정보 입력 단계의 주문 상세 내역에 부가가치세와 배송비가 각기 별도 표기됩니다.</p>
                    <p>③총 주문 금액이 35,000원 미만일 경우 배송비(부가가치세 포함)가 발생되며, 총 주문 금액이 35,000원 이상 시에는 무료입니다. 일반 주문은 온라인에서 주문이 가능하며 온라인 주문은 제품을 장바구니에 담고 배송정보, 결제정보를 입력하여 주문하는 방법이며 주문 완료 후 바로 출고 준비가 진행됩니다.&nbsp;<span style="font-size:10.0pt;line-height:107%;font-family:'맑은 고딕';">제주도 및 도서산간 지역에 대해서는 추가 운임이 발생할 수 있으며 결제 시 추가 금액 확인이 가능합니다.</span></p>
                    <p><br></p>
                    <p>제10조(계약의 성립)</p>
                    <p>① “몰”은 합리적인 사유가 있는 경우 제9조와 같은 주문 신청을 승낙하지 않을 수 있습니다.</p>
                    <p>② “몰”의 승낙이 제12조 제1항의 수신확인통지형태로 이용자에게 도달한 시점에 계약이 성립한 것으로 보고, 그 전까지는 계약이 성립하지 않습니다.</p>
                    <p><br></p>
                    <p>제11조(지급방법)</p>
                    <p>“몰”에서 구매한 재화 또는 용역에 대한 대금지급방법은 다음 각 호의 방법 중 가용한 방법으로 할 수 있습니다.</p>
                    <p>1) 선불카드, 직불카드, 신용카드 등의 각종 카드 결제 (즉시 처리되며 처리 내역은 보안을 위해 암호화됩니다.)</p>
                    <p>2) 간편결제</p>
                    <p><br></p>
                    <p>제12조(수신확인통지, 주문 변경 및 취소)</p>
                    <p>① “몰”은 이용자의 주문이 있는 경우 이용자에게 수신확인통지를 합니다.</p>
                    <p>② 수신확인통지를 받은 이용자는 의사표시의 불일치 등이 있는 경우에는 수신확인통지를 받은 후 즉시 주문 변경 및 취소를 요청할 수 있고 “몰”은 배송 전에 이용자의 요청이 있는 경우에는 지체 없이 그 요청에 따라 처리하여야 합니다. 다만 이미 대금을 지불한 경우에는 제15조의 청약철회 등에 관한 규정에 따릅니다.</p>
                    <p>③ “몰”은 이용자의 주문 신청 및 대금 결제과정에서 ‘기술적인 오류’ 또는 ‘비정상적 거래’에 의하여 부당한 이득을 취하는 등 통상적인 전자상거래 관행에 부합하지 않는 거래가 있음을 알게 된 경우, 이를 이용자에게 고지하고 주문 신청을 승인하지 않거나 수신확인통지를 철회하여 계약을 취소할 수 있습니다. 이 경우 이용자는 수령한 재화 등을 “몰”의 요청에 따라 반환하여야 하고, “몰”은 이용자로부터 재화 등을 반환 받은 경우 3영업일 이내에 이미 지급받은 재화 등의 대금을 환급합니다.</p>
                    <p><br></p>
                    <p>제13조(재화 등의 배송)</p>
                    <p>① “몰”은 계약이 성립된 재화 등을 이용자가 주문할 때 명시한 배송지로 배송합니다. 단 배송지는 대한민국 내로 제한됩니다.</p>
                    <p>② 이용자와 재화 등의 공급시기에 관하여 별도의 약정이 없는 이상, 이용자가 청약을 한 날부터 영업일 기준 3일 이내에 재화 등을 배송할 수 있도록 주문제작, 포장 등 기타의 필요한 조치를 취합니다. 다만, 오후 5시 이전 신청된 주문은 당일 출고되며, 배송이 시작된 이후에 이용자가 단순변심에 의한 청약철회 시 반송비를 부담하게 될 수 있습니다.[KS3]</p>
                    <p><br></p>
                    <p>제14조(검수)</p>
                    <p>① 이용자는 주문한 재화 등을 수령한 후 지체 없이 그 수량 및 상태를 확인해야 합니다.</p>
                    <p>② 위와 같은 확인 결과 재화 등이 훼손 또는 누락된 경우 “몰”에 8일 이내에 알리면 제15조와 별도로 동일한 제품으로 교환 받거나 환불 받을 수 있습니다.</p>
                    <p><br></p>
                    <p>제15조(청약철회 등)</p>
                    <p>① 이용자는 「전자상거래 등에서의 소비자보호에 관한 법률」 제13조 제2항에 따른 계약내용에 관한 서면을 받은 날(그 서면을 받은 때보다 재화 등의 공급이 늦게 이루어진 경우에는 재화 등을 공급받거나 재화 등의 공급이 시작된 날을 말합니다)부터 7일 이내에는 청약의 철회를 할 수 있습니다. 다만, 청약철회에 관하여 「전자상거래 등에서의 소비자보호에 관한 법률」에 달리 정함이 있는 경우에는 동 법 규정에 따릅니다.</p>
                    <p>② 이용자는 재화 등을 배송 받은 경우 다음 각 호의 1에 해당하는 경우에는 반품 및 교환을 할 수 없습니다.</p>
                    <p>1) 이용자에게 책임 있는 사유로 재화 등이 멸실 또는 훼손된 경우 (다만, 재화 등의 내용을 확인하기 위하여 포장 등을 훼손한 경우에는 청약철회를 할 수 있습니다)</p>
                    <p>2) 이용자의 사용 또는 일부 소비에 의하여 재화 등의 가치가 현저히 감소한 경우</p>
                    <p>3) 시간의 경과에 의하여 재판매가 곤란할 정도로 재화 등의 가치가 현저히 감소한 경우</p>
                    <p>4) 동일 성능의 재화 등으로 복제 가능한 경우 그 원본인 재화 등 포장을 훼손한 경우</p>
                    <p>③ 이용자는 제1항 및 제2항의 규정에 불구하고 재화 등의 내용이 표시·광고 내용과 다르거나 계약내용과 다르게 이행된 때에는 당해 재화 등을 공급받은 날부터 3월 이내, 그 사실을 안 날 또는 알 수 있었던 날부터 30일 이내에 청약철회 등을 할 수 있습니다.</p>
                    <p><br></p>
                    <p>제16조(청약철회 등의 효과)</p>
                    <p>① “몰”은 이용자로부터 재화 등을 반환 받은 경우 3영업일 이내에 이미 지급받은 재화 등의 대금을 환급합니다. 이 경우 “몰”이 이용자에게 재화 등의 환급을 지연한 때에는 그 지연기간에 대하여 「전자상거래 등에서의 소비자보호에 관한 법률 시행령」 제21조의2에서 정하는 지연이자율을 곱하여 산정한 지연이자를 지급합니다.</p>
                    <p>② “몰”은 위 대금을 환급함에 있어서 이용자가 신용카드 등의 결제수단으로 재화 등의 대금을 지급한 때에는 지체 없이 당해 결제수단을 제공한 사업자로 하여금 재화 등의 대금의 청구를 정지 또는 취소하도록 요청합니다.</p>
                    <p>③ 청약철회 등의 경우 공급받은 재화 등의 반환에 필요한 비용은 이용자가 부담합니다. “몰”은 이용자에게 청약철회 등을 이유로 위약금 또는 손해배상을 청구하지 않습니다. 다만 재화 등의 내용이 표시·광고 내용과 다르거나 계약내용과 다르게 이행되어 청약철회 등을 하는 경우 재화 등의 반환에 필요한 비용은 “몰”이 부담합니다.</p>
                    <p><br></p>
                    <p>제17조(개인정보보호)</p>
                    <p>① “몰”은 이용자의 개인정보 처리 시 관련 법령을 준수합니다.</p>
                    <p>② 이용자의 개인정보 처리에 관하여는 “몰”에 별도로 공개되는 개인정보 처리방침이 적용됩니다.</p>
                    <p><br></p>
                    <p>제18조(회원의 비밀번호에 대한 의무)</p>
                    <p>① 비밀번호에 관한 관리책임은 회원에게 있습니다.</p>
                    <p>② 회원은 자신의 비밀번호를 제3자와 공유하거나 이용하게 해서는 안됩니다.</p>
                    <p>③ 회원이 자신의 비밀번호를 도난당하거나 제3자가 사용하고 있음을 인지한 경우에는 바로 “몰”에 통보하고 “몰”의 안내가 있는 경우에는 그에 따라야 합니다.</p>
                    <p><br></p>
                    <p>제19조(이용자의 의무)</p>
                    <p>이용자는 다음 행위를 하여서는 안 됩니다.</p>
                    <p>1) 신청 또는 변경 시 허위 내용의 등록</p>
                    <p>2) 타인의 정보 도용</p>
                    <p>3) “몰”에 게시된 정보의 변경</p>
                    <p>4) “몰”이 정한 정보 이외의 정보(컴퓨터 프로그램 등) 등의 송신 또는 게시</p>
                    <p>5) “몰” 기타 제3자의 저작권 등 지식재산권에 대한 침해</p>
                    <p>6) “몰” 기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위</p>
                    <p><br></p>
                    <p>제20조(책임의 한계)</p>
                    <p>① “몰”에 게시된 재화 등의 묘사 및 기술하는 사진과 텍스트는 계약의 구속을 받지 않으며 오직 정보제공의 목적으로만 제공되며, “몰”은 그 사진이나 텍스트에 오류 또는 누락이 있을 경우 책임을 지지 않습니다.</p>
                    <p>② “몰”이 재화 등을 발송하는 국가와 도착하는 국가가 다를 경우 “몰”은 재화 등이 배송지 국가의 법과 규제를 준수하지 않거나 전력 및 다른 제품호환성에 문제가 있더라도 책임을 지지 않습니다.</p>
                    <br><br>
                    <p>제21조(저작권의 귀속 및 이용제한)</p>
                    <p>① “몰“이 작성한 저작물에 대한 저작권 기타 지식재산권은 ”몰“에 귀속합니다.</p>
                    <p>② 이용자는 “몰”을 이용함으로써 얻은 정보 중 “몰”에게 지식재산권이 귀속된 정보를 “몰”의 사전 승낙 없이 복제, 송신, 출판, 배포, 방송 기타 방법에 의하여 영리목적으로 이용하거나 제3자에게 이용하게 하여서는 안됩니다.</p>
                    <p>③ “몰”은 약정에 따라 이용자에게 귀속된 저작권을 사용하는 경우 당해 이용자에게 통보하여야 합니다.</p>
                    <p><br></p>
                    <p>제22조(불가항력)</p>
                    <p>① “몰”은 이 약관상 의무를 이행하기 위한 모든 합리적인 노력을 다할 것이나, 합리적인 통제를 벗어난 상황에 의해 발생한 배송 지연이나 배송 실패에 관해서는 책임을 지지 않습니다. 이러한 상황에는 파업, 전쟁, 자연재해 또는 상품의 생산, 운송, 배송을 불가능하게 만드는 기타 상황들이 있습니다.</p>
                    <p>② 제1항과 같은 경우에도 “몰”은 합리적으로 가능한 신속하게 의무를 이행할 것이며, 공정하고 합리적인 방법으로 이용자들에게 남아있는 재화 등의 공급을 할당하고자 최선의 노력을 다합니다.</p>
                    <p><br></p>
                    <p>제23조(재판권 및 준거법)</p>
                    <p>① “몰”과 이용자 간에 발생한 전자상거래 분쟁에 관한 소송은 제소 당시의 이용자의 주소에 의하고, 주소가 없는 경우에는 거소를 관할하는 지방법원의 전속관할로 합니다. 다만, 제소 당시 이용자의 주소 또는 거소가 분명하지 않거나 외국 거주자의 경우에는 민사소송법상의 관할법원에 제기합니다.</p>
                    <p>② 본 약관의 준거법은 한국법입니다.</p>
                    <p><br></p>
                    <p>제24조 (부칙)</p>
                    <p>본 판매약관은 2024년 8월 1일부터 적용 됩니다.</p>

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
                        <a href="bluebottlecoffee_location-Korea.jsp" class="text-decoration-none"><p class="mb-1">커리어</p></a>
                    </div>
                    <!-- 두 번째 열 -->
                    <div>
                        <h6 class="fw-bold mb-3">알아보기</h6>
                        <a href="bluebottlecoffee_pages_about-us.jsp" class="text-decoration-none"><p class="mb-1">브랜드 소개</p></a>
                        <a href="#" class="text-decoration-none"><p class="mb-1">블루보틀 커피</p></a>
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