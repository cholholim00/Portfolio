<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>블루보틀 홍대 카페</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <!-- Noto Sans-->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
    <!-- Noto Sans-->
    <link rel="stylesheet" href="./main.css">
    <link rel="stylesheet" href="./cafe-inf.css">
    <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=bqm03dpk28"></script>
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
                        <a class="navbar-brand" href="#">
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
                            <a class="nav-link active" href="#">
                                <svg xmlns="http://www.w3.org/2000/svg" width="23" height="23" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
                                <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
                                </svg>
                            </a>
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



    <div class="container-fluid py-5 px-lg-5 px-4 nt_font">
        <div class="row align-items-start text-lg-start text-center">
            <div class="col-12 col-lg-6 mb-4 headline px-5">
                <h1>블루보틀 홍대 카페</h1> 
            </div>
            <div class="col-12 col-lg-6 body-article pt-5 px-4">
                <div class="row flex-column flex-md-row">
                    <div class="col-12 col-lg-6">
                        <strong class="mb-2">주소</strong>
                        <p class="mb-2">서울시 마포구 양화로 130 라이즈 호텔 1층 로비</p>
                    </div>
                    <div class="col-12 col-lg-6">
                        <strong class="mb-2">운영시간</strong>
                        <p class="mb-3">매일 07:30 - 21:00</p>
                    </div>
                </div>
                <a href="https://naver.me/xcJw2XV7" class="location-link">
                    <img src="../images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                </a>
            </div>

            <div class="py-3 py-lg-5"></div>  <!-- 패딩 -->

            <div class="row map-container mt-4 g-0 pb-5 px-lg-4 px-1">

                <div class="col-12 col-lg-7 map-box">
                    <div id="map"></div>
                </div>

                <div class="d-none d-lg-block col-lg-1"></div> <!-- 중간 여백 -->
                
                <div class="col-12 col-lg-4">
                    <div class="map-article py-2">
                       <p class="pb-3 text-start">
				                            라이즈 호텔 1층에 자리한 홍대 카페는 홍대 커뮤니티와 여행객들에게 쉼의 공간을 선물합니다. 
				                            블루보틀의 브랜드 철학과 직접 로스팅한 원두로 내린 다양한 커피와 페어링하기 좋은 디저트 메뉴, 다양한 MD상품을 만나보세요.
                        </p>
                        <a href="https://naver.me/xcJw2XV7" class="N-link">지도 보기</a>
                    </div>
                </div>
            </div>
            <div class="py-3 py-lg-5"></div>  <!-- 패딩 -->
            <!-- /* 카페상세 이미지 */ -->
            <div class="row cafe-img mb-4 px-lg-5 px-1 g-0">
                <div class="img-box col-12 my-lg-5 mt-5">
                    <img src="images/beulruboteul-hongdae-kape/img01.webp">
                </div>
                <div class="img-box col-12 my-5">
                    <img src="images/beulruboteul-hongdae-kape/img02.webp">               
                </div>
            </div>
            <div class="py-3 py-lg-5"></div>  <!-- 패딩 -->
            <h2 class="headlineH2 my-5 px-4 text-lg-start text-center">블루보틀 카페</h2>
            
			<!-- 이미지 카드 슬라이드 -->
			<%@ include file="cafe-slider.jsp" %>

        </div>
    </div>
    
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


    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
    <script src="./cafe-inf.js"></script>
    <script>
		var map = new naver.maps.Map('map', {
		    center: new naver.maps.LatLng(37.5543349117636, 126.921207395382), // 홍대 좌표
		    zoom: 17,
		    mapTypeControl: false,
		    mapTypeId: naver.maps.MapTypeId.NORMAL
		});
		var marker = new naver.maps.Marker({
		    position: new naver.maps.LatLng(37.5543349117636, 126.921207395382),
		    map: map,
		    title: "블루보틀 홍대 카페",
		    icon: {
		    	url: 'mapIcon.png',
		    	size: new naver.maps.Size(40, 40),
		    	anchor: new naver.maps.Point(20, 40)
		    }
		});
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
</body>
</html>