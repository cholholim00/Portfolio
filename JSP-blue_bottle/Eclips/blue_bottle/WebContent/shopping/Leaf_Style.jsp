<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>


<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>블루보틀-라이프 스타일</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="All_coffee.css">
    <link rel="stylesheet" href="./search.css">
    <!-- <link rel="stylesheet" href="./main3.css">
    <link rel="stylesheet" href="./main4.css"> -->
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        .side-bar-container {
            position: fixed;
            top: 0;
            left: -500px; /* 처음엔 화면 밖에 위치 */
            transition: left 0.3s ease;
            background-color: white;
            width: 500px;
            height: 100vh;
            z-index: 999;
        }
        .side-bar-container.active {
            left: 0;  /* active 클래스가 붙으면 화면에 보임 */
        }

        .side-bar-sub {
            margin-top: 180px;
        }

        .close-btn {
            border: 0;
            background-color: inherit;
            position: absolute;
            right: 20px;
            top: 5rem;
            padding: 10px;
        }

        .side-bar-sub ul,li {
            list-style: none none;
        }

        .side-bar-sub a {
            color: black;

        }

        .side-bar-ul li {
            cursor: pointer;
            display: flex;
            align-items: center;
            padding: 10px 30px;
        }

        .side-bar-ul li>p {
            font-size: 0.9rem;
            margin-bottom: 0;
        }

        .side-bar-ul li> p:hover {
            border-bottom: 1px solid black;
        }

    </style>
</head>
<body style="background-color: white;">
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
                        <a class="nav-link active" href="bestseller.jsp">베스트셀러</a>
                    </li>
                    <li class="nav-item me-3">
                        <a class="nav-link active" href="sets.jsp">세트</a>
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
                        <img src="./Link_img/logo2.png" alt="" width="20%">
                    </a>
                </ul>

                <ul class="navbar-nav ms-auto me-4 mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link active" href="#">
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
<div class="side-bar-container">
    <div class="side-bar-sub">
        <button class="close-btn">
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon icon-close drawer-toggle">
                <g id="close X">
                    <rect id="Rectangle 13" y="13.125" width="18.5616" height="1.23744" transform="rotate(-45 0 13.125)" fill="#333333"></rect>
                    <rect id="Rectangle 14" x="0.875" width="18.5616" height="1.23744" transform="rotate(45 0.875 0)" fill="#333333"></rect>
                </g>
            </svg>
        </button>
        <ul class="side-bar-ul">
            <a href="../shopping/coffee.jsp"><li><p>커피</p></li></a>
            <a href="../shopping/Cup&Tumbler.jsp"><li><p>컵과 텀블러</p></li></a>
            <a href="../shopping/Brewing_Tools.jsp"><li><p>브루잉 도구</p></li></a>
            <a href="../shopping/Leaf_Style.jsp"><li><p>라이프 스타일</p></li></a>
        </ul>
    </div>
</div>

<!-- 메인 이미지 배너 영역 -->
<div class="main-banner">
    <!-- 메인 이미지 -->
    <img src="./images/라이프스타일 메인.jpg" class="img-fluid" alt="메인 이미지">

    <!-- 메인 이미지 위에 배치되는 텍스트 -->
    <div class="banner-text">라이프 스타일</div>
</div>
<br><br>
<!-- 커피 9가지 상품 목록 -->
<div class="my_favorite">
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <div class="col" style="height: 580px;">
                <a href="../products/life_embroidered-eco-bag-blue-bottle.jsp" class="text-decoration-none text-reset">
                    <div class="card my_card h-100 position-relative overflow-hidden">
                        <div class="image-wrapper">
                            <img src="./images/D1_Main_1600x1600_EmbroideredTote_BBC.webp" class="card-img-top base-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                            <img src="./images/D1_Sub-Hover_EmbroideredTote_BBC.webp" class="card-img-top hover-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                        </div>
                        <div class="overlay-text text-center">
                            <p class="fw-bold mb-0">엠브로이더리 에코 백 -블루보틀-</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col" style="height: 580px;">
                <a href="../products/life-coffeetruck-key-chain.jsp" class="text-decoration-none text-reset">
                    <div class="card my_card h-100 position-relative overflow-hidden">
                        <div class="image-wrapper">
                            <img src="./images/1600x1600.webp" class="card-img-top base-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                            <img src="./images/1000x1250_fb8fe61e-2465-4ce0-b3b0-19e62ae0b9a4.webp" class="card-img-top hover-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                        </div>
                        <div class="overlay-text text-center">
                            <p class="fw-bold mb-0">커피트럭 키 체인</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col" style="height: 580px;">
                <a href="../products/life-blue-bottle-apolis-lunch-bag.jsp" class="text-decoration-none text-reset">
                    <div class="card my_card h-100 position-relative overflow-hidden">
                        <div class="image-wrapper">
                            <img src="./images/D1_1600x1600_20250116.webp" class="card-img-top base-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                            <img src="./images/D1_1000x1250_20250116-2.webp" class="card-img-top hover-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                        </div>
                        <div class="overlay-text text-center">
                            <p class="fw-bold mb-0">런치백</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col" style="height: 580px;">
                <a href="../products/life-blue-bottle-apolis-market-bag.jsp" class="text-decoration-none text-reset">
                    <div class="card my_card h-100 position-relative overflow-hidden">
                        <div class="image-wrapper">
                            <img src="./images/MarketBag_01_1600x1600_4c38f0a0-4e7d-4b89-88cd-51854d785762.webp" class="card-img-top base-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                            <img src="./images/MarketBag_02_1600x1600_999945ce-5bfa-4aae-9da5-26e71d6cf0c4.webp" class="card-img-top hover-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                        </div>
                        <div class="overlay-text text-center">
                            <p class="fw-bold mb-0">마켓백</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col" style="height: 580px;">
                <a href="../products/life-gray-cooler-bag.jsp" class="text-decoration-none text-reset">
                    <div class="card my_card h-100 position-relative overflow-hidden">
                        <div class="image-wrapper">
                            <img src="./images/240703_Gray-Cooler-Bag_1.webp" class="card-img-top base-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                            <img src="./images/20240729_1000x1250px_240711-Gray-Cooler-Bag-1.webp" class="card-img-top hover-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                        </div>
                        <div class="overlay-text text-center">
                            <p class="fw-bold mb-0">그레이 코튼 쿨러백</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col" style="height: 580px;">
                <a href="../products/life-seoul-tote-bag.jsp" class="text-decoration-none text-reset">
                    <div class="card my_card h-100 position-relative overflow-hidden">
                        <div class="image-wrapper">
                            <img src="./images/240705_Seoul-Tote-Bag.webp" class="card-img-top base-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                            <img src="./images/20240729_1000x1250px_240711-Seoul-Tote-Bag-1.webp" class="card-img-top hover-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                        </div>
                        <div class="overlay-text text-center">
                            <p class="fw-bold mb-0">서울 토트백</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col" style="height: 580px;">
                <a href="../products/life-stone-plate.jsp" class="text-decoration-none text-reset">
                    <div class="card my_card h-100 position-relative overflow-hidden">
                        <div class="image-wrapper">
                            <img src="./images/M1_MoheimStonePlate_Hero.webp" class="card-img-top base-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                            <img src="./images/Hover_MoheimStonePlate_0fea9d08-2905-46c8-9bfb-eb71239deb10.webp" class="card-img-top hover-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                        </div>
                        <div class="overlay-text text-center">
                            <p class="fw-bold mb-0">스톤 플레이트</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col" style="height: 580px;">
                <a href="../products/life_embroidered-eco-bag-coffee-leaves.jsp" class="text-decoration-none text-reset">
                    <div class="card my_card h-100 position-relative overflow-hidden">
                        <div class="image-wrapper">
                            <img src="./images/M1_EmbroideredTote_Hero.webp" class="card-img-top base-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                            <img src="./images/Hover_EmbroideredTote_2a8ef12a-a809-4bb9-8530-2d909f6377d6.webp" class="card-img-top hover-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                        </div>
                        <div class="overlay-text text-center">
                            <p class="fw-bold mb-0">엠브로이더리 에코 백 -커피 리프-</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col" style="height: 580px;">
                <a href="../products/life_blue-bottle-kiyosumi-tote-10th-anniversary-edition.jsp" class="text-decoration-none text-reset">
                    <div class="card my_card h-100 position-relative overflow-hidden">
                        <div class="image-wrapper">
                            <img src="./images/241213_BBCJ0172_pre-edited_1600x1600_801fcd32-d4fd-4a57-8b7f-6cece3f0edab.webp" class="card-img-top base-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                            <img src="./images/241213_BBCJ0047_pre_D2_MO.webp" class="card-img-top hover-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                        </div>
                        <div class="overlay-text text-center">
                            <p class="fw-bold mb-0">키요스미 토트백 10주년 에디션</p>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div><br><br>


<!-- 푸터 -->
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

<!-- 이미지 적용 기능(호버) -->
<script>
    function changeImage(id, mode) {
        const img = document.getElementById(id);
        if (!img) return;

        const hoverSrc = img.getAttribute("data-hover");
        const defaultSrc = img.getAttribute("data-default");

        img.src = mode === 'hover' ? hoverSrc : defaultSrc;
    }
</script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const sidebar = document.querySelector('.side-bar-container');
        const closeBtn = document.querySelector('.close-btn');
        const shoppingMenu = document.querySelectorAll('.nav-link')[0]; // 첫 번째 nav-link가 쇼핑

        shoppingMenu.addEventListener('click', function(e) {
            e.preventDefault();
            sidebar.classList.add('active');
            document.body.style.overflow = 'hidden'; // 스크롤 막기
        });

        closeBtn.addEventListener('click', function() {
            sidebar.classList.remove('active');
            document.body.style.overflow = ''; // 스크롤 다시 허용
        });
    });
</script>
</body>
</html>
