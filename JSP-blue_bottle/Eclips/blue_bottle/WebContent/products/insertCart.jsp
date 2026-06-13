<%@page import="cart.cartDAO"%>
<%@page import="cart.cartDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	int user_idx = Integer.parseInt(request.getParameter("idx"));
	int quantity = Integer.parseInt(request.getParameter("quantity"));
	int price = Integer.parseInt(request.getParameter("price"));
	String option = request.getParameter("option");
	String product_idx = request.getParameter("product_idx");
	String img_src = request.getParameter("img_src");
	
	System.out.println(user_idx);
	System.out.println(quantity);
	System.out.println(option);
	System.out.println(product_idx);
	System.out.println(img_src);
	System.out.println(price);
	
	// 1. cart 테이블에 세션으로 받아온 user_idx 삽입 (insert)
	cartDTO cart = new cartDTO();
	cart.setUser_idx(user_idx);
	cart.setQuantity(quantity);
	cart.setPrice(price);
	cart.setOption(option);
	cart.setProduct_idx(product_idx);
	cart.setImg_src(img_src);
	
	// DB 연결
	cartDAO dao = new cartDAO(application);
	
	/* int firstRes = 0;
	
	firstRes = dao.insertCart(cart);
	if(firstRes == 0){
		out.println("<script>alert('카트 담기 간 에러가 발생했습니다1');</script>");
	}
	 */
	// 2. cart 테이블에서 해당 user_idx의 cart_idx 값을 가져오기 (select)
	/* cartDTO productIdx = dao.selectCartIdx(user_idx);
	if(productIdx != null){
		String prod_id = productIdx.getProduct_idx();
		if(prod_id != null){
			out.println("<script>alert('이미 담은 상품입니다.'); history.back();</script>");
		}
	} */
	boolean isDuplicate = dao.hasProductInCart(user_idx, product_idx);
    if (isDuplicate) {
        out.println("<script>alert('이미 담은 상품입니다.'); history.back();</script>");
        dao.close();
    } else {
    	// 3. cart_item 테이블에 상품 삽입 (insert)
    	
    	int thirdRes = 0;
    	thirdRes = dao.insertCartItem(cart);
    	if(thirdRes == 0){
    		out.println("<script>alert('카트 담기 간 에러가 발생했습니다2'); history.back();</script>");
    		dao.close();
    	}else{
    		out.println("<script>alert('상품을 카트에 담았습니다'); history.back();</script>");
    		dao.close();
    	}
    }

	
	

	
%>