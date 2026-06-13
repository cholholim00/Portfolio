<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
	request.setCharacterEncoding("UTF-8");

	String search = request.getParameter("search");
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try{
			String url = "jdbc:oracle:thin:@localhost:1521:xe";
			String id = "musthave";
			String pwd = "1234";
			Class.forName("oracle.jdbc.OracleDriver");
			conn = DriverManager.getConnection(url, id, pwd);
			
			String sql = "SELECT name,path,img_src1,img_src2 FROM product WHERE name LIKE ? AND name NOT IN('[사은품] 서울 토트백')";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"+search+"%");
			rs = pstmt.executeQuery();
			
			
		}catch(Exception e){
			System.out.println(e.getMessage());
		}

%>
    
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>search</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="./search.css">
    <!-- <link rel="stylesheet" href="./main3.css">
    <link rel="stylesheet" href="./main4.css"> -->
  </head>
  <body>

    <!-- 검색창 -->
    <form action="./search.jsp?search=" method="get">
	    <div class="mb-3 mt-4 d-flex align-items-center gap-2" style="margin-left: 180px;">
	        <a href="../main/index.jsp"><img src="./images/bbc_logo.webp" alt="" width="100px"></a>
	        <input type="text" class="form-control" placeholder="검색" name="search" style="height: 50px; width: 76%;">
	        <input type="submit" value="검색" class="btn btn-primary" style="height: 50px; width: 80px;">
	    </div>
    </form>
		
		<% if(search.isEmpty()){ %>
    <!-- 인기상품(검색X) -->
    <div class="my_favorite">
        <div class="mb-3 fw-bold" style="font-size: 25px;">인기상품</div>
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <div class="col" style="height: 580px;">
                <a href="../products/cup-lny-ceramic-cup.jsp" class="text-decoration-none text-reset">
                    <div class="card my_card h-100 position-relative overflow-hidden">
                        <div class="image-wrapper">
                            <img src="./images/M1_LNYJadeCup_Hero_02.webp" class="card-img-top base-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                            <img src="./images/Hover_LNYJadeCup.webp" class="card-img-top hover-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                        </div>
                        <div class="overlay-text text-center">
                            <p class="fw-bold mb-0">제이드 포셀린 라운드 컵</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col" style="height: 580px;">
                <a href="../products/cup-blue-bottle-coffee-tumbler.jsp" class="text-decoration-none text-reset">
                    <div class="card my_card h-100 position-relative overflow-hidden">
                        <div class="image-wrapper">
                            <img src="./images/D1_Main_1600x1600_f3f43bab-d63e-4688-adc1-d2a78a251312.webp" class="card-img-top base-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                            <img src="./images/D1_Sub-Hover.webp" class="card-img-top hover-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                        </div>
                        <div class="overlay-text text-center">
                            <p class="fw-bold mb-0">블루보틀 텀블러 (500ml)</p>
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
            <div class="col" style="height: 580px;">
                <a href="../products/brew_porlex-grinder.jsp" class="text-decoration-none text-reset">
                    <div class="card my_card h-100 position-relative overflow-hidden">
                        <div class="image-wrapper">
                            <img src="./images/Porlex-Mini-Grinder-II-M1-Hero_9279346a-9689-4723-ba64-edda2ebd3900.webp" class="card-img-top base-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                            <img src="./images/Porlex-Mini-Grinder-II-Hover-M2.webp" class="card-img-top hover-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                        </div>
                        <div class="overlay-text text-center">
                            <p class="fw-bold mb-0">포렉스(Porlex) 미니 그라인더 Ⅱ</p>
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
                <a href="../products/cup-double-wall-thermo-glass-set.jsp" class="text-decoration-none text-reset">
                    <div class="card my_card h-100 position-relative overflow-hidden">
                        <div class="image-wrapper">
                            <img src="./images/Bodum-Double-Wall-Glass-Thermo-Glasses-M1-Hero.webp" class="card-img-top base-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                            <img src="./images/Bodum-Double-Wall-Glass-Thermo-Glasses-Hover.webp" class="card-img-top hover-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
                        </div>
                        <div class="overlay-text text-center">
                            <p class="fw-bold mb-0">더블월 써모 글라스 세트 (각 350ml)</p>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
    <% }else{ %>
    <div class="my_favorite">
        <div class="mb-3 fw-bold" style="font-size: 25px;">검색결과: <%=search %></div>
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <% while(rs.next()){ %>
            	<% System.out.println(rs.getString("name"));System.out.println(rs.getString("path"));System.out.println(rs.getString("img_src1")); %>
	            <div class="col" style="height: 580px;">
	                <a href="<%=rs.getString("path") %>" class="text-decoration-none text-reset">
	                    <div class="card my_card h-100 position-relative overflow-hidden">
	                        <div class="image-wrapper">
	                            <img src="<%=rs.getString("img_src1")%>" class="card-img-top base-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
	                            <img src="<%=rs.getString("img_src2")%>" class="card-img-top hover-img position-absolute top-0 start-0 w-100 h-100 object-fit-cover" alt="...">
	                        </div>
	                        <div class="overlay-text text-center">
	                            <p class="fw-bold mb-0"><%=rs.getString("name") %></p>
	                        </div>
	                    </div>
	                </a>
	            </div>
            <% } %>
        </div>
    </div>
    <% } %>





    
    

















    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
  </body>
</html>