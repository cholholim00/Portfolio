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
    <link rel="stylesheet" href="./bluebottlecoffee_account_register.css">
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

    
    
    
    
    <div class="customer-container">
        <div class=customer-join>
            <form action="registerProcess.jsp" method="post" name="join">
                    <div class="title-text">
                        <p class="p-title">회원 가입</p>
                    </div> 
                    <div class="sub-text">
                        <span>블루보틀 공식 온라인 스토어 회원 가입을 환영합니다.</span> <br>
                        <span>*표시된 필수항목 입력과 이용약관에 동의해주시기 바랍니다.</span> <br>
                    </div>   
                <div class="form-floating mb-3 mt-3">
				    <input type="text" name="name_list1" class="form-control" id="floatingLastName" placeholder="성 (Last name) *" >
				    <label for="floatingLastName">성 (Last name) *</label>
					<div id="error-message-5" class="error-message"  style="color: rgb(189, 61, 68); display:none;  font-size:10px">
				    필수 입력 항목입니다.
					</div>
				</div>
				
				<div class="form-floating mb-3">
				    <input type="text" name="name_list2" class="form-control" id="floatingFirstName" placeholder="이름 (First name) *" >
				    <label for="floatingFirstName">이름 (First name) *</label>
				    <div id="error-message-6" class="error-message" style="color: rgb(189, 61, 68); display:none;  font-size:10px">
				    	필수 입력 항목입니다.
					</div>
				</div>
	
				
				<div class="form-floating mb-3">
				    <input type="email" name="email_list" class="form-control" id="floatingEmail" placeholder="이메일 주소 *" >
				    <label for="floatingEmail">이메일 주소 *</label>
				    <div id="error-message-7" class="error-message"  style="color: rgb(189, 61, 68); display:none;  font-size:10px">
				    	필수 입력 항목입니다.
					</div>
				</div>
				
				<div class="form-floating mb-3">
				    <input type="tel" name="phone_list" class="form-control" id="floatingTel" placeholder="전화번호 *" >
				    <label for="floatingTel">전화번호 *</label>
				    <div id="error-message-8" class="error-message"  style="color: rgb(189, 61, 68); display:none;  font-size:10px">
				    	필수 입력 항목입니다.
					</div>
				</div>

				
				<div class="form-floating mb-3">
				    <input type="password" name="pwd_list1" class="form-control" id="floatingPassword" placeholder="비밀번호 *" >
				    <label for="floatingPassword">비밀번호 *</label>
				    <div id="error-message-9" class="error-message"  style="color: rgb(189, 61, 68); display:none;  font-size:10px">
					    필수 입력 항목입니다.
					</div>
				</div>

				
				<div class="form-floating">
				    <input type="password" name="pwd_list2" class="form-control" id="floatingPasswordConfirm" placeholder="비밀번호 확인 *" >
				    <label for="floatingPasswordConfirm">비밀번호 확인 *</label>
				    <div id="error-message-10" class="error-message"  style="color: rgb(189, 61, 68); display:none;  font-size:10px">
					    필수 입력 항목입니다.
					</div>
				</div>

                

                <p class="p-text mt-5">* 표시된 항목은 필수 입력 항목 입니다.</p>
                <input type="checkbox" id="all_Check" class="custom-checkbox" name="check_all">
                <label for="all_Check">모든 약관에 동의합니다</label>

                <hr>



                <div class="card-check mt-2">
                    <input type="checkbox" id="one_Check" class="custom-checkbox  required-check" name="check_box1">
                    <label for="one_Check">
                        <a href="bluebottle_policies_terms-of-service.jsp" class="terms-link">이용약관</a>에 동의합니다*
                    </label>
                    <div id="error-message-1" class="error-message"  style="color: rgb(189, 61, 68); display:none; margin-top: 10px; font-size:10px">
		            필수 입력 항목입니다.
		        	</div>

                    <br>

                    <input type="checkbox" id="two_Check" class="custom-checkbox  required-check" name="check_box2">
                    <label for="two_Check">
                        <a href="bluebottlecoffee_pages_sign-up-personal-info-agreement.jsp" class="terms-link">개인 정보 수집 및 이용</a>에 동의합니다*
                    </label>
					<div id="error-message-2" class="error-message" style="color: rgb(189, 61, 68); display:none; margin-top: 10px; font-size:10px">
		            필수 입력 항목입니다.
		        	</div>
                    <br>

                    <input type="checkbox" id="three_Check" class="custom-checkbox  required-check" name="check_box3">
                    <label for="three_Check">
                        <a href="bluebottlecoffee_pages_sign-uppersonal.jsp" class="terms-link">개인 정보 처리 위탁</a>에 동의합니다*
                    </label>
					<div id="error-message-3" class="error-message"  style="color: rgb(189, 61, 68); display:none; margin-top: 10px; font-size:10px">
		            필수 입력 항목입니다.
		        	</div>
                    <br>

                    <input type="checkbox" id="four_Check" class="custom-checkbox  required-check"  name="check_box4">
                    <label for="four_Check">
                        <a href="bluebottlecoffee_pages_sign-up-transfer.jsp" class="terms-link">개인정보 국외 이전</a>에 동의합니다*
                    </label>
					<div id="error-message-4" class="error-message" style="color: rgb(189, 61, 68); display:none; margin-top: 10px; font-size:10px">
		            필수 입력 항목입니다.
		        	</div>
                    <br>

                    <input type="checkbox" id="five_Check" class="custom-checkbox" name="check_box5">
                    <label for="five_Check">
                        <a href="bluebottlecoffee_pages_sign-up-email-mms-agreement.jsp" class="terms-link">마케팅 활용 동의</a>/ 쿠폰 수신 (이메일) (선택)
                    </label>

                    <br>

                    <input type="checkbox" id="six_Check" class="custom-checkbox" name="check_box6">
                    <label for="six_Check">
                        <a href="bluebottlecoffee_pages_sign-up-email-mms-agreement.jsp" class="terms-link">마케팅 활용 동의</a>/ 쿠폰 수신 (SMS) (선택)
                    </label>
                </div>
				
                <input type="submit" class="btn btn-primary mt-5" value="가입하기" name="join_btn">

            </form>
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
    
    <script>
    document.addEventListener("DOMContentLoaded", function () {
        const form = document.forms["join"];
        const requiredChecks = document.querySelectorAll(".required-check");

        const inputs = [
            form["name_list1"],
            form["name_list2"],
            form["email_list"],
            form["phone_list"],
            form["pwd_list1"],
            form["pwd_list2"]
        ];

        const errorMessages = [
            document.getElementById("error-message-5"),
            document.getElementById("error-message-6"),
            document.getElementById("error-message-7"),
            document.getElementById("error-message-8"),
            document.getElementById("error-message-9"),
            document.getElementById("error-message-10")
        ];

        const checkErrorMessages = [
            document.getElementById("error-message-1"),
            document.getElementById("error-message-2"),
            document.getElementById("error-message-3"),
            document.getElementById("error-message-4")
        ];

        const allCheckBox = form["check_all"];

        allCheckBox.addEventListener("change", function () {
            const checked = this.checked;
            requiredChecks.forEach(chk => chk.checked = checked);
            form["check_box5"].checked = checked; 
            form["check_box6"].checked = checked;
        });

        requiredChecks.forEach(chk => {
            chk.addEventListener("change", function () {
                if (!this.checked) {
                    allCheckBox.checked = false;
                } else {
                    const allChecked = Array.from(requiredChecks).every(chk => chk.checked);
                    allCheckBox.checked = allChecked;
                }
            });
        });

        form.addEventListener("submit", function (event) {
            let isValid = true;

            inputs.forEach((input, index) => {
                if (!input.value.trim()) {
                    errorMessages[index].style.display = "block";
                    isValid = false;
                } else {
                    errorMessages[index].style.display = "none";
                }
            });

            if (inputs[4].value.trim() && inputs[5].value.trim() && inputs[4].value !== inputs[5].value) {
                errorMessages[5].textContent = "비밀번호가 일치하지 않습니다.";
                errorMessages[5].style.display = "block";
                isValid = false;
            } else if (inputs[5].value.trim()) {
                errorMessages[5].style.display = "none";
                errorMessages[5].textContent = "필수 입력 항목입니다.";
            }

            requiredChecks.forEach((chk, idx) => {
                if (!chk.checked) {
                    checkErrorMessages[idx].style.display = "block";
                    isValid = false;
                } else {
                    checkErrorMessages[idx].style.display = "none";
                }
            });

            if (!isValid) {
                event.preventDefault();
            }
        });
    });

</script>

  </body>
</html>