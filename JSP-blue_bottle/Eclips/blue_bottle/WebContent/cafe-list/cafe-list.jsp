<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>블루보틀 카페</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Noto Sans-->
    <link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
    <!-- Noto Sans-->
  <link rel="stylesheet" href="./main.css">
  <link rel="stylesheet" href="./cafe-list.css"/>
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
                            <a class="nav-link active" href="../Board/list2.jsp">블로그</a>
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


    <div class="container-fluid py-5 px-lg-5 px-4 nt_font mt-5">
        <h2 class="mb-5 text-lg-start px-1 headline">블루보틀 카페</h2>

        <div class="row row-cols-1 row-cols-sm-3 gy-5 px-2">
            <!-- 카드 시작 -->
            <div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/bluebottle-busan-gijang-cafe.jsp">
                            <img src="./images/cafe-list_img/cafe01.webp" alt="블루보틀 부산 기장 카페" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative text-start">
                        <strong class="d-block">블루보틀 부산 기장 카페</strong>
                        <p class="mb-1 address">부산 기장군 장안읍 정관로 1133 부산 프리미엄 아울렛 578호</p>
                        <p class="mb-2 hours">매일 10:30 - 21:00</p>
                        <a href="https://naver.me/F42yk6PB" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) -->
            <div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/blue-bottle-coffee-suwon-timevillas-pop-up.jsp">
                            <img src="./images/cafe-list_img/cafe03.webp" alt="블루보틀 수원 타임빌라스 팝업" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative">
                        <strong class="d-block">블루보틀 수원 타임빌라스 팝업</strong>
                        <p class="mb-1 address">경기 수원시 권선구 세화로 134 롯데몰수원 3층</p>
                        <p class="mb-2 hours">매일 10:30 - 22:00</p>
                        <a href="https://naver.me/F5D1o9r3" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) -->
            <div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/blue-bottle-busan-millak-cafe.jsp">
                            <img src="./images/cafe-list_img/cafe04.webp" alt="블루보틀 부산 민락 카페" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative">
                        <strong class="d-block">블루보틀 부산 민락 카페</strong>
                        <p class="mb-1 address">부산광역시 수영구 민락수변로 243 1, 4, 5층 (민락동)</p>
                        <p class="mb-2 hours">[4F] 매일 08:30 - 22:00 │ [1F] 매일 08:30 - 21:00</p>
                        <a href="https://naver.me/F0z2RkaA" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) -->
            <div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/bluebottle-samseong.jsp">
                            <img src="./images/cafe-list_img/cafe05.webp" alt="블루보틀 삼성 카페" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative">
                        <strong class="d-block">블루보틀 삼성 카페</strong>
                        <p class="mb-1 address">서울시 강남구 테헤란로 517 1층</p>
                        <p class="mb-2 hours">월-목: 08:00 - 20:00 │ 금-일: 08:00 - 20:30</p>
                        <a href="https://naver.me/FEU1wa1D" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) -->
            <div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/human-made-seoul-cafe-by-blue-bottle-coffee.jsp">
                            <img src="./images/cafe-list_img/cafe06.webp" alt="휴먼 메이드 서울 카페 바이 블루보틀 커피" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative">
                        <strong class="d-block">휴먼 메이드 서울 카페 바이 블루보틀 커피</strong>
                        <p class="mb-1 address">서울시 성동구 성수동2가 333-94</p>
                        <p class="mb-2 hours">매일 11:00 - 19:00</p>
                        <a href="https://naver.me/GL88ZWNO" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) -->
            <div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/beulruboteul-pangyo-kape.jsp">
                            <img src="./images/cafe-list_img/cafe07.webp" alt="블루보틀 판교 카페" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative">
                        <strong class="d-block">블루보틀 판교 카페</strong>
                        <p class="mb-1 address">경기 성남시 분당구 동판교로177번길 25</p>
                        <p class="mb-2 hours">매일 08:00 - 21:30</p>
                        <a href="https://naver.me/F9z8ITqR" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) -->
            <div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/bluebottle-yeonnam-cafe.jsp">
                            <img src="./images/cafe-list_img/cafe02.webp" alt="블루보틀 연남 카페" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative">
                        <strong class="d-block">블루보틀 연남 카페</strong>
                        <p class="mb-1 address">서울 마포구 성미산로32길 52 B1F - 1F</p>
                        <p class="mb-2 hours">매일 09:00 - 21:00</p>
                        <a href="https://naver.me/G4xNH4Bi" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) -->
            <div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/bluebottle-jamsil-cafe.jsp">
                            <img src="./images/cafe-list_img/cafe08.webp" alt="블루보틀 잠실 카페" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative">
                        <strong class="d-block">블루보틀 잠실 카페</strong>
                        <p class="mb-1 address">서울시 송파구 올림픽대로 300 롯데월드몰 1층</p>
                        <p class="mb-2 hours">매일 10:30 - 22:00</p>
                        <a href="https://naver.me/xguctD0a" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) -->
            <div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/beulruboteul-hongdae-kape.jsp">
                            <img src="./images/cafe-list_img/cafe09.webp" alt="블루보틀 홍대 카페" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative">
                        <strong class="d-block">블루보틀 홍대 카페</strong>
                        <p class="mb-1 address">서울시 마포구 양화로 130 라이즈 호텔 1층 로비</p>
                        <p class="mb-2 hours">매일 07:30 - 21:00</p>
                        <a href="https://naver.me/xcJw2XV7" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) -->
            <div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/bluebottle-myungdong-cafe.jsp">
                            <img src="./images/cafe-list_img/cafe10.webp" alt="블루보틀 명동 카페" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative">
                        <strong class="d-block">블루보틀 명동 카페</strong>
                        <p class="mb-1 address">서울 중구 명동길 14 1층</p>
                        <p class="mb-2 hours">평일: 07:30 - 22:00 │ 주말: 08:00 - 22:00</p>
                        <a href="https://naver.me/Fnm0NR77" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) -->
            <div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/bluebottle-jeju-cafe.jsp">
                            <img src="./images/cafe-list_img/cafe11.webp" alt="블루보틀 제주 카페" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative">
                        <strong class="d-block">블루보틀 제주 카페</strong>
                        <p class="mb-1 address">제주특별자치도 제주시 구좌읍 번영로 2133-30</p>
                        <p class="mb-2 hours">매일 08:00 - 19:00 (대설 및 태풍 등의 자연재해 시, 단축 영업 또는 임시 휴무)</p>
                        <a href="https://naver.me/5gF9Cqrf" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) -->
            <div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/bluebottle-yeouido-cafe.jsp">
                            <img src="./images/cafe-list_img/cafe12.webp" alt="블루보틀 여의도 카페" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative">
                        <strong class="d-block">블루보틀 여의도 카페</strong>
                        <p class="mb-1 address">서울 영등포구 여의대로 108 더현대서울점 5층</p>
                        <p class="mb-2 hours">평일: 10:30 - 21:00 │ 주말: 10:30 - 21:30 (백화점 휴점일 제외)</p>
                        <a href="https://naver.me/FQVGMUMz" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) -->
            <div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/bluebottle-gwanghwamoon-cafe.jsp">
                            <img src="./images/cafe-list_img/cafe13.webp" alt="블루보틀 광화문 카페" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative">
                        <strong class="d-block">블루보틀 광화문 카페</strong>
                        <p class="mb-1 address">서울 종로구 청계천로 11</p>
                        <p class="mb-2 hours">평일 07:30 - 20:00 │ 주말 08:00 - 20:30</p>
                        <a href="https://naver.me/xVBx9fpO" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) --><div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/bluebottle-hannam-cafe.jsp">
                            <img src="./images/cafe-list_img/cafe14.webp" alt="블루보틀 한남 카페" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative">
                        <strong class="d-block">블루보틀 한남 카페</strong>
                        <p class="mb-1 address">서울 용산구 한남대로 91</p>
                        <p class="mb-2 hours">평일: 09:00 - 20:30 │ 주말: 08:00 - 20:30</p>
                        <a href="https://naver.me/Fuz5m1sJ" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) -->
            <div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/bluebottle-apgujung-cafe.jsp">
                            <img src="./images/cafe-list_img/cafe15.webp" alt="블루보틀 압구정 카페" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative">
                        <strong class="d-block">블루보틀 압구정 카페</strong>
                        <p class="mb-1 address">서울 강남구 논현로 854</p>
                        <p class="mb-2 hours">평일: 07:30 - 21:00 │ 주말: 08:00 - 21:00</p>
                        <a href="https://naver.me/GWe2TZcS" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) -->
            <div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/bluebottle-yeoksam-cafe.jsp">
                            <img src="./images/cafe-list_img/cafe16.webp" alt="블루보틀 역삼 카페" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative">
                        <strong class="d-block">블루보틀 역삼 카페</strong>
                        <p class="mb-1 address">서울 강남구 테헤란로 129 강남N타워</p>
                        <p class="mb-2 hours">평일: 07:30 - 20:00 │ 주말: 08:00 - 20:30</p>
                        <a href="https://naver.me/F74VogQT" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) -->
            <div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/bluebottle-samchung-cafe.jsp">
                            <img src="./images/cafe-list_img/cafe17.webp" alt="블루보틀 삼청 카페" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative">
                        <strong class="d-block">블루보틀 삼청 카페</strong>
                        <p class="mb-1 address">서울 종로구 북촌로5길 76</p>
                        <p class="mb-2 hours">평일: 09:00 - 20:00 │ 주말: 09:00 - 20:30</p>
                        <a href="https://naver.me/FafyiH32" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) -->
            <div class="col">
                <div class="card-wrapper">
                    <div class="image-box">
                        <a href="locator/bluebottle-seongsu-cafe.jsp">
                            <img src="./images/cafe-list_img/cafe18.webp" alt="블루보틀 성수 카페" class="img-fluid"/>
                        </a>
                    </div>
                    <div class="body-article mt-3 position-relative">
                        <strong class="d-block">블루보틀 성수 카페</strong>
                        <p class="mb-1 address">서울특별시 성동구 아차산로 7</p>
                        <p class="mb-2 hours">매일 07:30 - 20:30</p>
                        <a href="https://naver.me/5XJIYguc" class="location-link">
                            <img src="./images/cafe-list_img/geo-alt.svg" width="9" height="14" alt="지도 아이콘"/> 지도
                        </a>
                    </div> 
                </div>
            </div>
            <!-- 카드 끝 (복사하여 추가 가능) -->
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

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    window.addEventListener('beforeunload', () => {
        localStorage.setItem('scrollY', window.scrollY);
    });

    window.addEventListener('load', () => {
        const scrollY = localStorage.getItem('scrollY');
        if (scrollY) {
        window.scrollTo(0, parseInt(scrollY, 10));
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
