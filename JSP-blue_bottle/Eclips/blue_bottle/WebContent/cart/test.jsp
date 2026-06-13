<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
<%
    response.setCharacterEncoding("UTF-8");
    int index = Integer.parseInt(request.getParameter("index"));
    //int total_price = Integer.parseInt(request.getParameter("total-price"));
    String total_price = request.getParameter("total-price");
    
    String gift_name = request.getParameter("gift-name");
    String gift_quantity = request.getParameter("gift-quantity");
    String gift_price = request.getParameter("gift-price");
    
    String[] names = new String[index];
    String[] quantities = new String[index];
    String[] prices = new String[index];

    // hidden input 값 받기
	  for (int i = 1; i < index; i++) {
	      names[i] = request.getParameter("name" + i);
	      quantities[i] = request.getParameter("quantity" + i);
	      prices[i] = request.getParameter("price" + i);
	  }

    // 확인을 위한 출력
    for (int i = 1; i < index; i++) {
        System.out.println("Name: " + names[i] + ", Quantity: " + quantities[i] + ", Price: " + prices[i]);
    }
    System.out.println(total_price);
    
    if(gift_name != null){
    	System.out.println("gift_name: "+gift_name+", gift_quantity: "+gift_quantity+", gift_price: "+gift_price);
    }
%>