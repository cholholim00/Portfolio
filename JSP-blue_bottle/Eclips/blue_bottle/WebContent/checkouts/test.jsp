<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    int user_idx = Integer.parseInt(request.getParameter("idx"));

    String name = request.getParameter("user_name");
    String post_num = request.getParameter("post_num");
    String addr = request.getParameter("addr");
    String phone = request.getParameter("phone");

    int index = Integer.parseInt(request.getParameter("index"));
    int total_price = Integer.parseInt(request.getParameter("total-price"));
    int vat = (int)(total_price * 0.1);

    String gift_name = request.getParameter("gift-name");
    String gift_quantity = request.getParameter("gift-quantity");
    String gift_price = request.getParameter("gift-price");

    String[] names = new String[index];
    String[] quantities = new String[index];
    String[] prices = new String[index];

    for (int i = 1; i < index; i++) {
        names[i] = request.getParameter("name" + i);
        quantities[i] = request.getParameter("quantity" + i);
        prices[i] = request.getParameter("price" + i);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>info3</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./checkouts.css">
</head>
<body>
<div class="row">
    <div class="col my_right">
        <!-- 사용자 정보 카드 등 UI 부분 생략 -->
    </div>

    <div class="col my_left">
        <div class="row mt-4" style="font-size: 14px;">
            <% for(int i=1; i<index; i++){ %>
                <div class="col-4"><%=names[i] %></div>
                <div class="col-2"><%=quantities[i] %>개</div>
                <div class="col">₩<span><%=prices[i] %></span></div>
                <hr />
            <% } %>
        </div>
        <div class="row mt-5" style="font-size: 14px;">
            <div class="col">소계</div>
            <div class="col">₩<span><%=total_price %></span></div>
        </div>
        <div class="row mt-3" style="font-size: 14px;">
            <div class="col">배송</div>
            <div class="col">₩<span>0</span></div>
        </div>
        <div class="row mt-3 fw-bold" style="font-size: 18px;">
            <div class="col">총계</div>
            <div class="col">₩<span><%=total_price + vat %></span></div>
        </div>
        <div class="mt-2" style="font-size: 14px; color: rgb(102, 102, 102);">
            <span>세금 포함 ₩<span><%=vat %></span></span>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
